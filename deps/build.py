#!/usr/bin/python

"""
This script generates a simple website showing examples and an about page.

The about page is generated from README.md and the examples are a concatenation
of a description markdown file and the examples.

The "julia sources examples" are taken verbatim from the julia source code:
https://github.com/JuliaLang/julia hence the script has to clone or pull the entire
julia source to extract the examples 

In theory it would be cool if this was written in Julia too, however libraries like 
urllib, pygments and jinja2 or their equivalents are not yet available in julia.
"""

import os
import sys
import shutil
import markdown2
import re
import codecs
import grablib

from jinja2 import contextfunction, Markup, FileSystemLoader, Environment
from pygments import highlight
import pygments.lexers as pyg_lexers
from pygments.formatters import HtmlFormatter

THIS_PATH = os.path.dirname(os.path.realpath(__file__))
PROJ_ROOT = os.path.realpath(os.path.join(THIS_PATH, os.pardir))
STATIC_PATH = os.path.join(THIS_PATH, 'static')
WWW_PATH = os.path.join(PROJ_ROOT, 'www')
WWW_STATIC_PATH = os.path.join(WWW_PATH, 'static')
ROOT_URL = 'http://www.scolvin.com/juliabyexample'


def _smart_comments(match):
    """
    replace markdown style links with html "<a href..."
    convert **strong** to html
    """
    comment = match.groups()[0]
    comment = re.sub('\[(.*?)\]\((.*?)\)', r'<a href="\2" target="_blank">\1</a>', comment)
    comment = re.sub('\*\*(.*?)\*\*', r'<strong>\1</strong>', comment)
    return '<span class="c">%s</span>' % comment


def src_file_copy(context, file_name):
    ex_dir = context['example_directory']
    file_path = os.path.join(PROJ_ROOT, ex_dir, file_name)
    new_path = os.path.join(WWW_PATH, ex_dir)
    if not os.path.exists(new_path):
        os.makedirs(new_path)
    shutil.copyfile(file_path, os.path.join(new_path, file_name))
    return ex_dir, file_path


@contextfunction
def code_file(context, file_name, **kwargs):
    ex_dir, file_path = src_file_copy(context, file_name)
    file_text = codecs.open(file_path, encoding='utf-8').read()
    url = '/'.join(s.strip('/') for s in [ex_dir, file_name])
    url = url.replace('/./', '/')
    download_link = ('<a class="download-link" href="%s" title="download %s" data-toggle="tooltip" '
                     'data-placement="bottom">'
                     '<span class="glyphicon glyphicon-cloud-download"></span></a>') % (url, file_name)
    # remove hidden sections
    regex = re.compile('\n*# *<hide>.*# *</hide>', flags=re.M | re.S)
    code = re.sub(regex, '', file_text)
    code = code.strip(' \r\n')
    lexer = pyg_lexers.get_lexer_for_filename(file_name)
    formatter = HtmlFormatter(cssclass='code')  # linenos=True,
    git_url = '%s/%s/%s' % (context['view_root'], context['example_repo_dir'], file_name)
    code = highlight(code, lexer, formatter)
    code = re.sub('<span class="c">(.*?)</span>', _smart_comments, code)
    response = """<a class="git-link" href="%s" data-toggle="tooltip" data-placement="bottom"
    target="_blank" title="go to github"><img src="static/github.png" alt="Github Link"/></a>%s\n%s\n""" % \
               (git_url, download_link, code)
    return Markup(response)


@contextfunction
def src_image(context, file_name, **kwargs):
    ex_dir, file_path = src_file_copy(context, file_name)
    url = '/'.join(s.strip('/') for s in [ex_dir, file_name])
    url = url.replace('/./', '/')
    return '<img class="source-image" src="%s" alt="%s"/>' % (url, file_name)


@contextfunction
def src_iframe(context, file_name, **kwargs):
    ex_dir, file_path = src_file_copy(context, file_name)
    url = '/'.join(s.strip('/') for s in [ex_dir, file_name])
    url = url.replace('/./', '/')
    return '<iframe class="source-iframe" frameborder="0" src="%s">%s</iframe>' % (url, file_name)


class SiteGenerator(object):
    ctx = {}
    tags = []

    def __init__(self, output=None):
        if output:
            self._output = output
        self._env = Environment(loader=FileSystemLoader(THIS_PATH))
        self.delete_www()
        self.generate_page()
        self.generate_statics()

    def _repl_tags(self, match):
        hno, title = match.groups()
        replacements = [(' ', '-'), ('.', '_'), (':', ''), ('&amp;', '')]
        tag_ref = title
        for f, t in replacements:
            tag_ref = tag_ref.replace(f, t)
        for c in ['\-', ':', '\.']:
            tag_ref = re.sub(r'%s%s+' % (c, c), c[-1], tag_ref)
        self.tags.append({'link': '#' + tag_ref, 'name': title})
        return '<h%s id="%s">%s<a href="#%s" class="hlink glyphicon glyphicon-link"></a></h%s>' \
               % (hno, tag_ref, title, tag_ref, hno)

    def generate_page(self):
        example_dir = 'src'
        self.test_for_missing_files(os.path.join(PROJ_ROOT, example_dir))
        template = self._env.get_template('template.jinja')
        ex_env = Environment(loader=FileSystemLoader(PROJ_ROOT))
        ex_env.globals.update(
            code_file=code_file,
            src_image=src_image,
            src_iframe=src_iframe
        )
        ex_template = ex_env.get_template('main_page.md')

        examples = ex_template.render(example_directory=example_dir,
                                      example_repo_dir='src',
                                      view_root='https://github.com/samuelcolvin/JuliaByExample/blob/master')
        examples = markdown2.markdown(examples)
        examples = re.sub('<h([1-6])>(.*?)</h[1-6]>', self._repl_tags, examples, 0, re.I)

        page_text = template.render(examples=examples, tags=self.tags, **self.ctx)
        file_name = 'index.html'
        page_path = os.path.join(WWW_PATH, file_name)
        open(page_path, 'w').write(page_text.encode('utf8'))
        self._output('generated %s' % file_name)

    def test_for_missing_files(self, example_dir):
        desc_text = open(os.path.join(PROJ_ROOT, 'main_page.md')).read()
        quoted_files = set(re.findall("{{ *code_file\( *'(.*?)' *\) *}}", desc_text))
        actual_files = set([fn for fn in os.listdir(example_dir) if
                            fn.endswith('.jl') and fn not in ['addcomments.jl', 'test_examples.jl']])
        non_existent = quoted_files.difference(actual_files)
        if len(non_existent) > 0:
            self._output('*** QUOTED FILES ARE MISSING ***:')
            self._output('    ' + ', '.join(non_existent))
        unquoted = actual_files.difference(quoted_files)
        if len(unquoted) > 0:
            self._output('*** JULIA FILES EXIST WHICH ARE UNQUOTED ***:')
            self._output('    ' + ', '.join(unquoted))

    def generate_statics(self):
        if os.path.exists(STATIC_PATH):
            shutil.copytree(STATIC_PATH, WWW_STATIC_PATH)
            self._output('copied local static files')
        down_success = self.download_libraries()

    def delete_www(self):
        if os.path.exists(WWW_PATH):
            shutil.rmtree(WWW_PATH)
            self._output('deleting existing site: %s' % WWW_PATH)
        os.makedirs(WWW_PATH)

    def generate_pyg_css(self):
        pyg_css = HtmlFormatter().get_style_defs('.code')
        file_path = os.path.join(WWW_STATIC_PATH, 'pygments.css')
        open(file_path, 'w').write(pyg_css.encode('utf8'))

    def download_libraries(self):
        grablib_path = os.path.join(THIS_PATH, 'grablib.json')
        # libs_root has to be set manually so build works with different working directories
        libs_root = os.path.join(PROJ_ROOT, 'www/static/external')
        grablib.grab(grablib_path, libs_root=libs_root)

    def _output(self, msg):
        print msg


def list_examples_by_size(examples_dir='src'):
    path = os.path.join(PROJ_ROOT, examples_dir)
    files = [(os.path.getsize(os.path.join(path, fn)), fn) for fn in os.listdir(path)]
    files.sort()
    print ''.join(['\n\n#### %s\n\n{{ code_file(\'%s\') }} ' % (fn, fn) for _, fn in files if fn.endswith('.jl')])


if __name__ == '__main__':
    if 'j_example_list' in sys.argv:
        list_examples_by_size()
    else:
        SiteGenerator()
        print 'Successfully generated site at %s' % WWW_PATH

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
import json
import urllib2
import shutil
import markdown2
import re
import codecs
import GrabLib

from jinja2 import contextfunction, Markup, FileSystemLoader, Environment
from pygments import highlight
import pygments.lexers as pyg_lexers
from pygments.formatters import HtmlFormatter

THIS_PATH = os.path.dirname(os.path.realpath(__file__))
PROJ_ROOT = os.path.realpath(os.path.join(THIS_PATH, os.pardir))
STATIC_PATH = os.path.join(THIS_PATH, 'static')
WWW_PATH = os.path.join(PROJ_ROOT, 'www')
WWW_STATIC_PATH = os.path.join(WWW_PATH, 'static')
DOWNLOADS_DIR = 'download'
WWW_DOWNLOAD_PATH = os.path.join(WWW_PATH, DOWNLOADS_DIR)
TEMPLATE_PATH = os.path.join(THIS_PATH, 'templates')
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


@contextfunction
def code_file(context, file_name, **extra_context):
    ex_dir = context['example_directory']
    file_path = os.path.realpath(os.path.join(PROJ_ROOT, ex_dir, file_name))
    file_text = codecs.open(file_path, encoding='utf-8').read()
    download_link = ''
    if True:
        path = os.path.join(WWW_DOWNLOAD_PATH, ex_dir)
        if not os.path.exists(path):
            os.makedirs(path)
        # shutil.copyfile(file_path, os.path.join(path, file_name))
        url = '/'.join(s.strip('/') for s in [DOWNLOADS_DIR, ex_dir, file_name])
        url = url.replace('/./', '/')
        download_link = """<a class="download-link" href="%s" title="download %s" data-toggle="tooltip" data-placement="bottom">
        <span class="glyphicon glyphicon-cloud-download"></span></a>""" % (url, file_name)
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
def source_image(context, file_name, **extra_context):
    ex_dir = context['example_directory']
    file_path = os.path.realpath(os.path.join(PROJ_ROOT, ex_dir, file_name))
    path = os.path.join(WWW_DOWNLOAD_PATH, ex_dir)
    if not os.path.exists(path):
        os.makedirs(path)
    # shutil.copyfile(file_path, os.path.join(path, file_name))
    url = '/'.join(s.strip('/') for s in [DOWNLOADS_DIR, ex_dir, file_name])
    url = url.replace('/./', '/')
    return '<img class="source-image" src="%s" alt="%s"/>' % (url, file_name)


class SiteGenerator(object):
    ctx = {}
    tags = []

    def __init__(self, output=None):
        if output:
            self._output = output
        self._env = Environment(loader=FileSystemLoader(TEMPLATE_PATH))
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
        example_dir = os.path.join(PROJ_ROOT, 'common_usage')
        self.test_for_missing_files(example_dir)
        template = self._env.get_template('template.jinja')
        ex_env = Environment(loader=FileSystemLoader(PROJ_ROOT))
        ex_env.globals.update(
            code_file=code_file,
            source_image=source_image
        )
        ex_template = ex_env.get_template('common_usage.md')

        examples = ex_template.render(example_directory=example_dir,
                                      example_repo_dir='common_usage',
                                      view_root='https://github.com/samuelcolvin/JuliaByExample/blob/master')
        examples = markdown2.markdown(examples)
        examples = re.sub('<h([1-6])>(.*?)</h[1-6]>', self._repl_tags, examples, 0, re.I)

        page_text = template.render(examples=examples, tags=self.tags, **self.ctx)
        file_name = 'index.html'
        page_path = os.path.join(WWW_PATH, file_name)
        open(page_path, 'w').write(page_text.encode('utf8'))
        self._output('generated %s' % file_name)

    def test_for_missing_files(self, example_dir):
        desc_text = open(os.path.join(PROJ_ROOT, 'common_usage.md')).read()
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
        libs_json_path = os.path.join(THIS_PATH, 'libraries.json')
        GrabLib.process_file(libs_json_path)

    def _output(self, msg):
        print msg


def list_examples_by_size(examples_dir='repo_julia_source/examples'):
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

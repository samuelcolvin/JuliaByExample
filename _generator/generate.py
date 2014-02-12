#!/usr/bin/python

import json, os, urllib2, jinja2, shutil, markdown2, sys, re
from copy import copy
from jinja2 import contextfunction
from pygments import highlight
import pygments.lexers as pyg_lexers
from pygments.formatters import HtmlFormatter

THIS_PATH = os.path.dirname(os.path.realpath(__file__))
PROJ_ROOT = os.path.realpath(os.path.join(THIS_PATH, os.pardir))
STATIC_PATH = os.path.join(THIS_PATH, 'static')
WWW_PATH = os.path.join(PROJ_ROOT, 'www')
WWW_STATIC_PATH = os.path.join(WWW_PATH, 'static')
TEMPLATE_PATH = os.path.join(THIS_PATH, 'templates')
PAGES = {
  'Common Usage': {
    'page': 'index',
    'source': 'common_usage'
  },
  'Source Examples': {
    'page': 'julia_source',
    'source': 'julia_source_examples'
  }
}

BASIC_CONTEXT = {
'title': 'Julia By Example',
'author': 'Samuel Colvin',
'description': 'Examples of Common tasks in Julia (Julia Lang)',
'source_url': 'https://github.com/samuelcolvin/sentiment',
'julia_url': 'http://www.julialang.org',
'root_url': 'index.html',
}

@contextfunction
def code_file(context, file_name, **extra_context):
    file_path = os.path.join(context['example_directory'], file_name)
    file_text = open(file_path, 'r').read()
    lexer = pyg_lexers.get_lexer_for_filename(file_name)
    formatter = HtmlFormatter(cssclass='code')#linenos=True, 
    return highlight(file_text, lexer, formatter)

class SiteGenerator(object):
    def __init__(self, output = None):
        self._env = jinja2.Environment(loader= jinja2.FileSystemLoader(TEMPLATE_PATH))
        if output:
            self._output = output
        self.delete_www()
        self.base_context()
        for info in PAGES.values():
            self.generate_page(info)
        self.generate_statics()
        
    def base_context(self):
        ex_pages = []
        for title, info in PAGES.items():
            ex_pages.append({'url':info['page'] + '.html', 'title': title})
        self.context = BASIC_CONTEXT
        self.context['example_pages'] = ex_pages
        info_file = os.path.join(PROJ_ROOT, 'intro.md')
        intro = open(info_file, 'r').read()
        self.context['intro'] = markdown2.markdown(intro)
    
    def generate_page(self, info):
        template = 'examples.template.html'
        self._template = self._env.get_template(template)
        example_dir = os.path.join(PROJ_ROOT, info['source'])
        ex_env = jinja2.Environment(loader= jinja2.FileSystemLoader(example_dir))
        ex_env.globals['code_file'] = code_file
        ex_template = ex_env.get_template('description.md')
        
        description = ex_template.render(example_directory = example_dir)
        description = markdown2.markdown(description)
        tagno = 0
        while re.search('<[hH][123456]>', description):
            tagno += 1
            description = re.sub('<([hH])([123456])>', r'<\1\2 id="tag%d">' % tagno, description, count=1)
        tags = []
        for g in re.finditer('<[hH][123456] id="(.*?)">(.*?)</[hH]', description):
            parts = g.groups()
            tags.append({'link': '#' + parts[0], 'name': parts[1]})
        
        new_context = copy(self.context)
        new_context['examples'] = description
        new_context['page'] = '%s.html' % info['page']
        new_context['tags'] = tags
        page_text = self._template.render(**new_context)
        page_path = os.path.join(WWW_PATH, '%s.html' % info['page'])
        open(page_path, 'w').write(page_text)
        fn2 = page_path
        if len(fn2) > 40:
            fn2 = '...%s' % fn2[-37:]
        self._output('generated html file "%s" from page: %s, using template: %s' % (fn2, info['page'], template))
    
    def generate_statics(self):
        if os.path.exists(STATIC_PATH):
            shutil.copytree(STATIC_PATH, WWW_STATIC_PATH)
            self._output('copied static files')
        down_success = self.download_libraries()
        if not down_success:
            raise Exception('Error downloading libraries')
        self.generate_pyg_css()
        
    def delete_www(self):
        if os.path.exists(WWW_PATH):
            shutil.rmtree(WWW_PATH)
            self._output('deleting existing site: %s' % WWW_PATH)
        os.makedirs(WWW_PATH)
        
    def generate_pyg_css(self):
        pyg_css = HtmlFormatter().get_style_defs('.code')
        file_path = os.path.join(WWW_STATIC_PATH, 'pygments.css')
        open(file_path, 'w').write(pyg_css)

    def download_libraries(self):
        libs_json_path = os.path.join(THIS_PATH, 'libraries.json')
        url_files = json.load(open(libs_json_path, 'r'))
        downloaded = 0
        ignored = 0
        for url, path in url_files.items():
            #self._output('DOWNLOADING: %s\n             --> %s...' % (url, path))
            dest = os.path.join(WWW_STATIC_PATH, 'external', path)
            if os.path.exists(dest):
                #self._output('file already exists at ./%s' % path)
                #self._output('*** IGNORING THIS DOWNLOAD ***\n')
                ignored += 1
                continue
            dest_dir = os.path.dirname(dest)
            if not os.path.exists(dest_dir):
                self._output('     mkdir: %s' % dest_dir)
                os.makedirs(dest_dir)
            try:
                response = urllib2.urlopen(url)
                content = response.read()
            except Exception, e:
                self._output('\nURL: %s\nProblem occured during download: %r' % (url, e))
                self._output('*** ABORTING ***')
                return False
            open(dest, 'w').write(content)
            downloaded += 1
            #self._output('Successfully downloaded %s\n' % os.path.basename(path))
        
        self._output('library download finish: %d files downloaded, %d existing and ignored' % (downloaded, ignored))
        return True

    def _output(self, msg):
        print msg

def list_examples_by_size(examples_dir = 'julia_source_examples'):
    path = os.path.join(PROJ_ROOT, examples_dir)
    files = [(os.path.getsize(os.path.join(path, fn)), fn) for fn in os.listdir(path)]
    files.sort()
    print ''. join(['\n\n#### %s\n\n{{ code_file(\'%s\') }} ' % (fn, fn) for _, fn in files if fn.endswith('.jl')])

if __name__ == '__main__':
    SiteGenerator()
    print 'Successfully generated site at %s' % WWW_PATH
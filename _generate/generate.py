#!/usr/bin/python

import json, os, urllib2, jinja2, shutil, markdown2, sys, re, git
from copy import copy
from jinja2 import contextfunction, Markup
from pygments import highlight
import pygments.lexers as pyg_lexers
from pygments.formatters import HtmlFormatter

THIS_PATH = os.path.dirname(os.path.realpath(__file__))
PROJ_ROOT = os.path.realpath(os.path.join(THIS_PATH, os.pardir))
STATIC_PATH = os.path.join(THIS_PATH, 'static')
WWW_PATH = os.path.join(PROJ_ROOT, 'www')
WWW_STATIC_PATH = os.path.join(WWW_PATH, 'static')
TEMPLATE_PATH = os.path.join(THIS_PATH, 'templates')

BASIC_CONTEXT = {
'title': 'Julia By Example',
'author': 'Samuel Colvin',
'description': 'Examples of Common tasks in Julia (Julia Lang)',
'source_url': 'https://github.com/samuelcolvin/JuliaByExample',
'julia_url': 'http://www.julialang.org',
'root_url': 'index.html',
}

@contextfunction
def code_file(context, file_name, **extra_context):
    ex_dir = context['example_directory']
    file_path = os.path.join(PROJ_ROOT, ex_dir, file_name)
    file_text = open(file_path, 'r').read()
    lexer = pyg_lexers.get_lexer_for_filename(file_name)
    formatter = HtmlFormatter(cssclass='code')#linenos=True,
    git_url = '%s/%s/%s' % (context['view_root'], context['example_repo_dir'], file_name)
    response = '<a class="git-link" href="%s" target="_blank">View on GitHub</a>\n%s\n' % \
        (git_url, highlight(file_text, lexer, formatter))
    return Markup(response)

class SiteGenerator(object):
    def __init__(self, output = None):
        self._env = jinja2.Environment(loader= jinja2.FileSystemLoader(TEMPLATE_PATH))
        if output:
            self._output = output
        self.delete_www()
        repos_json = os.path.join(PROJ_ROOT, 'repos.json')
        repos = json.load(open(repos_json, 'r'))
        self.get_repos(repos)
        for repo in repos:
            self.generate_page(repo)
        self.generate_statics()
        
    def get_repos(self, repos):
        ex_pages = []
        self._output('UPDATING REPOS:')
        for repo in repos:
            repos_path = os.path.join(PROJ_ROOT, repo['directory'])
            if os.path.exists(repos_path):
                self._output(git.cmd.Git(repos_path).pull())
            else:
                git.Git().clone(repo['url'], repos_path)
            ex_pages.append({'url':repo['page_name'] + '.html', 'title': repo['title']})
        self.context = BASIC_CONTEXT
        self.context['example_pages'] = ex_pages
        info_file = os.path.join(PROJ_ROOT, 'intro.md')
        intro = open(info_file, 'r').read()
        self.context['intro'] = markdown2.markdown(intro)
    
    def generate_page(self, repo):
        template = 'examples.template.html'
        self._template = self._env.get_template(template)
        example_dir = os.path.join(repo['directory'], repo['example_sub_dir'])
        ex_env = jinja2.Environment(loader= jinja2.FileSystemLoader(PROJ_ROOT))
        ex_env.globals['code_file'] = code_file
        ex_template = ex_env.get_template(repo['description'])
        
        examples = ex_template.render(example_directory = example_dir,
                                      example_repo_dir =  repo['example_sub_dir'],
                                      view_root = repo['view_root'])
        examples = markdown2.markdown(examples)
        tagno = 0
        while re.search('<[hH][123456]>', examples):
            tagno += 1
            examples = re.sub('<([hH])([123456])>', r'<\1\2 id="tag%d">' % tagno, examples, count=1)
        tags = []
        for g in re.finditer('<[hH][123456] id="(.*?)">(.*?)</[hH]', examples):
            parts = g.groups()
            tags.append({'link': '#' + parts[0], 'name': parts[1]})
        
        new_context = copy(self.context)
        new_context['examples'] = examples
        new_context['page'] = '%s.html' % repo['page_name']
        new_context['tags'] = tags
        page_text = self._template.render(**new_context)
        page_path = os.path.join(WWW_PATH, '%s.html' % repo['page_name'])
        open(page_path, 'w').write(page_text)
        fn2 = page_path
        if len(fn2) > 40:
            fn2 = '...%s' % fn2[-37:]
        self._output('generated html file "%s" from page: %s, using template: %s' % (fn2, repo['page_name'], template))
    
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
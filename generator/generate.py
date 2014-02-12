#!/usr/bin/python

import json, os, urllib2, jinja2, shutil, markdown2
from copy import copy

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
'source_url': 'https://github.com/samuelcolvin/sentiment',
'julia_url': 'http://www.julialang.org',
'root_url': 'index.html',
}

class SiteGenerator(object):
    def __init__(self, output = None):
        self._env = jinja2.Environment(loader= jinja2.FileSystemLoader(TEMPLATE_PATH))
        if output:
            self._output = output
        self.delete_www()
        pages_file = os.path.join(PROJ_ROOT, 'pages.json')
        pages = json.load(open(pages_file, 'r'))
        self.base_context(pages)
        for info in pages.values():
            self.generate_page(info)
        self.move_statics()
        
    def base_context(self, pages):
        ex_pages = []
        for title, info in pages.items():
            ex_pages.append({'url':info['page'] + '.html', 'title': title})
        self.context = BASIC_CONTEXT
        self.context['example_pages'] = ex_pages
        info_file = os.path.join(PROJ_ROOT, 'intro.md')
        intro = open(info_file, 'r').read()
        self.context['intro'] = markdown2.markdown(intro)
    
    def generate_page(self, info):
        template = 'examples.template.html'
        self._template = self._env.get_template(template)
        descrip_file = os.path.join(PROJ_ROOT, info['source'], 'description.md')
        description = open(descrip_file, 'r').read()
        new_context = copy(self.context)
        new_context['examples'] = markdown2.markdown(description)
        new_context['page'] = '%s.html' % info['page']
        page_text = self._template.render(**new_context)
        page_path = os.path.join(WWW_PATH, '%s.html' % info['page'])
        open(page_path, 'w').write(page_text)
        fn2 = page_path
        if len(fn2) > 40:
            fn2 = '...%s' % fn2[-37:]
        self._output('generated html file "%s" from page: %s, using template: %s' % (fn2, info['page'], template))
    
#     def generate_page(self, page):
#         context = {}
#         for var, item in page['context'].items():
#             context[var] = item['value']
#             if item['type'] == 'markdown':
#                 context[var] = markdown2.markdown(item['value'])
#         r = tr.RenderTemplate(page['template'])
#         content = r.render(context)
#         fn = os.path.join(WWW_PATH, '%s.html' % page['name'])
#         open(fn, 'w').write(content)
#         os.chmod(fn, 0666)
#         fn2 = fn
#         if len(fn2) > 40:
#             fn2 = '...%s' % fn2[-37:]
#         self._output('generated html file "%s" from page: %s, using template: %s' % (fn2, page['name'], page['template']))
        
    def move_statics(self):
        if os.path.exists(STATIC_PATH):
            shutil.copytree(STATIC_PATH, WWW_STATIC_PATH)
            self._output('copied static files')
        down_success = self.download_libraries()
        if not down_success:
            raise Exception('Error downloading libraries')
        
    def delete_www(self):
        if os.path.exists(WWW_PATH):
            shutil.rmtree(WWW_PATH)
            self._output('deleting existing site: %s' % WWW_PATH)
        os.makedirs(WWW_PATH)


    def download_libraries(self):
        libs_json_path = 'libraries.json'
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

if __name__ == '__main__':
    SiteGenerator()
    print 'Successfully generated site at %s' % WWW_PATH
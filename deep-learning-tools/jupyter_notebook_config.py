# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '127.0.0.1'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.base_url = '/'
c.NotebookApp.trust_xheaders = True
c.NotebookApp.tornado_settings = {'static_url_prefix': '/static/'}
c.NotebookApp.notebook_dir = '/data/'
c.NotebookApp.allow_origin = '*'
c.NotebookApp.token = ''
c.NotebookApp.password = ''

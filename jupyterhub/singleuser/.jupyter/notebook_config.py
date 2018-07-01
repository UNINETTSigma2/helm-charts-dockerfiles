# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.quit_button = False
c.NotebookApp.port = 8888
c.NotebookApp.base_url = '/'
c.NotebookApp.trust_xheaders = True
c.NotebookApp.tornado_settings = {'static_url_prefix': '/static/'}
c.NotebookApp.notebook_dir = '/home/notebook'
c.NotebookApp.allow_origin = '*'

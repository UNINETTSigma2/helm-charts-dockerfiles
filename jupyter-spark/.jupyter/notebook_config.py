# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.ServerApp.ip = '*'
c.ServerApp.open_browser = False
c.ServerApp.quit_button = False
c.ServerApp.port = 8888
c.ServerApp.base_url = '/'
c.ServerApp.trust_xheaders = True
c.ServerApp.tornado_settings = {'static_url_prefix': '/static/'}
c.ServerApp.root_dir = '/home/notebook'
c.ServerApp.allow_origin = '*'
c.ServerApp.log_level = 'DEBUG'
c.ServerApp.allow_remote_access = True
# Run all nodes interactively
c.InteractiveShell.ast_node_interactivity = "all"
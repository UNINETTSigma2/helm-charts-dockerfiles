import os
# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# ServerApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.ServerApp.ip = '*'
c.ServerApp.quit_button = False
c.ServerApp.port = 8888
#c.ServerApp.root_dir = os.environ['HOME']
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True
c.ServerApp.token = ''
c.ServerApp.password = ''
# Run all nodes interactively
c.InteractiveShell.ast_node_interactivity = "all"

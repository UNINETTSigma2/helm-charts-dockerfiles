import os
# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '*'
c.NotebookApp.quit_button = False
c.NotebookApp.port = 8888
c.NotebookApp.notebook_dir = os.environ['HOME']
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_remote_access = True
c.NotebookApp.token = ''
c.NotebookApp.password = ''
# Run all nodes interactively
c.InteractiveShell.ast_node_interactivity = "all"

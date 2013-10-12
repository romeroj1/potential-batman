from fabric.api import *

@task
def rebuildwinrepo():
    '''Rebuilds the WIN repo for master and minions'''
    run('salt-run winrepo.genrepo')
    run("salt '*' pkg.refresh_db")
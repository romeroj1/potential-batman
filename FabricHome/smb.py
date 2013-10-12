from fabric.api import *

@task
def installsmb():
    '''Installs Samba'''
    run('yum -y install samba*')
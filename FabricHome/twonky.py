from fabric.api import *
from fabric.colors import *
import datetime


@task
def install():
    '''
    Installs twonky
    Twonky has dependencies on libgcc.i686 and glibc.i686 so make sure these are installed before starting server
    '''
    
@task
def restart():
    '''
    Restarts twonky server by using /etc/init.d/twonkyserver
    '''
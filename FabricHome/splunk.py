from fabric.api import *
from fabric.colors import *
import datetime


@task
def splunk_check():
    """
    Checks if splunk has been installed and is running
    """
    output['stdout'] = False
    output['running'] = False
    output['status'] = False
    output['warnings'] = False
    output['user'] = False
    output['stderr'] = False
    # print(output)
    # print(env.hosts)
    out = sudo('ls /apps/')
    if "splunkforwarder" in out:
        print(green(env.host + " Splunk is installed"))
    else:
        print(red(env.host + " Splunk is not installed"))

@task
def install(type=None):
    """
    Installs splunk
    """
    if type == None:
        print "Please enter a valid splunk software to upload, either F for full or UF for universal forwarder"
        return
    strtype = str.lower(type)        
    prepare(strtype)
    if strtype == "uf":        
        fwd()
    elif strtype == "f":
        full()
        
@task    
def prepare(type=None):
    """
    Uploads splunk installation files to servers.
    """
    if type == None:
        print "Please enter a valid splunk software to upload, either F for full or UF for universal forwarder"
        return
    strpath = '/home/johann/Downloads/'
    if type.lower() == "f":
        put(strpath + 'splunk-6.0.1-189883-linux-2.6-x86_64.rpm', '~/splunk-6.0.1-189883-linux-2.6-x86_64.rpm', mode=0755)        
    elif type.lower() == "uf":
        put(strpath + 'splunkforwarder-5.0-140868-linux-2.6-x86_64.rpm', '~/splunkforwarder-5.0-140868-linux-2.6-x86_64.rpm', mode=0755)        
        
def fwd():
    """
    Install splunk forwarder.
    """    
    run('rpm -i --prefix=/apps splunkforwarder-5.0-140868-linux-2.6-x86_64.rpm')
    run('/apps/splunkforwarder/bin/splunk start --accept-license')
    run('/apps/splunkforwarder/bin/splunk enable boot-start')    
    run('/apps/splunkforwarder/bin/splunk add forward-server 10.0.0.99:9997 -auth admin:changeme')        
    run('/apps/splunkforwarder/bin/splunk add monitor /var/log')
    set_splunk_perms()
    sudo('/apps/splunkforwarder/bin/splunk restart')
    remove_remote_file('~/splunkforwarder*')
    
@task    
def set_splunk_perms():
    sudo('chown -R splunk:splunk /apps/splunk*')
    sudo('chmod -R 777 /apps/splunk*')
    
    
def remove_remote_file(file_spec):
    """
    This will remove the specified file only if exists on remote system.
    """
    run('if [ -f ' + file_spec + ' ]; then rm -f ' + file_spec + '; fi')

      
def full():
    """
    Plain vanilla install for splunk
    """    
    run('rpm -i --prefix=/apps splunk-6.0.1-189883-linux-2.6-x86_64.rpm')
    run('/apps/splunk/bin/splunk start --accept-license')
    run('/apps/splunk/bin/splunk enable boot-start')    

@task
def deploy_jrapp(env=None):
    """
    Deploys the sc3 management application for splunk
    """
    
    if env == 'None':
        print('Enter a valid environment to deploy the tool to')
        return

    local('tar cvfz jrlocal.tar.gz jrlocal/')
    put('jrlocal.tar.gz','/tmp/jrlocal.tar.gz', use_sudo=True, mode=0755)
    stop('f')
    with cd('/apps/splunk/etc/apps/'):        
        sudo('tar xvf /tmp/jrlocal.tar.gz')
        local('rm -f jrlocal.tar.gz')

    #with cd('/apps/splunk/etc/apps/sc3mgmt/default/'):
     #   if env == 'p':
      #      sudo('mv savedsearches.conf.prod savedsearches.conf')
       # elif env == 's':
        #    sudo('mv savedsearches.conf.st savedsearches.conf')
        set_splunk_perms()
        start('f')

@task
def restart(type=None):
    '''Restarts the splunk daemon'''
    strtype = str.lower(type)
    if strtype == 'uf':        
        strpath = '/apps/splunkforwarder/bin/'
    elif strtype == 'f':
        strpath = '/apps/splunk/bin/'
        
    sudo(strpath + 'splunk restart')

@task
def start(type):
    '''Starts splunk'''
    
    if type == 'f':
        sudo('/apps/splunk/bin/splunk start')
    elif type == 'uf':
        sudo('/apps/splunkforwarder/bin/splunk start')
        
@task
def stop(type):
    '''
    Starts splunk
    '''
    
    if type == 'f':
        sudo('/apps/splunk/bin/splunk stop')
    elif type == 'uf':
        sudo('/apps/splunkforwarder/bin/splunk stop')

@task
def deploysvr_reload():
    '''
    Use to reload deployment server after adding new apps
    '''
    sudo('/apps/splunk/bin/splunk reload deploy-server')
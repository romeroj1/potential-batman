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
    strpath = '/home/johann/workspace/mixcode/fabric/'
    if type.lower() == "f":
        put(strpath + 'splunk-5.0-140868-linux-2.6-x86_64.rpm', '~/splunk-5.0-140868-linux-2.6-x86_64.rpm', mode=0755)        
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
    run('rpm -i --prefix=/apps splunk-5.0-140868-linux-2.6-x86_64.rpm')
    run('/apps/splunk/bin/splunk start --accept-license')
    run('/apps/splunk/bin/splunk enable boot-start')    
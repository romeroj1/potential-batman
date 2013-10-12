from fabric.api import *

@task
def deploykeys():
    '''Deploys keys for root'''
    
    
@task
def deployuserkeys():
    '''deploys user keys'''
    
    out = run('ls -a ~/')
    if not ('.ssh' in out):
        run('mkdir ~/.ssh/')
    put('/home/johann/.ssh/authorized_keys', '~/.ssh/authorize_keys', mode=0700)
    
@task
def update():
    '''Runs yum update'''
    run('yum -y update')
    
@task
def kernelupdate():
    '''Updates Kernel'''
    run('yum -y update kernel')
    
@task
def basepkgs():
    '''
    Installs base pkgs that might be needed for different functions. Will work on both server or desktop
    Meant for centos
    '''
    run('yum -y install unrar p7zip p7zip-plugins nfs-utils python-pip python2-devel telnet dd_rescue' +
        ' kernel-devel kernel-headers dkms gcc gcc-c++ glibc.i686 libgcc.i686 openssh-clients')
    
@task
def postinstall():
    '''Runs basic updates after base installation'''
    update()
    kernelupdate()
    basepkgs()
    
@task    
def install_sublime():
    '''
    This deploys the sublime text editor and creates a desktop icon for it.
    Applies to Fedora only, not sure RedHat.
    '''
    strPath= 'SublimeText2.0.1x64.tar.bz2'
    local('sudo tar jxvf /home/johann/Downloads/%s' % strPath + ' -C /apps/') 
    local('sudo mv /apps/Sublime\ Text\ 2 /apps/sublime')
    local('sudo cp sublime.desktop /usr/share/applications/')
    
@task
def add_master_users():
    '''Adds master uers'''
    strpwd = raw_input('') #Enter password here 
    run('useradd johann -G wheel -p %s' % strpwd)
    
@task
def createrepo():
    '''Creates an RPM Repo'''
    lstfolders = ['SRPMs', 'i386', 'x86_64']
    strpath = '/apps/myrepo/el/6/products/'
    run('yum -y install createrepo httpd')
    
    for d in lstfolders:
        try:
            folder = strpath + d
            run('mkdir -p ' + folder)                           
            print 'Completed creating folder ' + folder
        except OSError as e:
            print 'Error ({0}) : {1}'.format(e.errno, e.strerror)
            
@task
def rpmmakesetup():
    '''Sets up Dev environment to make RPMs'''
    local('sudo yum -y install @development-tools fedora-packager')
    local('rpmdev-setuptree')
    
@task
def buildrpm():
    '''Builds an RPM'''
    
from fabric.api import *
import os.path


@task
def createnewvm(name=None,os=None,hdname=None,hdsize=None,port=None,device=None):
    '''Creates a new VM based on given choices'''
    if name == None or os == None or hdname == None or hdsize == None or port == None or device== None:
        print('pls enter all required items to be able to create a VM')
        return
    createvm(name,os)
    modifyvm(name)
    createhd(name,hdname,hdsize)
    createstoragecontroller(name)
    attachcontroller(name)
    attachhd(name,hdname,port,device)
    
@task
def startvm(name=None):
    '''Starts a virtual machine. need to pass the name of the VM'''
    if name == None:
        print('pls enter a valid virtual machine name to modify')
        return
    run('VBoxManage startvm "' + name + '" --type headless')

@task
def stopvm(name=None):
    '''Stops a vrtual Machine, need to pass the name of the VM'''
    if name == None:
        print('pls enter a valid virtual machine name to modify')
        return
    run('VBoxManage controlvm "' + name + '" poweroff')

@task
def restartvm(name=None):
    '''Restarts a vrtual Machine, need to pass the name of the VM'''
    if name == None:
        print('pls enter a valid virtual machine name')
        return
    run('VBoxManage controlvm "' + name + '" reset')
        
@task
def showvminfo(name=None):
    run('VBoxManage showvminfo "' + name + '"')
    
@task
def listostypes():
    '''List available OS types in vbox'''
    run('VBoxManage list ostypes')
    #ostype Windows8_64 or RedHat_64

@task    
def createvm(name=None,os=None):
    '''Creates a vm container'''
    out = run('ls -a /apps')
    if not ('VMs' in out):
        run('mkdir -p /apps/VMs')
    run('VBoxManage createvm --name "' + name + '" --ostype ' + os + ' --basefolder "/apps/VMs/" --register') 
    
    
@task
def modifyvm(name=None):
    '''Modifys an existing VM'''
    if name == None:
        print('pls enter a valid virtual machine name to modify')
        return
    run('VBoxManage modifyvm "' + name + '" --memory 4096 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 em1')
    
@task
def createhd(name=None,hdname=None,size=None):
    '''Creates a virtual hard drive'''
    if name == None:
        print('pls enter a valid virtual machine name to modify')
        return
    strhdname = hdname + '.vdi'
    run('VBoxManage createhd --filename "/apps/VMs/' + name + '/' + strhdname + '" --size '  + size ) 
    #Size in MB example 102400 = 100GB
    
@task
def createstoragecontroller(name=None):
    '''Creates the storage controller for the HD and DVD'''
    run('VBoxManage storagectl "' + name + '" --name "IDE Controller" --add ide --controller PIIX4') 
    run('VBoxManage storagectl "' + name + '" --name "SATA Controller" --add sata --controller IntelAHCI --sataportcount 5')
    
@task
def attachcontroller(name=None):
    '''Attaches Controler'''
    if name == None:
        print('pls enter a valid virtual machine name to modify')
        return
    #isopath = '/root/en_windows_8_enterprise_x64_dvd_917522.iso'
    #isopath = '/root/CentOS-6.4-x86_64-bin-DVD1.iso'
    isopath = '/root/en_windows_server_2012_x64_dvd_915478.iso'
    run('VBoxManage storageattach "' + name + '" --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium "' + isopath + '"')
    
@task
def attachhd(name=None,hdname=None,port=None,device=None):
    '''Attaches a hard drive to a virtual Machine'''
    if name == None or hdname == None:
        print('pls enter a valid virtual machine name to modify')
        return
    basedir = '/apps/VMs/'
    strvmname = name
    strhdname = '/' + hdname + ".vdi"
    run('VBoxManage storageattach "' + strvmname + '" --storagectl "SATA Controller" --port ' + port + ' --device ' + device + ' --type hdd --medium "' + basedir + strvmname + strhdname + '"')
    
@task
def ip(name=None,type=None):
    '''Executes ipconfig on guest machine'''
    if name == None or type == None:
        print('pls enter a valid virtual machine name')
        return
    if type == 'w':
        cmd = "c:\\windows\\system32\\ipconfig.exe"
        #add password later
        run('VBoxManage --nologo guestcontrol "' + name + '" execute --image ' + cmd + ' --username Johann --password "pwd here" --wait-exit --wait-stdout')
    elif type == 'x':
        cmd = raw_input('')
        #add password later
        run('VBoxManage --nologo guestcontrol "' + name + '" execute --image ' + cmd + ' --username root --password "pwd here" --wait-exit --wait-stdout')    
    
    
@task
def ejectdvd(name=None):
    '''Ejects DVD drive'''
    run('VBoxManage storageattach "' + name + '" --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none' )
    
@task
def addportsatacotlr(name=None):
    '''Adds a new port to SATA Controller'''
    if name == None:
        print('pls enter a valid virtual machine name to modify')
        return
    run('VBoxManage storagectl "' + name + '" --name "SATA Controller" --sataportcount 4')
    
@task
def takesnapshot(name=None):
    '''Takes a Snapshot of the Virtual Machine'''
    strname = name
    run('VBoxManage snapshot "' + strname + '" take ' + strname + '.ss02')

@task
def createrawdisk(name=None):
    '''Creates and attaches a physical disk to a virtul guest'''
    strvmdisk = '/apps/VMs/' + name + '/diskraw1.vmdk'
    strrawdisk = '/dev/sdb'
    strname = name
    run('VBoxManage internalcommands createrawvmdk -filename ' + strvmdisk + ' -rawdisk ' + strrawdisk)
    run('VBoxManage storageattach ' + strname + ' --storagectl "SATA Controller" --port 2 --device 0 --type hdd --medium ' + strvmdisk)
    
@task
def autostart(name,case):
    '''
    Enables Auto Start on VM guest
    VBoxManage modifyvm jrms01 --autostart-enabled on or off
    '''
    run('VBoxManage modifyvm ' + name + ' --autostart-enabled ' + case)
    showvminfo(name)
    
@task
def status():
    '''
    Shows status of all vms
    '''
    run('VBoxManage list runningvms')

#!/usr/bin/python
import os
import subprocess
from optparse import OptionParser
import shutil

usage = "usage: splunkinstall.py -f | -a"
mydescription = "splunkinstall.py is intended to aid in the installation of splunk. It could install the server or the agent"

myversion = "splunkinstall.py-0.01"

strsplunkfull = '/apps/temp/splunk-5.0-140868-linux-2.6-x86_64.rpm'
strsplunkfwd = '/home/johann/workspace/mixcode/fabricNG/splunk/splunkforwarder-5.0.3-163460-linux-2.6-x86_64.rpm'
strbasecmd = 'rpm -ivh --prefix=/apps '
strpath = '/apps/splunkforwarder/etc/apps/search/local/'
srcfile = '/home/johann/workspace/mixcode/fabric/ihs8.conf'
dstfile = strpath + 'inputs.conf'

def full():
    '''Installs full version of splunk'''
    strcmd = strbasecmd + strsplunkfull
    subprocess.call(strcmd, shell=True)
    subprocess.call('/apps/splunk/bin/splunk start --accept-license', shell=True)
    subprocess.call('/apps/splunk/bin/splunk enable boot-start', shell=True)
    
def forwarder():
    '''Install splunkforwader'''
    strcmd = strbasecmd + strsplunkfwd
    subprocess.call(strcmd, shell=True)
    try:
        folder = strpath
	os.makedirs(folder)                           
        print 'Completed creating folder ' + folder
    except OSError as e:
        print 'Error ({0}) : {1}'.format(e.errno, e.strerror)
    shutil.copy(srcfile, dstfile)
    subprocess.call('/apps/splunkforwarder/bin/splunk start --accept-license', shell=True)
    subprocess.call('/apps/splunkforwarder/bin/splunk enable boot-start', shell=True)
    subprocess.call('/apps/splunkforwarder/bin/splunk add forward-server SLSPINDEX01.sce.com:9997 -auth admin:changeme', shell=True)
    subprocess.call('/apps/splunkforwarder/bin/splunk add forward-server SLSPINDEX01.sce.com:9997 -auth admin:changeme', shell=True)

def main():
    '''Main module'''
    
    parser = OptionParser(usage,version=myversion,description=mydescription)
    parser.add_option("-f", "--full", help="install splunk server", action="store_true", dest="full")
    parser.add_option("-a", "--forwarder", help="install splunk universal forwarder", action="store_true", dest="agent")

    (options,args) = parser.parse_args()
    
    if options.full and options.agent:
        parser.error("options -f and -a may not be run together.")    
    elif options.full:
        full()
    elif options.agent:
        forwarder()
    else:
        print parser.description + "\n " + parser.usage
                
if __name__ == '__main__':
    main()

#!/usr/bin/python
# Script to control virtual machines hosted in virtualbox.
# Currently use in windows as part of the startup and shutdown scripts to handle VMs
# Author: Johann Romero
# Date: 12/30/2013
# Version: 1.0
# License: MIT http://www.opensource.org/licenses/mit-license.php


import os
import re
import optparse
import glob
import tarfile
import time
import datetime
import ConfigParser
import logging.handlers
from optparse import OptionParser
from sendemail import sendmail
import subprocess


#########################
# Read configuration data
#########################
confpath = os.path.dirname(__file__)
config = ConfigParser.ConfigParser()
config.read(confpath + "/vm.conf")
logSize = config.getint('Config','MaxLogFileSize')
numLogs = config.getint('Config','NumLogs')
logfile = config.get('Config','LogFile')
sectionList = config.sections()
email = config.get('Config', 'SendNotification')
now = datetime.datetime.now().strftime("%m%d%Y%H%M")

##########################
# Setup logging
##########################
# Setup handler
handler = logging.handlers.RotatingFileHandler(logfile, maxBytes=logSize, backupCount=numLogs)
handler.setLevel(logging.INFO)
# Logging Format
formatter = logging.Formatter('%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
handler.setFormatter(formatter)
# create logger
my_logger = logging.getLogger(__name__)
my_logger.setLevel(logging.INFO)
# Add handler to logger
my_logger.addHandler(handler)

strtime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")


def main():
    usage = "usage: %prog [options]"
    parser = optparse.OptionParser(usage)    
    parser.add_option("-s", "--start", action="store_true", dest="startVM", default=False, help="Starts VM")
    parser.add_option("-d", "--down", action="store_true", dest="downVM", default=False, help="Shutsdown VM")
    options, args = parser.parse_args()
 
    
    if options.startVM and options.downVM:
        parser.error('You can not turnon and shutdown commands at the same time. Please choose one or the other.')

    for s in sectionList:
    	if config.has_option(s, "enabled"):
            my_logger.debug('Working on stanza ' + s)
            enabled = config.getboolean(s, "enabled")
            my_logger.debug('Stanza enabled ' + str(enabled))
            
            if enabled:
            	if options.startVM:                 
        			startVirtualServer(config.get(s, "name"))
                
                if options.downVM:
                    downVirtualServer(config.get(s, "name"))


def startVirtualServer(name):
    '''
    Starts virtualBox virtual server 
    Assumes VirtualBox is installed and is part of the environment variables
    '''
    try:
        my_logger.info('Starting Server ' + name)
        strcmd = 'vboxmanage startvm ' + name + ' --type headless'
        my_logger.debug(strcmd) 
        subprocess.call(strcmd, shell=True)
        my_logger.info('Started server ' + name)
    except Exception, e:
        my_logger.info(e)
    
    #sendmail("Started Server", name)
    
def downVirtualServer(name):
    '''
    Shutsdown virtualbox virtual server
    '''     
    try:
        my_logger.info('Shuttind down server ' + name)
        strcmd = 'vboxmanage controlvm ' + name + ' poweroff'
        subprocess.call(strcmd, shell=True)
        my_logger.debug(strcmd)
        my_logger.info('Shutdown server ' + name)
    except Exception, e:
        my_logger.info(e)


if __name__ == "__main__":
    main()
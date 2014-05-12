#!/usr/bin/python
# This script cleans up log files
# Author: Johann Romero
# Date: 04/16/2013
# Update: 11/12/2013.Fix tar compresion. move tar option outside of the for loop
# Update: 12/29/2013. Added logging and for loops to handle multiple paths
# Update: 01/06/2014. Change email to send contents of files to delete based on the list, rather than reading the log file and the sending the outout.
# Version: 1.1
# License: MIT http://www.opensource.org/licenses/mit-license.php
# based on Don Magee's work at http://tacticalcoder.com/blog/2012/01/quick-and-dirty-log-file-cleanup-with-python/

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

#dir_input = r"E:\logs"

#########################
# Read configuration data
#########################
confpath = os.path.dirname(__file__)
config = ConfigParser.ConfigParser()
config.read(confpath + "/purge.conf")
logSize = config.getint('Config','MaxLogFileSize')
numLogs = config.getint('Config','NumLogs')
logfile = config.get('Config','LogFile')
sectionList = config.sections()
email = config.get('Config', 'SendNotification')
now = datetime.datetime.now().strftime("%m%d%Y%H%M")
li = []

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
    parser.add_option("-r", "--remove", action="store_true", dest="removeFiles", default=True, help="Delete original files.")
    parser.add_option("-t", "--tar", action="store_true", dest="tarFiles", default=False, help="Tar all files using bzip2 compression as a default. If --gzip or --no-compression are used then tar will be automatically used.")
    parser.add_option('-g', "--gzip", action="store_true", dest="gzipFiles", default=False, help="Use GZIP compression instead of bzip2")
    parser.add_option("-n", "--no-compression", action="store_true", dest="noCompression", default=False, help="Do not use any compression for tar.")
    parser.add_option("-l", "--list", action="store_true", dest="listFiles", default=True, help="List all files that would be affected. This is the default option.")
    options, args = parser.parse_args()
 
    
    if options.gzipFiles and options.noCompression:
        parser.error('You can not use both gzip compression and no compression. Please choose one or the other.')
 
    if options.listFiles and (options.tarFiles or options.removeFiles):
        options.listFiles = True
 
    # setup compression type
    tarType = "w:gz"
    tarExt = '.tar.gz'
    if options.gzipFiles:
        options.tarFiles = True
        tarType = "w:gz"
        tarExt = '.tar.gz'        
    if options.noCompression:
        options.tarFiles = True
        tarType = "w"
        tarExt = '.tar'    
                                                   
    for s in sectionList:
        if config.has_option(s, "enabled"):
            my_logger.debug('Working on section ' + s)
            enabled = config.getboolean(s, "enabled")
            my_logger.debug('Section enabled ' + str(enabled))
            if enabled:
                my_logger.debug('Section name is ' + config.get(s, "name"))
                for dirname, dirnames, filenames in os.walk(s): 
                    my_logger.debug('Looking for old log files in: %s' % dirname)
                    
                    for d in dirnames:           
                        my_logger.debug('Thinking')
                                    
                    for e in filenames:
                            strFile = os.path.join(dirname, e)
                            my_logger.debug('looking at file ' + strFile)
                            stats = os.stat(strFile)  
                            modDate = time.localtime(stats[8])
                            lastmodDate = time.strftime("%m-%d-%Y", modDate)
                            expDate = get_Filterdate(config.getint(s, "retention"))
                                             
                            if  expDate > lastmodDate:                                             
                                if options.listFiles:
                                    my_logger.debug('The following files will be affected: ')
                                    my_logger.debug(strFile, lastmodDate)
                                    li.append(strFile)                

    if options.tarFiles:                    
        #archive_OldFiles(logFile,lastmodDate,archiveName)
        if not li:
            my_logger.info('File list is empty')                    
        archive_OldFiles(li,tarType,tarExt) 
                
    if options.removeFiles:
        #delete_OldFiles(logFile,expDate)
        if not li:
            my_logger.info('Nothing to delete')                    
        delete_OldFiles(li)

def get_Filterdate(daysolderthan):
    '''
    Returns the date to filter files out on
    '''
    today = datetime.date.today()
    #daysolderthan = int('7')
    DD = datetime.timedelta(days=daysolderthan)
    olderthandate = today - DD
    #padded the day to be a two digit int so that it would match the day digits on file modtime
    day = '%02d' % olderthandate.day
    month = olderthandate.month
    year = olderthandate.year
        
    #filterDate = str(year) + '-' + str(month) + '-' + str(day)
    filterDate = str(month) + '-' + str(day) + '-' + str(year)
    return filterDate 
    
def delete_OldFiles(pList):
    '''
    Executes the actual deletion of the file
    '''     
    try:
        my_logger.info('Starting purge')
        for f in pList:
            my_logger.info('Removing ' + f)
            os.remove(f)  # commented out for testing
        # open and read log file
        #fo = open(logfile, "r")
        #strlogcontent = fo.read()
        
        # added by JR on 1/6/2014
        # Send contents of list
        sendmail("Purge Completed", pList)
        my_logger.info('Purge Completed')
    except Exception, e:
        #my_logger.info('Could not remove ' + f)
        my_logger.info(e)
        
def archive_OldFiles(li,tarType,tarExt):
    '''
    Archives old log files
    '''     
    #create a tar file and open it with gz compression    
    archiveName = '/tmp/logsBackup.' + now + tarExt
    archive = tarfile.open(archiveName, tarType)        
    print '-'*1000
    fileCount = 0       
    try:
        for name in li:            
            my_logger.info('Compressing ' + name)
            fileCount += 1        
            archive.add(name)    
    except OSError:
        my_logger.info('Could not compress ' + name)
    
    archive.close()                    
                        
if __name__ == "__main__":
    main()
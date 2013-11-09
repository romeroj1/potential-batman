#!/usr/bin/python
# This script cleans up log files
# Author: Johann Romero
# Date: 2032-11-08
# Version: 1.0
# License: MIT http://www.opensource.org/licenses/mit-license.php
# based on Don Magee's work at http://tacticalcoder.com/blog/2012/01/quick-and-dirty-log-file-cleanup-with-python/

import os
import re
import optparse
import glob
import tarfile
import time
import datetime

archiveName = '' #Base name for archive
dir_input = r"/tmp/t"
daysolderthan = int('4')

def main():
    usage = "usage: %prog [options]"
    parser = optparse.OptionParser(usage)    
    parser.add_option("-r", "--remove", action="store_true", dest="removeFiles", default=False, help="Delete original files.")
    parser.add_option("-t", "--tar", action="store_true", dest="tarFiles", default=False, help="Tar all files using bzip2 compression as a default. If --gzip or --no-compression are used then tar will be automatically used.")
    parser.add_option('-g', "--gzip", action="store_true", dest="gzipFiles", default=False, help="Use GZIP compression instead of bzip2")
    parser.add_option("-n", "--no-compression", action="store_true", dest="noCompression", default=False, help="Do not use any compression for tar.")
    parser.add_option("-l", "--list", action="store_true", dest="listFiles", default=True, help="List all files that would be affected. This is the default option.")
    options, args = parser.parse_args()
 
    
    if options.gzipFiles and options.noCompression:
        parser.error('You can not use both gzip compression and no compression. Please choose one or the other.')
 
    if options.listFiles and (options.tarFiles or options.removeFiles):
        options.listFiles = False
 
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
    
    today = datetime.date.today()
    DD = datetime.timedelta(days=daysolderthan)
    olderthandate = today - DD
    #padded the day to be a two digit int so that it would match the day digits on file modtime
    day = '%02d' % olderthandate.day
    month = olderthandate.month
    year = olderthandate.year
        
    #filterDate = str(year) + '-' + str(month) + '-' + str(day)
    filterDate = str(month) + '-' + str(day) + '-' + str(year)                
    
    for dirname, dirnames, filenames in os.walk(dir_input):                        
        print 'Looking for old log files in: %s' % dirname
        for e in filenames:
            logFile = os.path.join(dirname, e)
            stats = os.stat(logFile)  
            modDate = time.localtime(stats[8])
            lastmodDate = time.strftime("%m-%d-%Y", modDate)
            #expDate = time.strptime(filterDate, '%m-%d-%Y')
            expDate = filterDate            
            if  expDate == lastmodDate:
                if options.listFiles:
                    print 'The following files will be affected:'
                    print logFile, lastmodDate
 
                if options.tarFiles:                    
                    archive_OldFiles(filterDate,logFile,expDate,tarType,tarExt)
 
                if options.removeFiles:
                    delete_OldFiles(logFile,expDate)
                 
                 
def delete_OldFiles(logFile,expDate):
    '''
    Executes the actual deletion of the file
    '''     
    try:
        print 'Removing', logFile, expDate
        os.remove(logFile)  # commented out for testing
    except OSError:
        print 'Could not remove', logFile

def archive_OldFiles(filterDate,logFile,expDate,tarType,tarExt):
    '''
    Archives old log files
    '''     
    #create a tar file and open it with gz compression                    
    archiveName = 'logsBackup.' + filterDate + tarExt
    archive = tarfile.open(archiveName, tarType)
 
    print '-'*50
    fileCount = 0
       
    try:
        print 'Compressing', logFile, expDate
        fileCount += 1
        archive.add(logFile)
    except OSError:
        print 'Could not compress', logFile
                        
                        
if __name__ == "__main__":
    main()
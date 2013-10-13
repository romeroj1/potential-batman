#!/usr/bin/env python
#PROGRAM: delhiddenfiles.py
#AUTHOR: Johann Romero
#ORIGIN: July 14 2013
#VERSION: 0.1
#LAST UPDATE: 
#
#INSTRUCTIONS: This script is meant to delete hidden folders

import os
import shutil


#dir_input = raw_input('Enter dir: ')
dir_input = r"/apps/nas/public/videos/tv"
win_trace = ['.AppleDouble','.DS_Store','._.DS_Store','Thumbs.db']

files_removed = 0

def main():
    '''
    Main module
    '''
    for dirname, dirnames, filenames in os.walk(dir_input):
        for subdirname in dirnames:
            print os.path.join(dirname, subdirname)        
            
        for e in win_trace:
            if e in dirnames:
                delfolder = os.path.join(dirname, e)                             
                delete(delfolder)
                
        for e in win_trace:
            if e in filenames:
                delfolder = os.path.join(dirname, e)                             
                filedelete(delfolder)
                
                
def delete(path):
    '''
    Deletes folder or files
    '''
    try:
        print "removing '%s'" % path        
        shutil.rmtree(path) 
        #files_removed += 1
        #print files_removed               
    except OSError as e:
        print 'Error deleting folder: {0} \n Error: ({1}) : {2}'.format(e.filename, e.errno, e.strerror)

def filedelete(path):
    '''
    Deletes a file
    '''
    try:
        print "removing '%s'" % path        
        os.remove(path) 
                       
    except OSError as e:
        print 'Error deleting file: {0} \n Error: ({1}) : {2}'.format(e.filename, e.errno, e.strerror)
        
        
if __name__ == '__main__':
    main()
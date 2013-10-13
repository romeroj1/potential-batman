#!/usr/bin/python
#PROGRAM: delfiles.py
#AUTHOR: Johann Romero
#ORIGIN: June 29 2013
#VERSION: 0.0q
#LAST UPDATE: 
#
#INSTRUCTIONS: This script is meant to be use on a Windows system

import os
import shutil
import win32api
import win32con


#dir_input = raw_input('Enter dir: ')
dir_input = r"C:\Users\romeroj1\Desktop\Google Drive"
win_trace = ['.svn']
files_removed = 0

def main():
    '''Main module'''
    for dirname, dirnames, filenames in os.walk(dir_input):
        for subdirname in dirnames:
            print os.path.join(dirname, subdirname)        
            
        for e in win_trace:
            if e in dirnames:
                delfolder = os.path.join(dirname, e)             
                setnormalfile(delfolder)
    
#    for item in os.listdir(dir_input):
#        if os.path.isfile(os.path.join(dir_input, item)):
#            pass
#        else:
#            subdirs.append(os.path.join(dir_input, item))
    #stripjunk(subdirs)
    

def setnormalfile(dirs):
    '''Sets file Read-Only file bit on windows to False or Normal'''
    for dirname,dirnames,filenames in os.walk(dirs):
        for filename in filenames:
            fn = os.path.join(dirname, filename)
            win32api.SetFileAttributes(fn, win32con.FILE_ATTRIBUTE_NORMAL)
        
    delete(dirs)
    
    
def delete(path):
    '''Deletes folder or files'''
    try:
        print "removing '%s'" % path        
        shutil.rmtree(path) 
        #files_removed += 1
        #print files_removed               
    except OSError as e:
         print 'Error deleting folder: {0} \n Error: ({1}) : {2}'.format(e.filename, e.errno, e.strerror)
         
if __name__ == '__main__':
    main()
#! /usr/bin/python
 
''' 
Title:    jrrename.py
Author:   Johann Romero (johann.romero@gmail.com)
Date:     Dec222013
update:   
Info:     Renames files within a specified folder
'''
 
import os
import glob
import shutil

def main():
    '''
    Will rename files in specified path. Change Extension or path if required
    Change doIt flag to do dry run or to actually do work
    '''

    doIt = True
    cnt = 01
    strPath = '/Volumes/Public/videos/tv/Friends/S10/'
    currentFiles = glob.glob(strPath + '*.avi')
    for filename in currentFiles:
        saveName = strPath + 'Friends.S10.E' + str('%02d' % cnt) + '.avi'
        if doIt:
            shutil.move(filename,saveName)
            print "Renaming {0} to {1}".format(filename,saveName)
            cnt +=1
        else:
            print "Would Rename {0} to {1}".format(filename,saveName)
            cnt +=1

if __name__ == "__main__":
    main()
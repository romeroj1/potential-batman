#! /usr/bin/python
import os
import sys
import tempfile
import uuid

ERROR_STR = "Error removing %(path)s, %(error)s "

def createtmpstruct():
    '''Creates a dummy structure so that we can test the backup script'''
    rootdir = ['testbkp', 'testbkp1', 'testbkp2', 'ad', 'cisco', '_internal']
    folderlist = ['db', 'colddb']
    
    for f in rootdir:
        for d in folderlist:
            try:
                folder = '/tmp/db/' + f + '/' + d + '/'
                os.makedirs(folder)                           
                print 'Completed creating folder ' + folder
                makebuckets(folder)
                #makefile(folder)
            except OSError:
                pass

def makebuckets(path):
    '''Creates dummy buckets'''
    
    for i in range(10):
        fn = 'deb_' + str(uuid.uuid4())
        strpath = path + fn
        os.makedirs(strpath)
        print 'Completed creating file ''' + strpath

def makefile(path):
    '''Creates dummy files'''
    
    for i in range(10):
        fn = str('deb_' + uuid.uuid4())
        strpath = path + fn
        file = open(strpath, 'w')
        file.write('Just Dummy data....')
        print 'Completed creating file ''' + strpath
        file.close()
    
    
def rmgeneric(path, __func__):
    
    try:
        __func__(path)
        print 'Removed ', path
    except OSError, (errno, strerror):
        print ERROR_STR % {'path' : path, 'error': strerror}
        
def removeall(path):
    '''Deletes folders and files'''
    if not os.path.isdir(path):
        return
    
    files = os.listdir(path)
    
    for x in files:
        fullpath = os.path.join(path, x)
        if os.path.isfile(fullpath):
            f = os.remove
            rmgeneric(fullpath, f)
        elif os.path.isdir(fullpath):
            removeall(fullpath)
            f = os.rmdir
            rmgeneric(fullpath, f)

if __name__ == '__main__':
    createtmpstruct()
    
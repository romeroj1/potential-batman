#! /usr/bin/python
import os
import sys
import tempfile
import uuid

ERROR_STR = "Error removing %(path)s, %(error)s "

def createtmpstruct():
    '''Creates a dummy structure so that we can test the backup script'''
    rootdir = ['testbkp', 'testbkp1', 'testbkp2']
    folderlist = ['foo', 'bar', 'baz']
    
    for f in rootdir:
        for d in folderlist:
            try:
                folder = '/tmp/' + f + '/' + d + '/'
                os.makedirs(folder)                           
                print 'Completed creating folder ' + folder
                makefile(folder)
            except OSError:
                pass
            
def makefile(path):
    '''Creates dummy files'''
    
    for i in range(10):
        fn = str(uuid.uuid4())
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
    
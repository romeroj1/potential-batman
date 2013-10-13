#!/usr/bin/python
import subprocess


destdir = "/apps/sc3repo/el/6/products/"
lstfolders = ['SRPMS', 'i386', 'x86_64']

def main():
    '''main module'''
    for arch in lstfolders:
        strcmd = 'createrepo ' + destdir + arch
        print 'Executing ' + strcmd
        subprocess.call(strcmd, shell=True)

if __name__ == '__main__':
    main()
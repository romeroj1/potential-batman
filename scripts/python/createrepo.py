#!/usr/bin/python
import subprocess
import os

lstfolders = ['SRPMS', 'i386', 'x86_64']
strpath = '/var/www/html/myrepo/el/6/products/'

def main():
    '''main Module'''
    subprocess.call('yum -y install createrepo httpd', shell=True)
    for d in lstfolders:
        try:
            folder = strpath + d
            os.makedirs(folder)                           
            print 'Completed creating folder ' + folder
        except OSError as e:
            print 'Error ({0}) : {1}'.format(e.errno, e.strerror)

if __name__ == '__main__':
    main()    
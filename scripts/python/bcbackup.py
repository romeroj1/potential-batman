#!/usr/bin/env python

# Script to run beyond compare which in turn backsup important folders

__author__="Johann Romero"  # Based mostly on "warrenstrange" work @ https://blogs.oracle.com/warren/entry/a_python_script_to_encode
__date__ ="$Jun 19, 2013 11:28:09 AM$"

import subprocess
import os.path
from subprocess import Popen
import sendemail

def bcbackup():
    '''
    Executes Beyond Compare
    '''
    
    strbc = os.path.join( "c:\\", "repo", "svn", "bcomp.exe" )
    strbcconfig = os.path.join( "c:\\", "Users", "romeroj1", "Desktop", "sync.config" )        
        
    #print (strbc)
    #print (strbcconfig)
    
    strcmd = strbc+' @'+strbcconfig
    #print (strcmd)    

    if os.path.exists(strbc) and os.path.exists(strbcconfig):
        subprocess.call(strcmd, shell=True)
        print ("i'm done, sending email...")
        sendmail("BC Backup Done","Backup has completed, pls check log files for any errors")
    else:                                        
        print ("skipping this run... Either Beyond Compare is not installed or can't find the config file")
        
if __name__ == "__main__":
    bcbackup()
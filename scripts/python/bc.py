#!/usr/bin/env python

# Script to run beyond compare which in turn backs up important folders

__author__="Johann Romero"  # Based mostly on "warrenstrange" work @ https://blogs.oracle.com/warren/entry/a_python_script_to_encode
__date__ ="$Jun 19, 2013 11:28:09 AM$"

import subprocess
import os.path
import datetime
from subprocess import Popen
from sendemail import sendmail

def bcbackup():
    '''
    Executes Beyond Compare
    '''
    
    strbc = r"e:\apps\bc\Bcompare.exe"
    strbcconfig = r"c:\users\johann\workspace\jrbackup\sync.config"
    strdate = datetime.datetime.now().strftime("%Y-%m-%d")
    strlogpath = r"e:\logs\syncLog" + strdate + ".txt"   
    
    #print (strbc)
    #print (strbcconfig)
    #print strlogpath
    
    strcmd = strbc+' @'+strbcconfig
    print (strcmd)    

    if os.path.exists(strbc) and os.path.exists(strbcconfig):
        subprocess.call(strcmd, shell=True)
        # open and read log file
        fo = open(strlogpath, "r")
        strlogcontent = fo.read()
        #print ("i'm done, sending email...")
        #sendmail("Beyond Compare Backup Done","Backup for NAS has completed, pls check log files for any errors")
    	sendmail("Beyond Compare Backup Done", strlogcontent)
    else:                                        
        print ("skipping this run... Either Beyond Compare is not installed or can't find the config file")
        
if __name__ == "__main__":
    bcbackup()
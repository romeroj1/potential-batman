import subprocess
import os.path
import datetime


def myencode(path=None):
    '''
    Converts file with specific extensions to .mp4. It assumes HandBrakeCLI is 
    installed already in the system where script gets executed 
    '''
    
    #path = '/apps/nas/tmp'
    strdest = '/apps/nas/tmp/converted'
    now = datetime.datetime.now()
    strtoday = now.strftime('%Y%m%d%H%M')
    
    for root, dirs, files in os.walk(path, topdown=False):
        for name in files:
            #Get file extension
            (base, ext)=os.path.splitext(name)
            #if it is a .mkv or .mov
            if ext.lower() == '.mkv' or ext.lower() == '.mov':
                #Get the directory where the file is at
                (h, tail) = os.path.split(root)
                #Form the destination folder path
                destdir = strdest #os.path.join(strdest,tail)
                #Created the destination folder if required
                print destdir
                if not os.path.exists(destdir):
                    os.mkdir(destdir)
                #Form the output file name (.mp4 extension)
                #newfile = os.path.join(destdir, base + "_" + strtoday + ".mp4")
                newfile = os.path.join(destdir, base + ".mp4")
                print 'This is the new file ' + newfile
                infile = os.path.join(root,name)
                print 'This is the old file ' + infile
                # If it already exists don't overwrite it - skip it
                if os.path.exists(newfile):
                    print "skipping " + infile
                else:                                        
                    subprocess.call(['HandBrakeCLI', '--preset=Universal', '-i' ,infile, '-o', newfile])                                    
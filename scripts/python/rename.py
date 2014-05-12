#!/usr/bin/python
import os
from optparse import OptionParser

#################################################
#
#  Variables
#
#################################################

usage = "usage: %prog [options]"
basedir = '/splunk/db/amigopod/db/'
#basedir = '/tmp/test/'
lstbuckets = ['db', 'colddb']
strsplunkdbhome = '/splunk/db/'

#################################################
#
# GUIDS FOR EACH INDEXER
#
#################################################

#guid for MP 224
strguid = 'BB929E61-87C0-4EA6-A4F2-D5BAFBCBE83E'
#guid for MP 225
#strguid = '1681EB43-2924-4B06-91AE-72C169FE85ED'
#guid for MP 226
#strguid = '0AA49B9B-8A24-4237-A844-D4E5ACE812F0'
#guid for MP 227
#strguid = 'BF4A3BE7-22A1-4952-8F95-5F86F5DBEF52'

def main():
	'''
	Main Module
	'''
	parser = OptionParser(usage,version='%prog 1.0',description='Rename Splunk Index buckets one at a time')
	parser.add_option('-i', '--indexName', dest='index', action='store', type='string', help='Input a valid index name')
	(options,args) = parser.parse_args()

	if len(args) != 0:
		parser.error("incorrect number of arguments")

	if options.index:
		for i in lstbuckets:
			basedir = '/splunk/db/' + options.index + '/' + i +'/'
			renameBuckets(basedir)

def renameBuckets(strBucketName=None):
	'''
	Rename buckets one at a time
	'''

	basedir = strBucketName
	
	if basedir == 'None':
		print('provide a valid path to an index')
		return

	for fn in os.listdir(basedir):
	  if not os.path.isdir(os.path.join(basedir, fn)):
	    continue # Not a directory
	  if 'db_' in fn:
	    srcFolder = os.path.join(basedir, fn)
	    dstFolder = os.path.join(basedir, fn + '_' + strguid)
	    print('Renaming folder ' + srcFolder + ' to ' + dstFolder)
	    #os.rename(os.path.join(basedir, fn), os.path.join(basedir, fn + '_' + strguid))

if __name__ == '__main__':
	main()
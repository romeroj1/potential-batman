#!/usr/bin/python

import os

#guid for MP 233
strguid = '9228E784-3A60-459B-BF9C-382A5DB101CB'
#guid for MP 225
#strguid = '1681EB43-2924-4B06-91AE-72C169FE85ED'
#guid for MP 226
#strguid = '0AA49B9B-8A24-4237-A844-D4E5ACE812F0'
#guid for MP 227
#strguid = 'BF4A3BE7-22A1-4952-8F95-5F86F5DBEF52'
#guid for MP 224
#strguid = 'BB929E61-87C0-4EA6-A4F2-D5BAFBCBE83E'

lstidxs = ["_internaldb", "audit", "acmepacket", "ad", "amigopod", "antivirus", "apache", "aruba", "autosys", "avaya", "bluecoat", "calypso", "checkpoint", "cisacs", "cisco", "cisco_ucs", "citrix", "collateral", "contractor", "cyberark", "defaultdb", "datapower", "egain", "emc", "endur", "entsec_spool", "f5", "filetrek", "fireeye", "gis", "google", "host", "iam", "iboss", "iis", "imperva", "infoblox", "jboss", "juniper", "legaldocs", "mobile", "mq", "mssql", "netapp", "operations_manager", "oracle", "os", "paidsite_bc", "peregrine", "pictureperfect", "r7", "rsa", "sccm", "sharepoint", "silvertail", "siteminder", "solidcore", "sophos", "sos", "sso", "summarydb", "summary_entsec", "summary_juniper", "summary_test", "syslog", "teller3", "test", "user", "vmware", "vontu", "was", "wily", "win"]
lstBucketbase = ['db', 'colddb']
for i in lstidxs:
	for bb in lstBucketbase:
	    basedir = '/splunk/db/' + i + '/' + bb + '/'
	    for fn in os.listdir(basedir):
		  if not os.path.isdir(os.path.join(basedir, fn)):
		    continue # Not a directory
		  if 'db_' in fn:
		    print('Renaming folder ' + os.path.join(basedir, fn) + ' to ' + os.path.join(basedir, fn + '_' + strguid))
		    #Enable when ready to test  
		    #os.rename(os.path.join(basedir, fn), os.path.join(basedir, fn + '_' + strguid))
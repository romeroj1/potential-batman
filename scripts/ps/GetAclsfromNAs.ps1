#################################################
#   Script name: GetAclsfromNAS.ps1				#
#	Author: Johann Romero					 	#
#################################################

# initialize the items variable with the 
# contents of a directory
#$items = Get-ChildItem -Recurse -Path "\\svrname.domain.com\scst\sc\syst\sftp" 
$items = Get-ChildItem -Recurse -Path "c:\Utils" 
$file = "c:\temp\NASFolderStructure.txt"
$filedate = Get-Date -Format "Mdyyyy_HHmm"
$logpath = "C:\Temp\nasacls_$filedate.log"
$log = [System.IO.StreamWriter] $logpath 
$i=0
# enumerate the items array
foreach ($item in $items) 
{
	$i=$i+1;
	Write-Progress -Activity "Searching for folders, this action could take up to 30min, please wait ..." -Status "Progress: " -PercentComplete ($i/$items.Count*100)
    # if the item is a directory, then process it.
    if ($item.PSIsContainer -eq "True")
    {	  		
		$log.WriteLine("------------------------------------")
		$acls = Get-Acl -Path $item.FullName | select path,owner,accesstostring,group			
		$log.WriteLine($acls)
		Write-Host -Verbose $acls
		$log.WriteLine("------------------------------------")            
    }	  
}
$log.close()

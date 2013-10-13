#################################################
#   Script name: CreateNASFolderStructure.ps1	#
#	Author: Johann Romero					 	#
#################################################

$items = Get-Content -Path "e:\Temp\cssfolders.txt"
#$items = Get-Content -Path "c:\Temp\test.txt"
$filedate = Get-Date -Format "Mdyyyy_HHmm"
$logpath = "E:\Temp\naslog_$filedate.log"
#$logpath = "c:\Temp\naslog_$filedate.log"
$log = [System.IO.StreamWriter] $logpath 
$date = Get-Date
Write-Host $items.Count "Folders to create"
$log.WriteLine("Folders to create" + $items.Count)
Write-Host "Creating folders on " $date
$log.WriteLine("Creating folders on " + $date)

# enumerate the items array
foreach ($item in $items) 
{
      #Creates a folder for each item	  	  
	  $log.WriteLine("-------------------------------------------")	  	 
	  Write-Host "-------------------------------------------" 	  
	  $log.WriteLine("Checking if folder exists")
	  $folderexists = Test-Path $item
	  If($folderexists -eq $true)
	  {
	  	$log.WriteLine("Folder: " + $item + " already exist ... Continue to next ...")
		Write-Host "Folder already exist ... Continue to next ..."
	  }
	  else
	  {
	  $log.WriteLine("Folder: " + $item + " does not exist")
	  $log.WriteLine("Creating folder: " + $item)
	  Write-host "Creating folder: " $item 	  	  
	  New-Item -Path $item -type directory 
	  $log.WriteLine("Folder: " + $item + " has been created")
	  Write-Host "Folder: " $item " has been created"
	  }
}
$log.close()

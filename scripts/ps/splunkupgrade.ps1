# Author: Johann Romero
# Date: 07/16/2013
# Abstract: Upgrades splunk forwarder
# Need to connect to server before executing
#7zip needs to be present on the server


$tool = 'msiexec.exe'
$i = '/i'
$x = '/q/x'
$tempdir = "E:\temp\splunkupgrade\"
$newdir = "E:\Apps\SplunkForwarder"
$param1 = 'AGREETOLICENSE=Yes /quiet' #/quiet
$installdir = 'INSTALLDIR="$newdir"'
$indexer = 'RECEIVING_INDEXER="slssindex04.sce.com:9997"'
$launch = 'LAUNCHSPLUNK=0'
$startup = 'SERVICESTARTTYPE=auto'
$filename = '\\svr.domain.com\public\splunk\forwarder\w\splunkforwarder-5.0.3-163460-x64-release.msi'
$splunkpath = 'E:\Program Files\SplunkUniversalForwarder'
$bkpname = $tempdir+'splunk-upgrade.zip'
#product can be found here HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
$pcode = '`{3f09c82b-a919-42bc-afb8-f1d34d661b21`}'
$log = '/l*v e:\temp\splunkupgrade.log'
$launch = 'LAUNCHSPLUNK=0'
$startup = 'SERVICESTARTTYPE=auto'
$lstmonitors = "E:\LogFiles", "C:\inetpub\logs\LogFiles\W3SVC1"
$bkpinputs = $splunkpath+"\etc\apps\MSICreated\local\inputs.conf"
$tmpinputs = $tempdir+"inputs.conf"
$restoreconf = "y"
$destinationFolder = $newdir+"\etc\apps\search\local\"

function upgrade
{
	checksplunksvc
	zipsplunkfolder	
	backup_inputs
	uninstallsplunk
	installnewsplunk
	if ($restoreconf -eq "y")
	{
		restore_inputs
	}
	else
	{
		addmonitors
	}	
	restartsplunk
}

function uninstallsplunk
{
	Write-Host "Uninstalling Splunk..."
	#Enable for debugging
	#Write-Host "$tool $x$pcode"
	Invoke-Expression "$tool $x$pcode"
	Start-Sleep -Seconds 15
}

function installnewsplunk
{
	Write-Host "Installing new splunk now ...."
	Write-Host "$tool $i $filename $installdir $indexer $param1"
	Invoke-Expression "$tool $i $filename $installdir $indexer $launch $startup $param1"
	Start-Sleep -Seconds 15
}

function checksplunksvc
{
	Write-Host "Check if Splunk is Running..."
	$status = Get-Service -DisplayName "SplunkForwarder" | sort-Object status
	if ($status.Status -eq "Running")
	{
		Write-Host "Splunk is Running... Stopping splunk now ..."
		Stop-Service -displayname "SplunkForwarder"	
	}
}

function restartsplunk
{
	Write-Host "Restarting Splunk..."
	[string]$basepath = $newdir+"\bin"
		cd $basepath 
		[string]$cmd = ".\splunk"
		[array]$args = "restart";
		& $cmd $args;
}

function addMonitors
{
	foreach ($p in $lstmonitors)
	{
		[string]$basepath = $newdir+"\bin"
		cd $basepath 
		[string]$cmd = ".\splunk"
		[array]$args = "add", "monitor", $p;
		& $cmd $args;
	}
}

function create-7zip([String] $aDirectory, [String] $aZipfile)
{
    [string]$pathToZipExe = "E:\Program Files (x86)\7-Zip\7z.exe";
    [Array]$arguments = "a", "-tzip", "$aZipfile", "$aDirectory", "-r";
    & $pathToZipExe $arguments;
}

function zipsplunkfolder
{
	Write-Host "Backing up splunk folder..."
	create-7zip $splunkpath $bkpname
}

function backup_inputs
{
	Write-Host "Backing up inputs.conf"
	cp $bkpinputs $tmpinputs
	Write-Host "Done backing up"
}

function restore_inputs
{
	Write-Host "Restoring inputs.conf from backup ..."
	
	if (!(Test-Path -path $destinationFolder))
	{
		New-Item $destinationFolder -Type Directory
	}
	cp $tmpinputs $destinationFolder"inputs.conf" -Recurse -Force
}

upgrade
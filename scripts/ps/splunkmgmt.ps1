# Author: Johann Romero
# Date: 06/21/2013
# Abstract: Deploys new inputs.conf file for splunk and restarts service. Has a dependency on psservice from sysinternals

$basedrive = "\E$\"
$basedir = "\Program Files\SplunkUniversalForwarder"
$inputstemplate = "e:\temp\splunk\inputs.conf"
$splunkinputs = $basedir + "\etc\apps\MSICreated\local\"
$tempdir = "e:\temp\splunk"
$a = Get-Content $tempdir"\svrlist.txt"
$tool = 'E:\temp\splunk\psservice.exe'
$params1 = "restart"
$params2 = "splunkforwarder"

function update_splunk_monitors
{
	foreach ($i in $a)
	{	
		echo "Copying new inputs file..."
		$destpath = "\\" + $i + $basedrive + $splunkinputs
		cp $inputstemplate $destpath
		$svrname = "\\" + $i 
		Invoke-Expression "$tool $svrname $params1 $params2"
	}
}
$basepath='e:\trojan5\LogFiles\xxxx\'
$iisbase='e:\trojan5\LogFiles\W3SVC1'

$stream = [System.IO.StreamWriter] "e:\temp\inputs.conf"

function myaccount
{
	$folderlist=ls $basepath
	foreach ($f in $folderlist)
	{		
		$stream.WriteLine("[monitor://" + $basepath + $f + "]")
		$stream.WriteLine("disabled = false")
		$stream.WriteLine("ignoreOlderThan = 5d")
		$stream.WriteLine("sourcetype = SC3:" + $f)
		$stream.WriteLine("")		
	}
	$stream.WriteLine("[monitor://" + $iisbase + "]")
	$stream.WriteLine("disabled = false")
	$stream.WriteLine("ignoreOlderThan = 2d")
	$stream.WriteLine("sourcetype = SC3:IIS")
}
myaccount
$stream.close()
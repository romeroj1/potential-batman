$basepath='e:\trojan5\LogFiles\xxxx\'
$iisbase='e:\trojan5\LogFiles\'
$iisbase_b='F:\LogFiles\'
$logpath = "E:\Temp\inputs.conf"

$stream = [System.IO.StreamWriter] $logpath

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
	
}

function iis_a
{
	$folderlist=ls $iisbase	
	foreach ($f in $folderlist)
	{	
		if ($f.name.StartsWith("W3SVC"))
		{
			$stream.WriteLine("[monitor://" + $iisbase + $f + "]")
			$stream.WriteLine("disabled = false")
			$stream.WriteLine("ignoreOlderThan = 2d")
			$stream.WriteLine("sourcetype = SC3:IIS")		
			$stream.WriteLine("")
		}
		else
		{
			Write-Host ("Nothing Found")
		}		
	}
	$flist=ls $iisbase_b
	foreach ($d in $flist)
	{	
		if ($d.name.StartsWith("W3SVC"))
		{
			$stream.WriteLine("[monitor://" + $iisbase_b + $d + "]")
			$stream.WriteLine("disabled = false")
			$stream.WriteLine("ignoreOlderThan = 2d")
			$stream.WriteLine("sourcetype = SC3:IIS")
			$stream.WriteLine("")
		}
		else
		{
			Write-Host ("Nothing Found")
		}		
	}
	
}

myaccount
iis_a
$stream.close()
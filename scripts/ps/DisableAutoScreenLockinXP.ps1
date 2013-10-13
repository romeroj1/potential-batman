#########################################
#										#
# Look up registry and delete it		#
#										#
#########################################
try 
{
	$regpath = "hkcu:\Software\Policies\Microsoft\Windows\Control Panel\Desktop"
	$logpath = "c:\Temp\RegDelete2.log"
	$log = [System.IO.StreamWriter] $logpath 
	$log.WriteLine("--------------------------------------")
	$log.WriteLine("Accessing Registry at: " + $regpath)
	$checkregexist = Test-Path -Path $regpath
	if($checkregexist -eq $true)
	{
		$registrykeys = gp $regpath
		Write-Host "Found the following keys: " $registrykeys 
		$log.WriteLine("Found the following keys: " + $registrykeys)
		foreach($item in $registrykeys)
		{
			Write-Host "Deleting key: " $item.PSPath
			$log.WriteLine("Deleting key: " + $item.PSPath)	
			del $item.PSPath
		}
	}
		
}
# Catch specific types of exceptions thrown by one of those commands
catch [System.IO.IOException] 
{
	Write-Host "Can't access path " $regpath
	$log.WriteLine("Can't access path " + $regpath)
}
# Catch all other exceptions thrown by one of those commands
catch 
{
	Write-Host $StackTrace
	$log.WriteLine($StackTrace)
}
# Execute these commands even if there is an exception thrown from the try block
finally 
{
	$log.close()
}


<# Author: Johann Romero
Scripts tries to ping servers on the list provided
#>


try
{	
	$svrlist = Get-Content -Path "C:\Users\romeroj1\Documents\Work\utils\Scripts\Input Files\svr2ping.txt"
	foreach($item in $svrlist)
	{
		ping -4 $item
				
	}	
}
catch [System.Exception]
{
	Write-Host $Error + $StackTrace
}


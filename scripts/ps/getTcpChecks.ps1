<# Author: Johann Romero
Scripts tries to connect to a remote server on a specific port.
This validates if the firewall port is open and remote server is listening on that port
#>


try
{	
	$svrlist = Get-Content -Path "c:\Utils\Scripts\Input Files\srvlistwports.txt"
	foreach($item in $svrlist)
	{
		$socket = New-Object Net.Sockets.TcpClient
		$svrname = $item.split(":");
		$socket.Connect($svrname[0], $svrname[1])
		If($socket.Connected)
		{
			$status = "open"
			$socket.Close()
		}
		else
		{
			$status = "Closed / Filtered"		
		}
		$socket= $null
		Write-Output $svrname[0] $svrname[1] $status
	}	
}
catch [System.Exception]
{
	Write-Host "Error: " $Error
}
catch
{
	Write-Host $Error + $StackTrace
}
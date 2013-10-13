<# Author: Johann Romero
Connects to AD and get user group membership
This script assumes you have the Quest Active Directory Management cmdlets installed
Also assumes its executed in a server or workstation that is a member of the domain you are querying
#>

$userlist = Get-Content "c:\Temp\ad\userlist.txt"
$filedate = Get-Date -Format "Mdyyyy_HHmm"
$logpath = "c:\Temp\ad\log_$filedate.log"
$log = New-Object system.IO.StreamWriter($logpath)
$domain="mydomain"

try
{	
# enumerate the items array
	foreach ($u in $userlist)
	{
		$m="Check if user" + $user + " exist in Active Directory"
		$user=Get-QADUser $domain"\"$u
		if (!$user)
		{
			$m="user " + $u + " does not exist in Active Directory "
			Write-Host ($m)
			$log.WriteLine($m)
		}
		Else
		{
			$m="Getting group membership for user: " + $user
        	$log.WriteLine("-------------------------------------")
			$log.WriteLine($m)
			Write-Host($m)
			$adquery = Get-QADMemberOf $user | Out-String
			Write-Host ($adquery)			
			$log.WriteLine($adquery)
		}
	}
}
Catch [System.Exception]
{
	$log.WriteLine($_.Exception.ToString())
    Write-Host($_.Exception.ToString())	
}
$log.close()
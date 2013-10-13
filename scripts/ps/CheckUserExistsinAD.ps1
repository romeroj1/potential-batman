$userlist = Get-Content "C:\Temp\userlist.txt"
$domain = "mydomain"
foreach ($user in $userlist)
{
	$result = Get-QADUser $domain\$user

	if($result)
	{
    	write-host "User " $user " exist."
	}
	else
	{
		Write-Host "User " $user "does not exist in the domain"
	}
}

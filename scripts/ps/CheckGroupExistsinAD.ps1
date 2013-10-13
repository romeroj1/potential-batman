$grouplist = Get-Content "C:\Temp\grouplist.txt"
$domain = "mydomain"
foreach ($group in $grouplist)
{
	$result = Get-QADUser $domain\$user

	if($result)
	{
    	write-host "Group " $group " exist."
	}
	else
	{
		Write-Host "Group " $group "does not exist in the domain"
	}
}

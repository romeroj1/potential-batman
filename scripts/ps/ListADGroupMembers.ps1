$listgroups = "e:\Temp\adquery\grouplist.txt"
$groups = Get-Content $listgroups
$domain = "mydomain"
$log = "e:\temp\adquery\results.txt"
foreach($g in $groups)
{
		echo "Getting Group Members for: " $g | Out-File $log -Append
		Get-QADGroupMember $domain\$g | Select Name,DN | Out-File $log -Append 	
}
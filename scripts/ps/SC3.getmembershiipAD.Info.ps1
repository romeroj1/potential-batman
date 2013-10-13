<# Author: Johann Romero#>

$grouplist = Get-Content "e:\Temp\grouplist.txt"
$filedate = Get-Date -Format "Mdyyyy_HHmm"
$logpath = "e:\Temp\log_$filedate.log"
$log = New-Object system.IO.StreamWriter($logpath)
$ldapdn="OU=xxxxx,DC=xxxx,DC=xxxx"
$em="No group members found"
$em1="No user members found"

try
{	
# enumerate the items array
	foreach ($group in $grouplist)
	{
		$groupdn='CN=' + $group + ',' + $ldapdn
		$m="Getting members for group: " + $groupdn
        $log.WriteLine("-------------------------------------")
		$log.WriteLine($m)
		Write-Host($m)
		$querygroups= Get-QADGroupMember $groupdn | select dn -First 3
		
		foreach ($qg in $querygroups)
		{			
			if (!$qg)
			{
				Write-Host($em)
				$log.WriteLine($em)
			}
			else
			{
				$qg = $qg.DN
				$query= Get-QADGroupMember $qg | select dn -First 3                                
				foreach ($q in $query)
				{
					if (!$q)
			        {
				        Write-Host($em1 + " for: " + $qg)
				        $log.WriteLine($em1 + " for: " + $qg)
			        }
                    else
                    {
                       $m="Getting members for group: " + $qg
                       Write-Host($m)
                       $log.WriteLine($m)
                       Write-Host("User: " + $q.DN)
					   $log.WriteLine("User: " + $q.DN)
                    }                    
				}
			}
		}
	}
	
}
Catch [System.Exception]
{
	$log.WriteLine($_.Exception.ToString())
    Write-Host($_.Exception.ToString())
}
$log.close()
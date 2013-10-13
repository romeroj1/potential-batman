$servers = Get-Content -Path "E:\utils\PsSuite\serverlist.txt"
$filedate = Get-Date -Format "Mdyyyy_HHmm"
$logpath = "e:\temp\log_$filedate.log"
$log = [System.IO.StreamWriter] $logpath 
# enumerate the items array
foreach ($server in $servers) 
{
	#$checkkb = get-wmiobject Win32_QuickFixEngineering -computer $computer | where-object {$_.hotfixid -eq $kb} | select-object hotfixid, description
	$checkkb = get-wmiobject Win32_QuickFixEngineering -computer $server | select-object hotfixid, description
	$log.WriteLine("Total Patches Found for " + $server + " " + $checkkb.count)
	foreach($patch in $checkkb)
	{
		$log.writeline("Patch ID: " + $patch.hotfixid + " " + "Patch Description: " + $patch.description)
	}
}
$log.close()

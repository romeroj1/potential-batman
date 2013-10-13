$a = Get-Content "c:\temp\svrlist.txt"
$filedate = Get-Date -Format "Mdyyyy_HHmm"
$logpath = "c:\Temp\lookup_$filedate.log"
$log = [System.IO.StreamWriter] $logpath 

function dolookup()
{
	foreach ($i in $a) 
	{
		nslookup $i | Export-Csv c:\Temp\lookup.csv
	}	
}

dolookup
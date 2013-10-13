
<#
	Get Logon ID from AD
#>

# Try one or more commands
try 
{
	#convert date to string
	$filedate = Get-Date -Format "Mdyyyy_HHmm"
	#log path
	$logpath = "c:\Temp\adlog_$filedate.log"
	#results Log
	$rlog =  "c:\Temp\rlog_$filedate.log"
	#.net Class
	$log = [System.IO.StreamWriter] $logpath 
	#Get list of users
	$userlist = Get-Content "c:\Utils\Scripts\OracleUsers.txt"
	$log.Writeline("User count is: " + $userlist.Count)
	foreach ($item in $userlist) 
	{		
		$results = Get-ADUser -Filter 'Name -like $item' -Properties SamAccountName
		#Write a new custom object to the pipeline
		$log.Writeline("User Name: " + $item + " --- LoginId: " + $results.SamAccountName)
		Write-Host $results.SamAccountName
	}
}
# Catch specific types of exceptions thrown by one of those commands
catch [System.IO.IOException] 
{
	Write-Host "Can't access input file"
	$log.WriteLine("Can't access input file:" + $StackTrace)
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

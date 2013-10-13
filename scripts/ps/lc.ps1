param
(
    [Alias("f")]
    [string] $ComputerListFile = "e:\Utils\PsSuite\serverlist.txt",
    [Alias("s")]
    [datetime] $startDt = "01/01/2010",
    [Alias("e")]
    [datetime] $endDt = "12/31/2030",
    [Alias("t")]
    [string] $FileType = "*",
	[Alias("bp")]
	[string] $BackupPath = "e:\backup\"+(Get-Date).ToString('MMddHHmm'),
	[Alias("o")]
	[string] $opt = "c"
)

write-host "`r`n`r`n" #Start log file with 2 blank lines 
$dtStart = [System.DateTime]::Now #Save start time to calculate total time below
write-host ($dtStart.ToString() + " - Script started")

$7ZipPath = "C:\Program Files\7-Zip\7z.exe"
if (-not [System.IO.File]::Exists($7ZipPath) )
{
	$7ZipPath = "E:\Program Files\7-Zip\7z.exe"
}

#Get-Content $ComputerListFile
Write-Host "Picking Files between [$startDt] and [$endDt] " -NoNewline

if ( $opt -ieq "c" ) {
	Write-Host "Copying "  -NoNewline
}
else {
	Write-Host "Moving "	-NoNewline
}
Write-Host "to [$BackupPath] "

$src = "\\svrname\e$\Logs"


$trackingJob = Invoke-Command -ScriptBlock {
    write-host "Computer name is $_.PSComputerName "
	
	$src | dir   | ForEach-Object {
		#Mode LastWriteTime Length Name
		if ( $_.Name -like $FileType )
		{
			if ( $_.LastWriteTime -ge $startDt -and $_.LastWriteTime -le $endDt ) 
			{
				if ( $opt -ieq "c" )
				{
					Copy-Item $_.Name $BackupPath
				}
				Write-Host $_.Name `t $_.LastWriteTime
			}
		}
	}
} -ComputerName (Get-Content $ComputerListFile) #-AsJob


while ($trackingJob.State -like "Running")                #wait until Completed or Failed, Paused, etc.
{
    Start-Sleep -Seconds 10
}
if ($trackingJob.State -like "Failed")
{
	throw $Error
}


$dtEnd = [datetime]::Now
$tsTotal = $dtEnd.Subtract($dtStart)
Write-Host ($dtEnd.ToString()) " - Script finished. Total time: " $tsTotal
write-host "`r`n`r`n" #End log file with 2 blank lines 

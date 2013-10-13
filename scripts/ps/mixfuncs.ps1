#$a = Get-Content "c:\temp\userlist.txt"
#$files = ls "c:\temp\logs" #E:\temp\UniversalForwader
$drive = "c$"
$folder = "\temp\splunk\t\"

function delfiles([string]$path)
{
	$fileslist = ls $path\*.txt -Recurse
	foreach ($f in $fileslist)
	{
		echo "Deleting file " + $f + "--------------------"
		rm $f
	}	
}

function createfolder([string]$path)
{
	mkdir $path
}

function deletefolder()
{
	foreach ($i in $a)
	{
		$del = "\\"+$i+"\"+$drive+"\"+$folder
		rm -Recurse -Path $del
	}	
}

function copy_splunk
{
	foreach ($i in $a) 
	{
		foreach ($f in $files)
		{
			$p = "\\"+$i+"\"+$drive+$folder
			$folderexists = Test-Path $p
			If($folderexists -eq $true)
			{
				cp $f.FullName -Destination $p$f
			}			 		
			else
			{				
				createfolder($p)
				cp $f.FullName -Destination $p$f
			}
		}		
	}
}

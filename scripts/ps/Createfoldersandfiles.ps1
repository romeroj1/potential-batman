try
{
	#Creates 60 folders, making sure the folder name has 2 digits	
	#Change path to match your needs when running this on a server
	$path="c:\temp\xx\"
	0..60 | %{ $p="jrtesting{0:d2}" -f $_ ; md $path$p }
	$dirlist=ls -Recurse $path
	
	foreach ($item in $dirlist)	
	{
		#Creates 20 txt files in each folder
		0..20 | %{ $f="{0:d2}" -f "$_.txt" ; ni -Path $path$item `
		-Name $f -Value (Get-Date).toString() -ItemType file}		
		
		#Creates 20 xml files in each folder
		0..20 | %{ $f="{0:d2}" -f "$_.xml" ; ni -Path $path$item `
		-Name $f -Value (Get-Date).toString() -ItemType file}	
		
		#Creates 20 jpg files in each folder
		0..20 | %{ $f="{0:d2}" -f "$_.jpg" ; ni -Path $path$item `
		-Name $f -Value (Get-Date).toString() -ItemType file}	
		
		#Creates 20 doc files in each folder
		0..20 | %{ $f="{0:d2}" -f "$_.doc" ; ni -Path $path$item `
		-Name $f -Value (Get-Date).toString() -ItemType file}	
	}
}
catch [System.Exception]
{
	Write-Host $_.Exception.ToString()
}

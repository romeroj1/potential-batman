$tempdir = "e:\temp"
$inputFile = Get-Content $tempdir"\userlist.txt"

foreach($a in $inputFile)
{
    New-QADUser -Name $a  -ParentContainer 'OU=xxxx,DC=xxxx,DC=xxxx' -SamAccountName $a -UserPassword '<pwdhere>'
}
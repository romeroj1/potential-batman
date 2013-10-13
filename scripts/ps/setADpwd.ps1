$userlist = Get-Content "e:\Temp\jr\userlist1.txt"
$PWD = "<pwdhere>"

Function Set-AdUserPwd 
{ 
	foreach ($user in $userlist)
	{
		#Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $PWD)
		Set-QADUser -Identity $user -UserPassword $PWD
	}		 
} 
Set-AduserPwd

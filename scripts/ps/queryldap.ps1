Get-QADUser -Locked -SearchRoot "OU=xxxx,DC=xxxx,DC=xxxx"
Get-QADUser -Disabled -SearchRoot "OU=xxxx,DC=xxxx,DC=xxxx"
Get-QADUser -Disabled -SearchRoot "OU=xxxx,DC=xxxx,DC=xxxx" -SearchScope Subtree
Get-QADUser -SearchRoot "OU=xxxx,DC=xxxx,DC=xxxx" -SearchScope Subtree

Get-QADUser -SearchRoot "OU=xxxx,DC=xxxx,DC=xxxx" -SearchScope Subtree -SizeLimit 0 -LdapFilter '(pwdLastSet=0)' 


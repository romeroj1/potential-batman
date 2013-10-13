#Get-QADGroup -GroupType Distribution | Select Name,@{n='MemberCount';e= {@($_ | Get-QADGroupMember).Count}}

Get-QADGroup -SearchRoot "OU=xxxx,DC=xxxx,DC=xxxx" | Select Name,@{n='MemberCount';e= {@($_ | Get-QADGroupMember).Count}} | Export-csv E:\temp\Adgroupcount.csv
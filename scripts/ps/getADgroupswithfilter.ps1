get-qadgroup -Name SCNU-UT-* -SearchRoot 'OU=xxxx, DC=xxxx,DC=xxxx,DC=xxxx' | Select GroupName | Export-csv E:\scnu.csv
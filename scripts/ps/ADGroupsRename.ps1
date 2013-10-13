import-csv ‘c:\utils\scripts\scnu.csv’ | ForEach-Object {Get-QADGroup –Name $_.’OldName’ | `
Rename-QADObject –NewName $_.’NewName’ | Set-QADGroup –SAMAccountname $_.’NewName’ -Description "Primary:xxxx Backup: Johann Romero"`
–Displayname $_.’NewName’ | Format-List Name,sAMAccountname,DN}
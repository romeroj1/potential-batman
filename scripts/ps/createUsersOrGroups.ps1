    #Import the PowerShell module containing AD cmdlets
    Import-Module ActiveDirectory
       
    #Read a CSV file with the user or group details and create an account in AD for each entry
    Function Create-ADAccountsFromCSV {
        Param (
            [parameter(Mandatory=$true)][string]$CSVPath,
            [parameter(Mandatory=$true)][string]$Type,
            [parameter(Mandatory=$true)][string]$OrgUnit
            )
     
        if (($Type -ne "Group") -and ($Type -ne "User"))
        {
            Throw New-Object System.ArgumentException("Type parameter must be specified as either 'User' or 'Group'.")
        }
     
        #Read the CSV file
        $csvData = Import-CSV $CSVPath
        foreach ($line in $csvData) {
           
            #Create a hash table of the account details
            $accountTable = @{
                'givenName'=$line.FirstName
                'sn'= $line.LastName
                'displayName'= $line.DisplayName
                'sAMAccountName'= $line.sAMAccountName
                'password' = $line.Password
                'description' = $line.Description
                'ou' = $OrgUnit 
            }
                   
            if ($Type -eq "User")
            {
                #Call the function to create a user account
                CreateUser -AccountInfo $accountTable
            }
     
            if ($Type -eq "Group")
            {
                #Call the function to create a group account
                CreateGroup -AccountInfo $accountTable                               
            }
        }
    }        

    #Create an Active Directory user
    Function CreateUser {
      Param($AccountInfo)
     
        try
        {
            #Check to see if the user already exists
            $userFilterString = "samAccountName -like `"" + $AccountInfo['sAMAccountName'] + "`""
            $user = Get-ADUser -Filter $userFilterString
           
            #If user not already created, create them
            if ($user -eq $null)
            {
                write-host "Creating user account:" $AccountInfo['sAMAccountName']
               
                #Create the user account object
                New-ADUser -SamAccountName $AccountInfo['sAMAccountName'] `
                           -Name $AccountInfo['displayName'] `
                           -DisplayName $AccountInfo['displayName'] `
                           -GivenName $AccountInfo['givenName'] `
                           -Surname $AccountInfo['sn'] `
                           -Path $AccountInfo['ou'] `
                           -ChangePasswordAtLogon $true `
                           -AccountPassword (ConvertTo-SecureString $AccountInfo['password'] -AsPlainText -Force) `
                           -Description $AccountInfo['description'] `
                           -Enabled $false
           
                #Set 'User must change password at next logon' to true after user has been created
                #For some reason, the option wasn't set during New-ADUser - could be a bug?
                $user = Get-ADUser -Filter $userFilterString
                Set-ADUser $user -ChangePasswordAtLogon $true          
            }
            else
            {
                write-host "User" $AccountInfo['sAMAccountName'] "not created as it already exists" -ForegroundColor blue
            }
        }
        catch
        {
            write-host "There was a problem creating the user" $AccountInfo['sAMAccountName'] "-" $_ -ForegroundColor red
        }
    }

    #Create an Active Directory group
    Function CreateGroup {
        Param($AccountInfo)
     
        try
        {
            #Check to see if the group already exists
            $groupFilterString = "samAccountName -like `"" + $AccountInfo['GroupName'] + "`""
            $group = Get-ADGroup -Filter $groupFilterString
           
            if ($group -eq $null)
            {  
                write-host "Creating group account:" $AccountInfo['GroupName']
               
                #Create the group account object
                New-ADGroup -SamAccountName $AccountInfo['GroupName'] `
                            -Name $AccountInfo['GroupName'] `
                            -Path $AccountInfo['ou'] `
							-Description $AccountInfo['Description']`
                            -GroupScope Global `
                            -GroupCategory Security
            }
            else
            {
                write-host "Group" $AccountInfo['GroupName'] "not created as it already exists" -ForegroundColor blue
            }
        }
        catch
        {
            write-host "There was a problem creating the group" $AccountInfo['GroupName'] "-" $_ -ForegroundColor red
        }  
    }
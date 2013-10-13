#Download Microsoft Security Essentials definitions 
#and sends email confirming it has beend done
# Written by Johann Romero

###############################################
#  Variables 
###############################################

#From Address
$fromaddress = "emailfrom@domain.com"

#To Address
$toaddress = "emailto@domain.com"

#SMTP Server
$smtpserver = "smtp.domain.com"

#Application Name
$appname = "Virus Definitios Update" 

#Convert date to string
$date = ( Get-Date ).ToString('yyyyMMdd_HHmmss')

#Path to the Security Essentials Log
$logpath = "C:\ProgramData\Microsoft\Microsoft Antimalware\Support\MPLog-03232010-100408.log"

#Environment name
$env = "My Desktop"

#Proxy Server Name
$proxyserver = "proxy.domain.com"

#Destination file
$localfilename = "C:\Temp\Definitions\mpam-fex64.exe"

#File to download
$url = "http://download.microsoft.com/download/DefinitionUpdates/mpam-fex64.exe"

###################################################
#  
#  Script execution below... Do not modify below 
#
##################################################
#.Net Class
$webClient = New-Object System.Net.WebClient

#Proxy address and port
$proxy = New-Object System.Net.WebProxy $proxyserver

#Proxy Credentials
#$proxy.Credentials = New-Object System.Net.NetworkCredential("uid", "pwd")
#$webClient.proxy=$proxy

#specify a header for logs purposes
$webClient.Headers.Add("user-agent", "Windows PowerShell WebClient Header")

#Action
$webClient.DownloadFile($url,$localfilename)

#Update Security Essentials
Invoke-Item $localfilename

#Send confirmation Email

$mail = new-object System.Net.Mail.MailMessage

#set sender email address
$mail.From = new-object System.Net.Mail.MailAddress("$fromaddress");

#set the recepient email address
$mail.To.Add("$toaddress");
$mail.IsBodyHtml = "True"

#set the email subject 
$mail.Subject = "$appname - $env";

#set the content
$mail.Body = Get-Content -Path $logpath | Select-String -Pattern "Version"

#$mail.Attachments.Add("$logpath")

#send the message
$smtp = new-object System.Net.Mail.SmtpClient("$smtpserver");

#set the username and password properites on the SmtpClient for authentication
#$smtp.Credentials = new-object System.Net.NetworkCredential("xxx", "xxx"); 
#$smtp.EnableSsl = "true"

#send it
$smtp.Send($mail) 

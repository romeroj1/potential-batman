$bc = "'D:\Program Files\Beyond Compare 3\bcompare.exe'"
$report = "F:\Users\Johann\bkpdaemon\Logs\backup_Report.txt"
$arg2 = "'@F:\Users\Johann\bkpdaemon\bkp.Config'"
$fromaddress = "emailfrom@domain.com"
$toaddress = "emailto@domain.com"
$smtpserver = "smtp.domain.com"
$date = ( Get-Date ).ToString('yyyyMMdd_HHmmss')
$gmailuid = $toaddress
$gmailpwd = '<passwordhere>'

function sendmail()
{
# Building Email output 

$mail = new-object System.Net.Mail.MailMessage

#set sender email address
$mail.From = new-object System.Net.Mail.MailAddress("$fromaddress");

#set the recepient email address
$mail.To.Add("$toaddress");
$mail.IsBodyHtml = "True"

#set the email subject 
$mail.Subject = "Home Backup Completed";

#set the content
$mail.Body = (Get-Content $report | Out-String) -join '<br>';

#$mail.Attachments.Add("$logpath")

#send the message
$smtp = new-object System.Net.Mail.SmtpClient($smtpserver, 587);

#set the username and password properites on the SmtpClient for authentication
$smtp.Credentials = new-object System.Net.NetworkCredential($gmailuid, $gmailpwd); 
$smtp.EnableSsl = "true"

#send it
$smtp.Send($mail) 

}
echo "-------- Backup processing starting now...."
#Invoke-Expression "& $tool $arg1$arg2" -Verbose
Invoke-Expression "& $bc $arg2" -Verbose
echo "-------- running backup"
sendmail
echo "-------- Sending email confirmation"
# We are done, 
Echo "Backup Processing completed."
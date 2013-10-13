# email out
$app="NMS"
$toaddress = "email@domain.com"
$smtpserver = "smtp.domain.com"
$date = ( Get-Date ).ToString('MM/dd/yyyy HH:mm:ss')
$subj= "MR service restarted @ " + ( Get-Date ).ToString('MM/dd HH:mm')
$env = "Production"
# Don't Modify anything below
###################################################
$mail = new-object System.Net.Mail.MailMessage
$mail.From = new-object System.Net.Mail.MailAddress("email@domain.com");

#set the recepient email address
$mail.To.Add("$toaddress");
$mail.IsBodyHtml = "True"

#set the email subject 
$mail.Subject = "$app`:$env - $subj";

#set the content
$mail.Body = "Hi, <br/><br/>The <b>Master Relay</b> windows service has been restarted at $date .<br/><br/>by<br/>SC NMS Support <br/><br/><i>This is automated message from server <b>$env:COMPUTERNAME</b>.</i>";

#send the message
$smtp = new-object System.Net.Mail.SmtpClient("$smtpserver");

#send it
$smtp.Send($mail) 
###############################################
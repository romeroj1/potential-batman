###############################################
# dsrp Sync Job
###############################################

$fromaddress = "emailfrom@domain.com"
$toaddress = "emailto@domain.com"
$smtpserver = "smtp.domain.com"

# Don't Modify anything below
###################################################

# Building Email output 

$mail = new-object System.Net.Mail.MailMessage

#set sender email address
$mail.From = new-object System.Net.Mail.MailAddress("$fromaddress");

#set the recepient email address
$mail.To.Add("$toaddress");
$mail.IsBodyHtml = "True"

#set the email subject 
$mail.Subject = "Testing Iron Port";

#set the content
$mail.Body = "This is just sample email to test";

#$mail.Attachments.Add("$logpath")

#send the message
$smtp = new-object System.Net.Mail.SmtpClient("$smtpserver");

#set the username and password properites on the SmtpClient for authentication
#$smtp.Credentials = new-object System.Net.NetworkCredential("xxx", "xxx"); 
#$smtp.EnableSsl = "true"

#send it
$smtp.Send($mail) 


###############################################
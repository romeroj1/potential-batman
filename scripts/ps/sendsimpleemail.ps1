###############################################
# SC3 BRKFX Sync Job
###############################################

$fromaddress = "emailfrom@domain.com"
$toaddress = "emailto@domain.com"
$smtpserver = "smtp.domain.com"
$date = ( Get-Date ).ToString('yyyyMMdd_HHmmss')
$subject = "More messages"
$body = "sssssssssssssssssssssssssssssssss"

# Don't Modify anything below
###################################################

# Building Email output 

Send-MailMessage -To $toaddress -From $fromaddress -SmtpServer $smtpserver -Subject $subject -Body $body -BodyAsHtml

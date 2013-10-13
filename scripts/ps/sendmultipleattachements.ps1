###############################################
# SC3 BRKFX Sync Job
###############################################

$fromaddress = "emailfrom@domain.com"
$toaddress = "emailto.domain.com"
$smtpserver = "smtp.domain.com"
$appname = "SC3_BRKFX_SYNC" 
$date = ( Get-Date ).ToString('yyyyMMdd_HHmmss')
$logpath = "E:\LogFiles\sync\sync.log"
$report = "e:\LogFiles\sync\SC3_BRKFX_SYNC.html"
$newlog = "E:\LogFiles\sync\sync_$date.log"
$env = "BreakFix"
$subject = "$appname Sync Results - $env"
$body = "Code Migrations Results"

# Don't Modify anything below
###################################################

# Building Email output 

Send-MailMessage -To $toaddress -From $fromaddress -Attachments $logpath, $report -SmtpServer $smtpserver -Subject $subject -Body $body -BodyAsHtml

#!/usr/bin/env python

import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# me == my email address
# you == recipient's email address
me = "johann.romero@gmail.com"
sc3infra = ['s@s.com', 'y@y.com', 'x@x.com']
COMMASPACE = ', '
strmsg = None
strmailgw = 'smtpserver'

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart('alternative')
msg['Subject'] = "IPQ has been updated"
msg['From'] = me
msg['To'] = COMMASPACE.join(sc3infra)


# Create the body of the message (a plain-text and an HTML version).
text = "Hi!\nIPQ has been updated. Pls update your copy asap!!!"
html = """\
<html>
  <head></head>
  <body>
    <p>Hi!<br>
       IPQ has been updated. Pls update your copy asap!!!
    </p>
  </body>
</html>
"""

# Record the MIME types of both parts - text/plain and text/html.
part1 = MIMEText(text, 'plain')
part2 = MIMEText(html, 'html')

# Attach parts into message container.
# According to RFC 2046, the last part of a multipart message, in this case
# the HTML message, is best and preferred.
msg.attach(part1)
msg.attach(part2)

# Send the message via local SMTP server.
s = smtplib.SMTP(strmailgw)
# sendmail function takes 3 arguments: sender's address, recipient's address
# and message to send - here it is sent as one string.
s.sendmail(me, sc3infra, msg.as_string())
s.quit()

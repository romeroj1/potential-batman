#-- Start ----

import telnetlib

HOST = "192.169.10.10  #ipaddress of the host you are telneting
user = "cisco" #user name
password = "cisco" #user password
en_password = "cisco" #enable password (privilege level 15)

tn = telnetlib.Telnet(HOST)
tn.read_until("Username: ")
tn.write(user + "\n")

tn.read_until("Password: ")
tn.write(password + "\n")
tn.write("enable\n")
tn.read_until("Password: ")
tn.write(en_password + "\n")

tn.write("terminal length 0\n")
#the above command is to instruct cisco routers to display
#the output without any break or human intervention.

tn.write("show run\n") #display running-config of the cisco device

tn.write("exit\n")

print tn.read_all()

#-- Stop ---- 
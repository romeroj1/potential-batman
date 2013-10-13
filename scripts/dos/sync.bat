Set workingdir="E:\Program Files\Beyond Compare 3"
set logpath=E:\Trojan5\batch\dsrp\sync.log
set dsrsyncconfig=E:\Trojan5\batch\dsrp\sync.config
set bkplog=E:\trojan5\batch\dsrp\logs
 

%workingdir%\BCompare.exe @%dsrsyncconfig% /closescript /silent

powershell -command "& 'E:\Trojan5\batch\dsrp\sync.ps1'"

for /f "tokens=1-3 delims=/- " %%a in ('date /t') do set XDate=%%a-%%b-%%c

for /f "tokens=1-2 delims=: " %%a in ('time /t') do set XTime=%%a.%%b


move %logpath% %bkplog%\"sync_%Xdate%_%XTime%.log"

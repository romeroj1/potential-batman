rem **********************************************************
rem *
rem * Imports Certicom RootCA
rem *
rem *
rem **********************************************************

rem Set LogFile=E:\temp\rootca.log
set certdir=E:\temp\Installer\RootCA
set certfile=E:\temp\Installer\RootCA\tls.secg.org_8.cer
set certstore=Root
set verisigncertfile=E:\Temp\Installer\RootCA\Certs\verisingCA.cer
rem ***********************************************************
rem *
rem *
rem * Don't change anything below here
rem *
rem ***********************************************************
echo Installing RootCA
certutil -addstore %certstore% "%certfile%"
certutil -addstore %certstore% "%verisigncertfile%"


set certfile=E:\temp\Installer\RootCA\certicom-test-client-cert.cer
set certstore=My
rem ***********************************************************
rem *
rem *
rem * Don't change anything below here
rem *
rem ***********************************************************
echo Installing Personal
certutil -addstore %certstore% "%certfile%"

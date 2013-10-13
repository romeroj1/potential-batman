set ssl_name="CN=whatever.domain.com, OU=IT, O=xxxx, L=Wherever, S=California, C=US"
SslSetup.exe /p:8203 /l:localmachine /s:%ssl_name% /c /v >> e:\sslbind.log
rem SslSetup.exe /p:8204 /l:localmachine /s:%ssl_name% /c /v >> e:\sslbind.log
pause
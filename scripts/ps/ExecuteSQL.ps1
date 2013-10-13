#########################################
#										#
# This script execute a SQL command		#
#										#
#########################################

<#
The following is a list of commands to do something in sql

Select * from name of table
Select * from sys.tables  --> returns list of tables
insert into ESCNetworks (DataCenter, Application, Environment,Network,Mask,Gateway) values ('xx', 'xx', 'xx', '192.168.0.0/24', '255.255.255.0', '192.168.0.1')"
Display Columns of a table
$myquery = "SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name='Networks'"
select * from dbo.VIPs where Service like 'DP%'
#>

#############################################################
# Actual Script doing work below
#############################################################


$dbname = "JRStuff"
#select query
$myquery = "Select * from networks "
$sqlserver = ".\sqlexpress"

Invoke-Sqlcmd -Query $myquery -ServerInstance $sqlserver -Database $dbname | Format-Table #| Export-Csv c:\Temp\t.csv
#!/bin/sh

#
# Define the usage function.
#
Usage()
{
   cat $ARCSIGHT_HOME/bin/scripts/upgrade/export_system_tables/readme.txt
   exit $1
}

#
# Process command-line arguments.
#
if [ $# -gt 0 ]; then
   case "$1" in
       -h) Usage 0;;
        *) ;;
   esac
fi

echo "Creating parameters for export"

if [ "$2" = "-s" ]; then
    sqlplus $1 @$ARCSIGHT_HOME/bin/scripts/upgrade/export_system_tables/export_system_tables.sql '"or upper(table_name) like "' ARC_SLD_%
elif [ "$2" != "-s" ]; then
    sqlplus $1 @$ARCSIGHT_HOME/bin/scripts/upgrade/export_system_tables/export_system_tables.sql '"and upper(table_name) not like "' ARC_SLD_%
fi

grep "tables="  system.param > system_tables.param
grep [A-Z], system.param >> system_tables.param
grep [0-9], system.param >> system_tables.param
rm -f system.param

exp $1 parfile=system_tables.param file=/opt/arcsight/system_table_backup/arcsight.dmp direct=y consistent=y

RETVAL=$?
[ $RETVAL -eq 0 ] && echo Success > /home/backup/tmp/exportstat.txt
[ $RETVAL -ne 0 ] && echo Failure > /home/backup/tmp/exportstat.txt

rm ~/tmp/arcsight.dmp.gz
gzip /opt/arcsight/system_table_backup/arcsight.dmp
mv /opt/arcsight/system_table_backup/*.gz ~/tmp/

echo
echo
echo "Finished exporting all system tables from $1 to /home/backup/tmp/arcsight.dmp"

echo "Loggin succesful system table export."
sqlplus $1 @$ARCSIGHT_HOME/bin/scripts/upgrade/export_system_tables/log_successful_export.sql


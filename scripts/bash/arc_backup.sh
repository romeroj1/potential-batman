rm /opt/arcisght/db/arcsight.dmp
rm /opt/arcsight/db/arcsight.dmp.gz
/opt/arcsight/db/bin/arcsight export_system_tables arcsight/xxxx@arcsight
gzip /opt/arcsight/db/arcsight.dmp
mv /opt/arcsight/db/arcsight.dmp.gz /root



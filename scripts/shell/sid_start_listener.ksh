#!/usr/bin/ksh

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
#& - Parameters to be set when doing a database install
#& or when using these scripts in an existing environment.
HOSTNAME=`hostname`        ### Parameter for hostname.
SCRIPT=$(basename $0)      ### Parameter for script name
#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


. /<sid>/admin/profile/oracle.profile

su -m oracle -c $ORACLE_HOME/bin/lsnrctl << EOF

start listener_$ORACLE_SID

EOF

stat1=$?

if [[ $stat1 != 0 ]]; then

        echo ""
        echo "The Listener Start in $ORACLE_SID failed."
        echo ""

        export DATE=`date +"%h %d %T %p"`

        SUBJECT="${HOSTNAME}  ${ORACLE_SID} - Script ${SCRIPT} failed to start the database on ${DATE}."

        mailx -s "${SUBJECT}" xxxxxxxxxx@domain.com < /dev/null
        
        exit 1

else

        export DATE=`date +"%h %d %T %p"`

        SUBJECT="${HOSTNAME}  ${ORACLE_SID} - Script ${SCRIPT} sucessfully started the database on ${DATE}."

        mailx -s "${SUBJECT}" xxxxxxxx@domain.com < /dev/null

        exit 0

fi


exit

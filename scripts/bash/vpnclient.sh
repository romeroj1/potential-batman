#! /bin/bash
#
# openvpn-client    Start/Stop the openvpn client
#
# chkconfig: 2345 90 60
# description: start openvpn client at boot
# processname: openvpn

# Source function library.
. /etc/init.d/functions

daemon="openvpn"
prog="openvpn-client"
conf_file="/etc/openvpn/btguard.conf"
mypid="/run/btguard.pid"

start() {
    echo -n $"Starting $prog: " 
        if [ -e $mypid ] && [ $(pgrep -fl "openvpn $conf_file" | wc -l) -gt 0 ]; then
        echo_failure
        echo
        exit 1
    fi
    runuser -l root -c "$daemon $conf_file >/dev/null 2>&1 &" && echo_success || echo_failure
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch $mypid;
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog: "
    pid=$(ps -ef | grep "[o]penvpn $conf_file" | awk '{ print $2 }')
    kill $pid > /dev/null 2>&1 && echo_success || echo_failure
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f $mypid;
    return $RETVAL
}   

status() {
    pgrep -fl "openvpn $conf_file" >/dev/null 2>&1
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        pid=$(ps -ef | grep "[o]penvpn $conf_file" | awk '{ print $2 }')
        echo $"$prog (pid $pid) is running..."
    else
        echo $"$prog is stopped"
    fi
}   

restart() {
    stop
    start
}   

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    condrestart)
        [ -f $mypid ] && restart || :
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart}"
        exit 1
esac

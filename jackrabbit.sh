#!/bin/sh
### BEGIN INIT INFO
# Provides:          jackrabbit
# Short-Description: Start/stop Jackrabbit JCR server.
#
# Description:       This relies on a PID file to check if Jackrabbit is running.
#                    Edit the variables below to configure Jackrabbit
#                    Depending on the storage backend, you might want to adjust
#                    the required start / stop lines.
#
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Required-Start:
# Required-Stop:
#
# Author:            Daniel Barsotti <daniel.barsotti@liip.ch>
#                    Bastian Widmer <bastian.widmer@liip.ch>
### END INIT INFO


### PLEASE EDIT THESE VALUES FOR YOUR SETUP
# Directory in which jackrabbit will store local data, must be writeable
BASEDIR=/home/dev/Jackrabbit-startup-script/jackrabbit
# Full filename of jackrabbit standalone .jar to run
JACKRABBIT_JAR=$BASEDIR/jackrabbit-standalone-2.3.1-jackalope-SNAPSHOT.jar
# IP address for jackrabbit to listen on. you can make jackrabbit listen on all
# interfaces by using 0.0.0.0 here.
JACKRABBIT_HOST=127.0.0.1
# Port number to listen on. 8080 is default, you can use something else
JACKRABBIT_PORT=8080
# JMX-Port for monitoring
JMX_PORT=1111
# Directory of the JMX configuration files (jmx.user & jmx.role). It defaults to
# the script directory
JMX_DIR=$PWD
# Java memory allocation
MEMORY="-XX:MaxPermSize=128m \
        -Xmx512M \
        -Xms128M"
# JMX Management Parameters
MANAGEMENT="-Dcom.sun.management.jmxremote  \
            -Dcom.sun.management.jmxremote.port=$JMX_PORT \
            -Dcom.sun.management.jmxremote.authenticate=true \
            -Dcom.sun.management.jmxremote.ssl=false \
            -Dcom.sun.management.jmxremote.password.file=$JMX_DIR/jmx.user \
            -Dcom.sun.management.jmxremote.access.file=$JMX_DIR/jmx.role"
# Full filename to the pid file to check if jackrabbit is running
PIDFILE=$BASEDIR/jackrabbit.pid
# Full filename to the logfile to output console output of jackrabbit
# additionally, jackrabbit has its own logfile
LOGFILE=$BASEDIR/jackrabbit.log
###

# Uncomment to debug the script
#set -x

is_started() {
    curl -s "http://$JACKRABBIT_HOST:$JACKRABBIT_PORT" |grep "Jackrabbit" > /dev/null
    return $?
}

do_start() {
    if ! is_started; then
        cd $BASEDIR
        nohup java $MEMORY $MANAGEMENT -jar $JACKRABBIT_JAR -h $JACKRABBIT_HOST -p $JACKRABBIT_PORT >> $LOGFILE 2>&1 & echo $! > $PIDFILE
        # Wait until the server is ready (from an idea of Christoph Luehr)
        while [ -z "`curl -s "http://$JACKRABBIT_HOST:$JACKRABBIT_PORT"`" ] ; do sleep 1s; echo -n "."; done
        echo "Jackrabbit started"
    else
        echo "Jackrabbit is already running"
    fi
}

do_stop() {
    if is_started; then
        if [ -f $PIDFILE ]; then
            kill $(cat $PIDFILE)
            rm $PIDFILE
            echo "Jackrabbit stopped"
        else
            echo "pid not found"
        fi
    else
        echo "Jackrabbit is not running"
    fi
    exit 3
}

do_status() {
    if is_started; then
        echo "Jackrabbit is running \c"
        if [ -f $PIDFILE ]; then
            echo "[ pid = " $(cat $PIDFILE) "]"
        else
            echo "[ pid not found ]"
        fi
    else
        echo "Jackrabbit is not running"
        exit 3
    fi
}

case "$1" in
    start)
        do_start
    ;;
    stop)
        do_stop
    ;;
    status)
        do_status
    ;;
    *)
        echo "Usage: $SCRIPTNAME {start|stop|status}" >&2
        exit 3
    ;;
esac

#!/bin/sh
### BEGIN INIT INFO
# Provides:          jackrabbit
# Short-Description: Start/stop Jackrabbit JCR server.
#
# Description:      This relies on a PID file to check if Jackrabbit is running.
#                   If you kill Jackrabbit without removing the PID file, you
#                   will not be able to start Jackrabbit with this script until
#                   you manually remove the PID file.
#                   Edit the variables below to configure Jackrabbit
#                   Depending on the storage backend, you might want to adjust
#                   the required start / stop lines.
#
# Default-Start:    2 3 4 5
# Default-Stop:     0 1 6
# Required-Start:
# Required-Stop:
#
# Author:           Daniel Barsotti <daniel.barsotti@liip.ch>
### END INIT INFO


### PLEASE EDIT THESE VALUES FOR YOUR SETUP
# directory in which jackrabbit will store local data, must be writeable
BASEDIR=/home/dev/jackalope/jackrabbit
# full filename of jackrabbit standalone .jar to run
JACKRABBIT_JAR=$BASEDIR/jackrabbit-standalone-2.2.8-jackalope-SNAPSHOT.jar
# ip address for jackrabbit to listen on. you can make jackrabbit listen on all
# interfaces by using 0.0.0.0 here.
JACKRABBIT_HOST=127.0.0.1
# port number to listen on. 8080 is default, you can use something else
JACKRABBIT_PORT=8080
###

# full filename to the pid file to check if jackrabbit is running
PIDFILE=$BASEDIR/jackrabbit.pid
# full filename to the logfile to output console output of jackrabbit
# additionally, jackrabbit has its own logfile
LOGFILE=$BASEDIR/jackrabbit.log

#set -x

do_start() {
    if [ ! -f $PIDFILE ]; then
        cd $BASEDIR
        nohup java -jar $JACKRABBIT_JAR -h $JACKRABBIT_HOST -p $JACKRABBIT_PORT >> $LOGFILE 2>&1 & echo $! > $PIDFILE
        echo "Jackrabbit started"
    else
        echo "Jackrabbit is already running"
    fi
}

do_stop() {
    if [ -f $PIDFILE ]; then
        kill $(cat $PIDFILE)
        rm $PIDFILE
        echo "Jackrabbit stopped"
    else
        echo "Jackrabbit is not running"
    fi
}

do_status() {
    if [ -f $PIDFILE ]; then
          echo "Jackrabbit is running [ pid = " $(cat $PIDFILE) "]"
    else
        echo "Jackrabbit is not running"
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


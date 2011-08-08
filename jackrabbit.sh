#!/bin/sh
### BEGIN INIT INFO
# Provides:         jackrabbit
# Description:      Start/stop the Jackrabbit server.
#                   This relies on a PID file to check if Jackrabbit is running or not.
#                   If you kill Jackrabbit without removing the PID file, you will not be
#                   start Jackrabbit with this script before you manually removed the PID
#                   file.
# Author:						Daniel Barsotti <daniel.barsotti@liip.ch>
### END INIT INFO


### YOU HAVE TO EDIT THESE VALUES !!!
BASEDIR=/home/dev/jackalope/jackrabbit
#JACKRABBIT=$BASEDIR/jackrabbit-standalone-2.2.6-SNAPSHOT.jar
JACKRABBIT=$BASEDIR/jackrabbit-standalone-2.2.8-jackalope-SNAPSHOT.jar
### 


PIDFILE=$BASEDIR/jackrabbit.pid
LOGFILE=$BASEDIR/jackrabbit.log

#set -x

do_start() {
	if [ ! -f $PIDFILE ]; then
		cd $BASEDIR
		nohup java -jar $JACKRABBIT >> $LOGFILE 2>&1 & echo $! > $PIDFILE
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


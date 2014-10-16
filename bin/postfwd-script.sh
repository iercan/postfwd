#!/bin/sh
#
# Startscript for the postfwd daemon
#
# by JPK

PATH=/bin:/usr/bin:/usr/local/bin

# path to program
PFWCMD=/usr/local/postfwd/sbin/postfwd
# rulesetconfig file
PFWCFG=/etc/postfix/postfwd.cf

# daemon settings
PFWUSER=nobody
PFWGROUP=nobody
PFWINET=127.0.0.1
PFWPORT=10040

# recommended extra arguments
PFWARG="--summary=600 --cache=600 --cache-rdomain-only --cache-no-size"


## should be no need to change below

P1="`basename ${PFWCMD}`"; P2="`basename $0`";
PIDS="`ps -aef | grep "${P1}" | grep -v "${P2}" | grep -v grep | awk '{print $2}' | sort -nr`"

case "$1" in

	start*)		if [ -n "${PIDS}" ]; then
                                echo "Process called \"${P1}\" already found at PID ${PIDS}. Please use \"${P2} restart\" instead." ;
				false;
                        else
				echo "Starting ${P1}...";
				${PFWCMD} ${PFWARG} --daemon --file=${PFWCFG} --interface=${PFWINET} --port=${PFWPORT} --user=${PFWUSER} --group=${PFWGROUP};
			fi ;
			;;

	stop*)		if [ -z "${PIDS}" ]; then
				echo "No process called \"${P1}\" found" ;
				false;
			else
				echo "Stopping ${P1}...";
				for pid in ${PIDS}; do kill ${pid}; done ;
			fi ;
			;;

	reload*)	if [ -z "${PIDS}" ]; then
				echo "No process called \"${P1}\" found" ;
				false;
			else
				echo "Refreshing ${P1}...";
				for pid in ${PIDS}; do kill -HUP ${pid}; done ;
			fi ;
			;;

	restart*)	$0 stop;
			sleep 1;
			$0 start;
			;;

	*)		echo "Unknown argument \"$1\"" >&2;
			echo "Usage: ${P2} {start|stop|reload|restart}" >&2;
			exit 1;;
esac
exit $?
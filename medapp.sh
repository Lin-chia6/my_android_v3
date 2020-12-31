#!/bin/sh
 
### BEGIN INIT INFO
# Provides:          
# Required-Start:    my-service
# Required-Stop:     my-service
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: My Linux Service
### END INIT INFO
 
set -e
 
SERVICE_NAME=`basename $0`
PIDFILE=/var/run/medapp.pid
LOGPATH="/var/log/${SERVICE_NAME}"
FOREVER_BIN=`which forever`
APP_PATH="/opt/my_android_v3/RestfulAPI/index.js"
 
case $1 in
 start)
 if [ -e "${PIDFILE}" ]; then
 PID=`cat ${PIDFILE}`
 echo "Service is running already. (PID=${PID})"
 exit 1
 fi
 if [ ! -d "${LOGPATH}" ]; then
 mkdir -p "${LOGPATH}"
 fi
 PID=`ps aux | grep ${APP_PATH} | head -n1 | awk '{print $2}'`
 ${FOREVER_BIN} -a -l "${LOGPATH}/service.log" -o "${LOGPATH}/out.log" -e "${LOGPATH}/error.log" start ${APP_PATH} > "${LOGPATH}/start.log"
 rm -rf ${PIDFILE}
 echo "${PID}" > ${PIDFILE}
 echo "Service ${SERVICE_NAME} start. PID=${PID}"
 ;;
 stop)
 if [ ! -e "${PIDFILE}" ]; then
 echo "Service is not running."
 else
 PID=`cat ${PIDFILE}`
 kill ${PID} || true
 rm -rf ${PIDFILE}
 echo "Service ${SERVICE_NAME} stop. PID=${PID}"
 fi
 ;;
 restart)
 $0 stop
 sleep 1
 $0 start
 ;;
 status)
 if [ -e "${PIDFILE}" ]; then
 PID=`cat ${PIDFILE}`
 echo "Service is running. (PID=${PID})"
 else
 echo "Service is not running."
 fi
 ;;
 *)
 echo "Usage: ${0} {start|stop|restart|status}"
 exit 1
 ;;
esac

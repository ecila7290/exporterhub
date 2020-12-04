#!/bin/sh
parm=$APP_STAT
set -eu
 
echo "Checking DB connection ..."
 
i=0
until [ $i -ge 10 ]
do
  nc -z maria_db 3306 && break
 
  i=$(( i + 1 ))
 
  echo "$i: Waiting for DB 1 second ..."
  sleep 1
done
 
if [ $i -eq 10 ]
then
  echo "DB connection refused, terminating ..."
  exit 1
fi
 
echo "DB is up ..."

	case $parm in 
		server)
			python manage.py migrate 
			python manage.py runserver 0.0.0.0:8000
			;;
		scheduler)
			python manage.py scheduler
			;;
	esac

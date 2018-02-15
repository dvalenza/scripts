#cron command for remote pull
#rsync -avz -e "ssh -p 1234" root@12.123.123.123:/mysql_backups /media/BB_Backups/`date +"%m-%d-%Y"`

#the script:


#!/usr/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin 
MyUSER="root" # USERNAME 
MyPASS="" # PASSWORD 
MyHOST="localhost" # Hostname 
MYSQL="$(which mysql)" 
MYSQLDUMP="$(which mysqldump)" 
CHOWN="$(which chown)" 
CHMOD="$(which chmod)" 
GZIP="$(which gzip)" 
MBD="/mysql_backups" 
HOST="$(hostname)" 
NOW="$(date +"%d-%m-%Y")" 
FILE="" 
DBS="" 
IGGY="performance_schema information_schema test" 
find "$MBD/" -type f -mtime +1 -exec rm {} \; 
[ ! -d $MBD ] && mkdir -p $MBD || : 
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')" 
for db in $DBS 
do 
	skipdb=-1 
	if [ "$IGGY" != "" ]; 
	then 
		for i in $IGGY 
		do 
			[ "$db" == "$i" ] && skipdb=1 || : 
		done 
	fi 
	if [ "$skipdb" == "-1" ] ; then 
		FILE="$MBD/$db.$NOW.gz" 
		$MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE 
	fi 
done

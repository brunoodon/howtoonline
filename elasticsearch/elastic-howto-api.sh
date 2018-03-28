#!/bin/bash
#if test -f $log_tmp
#then
#	rm -f $log_tmp
#fi
lista=$(mysql -u root -h 91.205.173.217 --password=mujebik@ -D moodle -e "select mdl_user.username,mdl_user.email,mdl_logstore_standard_log.action,from_unixtime(mdl_logstore_standard_log.timecreated, '%Y-%m-%d') as data_acesso, mdl_logstore_standard_log.courseid, mdl_course.fullname, mdl_logstore_standard_log.other, mdl_user.id, mdl_user.firstname, mdl_user.lastname, mdl_user.city from  mdl_logstore_standard_log, mdl_user, mdl_course where mdl_user.id = mdl_logstore_standard_log.userid and mdl_logstore_standard_log.action = 'viewed' and mdl_logstore_standard_log.courseid = mdl_course.id" | grep -v username | tr \\t ';' | cut -d ';' -f 1,2,4,5,6,9- | sed s/';}'/'|'/g | tr -d '|' | grep -i -v 's:')

for line in $lista
do

login=$(echo "$line" | cut -d ';' -f 1)
email=$(echo "$line" | cut -d ';' -f 2)
date=$(echo "$line" | cut -d ';' -f 3)
coursename=$(echo "$line" | cut -d ';' -f 5)
name=$(echo "$line" | cut -d ';' -f 7)
surname=$(echo "$line" | cut -d ';' -f 8)
city=$(echo "$line" | cut -d ';' -f 9)

done


#diff=$(diff $log_tmp $log)
#if test -n "$diff"
#	then
#		echo "$diff" | grep -v -E ^[0-9] | sed s/'< '/':'/g | sed s/'> '/':'/g | tr -d ':'  >> $log
#	fi


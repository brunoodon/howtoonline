#!/bin/bash
data_hoje=$(date +%Y-%m-%d)
data_agora=$(date "+%Y-%m-%d %H:%M:%S")
elastichost=<host>
elasticport=9200
username=elastic
password="$1"
index=howto-$data_hoje
mysql -u root -h <host> --password=<password> -D moodle -e "select mdl_user.username,mdl_user.email,mdl_logstore_standard_log.action,from_unixtime(mdl_logstore_standard_log.timecreated, '%Y-%m-%d') as data_acesso, mdl_logstore_standard_log.courseid, mdl_course.fullname, mdl_logstore_standard_log.other, mdl_user.id, mdl_user.firstname, mdl_user.lastname, mdl_user.city from  mdl_logstore_standard_log, mdl_user, mdl_course where mdl_user.id = mdl_logstore_standard_log.userid and mdl_logstore_standard_log.action = 'viewed' and mdl_logstore_standard_log.courseid = mdl_course.id" | grep -v username | tr \\t ';' | cut -d ';' -f 1,2,4,5,6,9- | sed s/';}'/'|'/g | tr -d '|' | grep -i -v 's:'|grep -i "$data_hoje" > /tmp/query.tmp


curl --user $username:$password -XPUT -H "Content-Type: application/json" "$elastichost:$elasticport/$index?pretty" \
  --data @- <<END	
{
	"mappings": {
	"doc": {
		"properties": {
		"data": { "type": "date", "format": "yyyy-MM-dd" },
		"id": { "type": "integer" }
}
}
}
}

END


for i in $(cat /tmp/query.tmp|tr ' ' _)
do
login=$(echo $i| cut -d ';' -f 1)
email=$(echo $i| cut -d ';' -f 2)
data=$(echo $i| cut -d ';' -f 3)
coursename=$(echo $i| cut -d ';' -f 5)
user_id=$(echo $i| cut -d ';' -f 6)
name=$(echo $i| cut -d ';' -f 7)
surname=$(echo $i| cut -d ';' -f 8)
city=$(echo $i| cut -d ';' -f 9)




curl --user $username:$password -XPOST -H 'Content-Type: application/json' "$elastichost:$elasticport/$index/doc?" \
		--data @- <<END 
{"id": "$user_id", "login": "$login","email": "$email","data": "$data","curso": "$coursename","nome": "$name","sobrenome": "$surname","cidade": "$city"}
END


done

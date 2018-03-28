#!/bin/bash
if test -f /tmp/temp.txt
then
	rm -f /tmp/temp.txt
fi
data_hoje=$(date +%Y-%m-%d)
data_agora=$(date "+%Y-%m-%d %H:%M")
elastichost=elk.howtoonline.com.br
elasticport=9200
username=elastic
password=mujebik@
index=howto-$data_hoje


curl --user $username:$password -XPUT -H "Content-Type: application/json" "http://$elastichost:$elasticport/$index/mappings/doc?" \
  --data @- <<END	
{

		"properties": {
		"date": { "type": "date", "format": "yyyy-MM-dd HH:mm||yyyy-MM-dd||strict_date_optional||epoch_millis|basic_date_time" }
}
}

END


#for i in "$(mysql -u root -h 91.205.173.217 --password=mujebik@ -D moodle -e "select mdl_user.username,mdl_user.email,mdl_logstore_standard_log.action,from_unixtime(mdl_logstore_standard_log.timecreated, '%Y-%m-%d') as data_acesso, mdl_logstore_standard_log.courseid, mdl_course.fullname, mdl_logstore_standard_log.other, mdl_user.id, mdl_user.firstname, mdl_user.lastname, mdl_user.city from  mdl_logstore_standard_log, mdl_user, mdl_course where mdl_user.id = mdl_logstore_standard_log.userid and mdl_logstore_standard_log.action = 'viewed' and mdl_logstore_standard_log.courseid = mdl_course.id" | grep -v username | tr \\t ';' | cut -d ';' -f 1,2,4,5,6,9- | sed s/';}'/'|'/g | tr -d '|' | grep -i -v 's:'| grep -i $data_hoje)"
#do
#login=$(echo "$i"| cut -d ';' -f 1)
#email=$(echo "$i"| cut -d ';' -f 2)
#date=$(echo "$i"| cut -d ';' -f 3)
#coursename=$(echo "$i"| cut -d ';' -f 5)
#name=$(echo "$i"| cut -d ';' -f 7)
#surname=$(echo "$i"| cut -d ';' -f 8)
#city=$(echo "$i"| cut -d ';' -f 9)




#curl --user $username:$password -XPOST -H 'Content-Type: application/json' "$elastichost:$elasticport/$index/doc?" \
#		--data @- <<END 
#{"login": "$login","email": "$email","data": "$date","curso": "$coursename","nome": "$name","sobrenome": "$surname","cidade": "$city"}
#END


#done


curl --user $username:$password -XPOST -H 'Content-Type: application/json' "$elastichost:$elasticport/$index/mappings/doc?" \
		--data @- <<END 
{"login": "bguno","email": "bguno@merda","data": "$data_hoje","curso": "De Merda","nome": "Cú","sobrenome": "de Oliveira","cidade": "Nilopolis"}
END


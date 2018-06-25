#!/bin/bash
# Выгружает данные из заббикса и отправляет на почту
DST=/tmp

groups=( R01 R23 R31 R34 R36 R46 R48 R61 R68 )
options=""
for i in "${groups[@]}"
do
      mysql -uroot -p <password>  -h <ip address> -e "select name  from zabbix.hosts where hostid in ( select hostid from zabbix.hosts_groups where groupid in (select groupid  from zabbix.groups where groups.name like '$i%') )" > "$DST/$i.txt"
      options+=" -A  $DST/$i.txt"
done
echo "Группы" | mail -s "Выгрузка по всем группам"  $options  $1


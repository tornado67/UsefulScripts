#!/bin/bash
# Выбираем хосты из базы заббикса

mysql -h10.124.3.201 -uroot -p -e "select host  from zabbix.hosts where host like '%'" >  hosts.txt

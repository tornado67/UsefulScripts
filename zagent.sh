#!/bin/bash
# просто для облегчения жизни
wget http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb
dpkg -i zabbix-release_3.4-1+stretch_all.deb
apt update 
apt-get install zabbix-agent -y
sed -i.backup -e 's/#.*$//' -e '/^$/d' /etc/zabbix/zabbix_agentd.conf

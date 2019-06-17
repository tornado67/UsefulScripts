-- Выборка хостов в группе R01

select name  from zabbix.hosts where hostid in ( select hostid from zabbix.hosts_groups where groupid in (select groupid  from zabbix.groups where groups.name like 'R01%') );


-- Выбираем соответствие IP  и имени хоста.
SELECT   
    interface.ip,
    interface.dns,
    hosts.name
FROM hosts JOIN interface ON hosts.hostid=interface.hostid WHERE name like '%HOST%'


-- --------------------------------------------------------------------    ДОБАВЛЕНИЕ ХОСТА В ГРУППУ   ---------------------------------------------------------------------------------------------

--Временно делаем поле авторинкрементным.
ALTER TABLE hosts_groups  MODIFY COLUMN hostgroupid bigint(20) auto_increment;
 
--Вставляем то что нужно
INSERT INTO  hosts_groups ( hostgroupid, hostid, groupid) SELECT  0,hostid,'23' FROM hosts WHERE name like '%HOST%';

--Возращаем все как было)))
ALTER TABLE  hosts_groups  MODIFY COLUMN hostgroupid bigint(20);


-- -------------------------------------------------------------------     ДОБАВЛЕНИЕ ХОСТА К ПРОКСИ    ---------------------------------------------------------------------------------------------

UPDATE hosts SET proxy_hostid='43181' --id прокси можно посмотреть во фронтенде.
WHERE 
  (hostid in (select hostid from  (select * from hosts where name like 'R36%') as r36));

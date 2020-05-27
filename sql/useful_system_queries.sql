#Show slave hosts IPs
SELECT * FROM information_schema.PROCESSLIST AS p WHERE p.COMMAND = 'Binlog Dump';

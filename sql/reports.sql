USE reports;
SET @r_date := '2018-06-20';
CREATE TEMPORARY TABLE  IF NOT EXISTS -- Создаем темповую таблицу с движком memory на базе двух самых крупных таблиц.
  r_tt_uptime ( INDEX(ops_index) ) 
ENGINE=MEMORY 
AS (
  SELECT ops_index,time_start,time_end, _name, _begin, _end 
    FROM reports.`r_ops_uptime` as rou
    JOIN reports.`r_time_table` as rtt
      ON rtt._index = rou.ops_index
         
  WHERE rou.report_date = @r_date AND rtt._date = @r_date 
);

SELECT  --Выбираем нужные данные, объединив самую маленькую таблицу с темповой.

     Administration         as 'УФПС',
     PostOffice             as 'Почтамт',
     r_tt_uptime._name      as 'Название ОПС',
     r_tt_uptime.ops_index  as 'Индекс',
     r_tt_uptime._begin     as 'Начало расчетное',
     r_tt_uptime.time_start as 'Начало фактическое',
     r_tt_uptime._end       as 'Конец расчетный' ,
     r_tt_uptime.time_end   as 'Конец фактический' 
     
  FROM r_tt_uptime 
  JOIN reports.`PostIndex` as pi ON  pi.`OPSIndex` = r_tt_uptime.`ops_index`;

DROP TABLE r_tt_uptime;

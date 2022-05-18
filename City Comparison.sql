--Gathering city temperature data for a vizualization
select round(avg(tmax), 2) as AverageMaxTemp, round(avg(tavg), 2) as AverageTemp, month, year,
case
when round(avg(tmax),2) is not null then 'Ketchican'
End as City
from Weather_Comp.dbo.Ketchikan_weather
group by month, year
--order by 3,4

UNION

select round(avg(cast(tmax as decimal)), 2) as AverageMaxTemp, round(avg(cast(tavg as decimal)), 2) as AverageTemp, month(date) as month, year(date) as year,
case
when round(avg(cast(tmax as decimal)),2) > 0 then 'Tucson'
End as City
from Weather_Comp.dbo.Tucson_Temps
where name like '%airport%'
group by month(date), year(date)
order by 5, 3,4;

Create view TucsonTempData as
select*
from Weather_Comp.dbo.Tucson_Temps
where name like '%airport%';

select * from TucsonTempData;

select name, LATITUDE, LONGITUDE, tmax, elevation
from Weather_Comp.dbo.Tucson_Temps
where date = '2021-06-07'
and tmax is not null;

select date, elevation, name
from Weather_Comp.dbo.Tucson_Temps
where tmax is not null;

select round(sum(prcp), 2) as Rainfall, round(avg(tmax), 2) as MaxTemp, month(date) as Month, year(date) as Year,
case
when round(avg(tmax),2) is not null then 'Skagway'
End as City
from Weather_Comp.dbo.Skagway_Temps
group by month(date), year(date)
--order by 1,2;

UNION

select round(sum(prcp), 2) as Rainfall, round(avg(cast(tmax as decimal)), 2) as MaxTemp, month(date) as Month, year(date) as Year,
case
when round(avg(cast(tmax as decimal)),2) is not null then 'Tucson'
End as City
from TucsonTempData
group by month(date), year(date)
order by 5,1,2;
-- This is a SQL project gathering data to later be input into Tableau for vizualization.
-- The resulting dashboard can be seen here: https://public.tableau.com/app/profile/andrew.johns7976/viz/Alaskavs_ArizonaClimateResearch/Dashboard1




--Gathering city temperature data for a vizualization
select round(avg(tmax), 2) as AverageMaxTemp, round(avg(tavg), 2) as AverageTemp, month, year,
case
when round(avg(tmax),2) is not null then 'Ketchican'
End as City
from Weather_Comp.dbo.Ketchikan_weather
group by month, year

UNION

select round(avg(cast(tmax as decimal)), 2) as AverageMaxTemp, round(avg(cast(tavg as decimal)), 2) as AverageTemp, month(date) as month, year(date) as year,
case
when round(avg(cast(tmax as decimal)),2) > 0 then 'Tucson'
End as City
from Weather_Comp.dbo.Tucson_Temps
where name like '%airport%'
group by month(date), year(date)
order by 5, 3,4;

--Gathering City Rainfalls and temperatures for a Vizualization
select round(sum(prcp), 2) as Rainfall, round(avg(tmax), 2) as MaxTemp, month(date) as Month, year(date) as Year,
case
when round(avg(tmax),2) is not null then 'Skagway'
End as City
from Weather_Comp.dbo.Skagway_Temps
group by month(date), year(date)

UNION

select round(sum(prcp), 2) as Rainfall, round(avg(cast(tmax as decimal)), 2) as MaxTemp, month(date) as Month, year(date) as Year,
case
when round(avg(cast(tmax as decimal)),2) is not null then 'Tucson'
End as City
from TucsonTempData
group by month(date), year(date)
order by 5,1,2;

--Creating a View Containg Data for Tucson only,
--previously data for the surrounding area was also included
Create view TucsonTempData as
select*
from Weather_Comp.dbo.Tucson_Temps
where name like '%airport%';

select * from TucsonTempData;

--Gathering location data for a vizualizaion exploring the 
--relationship between elevation and max temperature
select name, LATITUDE, LONGITUDE, tmax, elevation
from Weather_Comp.dbo.Tucson_Temps
where date = '2021-06-07'
and tmax is not null;

Select *
From PorfolioProject.dbo.CovidDeaths
Where continent is not null
order by 3, 4

--Select *
--From PorfolioProject.dbo.CovidVaccinations
--order by 3, 4

Select Location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject.dbo.CovidDeaths
order by 1,2

--Looking at the total cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PorfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at the total cases vs population
--Shows what percentage of population has Covid
Select Location, date, population, total_cases, round((total_cases/population)*100, 2) as PositivePercentage
From PorfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2

--What countries have the highest infection rate
Select Location, population, MAX(total_cases) as HighestInfectionCount, round(MAX((total_cases/population))*100, 2) as PolationInfectionPercentage
From PorfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
group by location, population
order by 4 desc

--Show countries with the highest covid related death count

Select Location, population, MAX(cast(total_deaths as int))as TotalDeathCount, (MAX(total_deaths/total_cases))*100 as DeathPercentage
From PorfolioProject.dbo.CovidDeaths
Where continent is not null
group by location, population
order by 3 desc

--Highest deaths again, but now broken down by contient

Select location, population, MAX(cast(total_deaths as int))as TotalDeathCount, (MAX(total_deaths/total_cases))*100 as DeathPercentage
From PorfolioProject.dbo.CovidDeaths
Where continent is null
group by location, population
order by 3 desc

--Global Numbers

Select Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PorfolioProject.dbo.CovidDeaths
where continent is not null 

--Global numbers organized chronologically
Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(convert(int, new_deaths))/sum(new_cases)*100 as DeathPercentage
from PorfolioProject.dbo.CovidDeaths
where continent is not null 
Group by date
order by 1,2

--Looking at total population vs total vaccination
Select *
From PorfolioProject.dbo.CovidVaccinations vac
Join PorfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingTotalVaccinations
From PorfolioProject.dbo.CovidVaccinations vac
Join PorfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingTotalVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingTotalVaccinations
From PorfolioProject.dbo.CovidVaccinations vac
Join PorfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

Select *, (RollingTotalVaccinations/population)*100 as RollingVaccinationPercentage
From PopvsVac
Order by 1,2,3

--Temp Table
Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulatonVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingTotalVaccinations numeric
)

Insert into PercentPopulatonVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingTotalVaccinations
From PorfolioProject.dbo.CovidVaccinations vac
Join PorfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingTotalVaccinations/population)*100 as RollingVaccinationPercentage
From PercentPopulatonVaccinated
Order by 1,2,3

--Creating View to store data for future vizulaizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location order by dea.location, dea.date) as RollingTotalVaccinations
From PorfolioProject.dbo.CovidVaccinations vac
Join PorfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated
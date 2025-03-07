
USE portfolio;

Go
Select * from portfolio.dbo.CovidDeaths
order by 3,4

Select * from portfolio.dbo.CovidVaccinations
order by 3,4

--select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
from portfolio.dbo.CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolio.dbo.CovidDeaths
where location like '%states%'
order by 1,2

--looking at total cases vs population
--shows what percentage of population got covid
Select Location, date, total_cases, population, (total_cases/population)*100 as PopulationPercentage
from portfolio.dbo.CovidDeaths
--where location like '%states%'
order by 1,2


--looking at countries with highest infection rate compared to population

Select Location,  population, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationPercentageInfected
from portfolio.dbo.CovidDeaths
--where location like '%states%'
Group by Location,  population
order by PopulationPercentageInfected desc

--showing countries with Highest Death Count per population

Select Location,  Max(cast(total_deaths as int)) as TotalDeathCount
from portfolio.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--Lets break things down by continent

Select continent,  Max(cast(total_deaths as int)) as TotalDeathCount
from portfolio.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--showing continents with the highest death count per population

Select continent,  Max(cast(total_deaths as int)) as TotalDeathCount
from portfolio.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc



--Global Numbers
Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths , Sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from portfolio.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2 

--looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolio.dbo.CovidDeaths dea
join portfolio.dbo.CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use cte

With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolio.dbo.CovidDeaths dea
join portfolio.dbo.CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (RollingPeopleVaccinated/population)*100
from PopvsVac

--Temp table

DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolio.dbo.CovidDeaths dea
join portfolio.dbo.CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * , (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolio.dbo.CovidDeaths dea
join portfolio.dbo.CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated 
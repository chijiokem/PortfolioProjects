SELECT *
FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 1,2

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 1,2

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 1,2

--looking at tota lcases vs total deaths (sine the values in total_deaths and total_cases are nvarchar values i used the cast function)
--this shows the liklihood of dying of covid in Africa

SELECT location, date, total_cases, total_deaths, CAST(total_deaths AS float) / CAST(total_cases AS float)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%Africa%'
and continent is not null
ORDER BY 1,2


--looking at total_cases vs population 
-- this looks at the population that has covid

SELECT location, date, population, total_cases,  CAST(total_cases AS float) / CAST(population AS float)*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
where location like '%Africa%'
and continent is not null
ORDER BY 1,2


--looking at countries with highest infection rate compares to the population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX(CAST(total_cases AS float) / CAST(population AS float))*100 as InfectionRate
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY location, population
ORDER BY 4 desc


--locations with the highest deaths

SELECT location, MAX(CAST (total_deaths AS int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY 2 desc


--continents with the highest death count

SELECT continent, MAX(CAST (total_deaths AS int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


--GLOBAL NUMBERS
--total cases and and total deaths around the world

SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
CASE
WHEN sum(new_cases) = 0 THEN 0
ELSE sum(cast(new_deaths as int))/sum(new_cases)*100 
END as TotalDeathPercentage
FROM PortfolioProject..CovidDeaths
--where location like '%Africa%'
where continent is not null
--group by date
ORDER BY 1,2 


--deaths around the world sorted by date

SELECT date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
CASE
WHEN sum(new_cases) = 0 THEN 0
ELSE sum(cast(new_deaths as int))/sum(new_cases)*100 
END as DeathPercentage
FROM PortfolioProject..CovidDeaths
--where location like '%Africa%'
where continent is not null
group by date
ORDER BY 1,2 


--JOIN OPERATION
--looking at the total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVac
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
order by 2, 3

--USE CTE

with PopvsVac(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVac)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVac
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeopleVac/Population)*100
from PopvsVac


--TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
Continent varchar (255),
Location varchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVac numeric
)

insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVac
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3
SELECT *, (RollingPeopleVac/Population)*100
from #PercentPopulationVaccinated



--CREATING VIEW TO STORE DATA FOR VISUALIZATION

create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVac
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3


select *
from PercentPopulationVaccinated
SELECT *
FROM [Portfolio Project]..CovidDeaths
ORDER BY 3,4

SELECT *
FROM [Portfolio Project]..CovidVaccinations
ORDER BY 3,4

--select data that we are going to use

SELECT Location, date, total_cases, new_cases,total_deaths, population 
FROM [Portfolio Project]..CovidDeaths

--Looking at total cases and total deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/cast(total_cases as float))*100 as Deathpercentage
FROM [Portfolio Project]..CovidDeaths
where location like '%states%'
ORDER BY 1,2

--Looking at total cases vs population 
SELECT Location, date, total_cases, population, (total_cases/CAST(population AS FLOAT))*100 Populationinfected_percentage
FROM [Portfolio Project]..CovidDeaths
Order by 1,2

--showing countries with highestinfection rate compared to population
select Location,population, MAX(total_cases) Highestinfected, MAX((total_cases/CAST(population AS FLOAT)))*100 Populationinfected_percentage
FROM [Portfolio Project]..CovidDeaths
GROUP BY location, population
Order by 4 desc--Populationinfected_percentage desc

--showing countries with highest death count per population
SELECT Location, max(total_deaths) as totaldeathcount 
FROM [Portfolio Project]..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY totaldeathcount DESC;

--Showing continents with highest death count over population
SELECT continent, max(total_deaths) as totaldeathcount 
FROM [Portfolio Project]..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY totaldeathcount DESC;


--Looking for totaldeath Percentage

SELECT sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, (cast(sum(new_deaths) as float)/sum(new_cases))*100 AS totaldeathpercentage
FROM [Portfolio Project]..CovidDeaths
where continent is not null
--GROUP BY date
--ORDER BY date asc;

SELECT*
FROM [Portfolio Project]..CovidVaccinations

--
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as totalnewvaccination, (cast(sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as float)/population)*100 vaccinatedpercent
FROM [Portfolio Project]..CovidDeaths DEA
JOIN [Portfolio Project]..CovidVaccinations VAC
	ON DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
ORDER BY 2,3;

--CTE

with popvsvacc as
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as totalnewvaccination, (cast(sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as float)/population)*100 vaccinatedpercent
FROM [Portfolio Project]..CovidDeaths DEA
JOIN [Portfolio Project]..CovidVaccinations VAC
	ON DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
--ORDER BY 2,3
)
SELECT* 
FROM popvsvacc;

--Temp Table
DROP TABLE IF EXISTS  #Percentpopulationvaccinated
CREATE TABLE #Percentpopulationvaccinated
(
continent varchar(50),
location varchar(50),
date datetime,
population numeric,
new_vaccinations numeric,
totalnewvaccination numeric,
vaccinatedpercent float
)

INSERT INTO #Percentpopulationvaccinated
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, cast(sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as float) as totalnewvaccination, (cast(sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as float)/population)*100 vaccinatedpercent
FROM [Portfolio Project]..CovidDeaths DEA
JOIN [Portfolio Project]..CovidVaccinations VAC
	ON DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
--ORDER BY 2,3
SELECT*
FROM #Percentpopulationvaccinated

--Creating views to store data for later visualizations

CREATE VIEW Percentpopulationvaccinated as
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, cast(sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as float) as totalnewvaccination, (cast(sum(VAC.new_vaccinations) over(partition by DEA.location order by DEA.location, DEA.date) as float)/population)*100 vaccinatedpercent
FROM [Portfolio Project]..CovidDeaths DEA
JOIN [Portfolio Project]..CovidVaccinations VAC
	ON DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
--ORDER BY 2,3

SELECT *
FROM Percentpopulationvaccinated











 
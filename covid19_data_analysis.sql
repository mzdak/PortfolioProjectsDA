SELECT * 
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

SELECT * 
FROM CovidVaccinations
ORDER BY 3,4

--Select Data To Be Used
SELECT LOCATION, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
where continent is not null
ORDER BY 1,2


--Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT LOCATION, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE LOCATION = 'INDIA' OR location = 'INDONESIA' OR location LIKE '%SAUDI%'
ORDER BY 1,2


--Looking at total cases vs population
SELECT LOCATION, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM CovidDeaths
WHERE LOCATION = 'INDIA'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population
SELECT LOCATION, MAX(total_cases) as HighestInfectionCount, population, (MAX(total_cases)/population)*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with highest death count per population
SELECT LOCATION, MAX(cast(total_deaths as int)) as HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT null
GROUP BY location
ORDER BY HighestDeathCount DESC

-- Breaking things down by continent
-- Continent with the highest death count
SELECT location, MAX(cast(total_deaths as int)) as HighestDeathCount
FROM CovidDeaths
WHERE continent IS null
GROUP BY location
ORDER BY HighestDeathCount DESC

-- Global Numbers
SELECT date, sum(new_cases) as TotalCases, SUM(cast(new_deaths as int)) TotalDeaths, 
	(SUM(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
FROM CovidDeaths
where continent is not null
group by date
ORDER BY 1


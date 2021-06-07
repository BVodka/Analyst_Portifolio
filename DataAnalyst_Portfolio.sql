SELECT * FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3, 4



--SELECT * FROM PortifolioProject..covid_vaccinations
--ORDER BY 3,4 

-- Select the data we will be using for analysis

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


--- Looking at Total Cases vs Total Deaths
--- Shows the likelihood of dying if you contact COVID
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortifolioProject..covid_deaths
WHERE Location LIKE '%geria%' AND continent IS NOT NULL
ORDER BY 1, 2

--- Looking at Total Cases vs Population
SELECT Location, date, total_cases, Population , (total_cases / Population) * 100 AS DeathPercentage
FROM PortifolioProject..covid_deaths
WHERE Location LIKE '%geria%' AND continent IS NOT NULL
ORDER BY 1, 2

--- Looking at countries with highest infection rates
SELECT Location, Population, MAX(total_cases) as HighInfectionCount , MAX(total_cases / Population) * 100 AS PercentageofPopulationInfected, MAX(total_deaths) * 100 AS MaximumMortality
FROM PortifolioProject..covid_deaths
--WHERE Location LIKE '%geria%'
WHERE continent IS NOT NULL
GROUP BY Location , Population
ORDER BY PercentageofPopulationInfected DESC; 
--- ORDER BY MaximumMortality

--- Showing Countries with the Highest Death Count per Population
--- Looking at countries with highest infection rates
SELECT Location, Population , MAX(total_cases / Population) * 100 AS PercentageofPopulationInfected, MAX(total_deaths /Population)* 100 AS DeathPerPop
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY Location , Population
ORDER BY DeathPerPop DESC; 
--- ORDER BY MaximumMortality


--- Showing Countries with the Highest Death Count per Population
--- Looking at countries with highest infection rates
SELECT Location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY Location 
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality

--- Detailing by continents and nations total deaths
--- Looking at countries with highest infection rates
SELECT Location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
--WHERE continent IS NOT NULL
GROUP BY location , continent
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality


--- Detailing by continents total deaths by continents
--- Looking at countries with highest infection rates
SELECT Location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
WHERE continent IS NULL
GROUP BY location , continent
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality

--- Showing the continents with the highest death counts
--- Detailing by continents total deaths by continents
--- Looking at countries with highest infection rates
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality


----------------------------------------
----------------------------------------
----------------------------------------

--Creating views for drill downs by continents

SELECT Location, continent, date, total_cases, new_cases, total_deaths, population
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


--- Looking at Total Cases vs Total Deaths
--- Shows the likelihood of dying if you contact COVID
SELECT Location, continent, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

--- Looking at Total Cases vs Population
SELECT Location,continent, date, total_cases, Population , (total_cases / Population) * 100 AS DeathPercentage
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

--- Looking at countries with highest infection rates
SELECT Location, continent, Population, MAX(total_cases) as HighInfectionCount , MAX(total_cases / Population) * 100 AS PercentageofPopulationInfected, MAX(total_deaths) * 100 AS MaximumMortality
FROM PortifolioProject..covid_deaths
--WHERE Location LIKE '%geria%'
WHERE continent IS NOT NULL
GROUP BY Location , continent, population
ORDER BY PercentageofPopulationInfected DESC; 
--- ORDER BY MaximumMortality

--- Showing Countries with the Highest Death Count per Population
--- Looking at countries with highest infection rates
SELECT Location,continent, Population , MAX(total_cases / Population) * 100 AS PercentageofPopulationInfected, MAX(total_deaths /Population)* 100 AS DeathPerPop
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY Location , continent, Population
ORDER BY DeathPerPop DESC; 
--- ORDER BY MaximumMortality


--- Showing Countries with the Highest Death Count per Population
--- Looking at countries with highest infection rates
SELECT Location, continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY Location , continent
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality

--- Detailing by continents and nations total deaths
--- Looking at countries with highest infection rates
SELECT Location, continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
--WHERE continent IS NOT NULL
GROUP BY location , continent
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality


--- Detailing by continents total deaths by continents
--- Looking at countries with highest infection rates
SELECT Location,continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortifolioProject..covid_deaths
WHERE continent IS  NULL
GROUP BY location , continent
ORDER BY TotalDeathCount DESC; 
--- ORDER BY MaximumMortality


-----GLOBAL NUMBERS  --- need to sort out an error here
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortifolioProject..covid_deaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2


----- Looking at total population versus vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, 
  dea.date) AS RollingPeopleVaccinated
 --- ,(RollingPeopleVaccinated/population)* 100
FROM PortifolioProject..covid_deaths dea
JOIN PortifolioProject..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

--- USE CTE
WITH PopvsVac (continent, location, date, population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, 
  dea.date) AS RollingPeopleVaccinated
 --- ,(RollingPeopleVaccinated/population)* 100
FROM PortifolioProject..covid_deaths dea
JOIN PortifolioProject..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/population) * 100
FROM PopvsVac

---TEMP TABLE
DROP TABLE IF EXISTS #PercentagePopulationVaccinated

CREATE TABLE #PercentagePopulationVaccinated
(
 continent nvarchar(255),
 location nvarchar(255),
 DATE datetime,
 Population numeric ,
 new_vaccinations numeric, 
 RollingPeopleVaccinated numeric
 )

INSERT INTO #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, 
  dea.date) AS RollingPeopleVaccinated
 --- ,(RollingPeopleVaccinated/population)* 100
FROM PortifolioProject..covid_deaths dea
JOIN PortifolioProject..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

SELECT *, (RollingPeopleVaccinated/population) * 100
FROM #PercentagePopulationVaccinated 


--- Create views to store data for visualization 

Create View PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, 
  dea.date) AS RollingPeopleVaccinated
 --- ,(RollingPeopleVaccinated/population)* 100
FROM PortifolioProject..covid_deaths dea
JOIN PortifolioProject..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

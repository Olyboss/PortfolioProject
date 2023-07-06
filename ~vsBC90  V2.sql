
Select *
From [Portfolio Project]..[Covid death]
order By 3,4


--Select *
--From [Portfolio Project]..[Covid vaccination]
--order By 3,4


-- Select the Data that we are going to be using



Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..[Covid death]
order By 1,2


-- looking at Total Cases vs Total Deaths
-- Show likelihood of dying if you contact covid in your country


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..[Covid death]
Where location like %States%
order By 1,2


-- Looking at Total cases vs population
-- Shows what percentage of population got covid

Select Location, date, population, total_cases, (total_cases/population)*100 as percentpopulationinfected
From [Portfolio Project]..[Covid death]
--Where location like %spain%
order By 1,2

-- Looking at country with Highest Onfection Rate compared to population


Select Location, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as percentpopulationinfected
From [Portfolio Project]..[Covid death]
--Where location like %spain%
Group By location, population 
order By percentpopulationinfected desc

-- showing Counttry with the Highest Death Count per population


Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..[Covid death]
--Where location like %spain%
where continent is not null
Group By location
order By TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

-- showing the continents with the highest death per population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..[Covid death]
--Where location like %spain%
where continent is not null
Group By continent
order By TotalDeathCount desc


--GLOBAL NUMBERS

 
 
Select date, SUM(new_cases), SUM(new_deaths), as DeathPercentage
From [Portfolio Project]..[Covid death]
--Where location like %UnitedState%
where continent is not null
Group By date
order By 1,2


-- Looking at Total population vs Vaccinations

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated) 
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..[Covid death] dea
Join [Portfolio Project]..[Covid vaccination] vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	--order By 2,3
)

select *, (RollingPeopleVaccinated/population)*100
From popvsVac









-- TEMP TABLE


Create Table #percentpopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
Rollingpeoplevaccinated numeric
)

Insert into #PercentpopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..[Covid death] dea
Join [Portfolio Project]..[Covid vaccination] vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	--order By 2,3



select *, (RollingPeopleVaccinated/population)*100
From #PercentpopulationVaccinated




-- cfeating view to store data for later visualizations

Create view PercentpopulationVaccinated1 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..[Covid death] dea
Join [Portfolio Project]..[Covid vaccination] vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	--order By 2,3


Select *
From PercentpopulationVaccinated1
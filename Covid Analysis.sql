select *
from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--selecting data that we are going to use

select location,date,total_cases,new_cases,total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking for total Cases Vs Total Deaths in India
--Shows the percentage of Total Deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location='India'
order by 1,2

--Looking at Total Cases Vs Population in India
--Shows the percentage of population infected by Covid

select location,date,population,total_cases,(total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths$
where location='India'
order by 1,2

--Looking at countries with Highest Infection rate compared to Population

select location,population,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths$
group by location, population
order by InfectedPercentage Desc

--Looking at countries with highest death count per population

select location,max(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeathcount Desc

--Let's break things down by continent
--Looking at Continents with highest death count per population

select continent,max(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathcount Desc

--GLOBAL NUMBERS

select sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--group by Date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

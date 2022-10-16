select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


select location, date, total_cases, new_cases,total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select location, date, total_cases,total_deaths, round((total_deaths/total_cases) * 100,2) as deaths_percentages
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select location, date, total_cases,total_deaths, round((total_deaths/total_cases) * 100,2) as deaths_percentages
from PortfolioProject..CovidDeaths
where continent is not null and location = 'Egypt'
order by 1,2

-- percentages of population in egypt get covid
select location, date, total_cases,population, round((total_cases/population) * 100,2) as case_percentages
from PortfolioProject..CovidDeaths
where location = 'Egypt'
order by 1,2

-- Countries with heighist infection rate compared to population
select location, population, MAX(total_cases) as heigh_infection, MAX((total_cases/population)) * 100 as population_infected
from PortfolioProject..CovidDeaths
where continent is not null
group by location , population
order by population_infected desc

-- Couontries with heighist death count per population
select location, MAX(cast(total_deaths as int)) as total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by location 
order by total_death_count desc

-- Break things down by continent
select location, MAX(cast(total_deaths as int)) as total_death_count
from PortfolioProject..CovidDeaths
where continent is null
group by location 
order by total_death_count desc


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
Group By date
order by 1,2



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2


select * 
from PortfolioProject..CovidVaccination
order by 3,4

select * 
from PortfolioProject..CovidDeaths dea
join  portfolioProject..CovidVaccination vac 
on dea.location = vac.location
and dea.date = vac.date

-- population vs vaccination
 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join  portfolioProject..CovidVaccination vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(convert(int ,vac.new_vaccinations)) OVER(partition by dea.location ORDER by dea.location,dea.date) as total_vaccinated
from PortfolioProject..CovidDeaths dea
join  portfolioProject..CovidVaccination vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, total_vaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(convert(int ,vac.new_vaccinations)) OVER(partition by dea.location ORDER by dea.location,dea.date) as total_vaccinated
from PortfolioProject..CovidDeaths dea
join  portfolioProject..CovidVaccination vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *, (total_vaccinated/Population)*100
From PopvsVac

-- COVID DEATHS

select * from coviddeath
order by 3,4;

-- Select Data to be used
Select location, date, total_cases, new_cases, total_deaths, population
from coviddeath
order by 1,2;

-- Looking at total cases vs total deaths
-- Shows the liklihood of dying if Covid is contracted in the United Kingdom

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percent
from coviddeath
where location like '%kingdom%'
order by 1,2;

-- Looking at the total cases vs the population
-- Shows what percentage of population got Covid in the United Kingdom

Select location, date, total_cases, population, (total_cases/population)*100 AS Population_percent
from coviddeath
-- where location like '%kingdom%'
order by 1,2;

-- Looking at Countries with highest infection rates compared to population

Select location, population, MAX(total_cases) AS Highest_infection_count , MAX(total_cases/population)*100 AS Population_percentInfected
from coviddeath
group by location, population
order by Population_percentInfected desc;

Select location, population, date, MAX(total_cases) AS Highest_infection_count , MAX(total_cases/population)*100 AS Population_percentInfected
from coviddeath
group by location, population, date
order by Population_percentInfected desc;

-- Showing countries with highest death count per population

ALTER TABLE coviddeath
MODIFY COLUMN total_deaths INT;

Select location, MAX(total_deaths) AS Total_death_count
from coviddeath
where continent != ''
group by location
order by Total_death_count desc;

-- breaking down by continent
-- Showing continents with the highest death count per population

Select continent, MAX(total_deaths) AS Total_death_count
from coviddeath 
where continent != '' 
group by continent
order by Total_death_count desc;

-- GLOBAL NUMBERS

ALTER TABLE coviddeath
MODIFY COLUMN new_deaths INT;

Select SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS Death_Percent
from coviddeath
-- where location like '%kingdom%'
where continent != '' 
-- group by date
order by 1,2;

-- COVID VACCINATIONS
select * from covidvacc
order by 3,4;

-- Looking at Total Population vs Vaccinations

SET SQL_SAFE_UPDATES = 0;

UPDATE covidvacc
SET new_vaccinations = 0
WHERE new_vaccinations = '';

ALTER TABLE covidvacc
MODIFY COLUMN new_vaccinations INT;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date)
 AS RollingPeopleVaccinated
from coviddeath dea
join covidvacc vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent != ''
order by 2,3;

-- Using CTE

With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date)
 AS RollingPeopleVaccinated
from coviddeath dea
join covidvacc vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent != ''
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 from PopvsVac;

-- With Temp Table

Drop table if exists PercentPopulationVaccinated;

Create Table PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);
Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, STR_TO_DATE(dea.date, '%d/%m/%Y') AS Date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date)
 AS RollingPeopleVaccinated
from coviddeath dea
join covidvacc vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent != '';


Select *, (RollingPeopleVaccinated/Population)*100 from PercentPopulationVaccinated;

-- creating a view

create view PercentPopulationVaccinated1 as
Select dea.continent, dea.location, STR_TO_DATE(dea.date, '%d/%m/%Y') AS Date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date)
 AS RollingPeopleVaccinated
from coviddeath dea
join covidvacc vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent != '';













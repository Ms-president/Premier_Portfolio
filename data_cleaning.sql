-- DATA CLEANING

Select*
from layoffs;
-- 0. create a staging database; best practice to keep the raw data intact
-- 1. remove duplicates
-- 2. standardize the data
-- 3. remove null values or blank values
-- 4. remove any irrelevant columns


-- CREATE A STAGING DATABASE
create table layoffs_staging
like layoffs;

Select*
from layoffs_staging;

insert layoffs_staging
select*
from layoffs;


-- REMOVE DUPLICATES
Select*,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
from layoffs_staging;
WITH DUPLICATE_CTE AS
(
Select*,
row_number() over(
partition by company, location, 
industry, total_laid_off, percentage_laid_off, 'date', stage, 
country, funds_raised_millions) as row_num
from layoffs_staging
)
SELECT*
FROM duplicate_CTE
WHERE row_num >1;

SELECT*
FROM layoffs_staging
WHERE company='casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
FROM layoffs_staging2;

insert into layoffs_staging2
Select*,
row_number() over(
partition by company, location, 
industry, total_laid_off, percentage_laid_off, 'date', stage, 
country, funds_raised_millions) as row_num
from layoffs_staging;

delete
FROM layoffs_staging2
where row_num>1;

select*
FROM layoffs_staging2;

-- standardize the data

select company, trim(company)
FROM layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct (industry)
FROM layoffs_staging2
order by 1;

select*
from layoffs_staging2
where industry like 'crypto%';

Update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';

select distinct country, trim(trailing '.' from country)
FROM layoffs_staging2
order by 1;

Update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select distinct country,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;


select `date`
from layoffs_staging2
order by 1;

Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- to change date text to digit
alter table layoffs_staging2
modify column `date` date;

-- remove null values or blank values (fill in fillable data using join statement)
select *
from layoffs_staging2;

update layoffs_staging2
set industry = null
where industry = '';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
where (t1.industry is null)
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null)
and t2.industry is not null;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- remove any irrelevant columns
select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;

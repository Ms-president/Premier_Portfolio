# Data Cleaning With mySQL

## Project Overview
This project showcases my approach to cleaning and preparing raw datasets for analysis. It involves identifying and handling missing values, correcting data types, removing duplicates, dealing with outliers, and standardizing formatting to ensure data quality and consistency. The goal is to transform messy, real-world data into a clean and structured format suitable for further analysis or machine learning

## 📦 Dataset: `world_layoffs.csv` [here](kaggle.com)

The dataset includes:
- Company names
- Headquarters (city, country)
- Industry
- Total number of layoffs
- Dates of layoffs
- Percentage of workforce affected
- Additional relevant metadata

## 🧼 Key Cleaning Tasks Performed

- ✅ Removed duplicate records
- ✅ Handled missing/null values
- ✅ Standardized column names and data formatting
- ✅ Converted data types (e.g., date parsing, numeric conversion)
- ✅ Treated outliers and inconsistent entries
- ✅ Filtered ambiguous or incomplete records


## 🛠️ Tools and Technologies

- MySQL (Structured Query Language)

All data cleaning was performed using SQL queries in MySQL.

## Data Analysis - Excerpt
```SQL
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
```

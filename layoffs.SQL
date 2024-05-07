-- Steps in this Project to Clean Data:
-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Handle Null and Blank Values

SELECT * FROM layoffs l 

--Remove Duplicates

WITH new_table AS
(
SELECT*, ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs l)
SELECT * 
FROM new_table
WHERE row_num > 1

DELETE FROM layoffs 
WHERE rowid NOT IN (
  SELECT MIN(rowid) 
  FROM layoffs  
  GROUP BY company, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
)

--Standardize Data

SELECT company, TRIM(company)
from layoffs l 

UPDATE layoffs 
SET company  = TRIM(company)


SELECT DISTINCT industry
from layoffs l 
ORDER BY 1

UPDATE layoffs 
SET industry = "Crypto"
WHERE industry LIKE "Crypto%"

SELECT DISTINCT country
from layoffs l 
ORDER BY 1

UPDATE layoffs 
SET country = "United States"
Where country = "United States."

--Handle Null and Blank Values

Select *
From layoffs l 
Where total_laid_off = "NULL" And percentage_laid_off ="NULL"

DELETE
From layoffs  
Where total_laid_off = "NULL" And percentage_laid_off ="NULL"


Select *
From layoffs l 
WHERE industry ="NULL" or industry = ''


SELECT * 
from layoffs l 
JOIN layoffs l2
	ON l.company = l2.company
WHERE (l.industry ="NULL" OR l.industry = '')
AND l2.industry <> "NULL"

UPDATE layoffs 
SET industry = "Travel"
WHERE company = "Airbnb"

UPDATE layoffs 
SET industry = "Consumer"
WHERE company = "Juul"

UPDATE layoffs 
SET industry = "Transportation"
WHERE company = "Carvana"


--Explore Data

SELECT total_laid_off 
FROM layoffs l 
ORDER BY total_laid_off DESC

SELECT *
FROM layoffs l 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC

SELECT company, SUM(total_laid_off)
FROM layoffs l 
GROUP BY company 
ORDER BY 2 DESC

SELECT industry, SUM(total_laid_off)
FROM layoffs l 
GROUP BY industry 
ORDER BY 2 DESC

SELECT country, SUM(total_laid_off)
FROM layoffs l 
GROUP BY country 
ORDER BY 2 DESC

Select *
from layoffs l 

SELECT company, AVG(percentage_laid_off)
FROM layoffs l 
GROUP BY company 
ORDER BY 2 DESC

Select *
FROM layoffs l 
Where date ="NULL"


--Add Year Column

ALTER TABLE layoffs ADD COLUMN Year

SELECT SUBSTR(date, LENGTH(date)-3, LENGTH(date)-4)
from layoffs l 

UPDATE layoffs 
SET Year = SUBSTR(date, LENGTH(date)-3, LENGTH(date)-4)

--Layoffs by Company and Year. Ranking the top 5 companies who had the most layoffs per each year in 2020-2023

SELECT company, Year, SUM(total_laid_off)
FROM layoffs l 
GROUP BY company, Year
ORDER BY 3 DESC

WITH Company_Year (company, Year, total_laid_off) AS
(
SELECT company, Year, SUM(total_laid_off)
FROM layoffs l 
GROUP BY company, Year
ORDER BY 3 DESC
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY Year ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE Year <> ''
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5





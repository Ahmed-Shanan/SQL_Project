-- january 
CREATE TABLE january_jobs AS    
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- february
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- march
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select job_posted_date 
from january_jobs;    

-----------------------------------------------------------------------

WITH required_skills AS (
    SELECT company_dim.company_id,
    COUNT(DISTINCT skills_job_dim.skill_id) AS unique_skills_count
    FROM company_dim
    LEFT JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    GROUP BY company_dim.company_id
),

max_salary AS (
    SELECT 
    job_postings_fact.company_id,
    MAX(salary_year_avg) as highest_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    GROUP BY job_postings_fact.company_id
)

SELECT 
    company_dim.company_id,
    company_dim.name,
    required_skills.unique_skills_count,
    max_salary.highest_salary
FROM company_dim
LEFT JOIN required_skills ON company_dim.company_id = required_skills.company_id
LEFT JOIN max_salary ON company_dim.company_id = max_salary.company_id  
ORDER BY company_dim.name;

---------------------------------------------------------------------------

SELECT 
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE quarter1_job_postings.salary_year_avg > 70000
AND quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY quarter1_job_postings.salary_year_avg DESC;

---------------------------------------------------------------------------

SELECT 
    job_id,
    job_title_short,
    'with_salary_info' AS salary_info
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
OR salary_hour_avg IS NOT NULL

UNION ALL

SELECT 
    job_id,
    job_title_short,
    'without_salary_info' AS salary_info
FROM job_postings_fact
WHERE salary_year_avg IS NULL
OR salary_hour_avg IS NULL

---------------------------------------------------------------------------


SELECT 
    quarter1_job_postings.job_id,
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
LEFT JOIN skills_job_dim ON quarter1_job_postings.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE quarter1_job_postings.salary_year_avg > 70000
ORDER BY quarter1_job_postings.job_id;

---------------------------------------------------------------------------

SELECT 
    COUNT(DISTINCT quarter1_job_postings.job_id) AS total_jobs,
    skills_dim.skills,
    EXTRACT(MONTH FROM quarter1_job_postings.job_posted_date) AS month,
    EXTRACT(YEAR FROM quarter1_job_postings.job_posted_date) AS year
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
LEFT JOIN skills_job_dim ON quarter1_job_postings.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY 
    skills_dim.skills,
    EXTRACT(MONTH FROM quarter1_job_postings.job_posted_date),
    EXTRACT(YEAR FROM quarter1_job_postings.job_posted_date)
ORDER BY 
    skills_dim.skills,
    year,
    month;

---------------------------------------------------------------------------

WITH combined_job_postings AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
),

monthy_job_demand AS (
    SELECT 
    skills_dim.skills,
    EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,
    EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,
    COUNT(DISTINCT combined_job_postings.job_id) AS postings_count
    FROM combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
    skills_dim.skills,
    year,
    month   
)

SELECT
skills,
year,
month,
postings_count
FROM monthy_job_demand
ORDER BY
skills,
year,
month;

---------------------------------------------------------------------------
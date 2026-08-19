/*
 **Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 
 
 - Identify skills in high demand and associated with high average salaries for Data Analyst roles
 - Concentrates on remote positions with specified salaries
 - Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
 */
WITH skill_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS postings_count
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY skills_dim.skill_id
), top_paying_jobs AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY skills_dim.skill_id
) 

SELECT 
    skill_demand.skill_id,
    skill_demand.skills,
    skill_demand.postings_count,
    top_paying_jobs.average_salary
FROM skill_demand
    INNER JOIN top_paying_jobs ON skill_demand.skill_id = top_paying_jobs.skill_id
ORDER BY skill_demand.postings_count DESC,
    top_paying_jobs.average_salary DESC
LIMIT 25;


/*
[
  {
    "skill_id": 0,
    "skills": "sql",
    "postings_count": "398",
    "average_salary": "97237"
  },
  {
    "skill_id": 181,
    "skills": "excel",
    "postings_count": "256",
    "average_salary": "87288"
  },
  {
    "skill_id": 1,
    "skills": "python",
    "postings_count": "236",
    "average_salary": "101397"
  },
  {
    "skill_id": 182,
    "skills": "tableau",
    "postings_count": "230",
    "average_salary": "99288"
  },
  {
    "skill_id": 5,
    "skills": "r",
    "postings_count": "148",
    "average_salary": "100499"
  },
  {
    "skill_id": 183,
    "skills": "power bi",
    "postings_count": "110",
    "average_salary": "97431"
  },
  {
    "skill_id": 7,
    "skills": "sas",
    "postings_count": "63",
    "average_salary": "98902"
  },
  {
    "skill_id": 186,
    "skills": "sas",
    "postings_count": "63",
    "average_salary": "98902"
  },
  {
    "skill_id": 196,
    "skills": "powerpoint",
    "postings_count": "58",
    "average_salary": "88701"
  },
  {
    "skill_id": 185,
    "skills": "looker",
    "postings_count": "49",
    "average_salary": "103795"
  },
  {
    "skill_id": 188,
    "skills": "word",
    "postings_count": "48",
    "average_salary": "82576"
  },
  {
    "skill_id": 80,
    "skills": "snowflake",
    "postings_count": "37",
    "average_salary": "112948"
  },
  {
    "skill_id": 79,
    "skills": "oracle",
    "postings_count": "37",
    "average_salary": "104534"
  },
  {
    "skill_id": 61,
    "skills": "sql server",
    "postings_count": "35",
    "average_salary": "97786"
  },
  {
    "skill_id": 74,
    "skills": "azure",
    "postings_count": "34",
    "average_salary": "111225"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "postings_count": "32",
    "average_salary": "108317"
  },
  {
    "skill_id": 192,
    "skills": "sheets",
    "postings_count": "32",
    "average_salary": "86088"
  },
  {
    "skill_id": 215,
    "skills": "flow",
    "postings_count": "28",
    "average_salary": "97200"
  },
  {
    "skill_id": 8,
    "skills": "go",
    "postings_count": "27",
    "average_salary": "115320"
  },
  {
    "skill_id": 199,
    "skills": "spss",
    "postings_count": "24",
    "average_salary": "92170"
  },
  {
    "skill_id": 22,
    "skills": "vba",
    "postings_count": "24",
    "average_salary": "88783"
  },
  {
    "skill_id": 97,
    "skills": "hadoop",
    "postings_count": "22",
    "average_salary": "113193"
  },
  {
    "skill_id": 233,
    "skills": "jira",
    "postings_count": "20",
    "average_salary": "104918"
  },
  {
    "skill_id": 9,
    "skills": "javascript",
    "postings_count": "20",
    "average_salary": "97587"
  },
  {
    "skill_id": 195,
    "skills": "sharepoint",
    "postings_count": "18",
    "average_salary": "81634"
  }
]
*/

---------------------------------------------------------------------------
WITH skills_demand AS (
    SELECT skills_dim.skills,
        skills_dim.skill_id,
        COUNT(job_postings_fact.job_id) AS postings_count
    FROM skills_dim
        INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
        INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE job_title_short = 'Data Analyst'
    GROUP BY skills_dim.skill_id
),
top_paying_jobs AS (
    SELECT skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
    FROM skills_dim
        INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
        INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        aND job_postings_fact.job_location = 'Anywhere'
    GROUP BY skills_dim.skill_id
)
SELECT skills_demand.skills,
    skills_demand.postings_count,
    top_paying_jobs.average_salary
FROM skills_demand
    INNER JOIN top_paying_jobs ON skills_demand.skill_id = top_paying_jobs.skill_id
ORDER BY skills_demand.postings_count DESC,
    top_paying_jobs.average_salary DESC
LIMIT 10;
/*
 [
 {
 "skills": "sql",
 "postings_count": "92628",
 "average_salary": "97237"
 },
 {
 "skills": "excel",
 "postings_count": "67031",
 "average_salary": "87288"
 },
 {
 "skills": "python",
 "postings_count": "57326",
 "average_salary": "101397"
 },
 {
 "skills": "tableau",
 "postings_count": "46554",
 "average_salary": "99288"
 },
 {
 "skills": "power bi",
 "postings_count": "39468",
 "average_salary": "97431"
 },
 {
 "skills": "r",
 "postings_count": "30075",
 "average_salary": "100499"
 },
 {
 "skills": "sas",
 "postings_count": "14034",
 "average_salary": "98902"
 },
 {
 "skills": "sas",
 "postings_count": "14034",
 "average_salary": "98902"
 },
 {
 "skills": "powerpoint",
 "postings_count": "13848",
 "average_salary": "88701"
 },
 {
 "skills": "word",
 "postings_count": "13591",
 "average_salary": "82576"
 }
 ]
 */
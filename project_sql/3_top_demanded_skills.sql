/*
 **Question: What are the most in-demand skills for data analysts?**
 
 - Identify the top 5 in-demand skills for a data analyst.
 - Focus on all job postings.
 - Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.
 */
 
SELECT skills_dim.skills,
    COUNT(DISTINCT combined_job_postings.job_id) AS postings_count
FROM (
        SELECT job_id,
            job_posted_date
        FROM job_postings_fact
    ) AS combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    INNER JOIN job_postings_fact ON combined_job_postings.job_id = job_postings_fact.job_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY postings_count DESC
LIMIT 5;


SELECT skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS postings_count
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY postings_count DESC
LIMIT 5;
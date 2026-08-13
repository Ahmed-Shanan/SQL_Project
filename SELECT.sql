SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS avg_yearly_salary, 
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM job_postings_fact
WHERE job_posted_date :: DATE > '2023-06-01' 
GROUP BY 
    job_schedule_type
ORDER BY 
    job_schedule_type ASC;


select 
    count(job_id) AS total_jobs,
    extract(month from job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month
FROM 
    job_postings_fact
group by 
    month 
order by 
    month ASC;



select
company_dim.name as compnay_name,
count(job_postings_fact.job_id) as job_posted_count
from
job_postings_fact
inner join
company_dim on job_postings_fact.company_id = company_dim.company_id
where job_health_insurance is TRUE
and extract(year from job_posted_date) = 2023
and extract(quarter from job_posted_date) = 2
group by
    company_dim.name
having
    count(job_postings_fact.job_id) > 0    
order by
    job_posted_count DESC;


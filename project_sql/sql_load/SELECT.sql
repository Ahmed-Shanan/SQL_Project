SELECT 
    job_id, 
    job_title,
    salary_year_avg, 
    case 
        when salary_year_avg > 100000 then 'high salary'
        when salary_year_avg >= 60000 then 'Standard salary'
        when salary_hour_avg < 60000 then 'low salary'
    end as salary_category    
from 
job_postings_fact
where 
    salary_year_avg is not null
    and job_title = 'Data Analyst'
    order by 
    salary_year_avg desc;    


SELECT 
    count(DISTINCT(company_dim.company_id)) as total_companies,
    --job_postings_fact.job_work_from_home,
    case 
        when job_postings_fact.job_work_from_home = TRUE then 'Remote'
        when job_postings_fact.job_work_from_home = FALSE then 'Onsite'
    end as work_location
from 
    job_postings_fact 
inner join 
    company_dim on job_postings_fact.company_id = company_dim.company_id  
group by 
    job_postings_fact.job_work_from_home;    


select 
    count(DISTINCT case when job_work_from_home = TRUE then company_id end) as remote_companies,
    count(DISTINCT case when job_work_from_home = FALSE then company_id end) as onsite_companies
from 
    job_postings_fact  

select 
count(distinct company_id) as total_companies,
case 
    when job_work_from_home = TRUE then 'Remote'
    when job_work_from_home = FALSE then 'Onsite'
end as work_location
from 
    job_postings_fact  
GROUP BY
    job_work_from_home;    



select 
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title like '%Senior%' THEN 'Senior'
        WHEN job_title like '%Lear%' 
        OR job_title like '%Manager%' THEN 'Lead/Manager'
        WHEN job_title like '%Junior%' 
        OR job_title like'%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specificed'
    END AS experience_level,
    CASE
        WHEN job_work_from_home is TRUE THEN 'Yes'
        ELSE 'No'
    END AS remote_option
    
from job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY job_id;

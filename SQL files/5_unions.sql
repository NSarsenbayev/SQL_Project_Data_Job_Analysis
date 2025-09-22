SELECT *
FROM january_2023_jobs;

SELECT *
FROM february_2023_jobs;

SELECT *
FROM march_2023_jobs;

-- Get jobs and companies from January
SELECT 
    job_title_short,
    company_id, 
    job_location
FROM january_2023_jobs

UNION ALL

-- Get jobs and companies from February
SELECT 
    job_title_short,
    company_id, 
    job_location
FROM february_2023_jobs

UNION ALL -- combine another table

-- Get jobs and companies from March


WITH q1_job_postings AS (
-- Combine job postings from January, February, and March
SELECT * FROM january_2023_jobs
UNION ALL
SELECT * FROM february_2023_jobs
UNION ALL 
SELECT * FROM march_2023_jobs
)

SELECT 
    q1.job_id,
    q1.job_title,
    q1.company_id,
    q1.salary_year_avg,
    skills.skills, 
    skills.type
FROM q1_job_postings q1
LEFT JOIN skills_job_dim AS skills_job ON q1.job_id = skills_job.job_id
LEFT JOIN skills_dim AS skills ON skills_job.skill_id = skills.skill_id
WHERE q1.salary_year_avg > 70000;

SELECT 
    company.name,
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
SELECT * FROM january_2023_jobs
UNION ALL
SELECT * FROM february_2023_jobs
UNION ALL 
SELECT * FROM march_2023_jobs 
) AS quarter1_job_postings
JOIN company_dim AS company ON quarter1_job_postings.company_id = company.company_id
WHERE quarter1_job_postings.salary_year_avg > 70000
ORDER BY quarter1_job_postings.salary_year_avg DESC
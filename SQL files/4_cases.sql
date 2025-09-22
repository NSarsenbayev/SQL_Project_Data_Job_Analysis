SELECT 
    salary_year_avg,
    CASE
    WHEN salary_year_avg < 70000 THEN 'low'
    WHEN salary_year_avg >= 70000 AND salary_year_avg < 90000 THEN 'standard'
    ELSE 'high'
    END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND 
salary_year_avg IS NOT NULL
GROUP BY salary_year_avg, salary_category
ORDER BY salary_year_avg DESC;

SELECT *
FROM (-- Subquery starts here
SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)
    = 1) AS january_jobs;
    -- Subquery ends here) 

WITH january_jobs AS 
    ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) -- CTE definition starts here
SELECT *
FROM january_jobs;

-- subquery
SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
        SELECT
        company_id
        FROM job_postings_fact
        WHERE job_no_degree_mention = true
        ORDER BY company_id
);

WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) as total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs 
FROM company_dim 
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC
LIMIT 10;

SELECT sd.skills,
top_skills.skills_count
FROM (
    SELECT 
    skill_id,
    COUNT(*) AS skills_count
FROM skills_job_dim 
GROUP BY skill_id
ORDER BY skills_count DESC
LIMIT 5) AS top_skills
JOIN skills_dim sd
    ON top_skills.skill_id = sd.skill_id
ORDER BY top_skills.skills_count DESC;

SELECT cd.name, 
    cj.job_count,
        CASE
        WHEN cj.job_count < 10 THEN 'Small'
        WHEN cj.job_count >=10 AND cj.job_count <50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size

FROM (SELECT company_id,
    COUNT(job_id) AS job_count
FROM job_postings_fact
GROUP BY company_id) AS cj

JOIN company_dim cd 
ON cj.company_id = cd.company_id

WITH remote_job_skills AS (
SELECT
     skills_to_job.skill_id,
    COUNT(*) AS skill_count
FROM skills_job_dim AS skills_to_job
JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE job_postings.job_work_from_home = true AND job_postings.job_title_short = 'Data Analyst'
GROUP BY skills_to_job.skill_id
)
SELECT 
    skill.skill_id,
    skill.skills,
    skill_count
FROM remote_job_skills
JOIN skills_dim AS skill ON remote_job_skills.skill_id = skill.skill_id
ORDER BY skill_count DESC
LIMIT 5



SELECT skills,
FROM skills_dim
WHERE remote_job_skills
LIMIT 5


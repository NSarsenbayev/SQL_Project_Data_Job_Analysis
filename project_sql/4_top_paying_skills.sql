SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary_avg
FROM job_postings_fact
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY salary_avg DESC
LIMIT 25

/* 
Insights:
- The highest salaries cluster around specialized/niche tools (Solidity, Couchbase, Golang,     DataRobot) rather than traditional analyst tools (SQL, Excel, Tableau).

- Employers pay more when data analysts overlap with ML engineers, data engineers, or blockchain specialists.

- Classic analyst skills (Excel, SQL, Tableau) are essential but don’t make the top-paying list — it’s the rare, cross-disciplinary skills that boost compensation.
*/
sds
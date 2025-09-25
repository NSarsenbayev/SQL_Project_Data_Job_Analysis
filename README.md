# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others' work to find optimal jobs.

Data hails from [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used
For my deep dive into the Data Analyst job market, I used several key tools:
- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, idel for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:
##### 1. To identify the top 10 highest-paying roles, I focused on Data Analyst positions, filtering by average yearly salary and remote location.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```
## Visualize Data
```python
import seaborn as sns
sns.barplot(data=df_sorted, x="salary_year_avg", y="job_title", hue="job_title", palette="dark:b")
sns.set_theme(style="ticks")
sns.despine()
plt.title("Skill Count for Top 10 Paying Data Analyst Jobs in 2023 in the US")
plt.legend("")
plt.xlabel("Average Salary $USD")
plt.ylabel("")
plt.show()
```
![Top paying roles](project_sql\images\Top_10_paying_jobs.png)
*Bar graph visualizing the salary frothe top 10 salaries for data analysts

# Insights
- **"Data Analyst"** jobs pay the most overall — even more than many fancy titles.

- **Manager** and **director** roles also pay well — more experience = more money.

- **Remote** and **hybrid** jobs still pay great — you don’t need to be in an office to earn big.

- **Specialized roles** (like risk or performance analysis) also get good salaries.

##### 2. What skills are required for these top-paying jobs?
Core technical skills dominate across all job postings:
- *SQL* → the most requested skill, highlighting its importance in querying and managing data.
- *Python* → critical for analysis, automation, and data science tasks.
- *Tableau* → strong demand for visualization skills.
- Other skills like *R, Snowflake, Pandas, and Excel* show varying degrees of demand.

##### 3. What skills are most in demand for data analysts?
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY demand_count DESC
LIMIT 5
```
## Visualize Data
```python
sns.barplot(data=df_demanded_skills, x="skills", y="demand_count")
sns.despine()
plt.title("Top In-demand Skills in 2023 for Data Analyst Jobs in the US")
plt.xlabel("")
plt.ylabel("Demand Count")
plt.show()
```
![Top Demanded Skills](project_sql\images\Top_in_demand_skills.png)
*Bar graph visualizes the most demanded skills for Data Analyst in 2023 in the US.

# Insights
- **SQL** is the most in-demand skill for data analyst roles in the US in 2023, with the highest demand count.

- **Excel and Python** follow **SQL**, indicating that foundational tools and programming languages remain essential.

- **Tableau and Power BI**, while still important, have relatively lower demand compared to SQL and Excel.

Overall, the top in-demand skills blend data querying, analysis, and visualization tools.

##### 4. Which skills are associated with higher salaries?
This query identifies the high-paying skills across all Data Analytics jobs

```sql
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
```
## Visualize Data
```python
sns.barplot(data=df_high_paying_skills, x="salary_avg", y="skills", hue="skills", palette="dark:b")
sns.set_theme(style="ticks")
sns.despine()
plt.title("High Paying Skills")
plt.xlabel("Average Salary $USD")
plt.ylabel("")
plt.show()
```
![Top_paying_skills](project_sql\images\Top_paying_skills.png)
*Bar graph visualizes top paying skills in Data Analysis

# Insights
- The highest salaries cluster around *specialized/niche tools* (Solidity, Couchbase, Golang,     DataRobot) rather than traditional analyst tools (*SQL, Excel, Tableau*).

- Employers pay more when data analysts overlap with *ML engineers, data engineers, or blockchain* specialists.

- Classic analyst skills (*Excel, SQL, Tableau*) are essential but don’t make the top-paying list — it’s the rare, cross-disciplinary skills that boost compensation.

##### 5. What are the most optimal skills to learn?
The query combines both high-demand and high-paying skills in Data Analytics roles.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary_avg
FROM job_postings_fact
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND job_postings_fact.salary_year_avg IS NOT NULL
AND job_postings_fact.job_work_from_home = True
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY salary_avg DESC, demand_count DESC
LIMIT 25;
```
## Visualize Data
```python
sns.barplot(data=df_optimal_skills, x="salary_avg", y="skills")
sns.despine()
plt.title("Optimal Skills")
plt.xlabel("Average Salary $USD")
plt.ylabel("")
plt.show()
```
![Optimal_skills](project_sql\images\Optimal_skills.png)
*The bar graph visualizes Optimal skills for Data Analysis roles combining high salaries and high demand in the market.

# What I learned
During this SQL for Data Analysis course, I gained hands-on experience working with real-world data using **Visual Studio Code** and advanced **SQL querying techniques**. I learned how to write and optimize queries using **Common Table Expressions (CTEs), subqueries**, and various types of **joins** and **merging strategies** to combine and analyze datasets. I also became proficient in using **aggregation functions** (e.g., SUM(), AVG(), COUNT(), etc.) and understanding the overall **structure and flow of SQL queries**. These skills have strengthened my ability to extract insights from data and prepare it for analysis in a structured, efficient way. 
Additionally, I applied my **Python skill**s to visualize the data using **bar charts**, enhancing my ability to communicate insights effectively.  

# Conclusions
This project significantly strengthened my *SQL* skills and deepened my understanding of the data analytics job landscape. By analyzing in-demand and high-paying skills, I was able to identify key areas for professional growth and development. The insights gained serve as a valuable resource for guiding future learning priorities. For aspiring data analysts, this type of analysis can support more strategic career planning by focusing on skills that align with market needs. Overall, this experience reinforced the value of continuous learning and staying adaptable to evolving trends in the data analytics field.



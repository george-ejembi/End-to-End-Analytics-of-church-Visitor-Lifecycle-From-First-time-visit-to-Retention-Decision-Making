# Church Follow-Up Analytics: Member Engagement, Retention & Decision Insights

## Table of Contents
1. [Project Overview](#project-overview)  
2. [Problem Statement](#problem-statement)  
3. [Objectives](#objectives)  
4. [Dataset](#dataset)  
5. [Data Cleaning & Structuring](#data-cleaning--structuring)  
6. [ETL Process](#etl-process)  
7. [Analysis](#analysis)  
8. [Power BI Visualization](#power-bi-visualization)  
9. [Insights & Recommendations](#insights--recommendations)  
10. [Future Work](#future-work)  
11. [License](#license)  

---

## Project Overview

This project provides an end-to-end analytics workflow for a church’s follow-up unit. The analysis tracks members’ journey from first visit to retention and decision-making, leveraging structured datasets and data transformations. Insights generated help optimize engagement strategies, improve follow-up consistency, and enhance member experience.

---

## Problem Statement

The follow-up unit works with first-time visitors and returning members, tracking engagement and retention. However, there is limited insight into:

- How follow-up consistency impacts retention  
- Which member demographics are more engaged  
- How service experience influences members’ decision-making  
- Optimal strategies to improve first-time visitor conversion  

This project addresses these gaps using a data-driven approach.

---

## Objectives

1. Generate a simulated dataset representing member demographics, follow-up engagement, and service feedback  
2. Clean, structure, and integrate the data into a format suitable for analysis  
3. Transform and aggregate data to answer key questions  
4. Analyze engagement, retention, and decision-making patterns  
5. Visualize insights in Power BI to support strategic decision-making  

---

## Dataset

The dataset consists of **three tables**:

### 1. Members Master Data

| Column | Description |
|--------|-------------|
| Member_ID | Unique identifier |
| Names | Full name of member |
| Gender | Male/Female |
| Date_of_Birth | Date of birth |
| Age | Calculated from DOB |
| Profession | Job / occupation |
| Email | Contact email |
| Phone_Number | Contact phone |
| Address | Residential address |
| Instagram_Handle | Optional social media handle |
| How_Heard | Social media, friends, others |
| Visiting_Member | Yes / No |
| FollowUp_Personnel | Assigned staff |
| First_Visit_Date | Date of first visit |
| Member_Type | First Timer / Second Timer |
| Age_Bucket | Youth / Adult / Senior |

### 2. Follow-Up Engagement Data

| Column | Description |
|--------|-------------|
| Member_ID | Foreign key |
| FollowUp_Week | Week 1–4 |
| FollowUp_Date | Date of follow-up |
| Followup_Completed_% | Completion percentage of follow-up |
| Preferred_Contact_Time | Morning / Afternoon / Night |
| Prayer_Requests | Grace / Favour / Mercy / Longevity / Prosperity / Others |
| Notes | Members’ experience |
| Engagement_Score_% | Overall engagement score |
| Engagement_Group | Low / Medium / High |

### 3. Service Feedback Data

| Column | Description |
|--------|-------------|
| Member_ID | Foreign key |
| Service_Date | Date of service attended |
| Enjoyed | Prayer / Sermon / Worship / Atmosphere |
| Decision_Status | Decided / Undecided |

---

## Data Cleaning & Structuring

- **Handling Missing Values**: Fill missing emails, phone numbers, and engagement scores with defaults or median values  
- **Data Type Standardization**: Ensure consistent IDs, numeric percentages, and date formats  
- **Derived Columns**: Calculated `Age` from DOB and assigned `Age_Bucket`  

---

## ETL Process

1. **Extract**: Load CSVs for members, follow-up engagement, and service feedback  
2. **Transform**: Clean missing values, standardize text, calculate derived columns, categorize engagement levels  
3. **Load**: Insert clean datasets into database tables or analytical environment for querying and visualization  

---

## Analysis

Key analytical questions explored:

- Are younger members more engaged than older members?  
- Does inconsistency in follow-up reduce retention?  
- What is the average time for first-time visitors to disengage?  
- What is the conversion rate from first-timer to second-timer?  
- Which follow-up completion groups are more likely to decide?  

The analysis provides aggregated insights and patterns to inform strategic follow-up decisions.

---

## Power BI Visualization

Visualizations include:
[```Blank for now```]

---

## Insights & Recommendations
[```Blank for now```]

**Recommendations**:  
[```Blank for now```]  

---

## Future Work

- Include multi-service attendance history for better disengagement modeling  
- Predictive analytics to forecast which members are at risk of disengaging  
- Integration with automated SMS/email follow-ups based on engagement scores  

---

## License
MIT Licensed!


## 🛠️ Tools & Technologies

![Power BI](https://img.shields.io/badge/Power%20BI-F2C80F?style=for-the-badge&logo=power-bi&logoColor=black)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)

This project is licensed under the MIT License – see the LICENSE file for details

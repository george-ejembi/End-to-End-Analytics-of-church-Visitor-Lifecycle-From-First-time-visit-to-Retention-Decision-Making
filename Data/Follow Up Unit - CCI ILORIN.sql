
-- Full end analysis of CCI ILORIN FOLLOW UP DATA --
-- Analytics Engineer: George Eneumola Ejembi ------

/*******************************************************
-- *****************************************************
-- Full Data View 
-- *****************************************************
-- *****************************************************/

SELECT*
FROM members_master;
--
SELECT*
FROM followup_data;
--
SELECT*
FROM service_feedback;


             /*******************************************************
             -- Section 1: Follow-Up Performance
             *******************************************************/

             -- does higher follow up completion lead to higher engagement? --
             SELECT
               completion_group,
               Avg(Engagement_Score) AS avg_engagement
             FROM(
             SELECT
               Engagement_Score,
                  CASE WHEN followup_completed <40 THEN 'Low Completion'
                  WHEN followup_completed <70 THEN 'Medium Completion'
                  ELSE 'Higher Completion'
                  END AS completion_group

             FROM followup_data
             )sub
                GROUP BY completion_group
                ORDER BY Avg_engagement DESC;

            -- which follow up week drives the highest engagement? --
            SELECT
              followup_week,
              AVG(engagement_score) AS Avg_engagemnent
            FROM followup_data
            GROUP BY Followup_Week
            ORDER BY Avg_engagemnent DESC;

            -- follow up personnel performance? --
            SELECT
            m.followup_personnel,
               AVG(f.engagement_score) AS Avg_engagement,
               AVG(f.followUp_completed) AS Avg_completion
           FROM members_master m
           JOIN followup_data f
           ON m.Member_ID = f.Member_ID
           GROUP BY m.Followup_Personnel
           ORDER BY Avg_engagement DESC;

                                                                   -- does inconsistency reduce retention? --
                                                                   SELECT
                                                                   CASE 
                                                                   WHEN followup_completed < 40 THEN 'Inconsistent'
                                                                   WHEN followup_completed < 70 THEN 'Moderately Consistent'
                                                                   ELSE 'Highly Consistent'
                                                                   END AS consistency_level,
                                                                   COUNT(*) AS total,
                                                                   SUM(CASE WHEN m.member_type = 'Second Timer' THEN 1 ELSE 0 END) AS Retained,
                                                                       ROUND(
                                                                   SUM(CASE WHEN m.member_type = 'Second Timer' THEN 1 ELSE 0 END) * 0.1/
                                                                   COUNT(*),2
                                                                        ) AS Retention_rate
                                                                   FROM followup_data f
                                                                   JOIN members_master m
                                                                   ON f.Member_ID = m.Member_ID
                                                                       GROUP BY
                                                                           CASE
                                                                             WHEN followup_completed < 40 THEN 'Inconsistent'
                                                                             WHEN followup_completed < 70 THEN 'Moderately Consistent'
                                                                       ELSE 'Highly Consistent'
                                                                       END
                                                                  ORDER BY Retention_rate DESC;
   
     
             /*******************************************************
             -- Section 2: Retention & Conversion Analysis
             *******************************************************/
             -- what is the first-time to second-timer conversion rate?
             SELECT
               COUNT(CASE WHEN member_type = 'First Timer' THEN 1 END)     AS First_Timers,
               COUNT(CASE WHEN member_type = 'Second Timer' THEN 1 END)    AS Second_Timers,
                     CAST(
                         COUNT(CASE WHEN member_type = 'Second Timer' THEN 1 END) * 1.0/
                         NULLIF(COUNT(CASE WHEN member_type = 'First Timer' THEN 1 END),0)
                         AS DECIMAL(10,2))                                 AS Conversion_rate
             FROM members_master;

             -- determine retention by source?
             SELECT
             how_heard,
             COUNT(*) AS total,
             SUM(CASE WHEN member_type = 'Second Timer' THEN 1 ELSE 0 END)   AS Retained,
             ROUND(
             SUM(CASE WHEN member_type = 'Second Timer' THEN 1 ELSE 0 END) * 1.0/
             COUNT(*),2
             )  AS Retention_rate
             FROM members_master
             GROUP BY How_Heard
             ORDER BY Retention_rate  DESC;

             -- determine retention by age group/
             SELECT
             age_bucket,
             COUNT(*)  AS Total,
             SUM(CASE WHEN member_type = 'Second Timer' THEN 1 ELSE 0 END) Retained,
             ROUND(
             SUM(CASE WHEN member_type = 'Second Time' THEN 1 ELSE 0 END) * 1.0 / COUNT(*),2
             )  AS retention_rate
             FROM members_master
             GROUP BY Age_Bucket
             ORDER BY retention_rate;


             /*******************************************************
             -- Section 3: Engagement Intelligence Analysis
             *******************************************************/
             -- determine engagement by contact time?
             SELECT
               preferred_contact_time,
               AVG(engagement_score)  AS avg_engagement
             FROM followup_data
             GROUP BY Preferred_Contact_Time
             ORDER BY avg_engagement DESC;

             -- determine engagement by prayer request?
             SELECT
               prayer_request,
               AVG(engagement_score)  AS avg_engagement
             FROM followup_data
             GROUP BY Prayer_Request
             ORDER BY avg_engagement DESC;

             -- determine engagemnet by distribution (Low-Medium-High)?
             SELECT 
             engagement_group,
             COUNT(*)  AS total_members,
             ROUND(COUNT(*) * 1.0/
             (
             SELECT COUNT(*) FROM followup_data),2) AS percentage_
             FROM followup_data
             GROUP BY Engagement_Group;


             /*******************************************************
             -- Section 4: Decision & Conversion Analysis
             *******************************************************/
             -- what is the overall decison rate? 
             SELECT
             COUNT(*)  AS total_members,
             SUM(CASE WHEN decision_status = 'Decided' THEN 1 ELSE 0 END)  AS decided,
             ROUND(
             SUM(CASE WHEN decision_status = 'Decided' THEN 1 ELSE 0 END) * 1.0/ COUNT(*),2
             )
             AS decision_rate
             FROM service_feedback;

             -- decision rate by engagement level
             SELECT 
             f.engagement_group,
                 COUNT(*) AS total,
                 SUM(CASE WHEN s.decision_status = 'Decided' THEN 1 ELSE 0 END) AS decided,
                 ROUND(
                 SUM(CASE WHEN s.decision_status = 'Decided' THEN 1 ELSE 0 END) * 1.0 /
             COUNT(*), 2
             ) AS decision_rate
             FROM followup_data f
             JOIN service_feedback s 
             ON f.member_id = s.member_id
             GROUP BY f.engagement_group
             ORDER BY decision_rate DESC;

             -- decision rate by follow-up completion?
             WITH categorized AS (
             SELECT 
                f.Member_ID,
                s.Decision_Status,
                CASE 
                    WHEN [Followup_Completed] < 30 THEN 'Low Completion'
                    WHEN [Followup_Completed] < 70 THEN 'Medium Completion'
                    ELSE 'High Completion'
                END AS completion_group
             FROM followup_data f
             JOIN service_feedback s 
                ON f.Member_ID = s.Member_ID
             )
            SELECT 
            completion_group,
            COUNT(*) AS total,
            SUM(CASE WHEN Decision_Status = 'Decided' THEN 1 ELSE 0 END) AS decided,    
            CAST(
                SUM(CASE WHEN Decision_Status = 'Decided' THEN 1 ELSE 0 END) * 1.0 /
                COUNT(*)
            AS DECIMAL(10,2)) AS decision_rate
           FROM categorized
           GROUP BY completion_group
           ORDER BY decision_rate DESC;

         -- decision by service experience?
           SELECT 
           enjoyed,
           COUNT(*) AS total, 
           SUM(CASE WHEN decision_status = 'Decided' THEN 1 ELSE 0 END) AS decided,   
           ROUND(
           SUM(CASE WHEN decision_status = 'Decided' THEN 1 ELSE 0 END) * 1.0 /
           COUNT(*), 2
              ) AS decision_rate
           FROM service_feedback
           GROUP BY enjoyed
           ORDER BY decision_rate DESC;


             /*******************************************************
             -- Section 5: Source - Engagement - Decision
             *******************************************************/
             -- From source to decison? 
            SELECT 
                m.how_heard,
                f.engagement_group,
    
                COUNT(*) AS total,
    
                SUM(CASE WHEN s.decision_status = 'Decided' THEN 1 ELSE 0 END) AS decided,
    
                ROUND(
                    SUM(CASE WHEN s.decision_status = 'Decided' THEN 1 ELSE 0 END) * 1.0 /
                    COUNT(*), 2
                ) AS decision_rate

            FROM members_master m
            JOIN followup_data f 
                ON m.member_id = f.member_id
            JOIN service_feedback s 
                ON m.member_id = s.member_id

            GROUP BY m.how_heard, f.engagement_group
            ORDER BY decision_rate DESC;

            --where are we losing people?
            
            SELECT 
                m.member_type,
                f.engagement_group,
                s.decision_status,
                COUNT(*) AS total

            FROM members_master m
            LEFT JOIN followup_data f 
                ON m.member_id = f.member_id
            LEFT JOIN service_feedback s 
                ON m.member_id = s.member_id

            GROUP BY m.member_type, f.engagement_group, s.decision_status
            ORDER BY total DESC;


            /*********************************
            -- KPIs To Track
            *********************************/
           -- Total Members
           SELECT COUNT(*)   AS Total_members
           FROM members_master;

           -- Total First Timers
           SELECT COUNT(*)  AS first_timers
           FROM members_master
           WHERE Member_Type = 'First Timer';

           -- Total Second Timers
           SELECT COUNT(*)  AS second_timers
           FROM members_master
           WHERE Member_Type = 'Second Timer';

           -- Retention Rate
           SELECT 
             CAST(
             COUNT(CASE WHEN member_type = 'second timer' THEN 1 END) * 1.0/
                 NULLIF(COUNT(CASE WHEN member_type = 'first timer' THEN 1 END),0)
                     AS DECIMAL (10,2))  AS rention_rate
           FROM members_master;

           -- Drop Off Rate 
           SELECT
           1-CAST(
               COUNT(CASE WHEN member_type = 'second timer' THEN 1 END)*1.0/
                    NULLIF(COUNT(CASE WHEN member_type = 'first timer' THEN 1 END),0)
                    AS DECIMAL (10,2))  AS dropoff_rate
                    FROM members_master

           -- Avg Follow-Up Completion
           SELECT
           AVG([Followup_Completed])  AS avg_follow_completed
           FROM followup_data;
           -- Follow Up completion Rate 
           SELECT 
           CAST(
             COUNT(CASE WHEN [followup_completed] >= 70 THEN 1 END)*1.0/
               COUNT(*)
               AS DECIMAL(10,2))   AS high_completion_rate
           FROM followup_data;
           -- Follow up Effectiveness; from completion to retention
           SELECT
           CAST(
             SUM(CASE WHEN m.member_type = 'second timer' THEN 1 ELSE 0 END) * 1.0/
             COUNT(*)
               AS DECIMAL(10,2))  AS followup_effectivenes
           FROM followup_data f
           JOIN members_master m
           ON f.Member_ID = m.Member_ID
           WHERE [Followup_Completed] >= 70;

           -- Avg Engagement Score
           SELECT 
           AVG([engagement_score])   AS avg_engagement_score
           FROM followup_data;
           -- High Engagement rate 
           SELECT
           CAST(
           COUNT(CASE WHEN engagement_group = 'High' THEN 1 END)*1.0/
           COUNT(*)
           AS DECIMAL(10,2))   AS high_engagement_rate
           FROM followup_data;
           -- overall decision rate 
           SELECT 
           CAST(
           SUM(CASE WHEN decision_status = 'Decided' THEN 1 ELSE 0 END)* 1.0/
           COUNT(*)
           AS DECIMAL(10,2))   AS decision_rate
           FROM service_feedback;




/*
Project: Customer Support Operations Analytics
File: 03_business_analysis.sql
Purpose: Answer management-level business questions.
SQL Dialect: MySQL 8+
*/

/* ============================================================
   1. Monthly Ticket Trend
   ============================================================ */
SELECT
    YEAR(created_date) AS year_no,
    MONTH(created_date) AS month_no,
    MONTHNAME(created_date) AS month_name,
    COUNT(*) AS total_tickets
FROM c_s_final
GROUP BY YEAR(created_date), MONTH(created_date), MONTHNAME(created_date)
ORDER BY year_no, month_no;


/* ============================================================
   2. Month-over-Month Ticket Growth
   ============================================================ */
WITH monthly_tickets AS (
    SELECT
        YEAR(created_date) AS year_no,
        MONTH(created_date) AS month_no,
        MONTHNAME(created_date) AS month_name,
        COUNT(*) AS total_tickets
    FROM c_s_final
    GROUP BY YEAR(created_date), MONTH(created_date), MONTHNAME(created_date)
),
with_previous AS (
    SELECT
        *,
        LAG(total_tickets) OVER (ORDER BY year_no, month_no) AS previous_month_tickets
    FROM monthly_tickets
)
SELECT
    year_no,
    month_no,
    month_name,
    total_tickets,
    previous_month_tickets,
    total_tickets - previous_month_tickets AS ticket_change,
    ROUND(
        (total_tickets - previous_month_tickets) * 100.0
        / NULLIF(previous_month_tickets, 0),
        2
    ) AS percentage_change
FROM with_previous
ORDER BY year_no, month_no;


/* ============================================================
   3. Top Cities by Ticket Volume
   ============================================================ */
WITH city_summary AS (
    SELECT city, COUNT(*) AS total_tickets
    FROM c_s_final
    GROUP BY city
),
ranked_cities AS (
    SELECT
        city,
        total_tickets,
        RANK() OVER (ORDER BY total_tickets DESC) AS city_rank
    FROM city_summary
)
SELECT *
FROM ranked_cities
WHERE city_rank <= 5
ORDER BY city_rank;


/* ============================================================
   4. Support Agent Performance
   ============================================================ */
WITH agent_performance AS (
    SELECT
        support_agent,
        COUNT(*) AS tickets_handled,
        ROUND(AVG(satisfaction_rating), 2) AS avg_satisfaction,
        ROUND(AVG(resolution_days), 2) AS avg_resolution_days
    FROM c_s_final
    GROUP BY support_agent
)
SELECT
    support_agent,
    tickets_handled,
    avg_satisfaction,
    avg_resolution_days,
    RANK() OVER (
        ORDER BY avg_satisfaction DESC,
                 avg_resolution_days ASC,
                 tickets_handled DESC
    ) AS performance_rank
FROM agent_performance
ORDER BY performance_rank;


/* ============================================================
   5. Monthly Customer Satisfaction Trend
   ============================================================ */
WITH satisfaction_trend AS (
    SELECT
        YEAR(resolved_date) AS year_no,
        MONTH(resolved_date) AS month_no,
        MONTHNAME(resolved_date) AS month_name,
        AVG(satisfaction_rating) AS avg_rating
    FROM c_s_final
    WHERE resolved_date IS NOT NULL
    GROUP BY YEAR(resolved_date), MONTH(resolved_date), MONTHNAME(resolved_date)
),
with_previous AS (
    SELECT
        *,
        LAG(avg_rating) OVER (ORDER BY year_no, month_no) AS previous_month_rating
    FROM satisfaction_trend
)
SELECT
    year_no,
    month_no,
    month_name,
    ROUND(avg_rating, 2) AS avg_rating,
    ROUND(previous_month_rating, 2) AS previous_month_rating,
    ROUND(avg_rating - previous_month_rating, 2) AS rating_change
FROM with_previous
ORDER BY year_no, month_no;


/* ============================================================
   6. Running Total of Tickets
   ============================================================ */
WITH monthly_tickets AS (
    SELECT
        YEAR(created_date) AS year_no,
        MONTH(created_date) AS month_no,
        MONTHNAME(created_date) AS month_name,
        COUNT(*) AS total_tickets
    FROM c_s_final
    GROUP BY YEAR(created_date), MONTH(created_date), MONTHNAME(created_date)
)
SELECT
    year_no,
    month_no,
    month_name,
    total_tickets,
    SUM(total_tickets) OVER (ORDER BY year_no, month_no) AS running_total_tickets
FROM monthly_tickets
ORDER BY year_no, month_no;


/* ============================================================
   7. Resolution Efficiency Trend
   ============================================================ */
WITH efficiency_trend AS (
    SELECT
        YEAR(created_date) AS year_no,
        MONTH(created_date) AS month_no,
        MONTHNAME(created_date) AS month_name,
        AVG(resolution_days) AS avg_resolution_days
    FROM c_s_final
    WHERE resolution_days IS NOT NULL
    GROUP BY YEAR(created_date), MONTH(created_date), MONTHNAME(created_date)
),
with_previous AS (
    SELECT
        *,
        LAG(avg_resolution_days) OVER (ORDER BY year_no, month_no) AS previous_month_avg
    FROM efficiency_trend
)
SELECT
    year_no,
    month_no,
    month_name,
    ROUND(avg_resolution_days, 2) AS avg_resolution_days,
    ROUND(previous_month_avg, 2) AS previous_month_avg,
    ROUND(avg_resolution_days - previous_month_avg, 2) AS change_in_avg_days
FROM with_previous
ORDER BY year_no, month_no;


/* ============================================================
   8. Open Tickets by Issue Category
   ============================================================ */
SELECT
    issue_category,
    COUNT(*) AS open_tickets,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS open_ticket_percentage
FROM c_s_final
WHERE ticket_status = 'OPEN'
GROUP BY issue_category
ORDER BY open_tickets DESC;

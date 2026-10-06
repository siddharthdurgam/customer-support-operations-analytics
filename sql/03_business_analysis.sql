/*=============================================================================
  Project : Customer Support Operations Analytics
  File    : 04_business_queries.sql
  Author  : D.Siddharth Patel

  Purpose:
  Business-focused SQL queries used to answer operational questions and
  support the Power BI dashboard.
=============================================================================*/

/* 1. Monthly Ticket Trend */
SELECT
    MONTH(created_date) AS month_no,
    MONTHNAME(created_date) AS month_name,
    COUNT(*) AS total_ticket
FROM c_s_final
GROUP BY MONTH(created_date), MONTHNAME(created_date)
ORDER BY month_no;

/* 2. Month-over-Month Ticket Growth */
WITH monthly_ticket AS (
    SELECT
        MONTH(created_date) AS month_no,
        MONTHNAME(created_date) AS month_name,
        COUNT(*) AS total_ticket
    FROM c_s_final
    GROUP BY MONTH(created_date), MONTHNAME(created_date)
), previous_month AS (
    SELECT
        month_no,
        month_name,
        total_ticket,
        LAG(total_ticket) OVER (ORDER BY month_no) AS previous_month_ticket
    FROM monthly_ticket
)
SELECT
    month_no,
    month_name,
    total_ticket,
    previous_month_ticket,
    total_ticket - previous_month_ticket AS ticket_change,
    ROUND((total_ticket - previous_month_ticket) * 100.0 / NULLIF(previous_month_ticket, 0), 2) AS percentage_change
FROM previous_month;

/* 3. Top 5 Cities by Ticket Volume */
WITH city_summary AS (
    SELECT city, COUNT(*) AS total_ticket
    FROM c_s_final
    GROUP BY city
)
SELECT
    city,
    total_ticket,
    RANK() OVER (ORDER BY total_ticket DESC) AS city_rank
FROM city_summary
ORDER BY city_rank
LIMIT 5;

/* 4. Support Agent Performance Ranking */
WITH support_agent_performance AS (
    SELECT
        support_agent,
        COUNT(*) AS ticket_handled,
        ROUND(AVG(satisfaction_rating), 2) AS avg_satisfaction,
        ROUND(AVG(resolution_days), 2) AS avg_resolution_days
    FROM c_s_final
    GROUP BY support_agent
)
SELECT
    support_agent,
    ticket_handled,
    avg_satisfaction,
    avg_resolution_days,
    RANK() OVER (
        ORDER BY avg_satisfaction DESC, avg_resolution_days ASC, ticket_handled DESC
    ) AS performance_rank
FROM support_agent_performance
ORDER BY performance_rank;

/* 5. Monthly Satisfaction Trend */
WITH satisfaction_trend AS (
    SELECT
        MONTH(resolved_date) AS month_no,
        MONTHNAME(resolved_date) AS month_name,
        AVG(satisfaction_rating) AS avg_rating,
        LAG(AVG(satisfaction_rating)) OVER (ORDER BY MONTH(resolved_date)) AS previous_month_rating
    FROM c_s_final
    GROUP BY MONTH(resolved_date), MONTHNAME(resolved_date)
)
SELECT
    month_no,
    month_name,
    ROUND(avg_rating, 2) AS avg_rating,
    ROUND(previous_month_rating, 2) AS previous_month_rating,
    ROUND(avg_rating - previous_month_rating, 2) AS rating_change,
    ROUND((avg_rating - previous_month_rating) * 100 / NULLIF(previous_month_rating, 0), 2) AS mom_change_percent
FROM satisfaction_trend
ORDER BY month_no;

/* 6. Running Total of Tickets */
WITH monthly_tickets AS (
    SELECT
        YEAR(created_date) AS year_no,
        MONTH(created_date) AS month_no,
        MONTHNAME(created_date) AS month_name,
        COUNT(*) AS total_ticket
    FROM c_s_final
    GROUP BY YEAR(created_date), MONTH(created_date), MONTHNAME(created_date)
)
SELECT
    year_no,
    month_no,
    month_name,
    total_ticket,
    SUM(total_ticket) OVER (ORDER BY year_no, month_no) AS running_total_ticket
FROM monthly_tickets
ORDER BY year_no, month_no;

/* 7. Resolution Efficiency Trend */
WITH efficiency_trend AS (
    SELECT
        YEAR(created_date) AS year_no,
        MONTH(created_date) AS month_no,
        MONTHNAME(created_date) AS month_name,
        AVG(resolution_days) AS avg_days_to_resolve
    FROM c_s_final
    GROUP BY YEAR(created_date), MONTH(created_date), MONTHNAME(created_date)
), previous_month AS (
    SELECT
        year_no,
        month_no,
        month_name,
        avg_days_to_resolve,
        LAG(avg_days_to_resolve) OVER (ORDER BY year_no, month_no) AS previous_month_avg
    FROM efficiency_trend
)
SELECT
    year_no,
    month_name,
    ROUND(avg_days_to_resolve, 2) AS avg_days_to_resolve,
    ROUND(previous_month_avg, 2) AS previous_month_avg,
    ROUND(avg_days_to_resolve - previous_month_avg, 2) AS change_in_avg,
    ROUND((avg_days_to_resolve - previous_month_avg) * 100 / NULLIF(previous_month_avg, 0), 2) AS mom_efficiency
FROM previous_month
ORDER BY year_no, month_no;

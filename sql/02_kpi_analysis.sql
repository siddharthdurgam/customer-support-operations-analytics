/*
Project: Customer Support Operations Analytics
File: 02_kpi_analysis.sql
Purpose: Executive KPI calculations.
SQL Dialect: MySQL 8+
*/

/* Total Tickets */
SELECT COUNT(*) AS total_tickets
FROM c_s_final;

/* Unique Customers */
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM c_s_final;

/* Open Tickets */
SELECT COUNT(*) AS open_tickets
FROM c_s_final
WHERE ticket_status = 'OPEN';

/* Average Satisfaction */
SELECT ROUND(AVG(satisfaction_rating), 2) AS avg_satisfaction_rating
FROM c_s_final;

/* Average Resolution Time */
SELECT ROUND(AVG(resolution_days), 2) AS avg_resolution_days
FROM c_s_final
WHERE resolution_days IS NOT NULL;

/* Refund Request Rate */
SELECT ROUND(
    SUM(CASE WHEN refund_requested = 'YES' THEN 1 ELSE 0 END) * 100.0
    / NULLIF(COUNT(*), 0),
    2
) AS refund_request_rate
FROM c_s_final;

/* Ticket Status Distribution */
SELECT
    ticket_status,
    COUNT(*) AS ticket_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS ticket_percentage
FROM c_s_final
GROUP BY ticket_status
ORDER BY ticket_count DESC;

/* Ticket Volume by Issue Category */
SELECT
    issue_category,
    COUNT(*) AS ticket_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS ticket_percentage,
    ROUND(AVG(resolution_days), 2) AS avg_resolution_days
FROM c_s_final
GROUP BY issue_category
ORDER BY ticket_count DESC;

/* Ticket Volume by Support Channel */
SELECT
    support_channel,
    COUNT(*) AS ticket_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS ticket_percentage
FROM c_s_final
GROUP BY support_channel
ORDER BY ticket_count DESC;

/* Ticket Volume by Region */
SELECT
    region,
    COUNT(*) AS ticket_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS ticket_percentage,
    ROUND(AVG(satisfaction_rating), 2) AS avg_satisfaction
FROM c_s_final
GROUP BY region
ORDER BY ticket_count DESC;

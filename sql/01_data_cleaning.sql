/*
Project: Customer Support Operations Analytics
File: 01_data_cleaning.sql
Purpose: Prepare the raw support-ticket table for analysis.
SQL Dialect: MySQL 8+
*/

/* ============================================================
   1. Create analytical copy
   ============================================================ */

CREATE TABLE c_s_clean AS
SELECT *
FROM customer_support_messy;


/* ============================================================
   2. Standardize text fields
   ============================================================ */

UPDATE c_s_clean
SET
    customer_name = NULLIF(TRIM(UPPER(customer_name)), ''),
    city = NULLIF(TRIM(UPPER(city)), ''),
    customer_type = NULLIF(TRIM(UPPER(customer_type)), ''),
    region = NULLIF(TRIM(UPPER(region)), ''),
    support_channel = NULLIF(TRIM(UPPER(support_channel)), ''),
    issue_category = NULLIF(TRIM(UPPER(issue_category)), ''),
    priority = NULLIF(TRIM(UPPER(priority)), ''),
    ticket_status = NULLIF(TRIM(UPPER(ticket_status)), ''),
    refund_requested = NULLIF(TRIM(UPPER(refund_requested)), ''),
    support_agent = NULLIF(TRIM(UPPER(support_agent)), '');


/* ============================================================
   3. Standardize known category aliases
   ============================================================ */

UPDATE c_s_clean
SET support_channel = 'EMAIL'
WHERE support_channel = 'MAIL';

UPDATE c_s_clean
SET support_channel = 'MOBILE APP'
WHERE support_channel = 'APP';

UPDATE c_s_clean
SET issue_category = 'TECHNICAL ISSUE'
WHERE issue_category = 'TECH PROBLEM';

UPDATE c_s_clean
SET issue_category = 'REFUND REQUEST'
WHERE issue_category = 'REFUND';


/* ============================================================
   4. Normalize satisfaction rating
   ============================================================ */

UPDATE c_s_clean
SET satisfaction_rating =
    CAST(CAST(NULLIF(TRIM(satisfaction_rating), '') AS DECIMAL(10,2)) AS SIGNED);


/* ============================================================
   5. Add technical row identifier if required
   ============================================================ */

ALTER TABLE c_s_clean
ADD COLUMN IF NOT EXISTS ID INT AUTO_INCREMENT PRIMARY KEY;


/* ============================================================
   6. Identify duplicate ticket IDs
   ============================================================ */

WITH duplicate_check AS (
    SELECT
        ID,
        ticket_id,
        ROW_NUMBER() OVER (
            PARTITION BY ticket_id
            ORDER BY ID
        ) AS row_num
    FROM c_s_clean
)
SELECT *
FROM duplicate_check
WHERE row_num > 1
ORDER BY ticket_id, ID;


/* ============================================================
   7. Validate date logic
   ============================================================ */

SELECT
    ticket_id,
    created_date,
    resolved_date,
    DATEDIFF(resolved_date, created_date) AS resolution_days,
    ticket_status
FROM c_s_clean
WHERE resolved_date IS NOT NULL
  AND DATEDIFF(resolved_date, created_date) < 0;


/* ============================================================
   8. Create final analytical table
   ============================================================ */

CREATE TABLE c_s_final AS
SELECT
    ticket_id,
    customer_id,
    customer_name,
    customer_type,
    city,
    region,
    support_channel,
    issue_category,
    priority,
    ticket_status,
    refund_requested,
    support_agent,
    satisfaction_rating,
    created_date,
    resolved_date,
    DATEDIFF(resolved_date, created_date) AS resolution_days
FROM c_s_clean;

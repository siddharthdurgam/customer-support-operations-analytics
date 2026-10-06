# KPI Analysis — Customer Support Operations

## Objective
Explore the cleaned customer-support dataset, identify operational patterns, and generate business insights for decision-making.

## KPI Framework

| KPI | Definition | Business Value |
|---|---|---|
| Total Tickets | Count of support tickets | Measures overall support demand and workload |
| Average Satisfaction | Average customer satisfaction rating | Tracks customer experience quality |
| Open Tickets | Tickets currently in Open status | Indicates backlog and potential service delays |
| Refund Request Rate | Refund-requested tickets as a percentage of all tickets | Highlights refund-related support demand |
| Unique Customers | Distinct customer IDs served | Measures customer reach |
| Average Resolution Days | Average ticket resolution duration | Measures operational efficiency |

## SQL KPI Queries

### 1. Total Tickets
```sql
SELECT COUNT(ticket_id) AS total_tickets
FROM c_s_final;
```

### 2. Average Customer Satisfaction
```sql
SELECT ROUND(AVG(satisfaction_rating), 2) AS avg_satisfaction_rating
FROM c_s_final;
```

### 3. Open Ticket Count
```sql
SELECT COUNT(*) AS open_ticket_count
FROM c_s_final
WHERE ticket_status = 'Open';
```

### 4. Refund Request Rate
```sql
SELECT ROUND(
    SUM(CASE WHEN UPPER(refund_requested) = 'YES' THEN 1 ELSE 0 END) * 100.0
    / NULLIF(COUNT(*), 0),
    2
) AS refund_request_rate
FROM c_s_final;
```

### 5. Unique Customers Served
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customer_count
FROM c_s_final;
```

### 6. Average Resolution Days
```sql
SELECT ROUND(AVG(resolution_days), 2) AS avg_resolution_days
FROM c_s_final;
```

## KPI Interpretation
- **Ticket volume** provides the baseline for workload and staffing decisions.
- **Satisfaction** helps evaluate service quality and customer experience.
- **Open tickets** should be monitored as a backlog indicator.
- **Refund rate** helps identify potential product, delivery, billing, or service issues.
- **Unique customers** separates customer reach from raw ticket volume.
- **Resolution time** helps identify operational bottlenecks and efficiency opportunities.

## Recommended Dashboard KPIs
1. Total Tickets
2. Open / Escalated Tickets
3. Average Satisfaction Rating
4. Average Resolution Days
5. Refund Request Rate
6. Unique Customers Served
7. Tickets by Priority
8. Tickets by Support Channel

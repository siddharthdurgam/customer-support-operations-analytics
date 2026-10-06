# Customer Support Operations Analytics

> End-to-end customer support analytics project using **SQL, Python, Power BI, and DAX** to evaluate ticket volume, customer experience, operational efficiency, and support performance.

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-Analytics-4479A1?logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-Data%20Analysis-3776AB?logo=python&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-KPI%20Modeling-1F4E79)

## Project Overview

Customer support teams need to balance ticket demand, resolution speed, customer satisfaction, and operational capacity. This project analyzes a customer-support dataset to identify demand patterns, backlog pressure, issue concentration, channel usage, regional distribution, and agent performance.

The project follows a practical analytics workflow:

**Raw Data → Data Cleaning & Validation → SQL Analysis → Python Analysis → KPI/DAX Modeling → Power BI Dashboard → Business Insights & Recommendations**

## Business Objectives

- Measure overall customer support workload.
- Identify the most frequently used support channels.
- Determine which issue categories generate the highest ticket volumes.
- Analyze open-ticket backlog and ticket status distribution.
- Compare support-agent workload, satisfaction, and resolution efficiency.
- Evaluate regional ticket demand and customer satisfaction.
- Track monthly ticket trends and operational performance.
- Translate analytical findings into actionable business recommendations.

## Dataset Snapshot

| Metric | Value |
|---|---:|
| Total Tickets | 40,000 |
| Columns | 17 |
| Unique Customers | 17,237 |
| Average Satisfaction | 3.02 / 5 |
| Average Resolution Time | 13.43 days |
| Open Tickets | 10,528 |
| Refund Request Rate | 50.11% |
| Date Range | 2024-12-27 to 2025-12-17 |

## Technology Stack

| Technology | Purpose |
|---|---|
| **SQL / MySQL** | Data cleaning, validation, transformations and business analysis |
| **Python** | Data preparation, response/resolution-time analysis and text analysis |
| **Power BI** | Interactive dashboard and executive reporting |
| **DAX** | KPI measures and analytical calculations |
| **GitHub** | Version control and project documentation |

## Data Preparation

The SQL workflow includes:

- Standardizing text fields with `TRIM`, `UPPER`, and `NULLIF`.
- Converting inconsistent category values into standardized business categories.
- Standardizing support channels and issue categories.
- Converting satisfaction values into a consistent numeric format.
- Detecting duplicate ticket IDs using window functions.
- Selecting the most complete record when duplicate records exist.
- Validating created and resolved dates.
- Calculating resolution duration in days.
- Checking for invalid negative resolution durations.

The Python workflow additionally calculates response and resolution intervals from timestamp fields and performs basic ticket-description text analysis.

## Key KPIs

The Power BI model includes executive-level measures for:

- Total Tickets
- Unique Customers
- Open Tickets
- Average Satisfaction Rating
- Average Resolution Time
- Refund Request Rate
- Closed Tickets
- Ticket status distribution

## Dashboard

### Executive Support Operations Dashboard

The Power BI dashboard provides an interactive view of:

- Ticket volume by issue category
- Ticket volume by support channel
- Ticket volume by region
- Current ticket status
- Open tickets by issue category
- Support-agent performance
- Monthly ticket trend
- Interactive filters for issue category, region, support channel, and support agent

> Upload the final `.pbix` file and dashboard screenshot to the `powerbi/` and `screenshots/` folders after the repository structure is in place.

## Key Findings

### 1. Support Channel Demand

Email is the highest-volume support channel with **8,411 tickets (21.03%)**, followed by Mobile App with **8,126 tickets (20.32%)**.

**Business implication:** Capacity planning should prioritize the highest-volume digital support channels.

### 2. Issue Category Concentration

Refund Request is the largest issue category with **7,014 tickets (17.54%)**, followed by Technical Issue with **6,918 tickets (17.30%)**.

Damaged Product has the highest average resolution time among the listed issue categories, indicating comparatively greater resolution complexity.

### 3. Ticket Backlog

Open tickets represent **10,528 tickets (26.32%)**, making Open the largest ticket-status group.

**Business implication:** Reducing the open-ticket backlog should be a key operational priority.

### 4. Regional Demand

Central and North have the highest ticket volumes at approximately **9K tickets each**, while East has the lowest volume at approximately **4.5K**.

Customer satisfaction remains relatively consistent across regions.

### 5. Agent Performance

The four support agents handle broadly similar ticket volumes and maintain comparable satisfaction levels, indicating a relatively balanced workload distribution.

## Business Recommendations

1. **Prioritize high-volume channels** by reviewing staffing and workflow capacity for Email and Mobile App support.
2. **Investigate recurring issue drivers**, particularly Refund Request and Technical Issue categories.
3. **Reduce the open-ticket backlog** through queue prioritization, escalation rules, and faster resolution workflows.
4. **Review complex issue categories**, especially Damaged Product cases, to identify process bottlenecks.
5. **Continue monitoring agent-level KPIs** to maintain balanced workload distribution and consistent customer experience.
6. **Track satisfaction alongside operational metrics** rather than using ticket volume alone to evaluate support performance.

## Repository Structure

```text
customer-support-operations-analytics/
│
├── README.md
├── requirements.txt
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   └── customer_support_analysis.py
│
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_kpi_analysis.sql
│   └── 03_business_analysis.sql
│
├── dax/
│   └── measures.md
│
├── documentation/
│   ├── business_problems.md
│   ├── data_quality.md
│   └── key_insights.md
│
├── powerbi/
│   └── README.md
│
└── screenshots/
    └── dashboard.png
```

## Analytical Questions

The project answers practical business questions including:

- How has ticket demand changed over time?
- Which support channels generate the highest demand?
- Which issue categories create the most customer complaints?
- Which regions generate the highest support workload?
- How is the support backlog distributed?
- Which agents have the strongest combination of satisfaction and resolution efficiency?
- Is customer satisfaction changing over time?
- Is resolution efficiency improving or declining?
- What operational areas should management prioritize?

## Project Outcome

This project demonstrates an end-to-end **Business Analyst / Data Analyst workflow**: converting operational support data into cleaned datasets, analytical SQL, reusable KPIs, interactive reporting, and actionable business recommendations.

---

**Author:** D. Siddharth Patel  
**Focus:** Business Analysis | Data Analytics | SQL | Python | Power BI

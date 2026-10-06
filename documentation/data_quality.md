# Data Quality & Cleaning

## Objective

Prepare the customer-support dataset for reliable KPI reporting and business analysis.

## Cleaning Steps

### 1. Text Standardization

Categorical fields are normalized using trimming, uppercase conversion, and blank-to-null handling.

Examples include:

- Customer name
- City
- Region
- Support channel
- Issue category
- Priority
- Ticket status
- Refund flag
- Support agent

### 2. Category Standardization

Known aliases are consolidated into consistent business categories.

| Source Value | Standard Value |
|---|---|
| MAIL | EMAIL |
| APP | MOBILE APP |
| TECH PROBLEM | TECHNICAL ISSUE |
| REFUND | REFUND REQUEST |

### 3. Satisfaction Rating

String-formatted ratings such as `1.0` or `5.0` are converted to numeric values for analysis.

### 4. Duplicate Detection

Duplicate ticket IDs are identified using `ROW_NUMBER()` partitioned by ticket ID. Where multiple records exist, completeness is used to retain the most informative record.

### 5. Date Validation

Created and resolved dates are validated before calculating resolution duration.

```text
Resolution Days = Resolved Date - Created Date
```

Negative durations are treated as data-quality exceptions and should be reviewed before reporting.

### 6. Python Operational Metrics

The Python workflow derives:

- First Response Hours
- Resolution Hours
- Resolution Days

These metrics support operational-efficiency analysis and Power BI reporting.

## Quality Principle

The cleaned dataset should be treated as the analytical layer for downstream SQL, Python, and Power BI work so that KPI definitions remain consistent across tools.

# Power BI DAX Measures

These measures form the executive KPI layer of the customer-support dashboard.

## Core KPIs

```DAX
Total Tickets =
COUNT('Support Tickets'[ticket_id])
```

```DAX
Unique Customers =
DISTINCTCOUNT('Support Tickets'[customer_id])
```

```DAX
Open Tickets =
CALCULATE(
    COUNT('Support Tickets'[ticket_id]),
    'Support Tickets'[ticket_status] = "OPEN"
)
```

```DAX
Avg Satisfaction Rating =
AVERAGE('Support Tickets'[satisfaction_rating])
```

```DAX
Avg Resolution Days =
AVERAGE('Support Tickets'[resolution_days])
```

```DAX
Refund % =
DIVIDE(
    CALCULATE(
        COUNTROWS('Support Tickets'),
        'Support Tickets'[refund_requested] = "YES"
    ) * 100,
    COUNTROWS('Support Tickets'),
    0
)
```

```DAX
Closed Tickets =
CALCULATE(
    COUNT('Support Tickets'[ticket_id]),
    'Support Tickets'[ticket_status] = "CLOSED"
)
```

## Modeling Notes

- Keep measure names business-friendly and consistent.
- Format satisfaction as a decimal with two places.
- Format Refund % as a percentage in the final model if the measure is implemented as a ratio rather than a 0–100 value.
- Use the same cleaned dataset used by the SQL analysis to keep KPI definitions consistent across the project.

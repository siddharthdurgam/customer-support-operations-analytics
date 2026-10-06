"""Customer Support Operations Analytics

Reusable Python workflow for preparing customer-support ticket data and
producing operational response/resolution metrics and ticket-text insights.

Expected input:
    data/raw/customer_support_tickets.csv

Output:
    data/processed/cleaned_support_tickets.csv
"""

from pathlib import Path
import re

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "raw" / "customer_support_tickets.csv"
OUTPUT_PATH = PROJECT_ROOT / "data" / "processed" / "cleaned_support_tickets.csv"


def normalize_text(value: object) -> object:
    """Trim whitespace and normalize non-null categorical text."""
    if pd.isna(value):
        return pd.NA
    cleaned = re.sub(r"\s+", " ", str(value)).strip().upper()
    return cleaned if cleaned else pd.NA


def load_data(path: Path) -> pd.DataFrame:
    """Load the raw support-ticket dataset."""
    if not path.exists():
        raise FileNotFoundError(
            f"Input dataset not found: {path}. "
            "Place the raw CSV in data/raw/."
        )
    return pd.read_csv(path)


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """Clean fields and calculate operational response/resolution metrics."""
    required_columns = {
        "Ticket ID",
        "Customer ID",
        "Date of Purchase",
        "First Response Time",
        "Time to Resolution",
        "Ticket Description",
    }
    missing = required_columns - set(df.columns)
    if missing:
        raise ValueError(f"Missing required columns: {sorted(missing)}")

    cleaned = df.copy()

    # Standardize categorical text fields where present.
    categorical_columns = [
        "Customer Name",
        "Customer Type",
        "City",
        "Region",
        "Support Channel",
        "Issue Category",
        "Priority",
        "Ticket Status",
        "Refund Requested",
        "Support Agent",
        "Ticket Type",
    ]
    for column in categorical_columns:
        if column in cleaned.columns:
            cleaned[column] = cleaned[column].map(normalize_text)

    # Standardize known category aliases.
    if "Support Channel" in cleaned.columns:
        cleaned["Support Channel"] = cleaned["Support Channel"].replace(
            {"MAIL": "EMAIL", "APP": "MOBILE APP"}
        )

    if "Issue Category" in cleaned.columns:
        cleaned["Issue Category"] = cleaned["Issue Category"].replace(
            {"TECH PROBLEM": "TECHNICAL ISSUE", "REFUND": "REFUND REQUEST"}
        )

    # Parse date/time fields safely.
    date_columns = [
        "Date of Purchase",
        "First Response Time",
        "Time to Resolution",
        "Created Date",
        "Resolved Date",
    ]
    for column in date_columns:
        if column in cleaned.columns:
            cleaned[column] = pd.to_datetime(cleaned[column], errors="coerce")

    # Numeric satisfaction rating.
    if "Customer Satisfaction Rating" in cleaned.columns:
        cleaned["Customer Satisfaction Rating"] = pd.to_numeric(
            cleaned["Customer Satisfaction Rating"], errors="coerce"
        )

    # Operational metrics.
    cleaned["First Response Hours"] = (
        cleaned["First Response Time"] - cleaned["Date of Purchase"]
    ).dt.total_seconds() / 3600

    cleaned["Resolution Hours"] = (
        cleaned["Time to Resolution"] - cleaned["First Response Time"]
    ).dt.total_seconds() / 3600

    cleaned["Resolution Days"] = cleaned["Resolution Hours"] / 24

    # Keep the most complete record when duplicate ticket IDs exist.
    if "Ticket ID" in cleaned.columns:
        completeness_columns = [
            column for column in [
                "City",
                "Customer Type",
                "Support Channel",
                "Customer Satisfaction Rating",
                "Support Agent",
            ]
            if column in cleaned.columns
        ]
        if completeness_columns:
            cleaned["_completeness_score"] = cleaned[completeness_columns].notna().sum(axis=1)
            cleaned = (
                cleaned.sort_values(["Ticket ID", "_completeness_score"], ascending=[True, False])
                .drop_duplicates(subset="Ticket ID", keep="first")
                .drop(columns="_completeness_score")
            )

    return cleaned


def ticket_text_summary(df: pd.DataFrame, top_n: int = 20) -> pd.DataFrame:
    """Return the most frequent alphabetic words in ticket descriptions."""
    if "Ticket Description" not in df.columns:
        return pd.DataFrame(columns=["word", "frequency"])

    text = " ".join(df["Ticket Description"].dropna().astype(str)).lower()
    words = re.findall(r"[a-z]+", text)

    stop_words = {
        "the", "and", "for", "with", "this", "that", "from", "have", "has",
        "was", "were", "are", "but", "not", "you", "your", "our", "they",
        "their", "been", "can", "will", "would", "could", "about", "into",
        "very", "more", "than", "what", "when", "where", "which", "please",
    }
    frequencies = pd.Series(
        word for word in words if word not in stop_words
    ).value_counts().head(top_n)

    return frequencies.rename_axis("word").reset_index(name="frequency")


def print_kpis(df: pd.DataFrame) -> None:
    """Print a concise operational KPI summary."""
    print("\nCustomer Support Operations KPIs")
    print("=" * 38)
    print(f"Total tickets: {len(df):,}")

    if "Customer ID" in df.columns:
        print(f"Unique customers: {df['Customer ID'].nunique():,}")

    if "Ticket Status" in df.columns:
        print(f"Open tickets: {(df['Ticket Status'] == 'OPEN').sum():,}")

    if "Customer Satisfaction Rating" in df.columns:
        print(f"Average satisfaction: {df['Customer Satisfaction Rating'].mean():.2f} / 5")

    if "Resolution Days" in df.columns:
        print(f"Average resolution time: {df['Resolution Days'].mean():.2f} days")

    if "Refund Requested" in df.columns:
        refund_rate = (df["Refund Requested"] == "YES").mean() * 100
        print(f"Refund request rate: {refund_rate:.2f}%")


def main() -> None:
    raw = load_data(INPUT_PATH)
    cleaned = clean_data(raw)
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    cleaned.to_csv(OUTPUT_PATH, index=False)

    print_kpis(cleaned)

    word_summary = ticket_text_summary(cleaned)
    print("\nTop ticket-description terms")
    print(word_summary.to_string(index=False))
    print(f"\nCleaned dataset saved to: {OUTPUT_PATH}")


if __name__ == "__main__":
    main()

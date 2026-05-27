# Hospital Operations BI Project

End-to-end business intelligence pipeline built on CMS Hospital Compare public data.
Mirrors the analytical work of a hospital operations analytics team.

## Stack
- Python (ETL pipeline)
- SQL (star schema warehouse + analytics)
- Tableau (operational dashboards)

## Data Source
CMS Hospital Compare — General Information
https://data.cms.gov/provider-data/dataset/xubh-q36u

## Live Dashboard
**Tableau Public:** https://public.tableau.com/app/profile/sukhraj.singh6336/viz/USHospitalOperationsPerformanceDashboard/HospitalOperationsOverview

## Key Findings
- **Utah ranks #1** nationally with an avg star rating of 4.24 — 45 of 46 hospitals are 5-star
- **Mississippi ranks last** among US states with 2.33 avg rating and 36 one-star hospitals
- **199 hospitals** are statistical anomalies — performing 2+ standard deviations below the national average of 3.21
- **New Jersey leads** readmission risk with 88.7% of hospitals flagged as high risk
- **NorthShore University Health System** ranks #1 nationally on mortality measures with 7 measures better than national average

## Project Structure
hospital-ops-bi/
├── data/
│   ├── raw/          # CMS Hospital Compare source data
│   └── processed/    # DuckDB warehouse
├── etl/              # Python ingestion pipeline
├── sql/              # 6 analytical query files
├── tableau/          # Dashboard CSVs and exports
└── docs/             # Data dictionary
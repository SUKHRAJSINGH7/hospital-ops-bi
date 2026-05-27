# Hospital Operations BI Project

End-to-end business intelligence pipeline built on CMS Hospital Compare public data.
Mirrors the analytical work of a hospital operations analytics team.

## Live Dashboard
[US Hospital Operations Performance Dashboard](https://public.tableau.com/app/profile/sukhraj.singh6336/viz/USHospitalOperationsPerformanceDashboard/HospitalOperationsOverview)

## Stack
- Python (ETL pipeline)
- DuckDB (star schema data warehouse)
- SQL (6 analytical queries)
- Tableau Public (operational dashboards)

## Data Source
CMS Hospital Compare — General Information
https://data.cms.gov/provider-data/dataset/xubh-q36u

## Key Findings
- Utah ranks #1 nationally with avg star rating of 4.24 — 45 of 46 hospitals are 5-star
- Mississippi ranks last among US states with 2.33 avg rating and 36 one-star hospitals
- 199 hospitals flagged as statistical anomalies — 2+ standard deviations below national avg of 3.21
- New Jersey leads readmission risk with 88.7% of hospitals flagged as high risk
- NorthShore University Health System ranks #1 on mortality with 7 measures better than national average

## Project Structure
hospital-ops-bi/
├── data/
│   ├── raw/          # CMS Hospital Compare source data
│   └── processed/    # DuckDB warehouse
├── etl/              # Python ingestion pipeline
├── sql/              # 6 analytical query files
├── tableau/          # Dashboard CSVs
└── docs/             # Data dictionary

## Analytical Queries
| File | Business Question |
|------|------------------|
| analysis_01_kpi_summary.sql | Which states have highest/lowest performing hospitals? |
| analysis_02_top_bottom_hospitals.sql | Which hospitals are best and worst nationally? |
| analysis_03_anomaly_detection.sql | Which hospitals are statistical outliers? |
| analysis_04_regional_benchmarking.sql | How does each state compare to national average? |
| analysis_05_readmission_analysis.sql | Which hospitals have worst readmission performance? |
| analysis_06_safety_performance.sql | How do hospitals rank percentile-wise on safety? |
# Hospital Operations BI Project
> Built as a portfolio project targeting hospital operations analytics roles.
> Mirrors the data pipeline, SQL analytics, and dashboard development work

## Live Dashboard
[US Hospital Operations Performance Dashboard](https://public.tableau.com/app/profile/sukhraj.singh6336/viz/USHospitalOperationsPerformanceDashboard/HospitalOperationsOverview)

## Live Dashboard
[US Hospital Operations Performance Dashboard](https://public.tableau.com/app/profile/sukhraj.singh6336/viz/USHospitalOperationsPerformanceDashboard/HospitalOperationsOverview)

## Analytical Workbook
[Hospital Operations Excel Analytics](https://docs.google.com/spreadsheets/d/1OdOiXWPe1A1nCjDN_eN8eFQMckPi9MXG1w9vLY2dOsw/edit?usp=sharing)

## Project Overview
End-to-end business intelligence pipeline analyzing 5,432 US hospitals across
mortality, safety, readmission, and patient experience performance measures.
Built on CMS Hospital Compare public data using a star schema data warehouse,
6 analytical SQL queries, and an operational Tableau dashboard.

## Tech Stack
| Tool | Purpose |
| Python 3.11 | ETL pipeline and data ingestion |
| DuckDB | Star schema data warehouse |
| SQL | 6 analytical queries (window functions, CTEs, z-scores) |
| Tableau Public | 3-sheet operational dashboard |
| Excel | Executive workbook with 6 formatted analytical sheets |

## Data Source
CMS Hospital Compare — General Information (5,432 hospitals, 38 fields)
https://data.cms.gov/provider-data/dataset/xubh-q36u

## Data Architecture
**Fact Table:** fact_hospital_performance (11,735 rows)
**Dimensions:** dim_hospital, dim_measure_group
**Measure Groups:** Mortality · Patient Safety · Readmission · Patient Experience

## Key Findings
- **Utah** ranks #1 nationally — avg star rating 4.24, 45 of 46 hospitals are 5-star
- **Mississippi** ranks last — avg rating 2.33 with 36 one-star hospitals
- **199 hospitals** flagged as statistical anomalies (z-score < -2.02)
- **New Jersey** leads readmission risk — 88.7% of hospitals flagged HIGH RISK
- **NorthShore University Health System** ranks #1 on mortality — 7 measures better than national average
- National average star rating: **3.21** across all 5,432 hospitals

## Analytical Queries
| Query | Business Question | Key Concepts |
|-------|------------------|--------------|
| analysis_01_kpi_summary.sql | Which states have highest/lowest performing hospitals? | GROUP BY, CASE WHEN, aggregations |
| analysis_02_top_bottom_hospitals.sql | Which hospitals are best and worst nationally? | DENSE_RANK, CTE, window functions |
| analysis_03_anomaly_detection.sql | Which hospitals are statistical outliers? | STDDEV, z-scores, CROSS JOIN |
| analysis_04_regional_benchmarking.sql | How does each state compare to national average? | CTE, benchmarking, CASE WHEN |
| analysis_05_readmission_analysis.sql | Which hospitals have worst readmission performance? | Risk flagging, AVG comparison |
| analysis_06_safety_performance.sql | How do hospitals rank percentile-wise on safety? | NTILE, percentile ranking |

## Deliverables
- **Tableau Dashboard** — 3-sheet operational dashboard published to Tableau Public
- **Excel Workbook** — 6-sheet formatted analytical workbook with executive summary
- **DuckDB Warehouse** — Star schema with fact and dimension tables
- **SQL Analytics** — 6 production-ready analytical query files

## Project Structure

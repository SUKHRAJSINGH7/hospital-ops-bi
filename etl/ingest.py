import duckdb
import os

RAW_PATH = "data/raw/hospitals_raw.csv"
DB_PATH  = "data/processed/hospital_ops.duckdb"

os.makedirs("data/processed", exist_ok=True)
conn = duckdb.connect(DB_PATH)

# ── Staging ───────────────────────────────────────────────────
print("Loading staging table...")
conn.execute(f"""
    CREATE OR REPLACE TABLE hospital_staging AS
    SELECT
        "Facility ID"                          AS hospital_id,
        "Facility Name"                        AS hospital_name,
        "Address"                              AS address,
        "City/Town"                            AS city,
        "State"                                AS state,
        "ZIP Code"                             AS zip,
        "County/Parish"                        AS county,
        "Telephone Number"                     AS phone,
        "Hospital Type"                        AS hospital_type,
        "Hospital Ownership"                   AS hospital_ownership,
        "Emergency Services"                   AS emergency_services,
        TRY_CAST("Hospital overall rating" AS INTEGER)            AS overall_rating,
        TRY_CAST("Count of Facility MORT Measures" AS INTEGER)    AS mort_count,
        TRY_CAST("Count of MORT Measures Better" AS INTEGER)      AS mort_better,
        TRY_CAST("Count of MORT Measures No Different" AS INTEGER) AS mort_no_diff,
        TRY_CAST("Count of MORT Measures Worse" AS INTEGER)       AS mort_worse,
        TRY_CAST("Count of Facility Safety Measures" AS INTEGER)  AS safety_count,
        TRY_CAST("Count of Safety Measures Better" AS INTEGER)    AS safety_better,
        TRY_CAST("Count of Safety Measures No Different" AS INTEGER) AS safety_no_diff,
        TRY_CAST("Count of Safety Measures Worse" AS INTEGER)     AS safety_worse,
        TRY_CAST("Count of Facility READM Measures" AS INTEGER)   AS readm_count,
        TRY_CAST("Count of READM Measures Better" AS INTEGER)     AS readm_better,
        TRY_CAST("Count of READM Measures No Different" AS INTEGER) AS readm_no_diff,
        TRY_CAST("Count of READM Measures Worse" AS INTEGER)      AS readm_worse
    FROM read_csv_auto('{RAW_PATH}', header=true)
""")
print(f"  Rows: {conn.execute('SELECT COUNT(*) FROM hospital_staging').fetchone()[0]:,}")

# ── Dim Hospital ──────────────────────────────────────────────
print("Building dim_hospital...")
conn.execute("""
    CREATE OR REPLACE TABLE dim_hospital AS
    SELECT DISTINCT
        hospital_id,
        hospital_name,
        address,
        city,
        state,
        zip,
        county,
        phone,
        hospital_type,
        hospital_ownership,
        emergency_services
    FROM hospital_staging
    WHERE hospital_id IS NOT NULL
""")
print(f"  Rows: {conn.execute('SELECT COUNT(*) FROM dim_hospital').fetchone()[0]:,}")

# ── Dim Measure Group ─────────────────────────────────────────
print("Building dim_measure_group...")
conn.execute("""
    CREATE OR REPLACE TABLE dim_measure_group (
        measure_group_id  INTEGER,
        group_code        VARCHAR,
        group_name        VARCHAR,
        description       VARCHAR
    )
""")
conn.execute("""
    INSERT INTO dim_measure_group VALUES
        (1, 'MORT',   'Mortality',          'Death rate measures vs national average'),
        (2, 'SAFETY', 'Patient Safety',     'Safety event measures vs national average'),
        (3, 'READM',  'Readmission',        '30-day readmission rate measures'),
        (4, 'PT_EXP', 'Patient Experience', 'HCAHPS patient satisfaction measures')
""")
print(f"  Rows: {conn.execute('SELECT COUNT(*) FROM dim_measure_group').fetchone()[0]:,}")

# ── Fact Table ────────────────────────────────────────────────
print("Building fact_hospital_performance...")
conn.execute("""
    CREATE OR REPLACE TABLE fact_hospital_performance AS
    SELECT hospital_id, 1 AS measure_group_id, overall_rating,
           mort_count AS facility_measure_count,
           mort_better AS measures_better,
           mort_no_diff AS measures_no_different,
           mort_worse AS measures_worse
    FROM hospital_staging WHERE mort_count IS NOT NULL

    UNION ALL

    SELECT hospital_id, 2, overall_rating,
           safety_count, safety_better, safety_no_diff, safety_worse
    FROM hospital_staging WHERE safety_count IS NOT NULL

    UNION ALL

    SELECT hospital_id, 3, overall_rating,
           readm_count, readm_better, readm_no_diff, readm_worse
    FROM hospital_staging WHERE readm_count IS NOT NULL
""")
print(f"  Rows: {conn.execute('SELECT COUNT(*) FROM fact_hospital_performance').fetchone()[0]:,}")

conn.close()
print("\nETL complete. DuckDB warehouse ready.")

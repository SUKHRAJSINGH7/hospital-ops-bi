-- ============================================================
-- HOSPITAL OPS BI — Star Schema + Data Load
-- ============================================================

-- ── Create Tables ────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS dim_hospital (
    hospital_id        TEXT PRIMARY KEY,
    hospital_name      TEXT,
    address            TEXT,
    city               TEXT,
    state              TEXT,
    zip                TEXT,
    county             TEXT,
    phone              TEXT,
    hospital_type      TEXT,
    hospital_ownership TEXT,
    emergency_services TEXT
);

CREATE TABLE IF NOT EXISTS dim_measure_group (
    measure_group_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    group_code        TEXT UNIQUE,
    group_name        TEXT,
    description       TEXT
);

CREATE TABLE IF NOT EXISTS fact_hospital_performance (
    performance_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    hospital_id            TEXT REFERENCES dim_hospital(hospital_id),
    measure_group_id       INTEGER REFERENCES dim_measure_group(measure_group_id),
    overall_rating         REAL,
    facility_measure_count INTEGER,
    measures_better        INTEGER,
    measures_no_different  INTEGER,
    measures_worse         INTEGER
);

-- ── Populate dim_hospital ─────────────────────────────────────

INSERT OR IGNORE INTO dim_hospital
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
FROM hospital_staging;

-- ── Populate dim_measure_group ────────────────────────────────

INSERT OR IGNORE INTO dim_measure_group (group_code, group_name, description)
VALUES
    ('MORT',   'Mortality',          'Death rate measures compared to national average'),
    ('SAFETY', 'Patient Safety',     'Safety event measures compared to national average'),
    ('READM',  'Readmission',        '30-day readmission rate measures'),
    ('PT_EXP', 'Patient Experience', 'HCAHPS patient satisfaction measures');

-- ── Populate fact_hospital_performance ───────────────────────

-- MORT
INSERT INTO fact_hospital_performance
    (hospital_id, measure_group_id, overall_rating,
     facility_measure_count, measures_better, measures_no_different, measures_worse)
SELECT
    s.hospital_id,
    mg.measure_group_id,
    s.overall_rating,
    s.count_of_facility_mort_measures,
    s.count_of_mort_measures_better,
    s.count_of_mort_measures_no_different,
    s.count_of_mort_measures_worse
FROM hospital_staging s
JOIN dim_measure_group mg ON mg.group_code = 'MORT'
WHERE s.count_of_facility_mort_measures IS NOT NULL;

-- SAFETY
INSERT INTO fact_hospital_performance
    (hospital_id, measure_group_id, overall_rating,
     facility_measure_count, measures_better, measures_no_different, measures_worse)
SELECT
    s.hospital_id,
    mg.measure_group_id,
    s.overall_rating,
    s.count_of_facility_safety_measures,
    s.count_of_safety_measures_better,
    s.count_of_safety_measures_no_different,
    s.count_of_safety_measures_worse
FROM hospital_staging s
JOIN dim_measure_group mg ON mg.group_code = 'SAFETY'
WHERE s.count_of_facility_safety_measures IS NOT NULL;

-- READM
INSERT INTO fact_hospital_performance
    (hospital_id, measure_group_id, overall_rating,
     facility_measure_count, measures_better, measures_no_different, measures_worse)
SELECT
    s.hospital_id,
    mg.measure_group_id,
    s.overall_rating,
    s.count_of_facility_readm_measures,
    s.count_of_readm_measures_better,
    s.count_of_readm_measures_no_different,
    s.count_of_readm_measures_worse
FROM hospital_staging s
JOIN dim_measure_group mg ON mg.group_code = 'READM'
WHERE s.count_of_facility_readm_measures IS NOT NULL;
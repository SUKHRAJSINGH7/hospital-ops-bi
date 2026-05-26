-- Which hospitals have the worst readmission performance compared to the national average?
WITH rs AS (
    SELECT ROUND(AVG(measures_worse), 2) AS avg_readm_worse
    FROM fact_hospital_performance
    WHERE measure_group_id = 3 AND measures_worse IS NOT NULL
)
SELECT 
    h.hospital_name,
    h.state,
    h.city,
    f.measures_better,
    f.measures_worse,
    f.overall_rating,
    rs.avg_readm_worse AS national_avg_worse,
    CASE
        WHEN f.measures_worse > rs.avg_readm_worse THEN 'High RISK'
        ELSE 'NORMAL'
    END As risk_flag
FROM fact_hospital_performance f
JOIN dim_hospital h ON h.hospital_id = f.hospital_id
JOIN dim_measure_group mg ON mg.measure_group_id = f.measure_group_id
CROSS JOIN rs
WHERE mg.group_code = 'READM'
ORDER BY f.measures_worse DESC;
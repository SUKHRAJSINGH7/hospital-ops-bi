-- How do hospitals rank percentile-wise on patient safety measures nationally?
SELECT
    h.hospital_name,
    h.state,
    h.city,
    f.measures_better,
    f.measures_worse,
    NTILE(100) OVER (ORDER BY f.measures_better DESC) AS safety_percentile
FROM fact_hospital_performance f
JOIN dim_hospital h ON h.hospital_id = f.hospital_id
JOIN dim_measure_group mg ON mg.measure_group_id = f.measure_group_id
WHERE mg.group_code = 'SAFETY'
AND f.measures_better IS NOT NULL
ORDER BY safety_percentile DESC;

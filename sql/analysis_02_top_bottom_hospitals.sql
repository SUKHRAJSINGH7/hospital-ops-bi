-- Which individual hospitals are the best and worst performers, 
-- What does their measure breakdown look like?

WITH ranked AS (
    SELECT
    h.hospital_name,
    h.state,
    h.city,
    f.overall_rating,
    f.measures_better,
    f.measures_worse,
    DENSE_RANK() OVER 
        (ORDER BY f.overall_rating DESC, f.measures_better DESC)  AS national_rank
FROM fact_hospital_performance f
JOIN dim_hospital h ON h.hospital_id = f.hospital_id
JOIN dim_measure_group mg ON mg.measure_group_id = f.measure_group_id
WHERE mg.group_code = 'MORT'
AND f.overall_rating IS NOT NULL
ORDER BY national_rank
)
SELECT * FROM ranked
WHERE national_rank <= 5
    OR national_rank >= (SELECT MAX(national_rank) FROM ranked) - 4
ORDER BY national_rank;

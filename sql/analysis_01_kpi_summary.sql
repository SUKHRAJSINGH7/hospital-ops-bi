-- Query 01: KPI Summary by State
-- Business Question: Which states have the highest and lowest
-- performing hospitals based on overall star ratings?
-- Used for: Executive reporting, regional benchmarking

SELECT
    h.state, 
    COUNT(DISTINCT h.hospital_id)                      AS total_hospitals,
    ROUND(AVG(f.overall_rating), 2)                    AS avg_star_rating, 
    COUNT(CASE WHEN f.overall_rating = 5 THEN 1 END)   AS five_star_count,
    COUNT(CASE WHEN f.overall_rating = 1 THEN 1 END)              AS one_star_count,
    ROUND(AVG(f.measures_better), 2)                   AS avg_measures_better,
    ROUND(AVG(f.measures_worse), 2)                    AS avg_measures_worse
FROM fact_hospital_performance f
JOIN dim_hospital h ON h.hospital_id = f.hospital_id
JOIN dim_measure_group mg ON mg.measure_group_id = f.measure_group_id
GROUP BY h.state
ORDER BY avg_star_rating DESC;

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
        (ORDER BY f.overall_rating DESC, f.measure_better DESC)  AS national_rank
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
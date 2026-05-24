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

-- Which hospitals are statistical outliers — performing significantly worse than the national average on mortality measures?
WITH national_stats AS (
    SELECT
        AVG(overall_rating)   AS avg_rating,
        STDDEV(overall_rating) AS stddev_rating
    FROM fact_hospital_performance
    WHERE overall_rating IS NOT NULL
), 
hospital_scores AS (
    SELECT
        h.hospital_name,
        h.state,
        h.city,
        f.overall_rating,
        ROUND(ns.avg_rating, 2)                                    AS national_avg,
        ROUND((f.overall_rating - ns.avg_rating) 
              / ns.stddev_rating, 2)                               AS z_score,
        CASE 
            WHEN (f.overall_rating - ns.avg_rating) 
                 / ns.stddev_rating < -2 
            THEN 'ANOMALY' 
            ELSE 'Normal' 
        END                                                        AS flag
    FROM fact_hospital_performance f
    JOIN dim_hospital h ON h.hospital_id = f.hospital_id
    JOIN dim_measure_group mg ON mg.measure_group_id = f.measure_group_id
    CROSS JOIN national_stats ns
    WHERE mg.group_code = 'MORT'
    AND f.overall_rating IS NOT NULL
)

SELECT * FROM hospital_scores
WHERE flag = 'ANOMALY'
ORDER BY z_score ASC;

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

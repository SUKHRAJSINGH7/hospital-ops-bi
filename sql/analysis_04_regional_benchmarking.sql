-- How does each state compare against the national average — which states are above, at, or below the national benchmark?
WITH national_avg AS (
    SELECT ROUND(AVG(overall_rating), 2) AS national_avg
    FROM fact_hospital_performance
    WHERE overall_rating IS NOT NULL
)
SELECT
    h.state, 
    ROUND(AVG(f.overall_rating), 2) AS state_avg,
    ns.national_avg                 AS national_avg,
    CASE 
        WHEN AVG(f.overall_rating) < ns.national_avg THEN 'BELOW'
        WHEN AVG(f.overall_rating) > ns.national_avg THEN 'ABOVE'
    ELSE 'At BENCHMARK'
END AS benchmark_status
FROM fact_hospital_performance f 
JOIN dim_hospital h ON h.hospital_id = f.hospital_id
JOIN dim_measure_group mg ON mg.measure_group_id = f.measure_group_id
CROSS JOIN national_avg ns
GROUP BY h.state, ns.national_avg
ORDER BY state_avg DESC;

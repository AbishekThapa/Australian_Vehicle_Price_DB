--Average Vehicle Price by Brand
SELECT 
    b.brand_name,
    ROUND(AVG(v.price)::numeric, 2) AS avg_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM brands b
JOIN models m ON b.brand_id = m.brand_id
JOIN vehicle_inventory v ON m.model_id = v.model_id
GROUP BY b.brand_name
HAVING COUNT(v.vehicle_id) >= 5
ORDER BY avg_price DESC;

Price Distribution by Year
SELECT
    year,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price)::numeric, 2) AS average_price,
    COUNT(vehicle_id) AS total_vehicles
FROM vehicle_inventory
WHERE year BETWEEN 2000 AND 2025
GROUP BY year
ORDER BY year


--Top 5 Most Expensive Models by Location
WITH ranked_vehicles AS (
    SELECT 
        l.location_name,
        b.brand_name,
        m.model_name,
        v.price,
        RANK() OVER (PARTITION BY l.location_name ORDER BY v.price DESC) AS price_rank
    FROM vehicle_inventory v
    JOIN models m ON v.model_id = m.model_id
    JOIN brands b ON m.brand_id = b.brand_id
    JOIN locations l ON v.location_id = l.location_id
    WHERE v.price IS NOT NULL
)
SELECT *
FROM ranked_vehicles
WHERE price_rank <= 5
ORDER BY location_name, price DESC;

--Price vs. Fuel Type Comparison
SELECT
    e.fuel_type,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM vehicle_inventory AS v
JOIN engine_specs AS e ON e.engine_id = v.engine_id
WHERE e.fuel_type IS NOT NULL
    AND e.fuel_type <> '-'
GROUP BY e.fuel_type
ORDER BY average_price DESC; 

--Price Correlation with Engine Size
SELECT
    e.engine_size,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM engine_specs AS e
JOIN vehicle_inventory AS v ON e.engine_id = v.engine_id
WHERE e.engine_size IS NOT NULL
    AND e.engine_size NOT IN ('-', '0 L')
GROUP BY e.engine_size
ORDER BY engine_size; 

--Regional Price Variation
SELECT
    b.brand_name,
    m.model_name,
    l.location_name,
    ROUND(AVG(v.price)::numeric, 2) AS average_price,
    COUNT(v.vehicle_id) AS total_vehicles
FROM vehicle_inventory AS v
JOIN models AS m ON m.model_id = v.model_id
JOIN locations AS l ON l.location_id = v.location_id
JOIN brands AS b ON b.brand_id = m.brand_id
GROUP BY b.brand_name, m.model_name, l.location_name
HAVING COUNT(v.vehicle_id) >= 3
ORDER BY b.brand_name, m.model_name, average_price DESC;







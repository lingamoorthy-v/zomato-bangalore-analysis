USE zomato_db;

-- 1. Table structure
DESCRIBE restaurants;

-- 2. Row counts
SELECT COUNT(*) AS restaurants_rows FROM restaurants;
SELECT COUNT(*) AS listings_rows FROM listings;
SELECT COUNT(*) AS cuisines_rows FROM cuisines;

-- 3. Preview
SELECT * FROM restaurants LIMIT 10;

-- 4. Missing values (COUNT(column) skips NULLs)
SELECT COUNT(*) AS total_rows,
       COUNT(*) - COUNT(rating) AS missing_rating,
       COUNT(*) - COUNT(phone) AS missing_phone
FROM restaurants;

-- 5. Duplicate restaurants (should return no rows)
SELECT name, address, COUNT(*) AS c
FROM restaurants
GROUP BY name, address
HAVING c > 1;

-- 6. Value ranges
SELECT MIN(rating), MAX(rating), ROUND(AVG(rating), 2),
       MIN(cost_for_two), MAX(cost_for_two),
       MIN(votes), MAX(votes)
FROM restaurants;

-- 7. Category values
SELECT price_category, COUNT(*) FROM restaurants GROUP BY price_category;
SELECT online_order, COUNT(*) FROM restaurants GROUP BY online_order;
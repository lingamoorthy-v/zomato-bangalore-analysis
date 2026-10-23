USE zomato_db;

-- Q1: How many restaurants are there in total?
SELECT COUNT(*) AS total_restaurants
FROM restaurants;

-- Q2: Top 10 areas by number of restaurants
SELECT location, COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY location
ORDER BY restaurant_count DESC
LIMIT 10;

-- Q3: Top 10 restaurants by votes
SELECT name, location, votes, rating
FROM restaurants
ORDER BY votes DESC
LIMIT 10;


-- Q4: Average rating and cost per area (areas with at least 20 restaurants)
SELECT location,
       COUNT(*) AS restaurants,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(AVG(cost_for_two), 0) AS avg_cost
FROM restaurants
GROUP BY location
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC;

-- Q5: Number of restaurants per price category
SELECT price_category, COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY price_category
ORDER BY restaurant_count DESC;

-- Q6: Average rating with vs without online ordering (only restaurants with 50+ votes)
SELECT online_order,
       COUNT(*) AS restaurants,
       ROUND(AVG(rating), 2) AS avg_rating
FROM restaurants
WHERE votes >= 50
GROUP BY online_order;


-- Q7: Restaurants per rating band using CASE WHEN
SELECT CASE
           WHEN rating IS NULL THEN 'Not rated'
           WHEN rating >= 4.0 THEN 'Excellent (4.0+)'
           WHEN rating >= 3.5 THEN 'Good (3.5-3.9)'
           WHEN rating >= 3.0 THEN 'Average (3.0-3.4)'
           ELSE 'Poor (below 3.0)'
       END AS rating_band,
       COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY rating_band
ORDER BY restaurant_count DESC;

-- Q8: Top 10 cuisines by number of restaurants
SELECT c.cuisine, COUNT(*) AS restaurant_count
FROM cuisines c
JOIN restaurants r ON c.restaurant_id = r.restaurant_id
GROUP BY c.cuisine
ORDER BY restaurant_count DESC
LIMIT 10;

-- Q9: Average rating per cuisine (cuisines with at least 30 rated restaurants)
SELECT c.cuisine,
       COUNT(r.rating) AS rated_restaurants,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM cuisines c
JOIN restaurants r ON c.restaurant_id = r.restaurant_id
GROUP BY c.cuisine
HAVING COUNT(r.rating) >= 30
ORDER BY avg_rating DESC
LIMIT 15;

-- Q10: Most common listing types
SELECT listing_type, COUNT(DISTINCT restaurant_id) AS restaurants
FROM listings
GROUP BY listing_type
ORDER BY restaurants DESC;


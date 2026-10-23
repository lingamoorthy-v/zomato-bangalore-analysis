CREATE DATABASE zomato_db CHARACTER SET utf8mb4;
USE zomato_db;

-- Convert empty text to real NULL
UPDATE restaurants SET rating = NULL WHERE rating = '' OR rating = 'NaN';
UPDATE restaurants SET phone = NULL WHERE phone = '' OR phone = 'NaN';
UPDATE restaurants SET price_category = NULL WHERE price_category = '' OR price_category = 'NaN';
UPDATE restaurants SET rating_category = NULL WHERE rating_category = '' OR rating_category = 'NaN';

-- Make rating numeric
ALTER TABLE restaurants MODIFY rating DOUBLE;

-- Primary key and indexes 
ALTER TABLE restaurants MODIFY restaurant_id INT NOT NULL;
ALTER TABLE restaurants ADD PRIMARY KEY (restaurant_id);
CREATE INDEX idx_listings_rid ON listings (restaurant_id);
CREATE INDEX idx_cuisines_rid ON cuisines (restaurant_id);
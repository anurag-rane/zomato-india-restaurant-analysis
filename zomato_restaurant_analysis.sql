-- ============================================================
-- Zomato India — Restaurant Intelligence Analysis
-- Dataset: 56,251 restaurants across Bangalore, India
-- Author: Anurag Rane
-- Platform: MySQL
-- Columns: url, address, name, online_order, book_table,
--          rate, votes, phone, location, rest_type,
--          dish_liked, cuisines, approx_cost(for two people),
--          reviews_list, menu_item, listed_in(type),
--          listed_in(city)
-- ============================================================
-- NOTE ON DATA CLEANING:
-- The 'rate' column contains values like "4.1/5" — strip "/5"
-- before analysis. The 'approx_cost' column may contain commas
-- (e.g. "1,200") — strip commas before casting to numeric.
-- Both cleanups are handled inline in the queries below.
-- ============================================================


-- ============================================================
-- SECTION I: DATA EXPLORATION & CLEANING
-- Understand structure, nulls, and data quality
-- ============================================================

-- Q1.1: Total number of restaurants in the dataset
SELECT
    COUNT(*)                        AS total_restaurants
FROM zomato;


-- Q1.2: Check for nulls in key columns
SELECT
    COUNT(*) - COUNT(name)                          AS null_names,
    COUNT(*) - COUNT(rate)                          AS null_ratings,
    COUNT(*) - COUNT(votes)                         AS null_votes,
    COUNT(*) - COUNT(location)                      AS null_locations,
    COUNT(*) - COUNT(cuisines)                      AS null_cuisines,
    COUNT(*) - COUNT(`approx_cost(for two people)`) AS null_costs,
    COUNT(*) - COUNT(online_order)                  AS null_online_order,
    COUNT(*) - COUNT(book_table)                    AS null_book_table
FROM zomato;


-- Q1.3: Unique locations (neighbourhoods) in the dataset
SELECT
    location,
    COUNT(*)                        AS restaurant_count
FROM zomato
WHERE location IS NOT NULL
GROUP BY location
ORDER BY restaurant_count DESC;


-- Q1.4: Unique restaurant types
SELECT
    rest_type,
    COUNT(*)                        AS restaurant_count
FROM zomato
WHERE rest_type IS NOT NULL
GROUP BY rest_type
ORDER BY restaurant_count DESC;


-- Q1.5: Distribution of online order availability
SELECT
    online_order,
    COUNT(*)                                        AS restaurant_count,
    ROUND(COUNT(*) * 100.0 /
          (SELECT COUNT(*) FROM zomato), 2)         AS percentage
FROM zomato
GROUP BY online_order;


-- Q1.6: Distribution of table booking availability
SELECT
    book_table,
    COUNT(*)                                        AS restaurant_count,
    ROUND(COUNT(*) * 100.0 /
          (SELECT COUNT(*) FROM zomato), 2)         AS percentage
FROM zomato
GROUP BY book_table;


-- ============================================================
-- SECTION II: RATINGS ANALYSIS
-- Which restaurants, cuisines and locations rate highest?
-- ============================================================

-- Q2.1: Overall rating distribution
-- Rate column stored as "4.1/5" — extract numeric value
SELECT
    ROUND(CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1)), 1) AS rating,
    COUNT(*)                                                 AS restaurant_count
FROM zomato
WHERE rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
GROUP BY rating
ORDER BY rating DESC;


-- Q2.2: Average rating by location — top 10 neighbourhoods
SELECT
    location,
    COUNT(*)                                                        AS total_restaurants,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1))), 2)   AS avg_rating,
    SUM(votes)                                                      AS total_votes
FROM zomato
WHERE rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
  AND location IS NOT NULL
GROUP BY location
HAVING total_restaurants >= 20
ORDER BY avg_rating DESC
LIMIT 10;


-- Q2.3: Average rating by restaurant type
SELECT
    rest_type,
    COUNT(*)                                                        AS total_restaurants,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1))), 2)   AS avg_rating
FROM zomato
WHERE rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
  AND rest_type IS NOT NULL
GROUP BY rest_type
HAVING total_restaurants >= 10
ORDER BY avg_rating DESC;


-- Q2.4: Top 10 highest rated restaurants (minimum 100 votes)
SELECT
    name,
    location,
    cuisines,
    CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1))   AS rating,
    votes
FROM zomato
WHERE rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
  AND votes >= 100
ORDER BY rating DESC, votes DESC
LIMIT 10;


-- Q2.5: Rating vs online order availability
-- Do restaurants with online ordering rate higher?
SELECT
    online_order,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1))), 2)   AS avg_rating,
    COUNT(*)                                                        AS restaurant_count
FROM zomato
WHERE rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
GROUP BY online_order;


-- ============================================================
-- SECTION III: CUISINE ANALYSIS
-- Which cuisines dominate Bangalore's food scene?
-- ============================================================

-- Q3.1: Top 15 most popular cuisines by restaurant count
-- Note: cuisines column can contain multiple comma-separated values
-- This query counts restaurants per primary cuisine
SELECT
    TRIM(SUBSTRING_INDEX(cuisines, ',', 1))     AS primary_cuisine,
    COUNT(*)                                     AS restaurant_count,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '')
              AS DECIMAL(3,1))), 2)              AS avg_rating
FROM zomato
WHERE cuisines IS NOT NULL
  AND rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
GROUP BY primary_cuisine
HAVING restaurant_count >= 20
ORDER BY restaurant_count DESC
LIMIT 15;


-- Q3.2: Top cuisines by average rating (min 30 restaurants)
SELECT
    TRIM(SUBSTRING_INDEX(cuisines, ',', 1))     AS primary_cuisine,
    COUNT(*)                                     AS restaurant_count,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '')
              AS DECIMAL(3,1))), 2)              AS avg_rating,
    ROUND(AVG(CAST(REPLACE(
        `approx_cost(for two people)`, ',', '')
        AS DECIMAL(10,2))), 0)                   AS avg_cost_for_two
FROM zomato
WHERE cuisines IS NOT NULL
  AND rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
  AND `approx_cost(for two people)` IS NOT NULL
GROUP BY primary_cuisine
HAVING restaurant_count >= 30
ORDER BY avg_rating DESC
LIMIT 10;


-- Q3.3: Cuisine distribution by location — top 5 locations
SELECT
    location,
    TRIM(SUBSTRING_INDEX(cuisines, ',', 1))     AS primary_cuisine,
    COUNT(*)                                     AS restaurant_count
FROM zomato
WHERE cuisines IS NOT NULL
  AND location IN (
      SELECT location FROM zomato
      GROUP BY location
      ORDER BY COUNT(*) DESC
      LIMIT 5
  )
GROUP BY location, primary_cuisine
ORDER BY location, restaurant_count DESC;


-- ============================================================
-- SECTION IV: COST ANALYSIS
-- Pricing patterns across locations, cuisines and types
-- ============================================================

-- Q4.1: Average cost for two by location — most to least expensive
SELECT
    location,
    COUNT(*)                                                AS restaurant_count,
    ROUND(AVG(CAST(REPLACE(
        `approx_cost(for two people)`, ',', '')
        AS DECIMAL(10,2))), 0)                              AS avg_cost_for_two,
    ROUND(MIN(CAST(REPLACE(
        `approx_cost(for two people)`, ',', '')
        AS DECIMAL(10,2))), 0)                              AS min_cost,
    ROUND(MAX(CAST(REPLACE(
        `approx_cost(for two people)`, ',', '')
        AS DECIMAL(10,2))), 0)                              AS max_cost
FROM zomato
WHERE `approx_cost(for two people)` IS NOT NULL
  AND location IS NOT NULL
GROUP BY location
HAVING restaurant_count >= 20
ORDER BY avg_cost_for_two DESC
LIMIT 10;


-- Q4.2: Cost vs rating correlation
-- Do more expensive restaurants rate higher?
SELECT
    CASE
        WHEN CAST(REPLACE(`approx_cost(for two people)`,
             ',', '') AS DECIMAL(10,2)) < 300   THEN 'Budget (< ₹300)'
        WHEN CAST(REPLACE(`approx_cost(for two people)`,
             ',', '') AS DECIMAL(10,2)) < 600   THEN 'Mid-range (₹300–600)'
        WHEN CAST(REPLACE(`approx_cost(for two people)`,
             ',', '') AS DECIMAL(10,2)) < 1000  THEN 'Premium (₹600–1000)'
        ELSE 'Fine Dining (₹1000+)'
    END                                                     AS price_segment,
    COUNT(*)                                                AS restaurant_count,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '')
              AS DECIMAL(3,1))), 2)                         AS avg_rating,
    ROUND(AVG(votes), 0)                                    AS avg_votes
FROM zomato
WHERE `approx_cost(for two people)` IS NOT NULL
  AND rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
GROUP BY price_segment
ORDER BY avg_cost_for_two;


-- Q4.3: Best value restaurants — high rating, low cost
-- (Rating >= 4.0, cost <= 400 for two, votes >= 50)
SELECT
    name,
    location,
    cuisines,
    CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1))           AS rating,
    votes,
    CAST(REPLACE(`approx_cost(for two people)`,
         ',', '') AS DECIMAL(10,2))                         AS cost_for_two
FROM zomato
WHERE CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1)) >= 4.0
  AND CAST(REPLACE(`approx_cost(for two people)`,
      ',', '') AS DECIMAL(10,2)) <= 400
  AND votes >= 50
  AND rate NOT IN ('NEW', '-', '')
ORDER BY rating DESC, votes DESC
LIMIT 15;


-- ============================================================
-- SECTION V: LOCATION INTELLIGENCE
-- Where should a new restaurant operator set up?
-- ============================================================

-- Q5.1: Restaurant density by location
SELECT
    location,
    COUNT(*)                                                AS total_restaurants,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '')
              AS DECIMAL(3,1))), 2)                         AS avg_rating,
    ROUND(AVG(votes), 0)                                    AS avg_votes,
    ROUND(AVG(CAST(REPLACE(
        `approx_cost(for two people)`, ',', '')
        AS DECIMAL(10,2))), 0)                              AS avg_cost_for_two,
    SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END)  AS online_order_count,
    SUM(CASE WHEN book_table = 'Yes' THEN 1 ELSE 0 END)    AS book_table_count
FROM zomato
WHERE location IS NOT NULL
  AND rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
GROUP BY location
HAVING total_restaurants >= 30
ORDER BY total_restaurants DESC
LIMIT 15;


-- Q5.2: Underserved locations — high avg rating but low restaurant count
-- Signals demand exceeding supply
SELECT
    location,
    COUNT(*)                                                AS total_restaurants,
    ROUND(AVG(CAST(REPLACE(rate, '/5', '')
              AS DECIMAL(3,1))), 2)                         AS avg_rating,
    ROUND(AVG(votes), 0)                                    AS avg_votes
FROM zomato
WHERE location IS NOT NULL
  AND rate NOT IN ('NEW', '-', '')
  AND rate IS NOT NULL
GROUP BY location
HAVING total_restaurants BETWEEN 10 AND 50
   AND avg_rating >= 4.0
ORDER BY avg_rating DESC, avg_votes DESC
LIMIT 10;


-- Q5.3: Online ordering adoption by location
SELECT
    location,
    COUNT(*)                                                AS total_restaurants,
    SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END)  AS online_enabled,
    ROUND(SUM(CASE WHEN online_order = 'Yes'
                   THEN 1 ELSE 0 END) * 100.0 /
          COUNT(*), 2)                                      AS online_order_pct
FROM zomato
WHERE location IS NOT NULL
GROUP BY location
HAVING total_restaurants >= 30
ORDER BY online_order_pct DESC
LIMIT 10;


-- ============================================================
-- SECTION VI: ADVANCED ANALYSIS — CTEs & WINDOW FUNCTIONS
-- ============================================================

-- Q6.1: Location ranking by avg rating using WINDOW FUNCTION
SELECT
    location,
    total_restaurants,
    avg_rating,
    avg_cost_for_two,
    RANK() OVER (ORDER BY avg_rating DESC)          AS rating_rank,
    RANK() OVER (ORDER BY total_restaurants DESC)   AS volume_rank
FROM (
    SELECT
        location,
        COUNT(*)                                                AS total_restaurants,
        ROUND(AVG(CAST(REPLACE(rate, '/5', '')
                  AS DECIMAL(3,1))), 2)                         AS avg_rating,
        ROUND(AVG(CAST(REPLACE(
            `approx_cost(for two people)`, ',', '')
            AS DECIMAL(10,2))), 0)                              AS avg_cost_for_two
    FROM zomato
    WHERE rate NOT IN ('NEW', '-', '')
      AND rate IS NOT NULL
      AND location IS NOT NULL
    GROUP BY location
    HAVING total_restaurants >= 30
) AS location_summary;


-- Q6.2: Cuisine popularity ranking within each location — CTE
WITH cuisine_location AS (
    SELECT
        location,
        TRIM(SUBSTRING_INDEX(cuisines, ',', 1))     AS primary_cuisine,
        COUNT(*)                                     AS restaurant_count,
        ROUND(AVG(CAST(REPLACE(rate, '/5', '')
                  AS DECIMAL(3,1))), 2)              AS avg_rating
    FROM zomato
    WHERE cuisines IS NOT NULL
      AND location IS NOT NULL
      AND rate NOT IN ('NEW', '-', '')
      AND rate IS NOT NULL
    GROUP BY location, primary_cuisine
)
SELECT
    location,
    primary_cuisine,
    restaurant_count,
    avg_rating,
    RANK() OVER (PARTITION BY location
                 ORDER BY restaurant_count DESC)     AS cuisine_rank_in_location
FROM cuisine_location
WHERE restaurant_count >= 5
ORDER BY location, cuisine_rank_in_location
LIMIT 50;


-- Q6.3: Restaurant performance tier classification — CTE
WITH restaurant_metrics AS (
    SELECT
        name,
        location,
        cuisines,
        CAST(REPLACE(rate, '/5', '') AS DECIMAL(3,1))           AS rating,
        votes,
        CAST(REPLACE(`approx_cost(for two people)`,
             ',', '') AS DECIMAL(10,2))                         AS cost_for_two,
        online_order,
        book_table
    FROM zomato
    WHERE rate NOT IN ('NEW', '-', '')
      AND rate IS NOT NULL
      AND `approx_cost(for two people)` IS NOT NULL
      AND votes > 0
)
SELECT
    name,
    location,
    cuisines,
    rating,
    votes,
    cost_for_two,
    online_order,
    CASE
        WHEN rating >= 4.5 AND votes >= 500  THEN 'Elite'
        WHEN rating >= 4.0 AND votes >= 200  THEN 'High Performer'
        WHEN rating >= 3.5 AND votes >= 100  THEN 'Solid'
        WHEN rating >= 3.0                   THEN 'Average'
        ELSE 'Underperformer'
    END                                                         AS performance_tier
FROM restaurant_metrics
ORDER BY rating DESC, votes DESC
LIMIT 50;


-- Q6.4: Cost percentile ranking by location
SELECT
    name,
    location,
    cost_for_two,
    ROUND(PERCENT_RANK() OVER (
        PARTITION BY location
        ORDER BY cost_for_two
    ) * 100, 1)                                     AS cost_percentile_in_location
FROM (
    SELECT
        name,
        location,
        CAST(REPLACE(`approx_cost(for two people)`,
             ',', '') AS DECIMAL(10,2))             AS cost_for_two
    FROM zomato
    WHERE `approx_cost(for two people)` IS NOT NULL
      AND location IS NOT NULL
) AS cost_data
ORDER BY location, cost_percentile_in_location DESC
LIMIT 50;

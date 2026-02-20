-- 1) SELECT / FROM / LIMIT
-- What it does: picks columns from a table and returns rows.
SELECT event_date, event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
LIMIT 1000;

-- 2) WHERE filters rows
-- What it does: keeps only rows that match conditions.

-- All the users who purchased on an event date
SELECT event_date, event_name, user_pseudo_id
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase' 
LIMIT 100;

-- 3) ORDER BY sorts results
-- What it does: sorts rows ascending/descending.

-- Most recent purchases 
SELECT event_date, event_timestamp, event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
ORDER BY event_timestamp DESC
LIMIT 20;

-- Tip for readability (GA4 timestamps are microseconds):
-- All the events and associated time.
SELECT 
  TIMESTAMP_MICROS(event_timestamp) AS event_time,
  event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
ORDER BY event_timestamp DESC
LIMIT 10;

-- 4) COUNT, SUM, AVG, MIN, MAX
-- What they do: summarize many rows into a few values.

-- Count total events in a date range
-- The number of events in the month of December 2020
SELECT COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231';

-- Count purchases in a date range
SELECT COUNT(*) AS purchase_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
    AND _TABLE_SUFFIX BETWEEN '20201201' AND '20201231';

-- 5) GROUP BY controls the grain
-- What it does: defines what one row in your result represents (e.g., per day, per event_name, per user).

-- Events by day
SELECT event_date, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_date
ORDER BY event_date;

-- Top event types
SELECT event_name, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_name
ORDER BY events DESC
LIMIT 15;

-- 6) HAVING filters after grouping
-- What it does: filters aggregated results (after GROUP BY).

-- Only event types with at least 50,000 events
-- Events by day for the first 7 days of December, 2020.
SELECT event_name, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_name
HAVING COUNT(*) >= 50000
ORDER BY events DESC;

-- 7) Wildcard tables + _TABLE_SUFFIX
-- GA4 exports are daily tables like events_20201201.

-- events_* queries many days, and _TABLE_SUFFIX limits which days you scan (faster/cheaper).
SELECT event_date, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201207'
GROUP BY event_date
ORDER BY event_date;

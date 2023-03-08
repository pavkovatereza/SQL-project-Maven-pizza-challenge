# Considering current opening hours are for 10-23 each day. New recommended opening hours 11-22 (Su-Th) and 11-23 (Fr,Sa).
# This change would increase hourly revenue by 10.6% as show the following calculations.

# Total sales for entries for recommended open hours between 11-22 (Su-Th) and 11-23 (Fr,Sa).
WITH cte_short_hs_rev AS
(
SELECT ROUND(SUM(d.quantity*p.price),0) AS updated_profit
FROM orders o
LEFT JOIN order_details d
ON o.order_id = d.order_id
LEFT JOIN pizzas p
ON d.pizza_id = p.pizza_id
WHERE (DAYNAME(o.date) IN ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday') 
	AND HOUR(o.time) BETWEEN '11:00:00' AND '21:59:59') OR
    (DAYNAME(o.date) IN ('Friday', 'Saturday') AND HOUR(o.time) BETWEEN '11:00:00' AND '22:59:59')
    ),
-- Total revenue with shorter opening times would be $805k
cte_normal_hs_rev AS
(
SELECT ROUND(SUM(d.quantity*p.price),0) AS total_profit
FROM order_details d
LEFT JOIN pizzas p
ON d.pizza_id = p.pizza_id
)
-- Total revenue is $818k
SELECT ROUND((((updated_profit)/(total_profit)*100)-100),2)
FROM cte_short_hs_rev, cte_normal_hs_rev
-- The change would decrease revenue by 1.52%

# What is an average hourly revenue considering original opening hours 10-23 daily (13h)
WITH cte_normal_hs_rev AS
(
SELECT ROUND(SUM(d.quantity*p.price),0) AS total_profit
FROM order_details d
LEFT JOIN pizzas p
ON d.pizza_id = p.pizza_id
),
cte_open_hs AS
(
SELECT COUNT(DISTINCT date)*13 AS total_hs_open
FROM orders
)
SELECT ROUND((total_profit/total_hs_open),2) AS past_hourly_rev_$
FROM cte_normal_hs_rev, cte_open_hs
-- Hourly revenue with old opening hours is $175.73

# What is an average hourly revenue considering recommended shorter opening hours?
WITH cte_short_hs_rev AS
(
SELECT ROUND(SUM(d.quantity*p.price),0) AS profit_shorter_open_hs
FROM orders o
LEFT JOIN order_details d
ON o.order_id = d.order_id
LEFT JOIN pizzas p
ON d.pizza_id = p.pizza_id
WHERE (DAYNAME(o.date) IN ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday') 
	AND HOUR(o.time) BETWEEN '11:00:00' AND '21:59:59') OR
    (DAYNAME(o.date) IN ('Friday', 'Saturday') AND HOUR(o.time) BETWEEN '11:00:00' AND '22:59:59')
    ),
cte_weekday_hs AS
(
SELECT COUNT(DISTINCT date)*COUNT(DISTINCT HOUR (time)) AS weekday_hs
FROM orders 
WHERE (DAYNAME(date) IN ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday') 
    AND HOUR(time) BETWEEN '11:00:00' AND '21:59:59')),
cte_weekend_hs AS
    (SELECT COUNT(DISTINCT date)*COUNT(DISTINCT HOUR (time)) AS weekend_hs
	FROM orders 
    WHERE
    (DAYNAME(date) IN ('Friday', 'Saturday') AND HOUR(time) BETWEEN '11:00:00' AND '23:00:00')
    ),
cte_new_open_hs AS
(
SELECT weekday_hs+weekend_hs AS shorter_hs_open
FROM cte_weekday_hs, cte_weekend_hs
)
SELECT ROUND(profit_shorter_open_hs/shorter_hs_open,2) AS new_hourly_rev_$
FROM cte_short_hs_rev, cte_new_open_hs
-- Hourly revenue with recommended shorter opening hours would be $194.44 which is 10.6% increase.


    
    

# This dataset contains information about sales, orders and pizza types in Plato's Pizza from 2015.

# Modify column format from daytime to date
ALTER TABLE pizza_sales.orders MODIFY date DATE;

# Searching duplicates
SELECT order_id, 
	COUNT(order_id) AS duplic
FROM pizza_sales.orders 
GROUP BY order_id
ORDER BY duplic DESC

# Searching missing values: Number of days per each month
SELECT MONTH(date), 
	COUNT(DISTINCT date)
FROM pizza_sales.orders
GROUP BY MONTH(date);
-- There are missing some days in September (28), October (27) and December (30)

# What dates are actually missing?
SELECT date, 
	MONTH(date)
FROM pizza_sales.orders
WHERE MONTH(date) IN ('9', '10', '12')
GROUP BY date;
-- September 24. and 25., October 5., 12., 19., and 26., December 25 (probably closed due to holiday) are missing

# What specific days are those?
SELECT DAYNAME("2015-09-24"),
	DAYNAME("2015-09-25"),
    DAYNAME("2015-10-05"),
    DAYNAME("2015-10-12"),
    DAYNAME("2015-10-19"),
    DAYNAME("2015-10-26"),
    DAYNAME("2015-12-25");
-- 4xMonday (all in October), 1xThursday, 2xFriday 

# How many orders are there in total in the dataset?
SELECT COUNT(DISTINCT order_id) AS orders
FROM pizza_sales.orders
-- 21350 total number of orders.

# How many pizzas in total has been sold in 2015?
SELECT SUM(quantity) AS pizzas_sold
FROM pizza_sales.order_details
-- There was 49574 pizzas sold in the year.

# What is the total amount of orders for each day in a week?
SELECT DAYNAME(date) AS day_of_week, 
	COUNT(order_id) AS num_orders
FROM pizza_sales.orders
GROUP BY day_of_week
ORDER BY num_orders DESC
-- The bussiest day is Friday with 3538 orders in total. Sunday has the least amount of orders 2624.
-- Average per day will be more accurate due to some missing days from the dataset.

# What is the average amount of pizzas made per day in a week?
SELECT DAYNAME(o.date) AS day_of_week, 
	ROUND(SUM(d.quantity)/COUNT(DISTINCT o.date),0) AS num_pizzas
FROM pizza_sales.orders o
LEFT JOIN pizza_sales.order_details d
	ON o.order_id = d.order_id
GROUP BY day_of_week
ORDER BY num_pizzas DESC
-- Friday has in average 165, Saturday and Thursday 144, Mo, We, Tu (132-135), Sunday 116 pizzas

# What is the average amount of orders per day in a week?
SELECT DAYNAME(date) AS day_of_week, 
	ROUND(COUNT(order_id)/COUNT(DISTINCT date),1) AS average_orders
FROM pizza_sales.orders
GROUP BY day_of_week
ORDER BY average_orders DESC
-- Friday is the busiest day with over 70 orders/day in average, least busy is Sunday with average of 50 orders/day.
-- The average for other days is lying in the range from 57 to 62 order/day.

# What is the average amount of orders per day?
SELECT ROUND(COUNT(order_id)/COUNT(DISTINCT date),1) AS daily_average
FROM pizza_sales.orders
-- Daily average is 59.6 orders

# What month is the bussiest?
SELECT MONTH(date) as month, 
	COUNT(order_id) AS total_orders
FROM pizza_sales.orders
GROUP BY month
ORDER BY total_orders DESC
-- I will calculate average again to eliminate the effect of the missing days.

SELECT MONTH(date) as month, 
	ROUND(COUNT(order_id)/COUNT(DISTINCT date),1) AS avg_daily_orders
FROM pizza_sales.orders
GROUP BY month
ORDER BY avg_daily_orders DESC
-- The average amount of daily orders is comparable for all months and is in a range 60±1 except July with 62.4 and December with 56.0 orders/day
-- There is no clear information showing if any season is better for a business
-- December is most likely the least busy month because of the holiday and people spending time at home with families then going out.

# What is the amount of pizzas sold daily in average for each month?
SELECT MONTH(o.date) as month, 
	ROUND(SUM(d.quantity)/(COUNT(DISTINCT DATE(o.date))),0) AS avg_pizzas
FROM pizza_sales.orders o
LEFT JOIN pizza_sales.order_details d
ON o.order_id = d.order_id
GROUP BY month
ORDER BY avg_pizzas DESC
-- The most pizzas were sold in October (144 daily average) considering days we have data for. Least in December (131)

# What day has the most pizzas ordered?
SELECT o.date AS date,
	DAYNAME(o.date) AS name,
	SUM(d.quantity) AS total_pizzas
FROM pizza_sales.orders o
LEFT JOIN pizza_sales.order_details d
	ON o.order_id = d.order_id
GROUP BY date
ORDER BY total_pizzas DESC
-- The overall busiest days were November 26th and 27th with 266 and 264 pizzas ordered respectively.

# What is the highest amount of pizzas in order?
SELECT SUM(quantity) AS quantity,
	order_id
FROM pizza_sales.order_details
GROUP BY order_id
ORDER BY quantity DESC
LIMIT 1
-- The highest amount of pizzas in one order was 28.

# What is the number of orders for different amount of pizzas?
SELECT COUNT(order_id) AS num_orders,
	quantity
FROM (SELECT SUM(quantity) AS quantity,
	order_id
FROM pizza_sales.order_details
GROUP BY order_id) AS inter_table
GROUP BY quantity
ORDER BY num_orders DESC
-- The most common number of pizza in one order are 1-4 (8k-3k), then it dramaticaly decrease 5 pizzas (145 orders)
-- Idea of promotion to get 5 pizzas with some specific discount. 

# How many orders have been placed before 11am and after 11pm? 
SELECT *
FROM pizza_sales.orders
WHERE time BETWEEN '00:00:00' AND '10:59:59'
	OR time BETWEEN '23:00:00' AND '23:59:59'
ORDER BY time 
-- There are only 37 entries outside of opening hours. All of late orders are within 5 minutes after closing. 
-- The earliest order has been placed at 9:52:21.

# What hour is the busiest throughout a day?
SELECT COUNT(order_id) AS orders,
	HOUR(time) AS hour
FROM pizza_sales.orders
GROUP BY hour
ORDER BY orders DESC
-- The most orders have been placed at 12h (2520) and 13h (2455) as lunch rush hours followed by dinner rush hours 17h (2336) and 18h (2399)

# What is the amount of orders for each hour in different days?
SELECT COUNT(order_id) AS orders,
	HOUR(time) AS hour,
    DAYNAME(date) AS day
FROM pizza_sales.orders
GROUP BY day, hour
ORDER BY hour, orders
-- The amount of orders after 22h is for every day except Friday and Saturday very little - perhaps change opening hours for weekdays.

# How many pizzas has been made in average each hour?
SET @days = (SELECT COUNT(DISTINCT date) FROM pizza_sales.orders)

SELECT HOUR(o.time) AS hour,
	ROUND(SUM(d.quantity)/@days,1) AS pizzas_per_hour
FROM pizza_sales.orders o
LEFT JOIN pizza_sales.order_details d
	ON o.order_id = d.order_id
GROUP BY hour
ORDER BY pizzas_per_hour DESC
-- The busiest hours are in agreement with the previous findings (12h and 13h)
-- For running promotion I would advise to make promotion for late orders (after 21h) or for an early lunch (11h-12h)

# What 5 pizzas are the most sold?
SELECT pizza_id, 
	SUM(quantity) AS pieces_sold
FROM pizza_sales.order_details
GROUP BY pizza_id
ORDER BY pieces_sold DESC
LIMIT 5
-- The absolutely most favorite pizza is the big_meat small size pizza with total of 1914 orders. 
-- The big_meat has been sold only in small size, doesn't have any other sales in different sizes.

# What 5 pizzas are the least sold?
SELECT pizza_id, 
	SUM(quantity) AS pieces_sold
FROM pizza_sales.order_details
GROUP BY pizza_id
ORDER BY pieces_sold 
LIMIT 5
-- The Greek XXL piza has only 28 orders, compare to the next (95 and more)
-- Check if we sell any other pizza in sizes XL and XXL 

# What pizzas are offered in XL and XXL size?
SELECT pizza_id,
	SUM(quantity) AS pieces_sold
FROM pizza_sales.order_details
WHERE pizza_id REGEXP "xl$" 
GROUP BY pizza_id
-- We sell only the Greek pizza in sizes XL and XXL, size XL has 552 orders

# Is there any pizzas that are sold mostly in one size?
SELECT p.pizza_id,
	COALESCE(SUM(d.quantity),0) AS pieces_sold
FROM pizza_sales.order_details d
RIGHT JOIN pizza_sales.pizzas p
	ON d.pizza_id = p.pizza_id
GROUP BY p.pizza_id
ORDER BY pieces_sold
-- Those pizzas and sizes doesn't have any sold piece: Big Meat (M and L), Four Cheese (S), Five Cheese (S and M)

# What are the prices of the most and least ordered pizzas?
SELECT p.pizza_id AS id,
	p.size,
	SUM(d.quantity) AS pieces_sold,
    p.price AS price
FROM pizza_sales.order_details d
LEFT JOIN pizza_sales.pizzas p
	ON d.pizza_id = p.pizza_id
GROUP BY id, size, price
ORDER BY price, pieces_sold DESC
-- Price of the Brie Carre pizza that is sold only in S size is higher than any of the other L pizzas. It has 490 pieces sold. 
-- The small big meat pizza is most favorite and it is sold for $12 (perhaps increase a price sightly to $12.5)
-- The least sold pizza is the XXL greek pizza for $35.95 (the only pizza sold in this size) 
-- Increase prices of pepperoni and hawaiian to match average prices for the same sizes. 

# What are the 5 most sold pizza types regardless size?
SELECT t.name AS pizza_type, 
	SUM(d.quantity) AS pieces_sold
FROM order_details d
LEFT JOIN pizzas p ON d.pizza_id = p.pizza_id
LEFT JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY pizza_type
ORDER BY pieces_sold DESC
LIMIT 5;
-- The Classic Deluxe Pizza (2453), The Barbecue Chicken Pizza (2432) and The Hawaiian Pizza (2422)

# What are the 5 least sold pizza types regardless size?
SELECT t.name AS pizza_type, 
	SUM(d.quantity) AS pieces_sold
FROM order_details d
LEFT JOIN pizzas p ON d.pizza_id = p.pizza_id
LEFT JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY pizza_type
ORDER BY pieces_sold
LIMIT 5;
-- The Brie Carre Pizza has significantly less orders (490) than any other (934 and more), it is sold only in small size

# What size is prefered?
SELECT 
	CASE
		WHEN pizza_id REGEXP "s$" THEN "Small"
        WHEN pizza_id REGEXP "m$" THEN "Medium"
        WHEN pizza_id REGEXP "xl$" THEN "XLarge"
        ELSE "Large"
	END AS pizza_size,
	SUM(quantity) AS pieces_sold
FROM pizza_sales.order_details
GROUP BY pizza_size
ORDER BY pieces_sold DESC
-- Large is the most favorite pizza size with 18956 pieces sold, small pizzas are the least sold with 14403 pieces sold.

# What is the average price per order?
WITH cte_price AS
	(SELECT d.order_id,
		SUM(p.price*d.quantity) AS order_price
    FROM pizza_sales.pizzas p
    LEFT JOIN pizza_sales.order_details d
    ON p.pizza_id = d.pizza_id
    GROUP BY d.order_id)

SELECT ROUND(AVG(order_price),2) AS avg_bill
FROM cte_price;
-- The average price per order is $38.31

# How many pizzas are in average order?
WITH cte_orders AS
	(SELECT SUM(quantity) AS total_orders
    FROM pizza_sales.order_details
    GROUP BY order_id)

SELECT ROUND(AVG(total_orders),1) AS avg_orders
FROM cte_orders;
-- The average amount of pizza per order is 2.3

# What category is the most favorite?
SELECT t.category,
	SUM(d.quantity) AS total_pizzas
FROM pizza_sales.order_details d
LEFT JOIN pizza_sales.pizzas p 
	ON d.pizza_id = p.pizza_id
LEFT JOIN pizza_sales.pizza_types t
	ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.category
ORDER BY total_pizzas DESC
-- Classic pizzas are the most sold with 14888 pieces sold. The other 3 categories has similar amount (Chicken 11050 Veggie 11649, Supreme 11987)

# What is the most favorite pizza in each category?
SELECT *
FROM (SELECT
    t.category,
	t.name,
	SUM(d.quantity) AS total_pizzas,
    DENSE_RANK () OVER(PARTITION BY t.category ORDER BY (SUM(d.quantity)) DESC) AS ranking
FROM pizza_sales.order_details d
LEFT JOIN pizza_sales.pizzas p 
	ON d.pizza_id = p.pizza_id
LEFT JOIN pizza_sales.pizza_types t
	ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name, t.category
ORDER BY total_pizzas DESC) AS inter_table
WHERE ranking = 1
-- The Classic Deluxe (Classic) and The Barbecue Chicken (Chicken) has 2453 and 2432 pieces sold each
-- The Sicilian (Supreme) and The Four Cheese (Veggie) has 1938 and 1902 pieces sold each

# What is the least favorite pizza in each category?
SELECT *
FROM (SELECT
    t.category,
	t.name,
	SUM(d.quantity) AS total_pizzas,
    DENSE_RANK () OVER(PARTITION BY t.category ORDER BY (SUM(d.quantity))) AS ranking
FROM pizza_sales.order_details d
LEFT JOIN pizza_sales.pizzas p 
	ON d.pizza_id = p.pizza_id
LEFT JOIN pizza_sales.pizza_types t
	ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name, t.category
ORDER BY total_pizzas DESC) AS inter_table
WHERE ranking = 1
-- The least sold pizza is Brie Carre (490) Mediterranean and Chicken Pesto (934 and 973) from Pepperoni, Mushroom and Peppers (1359)

# What month has the highest revenue?
SELECT MONTH(o.date) as month, 
	ROUND(SUM(p.price*d.quantity),0) AS revenue
FROM pizza_sales.orders o
LEFT JOIN pizza_sales.order_details d
	ON o.order_id = d.order_id
LEFT JOIN pizza_sales.pizzas p
	ON d.pizza_id = p.pizza_id
GROUP BY month
ORDER BY revenue DESC
-- July 72,5k, May 71,5k, March and November 70k

# What is the total revenue per year?
SELECT 
    ROUND(SUM(p.price * d.quantity),0) AS revenue
FROM
    pizza_sales.orders o
        LEFT JOIN
    pizza_sales.order_details d ON o.order_id = d.order_id
        LEFT JOIN
    pizza_sales.pizzas p ON d.pizza_id = p.pizza_id
-- total revenue $817860

# Does season affect revenue?
SELECT ROUND(SUM(d.quantity*p.price),0) AS revenue,
	CASE 
		WHEN monthname(o.date) IN ("March", "April", "May") THEN "spring"
        WHEN monthname(o.date) IN ("June", "July", "August") THEN "summer"
        WHEN monthname(o.date) IN ("September", "October", "November") THEN "fall"
        WHEN monthname(o.date) IN ("December", "January", "February") THEN "winter"
        END AS year_time
FROM pizza_sales.orders o
LEFT JOIN pizza_sales.order_details d
	ON o.order_id = d.order_id
LEFT JOIN pizza_sales.pizzas p
	ON p.pizza_id = d.pizza_id
GROUP BY year_time
ORDER BY revenue DESC
-- It seems like spring has the highest revenue (210k), the least has fall (198k)
    
# What is the pizza that brings the most revenue?
SELECT t.name AS pizza,
	ROUND(SUM(p.price * d.quantity),0) AS revenue
FROM pizza_sales.order_details d
LEFT JOIN pizza_sales.pizzas p
	ON d.pizza_id = p.pizza_id
LEFT JOIN pizza_sales.pizza_types t
	ON p.pizza_type_id = t.pizza_type_id
GROUP BY pizza
ORDER BY revenue DESC
-- The biggest revenue has The Thai Chicken P. ($43434), Barbecue Chicken P. ($42768), California Chicken P.($41410)
-- The lowest revenue has The Brie Carre P ($11588) and Green Garder ($13956)

# What are the ingredients for the least favorite pizzas?
SELECT name,
	ingredients
FROM pizza_sales.pizza_types
WHERE pizza_type_id IN ('brie_carre', 'green_garden')
-- Green Garden pizza used common ingredients, I will have a look in the Brie Carre pizza.

# Are The Brie Carre pizzas' ingredients used in other pizza type? 
SELECT name,
	ingredients
FROM pizza_sales.pizza_types
WHERE ingredients LIKE '%Brie%'
OR ingredients LIKE '%Prosciutto%'
OR ingredients LIKE '%Caramelized Onions%'
OR ingredients LIKE '%Pears%'
OR ingredients LIKE '%Thyme%'
-- The only ingredient used at another pizza type is prosciutto in The Prosciutto and Aragula Pizza.

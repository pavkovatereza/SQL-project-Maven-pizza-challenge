## 📚 Data Science Job Salaries Dataset
This dataset, available at [Maven Analytics Playground](https://www.mavenanalytics.io/blog/maven-pizza-challenge), contains information about sales of Plato’s Pizza, the Greek-inspired pizza restaurant, from 2015. It has 4 tables with information about orders and sales details, pizza types, and prices.  

Dataset was analyzed using MySQL, the code used for analysis can be found in [this](https://github.com/pavkovatereza/SQL-project-Maven-pizza-challenge/blob/main/Maven_pizza_challenge.sql) repository.
I also added separate calculation on the profitability of changed opening hours to [this](https://github.com/pavkovatereza/SQL-project-Maven-pizza-challenge/blob/main/Opening_hs_optimization.sql) repository.

Visualization will be available in the upcoming days.

## ❓ Questions
The goal of this analysis is to identify possible areas of improvement to get better sales and optimized operations. With this goal in mind, I was looking to get the following questions answered:

  - What are the KPI (revenue, total orders, and total pizzas made in 2015)?
  - When is the restaurant busiest and how efficient are opening hours? 
  - What is the daily average of orders/pizzas?
  - What is the average price per order and how many pizzas are in an average order?
  - What are the 3 most and least sold pizza types?
  - What size is preferred?
  - What category is the most favorite and what pizzas in each category are the most favorite?
  - Does season affect sales?
  - What pizza brought the most and the least revenue?
  - Are the variety of the ingredients used in pizzas optimized?

## 🚩 Datasets limitations and issues
1. The following days are missing from the dataset: 24th, 25th of September, 5th, 12th, 19th, 26th of October, and 25th of December (probably closed due to the holiday). All missing days from October are Mondays. The monthly/daily average will be used instead of the total to compare sales.
2. Information about takeaway/delivery orders or eat-in is not included. Such information will be useful for further analysis to optimize seating availability and amount of workers needed in the kitchen/on the floor.
3. There are some pizzas that don't have any sales in some particular sizes. Could be a system fault or actual data - the data source needs to be checked.

## 💭 Interesting insight
1. **The restaurant received 21350 orders, prepared 49574 pizzas, and earn $817860 in the year 2015.**
2. Friday is the busiest day of the week with an average of 165 pizzas. Thursday and Saturday shared the second position with an average of 144 pizzas. Sunday is the least busy day with an average of 116 pizzas.
3. The restaurant is expected to receive on average 60 orders per day, with $38.31 as an average price per order, and an average amount of 2.3 pizzas per order. The highest recorded amount of pizzas in one order was 28.
4. The majority of orders have 1-4 pizzas (8k - 3k), and the number of orders with more pizzas is dramatically decreasing (5 pizzas were ordered only 145 times).
5. **The majority of all orders had been placed between 11 and 23 with rush hours 12-14 and 17-19.** 
6. **Adjusting current opening hours (10-23 daily) to 11-22 Sun-Thu and 11-23 Fri-Sat would increase hourly revenue by 10.6% from $175.73/h to $194.44/h.**
7. Large-size pizzas are the favorite with 18.9k pieces sold. Small-sized pizzas are the least sold with 14.4k pieces.
8. The absolute favorite is the small-sized big meat pizza priced at $12 with 1.9k pieces sold and a total revenue of $23k. This pizza type doesn't have any other sales in different sizes.
9. The following pizzas and sizes don't have any recorded sales: Big Meat (M and L), Four Cheese (S), and Five Cheese (S and M).
10. Pizza types that brought the highest revenue are The Thai Chicken ($43.5k), The Barbecue Chicken ($42.7k), and The California Chicken ($41.4k)
11. The only pizza style made in XL and XXL sizes is the Greek pizza, XL size is very popular, but XXL had been sold only 28 times/year.
12. The Brie Carre is sold only in S size and the price is higher than any other L size pizza ($23.65), it is also a pizza that overall brought the smallest revenue of $11.5k. However, compared to small-sized pizzas, the Brie Carre brought the 2nd highest revenue.

## 🎯 Conclusion
The dataset provides valuable insight into the sales of Plato’s Pizza from the year 2015. For further analysis, I would recommend tracking which orders were placed for take-away and orders to eat in, and also information about the approximate cost of used ingredients (product cost). This information could be used to optimize the number of workers needed on specific days and times and the number of seats needed for guests in the restaurant. Knowing the product cost for each pizza will allow for analyzing the actual profit from selling each pizza (the most sold one or the one with the most revenue doesn’t need to be the most profitable one).

The majority of orders were placed between 11 and 23 with rush hours 12-14 and 17-19. Orders after 10 pm are not very common except for Friday and Saturday. I would recommend changing the opening hours from current 10-23 daily to Su-Th 11-22 and Fr-Sa 11-23 which would increase hourly revenue by 10.6%. Due to the decreasing amount of orders after rush hours I would suggest creating some special offers for orders after 21 for weekdays (Mo-Th) or before 12 for weekends (Saturday and Sunday early lunch). 

The dataset shows there are pizza types that don't have any sales in some particular size option (The Big Meat small, Four Cheese medium and large, Five Cheese large). To reflect this information, I recommend checking the ordering system to ensure all entries are saved accordingly.

As the restaurant has only the Greek pizza in XL and XXL sizes with 552 and 28 pieces sold/year respectively, I would consider removing XXL size and adding more options (the most sold/favorite types) for the XL size and creating a weekend/lunch offer for XL pizzas to introduce a new product to the customers. The effectiveness of this step should be reviewed with new data.

The Brie Carre pizza is the most expensive ($23.65) and available only in a small size. With 490 pieces sold it brought the overall lowest revenue (but second best for small pizzas) of $11.5k. Ingredients for this pizza are unique and not used in any other pizza. The manager/chef should review options for either changing ingredients to ones that are commonly used in the restaurant or changing the recipe to make the pizza more affordable.

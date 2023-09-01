-- CASE STUDY 2
-- PIZZA METRICS
-- Question 1; How many Pizzas were ordered?
SELECT COUNT(pizza_id) as volume_of_pizza_ordered
FROM customer_orders;
-- 14 pizzas were ordered

-- Question 2; How many unique customer orders were made?
SELECT COUNT(DISTINCT(concat_ws('-', pizza_id, exclusions, extras))) AS unique_values
FROM customer_orders;
-- There are eight unique orders

-- Question 3; How many successful orders were delivered by each runner?
SELECT * FROM runner_orders;
SELECT COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL;
-- 8 out of 10 orders were successful

-- Question 4; How many of each type of pizza was delivered?
SELECT pizza_name, count(order_id) as no_of_pizza_delivered
FROM customer_orders
	JOIN runner_orders USING (order_id)
	JOIN pizza_names USING (pizza_id)
WHERE cancellation IS NULL
GROUP BY pizza_name;
-- 9 Meat Lovers and 3 vegeterian Pizza was delivered

-- Question 5; How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, pizza_name, count(pizza_name)
FROM customer_orders
JOIN pizza_names USING (pizza_id)
GROUP BY customer_id, pizza_name
ORDER BY customer_id;

-- Question 6; What was the maximum number of pizzas delivered in a single order?
SELECT * FROM pizza_runner.customer_orders;
SELECT order_id, COUNT(order_id) AS no_of_orders
FROM customer_orders 
JOIN runner_orders
USING (order_id)
WHERE pickup_time IS NOT NULL
GROUP BY order_id
ORDER BY no_of_orders DESC
LIMIT 1;

-- Question 7; For each customer, how many delivered pizzas had at least 1 change and how many had no changes
SELECT customer_id,
		SUM(CASE WHEN (exclusions IS NOT NULL or extras IS NOT NULL) THEN 1 ELSE 0 END) as pizza_with_changes,
        SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) as pizza_with_no_changes
FROM customer_orders co
JOIN runner_orders ru ON co.order_id = ru.order_id
WHERE cancellation IS NULL
GROUP BY co.customer_id;

-- Question 8; How many pizzas were delivered that had both exclusions and extras?
SELECT SUM(CASE WHEN (exclusions IS NOT NULL AND extras IS NOT NULL) THEN 1 ELSE 0 END) as pizza_with_exclusion_and_extras
FROM customer_orders co
JOIN runner_orders ru ON co.order_id = ru.order_id
WHERE cancellation IS NULL;
-- 1 Pizza was delivered with both exclusions and extras

-- Question 9; What was the total volume of pizzas ordered for each hour of the day?
SELECT DATE(order_time) as day_of_order, 
	   HOUR(order_time) as hour_of_the_day, 
       COUNT(pizza_id) as Volume_of_pizza
FROM customer_orders 
GROUP BY day_of_order, hour_of_the_day;

-- Question 10; What was the volume of orders for each day of the week?
SELECT DAYNAME(DATE(order_time)) as day_of_the_week, count(pizza_id) as volume_of_pizza
FROM customer_orders
GROUP BY day_of_the_week















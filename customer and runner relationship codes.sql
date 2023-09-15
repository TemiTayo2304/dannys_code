-- Question 1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
 SELECT FLOOR(DATEDIFF(registration_date, '2021-01-01') /7) +1 AS Week_number, 
		COUNT(runner_id) as num_of_signups
 FROM runner
 GROUP BY week_number
 ORDER BY week_number;
 -- 2 of them signed up in the first week, and one in the subsequent weeks

-- Question 2 What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT order_id, runner_id, CONCAT(FLOOR(AVG(TIMESTAMPDIFF(MINUTE, order_time, pickup_time))),' minutes') as avg_pickup_time
FROM runner_orders
JOIN customer_orders
USING (order_id)
WHERE pickup_time IS NOT NULL
GROUP BY runner_id, 1
ORDER BY runner_id;


-- Question 3 Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT order_id, count(order_id) as no_of_pizzas, 
	  CONVERT(TIMEDIFF(pickup_time, order_time), TIME) as Preparation_Time
 FROM customer_orders JOIN runner_orders 
 USING (order_id) 
 WHERE pickup_time IS NOT NULL
 GROUP BY order_id, 3
 ORDER BY no_of_pizzas ASC;
 
 -- No, There isn't. The preparation time varies for each number of pizzas ordered


-- Question 4 What was the average distance travelled for each customer?
SELECT customer_id, 
		CONCAT(ROUND(AVG(IFNULL(distance, 0)),1), ' km') as Avg_distance_travelled
FROM customer_orders 
JOIN runner_orders 
USING (order_id)
WHERE pickup_time IS NOT NULL
GROUP BY customer_id;

-- customer 105 has the highest distance travelled of 25km and 104 with the least distance of 10km


-- Question 5 What was the difference between the longest and shortest delivery times for all orders?
SELECT CONCAT(MAX(duration) - MIN(duration), ' minutes') as delivery_time_difference
FROM runner_orders;

-- the difference between the longest and shortest delivery times for all orders is 30 minutes

-- Question 6 What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT order_id, runner_id, 
		CONCAT(ROUND((distance*1000)/(duration*60),1),' m/s') as Speed
FROM runner_orders
WHERE pickup_time IS NOT NULL
ORDER BY runner_id;


-- Question 7 What is the successful delivery percentage for each runner
SELECT runner_id,
		CONCAT(ROUND(SUM(CASE WHEN pickup_time IS NULL THEN 0 ELSE 1 END *100) /SUM(COUNT(*))OVER (), 0),'%') as delivery_percentage
FROM runner_orders
WHERE pickup_time IS NOT NULL
GROUP BY runner_id

-- Runner 1 has the highest successfull delivery percentage of 50%, runner 2 has 38% abd runner 3 with the least of 13%






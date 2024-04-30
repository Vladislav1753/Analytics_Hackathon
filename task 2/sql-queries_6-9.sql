-- Database: PizzaDB

SELECT AVG(n_orders) as Avg_number_of_orders
FROM (
	SELECT COUNT(order_id) AS n_orders
	FROM orders
	GROUP BY date);

-- 6) The answer is 59.63 or 59 if we round down it    
	
SELECT AVG(n_pizzas) AS avп_n_pizzas_in_autumn
FROM (
    SELECT od.order_id, COUNT(od.pizza_id) AS n_pizzas
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    WHERE EXTRACT(MONTH FROM o.date) IN (9, 10, 11)
    GROUP BY od.order_id
) AS subquery;

-- 7) The answer is 2.31 pizzas for order in average  

WITH popular_pizzas AS (
    SELECT pizza_id, COUNT(*) AS orders_count
    FROM order_details
    GROUP BY pizza_id
    ORDER BY orders_count DESC
    LIMIT 3
)
SELECT SUM(pizzas.price) AS earnings_in_june_from_top_3_pizzas
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN orders ON order_details.order_id = orders.order_id
WHERE EXTRACT(MONTH FROM orders.date) = 6
AND order_details.pizza_id IN (SELECT pizza_id FROM popular_pizzas);

-- 8) The answer is 6084.50 

SELECT category, size, COUNT(*) AS pizzas_ordered
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY category, size;

-- 9) The answer is in the file '9question.csv'
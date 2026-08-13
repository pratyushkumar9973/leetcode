WITH cte AS 
(SELECT customer_number, COUNT(order_number) AS number_of_order 
FROM Orders
GROUP BY customer_number)

SELECT customer_number FROM cte 
WHERE number_of_order = (select MAX(number_of_order) FROM cte)

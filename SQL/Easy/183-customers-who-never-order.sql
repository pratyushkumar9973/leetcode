SELECT c.name AS Customers 
FROM Customers c 
WHERE  Not EXISTS
(SELECT * FROM  Orders o 
where c.id = o.customerId);

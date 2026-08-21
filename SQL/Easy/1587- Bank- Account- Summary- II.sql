SELECT u.name,
SUM(amount) AS balance

FROM Users u
INNER JOIN Transactions t
ON  u.account = t.account
GROUP BY u.name 
HAVING SUM(amount) > 10000

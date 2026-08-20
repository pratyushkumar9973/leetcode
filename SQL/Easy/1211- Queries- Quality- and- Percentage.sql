WITH cte AS
(SELECT query_name, rating :: numeric/position AS ratio,
CASE WHEN rating < 3  THEN 1
ELSE 0 END AS quality_binary
FROM Queries)

SELECT query_name, ROUND(AVG(ratio):: numeric, 2) AS quality,
ROUND((SUM(quality_binary):: numeric/COUNT(*) )*100,2) AS poor_query_percentage
FROM cte
GROUP BY query_name

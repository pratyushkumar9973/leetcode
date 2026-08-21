-- LEETCODE: 1565. Unique Orders and Customers Per Month

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Orders                                              │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ order_id      │ int     │                                 │
│  │ order_date    │ date    │                                 │
│  │ customer_id   │ int     │                                 │
│  │ invoice       │ int     │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  order_id is the primary key for this table.                │
│  This table contains information about the orders made      │
│  by customer_id.                                            │
│                                                             │
│  Write an SQL query to find the number of unique orders     │
│  and the number of unique customers with invoices > $20     │
│  for each different month.                                  │
│                                                             │
│  Return the result table sorted in any order.               │
│                                                             │
│  Note: month format should be YYYY-MM.                      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Orders table:                                              │
│  +----------+------------+-------------+------------+       │
│  │ order_id │ order_date │ customer_id │ invoice    │       │
│  +----------+------------+-------------+------------+       │
│  │ 1        │ 2020-09-15 │ 1           │ 30         │       │
│  │ 2        │ 2020-09-17 │ 2           │ 90         │       │
│  │ 3        │ 2020-10-06 │ 3           │ 20         │       │
│  │ 4        │ 2020-10-20 │ 3           │ 21         │       │
│  │ 5        │ 2020-11-10 │ 1           │ 10         │       │
│  │ 6        │ 2020-11-21 │ 2           │ 15         │       │
│  │ 7        │ 2020-12-01 │ 4           │ 55         │       │
│  │ 8        │ 2020-12-03 │ 4           │ 77         │       │
│  │ 9        │ 2021-01-07 │ 3           │ 31         │       │
│  │ 10       │ 2021-01-15 │ 2           │ 20         │       │
│  +----------+------------+-------------+------------+       │
│                                                             │
│  Output:                                                    │
│  +---------+-------------+----------------+                │
│  │ month   │ order_count │ customer_count │                │
│  +---------+-------------+----------------+                │
│  │ 2020-09 │ 2           │ 2              │                │
│  │ 2020-10 │ 1           │ 1              │                │
│  │ 2020-12 │ 2           │ 1              │                │
│  │ 2021-01 │ 1           │ 1              │                │
│  +---------+-------------+----------------+                │
│                                                             │
│  Explanation:                                               │
│  Sep 2020: 2 orders, 2 customers - both invoices > 20       │
│  Oct 2020: 2 orders from 1 customer, only 1 invoice > 20    │
│  Nov 2020: 2 orders but both invoices <= 20 - EXCLUDED      │
│  Dec 2020: 2 orders from 1 customer, both invoices > 20     │
│  Jan 2021: 2 orders from 2 customers, only 1 invoice > 20   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(DISTINCT customer_id) AS customer_count
FROM Orders
WHERE invoice > 20
GROUP BY TO_CHAR(order_date, 'YYYY-MM');

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TO_CHAR(order_date, 'YYYY-MM')                             │
│  - PostgreSQL mein date ko string format mein convert karta │
│    hai 'YYYY-MM' pattern mein (e.g., 2020-09)               │
│  - MySQL mein LEFT(order_date, 7) ya DATE_FORMAT() hota     │
│  - PostgreSQL mein TO_CHAR() standard hai                   │
│                                                             │
│  WHERE invoice > 20                                         │
│  - Sirf woh orders lo jinka invoice $20 se zyada hai        │
│  - = 20 wale exclude honge                                  │
│                                                             │
│  COUNT(DISTINCT order_id)                                   │
│  - Har month mein kitne unique orders hain                  │
│  - Same order_id duplicate ho toh ek hi count hoga          │
│                                                             │
│  COUNT(DISTINCT customer_id)                                │
│  - Har month mein kitne unique customers hain               │
│  - Same customer ne multiple orders kiye toh ek hi count    │
│                                                             │
│  GROUP BY TO_CHAR(order_date, 'YYYY-MM')                    │
│  - Same month wale rows ko group karke aggregate karo       │
│  - SELECT mein jo expression hai wahi GROUP BY mein dalo    │
│                                                             │
│  WHY November 2020 NOT IN OUTPUT?                           │
│  - Nov mein 2 orders hain (invoice 10 aur 15)               │
│  - Dono <= 20 hai, toh WHERE clause se filter ho gaye       │
│  - Koi bhi row bachi nahi Nov ke liye                       │
│                                                             │
│  NOTE: Result order mein koi restriction nahi -             │
│  LeetCode accepts any order. Lekin ORDER BY month           │
│  add kar sakte ho for consistency.                          │
└─────────────────────────────────────────────────────────────┘

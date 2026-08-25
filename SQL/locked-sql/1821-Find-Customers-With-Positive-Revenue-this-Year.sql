-- ============================================================
-- LEETCODE: 1821. Find Customers With Positive Revenue this Year


┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Customers                                           │
│  +--------------+------+                                    │
│  │ Column Name  │ Type │                                    │
│  +--------------+------+                                    │
│  │ customer_id  │ int  │                                    │
│  │ year         │ int  │                                    │
│  │ revenue      │ int  │                                    │
│  +--------------+------+                                    │
│                                                             │
│  (customer_id, year) is the primary key for this table.     │
│  This table contains the customer ID and the revenue of     │
│  customers in different years.                              │
│  Note that this revenue can be negative.                    │
│                                                             │
│  Write an SQL query to report the customers with           │
│  positive revenue in the year 2021.                         │
│                                                             │
│  Return the result table in any order.                      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Customers table:                                           │
│  +-------------+------+---------+                           │
│  │ customer_id │ year │ revenue │                           │
│  +-------------+------+---------+                           │
│  │ 1           │ 2018 │ 50      │                           │
│  │ 1           │ 2021 │ 30      │                           │
│  │ 1           │ 2020 │ 70      │                           │
│  │ 2           │ 2021 │ -50     │                           │
│  │ 3           │ 2018 │ 10      │                           │
│  │ 3           │ 2016 │ 50      │                           │
│  │ 4           │ 2021 │ 20      │                           │
│  +-------------+------+---------+                           │
│                                                             │
│  Output:                                                    │
│  +-------------+                                            │
│  │ customer_id │                                            │
│  +-------------+                                            │
│  │ 1           │                                            │
│  │ 4           │                                            │
│  +-------------+                                            │
│                                                             │
│  Explanation:                                               │
│  - Customer 1: revenue = 30 in 2021 (positive) -> include   │
│  - Customer 2: revenue = -50 in 2021 (negative) -> exclude  │
│  - Customer 3: no row for 2021 -> exclude                   │
│  - Customer 4: revenue = 20 in 2021 (positive) -> include   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT customer_id
FROM Customers
WHERE year = 2021 AND revenue > 0;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SELECT customer_id                                         │
│  - Sirf customer_id return karna hai, revenue nahi         │
│  - Question mein explicitly bola hai: report the customers  │
│                                                             │
│  WHERE year = 2021                                          │
│  - Sirf year 2021 ke rows filter karo                      │
│  - PostgreSQL mein int column ko direct integer se compare   │
│    karte hain, quotes ki zarurat nahi hai                   │
│  - '2021' string bhi kaam karega lekin best practice int    │
│                                                             │
│  AND revenue > 0                                            │
│  - Sirf positive revenue wale rows lo                       │
│  - revenue = 0 wale exclude honge (strictly greater than 0) │
│  - Negative revenue wale bhi exclude honge                  │
│                                                             │
│  WHY NO DISTINCT NEEDED?                                    │
│  - Primary key (customer_id, year) hai                      │
│  - Ek customer ka ek hi row hoga 2021 ke liye               │
│  - DISTINCT ki zarurat nahi hai                             │
│  - Lekin kuch solutions mein DISTINCT likhte hain extra     │
│    safety ke liye                                           │
│                                                             │
│  WHY NO GROUP BY NEEDED?                                    │
│  - Aggregation nahi chahiye                                 │
│  - Direct row-level filter hai                              │
│  - Simple SELECT + WHERE se kaam ho jata hai                │
│                                                             │
│  EDGE CASES:                                                │
│  - revenue = 0: exclude (strictly > 0)                      │
│  - No 2021 row: customer not in output                      │
│  - Multiple years per customer: only 2021 row checked       │
│                                                             │
│  POSTGRESQL NOTE:                                           │
│  - year column int hai, toh 2021 (integer) use karo        │
│  - '2021' string bhi kaam karega due to implicit casting   │
│  - Best practice: match data type (int = int)               │
└─────────────────────────────────────────────────────────────┘
*/

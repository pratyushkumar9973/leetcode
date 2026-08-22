-- ============================================================
-- LEETCODE: 1421. NPV Queries

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: NPV                                                 │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ id            │ int     │                                 │
│  │ year          │ int     │                                 │
│  │ npv           │ int     │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  (id, year) is the primary key of this table.               │
│  The table has information about the id and the year of     │
│  each inventory and the corresponding net present value.    │
│                                                             │
│  Table: Queries                                             │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ id            │ int     │                                 │
│  │ year          │ int     │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  (id, year) is the primary key of this table.               │
│  Each row contains the id and year of a query.              │
│                                                             │
│  Write an SQL query to find the NPV of each query in the  │
│  Queries table.                                             │
│                                                             │
│  Return the result table in any order.                      │
│                                                             │
│  Note: If a query does not exist in the NPV table, return   │
│  NPV as 0.                                                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  NPV table:                                                 │
│  +-----+------+--------+                                    │
│  │ id  │ year │ npv    │                                    │
│  +-----+------+--------+                                    │
│  │ 1   │ 2018 │ 100    │                                    │
│  │ 7   │ 2020 │ 30     │                                    │
│  │ 13  │ 2019 │ 40     │                                    │
│  │ 1   │ 2019 │ 113    │                                    │
│  │ 2   │ 2008 │ 121    │                                    │
│  │ 3   │ 2009 │ 12     │                                    │
│  │ 11  │ 2020 │ 99     │                                    │
│  │ 7   │ 2019 │ 0      │                                    │
│  +-----+------+--------+                                    │
│                                                             │
│  Queries table:                                             │
│  +-----+------+                                             │
│  │ id  │ year │                                             │
│  +-----+------+                                             │
│  │ 1   │ 2019 │                                             │
│  │ 2   │ 2008 │                                             │
│  │ 3   │ 2009 │                                             │
│  │ 7   │ 2018 │                                             │
│  │ 7   │ 2019 │                                             │
│  │ 7   │ 2020 │                                             │
│  │ 13  │ 2019 │                                             │
│  +-----+------+                                             │
│                                                             │
│  Output:                                                    │
│  +-----+------+--------+                                    │
│  │ id  │ year │ npv    │                                    │
│  +-----+------+--------+                                    │
│  │ 1   │ 2019 │ 113    │                                    │
│  │ 2   │ 2008 │ 121    │                                    │
│  │ 3   │ 2009 │ 12     │                                    │
│  │ 7   │ 2018 │ 0      │                                    │
│  │ 7   │ 2019 │ 0      │                                    │
│  │ 7   │ 2020 │ 30     │                                    │
│  │ 13  │ 2019 │ 40     │                                    │
│  +-----+------+--------+                                    │
│                                                             │
│  Explanation:                                               │
│  - (1, 2019): NPV table mein hai -> npv = 113               │
│  - (2, 2008): NPV table mein hai -> npv = 121               │
│  - (3, 2009): NPV table mein hai -> npv = 12                │
│  - (7, 2018): NPV table mein nahi hai -> npv = 0           │
│  - (7, 2019): NPV table mein hai -> npv = 0                 │
│  - (7, 2020): NPV table mein hai -> npv = 30                │
│  - (13, 2019): NPV table mein hai -> npv = 40              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT
    q.id,
    q.year,
    COALESCE(n.npv, 0) AS npv
FROM Queries q
LEFT JOIN NPV n ON q.id = n.id AND q.year = n.year;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  LEFT JOIN Queries q ON NPV n                               │
│  - Queries table LEFT side pe hai (sab rows chahiye)        │
│  - NPV table RIGHT side pe hai (match ho toh data lo)       │
│  - ON condition mein dono columns match karte hain:        │
│    q.id = n.id AND q.year = n.year                          │
│                                                             │
│  COALESCE(n.npv, 0)                                         │
│  - PostgreSQL mein IFNULL ki jagah COALESCE use hota hai    │
│  - Agar n.npv NULL hai (match nahi mila), toh 0 return karo │
│  - MySQL mein IFNULL(n.npv, 0) hota                         │
│  - COALESCE multiple arguments le sakta hai                  │
│                                                             │
│  WHY LEFT JOIN AND NOT INNER JOIN?                          │
│  - INNER JOIN sirf matching rows deta hai                   │
│  - Lekin question bolta hai: agar query NPV mein nahi hai   │
│    toh bhi row chahiye with npv = 0                        │
│  - LEFT JOIN se non-matching rows bhi aati hain              │
│                                                             │
│  WHY MATCH ON BOTH id AND year?                             │
│  - Primary key composite hai (id, year)                     │
│  - Sirf id match karne se galat result aa sakta hai         │
│  - Example: id=1 ke liye 2018 aur 2019 dono alag npv hain   │
│                                                             │ 
└─────────────────────────────────────────────────────────────┘
*/

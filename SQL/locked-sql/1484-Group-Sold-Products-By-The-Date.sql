-- ============================================================
-- LEETCODE: 1484. Group Sold Products By The Date
-- DIFFICULTY: Easy (🔒 Locked / Premium)
-- TAGS: Database
-- ============================================================

/*
┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Activities                                          │
│  +-------------+---------+                                  │
│  │ Column Name │ Type    │                                  │
│  +-------------+---------+                                  │
│  │ sell_date   │ date    │                                  │
│  │ product     │ varchar │                                  │
│  +-------------+---------+                                  │
│                                                             │
│  There is no primary key for this table, it may have        │
│  duplicates.                                                │
│  Each row contains the product name and the date it was     │
│  sold in a market.                                          │
│                                                             │
│  Write a solution to find for each date the number of       │
│  different products sold and their names.                   │
│                                                             │
│  The sold products names for each date should be sorted     │
│  lexicographically.                                         │
│                                                             │
│  Return the result table ordered by sell_date.              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Activities table:                                          │
│  +------------+------------+                                │
│  │ sell_date  │ product    │                                │
│  +------------+------------+                                │
│  │ 2020-05-30 │ Headphone  │                                │
│  │ 2020-06-01 │ Pencil     │                                │
│  │ 2020-06-02 │ Mask       │                                │
│  │ 2020-05-30 │ Basketball │                                │
│  │ 2020-06-01 │ Bible      │                                │
│  │ 2020-06-02 │ Mask       │                                │
│  │ 2020-05-30 │ T-Shirt    │                                │
│  +------------+------------+                                │
│                                                             │
│  Output:                                                    │
│  +------------+----------+------------------------------+    │
│  │ sell_date  │ num_sold │ products                     │    │
│  +------------+----------+------------------------------+    │
│  │ 2020-05-30 │ 3        │ Basketball,Headphone,T-Shirt │    │
│  │ 2020-06-01 │ 2        │ Bible,Pencil                 │    │
│  │ 2020-06-02 │ 1        │ Mask                         │    │
│  +------------+----------+------------------------------+    │
│                                                             │
│  Explanation:                                               │
│  - 2020-05-30: 3 products (Headphone, Basketball, T-Shirt)  │
│    sorted: Basketball,Headphone,T-Shirt                     │
│  - 2020-06-01: 2 products (Pencil, Bible)                   │
│    sorted: Bible,Pencil                                     │
│  - 2020-06-02: 1 product (Mask)                             │
│    duplicate Mask ek hi baar count hua                      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    STRING_AGG(DISTINCT product, ',' ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  COUNT(DISTINCT product)                                    │
│  - Har date pe kitne unique products bech gaye              │
│  - DISTINCT se duplicate products ek hi baar count hote hain │
│  - Example: 2020-06-02 pe Mask do baar hai, COUNT = 1       │
│                                                             │
│  STRING_AGG(DISTINCT product, ',' ORDER BY product)         │
│  - PostgreSQL mein GROUP_CONCAT ki jagah STRING_AGG use hota hai │
│  - DISTINCT product: unique products lo                     │
│  - ',' separator: comma se join karo                        │
│  - ORDER BY product: lexicographically (A-Z) sort karo      │
│  - MySQL mein: GROUP_CONCAT(DISTINCT product ORDER BY product) │
│                                                             │
│  GROUP BY sell_date                                         │
│  - Same date wale rows ko ek group mein daalo               │
│  - Har date ke liye alag row banegi output mein             │
│                                                             │
│  ORDER BY sell_date                                         │
│  - Result ko date ke ascending order mein sort karo         │
│  - Question mein explicitly bola hai                        │
│                                                             │
│  MySQL vs PostgreSQL:                                       │
│  - MySQL: GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') │
│  - PostgreSQL: STRING_AGG(DISTINCT product, ',' ORDER BY product) │
│  - Function alag hai, logic bilkul same hai                 │
│                                                             │
│  EDGE CASES:                                                │
│  - Same product multiple times same date: DISTINCT handle   │
│  - Empty date: not in output                                │
│  - Single product: no comma, single string                  │
│  - NULL product: DISTINCT se ignore                         │
│                                                             │
│  WHY NOT ARRAY_AGG?                                         │
│  - PostgreSQL mein ARRAY_AGG bhi hota hai                   │
│  - Lekin output format string chahiye (comma separated)     │
│  - STRING_AGG exactly wahi format deta hai                  │
└─────────────────────────────────────────────────────────────┘
*/

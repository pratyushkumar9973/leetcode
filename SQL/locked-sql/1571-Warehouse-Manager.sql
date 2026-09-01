-- ============================================================
-- LEETCODE: 1571. Warehouse Manager
-- DIFFICULTY: Easy (🔒 Locked / Premium)
-- TAGS: Database
-- ============================================================

/*
┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Warehouse                                           │
│  +--------------+---------+                                  │
│  │ Column Name  │ Type    │                                  │
│  +--------------+---------+                                  │
│  │ name         │ varchar │                                  │
│  │ product_id   │ int     │                                  │
│  │ units        │ int     │                                  │
│  +--------------+---------+                                  │
│                                                             │
│  (name, product_id) is the primary key for this table.      │
│  Each row contains the information of the products in each  │
│  warehouse.                                                 │
│                                                             │
│  Table: Products                                            │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ product_id    │ int     │                                 │
│  │ product_name  │ varchar │                                 │
│  │ Width         │ int     │                                 │
│  │ Length        │ int     │                                 │
│  │ Height        │ int     │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  product_id is the primary key for this table.              │
│  Each row contains information about the product dimensions │
│  (Width, Length, and Height) in feet of each product.       │
│                                                             │
│  Write a solution to report the number of cubic feet of     │
│  volume the inventory occupies in each warehouse.           │
│                                                             │
│  Return the result table in any order.                      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Warehouse table:                                           │
│  +------------+------------+-------+                        │
│  │ name       │ product_id │ units │                        │
│  +------------+------------+-------+                        │
│  │ LCHouse1   │ 1          │ 1     │                        │
│  │ LCHouse1   │ 2          │ 10    │                        │
│  │ LCHouse1   │ 3          │ 5     │                        │
│  │ LCHouse2   │ 1          │ 2     │                        │
│  │ LCHouse2   │ 2          │ 2     │                        │
│  │ LCHouse3   │ 4          │ 1     │                        │
│  +------------+------------+-------+                        │
│                                                             │
│  Products table:                                            │
│  +------------+--------------+-------+--------+--------+     │
│  │ product_id │ product_name │ Width │ Length │ Height │     │
│  +------------+--------------+-------+--------+--------+     │
│  │ 1          │ LC-TV        │ 5     │ 50     │ 40     │     │
│  │ 2          │ LC-KeyChain  │ 5     │ 5      │ 5      │     │
│  │ 3          │ LC-Phone     │ 2     │ 10     │ 10     │     │
│  │ 4          │ LC-T-Shirt   │ 4     │ 10     │ 20     │     │
│  +------------+--------------+-------+--------+--------+     │
│                                                             │
│  Output:                                                    │
│  +----------------+--------+                                 │
│  │ warehouse_name │ volume │                                 │
│  +----------------+--------+                                 │
│  │ LCHouse1       │ 12250  │                                 │
│  │ LCHouse2       │ 20250  │                                 │
│  │ LCHouse3       │ 800    │                                 │
│  +----------------+--------+                                 │
│                                                             │
│  Explanation:                                               │
│  - Product 1 (LC-TV): 5 * 50 * 40 = 10000 cubic feet       │
│  - Product 2 (LC-KeyChain): 5 * 5 * 5 = 125 cubic feet     │
│  - Product 3 (LC-Phone): 2 * 10 * 10 = 200 cubic feet      │
│  - Product 4 (LC-T-Shirt): 4 * 10 * 20 = 800 cubic feet    │
│                                                             │
│  LCHouse1: 1*10000 + 10*125 + 5*200 = 12250 cubic feet     │
│  LCHouse2: 2*10000 + 2*125 = 20250 cubic feet              │
│  LCHouse3: 1*800 = 800 cubic feet                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT
    w.name AS warehouse_name,
    SUM(w.units * p.Width * p.Length * p.Height) AS volume
FROM Warehouse w
INNER JOIN Products p ON w.product_id = p.product_id
GROUP BY w.name;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JOIN Warehouse w ON Products p                             │
│  - product_id pe join karo taaki dimensions mil sake        │
│  - INNER JOIN se sirf woh products aayenge jo dono tables   │
│    mein hain                                                │
│                                                             │
│  w.units * p.Width * p.Length * p.Height                    │
│  - units = kitne pieces hain us warehouse mein               │
│  - Width * Length * Height = ek piece ka volume (cubic feet)│
│  - Multiply se total volume for that product in warehouse    │
│                                                             │
│  SUM(...)                                                   │
│  - Har warehouse mein saare products ka volume add karo     │
│  - Aggregate function har group ke liye total deta hai      │
│                                                             │
│  GROUP BY w.name                                            │
│  - Har warehouse ke liye alag group banaya jata hai         │
│  - name column se group kiya (warehouse ka naam)            │
│                                                             │
│  WHY NOT GROUP BY 1?                                        │
│  - MySQL mein GROUP BY 1 (first column) chalta hai          │
│  - PostgreSQL mein bhi chalta hai lekin explicit column     │
│    name likhna better practice hai                          │
│                                                             │
│  WHY INNER JOIN NOT LEFT JOIN?                              │
│  - Agar koi product Products table mein nahi hai, toh       │
│    uska volume calculate nahi kar sakte                     │
│  - LEFT JOIN karte toh NULL volume aata (galat result)      │
│                                                             │
│  POSTGRESQL NOTE:                                           │
│  - Column names case-sensitive hain (Width, Length, Height) │
│  - SUM integer multiplication karke integer return karta hai  │
│  - Agar bohot bada number ho toh BIGINT use karo            │
│                                                             │
│  EDGE CASES:                                                │
│  - Empty warehouse: not in output (no rows)                 │
│  - Product with 0 units: contributes 0 to volume            │
│  - Missing product in Products: ignored due to INNER JOIN   │
└─────────────────────────────────────────────────────────────┘
*/

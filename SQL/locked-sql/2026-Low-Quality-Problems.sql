-- ============================================================
-- LEETCODE: 2026. Low-Quality Problems

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Problems                                            │
│  +-------------+------+                                     │
│  │ Column Name │ Type │                                     │
│  +-------------+------+                                     │
│  │ problem_id  │ int  │                                     │
│  │ likes       │ int  │                                     │
│  │ dislikes    │ int  │                                     │
│  +-------------+------+                                     │
│                                                             │
│  problem_id is the primary key column for this table.       │
│  Each row of this table indicates the number of likes     │
│  and dislikes for a LeetCode problem.                       │
│                                                             │
│  Write an SQL query to report the IDs of the low-quality   │
│  problems.                                                  │
│                                                             │
│  A LeetCode problem is low-quality if the like percentage │
│  of the problem (number of likes divided by the total     │
│  number of votes) is strictly less than 60%.                │
│                                                             │
│  Return the result table ordered by problem_id in          │
│  ascending order.                                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Problems table:                                            │
│  +------------+-------+----------+                          │
│  │ problem_id │ likes │ dislikes │                          │
│  +------------+-------+----------+                          │
│  │ 6          │ 1290  │ 425      │                          │
│  │ 11         │ 2677  │ 8659     │                          │
│  │ 1          │ 4446  │ 2760     │                          │
│  │ 7          │ 8569  │ 6086     │                          │
│  │ 13         │ 2050  │ 4164     │                          │
│  │ 10         │ 9002  │ 7446     │                          │
│  +------------+-------+----------+                          │
│                                                             │
│  Output:                                                    │
│  +------------+                                             │
│  │ problem_id │                                             │
│  +------------+                                             │
│  │ 7          │                                             │
│  │ 10         │                                             │
│  │ 11         │                                             │
│  │ 13         │                                             │
│  +------------+                                             │
│                                                             │
│  Explanation:                                               │
│  - Problem 1: (4446 / (4446 + 2760)) * 100 = 61.69858%    │
│    -> 61.7% >= 60% -> NOT low-quality                       │
│  - Problem 6: (1290 / (1290 + 425)) * 100 = 75.21866%       │
│    -> 75.2% >= 60% -> NOT low-quality                       │
│  - Problem 7: (8569 / (8569 + 6086)) * 100 = 58.47151%      │
│    -> 58.5% < 60% -> LOW-QUALITY                           │
│  - Problem 10: (9002 / (9002 + 7446)) * 100 = 54.73006%     │
│    -> 54.7% < 60% -> LOW-QUALITY                           │
│  - Problem 11: (2677 / (2677 + 8659)) * 100 = 23.61503%     │
│    -> 23.6% < 60% -> LOW-QUALITY                           │
│  - Problem 13: (2050 / (2050 + 4164)) * 100 = 32.99002%     │
│    -> 33.0% < 60% -> LOW-QUALITY                           │
│                                                             │
│  Problems 7, 10, 11, and 13 are low-quality.                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT problem_id
FROM Problems
WHERE likes * 100.0 / (likes + dislikes) < 60
ORDER BY problem_id;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  likes * 100.0 / (likes + dislikes) < 60                    │
│  - Like percentage calculate karne ka formula               │
│  - 100.0 se multiply kiya (not 100) taaki decimal division   │
│    ho (integer division nahi)                               │
│  - PostgreSQL mein 100.0 float banata hai, result float     │
│    aata hai                                                 │
│  - likes + dislikes = total votes                           │
│  - likes / total votes * 100 = like percentage              │
│                                                             │
│  WHY likes * 100.0 / ... AND NOT likes / ... * 100?         │
│  - Dono same result dete hain mathematically                 │
│  - Lekin likes * 100.0 / ... pehle multiply karke float      │
│    division ensure karta hai                                │
│  - likes / (likes + dislikes) < 0.6 bhi same kaam karta hai  │
│                                                             │
│  WHERE clause mein condition                                │
│  - Strictly less than 60% -> < 60 (not <=)                 │
│  - 60% exactly ho toh include nahi hoga                     │
│                                                             │
│  ORDER BY problem_id                                          │
│  - Result ascending order mein sort karna hai               │
│  - Question mein explicitly bola hai                        │

│                                                             │
│  EDGE CASES:                                                │
│  - likes = 0, dislikes = 0: 0/0 = NULL -> WHERE false       │
│    -> not included (correct)                                │
│  - likes = 0, dislikes > 0: 0% < 60% -> included            │
│  - likes > 0, dislikes = 0: 100% >= 60% -> not included       │
│                                                             │
│  WHY NOT ROUND OR CAST?                                     │
│  - Exact comparison chahiye, round karne ki zarurat nahi   │
│  - PostgreSQL automatic type promotion karta hai            │
│  - 100.0 se multiply karne se float division guarantee     │
└─────────────────────────────────────────────────────────────┘
*/

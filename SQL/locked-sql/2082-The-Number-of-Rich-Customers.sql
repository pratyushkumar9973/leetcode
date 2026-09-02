-- ============================================================
-- LEETCODE: 2082. The Number of Rich Customers
-- DIFFICULTY: Easy (🔒 Locked / Premium)
-- TAGS: Database
-- ============================================================

/*
┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Store                                               │
│  +-------------+------+                                     │
│  │ Column Name │ Type │                                     │
│  +-------------+------+                                     │
│  │ bill_id     │ int  │                                     │
│  │ customer_id │ int  │                                     │
│  │ amount      │ int  │                                     │
│  +-------------+------+                                     │
│                                                             │
│  bill_id is the primary key for this table.                 │
│  Each row contains information about the amount of one bill │
│  and the customer associated with it.                       │
│                                                             │
│  Write an SQL query to report the number of customers who  │
│  had at least one bill with an amount strictly greater than  │
│  500.                                                       │
│                                                             │
│  Return the result as a single column named rich_count.     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Store table:                                               │
│  +---------+-------------+--------+                         │
│  │ bill_id │ customer_id │ amount │                         │
│  +---------+-------------+--------+                         │
│  │ 6       │ 1           │ 549    │                         │
│  │ 8       │ 1           │ 834    │                         │
│  │ 4       │ 2           │ 394    │                         │
│  │ 11      │ 3           │ 657    │                         │
│  │ 13      │ 3           │ 257    │                         │
│  +---------+-------------+--------+                         │
│                                                             │
│  Output:                                                    │
│  +------------+                                             │
│  │ rich_count │                                             │
│  +------------+                                             │
│  │ 2          │                                             │
│  +------------+                                             │
│                                                             │
│  Explanation:                                               │
│  - Customer 1: bill 549 > 500, bill 834 > 500 -> RICH      │
│  - Customer 2: bill 394 <= 500 -> NOT RICH                  │
│  - Customer 3: bill 657 > 500, bill 257 <= 500 -> RICH     │
│  - Total rich customers: 2 (Customer 1 and Customer 3)      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT COUNT(DISTINCT customer_id) AS rich_count
FROM Store
WHERE amount > 500;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  COUNT(DISTINCT customer_id)                                │
│  - Sirf unique customers count karo                         │
│  - DISTINCT se same customer do bills ke saath ek hi baar   │
│    count hoga                                               │
│  - Example: Customer 1 ne do bills 549 aur 834 dono > 500   │
│    lekin COUNT DISTINCT = 1 (ek hi customer)                │
│                                                             │
│  WHERE amount > 500                                         │
│  - Sirf woh bills lo jinka amount strictly greater than 500 │
│    hai                                                      │
│  - = 500 wale exclude honge                                 │
│                                                             │
│  AS rich_count                                              │
│  - Output column ka naam 'rich_count' hona chahiye          │
│  - Question mein explicitly bola hai                        │
│                                                             │
│  WHY NOT GROUP BY?                                          │
│  - Sirf total count chahiye, har customer ka alag nahi      │
│  - Simple aggregate se kaam ho jata hai                     │
│                                                             │
│  WHY NOT HAVING?                                            │
│  - HAVING tab use hota hai jab GROUP BY ke baad filter      │
│    karna ho                                                 │
│  - Yahan pehle se WHERE se filter kar rahe hain             │
│                                                             │
│  EDGE CASES:                                                │
│  - No bills > 500: return 0                                 │
│  - All customers rich: return total unique customers        │
│  - Single customer multiple rich bills: still count 1       │
│                                                             │
│  POSTGRESQL NOTE:                                           │
│  - COUNT ignores NULL values automatically                  │
│  - DISTINCT NULL ko ek baar count karta hai                 │
│  - amount > 500 direct integer comparison hai               │
└─────────────────────────────────────────────────────────────┘
*/

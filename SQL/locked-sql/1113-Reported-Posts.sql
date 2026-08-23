-- ============================================================
-- LEETCODE: 1113. Reported Posts

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Actions                                             │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ user_id       │ int     │                                 │
│  │ post_id       │ int     │                                 │
│  │ action_date   │ date    │                                 │
│  │ action        │ enum    │                                 │
│  │ extra         │ varchar │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  There is no primary key for this table, it may have        │
│  duplicate rows.                                            │
│                                                             │
│  The action column is an ENUM type of ('view', 'like',      │
│  'reaction', 'comment', 'report', 'share').                   │
│                                                             │
│  The extra column has optional information about the        │
│  action such as a reason for report or a type of reaction.  │
│                                                             │
│  Write an SQL query that reports the number of posts        │
│  reported yesterday for each report reason.                 │
│                                                             │
│  Assume today is 2019-07-05.                                │
│                                                             │
│  Note that we only care about report reasons with           │
│  non-zero number of reports.                                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Actions table:                                             │
│  +---------+---------+-------------+--------+--------+      │
│  │ user_id │ post_id │ action_date │ action │ extra  │      │
│  +---------+---------+-------------+--------+--------+      │
│  │ 1       │ 1       │ 2019-07-01  │ view   │ null   │      │
│  │ 1       │ 1       │ 2019-07-01  │ like   │ null   │      │
│  │ 1       │ 1       │ 2019-07-01  │ share  │ null   │      │
│  │ 2       │ 4       │ 2019-07-04  │ view   │ null   │      │
│  │ 2       │ 4       │ 2019-07-04  │ report │ spam   │      │
│  │ 3       │ 4       │ 2019-07-04  │ view   │ null   │      │
│  │ 3       │ 4       │ 2019-07-04  │ report │ spam   │      │
│  │ 4       │ 3       │ 2019-07-02  │ view   │ null   │      │
│  │ 4       │ 3       │ 2019-07-02  │ report │ spam   │      │
│  │ 5       │ 2       │ 2019-07-04  │ view   │ null   │      │
│  │ 5       │ 2       │ 2019-07-04  │ report │ racism │      │
│  │ 5       │ 5       │ 2019-07-04  │ view   │ null   │      │
│  │ 5       │ 5       │ 2019-07-04  │ report │ racism │      │
│  +---------+---------+-------------+--------+--------+      │
│                                                             │
│  Output:                                                    │
│  +---------------+--------------+                           │
│  │ report_reason │ report_count │                           │
│  +---------------+--------------+                           │
│  │ spam          │ 1            │                           │
│  │ racism        │ 2            │                           │
│  +---------------+--------------+                           │
│                                                             │
│  Explanation:                                               │
│  - Yesterday = 2019-07-04 (today is 2019-07-05)             │
│  - spam: post_id 4 reported (2 users ne same post report    │
│    kiya, but COUNT DISTINCT post_id = 1)                    │
│  - racism: post_id 2 aur 5 dono reported, COUNT = 2          │
│  - 2019-07-02 ka spam report ignore ho gaya (not yesterday) │
│  - Only report reasons with count > 0 shown                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT
    extra AS report_reason,
    COUNT(DISTINCT post_id) AS report_count
FROM Actions
WHERE action = 'report'
    AND action_date = '2019-07-04'
    AND extra IS NOT NULL
GROUP BY extra;



┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WHERE action = 'report'                                    │
│  - Sirf 'report' action wale rows lo                        │
│  - view, like, share, etc. sab filter ho jayenge          │
│                                                             │
│  AND action_date = '2019-07-04'                             │
│  - Today 2019-07-05 hai, yesterday = 2019-07-04           │
│  - PostgreSQL mein date direct string se compare hoti hai  │
│  - MySQL mein DATEDIFF('2019-07-05', action_date) = 1       │
│    use hota hai, lekin PostgreSQL mein direct date         │
│    comparison better hai                                    │
│                                                             │
│  COUNT(DISTINCT post_id)                                    │
│  - Same post ko multiple users report kar sakte hain        │
│  - DISTINCT se unique posts count hote hain                 │
│  - Example: post_id 4 ko 2 users ne report kiya spam       │
│    lekin count sirf 1 aayega                               │
│                                                             │
│  GROUP BY extra                                             │
│  - extra column mein report reason hai (spam, racism, etc.) │
│  - Har reason ke liye alag group banaya jata hai          │
│  - COUNT har group ke liye alag calculate hota hai         │
│                                                             │
│  WHY NOT HAVING COUNT > 0?                                │
│  - Question bolta hai: "only care about report reasons      │
│    with non-zero number of reports"                         │
│  - Lekin GROUP BY + COUNT automatically non-zero wale hi    │
│    return karta hai (zero count wale groups mein rows hi    │
│    nahi hoti)                                               │
│  - HAVING clause ki zarurat nahi hai is case mein         │
│                                                             │
│  POSTGRESQL vs MySQL DIFFERENCE:                           │
│  - MySQL: DATEDIFF('2019-07-05', action_date) = 1          │
│  - PostgreSQL: action_date = '2019-07-05'::date - 1        │
│    ya direct '2019-07-04'                                   │
│  - LeetCode pe direct date string accepted hai dono mein   │
│                                                             │
│  DUPLICATE ROWS HANDLE:                                     │
│  - Table mein duplicate rows ho sakti hain                  │
│  - DISTINCT post_id se duplicate reports same post ke         │
│    automatically handle ho jate hain                       │
│                                                             │
│  EDGE CASE: extra = null                                    │
│  - Agar koi report bina reason ke hai (extra = null)        │
│  - GROUP BY null se ek group ban jayega                   │
│  - Lekin question assume karta hai valid reasons hain       │
└─────────────────────────────────────────────────────────────┘
*/

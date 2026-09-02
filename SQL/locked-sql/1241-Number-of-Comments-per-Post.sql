-- ============================================================
-- LEETCODE: 1241. Number of Comments per Post

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Submissions                                         │
│  +---------------+----------+                                 │
│  │ Column Name   │ Type     │                                 │
│  +---------------+----------+                                 │
│  │ sub_id        │ int      │                                 │
│  │ parent_id     │ int      │                                 │
│  +---------------+----------+                                 │
│                                                             │
│  There is no primary key for this table, it may have       │
│  duplicate rows.                                            │
│  Each row can be a post or comment on the post.             │
│  parent_id is null for posts.                               │
│  parent_id for comments is sub_id for another post in the  │
│  table.                                                     │
│                                                             │
│  Write an SQL query to find the number of comments per     │
│  each post.                                                 │
│                                                             │
│  Result table should contain post_id and its corresponding  │
│  number_of_comments, and must be sorted by post_id in      │
│  ascending order.                                           │
│                                                             │
│  Submissions may contain duplicate comments. You should    │
│  count the number of unique comments per post.             │
│                                                             │
│  Submissions may contain duplicate posts. You should treat   │
│  them as one post.                                          │
│                                                             │
│  The comment with id 6 is a comment on a deleted post      │
│  with id 7 so we ignored it.                                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Submissions table:                                         │
│  +---------+------------+                                   │
│  │ sub_id  │ parent_id  │                                   │
│  +---------+------------+                                   │
│  │ 1       │ Null       │                                   │
│  │ 2       │ Null       │                                   │
│  │ 1       │ Null       │                                   │
│  │ 12      │ Null       │                                   │
│  │ 3       │ 1          │                                   │
│  │ 5       │ 2          │                                   │
│  │ 3       │ 1          │                                   │
│  │ 4       │ 1          │                                   │
│  │ 9       │ 1          │                                   │
│  │ 10      │ 2          │                                   │
│  │ 6       │ 7          │                                   │
│  +---------+------------+                                   │
│                                                             │
│  Output:                                                    │
│  +---------+--------------------+                           │
│  │ post_id │ number_of_comments │                           │
│  +---------+--------------------+                           │
│  │ 1       │ 3                  │                           │
│  │ 2       │ 2                  │                           │
│  │ 12      │ 0                  │                           │
│  +---------+--------------------+                           │
│                                                             │
│  Explanation:                                               │
│  - Post 1: comments 3, 4, 9 (comment 3 duplicate hai,      │
│    sirf ek baar count hoga) -> 3 unique comments            │
│  - Post 2: comments 5, 10 -> 2 unique comments               │
│  - Post 12: koi comment nahi -> 0                            │
│  - Comment 6: parent_id 7 hai jo post nahi hai, ignore      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/


-- Method 2: CTE (Cleaner)


-- WITH Posts AS (
--     SELECT DISTINCT sub_id
--     FROM Submissions
--     WHERE parent_id IS NULL
-- ),
-- Comments AS (
--     SELECT DISTINCT s1.sub_id AS post_id, s2.sub_id AS comment_id
--     FROM Posts s1
--     LEFT JOIN Submissions s2 ON s2.parent_id = s1.sub_id
-- )
-- SELECT post_id, COUNT(comment_id) AS number_of_comments
-- FROM Comments
-- GROUP BY post_id
-- ORDER BY post_id;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │   │
│                                                             │
│  LEFT JOIN Submissions s2 ON s2.parent_id = s1.sub_id        │
│  - s2 table se comments fetch karo                           │
│  - parent_id = s1.sub_id means ye comment s1 post pe hai   │
│  - LEFT JOIN se posts bina comments ke bhi aayenge         │
│                                                             │
│  WHERE s1.parent_id IS NULL                                 │
│  - Sirf posts select karo, comments nahi                   │
│  - parent_id NULL = ye khud post hai, kisi ka comment nahi  │
│                                                             │
│  COUNT(DISTINCT s2.sub_id)                                  │
│  - DISTINCT se duplicate comments ek hi baar count hote hain  │
│  - Example: comment 3 do baar hai, COUNT DISTINCT = 1       │
│  - Agar post ke koi comment nahi, COUNT = 0 (not NULL)      │
│                                                             │
│  Comment 6 (parent_id = 7) kyun ignore hua?                 │
│  - s1 mein parent_id IS NULL filter se post 7 nahi aata    │
│  - Kyunki 7 kisi ka comment hai, post nahi                  │
│  - Toh s2 mein bhi ye row nahi aayegi      


-- LEETCODE: 613. Shortest Distance in a Line

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Point                                               │
│  +-------------+------+                                     │
│  │ Column Name │ Type │                                     │
│  +-------------+------+                                     │
│  │ x           │ int  │                                     │
│  +-------------+------+                                     │
│                                                             │
│  In SQL, x is the primary key column for this table.        │
│  Each row indicates the position of a point on the X-axis.  │
│  All points are unique (no duplicates).                     │
│                                                             │
│  Write a query to find the shortest distance between        │
│  any two points from the Point table.                       │
│                                                             │
│  Return the result as a single column named 'shortest'.     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Point table:                                               │
│  +----+                                                     │
│  │ x  │                                                     │
│  +----+                                                     │
│  │ -1 │                                                     │
│  │ 0  │                                                     │
│  │ 2  │                                                     │
│  +----+                                                     │
│                                                             │
│  Output:                                                    │
│  +----------+                                               │
│  │ shortest │                                               │
│  +----------+                                               │
│  │ 1        │                                               │
│  +----------+                                               │
│                                                             │
│  Explanation:                                               │
│  The shortest distance is between points -1 and 0           │
│  which is |(-1) - 0| = 1.                                   │
│                                                             │
│  Other distances:                                           │
│  |0 - 2| = 2                                                │
│  |-1 - 2| = 3                                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION                                                   │
├─────────────────────────────────────────────────────────────┤
*/

-- Method 1: Self-Join (Cartesian Product + Filter)
SELECT MIN(ABS(p1.x - p2.x)) AS shortest
FROM Point p1
JOIN Point p2 ON p1.x != p2.x;

-- Method 2: Self-Join (Optimized - only p1.x < p2.x)
-- SELECT MIN(p2.x - p1.x) AS shortest
-- FROM Point p1
-- JOIN Point p2 ON p1.x < p2.x;

-- Method 3: Window Function (LEAD/LAG)
-- SELECT MIN(x - LAG(x) OVER (ORDER BY x)) AS shortest
-- FROM Point;


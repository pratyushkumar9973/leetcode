-- LEETCODE: 603. Consecutive Available Seats

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Cinema                                              │
│  +-------------+------+                                     │
│  │ Column Name │ Type │                                     │
│  +-------------+------+                                     │
│  │ seat_id     │ int  │                                     │
│  │ free        │ bool │                                     │
│  +-------------+------+                                     │
│                                                             │
│  seat_id is an auto-increment column for this table.        │
│  Each row indicates whether the ith seat is free or not.    │
│  1 means free while 0 means occupied.                       │
│                                                             │
│  Find all the consecutive available seats in the cinema.    │
│                                                             │
│  Return the result table ordered by seat_id in ascending    │
│  order.                                                     │
│                                                             │
│  The test cases are generated so that more than two seats │
│  are consecutively available.                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Cinema table:                                              │
│  +---------+------+                                         │
│  │ seat_id │ free │                                         │
│  +---------+------+                                         │
│  │ 1       │ 1    │                                         │
│  │ 2       │ 0    │                                         │
│  │ 3       │ 1    │                                         │
│  │ 4       │ 1    │                                         │
│  │ 5       │ 1    │                                         │
│  +---------+------+                                         │
│                                                             │
│  Output:                                                    │
│  +---------+                                                │
│  │ seat_id │                                                │
│  +---------+                                                │
│  │ 3       │                                                │
│  │ 4       │                                                │
│  │ 5       │                                                │
│  +---------+                                                │
│                                                             │
│  Explanation:                                               │
│  - Seat 1: free but isolated (seat 2 occupied)             │
│  - Seat 2: occupied                                         │
│  - Seats 3,4,5: all free AND consecutive (3-4-5)            │
│  - Only seats 3,4,5 qualify as part of consecutive group    │
│                                                             │
│  Note: "More than 2 seats" means at least 3 consecutive     │
│  free seats hona chahiye total mein, individual seat        │
│  bhi return karte hain jo us group mein hain              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤



-- Method 2: Window Functions (LAG + LEAD)
-- WITH CinemaNeighbors AS (
--     SELECT
--         seat_id,
--         free,
--         LAG(free) OVER (ORDER BY seat_id) AS prev_free,
--         LEAD(free) OVER (ORDER BY seat_id) AS next_free
--     FROM Cinema
-- )
-- SELECT seat_id
-- FROM CinemaNeighbors
-- WHERE free = 1
--   AND (prev_free = 1 OR next_free = 1)
-- ORDER BY seat_id;




-- Method 3: Two Self-Joins (Previous + Next)
-- SELECT C.seat_id
-- FROM Cinema C
-- LEFT JOIN Cinema P ON P.seat_id + 1 = C.seat_id AND P.free = 1 AND C.free = 1
-- LEFT JOIN Cinema N ON C.seat_id + 1 = N.seat_id AND C.free = 1 AND N.free = 1
-- WHERE NOT (P.seat_id IS NULL AND N.seat_id IS NULL)
-- ORDER BY C.seat_id;

/*

┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                                     │
│                                                             │
│  METHOD 2 (Window Functions - RECOMMENDED):                │
│  - LAG(free) se previous seat ka status milta hai           │
│  - LEAD(free) se next seat ka status milta hai             │
│  - free = 1 AND (prev_free = 1 OR next_free = 1)           │
│    means current seat free hai AND at least ek neighbor     │
│    bhi free hai                                             │
│  - PostgreSQL mein Window Functions best performance dete  │
│                                                             │
│  METHOD 3 (Two Self-Joins):                                 │
│  - P = previous seat (P.seat_id + 1 = C.seat_id)           │
│  - N = next seat (C.seat_id + 1 = N.seat_id)               │
│  - WHERE NOT (P IS NULL AND N IS NULL)                     │
│    means current seat isolated nahi hai                    │
│  - Lekin yeh method complex hai, Method 2 prefer karo     │
│                                                             │
                 │
│                                                             │
│  EDGE CASES:                                                │
│  - Single free seat: not included (no consecutive neighbor) │
│  - All seats occupied: empty result                         │
│  - All seats free: all returned (consecutive group)         │
│                                                             │
      │
└─────────────────────────────────────────────────────────────┘
*/

-- ============================================================
-- LEETCODE: 1294. Weather Type in Each Country

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Countries                                           │
│  +---------------+---------+                                │
│  │ Column Name   │ Type    │                                │
│  +---------------+---------+                                │
│  │ country_id    │ int     │                                │
│  │ country_name  │ varchar │                                │
│  +---------------+---------+                                │
│                                                             │
│  country_id is the primary key for this table.              │
│  Each row contains the ID and the name of one country.      │
│                                                             │
│  Table: Weather                                             │
│  +---------------+---------+                                │
│  │ Column Name   │ Type    │                                │
│  +---------------+---------+                                │
│  │ country_id    │ int     │                                │
│  │ weather_state │ int     │                                │
│  │ day           │ date    │                                │
│  +---------------+---------+                                │
│                                                             │
│  (country_id, day) is the primary key for this table.       │
│  Each row indicates the weather state in a country for one  │
│  day.                                                       │
│                                                             │
│  Write an SQL query to find the type of weather in each     │
│  country for November 2019.                                 │
│                                                             │
│  The type of weather is:                                    │
│  - Cold if average weather_state <= 15                      │
│  - Hot if average weather_state >= 25                       │
│  - Warm otherwise                                           │
│                                                             │
│  Return result table in any order.                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Countries table:                                           │
│  +------------+--------------+                                │
│  │ country_id │ country_name │                                │
│  +------------+--------------+                                │
│  │ 2          │ USA          │                                │
│  │ 3          │ Australia    │                                │
│  │ 7          │ Peru         │                                │
│  │ 5          │ China        │                                │
│  │ 8          │ Morocco      │                                │
│  │ 9          │ Spain        │                                │
│  +------------+--------------+                                │
│                                                             │
│  Weather table:                                             │
│  +------------+---------------+------------+                │
│  │ country_id │ weather_state │ day        │                │
│  +------------+---------------+------------+                │
│  │ 2          │ 15            │ 2019-11-01 │                │
│  │ 2          │ 12            │ 2019-10-28 │                │
│  │ 2          │ 12            │ 2019-10-27 │                │
│  │ 3          │ -2            │ 2019-11-10 │                │
│  │ 3          │ 0             │ 2019-11-11 │                │
│  │ 3          │ 3             │ 2019-11-12 │                │
│  │ 5          │ 16            │ 2019-11-07 │                │
│  │ 5          │ 18            │ 2019-11-09 │                │
│  │ 5          │ 21            │ 2019-11-23 │                │
│  │ 7          │ 25            │ 2019-11-28 │                │
│  │ 7          │ 22            │ 2019-12-01 │                │
│  │ 7          │ 20            │ 2019-12-02 │                │
│  │ 8          │ 25            │ 2019-11-05 │                │
│  │ 8          │ 27            │ 2019-11-15 │                │
│  │ 8          │ 31            │ 2019-11-25 │                │
│  │ 9          │ 7             │ 2019-10-23 │                │
│  │ 9          │ 3             │ 2019-12-23 │                │
│  +------------+---------------+------------+                │
│                                                             │
│  Output:                                                    │
│  +--------------+--------------+                              │
│  │ country_name │ weather_type │                              │
│  +--------------+--------------+                              │
│  │ USA          │ Cold         │                              │
│  │ Australia    │ Cold         │                              │
│  │ Peru         │ Hot          │                              │
│  │ China        │ Warm         │                              │
│  │ Morocco      │ Hot          │                              │
│  +--------------+--------------+                              │
│                                                             │
│  Explanation:                                               │
│  - USA Nov: (15) / 1 = 15 -> Cold                         │
│  - Australia Nov: (-2 + 0 + 3) / 3 = 0.33 -> Cold           │
│  - Peru Nov: (25) / 1 = 25 -> Hot                         │
│  - China Nov: (16 + 18 + 21) / 3 = 18.33 -> Warm          │
│  - Morocco Nov: (25 + 27 + 31) / 3 = 27.67 -> Hot          │
│  - Spain: no Nov 2019 data -> excluded from result          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────────┤
*/

SELECT
    c.country_name,
    CASE
        WHEN AVG(w.weather_state) <= 15 THEN 'Cold'
        WHEN AVG(w.weather_state) >= 25 THEN 'Hot'
        ELSE 'Warm'
    END AS weather_type
FROM Countries c
JOIN Weather w ON c.country_id = w.country_id
WHERE w.day BETWEEN '2019-11-01' AND '2019-11-30'
GROUP BY c.country_id, c.country_name;

/*
┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JOIN Countries c ON Weather w                              │
│  - country_id pe join karo taaki country_name mil sake      │
│  - INNER JOIN se sirf woh countries aayenge jinka data hai  │
│                                                             │
│  WHERE w.day BETWEEN '2019-11-01' AND '2019-11-30'          │
│  - Sirf November 2019 ke rows filter karo                  │
│  - PostgreSQL mein date strings direct compare hoti hain    │
│  - October aur December ke data ignore honge                │
│                                                             │
│  CASE WHEN ... THEN ... END                               │
│  - Conditional logic: Cold, Hot, ya Warm decide karta hai   │
│  - AVG aggregate function ke upar lagta hai                 │
│  - Order matter karta hai: <= 15 pehle, >= 25 doosra        │
│                                                             │
│  AVG(w.weather_state)                                       │
│  - Har country ke November days ka average nikalo             │
│  - PostgreSQL mein AVG float return karta hai               │
│                                                             │
│  GROUP BY c.country_id, c.country_name                        │
│  - Har country ke liye ek group                             │
│  - country_id bhi include kiya (primary key, safer)         │
│  - country_name sirf display ke liye hai                    │
│                                                             │
│  WHY Spain NOT IN OUTPUT?                                   │
│  - Spain ka November 2019 mein koi data nahi hai            │
│  - INNER JOIN se non-matching rows exclude ho jati hain     │
│  - LEFT JOIN karte toh Spain NULL ke saath aata             │
│                                                             │
│  POSTGRESQL NOTE:                                           │
│  - GROUP BY mein SELECT ke non-aggregate columns dene hain  │
│  - country_id primary key hai, isliye country_name bhi      │
│    group kar sakte hain (PostgreSQL strict mode)            │
│  - MySQL mein sirf country_name bhi kaam karta hai          │
│                                                             │
│  WEATHER_STATE TYPE:                                        │
│  - weather_state int hai (not varchar)                      │
│  - Negative values allowed hain (-2, 0, etc.)               │
│  - AVG directly calculate ho jata hai                       │
└─────────────────────────────────────────────────────────────┘
*/

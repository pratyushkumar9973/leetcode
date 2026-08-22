-- ============================================================
-- LEETCODE: 1350. Students With Invalid Departments

┌─────────────────────────────────────────────────────────────┐
│  QUESTION                                                   │
├─────────────────────────────────────────────────────────────┤
│  Table: Students                                            │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ id            │ int     │                                 │
│  │ name          │ varchar │                                 │
│  │ department_id │ int     │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  id is the primary key for this table.                      │
│  Each row contains the id, name, and department id          │
│  of a student.                                              │
│                                                             │
│  Table: Departments                                         │
│  +---------------+---------+                                 │
│  │ Column Name   │ Type    │                                 │
│  +---------------+---------+                                 │
│  │ id            │ int     │                                 │
│  │ name          │ varchar │                                 │
│  +---------------+---------+                                 │
│                                                             │
│  id is the primary key for this table.                      │
│  Each row contains the id and name of a department.         │
│                                                             │
│  Write an SQL query to find the id and the name of all      │
│  students who are enrolled in departments that no longer    │
│  exist.                                                     │
│                                                             │
│  Return the result table in any order.                      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  EXAMPLE                                                    │
├─────────────────────────────────────────────────────────────┤
│  Input:                                                     │
│  Students table:                                            │
│  +----+-------+---------------+                             │
│  │ id │ name  │ department_id │                             │
│  +----+-------+---------------+                             │
│  │ 1  │ Alice │ 31            │                             │
│  │ 2  │ Bob   │ 32            │                             │
│  │ 3  │ Tom   │ 33            │                             │
│  │ 4  │ John  │ 34            │                             │
│  │ 5  │ Alex  │ 35            │                             │
│  +----+-------+---------------+                             │
│                                                             │
│  Departments table:                                         │
│  +----+----------+                                          │
│  │ id │ name     │                                          │
│  +----+----------+                                          │
│  │ 31 │ Electrical Engineering                               │
│  │ 32 │ Computer Engineering                                 │
│  │ 33 │ Mechanical Engineering                               │
│  +----+----------+                                          │
│                                                             │
│  Output:                                                    │
│  +----+-------+                                             │
│  │ id │ name  │                                             │
│  +----+-------+                                             │
│  │ 4  │ John  │                                             │
│  │ 5  │ Alex  │                                             │
│  +----+-------+                                             │
│                                                             │
│  Explanation:                                               │
│  - John (department_id = 34) - department 34 does not       │
│    exist in Departments table                               │
│  - Alex (department_id = 35) - department 35 does not       │
│    exist in Departments table                               │
│  - Alice, Bob, Tom ke departments exist karte hain          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  SOLUTION                                                   │
├─────────────────────────────────────────────────────────────┤
*/

-- Method 1: LEFT JOIN + IS NULL
SELECT
    s.id,
    s.name
FROM Students s
LEFT JOIN Departments d ON s.department_id = d.id
WHERE d.id IS NULL;

-- Method 2: NOT IN
-- SELECT id, name
-- FROM Students
-- WHERE department_id NOT IN (SELECT id FROM Departments);


┌─────────────────────────────────────────────────────────────┐
│  EXPLANATION                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  METHOD 1 (LEFT JOIN + IS NULL):                            │
│  - LEFT JOIN se Students table ke saare rows aate hain      │
│    chahe Departments mein match ho ya na ho               │
│  - Jahan match nahi hota, wahan d.id NULL hota hai          │
│  - WHERE d.id IS NULL se sirf unmatched rows milti hain     │
│  - MOST COMMON approach, easy to understand                 │
│                                                             │
│  METHOD 2 (NOT IN):                                         │
│  - Subquery se saare valid department_ids nikalo            │
│  - Students mein se woh rows lo jo is list mein nahi hain   │
│  - Problem: agar Departments.id mein NULL ho toh            │
│    pura result empty aa sakta hai (SQL quirk)               │
│                                                             │                                                                                                                        │
└─────────────────────────────────────────────────────────────┘

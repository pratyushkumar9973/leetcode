SELECT class FROM Courses 
GROUP BY class
having  COUNT(student) >= 5;

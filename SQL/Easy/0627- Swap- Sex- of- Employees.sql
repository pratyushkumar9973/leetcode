UPDATE Salary
SET SEX = CASE WHEN sex = 'f'  THEN 'm'
WHEN sex = 'm' THEN 'f' ENd      

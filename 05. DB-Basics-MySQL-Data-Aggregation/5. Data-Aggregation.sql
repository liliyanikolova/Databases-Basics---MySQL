SELECT *
FROM wizzard_deposits;

-- (1) Records’ Count
SELECT count(*)
FROM wizzard_deposits;

-- (2) Longest Magic Wand
SELECT MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits;

-- (3) Longest Magic Wand per Deposit Groups
SELECT deposit_group, max(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits
GROUP BY deposit_group;

-- (4) Smallest Deposit Group per Magic Wand Size
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY avg(magic_wand_size)
LIMIT 1;

-- (5) Deposits Sum
SELECT deposit_group, sum(deposit_amount) AS total_sum
FROM wizzard_deposits
GROUP BY deposit_group;

-- (6) Deposits Sum for Ollivander family
SELECT wd.deposit_group, SUM(wd.deposit_amount)
FROM wizzard_deposits AS wd
WHERE wd.magic_wand_creator = 'Ollivander family'
GROUP BY wd.deposit_group;

-- (7) Deposits Filter
SELECT wd.deposit_group, SUM(wd.deposit_amount) AS total_sum
FROM wizzard_deposits AS wd
WHERE wd.magic_wand_creator = 'Ollivander family'
GROUP BY wd.deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

-- (8) Deposit charge
SELECT wd.deposit_group, wd.magic_wand_creator, MIN(wd.deposit_charge) AS min_deposit_charge
FROM wizzard_deposits AS wd
GROUP BY wd.deposit_group, wd.magic_wand_creator
ORDER BY wd.magic_wand_creator, wd.deposit_group;

-- (9) Age Groups
SELECT CASE WHEN wd.age BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN wd.age BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN wd.age BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN wd.age BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN wd.age BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN wd.age BETWEEN 51 AND 60 THEN '[51-60]'
				ELSE '[61+]'
		END AS 'age_group', 
		COUNT(*) AS wizard_count
FROM wizzard_deposits AS wd
GROUP BY age_group;

-- (10) First Letter
SELECT LEFT(wd.first_name, 1) AS 'first_letter'
FROM wizzard_deposits AS wd
WHERE wd.deposit_group = 'Troll Chest'
GROUP BY LEFT(wd.first_name, 1)
ORDER BY first_letter;

-- (11) Average Interest
SELECT wd.deposit_group, wd.is_deposit_expired, AVG(wd.deposit_interest) AS 'average_interest'
FROM wizzard_deposits AS wd
WHERE wd.deposit_start_date > '19850101'
GROUP BY wd.deposit_group, wd.is_deposit_expired
ORDER BY wd.deposit_group DESC, wd.is_deposit_expired ASC;

-- (12) Rich Wizard, Poor Wizard
SELECT SUM(wd1.deposit_amount - wd2.deposit_amount) AS sum_difference
FROM wizzard_deposits AS wd1
JOIN wizzard_deposits AS wd2
ON wd1.id = wd2.id - 1;


SELECT *
FROM employees;

-- (13) Employees Minimum Salaries
SELECT e.department_id, MIN(e.salary)
FROM employees AS e
WHERE e.hire_date > '20000101'
GROUP BY e.department_id
HAVING e.department_id IN (2, 5, 7);

-- (14) Employees Average Salaries
CREATE TABLE new_employees
SELECT *
FROM employees AS e
WHERE e.salary > 30000;

DELETE
FROM new_employees
WHERE manager_id = 42;

UPDATE new_employees
SET salary = salary + 5000
WHERE department_id =1;

SELECT ne.department_id, AVG(ne.salary) AS 'salary_average'
FROM new_employees AS ne
GROUP BY ne.department_id;

-- (15) Employees Maximum Salaries
SELECT e.department_id, MAX(e.salary) AS 'max_salary'
FROM employees AS e
GROUP BY e.department_id
HAVING MAX(e.salary) NOT BETWEEN 30000 AND 70000;

-- (16) Employees Count Salaries
-- First way
SELECT COUNT(*) - COUNT(e.manager_id) AS 'count'
FROM employees AS e;

-- Second way
SELECT COUNT(*) AS 'count'
FROM employees AS e
WHERE e.manager_id IS NULL;

-- (17) 3rd Highest Salary

-- SELECT e1.department_id,
-- (
-- SELECT e2.salary
-- FROM employees AS e2
-- WHERE e1.department_id = e2.department_id
-- ORDER BY e2.salary DESC
-- LIMIT 1 OFFSET 2
-- ) AS 'third_highest_salary'
-- FROM employees AS e1
-- GROUP BY e1.department_id
-- HAVING third_highest_salary IS NOT NULL;


SELECT e.department_id, MAX(e.salary) AS max_salary 
FROM employees AS e 
JOIN 
(
	SELECT e.department_id, MAX(e.salary) AS max_salary 
	FROM employees AS e 
	JOIN 
	(
		SELECT e.department_id, MAX(e.salary) AS max_salary 
		FROM employees AS e 
		GROUP BY e.department_id
	) AS fms 
	ON e.department_id = fms.department_id AND e.salary < fms.max_salary 
	GROUP BY e.department_id
) AS sms 
ON e.department_id = sms.department_id AND e.salary < sms.max_salary 
GROUP BY e.department_id

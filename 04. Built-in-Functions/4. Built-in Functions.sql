-- (1) Find Names of All Employees by First Name
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE e.first_name LIKE 'SA%';

-- (2) Find Names of All employees by Last Name
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE e.last_name LIKE '%ei%';

-- (3) Find First Names of All Employees
SELECT e.first_name
FROM employees AS e
WHERE (e.department_id = 3 OR e.department_id = 10)
		AND (YEAR(e.hire_date)>= 1995 AND YEAR(e.hire_date)<= 2005);

-- (4) Find All Employees Except Engineers
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE e.job_title NOT LIKE '%engineer%';

-- (5) Find Towns with Name Length
SELECT t.name
FROM towns AS t
WHERE CHAR_LENGTH(t.name) = 5 OR CHAR_LENGTH(t.name) = 6
ORDER BY t.name;

-- (6) Find Towns Starting With
SELECT *
FROM towns AS t
WHERE LEFT(t.name, 1) IN ('M', 'K', 'B', 'E')
ORDER BY t.name;

-- (7) Find Towns Not Starting With
SELECT *
FROM towns AS t
WHERE LEFT(t.name, 1) NOT IN ('R', 'B', 'D')
ORDER BY t.name;

-- (8) Create View Employees Hired After 2000 Year
CREATE VIEW v_employees_hired_after_2000 AS
	SELECT e.first_name, e.last_name
	FROM employees AS e
	WHERE YEAR(e.hire_date) > 2000;

-- (9) Length of Last Name
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE CHAR_LENGTH(e.last_name) = 5;

-- (10) Countries Holding ‘A’ 3 or More Times
SELECT c.country_name, c.iso_code
FROM countries AS c
WHERE CHAR_LENGTH(c.country_name) - CHAR_LENGTH(REPLACE(LOWER(c.country_name), 'a', '')) >= 3
ORDER BY c.iso_code;

-- (11) Mix of Peak and River Names
SELECT p.peak_name, r.river_name, CONCAT(LOWER(p.peak_name), RIGHT(r.river_name, CHAR_LENGTH(r.river_name) - 1)) AS 'mix'
FROM peaks AS p, rivers AS r
WHERE LOWER(RIGHT(p.peak_name, 1)) = LOWER(LEFT(r.river_name, 1))
ORDER BY mix;

-- (12) Games from 2011 and 2012 year
SELECT g.name, DATE_FORMAT(g.`start`, '%Y-%m-%d')
FROM games AS g
WHERE YEAR(g.`start`) IN (2011, 2012)
ORDER BY g.`start`, g.name
LIMIT 50;

-- (13) User Email Providers
SELECT u.user_name, RIGHT(u.email, CHAR_LENGTH(u.email) - LOCATE('@',u.email)) AS 'email_provider'
FROM users AS u
ORDER BY email_provider, u.user_name;

-- (14) Get Users with IPAdress Like Pattern
SELECT u.user_name, u.ip_address
FROM users AS u
WHERE u.ip_address LIKE '___.1%.%.___'
ORDER BY u.user_name;

-- (15) Show All Games with Duration and Part of the Day
SELECT g.name,
			CASE
				WHEN HOUR(g.`start`) >= 0 AND HOUR(g.`start`) < 12 THEN 'Morning'
				WHEN HOUR(g.`start`) >= 12 AND HOUR(g.`start`) < 18 THEN 'Afternoon'
				WHEN HOUR(g.`start`) >= 18 AND HOUR(g.`start`) < 24 THEN 'Evening'
			END AS 'part_of_the_day',
			CASE
				WHEN g.duration <= 3 THEN 'Extra Short'
				WHEN g.duration <= 6 THEN 'Short'
				WHEN g.duration > 6 THEN 'Long' 
				WHEN g.duration IS NULL THEN 'Extra Long'
			END AS 'new_duration'
FROM games AS g
ORDER BY g.name, new_duration, part_of_the_day;

-- (16) Orders Table
CREATE DATABASE orders_table;

CREATE TABLE orders
(
	id INT PRIMARY KEY, 
	product_name VARCHAR(50), 
	order_date DATE
);

INSERT INTO orders (id, product_name, order_date)
VALUES
	(1, 'Buter', '2016-09-19 00:00:00'),
	(2, 'Milk', '2016-09-30 00:00:00'),
	(3, 'Cheese', '2016-09-04 00:00:00'),
	(4, 'Bread', '2015-12-20 00:00:00'),
	(5, 'Tomatoes', '2015-12-30 00:00:00');

SELECT o.product_name, o.order_date, 
		DATE_ADD(o.order_date,INTERVAL 3 DAY) AS 'pay_due',
		DATE_ADD(o.order_date,INTERVAL 1 MONTH) AS 'deliver_due'
FROM orders AS o;




















CREATE DATABASE table_relationship;

-- (1) One-To-One Relationship
CREATE TABLE passports
(
	passport INT PRIMARY KEY,
	passport_number VARCHAR(50)
);


CREATE TABLE persons 
(
	person_id INT PRIMARY KEY,
	first_name VARCHAR(50),
	salary DECIMAL,
	passport_id INT,
	CONSTRAINT fk_persons_Passports FOREIGN KEY (passport_id) REFERENCES passports(passport)
);

INSERT INTO  passports (passport, passport_number)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

INSERT INTO  persons (person_id, first_name, salary, passport_id)
VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101);

-- (2) One-To-Many Relationship
CREATE TABLE manufacturers
(
	manufacturer_id INT PRIMARY KEY,
	name VARCHAR(50),
	established_on DATE
);

CREATE TABLE models
(
	model_id INT PRIMARY KEY,
	name VARCHAR(50),
	manufacturer_id INT,
	CONSTRAINT fk_models_manufacturers FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

INSERT INTO manufacturers (manufacturer_id, name, established_on)
VALUES
(1, 'BMW', '19160307'),
(2, 'Tesla', '20030101'),
(3, 'Lada', '19660501');

INSERT INTO models (model_id, name, manufacturer_id)
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

-- (3) Many-To-Many Relationship
CREATE TABLE students
(
	student_id INT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE exams
(
	exam_id INT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE students_exams
(
	student_id INT,
	exam_id INT,
	CONSTRAINT pk_students_exams PRIMARY KEY (student_id, exam_id),
	CONSTRAINT fk_studentsExams_students FOREIGN KEY (student_id) REFERENCES students(student_id),
	CONSTRAINT fk_studentsExams_exams FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

-- (4) Self-Referencing
CREATE TABLE teachers
(
	teacher_id INT PRIMARY KEY,
	name VARCHAR(50),
	manager_id INT NULL
);

INSERT INTO teachers (teacher_id, name, manager_id)
VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Grete', 101);

ALTER TABLE teachers
ADD CONSTRAINT fk_teachers_teachers 
FOREIGN KEY(manager_id) REFERENCES teachers(teacher_id);

-- (5) Online Store Database
CREATE DATABASE store;

USE store;

CREATE TABLE cities
(
	city_id INT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,
	name VARCHAR(50),
	birthday DATE,
	city_id INT,
	CONSTRAINT fk_customers_ciies FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE orders
(
	order_id INT PRIMARY KEY,
	customer_id INT,
	CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE item_types
(
	item_type_id INT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE items
(
	item_id INT PRIMARY KEY,
	name VARCHAR(50),
	item_type_id INT,
	CONSTRAINT fk_items_item_types FOREIGN KEY (item_type_id) REFERENCES item_types(item_type_id)
);

CREATE TABLE orderItems
(
	order_id INT,
	item_id INT,
	CONSTRAINT pk_orderItems PRIMARY KEY (order_id, item_id),
	CONSTRAINT fk_orderItem_items FOREIGN KEY (item_id) REFERENCES items(item_id),
	CONSTRAINT fk_orderItem_oders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- (6) University Database
CREATE DATABASE university_database;

CREATE TABLE majors
(
	major_id INT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE students
(
	student_id INT PRIMARY KEY,
	student_number VARCHAR(50),
	student_name VARCHAR(50),
	major_id INT,
	CONSTRAINT fk_students_majors FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE payments
(
	payment_id INT PRIMARY KEY,
	payment_date DATE,
	payment_amount DECIMAL(8,2),
	student_id INT,
	CONSTRAINT fk_payment_students FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE subjects
(
	subject_id INT PRIMARY KEY,
	subject_name VARCHAR(50)
);

CREATE TABLE agenda
(
	student_id INT,
	subject_id INT,
	CONSTRAINT pk_student_subject PRIMARY KEY (student_id, subject_id),
	CONSTRAINT fk_agenda_students FOREIGN KEY (student_id) REFERENCES students(student_id),
	CONSTRAINT fk_agenda_subjects FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- (9) Employee Address
SELECT e.employee_id, e.job_title, a.address_id, a.address_text
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;

-- (10) Employee Departments
SELECT e.employee_id, e.first_name, e.salary, d.name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY e.department_id
LIMIT 5;

-- (11) Employees Without Project
SELECT e.employee_id, e.first_name
FROM employees AS e
LEFT JOIN employees_projects AS ep
	ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id
LIMIT 3;

-- (12) Employees with Project
SELECT e.employee_id, e.first_name, p.name AS project_name
FROM employees AS e
JOIN employees_projects AS ep
	ON e.employee_id = ep.employee_id
JOIN projects AS p
	ON ep.project_id = p.project_id
WHERE p.start_date > '20020813' AND p.end_date IS NULL
ORDER BY e.employee_id
LIMIT 5;

-- (13) Employee 24 
-- Mine
SELECT e.employee_id, e.first_name, 
	IF (p.start_date > '20050101', NULL, p.name) AS project_name
FROM employees AS e
JOIN employees_projects AS ep
	ON e.employee_id = ep.employee_id
JOIN projects AS p
	ON ep.project_id = p.project_id
WHERE e.employee_id = 24;

-- 
SELECT e.employee_id, e.first_name, 
	IF (p.start_date > '20050101', NULL, p.name) AS project_name
FROM employees AS e
JOIN employees_projects AS ep
	ON e.employee_id = ep.employee_id
LEFT JOIN projects AS p
	ON ep.project_id = p.project_id
		AND p.start_date < '20050101'
WHERE e.employee_id = 24;

-- (14) Employee Manager
SELECT e.employee_id, e.first_name, e.manager_id, m.first_name
FROM employees AS e
LEFT JOIN employees AS m
	ON e.manager_id = m.employee_id
WHERE e.manager_id = 3 OR e.manager_id = 7
ORDER BY e.employee_id;

-- (15) Highest Peak in Bulgaria
SELECT mc.country_code, m.mountain_range, p.peak_name, p.elevation
FROM mountains_countries AS mc
JOIN mountains AS m
	ON mc.mountain_id = m.id
JOIN peaks AS p
	ON m.id = p.mountain_id
WHERE mc.country_code = 'BG' 
	AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- (16) Count Mountain Ranges
SELECT c.country_code, COUNT(m.mountain_range)
FROM countries AS c
JOIN mountains_countries AS mc
	ON c.country_code = mc.country_code
JOIN mountains AS m
	ON mc.mountain_id = m.id
WHERE c.country_code = 'BG'
	OR c.country_code = 'US' 
	OR c.country_code = 'RU'
GROUP BY c.country_code;

-- (17) Countries with Rivers
SELECT c.country_name, r.river_name
FROM continents AS con
JOIN countries AS c
	ON con.continent_code = c.continent_code
LEFT JOIN countries_rivers AS cr
	ON c.country_code = cr.country_code
LEFT JOIN rivers AS r
	ON cr.river_id = r.id
WHERE con.continent_name = 'Africa'
ORDER BY c.country_name
LIMIT 5;

-- (18) Continents and Currencies
SELECT a.continent_code, a.currency_code, a.currency_usage
FROM
(
	SELECT con.continent_code, curr.currency_code, COUNT(*) AS 'currency_usage'
	FROM continents AS con
	JOIN countries AS c
		ON con.continent_code = c.continent_code
	JOIN currencies AS curr
		ON c.currency_code = curr.currency_code
	GROUP BY con.continent_code, curr.currency_code
	HAVING COUNT(*) > 1
) AS a
INNER JOIN
(
	SELECT cu.continent_code, cu.currency_code, MAX(currency_usage) AS 'max_currency_usage'
	FROM
	(
		SELECT con.continent_code, curr.currency_code, COUNT(*) AS 'currency_usage'
		FROM continents AS con
		JOIN countries AS c
			ON con.continent_code = c.continent_code
		JOIN currencies AS curr
			ON c.currency_code = curr.currency_code
		GROUP BY con.continent_code, curr.currency_code
		HAVING COUNT(*) > 1
	) AS cu
	GROUP BY cu.continent_code
) AS b
	ON a.continent_code = b.continent_code
	AND a.currency_usage = max_currency_usage
ORDER BY a.continent_code;

-- --------------------------------------
SELECT a.continent_code, a.currency_code, a.currency_usage
FROM
(
	SELECT con.continent_code, curr.currency_code, COUNT(*) AS 'currency_usage'
	FROM continents AS con
	JOIN countries AS c
		ON con.continent_code = c.continent_code
	JOIN currencies AS curr
		ON c.currency_code = curr.currency_code
	GROUP BY con.continent_code, curr.currency_code
	HAVING COUNT(*) > 1
) AS a
INNER JOIN
(
	SELECT cu.continent_code, cu.currency_code, MAX(currency_usage) AS 'max_currency_usage'
	FROM
	(
		SELECT con.continent_code, curr.currency_code, COUNT(*) AS 'currency_usage'
		FROM continents AS con
		JOIN countries AS c
			ON con.continent_code = c.continent_code
		JOIN currencies AS curr
			ON c.currency_code = curr.currency_code
		GROUP BY con.continent_code, curr.currency_code
		HAVING COUNT(*) > 1
	) AS cu
	GROUP BY cu.continent_code
) AS b
	ON a.continent_code = b.continent_code
	AND a.currency_usage = max_currency_usage
ORDER BY a.continent_code;

-- (19) Countries Without any Mountains
SELECT COUNT(*) AS 'country_code'
FROM countries AS c
LEFT JOIN mountains_countries AS mc
	ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL;

-- (20) Highest Peak and Longest River by Country
SELECT rs.country_name, ps.highest_peak_elevation, rs.longest_river_length
FROM 
(
	SELECT c.country_name, MAX(r.length) AS 'longest_river_length'
	FROM rivers AS r
	RIGHT JOIN countries_rivers AS cr
		ON r.id = cr.river_id
	RIGHT JOIN countries AS c
		ON cr.country_code = c.country_code
	GROUP BY c.country_name
) AS rs
INNER JOIN 
(
	SELECT c.country_name, MAX(p.elevation) AS 'highest_peak_elevation'
	FROM countries AS c
	LEFT JOIN mountains_countries AS mc
		ON c.country_code = mc.country_code
	LEFT JOIN mountains AS m
		ON mc.mountain_id = m.id
	LEFT JOIN peaks AS p
		ON m.id = p.mountain_id
	GROUP BY c.country_name
) as ps
	ON rs.country_name = ps.country_name
ORDER BY ps.highest_peak_elevation DESC, 
			rs.longest_river_length DESC,
			ps.country_name
LIMIT 5;

-- (21) Highest Peak Name and Elevation by Country
SELECT *
FROM
(
	SELECT c.country_name, p.peak_name AS 'highest_peak_name', p.elevation, m.mountain_range AS 'mountain'
	FROM countries AS c
	INNER JOIN mountains_countries AS mc
		ON c.country_code = mc.country_code
	INNER JOIN mountains AS m
		ON mc.mountain_id = m.id
	INNER JOIN peaks AS p
		ON m.id = p.mountain_id
	INNER JOIN
	(	
		SELECT c.country_name, MAX(p.elevation) AS 'highest_peak_elevation'
		FROM countries AS c
		INNER JOIN mountains_countries AS mc
			ON c.country_code = mc.country_code
		INNER JOIN mountains AS m
			ON mc.mountain_id = m.id
		INNER JOIN peaks AS p
			ON m.id = p.mountain_id
		GROUP BY c.country_name
	) AS b
		ON c.country_name = b.country_name
		AND p.elevation = b.highest_peak_elevation
	UNION ALL	
	SELECT c.country_name, '(no highest peak)' AS 'highest_peak_name', 0 AS 'highest_peak_elevation', '(no mountain)' AS 'mountain'
	FROM countries AS c
	LEFT JOIN mountains_countries AS mc
		ON c.country_code = mc.country_code
	LEFT JOIN mountains AS m
		ON mc.mountain_id = m.id
	LEFT JOIN peaks AS p
		ON m.id = p.mountain_id
	GROUP BY c.country_name
	HAVING MAX(p.elevation) IS NULL
) AS result
ORDER BY result.country_name, result.highest_peak_name
LIMIT 5;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	















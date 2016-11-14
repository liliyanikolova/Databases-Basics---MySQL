-- (1) Problem 1.	Employees with Salary Above 35000

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE e.salary > 35000;

END $$

CALL usp_get_employees_salary_above_35000();

-- (2) Employees with Salary Above Number

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(criteria DECIMAL(19,4))
BEGIN
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE e.salary >= criteria;
END $$

CALL usp_get_employees_salary_above(48100);

-- (3) Town Names Starting With

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(start_symbols VARCHAR(50))
BEGIN
SELECT t.name
FROM towns AS t
WHERE LEFT(t.name,LENGTH(start_symbols)) = start_symbols;

END $$

CALL usp_get_towns_starting_with('b');

-- (4) Employees from Town

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(50))
BEGIN
SELECT e.first_name,e.last_name
FROM employees AS e 
JOIN addresses AS a 
ON a.address_id = e.address_id
JOIN towns AS t 
ON a.town_id = t.town_id
WHERE t.name = town_name;
END $$

CALL usp_get_employees_from_town('Sofia');

-- (5) Salary Level Function

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(employee_salary DECIMAL(19,4))
RETURNS VARCHAR(50)
BEGIN
	DECLARE salary_level VARCHAR(50);
	IF employee_salary < 30000 THEN
		SET salary_level = 'Low';
	ELSEIF employee_salary <= 50000 THEN
		SET salary_level = 'Average';
	ELSE
		SET salary_level = 'High';
	END IF;
	
	RETURN salary_level;
END $$

SELECT e.salary, ufn_get_salary_level(e.salary) AS salary_Level
FROM employees AS e;

-- (6) Employees by Salary Level

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(50))
BEGIN
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE  ufn_get_salary_level(e.salary) = salary_level;
END $$

CALL usp_get_employees_by_salary_level('High');
 
-- (7) Define Function
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR (50))
RETURNS TINYINT
BEGIN
	DECLARE result TINYINT;
	DECLARE char_index INT;
	SET result := 1;
	SET char_index := 0;
	WHILE char_index < LENGTH(word) DO
		IF LOCATE(SUBSTRING(word, char_index, 1), set_of_letters, 1) = 0 THEN
			RETURN 0;
		END IF;
		SET char_index = char_index + 1;
	END WHILE;
	
	RETURN result;
END $$

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
SELECT ufn_is_word_comprised('oistmiahf', 'halves');












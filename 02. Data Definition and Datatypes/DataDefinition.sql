-- 04. Insert Records in Both Tables

INSERT INTO towns (id,name)
VALUES (1,'Sofia'), (2,'Plovdiv'), (3,'Varna');

INSERT INTO minions (id, name, age, town_id)
VALUES (1,'Kevin',22,1), (2,'Bob',15,3), (3,'Steward',NULL,2);

# 07. Create Table People

CREATE TABLE people
(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	picture BLOB,
	height FLOAT,
	weight FLOAT,
	gender VARCHAR(255),
	birthdate DATE NOT NULL,
	biography VARCHAR(255)
);

INSERT INTO people (id,name,picture,height,weight,gender,birthdate,biography)
VALUES (1,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(2,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(3,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(4,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(5,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu');



#08. Create Table Users

CREATE TABLE users
(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	picture BLOB,
	height FLOAT,
	weight FLOAT,
	gender VARCHAR(255),
	birthdate DATE NOT NULL,
	biography VARCHAR(255)
);

INSERT INTO users (id,name,picture,height,weight,gender,birthdate,biography)
VALUES (1,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(2,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(3,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(4,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu'),
(5,'Pesho',NULL,NULL,NULL,'f','1992-04-08','babdiadbiu');


# 13. Movies Database

CREATE TABLE directors
(
	id INT NOT NULL,
	director_name VARCHAR(255) NOT NULL,
	notes VARCHAR(255),
PRIMARY KEY(id)
);

CREATE TABLE genres
(
	id INT NOT NULL,
	genre_name VARCHAR(255) NOT NULL,
	notes VARCHAR(255),
PRIMARY KEY(id)
);

CREATE TABLE categories
(
	id INT NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	notes VARCHAR(255),
PRIMARY KEY(id)
);

CREATE TABLE movies
(
	id INT NOT NULL,
	title VARCHAR(255) NOT NULL,
	director_id INT NOT NULL,
	copyright_year YEAR,
	movie_length INT,
	genre_id INT NOT NULL,
	category_id INT,
	rating INT,
	notes VARCHAR(255),
PRIMARY KEY(id),
FOREIGN KEY(director_id)
	REFERENCES directors(id),
FOREIGN KEY(genre_id)
	REFERENCES genres(id),
FOREIGN KEY(category_id)
	REFERENCES categories(id)
);

INSERT INTO genres(id, genre_name, notes)
VALUES (1,'action',NULL),
(2,'comedy',NULL),
(3,'drama',NULL),
(4,'monty',NULL),
(5,'python',NULL);

INSERT INTO directors(id, director_name, notes)
VALUES (1,'1',NULL),
(2,'2',NULL),
(3,'3',NULL),
(4,'4',NULL),
(5,'5',NULL);

INSERT INTO categories(id, category_name, notes)
VALUES (1,'1',NULL),
(2,'2',NULL),
(3,'3',NULL),
(4,'4',NULL),
(5,'5',NULL);

INSERT INTO movies(id,title,director_id, copyright_year,movie_length,genre_id,category_id, rating, notes)
VALUES (1,'Film1',1,'2000',120,1,1,5,NULL),
(2,'Film2',2,'2000',120,2,2,6,NULL),
(3,'Film3',3,'2000',120,3,3,7,NULL),
(4,'Film4',4,'2000',120,4,4,8,NULL),
(5,'Film5',5,'2000',120,5,5,9,NULL);


#14. Car Rental Database
CREATE TABLE categories
(
	id INT NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	daily_rate INT NOT NULL,
	weekly_rate INT NOT NULL,
	monthly_rate INT NOT NULL, 
	weekend_rate INT NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE cars
(
	id INT NOT NULL,
	plate_number VARCHAR(255) NOT NULL,
	make VARCHAR(255),
	model VARCHAR(255),
	car_year YEAR,
	category_id INT NOT NULL,
	doors INT,
	picture BLOB,
	car_condition VARCHAR(255) NOT NULL,
	available TINYINT,
	PRIMARY KEY(id),
	FOREIGN KEY(category_id) REFERENCES categories(id)
);

CREATE TABLE employees
(
	id INT NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	title VARCHAR(255) NOT NULL,
	notes VARCHAR(255),
	PRIMARY KEY(id)
);

CREATE TABLE customers
(
	id INT NOT NULL,
	driver_licence_number VARCHAR(255) NOT NULL,
	full_name VARCHAR(255) NOT NULL,
	address VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
	zip_code VARCHAR(255) NOT NULL,
	notes VARCHAR(255),
	PRIMARY KEY(id)
);



CREATE TABLE rental_orders
(
	id INT NOT NULL,
	employee_id INT NOT NULL,
	customer_id INT NOT NULL,
	car_id INT NOT NULL,
	car_condition VARCHAR(255) NOT NULL,
	tank_level INT,
	kilometrage_start INT,
	kilometrage_end INT,
	total_kilometrage INT,
	start_date DATE,
	end_date DATE,
	total_days INT,
	rete_applied INT,
	tax_rate INT,
	order_status VARCHAR(255),
	notes VARCHAR(255),
	PRIMARY KEY(id),
	FOREIGN KEY(employee_id) REFERENCES employees(id),
	FOREIGN KEY(customer_id) REFERENCES customers(id),
	FOREIGN KEY(car_id) REFERENCES cars(id)
);

INSERT INTO categories (id, category_name, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES (1,'1',1,2,3,4),
(2,'2',1,2,3,4),
(3,'2',1,2,3,4);

INSERT INTO cars (id, plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
VALUES (1,'1111',NULL,NULL,'2000',1,4,NULL,'ok',1),
(2,'1112',NULL,NULL,'2000',2,4,NULL,'ok',1),
(3,'1113',NULL,NULL,'2000',2,4,NULL,'ok',1);

INSERT INTO employees (id, first_name, last_name, title, notes)
VALUES (1,'fname','lname','mr.',NULL),
(2,'fname2','lname2','mr.',NULL),
(3,'fname3','lname3','mr.',NULL);

INSERT INTO customers (id, driver_licence_number, full_name, address, city, zip_code, notes)
VALUES (1,'licence_num','fullname','address','city','code',NULL),
(2,'licence_num','fullname','address','city','code',NULL),
(3,'licence_num','fullname','address','city','code',NULL);


INSERT INTO rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rete_applied, tax_rate, order_status, notes)
VALUES (1,1,1,1,'ok',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,2,2,2,'ok',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,3,3,3,'ok',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

#19. Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

#20. Basic Select All Fields and Order Them
SELECT * FROM towns
ORDER BY name;
SELECT * FROM departments
ORDER BY name;
SELECT * FROM employees
ORDER BY salary DESC;

#21. Basic Select Some Fields
SELECT name FROM towns
ORDER BY name;
SELECT name FROM departments
ORDER BY name;
SELECT first_name, last_name, job_title, salary FROM employees
ORDER BY salary DESC;

#22. Increase Employees Salary
UPDATE employees
SET salary = salary*1.1;

Select salary FROM employees;
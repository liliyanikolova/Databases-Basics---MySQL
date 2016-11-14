CREATE DATABASE minions;

CREATE TABLE minions
(
	id int NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL,
	age int
);

CREATE TABLE towns
(
id int NOT NULL PRIMARY KEY,
name varchar(50) NOT NULL
);

ALTER TABLE minions
ADD town_id int NOT NULL

ALTER TABLE minions
ADD CONSTRAINT fk_town_id FOREIGN KEY (town_id) REFERENCES towns(id)

INSERT INTO towns(id,name) VALUES(1,'Sofia'), (2,'Plovdiv'), (3,'Varna')

INSERT INTO minions(id,name,age,town_id) VALUES(1,'Kelvin',22,1),(2,'Bob',15,3),(3,'Steward',NULL,2)

TRUNCATE TABLE minions

SELECT *
FROM minions

DROP TABLE minions,towns

CREATE TABLE people
(
id int NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
name varchar(200) NOT NULL,
picture blob,
height double,
weight double,
gender set('m','f') NOT NULL,
birthdate date NOT NULL,
biography varchar(max)
)


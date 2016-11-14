-- Section 1: Data Definition
CREATE TABLE flights(
	flight_id INT PRIMARY KEY,
	departure_time DATETIME NOT NULL,
	arrival_time DATETIME NOT NULL,
	status ENUM('Departing', 'Delayed', 'Arrived', 'Cancelled'), 
	origin_airport_id INT,
	destination_airport_id INT,
	airline_id INT,
	CONSTRAINT fk_flights_origin_airport FOREIGN KEY (origin_airport_id) REFERENCES airports(airport_id),
	CONSTRAINT fk_flights_destination_airport FOREIGN KEY (destination_airport_id) REFERENCES airports(airport_id),
	CONSTRAINT fk_flights_airlines FOREIGN KEY (airline_id) REFERENCES airlines(airline_id)
);

CREATE TABLE tickets(
	ticket_id INT PRIMARY KEY,
	price DECIMAL (8,2) NOT NULL,
	class ENUM('First', 'Second', 'Third'),
	seat VARCHAR(5) NOT NULL,
	customer_id INT,
	flight_id INT,
	CONSTRAINT fk_tickets_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	CONSTRAINT fk_tickets_flights FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Section 2: Database Manipulations
-- Task 1: Data Insertion
INSERT INTO flights (flight_id,departure_time,arrival_time,status,origin_airport_id,destination_airport_id,airline_id)
VALUES 
(1,'2016-10-13 06:00','2016-10-13 10:00','Delayed',1,4,1),
(2,'2016-10-12 12:00','2016-10-12 12:01','Departing',1,3,2),
(3,'2016-10-14 15:00','2016-10-20 04:00','Delayed',4,2,4),
(4,'2016-10-12 13:24','2016-10-12 16:31','Departing',3,1,3),
(5,'2016-10-12 08:11','2016-10-12 23:22','Departing',4,1,1),
(6,'1995-06-21 12:30','1995-06-22 20:30','Arrived',2,3,5),
(7,'2016-10-12 23:34','2016-10-13 03:00','Departing',2,4,2),
(8,'2016-11-11 13:00','2016-11-12 22:00','Delayed',4,3,1),
(9,'2015-10-01 12:00','2015-12-01 01:00','Arrived',1,2,1),
(10,'2016-10-12 19:30','2016-10-13 12:30','Departing',2,1,7);

INSERT INTO tickets(ticket_id,price,class,seat,customer_id,flight_id)
VALUES
(1,3000.00,'First','233-A',3,8),
(2,1799.90,'Second','123-D',1,1),
(3,1200.50,'Second','12-Z',2,5),
(4,410.68,'Third','45-Q',2,8),
(5,560.00,'Third','201-R',4,6),
(6,2100.00,'Second','13-T',1,9),
(7,5500.00,'First','98-O',2,7);


-- Task 2: Update Arrived Flights
UPDATE flights
SET airline_id = 1
WHERE status = 'Arrived';

-- Task 3: Update Tickets
UPDATE tickets AS t, airlines AS al, flights AS f
SET t.price = t.price * 1.5
WHERE al.airline_id = f.airline_id AND f.flight_id = t.flight_id AND al.rating IN (SELECT MAX(rating)
																												FROM airlines);

-- Task 4: Table Creation
CREATE TABLE customer_reviews(
	review_id INT PRIMARY KEY,
	review_content VARCHAR(255) NOT NULL,
	review_grade ENUM('0','1','2','3','4','5','6','7','8','9','10'),
	airline_id INT,
	customer_id	INT,
	CONSTRAINT fk_customer_reviews_airlines FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
	CONSTRAINT fk_customer_reviews_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE customer_bank_accounts(
	account_id INT PRIMARY KEY,
	account_number VARCHAR(10) NOT NULL UNIQUE,
	balance DECIMAL(10,2) NOT NULL,
	customer_id INT,
	CONSTRAINT fk_customer_bank_accounts_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Task 5: Fill the new Tables with Data
INSERT INTO customer_reviews (review_id,review_content,review_grade,airline_id,customer_id)
VALUES
(1,'Me is very happy. Me likey this airline. Me good.','10',1,1),
(2,'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!','10',1,4),
(3,'Meh...','5',4,3),
(4,'Well Ive seen better, but Ive certainly seen a lot worse...','7',3,5);

INSERT INTO customer_bank_accounts(account_id,account_number,balance,customer_id)
VALUES 
(1,'123456790',2569.23,1),
(2,'18ABC23672',14004568.23,2),
(3,'F0RG0100N3',19345.20,5);

-- SECTION 3: Querying
-- Task 1: Extract All Tickets
SELECT t.ticket_id, t.price, t.class, t.seat
FROM tickets AS t
ORDER BY t.ticket_id;

-- Task 2: Extract All Customers
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS 'full_name', c.gender
FROM customers AS c
ORDER BY full_name, c.customer_id;

-- Task 3: Extract Delayed Flights
SELECT f.flight_id, f.departure_time, f.arrival_time
FROM flights AS f
WHERE f.`status` = 'Delayed'
ORDER BY f.flight_id;

-- Task 4: Extract Top 5 Most Highly Rated Airlines which have any Flights
SELECT a.airline_id, a.airline_name,a.nationality,a.rating
FROM airlines AS a
INNER JOIN flights AS f
	ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name,a.nationality,a.rating
ORDER BY a.rating DESC
LIMIT 5;

-- Task 5: Extract all Tickets with price below 5000, for First Class
SELECT t.ticket_id, ap.airport_name, CONCAT(c.first_name,' ',c.last_name) AS 'full_name'
FROM customers AS c
INNER JOIN tickets AS t
	ON c.customer_id = t.customer_id
INNER JOIN flights AS f
	ON t.flight_id = f.flight_id
INNER JOIN airports AS ap
	ON f.destination_airport_id = ap.airport_id
WHERE t.price < 5000 AND t.class = 'First'
ORDER BY t.ticket_id;

-- Task 6: Extract all Customers which are departing from their Home Town
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS 'Full_name',ts.town_name 
FROM towns AS ts
INNER JOIN customers AS c
	ON ts.town_id = c.home_town_id
INNER JOIN tickets AS t
	ON c.customer_id = t.customer_id
INNER JOIN flights AS f
	ON t.flight_id = f.flight_id 
WHERE c.home_town_id = f.origin_airport_id AND f.`status` = 'Departing'
ORDER BY c.customer_id;

-- Task 7: Extract all Customers which will fly
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS 'Full_name', 2016 - YEAR(c.date_of_birth) AS 'age'
FROM customers AS c
INNER JOIN tickets AS t
	ON c.customer_id = t.customer_id
INNER JOIN flights AS f
	ON t.flight_id = f.flight_id
WHERE f.`status` = 'Departing'
GROUP BY c.customer_id
ORDER BY age, c.customer_id;

-- Task 8: Extract Top 3 Customers which have Delayed Flights
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS 'Full_name',t.price,a.airport_name
FROM customers AS c
INNER JOIN tickets AS t
	ON c.customer_id = t.customer_id
INNER JOIN flights AS f
	ON t.flight_id = f.flight_id
INNER JOIN airports AS a
	ON f.destination_airport_id = a.airport_id
WHERE f.`status` = 'Delayed'
ORDER BY t.price DESC, c.customer_id
LIMIT 3;

-- Task 9: Extract the Last 5 Flights, which are departing.
SELECT f.flight_id, f.departure_time, f.arrival_time, a.airport_name,ap.airport_name
FROM airports AS a
INNER JOIN flights AS f
	ON a.airport_id = f.origin_airport_id
INNER JOIN airports AS ap
	ON f.destination_airport_id = ap.airport_id
WHERE f.`status` = 'Departing'
ORDER BY f.departure_time, f.flight_id
LIMIT 5;

-- Task 10: Extract all Customers below 21 years, which have already flew at least once
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS 'Full_name', 2016 - YEAR(c.date_of_birth) AS 'age'
FROM customers AS c
INNER JOIN tickets AS t
	ON c.customer_id = t.customer_id
INNER JOIN flights AS f
	ON t.flight_id = f.flight_id
WHERE f.`status` = 'Arrived' AND 2016 - YEAR(c.date_of_birth) < 21
ORDER BY age DESC, c.customer_id;

-- Task 11: Extract all Airports and the Count of People departing from them
SELECT a.airport_id, a.airport_name, COUNT(t.ticket_id)
FROM tickets AS t
INNER JOIN flights AS f
	ON t.flight_id = f.flight_id
INNER JOIN airports AS a
	ON f.origin_airport_id = a.airport_id
WHERE f.`status` = 'Departing'
GROUP BY a.airport_id, a.airport_name
HAVING COUNT(t.ticket_id) > 0
ORDER BY a.airport_id;

-- Section 4: Programmability
-- Task 1: Review Registering Procedure
DELIMITER $$
CREATE PROCEDURE usp_submit_review(customer_id INT, 
												review_content VARCHAR(255), 
												review_grade ENUM('0','1','2','3','4','5','6','7','8','9','10'), 
												airline_name VARCHAR(30))
BEGIN
	
	DECLARE new_review_id INT;
	DECLARE wanted_airline_id INT;
	
	SET new_review_id = (SELECT COUNT(*) FROM customer_reviews) + 1;		
	SET wanted_airline_id = (SELECT al.airline_id
									FROM airlines AS al
									WHERE al.airline_name = airline_name);
	
	START TRANSACTION;
								
	INSERT INTO customer_reviews(review_id, customer_id, review_content, review_grade, airline_id)
	VALUES(new_review_id,
			customer_id,
			review_content,
			review_grade,
			wanted_airline_id);		
	
	IF wanted_airline_id IS NULL THEN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET Message_Text = 'Airline does not exist.';
	ELSE
		COMMIT;
	END IF;		
END $$

DELIMITER ;;

CALL usp_submit_review(2, 'Greate Fly', '7', 'Sofia Air');
CALL usp_submit_review(2, 'Greate Fly', '7', 'Chuchuligovo');

-- Task 2: Ticket Purchase Procedure
DELIMITER $$
CREATE PROCEDURE usp_purchase_ticket(customer_id INT, flight_id INT, ticket_price DECIMAL(8,2), class ENUM('First','Second','Third'), seat VARCHAR(5))
BEGIN
	DECLARE new_ticket_id INT;
	DECLARE new_customer_balance DECIMAL(10,2);
	
	SET new_ticket_id = (SELECT COUNT(*) FROM tickets) + 1;	
	SET new_customer_balance = (SELECT cba.balance 
											FROM customer_bank_accounts AS cba
											WHERE cba.customer_id = customer_id) - ticket_price;
											
	START TRANSACTION;
	
	INSERT INTO tickets (ticket_id, customer_id, flight_id, price, class, seat)
	VALUES (new_ticket_id, customer_id, flight_id, ticket_price, class, seat);
		
	UPDATE customer_bank_accounts AS cba
	SET balance = new_customer_balance
	WHERE cba.customer_id = customer_id;
	
	IF (new_customer_balance < 0) THEN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET Message_Text = 'Insufficient bank account balance for ticket purchase.';
	ELSE
		COMMIT;
	END IF;
	
END $$

DELIMITER ;;

CALL usp_purchase_ticket(1, 3, 1666.75, 'First', '201-R');
CALL usp_purchase_ticket(1, 3, 20000, 'First', '98-O');

-- Section 5 (BONUS): Update Trigger
CREATE TABLE arrived_flights(
	flight_id INT PRIMARY KEY,
	arrival_time DATETIME NOT NULL,
	origin VARCHAR(50) NOT NULL,
	destination VARCHAR(50) NOT NULL,
	passengers INT NOT NULL
);

DELIMITER $$
CREATE TRIGGER tr_arrived_flights_update
AFTER UPDATE
ON flights
FOR EACH ROW
BEGIN
	DECLARE origin_airport VARCHAR(50);
	SET origin_airport = (SELECT origin_airport_id
									FROM old.origin_airport_id)
	
	INSERT INTO arrived_flights (flight_id, arrival_time, origin, destination, passengers)
	VALUES(old.flight_id, old.arrival_time, origin_airport, );
END $$


















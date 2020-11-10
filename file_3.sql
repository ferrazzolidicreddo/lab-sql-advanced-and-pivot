USE sakila;

# Select the first name, last name, and email address of all the customers who have rented a movie.

# Overview
SELECT * FROM sakila.rental;

SELECT first_name AS First_name, last_name AS Last_name, email as Email FROM sakila.customer;

# Solution
SELECT DISTINCT c.customer_id AS Customer,
				c.first_name AS First_name,
				c.last_name AS Last_name,
                c.email as Email
FROM sakila.customer AS c
JOIN sakila.rental as r
ON c.customer_id = r.customer_id;


# What is the average payment made by each customer (display the customer id, customer name (concatenated),
# and the average payment made).

# Testing
SELECT DISTINCT c.customer_id AS Customer,
				CONCAT(c.first_name,' ', c.last_name) AS Full_name,
                c.email as Email,
                AVG(p.amount) AS Average_Payment
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.payment AS p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

# Solution
SELECT DISTINCT c.customer_id AS Customer,
				CONCAT(c.first_name,' ', c.last_name) AS Full_name,
                c.email as Email,
                AVG(p.amount) AS Average_Payment
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.payment AS p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.customer_id;

# Select the name and email address of all the customers who have rented the "Action" movies.

#Testing
SELECT * FROM sakila.rental;
SELECT * FROM sakila.inventory;
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.category;


SELECT CONCAT(c.first_name,' ', c.last_name) AS Full_name,
		c.email AS Email
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
JOIN sakila.film_category as fc
ON i.film_id = fc.film_id AND fc.film_id = 1;

SELECT fc.film_id, i.inventory_id, c.customer_id, fc.category_id, count(fc.category_id) as Count, CONCAT(c.first_name,' ', c.last_name) AS Full_name,
		c.email AS Email
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
JOIN sakila.film_category as fc
ON i.film_id = fc.film_id
GROUP BY fc.category_id;

# Solution 1
SELECT fc.film_id, i.inventory_id, c.customer_id, fc.category_id, count(fc.category_id) as Count, CONCAT(c.first_name,' ', c.last_name) AS Full_name,
		c.email AS Email
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
JOIN sakila.film_category as fc
ON i.film_id = fc.film_id
WHERE fc.category_id = 1
GROUP BY c.customer_id;


# Solution 2
# Query 1
DROP VIEW View_1;

CREATE VIEW View_1 AS (SELECT * FROM (SELECT customer_id AS Customer, CONCAT(first_name,' ', last_name) AS Full_name,
		email AS Email FROM sakila.customer as c) AS al1);
        
SELECT * FROM View_1
JOIN sakila.inventory AS i
ON c.customer_id = i.customer_id;

SELECT fc.film_id, i.inventory_id, c.customer_id, fc.category_id, count(fc.category_id) as Count, CONCAT(c.first_name,' ', c.last_name) AS Full_name,
		c.email AS Email
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
JOIN sakila.film_category as fc
ON i.film_id = fc.film_id
WHERE fc.category_id = 1
GROUP BY c.customer_id;

------

# Use the case statement to create a new column classifying existing columns as either or high
# value transactions based on the amount of payment. If the amount is between 0 and 2, label should
# be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4,
# then it should be high.

CREATE VIEW View_1 AS (
SELECT DISTINCT c.customer_id AS Customer,
				CONCAT(c.first_name,' ', c.last_name) AS Full_name,
                c.email as Email,
                AVG(p.amount) AS Average_Payment
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
JOIN sakila.payment AS p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.customer_id);

#Solution
SELECT *,
CASE
	WHEN amount <=2 THEN 'LOW'
    WHEN (amount >2 AND amount <=4) THEN 'MEDIUM'
    ELSE 'HIGH'
END AS 'Classification'
FROM sakila.payment;

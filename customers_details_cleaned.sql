--1. Create aa database.
-- CREATE DATABASE ecommerce_dataset;

-- 2. Create table.
-- Create table Customers_Details(
-- customer_id TEXT,
-- CUSTOMER_NAME TEXT,
-- EMAIL TEXT,
-- PHONE TEXT,
-- CITY TEXT,
-- SIGNUP_DATE DATE
-- );

-- 3. Import the Row data in csv formet.
-- ?

-- 4. Remove Duplicate data in Customer_Id 
-- DELETE FROM customers_details
-- WHERE ctid NOT IN (
--     SELECT MIN(ctid)
--     FROM customers_details
--     GROUP BY customer_id
-- );

-- 5. Make primary key 
-- ALTER TABLE customers_details
-- ADD CONSTRAINT Customers_Id primary key(customer_id);

-- 6. To capitalize the Customer Name
-- Question 1. How can we check whether the customer_name column contains any numeric characters (0–9) along with alphabets using SQL?
-- SELECT *
-- FROM Customers_Details
-- WHERE customer_name ~ '[0-9]';

-- Question 2. How can we change the data type of the customer_name column from TEXT to VARCHAR(100) in SQL?
-- ALTER TABLE customers_details
-- ALTER column CUSTOMER_NAME TYPE VARCHAR(100);

-- Question 3. How can we use TRIM, INITCAP, and REGEXP_REPLACE together in SQL to clean, format, and capitalize text data?
-- UPDATE customers_details
-- SET customer_name=INITCAP(TRIM(REGEXP_REPLACE(customer_name,'\s',' ','g')));

-- Question 4. How can we clean and format the email column using TRIM, REGEXP_REPLACE, and INITCAP in SQL?
-- UPDATE customers_details SET email=INITCAP(TRIM(REGEXP_REPLACE(email,'\s',' ','g')));

-- Question 5. How can we update the table to replace invalid or unwanted email values with NULL in SQL?
-- UPDATE customers_details
-- SET email=NULL
-- WHERE email='Invalid_Email';

-- Question 6. How can we set a specific incorrect email value to NULL using an UPDATE statement?
-- UPDATE customers_details
-- SET email=NULL
-- WHERE email='Parkermichael@Gmail.Com';

-- Question 7. How can we identify duplicate email values in a table using GROUP BY and HAVING in SQL?
-- SELECT email, COUNT(*) FROM customers_details
-- GROUP BY email
-- HAVING COUNT(*)>1;

-- Question 8. How can we change the data type of the email column to VARCHAR(100) and add a UNIQUE constraint in PostgreSQL?
-- ALTER TABLE customers_details
-- ALTER column EMAIL TYPE VARCHAR(100),
-- ADD CONSTRAINT EMAIL_ID UNIQUE (EMAIL);

-- Question 9: How can we check whether email values follow a valid email format?
-- SELECT email
-- FROM customers_details
-- WHERE email IS NOT NULL
-- AND email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- Question 10. How can we change the data type of the phone column to VARCHAR(20) in PostgreSQL?
-- ALTER TABLE customers_details
-- ALTER COLUMN Phone TYPE VARCHAR(20);

-- Question 11. How can we rename the phone column to phone_number in a table using SQL?
-- ALTER TABLE customers_details
-- RENAME COLUMN phone TO Phone_number;

-- Question 12. How can we add a UNIQUE constraint to the phone_number column in PostgreSQL?
-- ALTER TABLE customers_details
-- ADD CONSTRAINT Phone_number UNIQUE (phone_number);

-- Question 13. How can we delete records where the phone number length is less than 10 digits using SQL?
-- DELETE FROM Customers_Details
-- WHERE LENGTH(Phone_number)<10;

-- Question 14: How can we clean phone numbers by removing extra spaces and formatting them?
-- UPDATE customers_details
-- SET phone_number = TRIM(REGEXP_REPLACE(phone_number, '\s', '', 'g'))
-- WHERE phone_number IS NOT NULL;

-- Question 15. How can we delete records where both phone_number and email are NULL in SQL?
-- DELETE FROM Customers_Details
-- WHERE Phone_number IS NULL AND EMAIL IS NULL;

-- Question 16. How can we change the data type of the city column to VARCHAR(50) in PostgreSQL?
-- ALTER TABLE customers_details
-- ALTER COLUMN CITY TYPE VARCHAR(50);

-- Question 17: Clean and standardize city names
-- UPDATE customers_details
-- SET city = INITCAP(TRIM(REGEXP_REPLACE(city, '\s', ' ', 'g')));

-- -- Standardize Bangalore spelling
-- UPDATE customers_details
-- SET city = 'Bangalore'
-- WHERE LOWER(city) IN ('banglore', 'bangaluru', 'bengaluru');

-- Question 18. How can we delete records where the signup_date value is NULL in SQL?
-- DELETE FROM Customers_Details
-- WHERE SIGNUP_DATE IS NULL;

-- Check for future signup dates
-- SELECT * FROM customers_details
-- WHERE signup_date > CURRENT_DATE;

-- Optionally, update or delete future dates
-- DELETE FROM customers_details
-- WHERE signup_date > CURRENT_DATE;

-- Add NOT NULL constraints to critical columns
-- ALTER TABLE customers_details
-- ALTER COLUMN customer_name SET NOT NULL,
-- ALTER COLUMN signup_date SET NOT NULL,
-- ALTER COLUMN city SET NOT NULL;

-- Final verification query
-- SELECT 
--     COUNT(*) as total_records,
--     COUNT(DISTINCT customer_id) as unique_customers,
--     COUNT(email) as emails_provided,
--     COUNT(phone_number) as phones_provided,
--     COUNT(CASE WHEN email IS NULL AND phone_number IS NULL THEN 1 END) as missing_contact_info,
--     MIN(signup_date) as earliest_signup,
--     MAX(signup_date) as latest_signup
-- FROM customers_details;


-- COPY customers_details
-- TO 'D:\STUDAY MATERIAL\Data Analytcs\SQL Practices\Clean Data\customers_details_cleaned.csv'
-- DELIMITER ','
-- CSV HEADER;



-- commit;




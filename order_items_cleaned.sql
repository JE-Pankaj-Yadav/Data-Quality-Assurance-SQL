-- ============================================================
-- Project : Order Items Data Cleaning & Validation
-- Role    : Data Analyst
-- Standard: MNC Production Level
-- Database: PostgreSQL
-- ============================================================

BEGIN;

---------------------------------------------------------------
-- 1. TABLE CREATION (IF NOT EXISTS)
---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
    order_id    INT,
    product_id  INT,
    quantity    INT,
    price       NUMERIC(10,2)
);

---------------------------------------------------------------
-- 2. REMOVE INVALID RECORDS
-- Quantity and Price must be greater than 0
---------------------------------------------------------------
DELETE FROM order_items
WHERE quantity IS NULL
   OR price IS NULL
   OR quantity <= 0
   OR price <= 0;

---------------------------------------------------------------
-- 3. REMOVE DUPLICATE RECORDS
-- Keeping only one unique combination
---------------------------------------------------------------
DELETE FROM order_items a
USING order_items b
WHERE a.ctid > b.ctid
  AND a.order_id = b.order_id
  AND a.product_id = b.product_id;

---------------------------------------------------------------
-- 4. DATA TYPE STANDARDIZATION
---------------------------------------------------------------
ALTER TABLE order_items
ALTER COLUMN order_id   TYPE INT USING order_id::INT,
ALTER COLUMN product_id TYPE INT USING product_id::INT,
ALTER COLUMN quantity   TYPE INT USING quantity::INT,
ALTER COLUMN price      TYPE NUMERIC(10,2) USING price::NUMERIC;

---------------------------------------------------------------
-- 5. APPLY CONSTRAINTS
---------------------------------------------------------------
ALTER TABLE order_items
ADD CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id);

---------------------------------------------------------------
-- 6. FINAL DATA VALIDATION CHECKS
---------------------------------------------------------------
-- Records with invalid quantity or price
SELECT *
FROM order_items
WHERE quantity <= 0 OR price <= 0;

---------------------------------------------------------------
-- 7. FINAL CLEAN DATA VIEW
---------------------------------------------------------------
SELECT *
FROM order_items
ORDER BY order_id, product_id;

COMMIT;

-- ============================================================
-- End of Script
-- ============================================================

-- 8. How can we export the cleaned table to a CSV file?
COPY order_items
TO 'D:/order_items_cleaned.csv'
DELIMITER ','
CSV HEADER;

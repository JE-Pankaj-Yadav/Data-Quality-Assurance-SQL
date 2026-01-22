-- ============================================================
-- Project : Order Data - Cleaning & Validation
-- Role    : Data Analyst
-- Standard: MNC Production Level
-- Database: PostgreSQL
-- ============================================================

BEGIN;

---------------------------------------------------------------
-- 1. CREATE TABLE (RAW STRUCTURE)
---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_data (
    order_id      VARCHAR(100),
    customer_id   VARCHAR(100),
    order_date    VARCHAR(100),
    order_status  VARCHAR(100),
    total_amount  VARCHAR(100),
    discount      VARCHAR(100)
);

---------------------------------------------------------------
-- 2. REMOVE RECORDS WITH CRITICAL NULLS
---------------------------------------------------------------
DELETE FROM order_data
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR total_amount IS NULL;

---------------------------------------------------------------
-- 3. STANDARDIZE TEXT (SAFE TRIM)
---------------------------------------------------------------
UPDATE order_data
SET
    order_id     = TRIM(order_id),
    customer_id  = TRIM(customer_id),
    order_status = INITCAP(TRIM(REGEXP_REPLACE(order_status, '\s+', ' ', 'g')));

---------------------------------------------------------------
-- 4. REMOVE DUPLICATE ORDERS
---------------------------------------------------------------
DELETE FROM order_data a
USING order_data b
WHERE a.ctid > b.ctid
  AND a.order_id = b.order_id;

---------------------------------------------------------------
-- 5. DATA TYPE CONVERSION (SAFE CAST)
---------------------------------------------------------------
ALTER TABLE order_data
ALTER COLUMN total_amount TYPE NUMERIC(10,2) USING total_amount::NUMERIC,
ALTER COLUMN discount     TYPE NUMERIC(10,2) USING COALESCE(discount,'0')::NUMERIC,
ALTER COLUMN order_date   TYPE DATE USING order_date::DATE;

---------------------------------------------------------------
-- 6. REMOVE INVALID NUMERIC VALUES
---------------------------------------------------------------
DELETE FROM order_data
WHERE total_amount <= 0
   OR discount < 0;

---------------------------------------------------------------
-- 7. REMOVE FUTURE-DATED ORDERS
---------------------------------------------------------------
DELETE FROM order_data
WHERE order_date > CURRENT_DATE;

---------------------------------------------------------------
-- 8. APPLY CONSTRAINTS
---------------------------------------------------------------
ALTER TABLE order_data
ADD CONSTRAINT pk_order_data PRIMARY KEY (order_id),
ADD CONSTRAINT chk_total_amount CHECK (total_amount > 0),
ADD CONSTRAINT chk_discount CHECK (discount >= 0);

---------------------------------------------------------------
-- 9. CLEAN ORPHAN CUSTOMER RECORDS
---------------------------------------------------------------
DELETE FROM order_data od
WHERE NOT EXISTS (
    SELECT 1
    FROM customers_details cd
    WHERE cd.customer_id = od.customer_id
);

---------------------------------------------------------------
-- 10. APPLY FOREIGN KEY
---------------------------------------------------------------
ALTER TABLE order_data
ADD CONSTRAINT fk_order_customer
FOREIGN KEY (customer_id)
REFERENCES customers_details(customer_id);

---------------------------------------------------------------
-- 11. FINAL VALIDATION VIEW
---------------------------------------------------------------
SELECT *
FROM order_data
ORDER BY order_date DESC;

COMMIT;

-- ============================================================
-- End of Script
-- ============================================================

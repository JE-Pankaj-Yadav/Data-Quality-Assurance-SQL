-- ============================================================
-- Project : Products Details - Data Cleaning & Validation
-- Role    : Data Analyst
-- Standard: MNC Production Level
-- Database: PostgreSQL
-- ============================================================

BEGIN;

---------------------------------------------------------------
-- 1. CREATE TABLE (SAFE & IDEMPOTENT)
---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products_details (
    product_id     INT,
    product_name   VARCHAR(100),
    category       VARCHAR(100),
    cost_price     NUMERIC(10,2),
    selling_price  NUMERIC(10,2)
);

---------------------------------------------------------------
-- 2. REMOVE INVALID / INCOMPLETE RECORDS
---------------------------------------------------------------
DELETE FROM products_details
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR cost_price IS NULL
   OR selling_price IS NULL
   OR cost_price <= 0
   OR selling_price <= 0
   OR selling_price < cost_price;   -- Business rule

---------------------------------------------------------------
-- 3. REMOVE DUPLICATE PRODUCTS
-- Keeping one record per product_id
---------------------------------------------------------------
DELETE FROM products_details a
USING products_details b
WHERE a.ctid > b.ctid
  AND a.product_id = b.product_id;

---------------------------------------------------------------
-- 4. STANDARDIZE TEXT COLUMNS
---------------------------------------------------------------
UPDATE products_details
SET
    product_name = INITCAP(TRIM(REGEXP_REPLACE(product_name, '\s+', ' ', 'g'))),
    category     = INITCAP(TRIM(REGEXP_REPLACE(category, '\s+', ' ', 'g')));

---------------------------------------------------------------
-- 5. DATA TYPE STANDARDIZATION (SAFE CAST)
---------------------------------------------------------------
ALTER TABLE products_details
ALTER COLUMN product_id TYPE INT USING product_id::INT,
ALTER COLUMN cost_price TYPE NUMERIC(10,2) USING cost_price::NUMERIC,
ALTER COLUMN selling_price TYPE NUMERIC(10,2) USING selling_price::NUMERIC;

---------------------------------------------------------------
-- 6. APPLY PRIMARY KEY
---------------------------------------------------------------
ALTER TABLE products_details
ADD CONSTRAINT pk_products PRIMARY KEY (product_id);

---------------------------------------------------------------
-- 7. REFERENTIAL INTEGRITY CHECKS
---------------------------------------------------------------
-- Orders having product_id not present in products table
SELECT COUNT(*) AS invalid_order_items
FROM order_items
WHERE product_id NOT IN (SELECT product_id FROM products_details);

---------------------------------------------------------------
-- 8. CLEAN ORDER_ITEMS DATA BEFORE FK
---------------------------------------------------------------
DELETE FROM order_items
WHERE product_id NOT IN (SELECT product_id FROM products_details);

---------------------------------------------------------------
-- 9. APPLY FOREIGN KEY CONSTRAINT
---------------------------------------------------------------
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES products_details(product_id);

---------------------------------------------------------------
-- 10. FINAL CLEAN DATA VIEW
---------------------------------------------------------------
SELECT *
FROM products_details
ORDER BY product_id;

COMMIT;

-- ============================================================
-- End of Script
-- ============================================================

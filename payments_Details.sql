-- ============================================================
-- Project : Payments Details - Data Cleaning & Validation
-- Role    : Data Analyst
-- Standard: MNC / Production Level
-- Database: PostgreSQL
-- ============================================================

BEGIN;

---------------------------------------------------------------
-- 1. CREATE TABLE (SAFE & IDEMPOTENT)
---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments_details (
    payment_id     INT,
    order_id       INT,
    payment_mode   VARCHAR(50),
    payment_status VARCHAR(20),
    payment_date   DATE
);

---------------------------------------------------------------
-- 2. REMOVE INVALID / INCOMPLETE RECORDS
---------------------------------------------------------------
DELETE FROM payments_details
WHERE payment_id IS NULL
   OR order_id IS NULL
   OR payment_mode IS NULL
   OR payment_status IS NULL
   OR payment_date IS NULL;

---------------------------------------------------------------
-- 3. STANDARDIZE PAYMENT MODE VALUES
---------------------------------------------------------------
UPDATE payments_details
SET payment_mode = UPPER(TRIM(payment_mode));

---------------------------------------------------------------
-- 4. STANDARDIZE PAYMENT STATUS VALUES
---------------------------------------------------------------
UPDATE payments_details
SET payment_status = UPPER(TRIM(payment_status));

---------------------------------------------------------------
-- 5. REMOVE INVALID PAYMENT STATUS
---------------------------------------------------------------
DELETE FROM payments_details
WHERE payment_status NOT IN ('SUCCESS', 'FAILED', 'PENDING');

---------------------------------------------------------------
-- 6. REMOVE DUPLICATE PAYMENTS
-- Keeping latest record per payment_id
---------------------------------------------------------------
DELETE FROM payments_details a
USING payments_details b
WHERE a.ctid > b.ctid
  AND a.payment_id = b.payment_id;

---------------------------------------------------------------
-- 7. APPLY DATA TYPES SAFELY
---------------------------------------------------------------
ALTER TABLE payments_details
ALTER COLUMN payment_id TYPE INT USING payment_id::INT,
ALTER COLUMN order_id   TYPE INT USING order_id::INT,
ALTER COLUMN payment_date TYPE DATE USING payment_date::DATE;

---------------------------------------------------------------
-- 8. APPLY CONSTRAINTS (DATA GOVERNANCE)
---------------------------------------------------------------
ALTER TABLE payments_details
ADD CONSTRAINT pk_payments PRIMARY KEY (payment_id);

---------------------------------------------------------------
-- 9. FINAL VALIDATION CHECKS
---------------------------------------------------------------
-- Invalid status check
SELECT *
FROM payments_details
WHERE payment_status NOT IN ('SUCCESS', 'FAILED', 'PENDING');

---------------------------------------------------------------
-- 10. CLEAN DATA VIEW
---------------------------------------------------------------
SELECT *
FROM payments_details
ORDER BY payment_date DESC;

COMMIT;

-- ============================================================
-- End of Script
-- ============================================================

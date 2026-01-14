-- ============================================================================
-- SQL DATABASE BASICS & CONSTRAINTS - BEGINNER'S GUIDE
-- ============================================================================

-- ============================================================================
-- SECTION 1: UNDERSTANDING DATABASES AND TABLES
-- ============================================================================

/*
WHAT IS A DATABASE?
- A structured collection of data
- Organized into tables (like Excel spreadsheets)
- Tables have rows (records) and columns (fields)
- Databases enforce rules to keep data consistent and accurate

WHAT IS A TABLE?
- A collection of related data organized in rows and columns
- Each column has a name and data type
- Each row represents one record/entity

EXAMPLE TABLE STRUCTURE:
    employees
    ┌────────┬──────────┬─────────┬────────────┐
    │ emp_id │   name   │  salary │  dept_id   │
    ├────────┼──────────┼─────────┼────────────┤
    │   1    │  Alice   │  50000  │     10     │
    │   2    │  Bob     │  60000  │     20     │
    └────────┴──────────┴─────────┴────────────┘
    
    - emp_id, name, salary, dept_id = COLUMNS (fields)
    - Each row = one employee (RECORD)
*/


-- ============================================================================
-- SECTION 2: DATA TYPES
-- ============================================================================

/*
DATA TYPES define what kind of data a column can store

COMMON DATA TYPES:

NUMERIC TYPES:
    INT, INTEGER        - Whole numbers (-2147483648 to 2147483647)
    SMALLINT           - Small whole numbers (-32768 to 32767)
    BIGINT             - Large whole numbers
    DECIMAL(p,s)       - Exact decimal numbers (p=precision, s=scale)
    NUMERIC(p,s)       - Same as DECIMAL
    FLOAT, REAL        - Approximate decimal numbers
    
    Examples:
    age INT              → 25, 30, 45
    price DECIMAL(10,2)  → 99.99, 1234.50 (10 total digits, 2 after decimal)

TEXT/STRING TYPES:
    CHAR(n)            - Fixed length string (always n characters)
    VARCHAR(n)         - Variable length string (up to n characters)
    TEXT               - Long text (unlimited or very large)
    
    Examples:
    country_code CHAR(2)      → 'US', 'UK' (always 2 characters)
    name VARCHAR(100)         → 'Alice', 'Bob' (up to 100 characters)
    description TEXT          → Long product descriptions

DATE/TIME TYPES:
    DATE               - Date only (YYYY-MM-DD)
    TIME               - Time only (HH:MM:SS)
    DATETIME           - Date and time together
    TIMESTAMP          - Date and time with timezone
    
    Examples:
    birth_date DATE           → '1990-05-15'
    created_at TIMESTAMP      → '2024-01-15 14:30:00'

BOOLEAN TYPE:
    BOOLEAN, BOOL      - True or False values
    
    Examples:
    is_active BOOLEAN         → TRUE, FALSE

OTHER TYPES:
    JSON               - Store JSON data
    BLOB               - Binary large objects (images, files)
*/


-- ============================================================================
-- SECTION 3: CREATING TABLES (CREATE TABLE)
-- ============================================================================

/*
CREATE TABLE statement creates a new table

BASIC SYNTAX:
    CREATE TABLE table_name (
        column1 datatype,
        column2 datatype,
        column3 datatype,
        ...
    );
*/

-- ----------------------------------------------------------------------------
-- 3.1 Simple Table Creation
-- ----------------------------------------------------------------------------

-- Create a basic employees table:
CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    hire_date DATE,
    is_active BOOLEAN
);

/*
This creates a table with 5 columns:
- emp_id: stores integers (employee ID)
- name: stores text up to 100 characters
- salary: stores numbers with 2 decimal places
- hire_date: stores dates
- is_active: stores true/false values
*/


-- ----------------------------------------------------------------------------
-- 3.2 Table with Constraints (Better Practice)
-- ----------------------------------------------------------------------------

/*
CONSTRAINTS: Rules that enforce data integrity

COMMON CONSTRAINTS:
    PRIMARY KEY    - Uniquely identifies each row, cannot be NULL
    NOT NULL       - Column cannot be empty
    UNIQUE         - All values must be different
    DEFAULT        - Provides default value if none specified
    CHECK          - Ensures values meet a condition
    FOREIGN KEY    - Links to another table
*/

-- Create employees table with constraints:
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,           -- Must be unique, cannot be NULL
    name VARCHAR(100) NOT NULL,       -- Cannot be empty
    email VARCHAR(100) UNIQUE,        -- Must be unique across all rows
    salary DECIMAL(10, 2) CHECK (salary > 0),  -- Must be positive
    hire_date DATE DEFAULT CURRENT_DATE,       -- Defaults to today
    is_active BOOLEAN DEFAULT TRUE,            -- Defaults to TRUE
    dept_id INT                        -- Can be NULL
);

/*
EXPLANATION OF EACH CONSTRAINT:

PRIMARY KEY on emp_id:
    - Guarantees each employee has a unique ID
    - Cannot be NULL (empty)
    - Only one PRIMARY KEY per table
    - Automatically creates an index for fast lookups

NOT NULL on name:
    - Every employee MUST have a name
    - INSERT will fail if name is not provided

UNIQUE on email:
    - No two employees can have the same email
    - NULL values are allowed (unless also NOT NULL)

CHECK on salary:
    - Ensures salary is always positive
    - INSERT/UPDATE will fail if salary <= 0

DEFAULT on hire_date:
    - If no hire_date provided, uses today's date
    - Can still manually specify a different date

DEFAULT on is_active:
    - If not specified, defaults to TRUE
    - Can still set to FALSE manually
*/


-- ============================================================================
-- SECTION 4: PRIMARY KEYS IN DETAIL
-- ============================================================================

/*
PRIMARY KEY: The most important constraint

PURPOSE:
- Uniquely identifies each row in the table
- Ensures no duplicate records
- Used to link tables together (relationships)

RULES:
- Only ONE primary key per table
- Cannot contain NULL values
- Must be unique across all rows
- Usually a number (INT) but can be other types
*/

-- ----------------------------------------------------------------------------
-- 4.1 Single Column Primary Key
-- ----------------------------------------------------------------------------

-- Method 1: Inline constraint
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

-- Method 2: Table-level constraint (same result)
CREATE TABLE students (
    student_id INT,
    student_name VARCHAR(100),
    PRIMARY KEY (student_id)
);


-- ----------------------------------------------------------------------------
-- 4.2 Auto-Incrementing Primary Key
-- ----------------------------------------------------------------------------

/*
AUTO_INCREMENT (MySQL) or SERIAL (PostgreSQL):
- Automatically generates unique numbers
- Starts at 1 and increments by 1
- You don't need to specify values when inserting
*/

-- MySQL syntax:
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2)
);

-- PostgreSQL syntax:
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2)
);

-- SQLite syntax:
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2)
);

/*
When inserting, you don't specify product_id:
    INSERT INTO products (product_name, price) VALUES ('Laptop', 999.99);
    
Database automatically assigns product_id = 1

Next insert gets product_id = 2, then 3, etc.
*/


-- ----------------------------------------------------------------------------
-- 4.3 Composite Primary Key (Multiple Columns)
-- ----------------------------------------------------------------------------

/*
COMPOSITE PRIMARY KEY: Combination of two or more columns

USE CASE: When no single column uniquely identifies a row
Example: Student enrollments (student can take multiple courses)
*/

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(2),
    PRIMARY KEY (student_id, course_id)  -- Combination must be unique
);

/*
This means:
- Student 1 can enroll in Course 101: Valid
- Student 1 can enroll in Course 102: Valid
- Student 1 CANNOT enroll in Course 101 again: Invalid (duplicate primary key)
- Student 2 can enroll in Course 101: Valid (different student)

The COMBINATION of student_id + course_id must be unique
*/


-- ============================================================================
-- SECTION 5: OTHER IMPORTANT CONSTRAINTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 5.1 NOT NULL Constraint
-- ----------------------------------------------------------------------------

/*
NOT NULL: Column must have a value (cannot be empty)
*/

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,    -- Required
    last_name VARCHAR(50) NOT NULL,     -- Required
    email VARCHAR(100),                 -- Optional (can be NULL)
    phone VARCHAR(20)                   -- Optional
);

-- This INSERT will work:
INSERT INTO customers (customer_id, first_name, last_name) 
VALUES (1, 'John', 'Doe');

-- This INSERT will FAIL (missing required fields):
-- INSERT INTO customers (customer_id, email) VALUES (2, 'test@email.com');
--                                          ↑ Error: first_name and last_name are NULL


-- ----------------------------------------------------------------------------
-- 5.2 UNIQUE Constraint
-- ----------------------------------------------------------------------------

/*
UNIQUE: All values in the column must be different
Unlike PRIMARY KEY, you can have multiple UNIQUE columns
*/

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,        -- No duplicate usernames
    email VARCHAR(100) UNIQUE,          -- No duplicate emails
    phone VARCHAR(20)
);

-- Multiple ways to define UNIQUE:

-- Method 1: Inline
CREATE TABLE example1 (
    id INT PRIMARY KEY,
    code VARCHAR(10) UNIQUE
);

-- Method 2: Table-level (can name the constraint)
CREATE TABLE example2 (
    id INT PRIMARY KEY,
    code VARCHAR(10),
    CONSTRAINT unique_code UNIQUE (code)
);

-- Method 3: Composite UNIQUE (combination must be unique)
CREATE TABLE example3 (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    UNIQUE (first_name, last_name)  -- Same name combination not allowed
);


-- ----------------------------------------------------------------------------
-- 5.3 DEFAULT Constraint
-- ----------------------------------------------------------------------------

/*
DEFAULT: Provides a value when none is specified
*/

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,           -- Defaults to today
    status VARCHAR(20) DEFAULT 'Pending',           -- Defaults to 'Pending'
    quantity INT DEFAULT 1,                         -- Defaults to 1
    is_shipped BOOLEAN DEFAULT FALSE,               -- Defaults to FALSE
    discount_pct DECIMAL(5,2) DEFAULT 0.00         -- Defaults to 0
);

-- When inserting, can omit columns with defaults:
INSERT INTO orders (order_id) VALUES (1);
-- Result: order_id=1, order_date=today, status='Pending', quantity=1, is_shipped=FALSE

-- Can override defaults:
INSERT INTO orders (order_id, status, quantity) VALUES (2, 'Processing', 5);
-- Result: order_id=2, status='Processing', quantity=5, other fields use defaults


-- ----------------------------------------------------------------------------
-- 5.4 CHECK Constraint
-- ----------------------------------------------------------------------------

/*
CHECK: Ensures values meet a specific condition
*/

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2) CHECK (price > 0),              -- Must be positive
    discount_pct DECIMAL(5, 2) CHECK (discount_pct BETWEEN 0 AND 100),  -- 0-100%
    stock_quantity INT CHECK (stock_quantity >= 0),      -- Cannot be negative
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Food'))
);

-- Valid INSERT:
INSERT INTO products VALUES (1, 'Laptop', 999.99, 10, 50, 'Electronics');

-- Invalid INSERTs (will fail):
-- INSERT INTO products VALUES (2, 'Shirt', -50, 10, 20, 'Clothing');  -- price < 0
-- INSERT INTO products VALUES (3, 'Phone', 500, 150, 30, 'Electronics');  -- discount > 100
-- INSERT INTO products VALUES (4, 'Book', 20, 5, -5, 'Books');  -- stock < 0, invalid category

-- Named CHECK constraints:
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10, 2),
    CONSTRAINT check_age CHECK (age >= 18 AND age <= 65),
    CONSTRAINT check_salary CHECK (salary > 0)
);


-- ----------------------------------------------------------------------------
-- 5.5 FOREIGN KEY Constraint
-- ----------------------------------------------------------------------------

/*
FOREIGN KEY: Links tables together, maintains referential integrity

ENSURES:
- Value must exist in the referenced table
- Prevents orphaned records
- Maintains relationships between tables
*/

-- First, create the parent table (departments):
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- Then create child table with FOREIGN KEY:
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

/*
This ensures:
- Cannot insert employee with dept_id that doesn't exist in departments
- Cannot delete a department that has employees
- Maintains data integrity
*/

-- Valid sequence:
INSERT INTO departments VALUES (10, 'Sales');
INSERT INTO employees VALUES (1, 'Alice', 10);  -- Works (dept 10 exists)

-- Invalid sequence:
-- INSERT INTO employees VALUES (2, 'Bob', 99);  -- Fails (dept 99 doesn't exist)

-- Named FOREIGN KEY:
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);


-- ----------------------------------------------------------------------------
-- 5.6 Foreign Key Actions (ON DELETE, ON UPDATE)
-- ----------------------------------------------------------------------------

/*
Control what happens when parent record is deleted or updated

OPTIONS:
- CASCADE: Automatically delete/update child records
- SET NULL: Set foreign key to NULL
- SET DEFAULT: Set foreign key to default value
- RESTRICT/NO ACTION: Prevent deletion/update if children exist
*/

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON DELETE CASCADE        -- If dept deleted, delete employees too
        ON UPDATE CASCADE        -- If dept_id changes, update employees too
);

-- Alternative example:
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE SET NULL       -- If customer deleted, set customer_id to NULL
        ON UPDATE CASCADE
);


-- ============================================================================
-- SECTION 6: INSERTING DATA (INSERT INTO)
-- ============================================================================

/*
INSERT INTO: Adds new rows to a table

SYNTAX:
    INSERT INTO table_name (column1, column2, ...)
    VALUES (value1, value2, ...);
*/

-- ----------------------------------------------------------------------------
-- 6.1 Basic INSERT
-- ----------------------------------------------------------------------------

-- First, create a table to work with:
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2),
    hire_date DATE,
    dept_id INT
);

-- Insert a single row (specify all columns):
INSERT INTO employees (emp_id, name, salary, hire_date, dept_id)
VALUES (1, 'Alice Johnson', 55000.00, '2023-01-15', 10);

-- Insert a single row (specify only some columns):
INSERT INTO employees (emp_id, name, dept_id)
VALUES (2, 'Bob Smith', 20);
-- salary and hire_date will be NULL

-- Insert without column names (must provide ALL values in order):
INSERT INTO employees
VALUES (3, 'Carol White', 62000.00, '2023-03-10', 10);


-- ----------------------------------------------------------------------------
-- 6.2 Inserting Multiple Rows
-- ----------------------------------------------------------------------------

-- Insert multiple rows in one statement (efficient):
INSERT INTO employees (emp_id, name, salary, hire_date, dept_id)
VALUES 
    (4, 'David Brown', 58000.00, '2023-02-20', 20),
    (5, 'Eve Davis', 61000.00, '2023-04-05', 10),
    (6, 'Frank Miller', 59000.00, '2023-05-12', 30),
    (7, 'Grace Lee', 64000.00, '2023-06-18', 20),
    (8, 'Henry Wilson', 57000.00, '2023-07-22', 30);

/*
BEST PRACTICE:
- Inserting multiple rows at once is much faster than individual INSERTs
- Always specify column names for clarity
- Order matches between column list and VALUES
*/


-- ----------------------------------------------------------------------------
-- 6.3 INSERT with Auto-Increment
-- ----------------------------------------------------------------------------

-- Table with auto-increment primary key:
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,  -- MySQL
    -- product_id SERIAL PRIMARY KEY,           -- PostgreSQL
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Don't specify product_id (it's auto-generated):
INSERT INTO products (product_name, price)
VALUES ('Laptop', 999.99);

INSERT INTO products (product_name, price)
VALUES 
    ('Mouse', 25.99),
    ('Keyboard', 79.99),
    ('Monitor', 299.99);

-- Database automatically assigns: product_id = 1, 2, 3, 4


-- ----------------------------------------------------------------------------
-- 6.4 INSERT with DEFAULT values
-- ----------------------------------------------------------------------------

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- Use DEFAULT keyword:
INSERT INTO orders (order_id, order_date, status)
VALUES (1, DEFAULT, DEFAULT);

-- Or simply omit columns with defaults:
INSERT INTO orders (order_id)
VALUES (2);
-- order_date and status will use their defaults


-- ----------------------------------------------------------------------------
-- 6.5 INSERT from SELECT (Copy data from another table)
-- ----------------------------------------------------------------------------

-- Create a backup table:
CREATE TABLE employees_backup (
    emp_id INT,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

-- Copy data from employees to employees_backup:
INSERT INTO employees_backup (emp_id, name, salary)
SELECT emp_id, name, salary
FROM employees
WHERE dept_id = 10;

-- Copy all employees earning > 60000:
INSERT INTO employees_backup
SELECT emp_id, name, salary
FROM employees
WHERE salary > 60000;


-- ============================================================================
-- SECTION 7: UPDATING DATA (UPDATE)
-- ============================================================================

/*
UPDATE: Modifies existing rows in a table

SYNTAX:
    UPDATE table_name
    SET column1 = value1, column2 = value2, ...
    WHERE condition;

WARNING: Without WHERE, ALL rows will be updated!
*/

-- ----------------------------------------------------------------------------
-- 7.1 Basic UPDATE
-- ----------------------------------------------------------------------------

-- Update a single row (by primary key):
UPDATE employees
SET salary = 60000.00
WHERE emp_id = 2;

-- Update multiple columns:
UPDATE employees
SET salary = 65000.00,
    dept_id = 30
WHERE emp_id = 3;


-- ----------------------------------------------------------------------------
-- 7.2 UPDATE Multiple Rows
-- ----------------------------------------------------------------------------

-- Give 10% raise to all employees in department 10:
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 10;

-- Update all employees hired before 2023-04-01:
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2023-04-01';


-- ----------------------------------------------------------------------------
-- 7.3 UPDATE with Calculations
-- ----------------------------------------------------------------------------

-- Increase salary by 5000:
UPDATE employees
SET salary = salary + 5000
WHERE emp_id = 5;

-- Double the salary for top performers:
UPDATE employees
SET salary = salary * 2
WHERE name IN ('Alice Johnson', 'Eve Davis');


-- ----------------------------------------------------------------------------
-- 7.4 UPDATE with Subquery
-- ----------------------------------------------------------------------------

-- Set salary to department average:
UPDATE employees e
SET salary = (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id
)
WHERE emp_id = 7;


-- ----------------------------------------------------------------------------
-- 7.5 UPDATE All Rows (CAREFUL!)
-- ----------------------------------------------------------------------------

-- Set all employees to active (no WHERE clause):
UPDATE employees
SET is_active = TRUE;

/*
WARNING: This updates EVERY row in the table!
Always double-check before running UPDATE without WHERE
*/


-- ============================================================================
-- SECTION 8: DELETING DATA (DELETE)
-- ============================================================================

/*
DELETE: Removes rows from a table

SYNTAX:
    DELETE FROM table_name
    WHERE condition;

WARNING: Without WHERE, ALL rows will be deleted!
*/

-- ----------------------------------------------------------------------------
-- 8.1 Basic DELETE
-- ----------------------------------------------------------------------------

-- Delete a specific employee:
DELETE FROM employees
WHERE emp_id = 8;

-- Delete multiple employees:
DELETE FROM employees
WHERE dept_id = 30;


-- ----------------------------------------------------------------------------
-- 8.2 DELETE with Complex Conditions
-- ----------------------------------------------------------------------------

-- Delete employees with salary less than 30000:
DELETE FROM employees
WHERE salary < 30000;

-- Delete employees hired before specific date:
DELETE FROM employees
WHERE hire_date < '2023-01-01';

-- Delete using multiple conditions:
DELETE FROM employees
WHERE dept_id = 20 AND salary > 70000;


-- ----------------------------------------------------------------------------
-- 8.3 DELETE with Subquery
-- ----------------------------------------------------------------------------

-- Delete employees from departments with less than 3 employees:
DELETE FROM employees
WHERE dept_id IN (
    SELECT dept_id
    FROM employees
    GROUP BY dept_id
    HAVING COUNT(*) < 3
);


-- ----------------------------------------------------------------------------
-- 8.4 DELETE All Rows
-- ----------------------------------------------------------------------------

-- Delete all rows (structure remains):
DELETE FROM employees;

/*
Alternative: TRUNCATE (faster, but can't undo):
    TRUNCATE TABLE employees;
    
TRUNCATE vs DELETE:
- TRUNCATE: Faster, resets auto-increment, can't have WHERE
- DELETE: Slower, preserves auto-increment, can have WHERE, can rollback
*/


-- ============================================================================
-- SECTION 9: ALTERING TABLES (ALTER TABLE)
-- ============================================================================

/*
ALTER TABLE: Modifies existing table structure

COMMON OPERATIONS:
- ADD COLUMN: Add new columns
- DROP COLUMN: Remove columns
- MODIFY COLUMN: Change column definition
- RENAME COLUMN: Change column name
- ADD/DROP CONSTRAINT: Modify constraints
*/

-- ----------------------------------------------------------------------------
-- 9.1 Adding Columns (ADD COLUMN)
-- ----------------------------------------------------------------------------

-- Add a single column:
ALTER TABLE employees
ADD COLUMN email VARCHAR(100);

-- Add column with constraint:
ALTER TABLE employees
ADD COLUMN phone VARCHAR(20) UNIQUE;

-- Add column with default value:
ALTER TABLE employees
ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- Add multiple columns (some databases):
ALTER TABLE employees
ADD COLUMN bonus DECIMAL(10, 2),
ADD COLUMN title VARCHAR(50);


-- ----------------------------------------------------------------------------
-- 9.2 Dropping Columns (DROP COLUMN)
-- ----------------------------------------------------------------------------

-- Remove a column:
ALTER TABLE employees
DROP COLUMN bonus;

-- Remove multiple columns (some databases):
ALTER TABLE employees
DROP COLUMN email,
DROP COLUMN phone;

/*
WARNING:
- Dropping a column deletes ALL data in that column
- This action is usually irreversible
- Make backups before dropping columns
*/


-- ----------------------------------------------------------------------------
-- 9.3 Modifying Columns (MODIFY/ALTER COLUMN)
-- ----------------------------------------------------------------------------

-- MySQL syntax (MODIFY):
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(150);

-- PostgreSQL syntax (ALTER COLUMN):
ALTER TABLE employees
ALTER COLUMN name TYPE VARCHAR(150);

-- Change column to NOT NULL:
ALTER TABLE employees
ALTER COLUMN email SET NOT NULL;

-- Remove NOT NULL constraint:
ALTER TABLE employees
ALTER COLUMN email DROP NOT NULL;

-- Change default value:
ALTER TABLE employees
ALTER COLUMN is_active SET DEFAULT FALSE;


-- ----------------------------------------------------------------------------
-- 9.4 Renaming Columns
-- ----------------------------------------------------------------------------

-- MySQL/PostgreSQL:
ALTER TABLE employees
RENAME COLUMN emp_name TO full_name;

-- Alternative syntax (some databases):
ALTER TABLE employees
CHANGE emp_name full_name VARCHAR(100);


-- ----------------------------------------------------------------------------
-- 9.5 Adding Constraints
-- ----------------------------------------------------------------------------

-- Add PRIMARY KEY (if table doesn't have one):
ALTER TABLE employees
ADD PRIMARY KEY (emp_id);

-- Add UNIQUE constraint:
ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);

-- Add CHECK constraint:
ALTER TABLE employees
ADD CONSTRAINT check_salary CHECK (salary > 0);

-- Add FOREIGN KEY:
ALTER TABLE employees
ADD CONSTRAINT fk_department 
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Add NOT NULL (different syntax per database):
ALTER TABLE employees
MODIFY COLUMN email VARCHAR(100) NOT NULL;  -- MySQL

ALTER TABLE employees
ALTER COLUMN email SET NOT NULL;  -- PostgreSQL


-- ----------------------------------------------------------------------------
-- 9.6 Dropping Constraints
-- ----------------------------------------------------------------------------

-- Drop named constraint:
ALTER TABLE employees
DROP CONSTRAINT unique_email;

-- Drop FOREIGN KEY:
ALTER TABLE employees
DROP FOREIGN KEY fk_department;  -- MySQL

ALTER TABLE employees
DROP CONSTRAINT fk_department;   -- PostgreSQL

-- Drop PRIMARY KEY:
ALTER TABLE employees
DROP PRIMARY KEY;  -- MySQL

ALTER TABLE employees
DROP CONSTRAINT employees_pkey;  -- PostgreSQL (name varies)


-- ----------------------------------------------------------------------------
-- 9.7 Renaming Tables
-- ----------------------------------------------------------------------------

-- Rename the table itself:
ALTER TABLE employees
RENAME TO staff;

-- Alternative syntax:
RENAME TABLE employees TO staff;


-- ============================================================================
-- SECTION 10: DROPPING TABLES (DROP TABLE)
-- ============================================================================

/*
DROP TABLE: Completely removes a table and ALL its data

WARNING: This is permanent and cannot be undone!
*/

-- Drop a single table:
DROP TABLE employees;

-- Drop table only if it exists (no error if it doesn't):
DROP TABLE IF EXISTS employees;

-- Drop multiple tables:
DROP TABLE employees, departments, products;

/*
DIFFERENCE: DROP vs DELETE vs TRUNCATE

DELETE FROM table:
    - Removes rows, keeps table structure
    - Can use WHERE to delete specific rows
    - Can be rolled back (in transaction)
    - Slower

TRUNCATE TABLE table:
    - Removes all rows, keeps table structure
    - Cannot use WHERE
    - Faster than DELETE
    - Resets auto-increment
    - Cannot be rolled back (usually)

DROP TABLE table:
    - Removes entire table (structure + data)
    - Table no longer exists
    - Cannot be rolled back
    - Must recreate table to use it again
*/


-- ============================================================================
-- SECTION 11: PRACTICAL EXAMPLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 11.1 Complete Database Setup Example
-- ----------------------------------------------------------------------------

-- Step 1: Create departments table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- Step 2: Insert departments
INSERT INTO departments (dept_id, dept_name, location)
VALUES 
    (10, 'Sales', 'New York'),
    (20, 'Engineering', 'San Francisco'),
    (30, 'Marketing', 'Chicago'),
    (40, 'HR', 'New York');

-- Step 3: Create employees table with foreign key
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    hire_date DATE DEFAULT CURRENT_DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Step 4: Insert employees
INSERT INTO employees (first_name, last_name, email, salary, hire_date, dept_id)
VALUES 
    ('Alice', 'Johnson', 'alice@company.com', 75000, '2022-01-15', 20),
    ('Bob', 'Smith', 'bob@company.com', 65000, '2022-03-20', 10),
    ('Carol', 'Williams', 'carol@company.com', 70000, '2022-05-10', 20),
    ('David', 'Brown', 'david@company.com', 60000, '2023-01-08', 30),
    ('Eve', 'Davis', 'eve@company.com', 68000, '2023-02-14', 10);


-- ----------------------------------------------------------------------------
-- 11.2 Common Modifications
-- ----------------------------------------------------------------------------

-- Give raises to engineering department:
UPDATE employees
SET salary = salary * 1.15
WHERE dept_id = 20;

-- Add phone column:
ALTER TABLE employees
ADD COLUMN phone VARCHAR(20);

-- Update specific employee phone:
UPDATE employees
SET phone = '555-1234'
WHERE emp_id = 1;

-- Remove employees who left:
DELETE FROM employees
WHERE hire_date < '2022-06-01' AND dept_id = 30;

-- Add manager column:
ALTER TABLE employees
ADD COLUMN manager_id INT,
ADD FOREIGN KEY (manager_id) REFERENCES employees(emp_id);


-- ----------------------------------------------------------------------------
-- 11.3 Table Restructuring Example
-- ----------------------------------------------------------------------------

-- Create backup before major changes:
CREATE TABLE employees_backup AS
SELECT * FROM employees;

-- Add new column:
ALTER TABLE employees
ADD COLUMN full_name VARCHAR(100);

-- Populate from existing data:
UPDATE employees
SET full_name = CONCAT(first_name, ' ', last_name);

-- If satisfied, can drop old columns:
-- ALTER TABLE employees
-- DROP COLUMN first_name,
-- DROP COLUMN last_name;


-- ============================================================================
-- SECTION 12: BEST PRACTICES
-- ============================================================================

/*
TABLE DESIGN:
✓ Always use PRIMARY KEY
✓ Use AUTO_INCREMENT for numeric primary keys
✓ Add NOT NULL where appropriate
✓ Use UNIQUE for columns that shouldn't duplicate
✓ Add CHECK constraints for data validation
✓ Use FOREIGN KEYS to maintain relationships
✓ Choose appropriate data types (don't use VARCHAR(1000) if VARCHAR(50) is enough)

INSERTING DATA:
✓ Always specify column names in INSERT
✓ Use multi-row INSERT for better performance
✓ Validate data before inserting
✓ Use transactions for multiple related inserts

UPDATING DATA:
✓ ALWAYS use WHERE clause (unless intentionally updating all rows)
✓ Test UPDATE with SELECT first to see what will be affected
✓ Back up data before major updates
✓ Use transactions for important updates

DELETING DATA:
✓ ALWAYS use WHERE clause (unless intentionally deleting all rows)
✓ Test DELETE with SELECT first
✓ Consider soft deletes (is_deleted flag) instead of hard deletes
✓ Back up before major deletions

ALTERING TABLES:
✓ Back up data before ALTER TABLE
✓ Test on development database first
✓ Be aware of table locks during ALTER
✓ Some operations can't be rolled back

NAMING CONVENTIONS:
✓ Use lowercase with underscores: employee_id (not EmployeeID)
✓ Be consistent across your database
✓ Use singular names for tables: employee (not employees) - debatable
✓ Primary keys: table_name_id (e.g., employee_id)
✓ Foreign keys: referenced_table_id (e.g., department_id)
*/

-- =============================================================================
-- SQL PRACTICE QUESTIONS - DATABASE BASICS & CONSTRAINTS
-- =============================================================================
/*
1. Create a table with a PRIMARY KEY constraint
2. Insert 5 rows into the table using INSERT INTO
3. Update a specific row using WHERE to target it
4. Delete rows based on a condition using DELETE FROM ... WHERE
5. Add a new column to an existing table using ALTER TABLE ... ADD COLUMN
*/

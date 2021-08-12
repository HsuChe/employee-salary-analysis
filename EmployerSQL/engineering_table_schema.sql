-- Create the Table Columns
-- first table departments
CREATE TABLE departments(
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL
);

-- Copy row information from the csv
COPY departments (dept_no,dept_name)
-- Can use any directory with access permission
FROM 'C:\Users\Public\Documents\data\departments.csv'
DELIMITER ','
CSV HEADER;

--NEXT TABLE dept_emp

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL
);

COPY dept_emp (emp_no,dept_no)
FROM 'C:\Users\Public\Documents\data\dept_emp.csv'
DELIMITER ','
CSV HEADER;

--NEXT TABLE dept_manager

CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL
);

COPY dept_manager (dept_no,emp_no)
FROM 'C:\Users\Public\Documents\data\dept_manager.csv'
DELIMITER ','
CSV HEADER;

--NEXT TABLE employees

CREATE TABLE employees(
	emp_no INT NOT NULL,
	emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL
);

COPY employees (emp_no,emp_title_id,birth_date,first_name,last_name,sex,hire_date)
FROM 'C:\Users\Public\Documents\data\employees.csv'
DELIMITER ','
CSV HEADER;

--NEXT TABLE salaries

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL
);

COPY salaries (emp_no,salary)
FROM 'C:\Users\Public\Documents\data\salaries.csv'
DELIMITER ','
CSV HEADER;

--NEXT TABLE titles

CREATE TABLE titles(
	title_id VARCHAR NOT NULL,
	title VARCHAR NOT NULL
);

COPY titles (title_id,title)
FROM 'C:\Users\Public\Documents\data\titles.csv'
DELIMITER ','
CSV HEADER;

-- ADDING PRIMARY KEY and FOREIGN KEYS after laying out the ERD

ALTER TABLE departments
ADD PRIMARY KEY (dept_no);

ALTER TABLE employees
ADD PRIMARY KEY (emp_no)
ADD CONSTRAINT foreign_key
FOREIGN KEY (emp_title_id) 
REFERENCES titles (title_id);

ALTER TABLE titles
ADD PRIMARY KEY (title_id);

ALTER TABLE dept_emp
ADD CONSTRAINT foreign_key
FOREIGN KEY (emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp
ADD CONSTRAINT foreign_key
FOREIGN KEY (dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager
ADD CONSTRAINT foreign_key
FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager
ADD CONSTRAINT foreign_key
FOREIGN KEY (emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries
ADD CONSTRAINT foreign_key
FOREIGN KEY (emp_no)
REFERENCES employees (emp_no);

<h3 align="center">Employee Salary SQL Challenge</h3>


<p align="center">
     Using SQL and python to pass a interview.
    <br />
    <a href="https://github.com/HsuChe/sql-challenge"><strong>Project Github URL »</strong></a>
    <br />
    <br />
  </p>
</p>


<!-- ABOUT THE PROJECT -->

## About The Project

![hero image](https://github.com/HsuChe/sql-challenge/blob/066cf19bf3c139bb6051b43ccaf67d9ed1b1f578/images/hero_image.jpg)

We will be building the database for an company while quering information regarding their employees, deparments, salaries and job titles.

All the information is separated onto several different databases and the primary keys are linked together with many to many databases.

Features of the database:

* There are three tables with dedicated primary keys for them.

  * **The departments table**
    * Table has department labels
  * **The titles table.**
    * Table has all the staff title labels.
  * **The employees table**
    * birth_date: birthday of the employee.
    * first_name: first name of the employee
    * last_name: last name of the employee
    * sex: gender of the employee
    * hire_date: the date that the employee was hired
* The dataset is in the csv file format with delimiter of comma.
* Download the department csv click [HERE](https://github.com/HsuChe/sql-challenge/blob/f792740e3d3fe30d899a38788f8179959f835b81/data/departments.csv)
* Download the dept_emp csv click [HERE](https://github.com/HsuChe/sql-challenge/blob/f792740e3d3fe30d899a38788f8179959f835b81/data/dept_emp.csv)
* Download the dept_manager csv click [HERE](https://github.com/HsuChe/sql-challenge/blob/f792740e3d3fe30d899a38788f8179959f835b81/data/dept_manager.csv)
* Download the employees csv click [HERE](https://github.com/HsuChe/sql-challenge/blob/f792740e3d3fe30d899a38788f8179959f835b81/data/employees.csv)
* Download the salaries csv click [HERE](https://github.com/HsuChe/sql-challenge/blob/f792740e3d3fe30d899a38788f8179959f835b81/data/salaries.csv)
* Download the titles csv click [HERE](https://github.com/HsuChe/sql-challenge/blob/f792740e3d3fe30d899a38788f8179959f835b81/data/titles.csv)

## Importing the database to PostgresSQL

First step is to generate the EDR table for the database. This will define the relationships between all the tables and formulate the primary keys as well as all the foreign keys.

![EDR Image](https://github.com/HsuChe/sql-challenge/blob/e6bd0ab02e69d7a78718266d43937b51b4436bc2/EDR.png)

We can begin creating tables and getting it ready for import and export. First we create the tables with the correct column names and data types. 

```sh
-- Create the Table Columns
-- first table departments
CREATE TABLE departments(
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL);

```

Next we will copy the dedicated csv from our directories.

```sh
-- Copy row information from the csv
COPY departments (dept_no,dept_name)
-- Can use any directory with access permission
FROM 'C:\Users\Public\Documents\data\departments.csv'
DELIMITER ','
CSV HEADER;
```

After all the tables are formed, we can add the relationships to the tables, specifically the primary keys. We have three tables with primary keys: The departments table, employees table, and the titles table.

```sh
ALTER TABLE departments
ADD PRIMARY KEY (dept_no);

ALTER TABLE employees
ADD PRIMARY KEY (emp_no)
ADD CONSTRAINT foreign_key
FOREIGN KEY (emp_title_id) 
REFERENCES titles (title_id);

ALTER TABLE titles
ADD PRIMARY KEY (title_id);
```

After we will be setting the foreign keys for the rest of the tables.

```sh
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

```

### Analysis through query

After setting up the database, we can begin the analysis for the database and answer some questions.

1. List the following details of each employee: employee number, last name, first name, sex, and salary.

  ```sh
    SELECT first_name, last_name, hire_date 
    FROM employees
    WHERE EXTRACT(YEAR FROM hire_date) = '1986';
  ```

2. List first name, last name, and hire date for employees who were hire in 1986.

  ```sh
    SELECT E.emp_no, E.last_name, E.first_name, E.sex, S.salary
    FROM employees AS E
    INNER JOIN salaries AS S
    ON E.emp_no = S.emp_no;
  ```

3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.name, sex, and salary.

  ```sh
      SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no,  employees.last_name, employees.first_name
      FROM dept_manager
      INNER JOIN employees
      ON dept_manager.emp_no = employees.emp_no
      INNER JOIN departments
      ON dept_manager.dept_no = departments.dept_no;
  ```

4. List the department of each employee with the following information: employee number, last name, first name, and department name.

  ```sh
    SELECT dept_emp.emp_no, e.last_name, e.first_name, d.dept_name
    FROM dept_emp
    INNER JOIN employees AS e
    ON dept_emp.emp_no = e.emp_no
    INNER JOIN departments AS d
    ON dept_emp.dept_no = d.dept_no;
  ```

5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."name, sex, and salary.

  ```sh
    SELECT first_name,last_name,sex
    FROM employees
    WHERE first_name = 'Hercules'
    AND last_name LIKE 'B%';
  ```
6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

  ```sh
    SELECT dept_emp.emp_no, employees.first_name, employees.last_name,departments.dept_name
    FROM dept_emp
    INNER JOIN departments
    ON dept_emp.dept_no = departments.dept_no
    INNER JOIN employees
    ON dept_emp.emp_no = employees.emp_no
    WHERE departments.dept_name = 'Sales';
  ```

7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

  ```sh
    SELECT dept_emp.emp_no, employees.first_name, employees.last_name,departments.dept_name
    FROM dept_emp
    INNER JOIN departments
    ON dept_emp.dept_no = departments.dept_no
    INNER JOIN employees
    ON dept_emp.emp_no = employees.emp_no
    WHERE departments.dept_name = 'Sales'
    OR departments.dept_name = 'Development';

  ```
8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

  ```sh
    SELECT last_name, COUNT(last_name)
    FROM employees
    GROUP BY last_name
    ORDER BY COUNT(last_name) DESC;
  ```

### BONUS QUESTION

We are to graph the database to isolate the reasons we belive that the database is fake and design specifically for the query tests. 

  1. We need to import the orm dependencies as well as pandas to do the analysis.
  ```sh

    # Import the Dependencies
    import pandas as pd
    # SQL Alchemy
    from sqlalchemy import create_engine
    # import local server password
    from config_file import password
    engine = create_engine(f'postgresql://postgres:{password}@localhost/sql-challenge')
    connection = engine.connect()
    # MatPlotLib
    from matplotlib import pyplot as plt

  ```

  2. We can now graph the datasets that we are suspicious about.

  ```sh

    # first, plot the common salary graph using histogram
    df['salary'].plot.hist(figsize = (8,6), alpha = .5, color = 'red')
    plt.title('Common Salary of Employees')
    plt.xlabel('Salary')
    plt.savefig('common_salary.png')

  ```

  ![Histogram Image](https://github.com/HsuChe/sql-challenge/blob/e6bd0ab02e69d7a78718266d43937b51b4436bc2/images/common_salary.png)

  3. We cna also graph the median salary of the variious job titles.

  ```sh

    # then plot the median salary for each title name
    df.groupby('title').median()['salary'].plot.bar(figsize = (8,5), alpha = .5)
    plt.xlabel('Title Name')
    plt.ylabel('Median Salary')
    plt.title('Median Salary of Title Name')
    plt.savefig('med_title_name.png')

  ```

  ![Bargraph Image](https://github.com/HsuChe/sql-challenge/blob/e6bd0ab02e69d7a78718266d43937b51b4436bc2/images/med_title_name.png)

  ## CONCLUSION

  ### Most of the employees has the exact same salaries regardless of titles and seniority suggesting that the data might be fake.

  ### There were women called Hercules.
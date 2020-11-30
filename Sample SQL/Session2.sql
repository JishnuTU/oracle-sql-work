
DESCRIBE employees;


SELECT FIRST_NAME, last_name 
FROM employees
WHERE last_name LIKE 'Ma%';


SELECT first_name, last_name, salary, commission_pct "%"
FROM employees
WHERE salary >=11000 AND commission_pct IS NOT NULL;





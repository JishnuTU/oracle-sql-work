SELECT last_name, salary "Monthly Pay" , salary * 12 "Annual Pay" 
FROM employees
WHERE department_id = 90
ORDER BY salary DESC;


SELECT last_name, salary "Monthly Pay" , ROUND ( (salary * 12)/365 ,2) "Daily Pay" 
FROM employees
WHERE department_id = 100
ORDER BY salary DESC;
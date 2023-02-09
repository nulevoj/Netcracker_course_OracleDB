/* 
Лекція "SQL-команди із операціями над множинами"
*/

/*

Операції роботи з множинами:
1) Об'єднання
	a) UNION ALL – додавання всіх рядків другої вибірки
		до результату першої вибірки
	b) UNION – об'єднання множин рядків,
		отриманих у результаті двох вибірок
		з виключенням дублікатів (дорожче UNION ALL)
2) Перетин - INTERSECT – перетин множин рядків,
	отриманих у результаті двох вибірок
3) Виняток - MINUS - різниця множин рядків,
	тобто рядків з першої вибірки, які відсутні у другій вибірці

Операції роботи з множинами
найчастіше застосовуються якщо:
1) послідовно додаються результати різних запитів однієї структури;
2) порівнюється вміст різних таблиць схожої структури.
*/

/* Операції UNION, UNION ALL
Синтаксис: 
<запит1> 
UNION [ALL] 
<запит2> 
UNION [ALL] 
<запит3> .....; 
Правила поєднання результатів запитів:
1) Число і порядок вилучених стовпців повинні збігатися у всіх запитах, що об'єднуються;
2) Типи даних у відповідних стовпцях мають бути сумісні.
*/

-- Отримання інформації про співробітників:
-- 1) працюючих на посаді MANAGER із зарплатою менше 4000
-- або
-- 2) працюючих на посаді SALESMAN із зарплатою менше 3500.
-- Використання класичної вибірки
SELECT ename,job,sal FROM emp 
WHERE
	(job ='MANAGER' AND sal < 4000) 
	OR (job = 'SALESMAN' AND sal < 3500);

-- Варіант із UNION ALL. Спроба отримати інформацію про співробітників.  
select 
    ename,
	job,
	sal 
from emp 
where 
    job = 'MANAGER' and sal < 4000
UNION ALL
select 
    ename,
	job 
from emp 
where 
    job = 'SALESMAN' and sal < 3500;
-- Результат команди - ERROR at line 1:
-- ORA-01789: query block has incorrect number of result columns

-- Повторне, успішне отримання відповіді
select 
     ename,
	 job,
	 sal 
from emp 
where 
     job = 'MANAGER' and sal < 4000
UNION ALL
select 
     ename,
	 job,
	 sal 
from emp
where 
    job = 'SALESMAN' and sal < 3500;

-- Отримання імен співробітників:
-- З зарплатою <= 2000 або
-- Із зарплатою >= 1500.
-- Варіант із UNION ALL.
select 
    ename,
	sal 
from emp 
where 
     sal <= 4000
UNION ALL
select 
    ename,
	sal 
from emp 
where 
     sal >= 1500;

-- Варіант з UNION – виключення дублікатів
select ename,sal from emp where sal <= 4000
UNION
select ename,sal from emp where sal >= 1500;

-- Отримання числа працівників по департаментах із зазначенням загальної кількості.
-- Для підсумку вказати слово "Разом:"
select 
    dname, 
    count(emp.empno) emp_count
from emp, dept
where 
     emp.deptno = dept.deptno
group by dname
union all
select 
    'Разом:', 
    count(emp.empno)
from emp; 

-- Отримання імен співробітників із зарплатою в діапазоні > 3000 та < 4000
-- Використовувати INTERSECT
select ename 
from emp 
where 
    sal < 4000
INTERSECT
select ename 
from emp 
where 
     sal > 3000;

-- Отримання імен співробітників із зарплатою < 4000, але не > 3000
-- Використовувати MINUS
select ename 
from emp 
where  
    sal < 4000
MINUS
select ename from emp
where 
    sal > 3000;


/* 
Лекція "SQL-команди з операціями з'єднання таблиць. Oracle-стиль"

*/

SET LINESIZE 120
SET PAGESIZE 100

/*

1) Oracle підтримує SQL-стиль SQL-команд
	з операціями з'єднання таблиць
2) Oracle перетворює SQL-стиль на свій Oracle-стиль

Особливості Oracle-стилю з'єднання таблиць:
1) з'єднання використовується для отримання даних з двох та більше таблиць
2) умови з'єднання записуються у пропозиції WHERE.
3) якщо однакове ім'я колонки зустрічається у кількох таблицях,
	то слід використати префікси у вигляді імен таблиць.

*/

-- Шаблон SQL-команд операції з'єднання Oracle-стилю
SELECT	
    table1.column, 
    table2.column
FROM 
    table1, 
    table2
WHERE
    table1.column1 OPER table2.column2;


/* ДЕКАРТОВЕ З'ЄДНАННЯ - АБО "ПОМИЛКОВЕ" З'ЄДНАННЯ

1) в Oracle-стилі декартове з'єднання формується найчастіше,
	якщо у WHERE-фразі випадково втрачено умову з'єднання таблиць,
	вказаних у FROM-фразі
2) щоб уникнути декартового з'єднання в Oracle-стилі,
	завжди вмикайте умову з'єднання в пропозицію WHERE.

*/

-- Отримати декартове з'єднання таблиць
SELECT 
    ename, 
	dname
FROM 
    emp, 
    dept, 
	loc;

/* ЕКВІ-З'ЄДНАННЯ ТАБЛИЦЬ */

-- Екві-з'єднання таблиць
SELECT 
    e.empno, 
	e.ename, 
	e.deptno, 
	d.dname
FROM 
    emp e, 
	dept d
WHERE 
    e.deptno=d.deptno;

-- Екві-з'єднання трьох таблиць
SELECT 
    e.empno, 
	e.ename, 
	e.deptno, 
	d.dname, 
	l.locno, 
	l.lname
	FROM emp e, dept d, loc l
	WHERE 	e.deptno=d.deptno AND 
			d.locno=l.locno;

/* ТЕТА-З'ЄДНАННЯ ТАБЛИЦЬ */

-- Штучний приклад тета-з'єднання таблиць
SELECT e.ename, e.sal, d.dname
	FROM emp e, dept d
	WHERE e.deptno > d.deptno;

/* ЗОВНІШНЄ З'ЄДНАННЯ ТАБЛИЦЬ

Особливості Oracle-стилю:
1) використовується спеціальний оператор (+)
2) оператор прикріплюється в умові з'єднання,
найчастіше, праворуч від імені FK-колонки
3) може призвести до плутанини:
- для одержання лівостороннього з'єднання
оператор (+) може знаходиться праворуч;
- для отримання правостороннього з'єднання
оператор (+) може бути ліворуч;

	*/
	
-- Приклад лівостороннього з'єднання (Варіант №1)
SELECT 
    e.ename, 
	d.deptno, 
	d.dname
FROM emp e, dept d
WHERE
    d.deptno = e.deptno(+)
ORDER BY e.deptno;

-- Приклад лівостороннього з'єднання (Варіант №2)
SELECT 
    e.ename, 
	d.deptno, 
	d.dname
FROM emp e, dept d
WHERE 
    e.deptno(+) = d.deptno
ORDER BY e.deptno;

-- Приклад правостороннього з'єднання
SELECT 
    e.ename, 
    d.deptno, 
	d.dname
FROM 
    emp e, 
	dept d
WHERE 
    e.deptno(+) = d.deptno
ORDER BY e.deptno;

/* САМОЗ'ЄДНАННЯ ТАБЛИЦЬ */

-- Отримати фразу для кожного співробітника
-- "Employee with name=<ename> works for <ename>"
SELECT 
    'Employee ' 
     || worker.ename 
	 || ' works for '
	 || manager.ename AS "Employee"
FROM 
    emp worker, 
    emp manager
WHERE 
    worker.mgr = manager.empno;


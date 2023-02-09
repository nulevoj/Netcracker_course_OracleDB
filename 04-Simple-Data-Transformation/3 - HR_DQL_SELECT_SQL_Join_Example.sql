/* 
Лекція "SQL-команди з операціями з'єднання таблиць. SQL-стиль"
*/

SET LINESIZE 2000
SET PAGESIZE 100

/*

Типи з'єднання таблиць:
1) декартове з'єднання
2) екві-з'єднання
3) тета-з'єднання
4) зовнішнє з'єднання
5) самоз'єднання

*/

/* ДЕКАРТОВЕ З'ЄДНАННЯ - АБО "ЛІНІВЕ" З'ЄДНАННЯ

Декартове з'єднання формується на основі
декартового добутку, якщо:
1) умова з'єднання опущена
2) умова з'єднання некоректна
3) у результаті з'єднання всі рядки першої таблиці-операнда
	з'єднуються з усіма рядками другої таблиці-операнда

*/
-- Отримання декартового з'єднання таблиць
SELECT ename,dname
FROM emp CROSS JOIN dept;

/* ЕКВІ-З'ЄДНАННЯ ТАБЛИЦЬ */

-- Отримання інформації про підрозділ та його локацію
-- для співробітника KING:
-- Поетапне отримання даних з різних таблиць
-- Крок 1. Отримання інформації про співробітника
SELECT empno, ename, deptno
FROM Emp 
WHERE 
    ename = 'KING';

-- Крок 2. Отримання інформації про підрозділ
SELECT 
    dname, 
	locno
FROM Dept 
WHERE 
    deptno = 1;
-- Крок 3. Отримання інформації про локацію
SELECT lname
FROM Loc 
WHERE 
    locno = 1;

-- Отримання рядків з використанням еквіз'єднань -
-- внутрішніх з'єднань таблиць ( JOIN = INNER JOIN )
SELECT 
    emp.empno, 
	emp.ename, 
	emp.deptno, 
	dept.dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno)
WHERE 
    emp.ename = 'KING';

SELECT 
    emp.empno, 
	emp.ename, 
	emp.deptno, 
	dept.dname
FROM emp INNER JOIN dept ON (emp.deptno=dept.deptno)
WHERE 
    emp.ename = 'KING';

/* ЗАМІНА ІМЕН ТАБЛИЦЬ НА ЇХ ПСЕВДОНІМИ

Ефект використання псевдонімів таблиць:
1) довгі імена таблиць можуть значно збільшити
	розмір SQL-запиту та час на його редагування
2) СКБД самостійно замінює імена таблиць
	на внутрішні ідентифікатори,
	тому ручне створення псевдоніма – спрощення роботи СКБД
3) якщо кілька таблиць мають однойменні стовпці,
	псевдоніми можуть вирішити конфлікт імен
	
*/
	
-- Проблеми при відсутності псевдонімів

-- Спроба отримати відповідь без вказівки імен таблиць
SELECT 
    empno, 
	ename, 
	deptno, 
	dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno);
-- Результат команди - ERROR at line 1: 
-- ORA-00918: column ambiguously defined

-- Отримання відповіді з явним зазначенням імен таблиць
SELECT 
    emp.empno, 
	emp.ename, 
	dept.deptno, 
	dept.dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno);

-- Автоматичне визначення в СУБД імен таблиць
-- якщо використовується символ '*'
-- без заборони дублювання імен колонок
SELECT *
FROM emp JOIN dept ON (emp.deptno=dept.deptno);

-- Використання псевдонімів таблиць
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno=d.deptno);

-- З'єднання таблиць з автоматичним визначенням
-- умов еквіз'єднання - NATURAL JOIN
SELECT *
FROM emp NATURAL JOIN dept ;

-- Спроба вказати псевдоніми в NATURAL JOIN
SELECT e.*
FROM emp e NATURAL JOIN dept d;
-- Результат команди - ERROR at line 1:
-- ORA-25155: column used in NATURAL join cannot have qualifier

-- Отримання інформації про підрозділ та його локацію
-- для співробітника KING через еквіз'єднання трьох таблиць:
-- 1) з'єднання першої пари таблиць emp та dept
-- 2) з'єднані другої пари таблиць:
-- 		- таблиця як результат 1-го з'єднання
-- 		- таліця loc
SELECT 
    e.empno, 
    e.ename, 
    e.deptno, 
	d.dname, 
	l.locno, 
	l.lname
FROM emp e JOIN dept d ON (e.deptno=d.deptno)
						JOIN loc l ON (d.locno=l.locno)
WHERE 
    e.ename = 'KING';
	
/* ТЕТА-З'ЄДНАННЯ ТАБЛИЦЬ

Використовуються операції порівняння, відмінні від операції '=' :
>
<
>=
<=
!= або <>

*/

-- Штучний приклад тета-з'єднання таблиць

SELECT 	
    e.ename, 
	e.sal, 
	d.dname
FROM emp e JOIN dept d ON (e.deptno > d.deptno);

/* ЗОВНІШНЄ З'ЄДНАННЯ ТАБЛИЦЬ

Типи зовнішнього з'єднання:
1) лівостороннє з'єднання LEFT JOIN = LEFT OUTER JOIN -
	а) повертає всі рядки з лівої таблиці,
		навіть якщо у правій таблиці немає збігів.
	b) найчастіше визначається між таблицями,
		коли зліва знаходиться таблиця з PK-колонкою,
		а праворуч - таблиця з FK-колонкою
2) правостороннє з'єднання RIGHT JOIN = RIGHT OUTER JOIN
	a) повертає всі рядки із правої таблиці,
		навіть якщо у лівій таблиці немає збігів.
	b) найчастіше визначається між таблицями,
		коли справа знаходиться таблиця з PK-колонкою,
		а зліва - таблиця з FK-колонкою
3) два зазначені типи з'єднання є взаємозамінними

*/
	
-- Отримання списку підрозділів
-- із зазначенням списку співробітників, що працюють в них 
SELECT 
    d.dname, 
	e.ename
FROM dept d JOIN emp e ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- Отримання списку ВСІХ підрозділів
-- із зазначенням списку співробітників, що працюють в них
-- Отримання підрозділів навіть за відсутності співробітників
-- на основі лівого з'єднання LEFT JOIN
SELECT 
    d.dname, 
	e.ename
FROM dept d LEFT JOIN emp e ON (d.deptno = e.deptno) 
ORDER BY d.dname;
		
-- Повторення попередньої команди,
-- але з правостороннім з'єднанням RIGHT JOIN
SELECT 
    d.dname, 
	e.ename
FROM emp e RIGHT JOIN dept d ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- Заміна NULL-значень на літерали
SELECT 
    d.dname, 
	NVL(e.ename,'UNDEFINED') AS ename
FROM emp e RIGHT JOIN dept d ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- Зовнішнє повне (двостороннє) з'єднання
-- FULL JOIN (LEFT JOIN + RIGHT JOIN)
SELECT 
    d.dname, 
	e.ename
FROM dept d FULL JOIN emp e ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- Зовнішнє з'єднання з автоматичним визначенням сполучних стовпців
SELECT *
FROM dept NATURAL LEFT JOIN emp;
		
/* САМОЗ'ЄДНАННЯ ТАБЛИЦЬ

Властивості:
1) використовується кілька посилань таблиць (іменних копій)
	одну таблицю;
2) застосовуються, в основному, якщо в таблиці
	є FK-колонка, що посилається на PK-колонку цієї ж таблиці

*/

-- Отримати для кожного співробітника фразу
-- "Employee <ename> works for <ename>"
SELECT 
    'Employee ' 
	|| worker.ename 
	|| ' works for '
	|| manager.ename AS "Employee"
FROM 
    emp worker JOIN emp manager 
        ON (worker.mgr = manager.empno);


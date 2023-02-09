/* 
Приклади SELECT-команд 
з використання операції "Вибірка" (фільтрування)
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- шаблон  простої SELECT-команди
SELECT [DISTINCT] {*, column [alias], ...}
FROM table
[WHERE condition(s)];

/*
SELECT - ВИБРАТИ щось
FROM – З таблиці
WHERE – ДЕ виконується умова обмеження
*/

/*
Оператори порівняння:
A = B
>
>=	
<
<=	
<> або !=
*/

-- Отримання імен співробітників із зарплатою > 3000
SELECT 
    ename, 
	sal 
FROM emp 
WHERE 
    sal > 3000;

-- Отримання інформації про співробітника за прізвищем KING
SELECT 
    empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp 
WHERE 
    ename = 'KING';

/*
Складні оператори:
BETWEEN ... AND ...
IN(list)
LIKE
IS NULL
*/


-- Отримання імен співробітників із зарплатою в діапазоні від 3000 до 3500
SELECT 
    ename, 
	sal 
FROM emp 
WHERE 
    sal BETWEEN 3000 AND 3500;

-- Отримання імен співробітників із зарплатою в діапазоні від 3000 до 3500
-- (класичний варіант із операторами порівняння)
SELECT 
    ename, 
	sal 
FROM emp 
WHERE 
    sal >= 3000 
	AND sal <= 3500;

	
-- Отримання імен співробітників із зарплатою, 
-- для яких номер співробітника приймає одне із значень 2 або 4
SELECT 
    empno, ename, sal, mgr
FROM emp
WHERE 
    empno IN (2, 4);

/*
Використання оператора LIKE:
- використовуйте оператор LIKE для пошуку за шаблоном.
- умова пошуку може містити як символи, так і числа.
- символ % позначає будь-яку кількість символів.
- символ _ позначає будь-який одиночний символ.
- символи шаблону можна поєднувати.
- використовуйте ідентифікатор ESCAPE для пошуку символів "%" or "_".
*/
	
-- Отримання імен співробітників, які мають в імені другу літеру = L
SELECT ename
FROM emp
WHERE 
    ename LIKE '_L%';

-- Отримання імен локацій, що включають символ підкреслення
SELECT lname
FROM Loc
WHERE 
    lname LIKE '%#_%%' ESCAPE '#';

-- Отримання імен співробітників, у яких перша літера = B, третя = A
SELECT ename
FROM emp
WHERE 
    ename LIKE 'B_A%';
	
/*
Контроль невизначеного значення NULL:
- NULL – це значення, яке невідоме, не визначене чи незастосовне;
- NULL – це не те саме, що нуль або пробіл;
- значенням виразів, що містять NULL, є NULL;
- оператор IS NULL використовується для перевірки, чи збігається значення з NULL
*/
	
-- Отримання розміру річної зарплати співробітника, у якого немає комісійних
select 
    12*sal+comm AS salary
FROM emp
WHERE 
    comm IS NULL;	


/*
Логічні оператори:
AND
OR
NOT
*/

-- Отримання списку співробітників, у яких зарплата >= 3500 та посада = 'SALESMAN'
SELECT 
    empno, 
	ename, 
	job, 
	sal
FROM emp
WHERE 
    sal >= 3500 
    AND job = 'SALESMAN';
			
-- Отримання списку співробітників, які мають зарплату >= 3500 чи посаду = 'SALESMAN'
SELECT 
    empno, 
    ename, 
	job, 
	sal
FROM emp
WHERE 
    sal >= 3500
	OR job = 'SALESMAN';


-- Отримання імені, посади співробітників, посада яких не входить до списку: 
-- 'MANAGER','SALESMAN'
SELECT 
    ename, 
	job
FROM emp
WHERE 
    job NOT IN ('MANAGER','SALESMAN');

-- Отримання імені, посади співробітників, посада яких не входить до списку: 
-- 'MANAGER','SALESMAN'
-- (класичний варіант із операторами порівняння)
SELECT 
    ename, 
	job
FROM emp
WHERE 
    job != 'MANAGER' 
	AND job != 'SALESMAN';

/*
Правила де Моргана щодо перетворення логічних виразів: 
-- 1) not (P and Q) = (not P) or (not Q)
-- 2) not (P or Q) = (not P) and (not Q) 
*/

-- Отримання імені, посади співробітників, посада яких не входить до списку: 
-- 'MANAGER','SALESMAN'
-- Використовувати лише оператор NOT та AND
SELECT 
    ename, 
	job
FROM emp
WHERE 
    NOT (job = 'MANAGER') 
	AND NOT (job = 'SALESMAN');

-- Отримання імені, посади співробітників, посада яких не входить до списку: 
-- 'MANAGER','SALESMAN'
-- Використовувати лише оператор NOT та OR
SELECT 
    ename, 
	job
FROM emp
WHERE
    NOT (job = 'MANAGER' 
        OR job = 'SALESMAN');

/*
Пріоритети операцій:
1	Усі оператори порівняння
2	NOT
3	AND
4	OR
*/
	 
-- Отримання імені, посади та зарплати співробітників,
-- які працюють на посаді 'SALESMAN' або
-- працюють на посаді = 'MANAGER' із зарплатою >3500
SELECT 
    ename, 
	job, 
	sal
FROM emp
WHERE  
    job = 'SALESMAN'
	OR job = 'MANAGER'
	AND sal > 3500;

-- Отримання імені, посади та зарплати співробітників,
-- які працюють на посаді 'SALESMAN' або
-- на посаді = 'MANAGER', а також одержують зарплату >3500

SELECT 
    ename, 
	job, 
	sal
FROM emp
WHERE 
    (job='SALESMAN' 
        OR job='MANAGER')
	 AND sal>3500;


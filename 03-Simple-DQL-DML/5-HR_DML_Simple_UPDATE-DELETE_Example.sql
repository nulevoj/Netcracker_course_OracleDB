/* 
Приклади простих DELETE/UPDATE-команд
*/

-- Шаблон простої UPDATE-команди
UPDATE table
SET	column = value [, column = value]
[WHERE condition];

-- Зміна заробітної плати співробітника з номером = 1
UPDATE emp
SET sal = 5500
WHERE 
    empno = 1;

-- Зміна зарплати та комісійних співробітника з номером = 2
UPDATE emp
SET sal = 5500, 
    comm = 500
WHERE 
    empno = 2;

-- Спроба зміни коду підрозділу співробітника (спроба)
UPDATE emp
SET deptno = 5
WHERE 
    empno = 1;

-- Спроба зміни коду підрозділу співробітника (спроба)
UPDATE emp
SET deptno = 3
WHERE 
    empno = 1;

-- Шаблон простої DELETE-команди
DELETE FROM table
	[WHERE condition];

-- Спроба видалення всіх підрозділів
DELETE FROM dept;

-- Видалення співробітників, перша літера імені яких = 'B'
DELETE FROM emp
WHERE 
    ename like 'B%';

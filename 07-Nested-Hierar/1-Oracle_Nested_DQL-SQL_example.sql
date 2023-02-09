/* 
Лекція "Data Query Language (DQL) з вкладеними запитами в СУБД Oracle" 
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- Приклад 1 Отримати список прізвищ співробітників,
-- зарплата яких більша за зарплату співробітника з ім'ям JONES
-- Варіант 1 – Використання двох запитів.
-- 1.1. Отримати розмір зарплати співробітника з ім'ям JONES
SELECT SAL FROM EMP WHERE  ENAME = 'JONES';
/* Відповідь:
   SAL
--------
  2975
*/	  
-- 1.2 Отримати список прізвищ співробітників,
-- зарплата яких більша за зарплату 2975
SELECT ENAME
FROM   EMP
WHERE  SAL > 2975;

-- Приклад 1. Варіант 2 – Використання самоз'єднання таблиці EMP
SELECT OTHER_EMP.ENAME
FROM   EMP OTHER_EMP, EMP JONES
WHERE  	JONES.ENAME = 'JONES'
		AND OTHER_EMP.SAL > JONES.SAL;

-- Приклад 1. Варіант 3 - Використання вкладеного запиту (підзапиту)
SELECT ENAME
FROM   EMP
WHERE  SAL > 
			(
			SELECT SAL
              FROM EMP WHERE ENAME = 'JONES'
			);

-- Приклад 1. Варіант 3, але з неправильним 1-м оформленням
SELECT ENAME FROM EMP WHERE  SAL > (SELECT SAL FROM EMP WHERE ENAME = 'JONES');

-- Приклад 1. Варіант 3, але з неправильним 2-м оформленням
SELECT ENAME 
FROM EMP 
WHERE  
	(SELECT SAL FROM EMP WHERE ENAME = 'JONES') < SAL;

-- Приклад 2 Виконання множинних однорядкових підзапитів.
-- Отримати список співробітників, у яких:
-- 1) зарплата більша за зарплату співробітника з ім'ям JONES
-- 2) посада збігається з посадою співробітника ALLEN
SELECT 	ENAME
FROM   	EMP
WHERE  	SAL <
			( 
			SELECT SAL
            FROM EMP WHERE ENAME = 'JONES'
			)
		AND 
		JOB = 
			(
			SELECT JOB 
			FROM EMP WHERE ENAME = 'ALLEN'
			);
		
-- Приклад 3 Використання агрегатних функцій у підзапитах
-- Отримати список співробітників, зарплата яких мінімальна
SELECT ENAME, JOB, SAL
FROM EMP
WHERE SAL =
			(SELECT MIN(SAL) FROM EMP);
			
-- Приклад 4 Використання пропозиції HAVING у підзапиті
-- Отримати список підрозділів, у яких середня зарплата співробітників
-- більше середньої зарплати співробітників у всій компанії
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING AVG(SAL) >
				(SELECT AVG(SAL) FROM EMP);

-- Приклад 5 Що не так із цим виразом?
SELECT EMPNO, ENAME
FROM   EMP
WHERE  SAL = 
			(SELECT MIN(SAL) FROM EMP
				GROUP BY  DEPTNO);
		
-- Приклад 6 Чи буде виконано цей вираз?
SELECT ENAME, JOB
FROM EMP
WHERE JOB = 
			(SELECT JOB
				FROM EMP WHERE ENAME='SMYTHE');
-- Потрібно перевіряти результат підзапиту

-- Приклад 7 Використання оператора ANY у багаторядкових підзапитах
-- Отримати список співробітників, які не є клерками,
-- а зарплата яких менша за будь-яку зарплату, яку отримують клерки
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE 	SAL < ANY 
				(SELECT SAL FROM EMP 
					WHERE JOB = 'CLERK')	
		AND JOB <> 'CLERK';

-- Приклад 8 Інший запит з урахуванням того,
-- що "< ANY" означає "менше максимального"
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE 	SAL <
				(SELECT MAX(SAL) FROM EMP 
					WHERE JOB = 'CLERK')	
		AND JOB <> 'CLERK';

-- Приклад 9 Використання оператора ALL у багаторядкових підзапитах
-- Отримати список співробітників, зарплата яких більша
-- максимальної середньої зарплати у різних підрозділах
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE SAL > ALL 
				(SELECT AVG(SAL)
					FROM EMP GROUP BY DEPTNO);

-- Приклад 10 Інший запит з урахуванням того,
-- що ">ALL" означає "більше максимального"
SELECT  EMPNO, ENAME, JOB
FROM EMP
WHERE SAL >  
			(SELECT MAX(AVG(SAL))
				FROM EMP GROUP BY DEPTNO);


-- Приклад 11 Вибрати ім'я, номер підрозділу, зарплату та комісійні
-- будь-якого працівника, у якого зарплата та комісійні одночасно
-- збігаються із зарплатою та комісійними будь-якого працівника у підрозділі 30.
-- Варіант 1. Не враховує, що є невизначені значення комісійних
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE (SAL, COMM) IN 
					(SELECT SAL, COMM
          			FROM EMP 
         			WHERE DEPTNO = 30);

-- Варіант 2. Враховує, що є невизначені значення комиссійних
-- Використання двох запитів
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE (SAL, COMM) IN 
					(SELECT SAL, COMM
          			FROM EMP 
         			WHERE DEPTNO = 30 
						AND COMM IS NOT NULL)
	AND COMM IS NOT NULL
UNION ALL
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE SAL IN 
					(SELECT SAL
          			FROM EMP 
         			WHERE DEPTNO = 30 
						AND COMM IS NULL)
	AND COMM IS NULL
;


-- Приклад 11. Варіант 2. Облік невизначених коммісійних значень
-- через функцію перетворення NVL
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE (SAL, NVL(COMM,-1)) IN 
							(SELECT SAL, NVL(COMM,-1)
							FROM EMP 
							WHERE DEPTNO = 30);

-- Приклад 12 Використання підзапитів у пропозиції FROM.
-- Вибрати співробітників з більшою зарплатою,
-- ніж середня зарплата у співробітників у їх підрозділах
SELECT  A.ENAME, A.SAL, A.DEPTNO, B.SALAVG
FROM  EMP A, 
			(SELECT DEPTNO, AVG(SAL) SALAVG
			FROM EMP
			GROUP BY DEPTNO) B
WHERE   A.DEPTNO = B.DEPTNO
AND     A.SAL > B.SALAVG;
 
-- Приклад 12.2 Використання підзапитів в операторі WITH.
-- Вибрати співробітників з більшою зарплатою,
-- ніж середня зарплата у співробітників у їх підрозділах
WITH 
AVG_SAL AS
	(
		SELECT DEPTNO, AVG(SAL) SALAVG
		FROM EMP
		GROUP BY DEPTNO
	)
SELECT A.ENAME, A.SAL, A.DEPTNO, B.SALAVG
FROM EMP A, AVG_SAL B
	WHERE 	A.DEPTNO = B.DEPTNO
			AND A.SAL > B.SALAVG;

-- Приклад 13 Отримати список підрозділів, у яких працюють співробітники.
-- Варіант 1. 
SELECT  D.DNAME
	FROM DEPT D, EMP E 
	WHERE D.DEPTNO = E.DEPTNO;

-- Варіант 2. Використання оператора DISTINCT
SELECT  DISTINCT D.DNAME
	FROM DEPT D, EMP E 
	WHERE D.DEPTNO = E.DEPTNO;

-- Варіант 3. Використання оператора IN
SELECT d.dname
	FROM dept d
	WHERE d.deptno IN (
			SELECT e.deptno 
			FROM emp e);

-- Варіант 4. Використання оператора EXISTS
SELECT D.DNAME
	FROM DEPT D
	WHERE EXISTS (
			SELECT E.DEPTNO 
			FROM EMP E 
			WHERE E.DEPTNO = D.DEPTNO);
-- Різниці у відповіді немає, але швидкість виконання може відрізнятися.
-- Рекомендація: -- якщо кількість рядків у підзапиті >
-- кількості рядків основного запиту - використовуємо EXISTS, інакше - IN

	
-- Приклад 14 Отримати список співробітників, які не мають підлеглих
SELECT EMPLOYEE.ENAME
FROM EMP EMPLOYEE
WHERE NOT EXISTS
			(SELECT MANAGER.MGR
			FROM EMP MANAGER
			WHERE MGR = EMPLOYEE.EMPNO);
			
SELECT D.DNAME
	FROM DEPT D
	WHERE NOT EXISTS (
			SELECT E.DEPTNO 
			FROM EMP E 
			WHERE E.DEPTNO = D.DEPTNO);

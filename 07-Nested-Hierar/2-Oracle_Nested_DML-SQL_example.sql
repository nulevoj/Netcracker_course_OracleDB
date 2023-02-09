/* 
Лекція: "Data Manipulation Language (DML) з вкладеними запитами в СУБД Oracle" 
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- Приклад 1 Використовуючи один INSERT-оператор, зареєструвати нового співробітника
-- у новому підрозділі, який також має бути зареєстрований.
-- Назва підрозділу = 'Odessa Office' і розташований в тому самому місті, 
-- що і підрозділ його керівника.
-- Співробітник: ім'я = 'IVANOV', посада = 'STUDENT', дата зарахування = поточна дата,
-- зарплата = 0, премія = 0, керівником є співробітник з ім'ям KING.

CREATE SEQUENCE DEPTNO START WITH 50 INCREMENT BY 10;
CREATE SEQUENCE EMPNO START WITH 8000;
INSERT ALL
	INTO DEPT (DEPTNO, DNAME, LOCNO)
		VALUES (DEPTNO.NEXTVAL, 'ODESSA OFFICE', LOCNO) 
	INTO EMP (EMPNO, ENAME, JOB, 
			MGR, HIREDATE, SAL, COMM, DEPTNO)
		VALUES (EMPNO.NEXTVAL, 'IVANOV', 'STUDENT', 
			EMPNO, SYSDATE, 0, 0, DEPTNO.CURRVAL)
SELECT E.EMPNO, D.LOCNO
FROM EMP E, DEPT D
WHERE E.ENAME = 'KING' 
		AND E.DEPTNO = D.DEPTNO;

-- 2. Створити дві таблиці із структурою: ename, dname, sal.
-- Ім'я кожної таблиці має бути зв'язане з ім'ям посади
-- менеджера та продавця, і містити співробітників відповідних посад
-- При створенні використовувати предикат 1 = 0 для формування пустих таблиць.

-- 2.1
CREATE TABLE MANAGER AS 
SELECT ename, dname, sal FROM emp e, dept d
		WHERE e.deptno = d.deptno AND 1=0;   
CREATE TABLE SALESMAN AS 
SELECT ename, dname, sal FROM emp e, dept d
		WHERE e.deptno = d.deptno AND 1=0;  

-- 2.2 Одним запитом внести у дві таблиці дані щодо співробітників двох посад	
INSERT FIRST
	WHEN JOB = 'MANAGER' THEN 
		INTO MANAGER (ENAME, DNAME, SAL)
			VALUES (ENAME, DNAME, SAL)
	WHEN JOB = 'SALESMAN' THEN 
		INTO SALESMAN (ENAME, DNAME, SAL)
			VALUES (ENAME, DNAME, SAL)
SELECT ENAME, JOB, DNAME, SAL
		FROM EMP E, DEPT D
			WHERE E.DEPTNO = D.DEPTNO;   

-- Приклад 3 Зміна посади та підрозділу співробітника
-- з номером = 7698 на такі ж, як у співробітника з номером = 7499.
UPDATE  emp
  SET  (job, deptno) = 
				  (SELECT job, deptno
                          FROM    emp
                          WHERE   empno = 7499)
  WHERE   empno = 7698;

-- Приклад 4 Для всіх співробітників, які працюють у місті DALLAS
-- збільшити зарплату на 10%

-- 4.1 - Варіант із кореляційним підзапитом
UPDATE EMP E SET SAL = SAL * 0.1 + SAL
WHERE EXISTS
	(
		SELECT NULL FROM DEPT D, LOC L
		WHERE D.DEPTNO = E.DEPTNO
			AND D.LOCNO = L.LOCNO
			AND L.LNAME = 'DALLAS'
	);

-- 4.2 - Варіант із оновлюваною тимчасовою таблицею
UPDATE 
	( 
		SELECT E.EMPNO,E.SAL
		FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
				JOIN LOC L ON (D.LOCNO = L.LOCNO)
		WHERE L.LNAME = 'DALLAS'
	)
	SET SAL = SAL * 0.1 + SAL;
  		
-- Приклад 5 Видалити всіх співробітників із підрозділу SALES
DELETE FROM EMP
 WHERE DEPTNO =  
		       (SELECT DEPTNO
 			        FROM DEPT
 			        WHERE DNAME ='SALES');

ROLLBACK;

-- Приклад 6 Другий варіант видалення всіх співробітників із підрозділу SALES
-- Використання тимчасової таблиці як підзапит
DELETE FROM	(
			SELECT * FROM EMP 
			WHERE DEPTNO = 
				(SELECT DEPTNO FROM DEPT
					WHERE DNAME ='SALES')
			);

ROLLBACK;
				
-- Приклад 7 Видалити всі підрозділи, які не мають співробітників.
-- Використання кореляційних підзапитів.
DELETE FROM DEPT D
	WHERE NOT EXISTS  
		       (SELECT DEPTNO
 			    FROM EMP E
 			    WHERE E.DEPTNO = D.DEPTNO);

ROLLBACK;

/* Приклад 8. Поєднаний INSERT/UPDATE запит – оператор MERGE
*/

-- 8.1 Створити копію таблиці emp
CREATE TABLE EMP_ALL AS
	SELECT * FROM EMP;
	
-- 8.2 Змінити коди підрозділів усіх співробітників та
UPDATE emp SET deptno = 20;

-- 8.3 Видалити співробітників, перша літера імені яких починається з А
DELETE FROM emp
	WHERE ename like 'A%';

-- 8.4 Відновити вихідні коди підрозділів роботи невидалених співробітників,
-- а також відновити видалених співробітників
MERGE INTO EMP A
	USING EMP_ALL B
		ON (A.EMPNO = B.EMPNO)
	WHEN MATCHED THEN
		UPDATE SET A.DEPTNO = B.DEPTNO
	WHEN NOT MATCHED THEN
		INSERT (EMPNO, ENAME, JOB, MGR, 
				HIREDATE, SAL, COMM, DEPTNO)
			VALUES (B.EMPNO, B.ENAME, B.JOB, B.MGR, 
				B.HIREDATE, B.SAL, B.COMM, B.DEPTNO);
		

/* 
Програмування активних БД на основі тригерів у мові PL/SQL.
Частина 2 - Тригери складного контролю даних. 
Приклади використання
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

/* Модернізація простих правил посилальної цілісності */

-- Спроба видалити рядки, на які є посиланням з інших таблиць
DELETE FROM dept;

-- Приклад тригера із забезпечення каскадного видалення
CREATE OR REPLACE TRIGGER dept_del_cascade
  AFTER DELETE ON dept
  FOR EACH ROW
BEGIN
  DELETE FROM emp
	WHERE emp.deptno = :OLD.deptno;
END;
/
SHOW ERRORS

-- Тест-кейси перевірки роботи тригера
-- 1
DELETE FROM dept;
-- 2 
SELECT * 
FROM emp;
--
ROLLBACK;

-- Відключення тригера
ALTER TRIGGER dept_del_cascade DISABLE;

/***
Забезпечення предметно-орієнтованого контролю
посилальної цілісності між двома таблицями
***/

/* Вбудовані правила контролю посилальної цілісності між двома таблицями:
1) спроба каскадного видалення PK-колонки зі зв'язком з FK-колонкою
	SQLCODE=-2292: integrity constraint violated - child record found
2) спроба додавання FK-колонки неіснуючої PK-колонки
	SQLCODE=-2291: integrity constraint violated - parent key not found
*/

-- Забезпечення предметно-орієнтованого контролю
-- спроби каскадного видалення PK-колонки зі зв'язком з FK-колонкою
CREATE OR REPLACE TRIGGER dept_del_cascade_control
  BEFORE DELETE ON dept
  FOR EACH ROW
DECLARE
	deptno_ dept.deptno%TYPE;
	emp_exists EXCEPTION;
BEGIN
	SELECT deptno INTO deptno_ FROM emp 
		WHERE deptno = :OLD.deptno
		FETCH FIRST 1 ROWS ONLY;
	RAISE emp_exists;
EXCEPTION 
		WHEN emp_exists THEN 
			RAISE_APPLICATION_ERROR(-20550,
			'In department with deptno=' || :OLD.deptno
				|| ' exists employees!');
		-- якщо запит не повертає дані, завершити роботу тригера
		WHEN NO_DATA_FOUND THEN 
			NULL;
END;
/
SHOW ERRORS

-- Тест-кейс перевірки роботи тригера
DELETE FROM dept;

-- Забезпечення предметно-орієнтованого контролю
-- спроби додавання FK-колонки неіснуючої PK-колонки
CREATE OR REPLACE TRIGGER emp_insert_empno_control
  BEFORE INSERT ON emp
  FOR EACH ROW
DECLARE
	deptno_ dept.deptno%TYPE;
BEGIN
	SELECT deptno INTO deptno_ FROM dept
		WHERE deptno = :NEW.deptno;
EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			RAISE_APPLICATION_ERROR(-20551,
				'Department with deptno=' 
				|| :NEW.deptno || ' NOT EXISTS!'
			);
END;
/
SHOW ERRORS

-- alter trigger emp_insert_empno_control disable;
alter trigger emp_insert_empno_control enable;

-- Тест-кейси перевірки роботи тригера
-- 1
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(1,'name1','JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),100,60);
-- 2
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(1,'name1','JOB1',to_date('01/01/2020','dd/mm/yyyy'),100,10);

/******* Забезпечення складних правил посилальної цілісності *******/

/* Заборонити вносити розмір зарплат, що суперечить допустимим діапазонам */

-- Створення таблиці з допустимими діапазонами зарплат з кожної посади
CREATE TABLE job_classification (
	job	 	VARCHAR(10) PRIMARY KEY,
	min_sal number(4,2),
	max_sal number(4,2)
);

INSERT INTO job_classification VALUES ('JOB1',10,30);
INSERT INTO job_classification VALUES ('JOB2',20,60);

/* Створення тригера, PL/SQL-блок якого виконується:
1) за подіями, що викликаються командами INSERT, UPDATE;
2) перед успішним завершенням цих подій (BEFORE);
3) для кожного рядка таблиці EMP, що обробляється цими командами (FOR EACH ROW)
*/
CREATE OR REPLACE TRIGGER sal_check 
	BEFORE INSERT OR UPDATE ON emp 
	FOR EACH ROW
DECLARE
	min_sal_ job_classification.min_sal%TYPE;
	max_sal_ job_classification.max_sal%TYPE;
	sal_out_of_range EXCEPTION;
BEGIN
	/* отримати мінімальний та максимальний
	оклад для нової посади службовця з таблиці 
	JOB_CLASSIFICATION в MIN_SAL и MAX_SAL */
	SELECT min_sal, max_sal INTO min_sal_, max_sal_ 
	FROM job_classification
	WHERE TRIM(job) = :NEW.job;
	/* якщо новий оклад службовця менше чи більше,
	ніж обмеження щодо посадової класифікації,
	виконується виняткова ситуація,
	а операція скасовується. */
	IF (:NEW.sal < min_sal_ OR :NEW.sal > max_sal_) THEN 
		RAISE sal_out_of_range;
	END IF;
EXCEPTION
	-- обробка виключення за неприпустимим значенням окладу співробітника
	WHEN sal_out_of_range THEN
		RAISE_APPLICATION_ERROR(-20300, 
				'salary ' 
				|| TO_CHAR(:NEW.sal)
				|| ' out of job classification '
				|| RTRIM(:NEW.JOB)|| ' for employee ' 
				|| :NEW.ename
		);
	/* обробка виключення, коли вказана посада в операції
		відсутня у таблиці JOB_CLASSIFICATION
	*/
	WHEN NO_DATA_FOUND THEN
		RAISE_APPLICATION_ERROR(-20301, 
				'incorrect job ' || :NEW.job);
END;
/
SHOW ERRORS

-- Тест-кейси перевірки роботи тригера
-- 1
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(3,'name3','JOB1',to_date('01/01/2020',
	'dd/mm/yyyy'),100,10);
-- 2
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(3,'name3','JOB1',to_date('01/01/2020',
	'dd/mm/yyyy'),20,10);
-- 3
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(4,'name4','JOB1111',
	to_date('01/01/2020','dd/mm/yyyy'),20,10);


-- Відключення тригера
ALTER TRIGGER sal_check DISABLE;


/* Заборонити працювати в кожному підрозділі 
понад 6 співробітникам */
CREATE OR REPLACE TRIGGER incorrect_emp_statistic
	BEFORE INSERT OR UPDATE ON emp 
	FOR EACH ROW
DECLARE
	incorrect_emp_statistic EXCEPTION;
	emp_quantity NUMBER(4);
BEGIN
	SELECT COUNT(*) INTO emp_quantity 
	FROM emp 
	WHERE 
	    deptno = :NEW.deptno; 
	IF emp_quantity = 6 THEN 
			RAISE incorrect_emp_statistic; 
	END IF; 	
EXCEPTION
	WHEN incorrect_emp_statistic THEN 
		RAISE_APPLICATION_ERROR(-20310,'More 6 employees!');
END; 
 /
SHOW ERRORS;

-- Тест-кейс перевірки роботи тригера
-- 1
INSERT INTO Emp VALUES 
	(7910,'IVANOV','SOFT_ENG',null,TO_DATE('1981-11-17', 
	'YYYY-MM-DD'),5000,null,30);

-- Відключення тригера
ALTER TRIGGER incorrect_emp_statistic DISABLE;


/* Спроба створити тригер, який забороняє 
встановлювати працівникові зарплату,
яка перевищує середню зарплату за підрозділом, 
у якому він працює */
CREATE OR REPLACE TRIGGER avg_sal_check
	BEFORE UPDATE OF Sal ON Emp 
	FOR EACH ROW
DECLARE
	avg_sal emp.sal%TYPE;
	sal_out_of_range EXCEPTION;
	deptno_ emp.deptno%TYPE;
	sal_ emp.sal%TYPE;
BEGIN
	deptno_ := :NEW.DEPTNO;
	sal_ := :NEW.SAL;
	SELECT AVG(SAL) INTO avg_sal 
	FROM EMP 
	WHERE 
	    DEPTNO = deptno_;
	IF sal_ > avg_sal THEN 
		RAISE sal_out_of_range;
	END IF;
EXCEPTION
	WHEN sal_out_of_range THEN
		RAISE_APPLICATION_ERROR(-20301, 
			'ERROR! sal > average salary for dept = ' 
			|| deptno_
		);
END;
/
SHOW ERRORS

-- Тест-кейси перевірки роботи тригера
-- 
SELECT AVG(sal) FROM emp WHERE deptno = 10;
-- 
SELECT empno,ename,sal FROM emp WHERE deptno = 10;
-- 1
UPDATE emp SET sal = 5000 WHERE empno = 7782;
/* Результат: 
ORA-04091: table STUDENT.EMP is mutating, trigger/function may not see it
Коментарій:
1) UPDATE-запит та SELECT-запит з тригера містять 
	загальну колонку SAL 
2) У сервера Oracle немає впевненості, 
	що повинен повернути SELECT-запит:
	а) з урахуванням того, що вже оновлено?
	б) або без урахування нових змін?
*/

/* 
До мутації таблиці може призвести DML-операція, 
	що перехоплюється рядковим тригером,
	коли в тілі тригера присутні:
1) DML-операція над тією ж таблицею, 
	що й перехоплювана тригером - ефект рекурсивного виклику
2) DQL-операція над тією ж колонкою таблиці, 
	що і перехоплювана AFTER-тригером (працює до Oracle 12)
	або всіма типами тригерів (працює з Oracle 12)
	- ефект нестабільного курсору чи неоднозначної 
		відповіді на запит
	
При порушенні обмеження видається помилка
ORA-04091: table таблица is mutating,  
	trigger/function may not see it 


Вирішення проблеми мутації:
Спосіб 1. Використання тимчасової таблиці, 
	PL/SQL-таблиці чи змінної пакета. Створюються два тригери:
1) рядковий AFTER-тригер, що оновлює тимчасову таблицю
2) рядковий AFTER-тригер, що контролює основну таблицю 
	на основі даних із тимчасової.

Спосіб 2. Використання композитного (Compound) тригера,
який може одночасно містити PL/SQL-блоки
рядкового тригера та тригера рівня таблиці:
BEFORE EACH ROW, AFTER EACH ROW, BEFORE STATEMENT, 
AFTER STATEMENT
*/

/* Синтаксис композитного (Compound) тригера
CREATE [OR REPLACE] TRIGGER ім'я_тригера 
FOR INSERT|DELETE|UPDATE|UPDATE OF колонки
ON ім'я_таблиці COMPOUND TRIGGER
BEFORE STATEMENT IS 
BEGIN 
…
END BEFORE STATEMENT;
BEFORE EACH ROW IS 
BEGIN 
…
END BEFORE EACH ROW;
…
*/

/*
Додатковий ефект - скорочення часу масового (BULK) 
	внесення рядків до іншої таблиці через INSERT-операцію, 
	коли воно використовується у поєднанні 
	з BULK COLLECT та FORALL-оператором.

Змішаний тригер (Compound-тригер), захищений від мутацій таблиць.
Блоки викликаються у такому порядку:
1) BEFORE STATEMENT
2) BEFORE EACH ROW
3) AFTER EACH ROW
4) AFTER STATEMENT
*/

-- Тестовий приклад Compound-тригера
CREATE OR REPLACE TRIGGER compound_trigger_example
	FOR UPDATE OF Sal ON Emp 
/* включення інструкції COMPOUND TRIGGER */
COMPOUND TRIGGER
-- включення PL/SQL-блоку типу BEFORE STATEMENT
BEFORE STATEMENT IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('BEFORE STATEMENT');
END BEFORE STATEMENT;  
-- включення PL/SQL-блоку типу BEFORE EACH ROW
BEFORE EACH ROW IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('BEFORE EACH ROW');
END BEFORE EACH ROW;  
-- включення PL/SQL-блоку AFTER STATEMENT
AFTER STATEMENT IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('AFTER STATEMENT');
END AFTER STATEMENT;  
-- включення PL/SQL-блоку AFTER EACH ROW
AFTER EACH ROW IS
	BEGIN	
		DBMS_OUTPUT.PUT_LINE('AFTER EACH ROW');
END AFTER EACH ROW;
END;
/
SHOW ERRORS

-- Тест-кейс перевірки роботи тригера
UPDATE emp SET sal = 5000 WHERE empno = 3;

-- Видалити тригер
DROP TRIGGER compound_trigger_example;

/* Створити тригер, який забороняє 
встановлювати співробітнику зарплату,
яка перевищує середню зарплату за підрозділом, 
у якому він працює */
CREATE OR REPLACE TRIGGER avg_sal_check
	FOR UPDATE OF Sal ON Emp 
	-- включення інструкції COMPOUND TRIGGER
	COMPOUND TRIGGER
	
	avg_sal emp.sal%TYPE;
	sal_out_of_range EXCEPTION;
	deptno_ emp.deptno%TYPE;
	sal_ emp.sal%TYPE;
/* увімкнення блоку типу BEFORE EACH ROW,
в якому зберігається значення коду підрозділу */
BEFORE EACH ROW IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('BEFORE EACH ROW');
	deptno_ := :NEW.DEPTNO;
	sal_ := :NEW.SAL;
END BEFORE EACH ROW;  
/* увімкнення блоку AFTER STATEMENT,
у якому визначається середня зарплата 
для заданого підрозділу*/
AFTER STATEMENT IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('AFTER STATEMENT');
	DBMS_OUTPUT.PUT_LINE('DEPTNO=' 
		|| deptno_ || ' SAL=' || sal_
	);
	SELECT AVG(SAL) INTO avg_sal 
	FROM EMP 
	WHERE DEPTNO = deptno_;
	IF sal_ > avg_sal THEN 
		RAISE sal_out_of_range;
	END IF;
EXCEPTION
	WHEN sal_out_of_range THEN
		RAISE_APPLICATION_ERROR(-20301, 
			'ERROR! sal > average salary for dept = ' 
			|| deptno_
		);
END AFTER STATEMENT;  
END;
/
SHOW ERRORS

-- Тест-кейси перевірки роботи тригера
-- 
SELECT AVG(sal) FROM emp WHERE deptno = 10;
-- 
SELECT empno,ename,sal FROM emp WHERE deptno = 10;
-- 1
UPDATE emp SET sal = 5000 WHERE empno = 7782;
/* Результат:
ORA-20301: ERROR! sal > average salary for dept = 10
*/

-- Відключення тригера
ALTER TRIGGER avg_sal_check DISABLE;


/* 
Програмування активних БД на основі тригерів у мові PL/SQL.
Частина 3 - Автоматичне оновлення даних на основі тригерів. 
Приклади створення
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

/* Журналування дій користувачів */

-- Створення таблиці-журналу з операцій над таблицею EMP
-- DROP TABLE emp_log;
CREATE TABLE emp_log (
	new_empno	 NUMBER,	-- значення колонки EMPNO
	new_ename	 CHAR(40),	-- нове значення колонки ENAME
	new_job		 CHAR(20),	-- нове значення колонки JOB
	old_ename	 CHAR(40),	-- старе значення колонки ENAME
	old_job	 	 CHAR(20),	-- старе значення колонки JOB
	op_type	 	 CHAR(6),	-- тип операції над таблицею EMP
	user_name 	 CHAR(20),	-- ім'я користувача, який виконує операцію
	change_date  DATE  	-- час виконання операції
); 

/* Створення тригера, PL/SQL-блок якого виконується:
1) за подіями, що викликаються командами 
	INSERT, UPDATE, DELETE
2) після успішного завершення цих подій (тип AFTER)
3) для кожного рядка таблиці EMP (тип FOR EACH ROW)
*/
CREATE OR REPLACE TRIGGER emp_log
	AFTER INSERT OR UPDATE OR DELETE ON emp 
	FOR EACH ROW
DECLARE 
	op_type_ emp_log.op_type%TYPE;
BEGIN
	IF INSERTING THEN op_type_ := 'INSERT'; END IF;
	IF UPDATING THEN op_type_ := 'UPDATE';  END IF;
	IF DELETING THEN op_type_ := 'DELETE'; END IF;
	INSERT INTO emp_log VALUES (
		:NEW.empno,
		:NEW.ename,
		:NEW.job,
		:OLD.ename,
		:OLD.job, 
		op_type_,
		USER,
		SYSDATE
	);
END;
/
SHOW ERRORS

-- Тест-кейси перевірки роботи тригера
-- 1
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) VALUES(
	5,
	'name1',
	'JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),
	100,
	30);
-- 2
UPDATE emp 
SET ename = 'new name' 
WHERE 
    empno = 1;
-- 3
DELETE FROM emp 
WHERE 
    empno = 2;
-- 4
SELECT * 
FROM emp_log;

-- Видалення тригера
DROP TRIGGER emp_log;

/* Автоматичне внесення значень до колонок таблиць БД */
CREATE SEQUENCE emp_empno START WITH 1;

-- Створення тригера підтримки механізму DEFAULT SEQUENCE
CREATE OR REPLACE TRIGGER emp_default_sequence
	BEFORE INSERT ON emp
	FOR EACH ROW
BEGIN
	IF :NEW.empno IS NULL THEN
		:NEW.empno := emp_empno.NEXTVAL;
	END IF;
END;
/
SHOW ERRORS;

-- Тест-кейси перевірки роботи тригера
-- 1
INSERT INTO emp (ename,job,hiredate,sal,deptno) VALUES(
	'name4','JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),
	20,10);
-- 2
SELECT empno, ename 
FROM emp 
WHERE 
     ename = 'name4';

--
DROP TRIGGER emp_default_sequence;

/* 
Створити процедуру по генерації тригера підтримки механізму
DEFAULT SEQUENCE 
Приклад програмного коду тригера, який враховує, що:
1) таблиця emp
2) PK-колонка - empno
3) SEQUENCE - emp_empno

CREATE TRIGGER emp_default_sequence 
	BEFORE INSERT 
	ON emp 
	FOR EACH ROW
BEGIN
	if :NEW.empno IS NULL THEN
		:NEW.empno := emp_empno.nextval;
	END IF;
END;
/

*/

-- Перша спроба створення процедури
CREATE OR REPLACE PROCEDURE create_seq(
table_name varchar, pk_name varchar)
AS 
	trigger_code_str varchar(300);
BEGIN
	trigger_code_str := 'CREATE OR REPLACE TRIGGER ' 
					|| table_name 
					|| '_default_sequence BEFORE INSERT ON ' 
					|| table_name 
					|| ' FOR EACH ROW'
					|| ' BEGIN 
						 if :NEW.' 
					|| pk_name 
					|| ' IS NULL THEN :NEW.' 
					|| pk_name 
					|| ' := ' 
					|| table_name 
					|| '_' 
					|| pk_name 
					|| '.nextval; 
						END IF; 
						END; 
						/';
	dbms_output.put_line(trigger_code_str);
	EXECUTE IMMEDIATE trigger_code_str;
EXCEPTION WHEN OTHERS THEN 
	raise_application_error(-20557,'Other errors: code=' 
		|| to_char(SQLCODE) || ', msg=' || SQLERRM);
END;
/
SHOW ERRORS;

-- Спроба виконати процедуру
EXECUTE create_seq('emp','empno');
/* Результат:
ORA-20557: Other errors: code=-1031, msg=ORA-01031: 
insufficient privileges
Причина помилки: процедура створена 
за замовчуванням з "AUTHID DEFINER".
А під час виконання команд створення особливих 
об'єктів БД типу тригер
необхідна опція створення процедури "AUTHID CURRENT_USER"
*/

/* Друга спроба створення процедури.
Додавання опції AUTHID CURRENT_USER
*/
CREATE OR REPLACE PROCEDURE create_seq(
table_name varchar, pk_name varchar)
AUTHID CURRENT_USER
AS 
	trigger_code_str varchar(300);
BEGIN
	trigger_code_str := 'CREATE OR REPLACE TRIGGER ' 
					|| table_name 
					|| '_default_sequence BEFORE INSERT ON ' 
					|| table_name 
					|| ' FOR EACH ROW'
					|| ' BEGIN 
						 if :NEW.' 
					|| pk_name 
					|| ' IS NULL THEN :NEW.' 
					|| pk_name 
					|| ' := ' 
					|| table_name 
					|| '_' 
					|| pk_name 
					|| '.nextval; 
						END IF; 
						END; 
						/';
	dbms_output.put_line(trigger_code_str);
	EXECUTE IMMEDIATE trigger_code_str;
EXCEPTION WHEN OTHERS THEN 
	raise_application_error(-20557,'Other errors: code=' 
		|| to_char(SQLCODE) || ', msg=' || SQLERRM);
END;
/
SHOW ERRORS;

-- Спроба виконати процедуру
EXECUTE create_seq('emp','empno');
/* Результат: 
ORA-20557: Other errors: code=-24344, 
msg=ORA-24344: success with compilation error.
Виникла невідома помилка під час виконання динамічного запиту
*/

/* Для уточнення помилки можна виконати запит 
до таблиці помилок
*/
SELECT * 
FROM user_errors
WHERE
    type = 'TRIGGER';
/* Результат: 
PLS-00103: Encountered the symbol "/" The symbol "/" 
was ignored.
Причина помилки: Помилково додано символ "/" 
наприкінці блоку створення тригера.
А в операторі EXECUTE IMMEDIATE символи 
завершення команд не вказуються.
*/

/* Третя спроба створення процедури
з видаленим помилкового символу "/" в trigger_code_str
*/
CREATE OR REPLACE PROCEDURE create_seq(
table_name varchar, pk_name varchar)
AUTHID CURRENT_USER
AS 
	trigger_code_str varchar(300);
BEGIN
	trigger_code_str := 'CREATE OR REPLACE TRIGGER ' 
					|| table_name 
					|| '_default_sequence BEFORE INSERT ON ' 
					|| table_name 
					|| ' FOR EACH ROW'
					|| ' BEGIN 
						 if :NEW.' 
					|| pk_name 
					|| ' IS NULL THEN :NEW.' 
					|| pk_name 
					|| ' := ' 
					|| table_name 
					|| '_' 
					|| pk_name 
					|| '.nextval; 
						END IF; 
						END;';
	dbms_output.put_line(trigger_code_str);
	EXECUTE IMMEDIATE trigger_code_str;
EXCEPTION WHEN OTHERS THEN 
	raise_application_error(-20557,'Other errors: code=' 
		|| to_char(SQLCODE) || ', msg=' || SQLERRM);
END;
/
SHOW ERRORS;


-- Успішне виконання процедури
EXECUTE create_seq('emp','empno');

-- Тест-кейси перевірки роботи тригера
-- 1
INSERT INTO emp (ename,job,hiredate,sal,deptno) VALUES(
	'name5','JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),20,10);
-- 2
SELECT empno, ename 
FROM emp 
WHERE 
    ename = 'name5';

/* Підтримка матеріалізованих представлень 
(Materialized View - MV) */

/*
Два етапи створення MV:
1) створення миттєвого знімка на основі SQL-запиту
2) забезпечення процесу узгодження 
	вмісту реальних таблиць та MV
*/

-- Створення таблиці-звіту (миттєвого знімка)
-- DROP TABLE REPORT1;
CREATE TABLE REPORT1 AS
	SELECT JOB, COUNT(JOB) AS ECOUNT FROM EMP GROUP BY JOB;

/* Створення тригера, який
спрацьовує за подіями INSERT,UPDATE,DELETE
ПІСЛЯ успішного завершення цих подій (BEFORE)
для кожного рядка таблиці EMP,
оброблюваної цими операціями (FOR EACH ROW).
Тригер оновлює вміст таблиці REPORT.
*/
CREATE OR REPLACE TRIGGER REPORT1 
	AFTER INSERT OR UPDATE OR DELETE ON EMP 
	FOR EACH ROW
DECLARE
	job_ emp.job%TYPE; 
BEGIN
	IF INSERTING THEN 
		DBMS_OUTPUT.PUT_LINE('INSERTING');
		BEGIN 
			SELECT job INTO job_ 
			FROM REPORT1 
			WHERE 
			    job = :NEW.job; 
			UPDATE REPORT1 
			SET ECOUNT = ECOUNT + 1 
			WHERE 
			    job = :NEW.job; 
			DBMS_OUTPUT.PUT_LINE('UPD=' || :NEW.JOB);
		EXCEPTION
			WHEN OTHERS THEN 
				INSERT INTO REPORT1 VALUES(:NEW.job, 1);
		END;
	END IF; 	
	IF UPDATING THEN 
		IF :NEW.job != :OLD.job THEN 
			DBMS_OUTPUT.PUT_LINE('UPDATING');
			UPDATE REPORT1 
			SET ECOUNT = ECOUNT + 1 
			WHERE 
			    job = :NEW.job;
			UPDATE REPORT1 
			SET ECOUNT = ECOUNT - 1 
			WHERE 
			    job = :OLD.job; 
		END IF;
	END IF; 
	IF DELETING THEN 
		DBMS_OUTPUT.PUT_LINE('DELETING');
		UPDATE REPORT1 
		SET ECOUNT = ECOUNT - 1 
		WHERE 
		    job = :OLD.job; 
	END IF; 
END; 
/
SHOW ERRORS;

-- Тест-кейси перевірки роботи тригера
-- Разове оновлення миттєвого знімку
DELETE FROM REPORT1;
INSERT INTO REPORT1  
	SELECT JOB, COUNT(JOB) AS ECOUNT FROM EMP GROUP BY JOB;
SELECT * FROM REPORT1;
-- 1
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) VALUES(
	5,'name5','JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),30,10);
SELECT * FROM REPORT1;
-- 2
UPDATE emp SET job = 'SALESMAN' WHERE empno = 5;
-- 3
DELETE FROM emp WHERE empno = 5;
-- 4
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) VALUES(
	8,'name1','JOB1111',
	to_date('01/01/2020','dd/mm/yyyy'),30,10);

-- відключення тригера
ALTER TRIGGER REPORT1 DISABLE;

/* «INSTEAD OF» тригер для створення 
оновлюваних представлень (VIEW)
CREATE [OR REPLACE] TRIGGER ім'я_тригера
INSTEAD OF
INSERT|DELETE|UPDATE|UPDATE OF колонки 
ON ім'я_представлення 
[FOR EACH ROW]
[DECLARE…] 
BEGIN  виконувані оператори 
[EXCEPTION обробники винятків] 
END;
*/

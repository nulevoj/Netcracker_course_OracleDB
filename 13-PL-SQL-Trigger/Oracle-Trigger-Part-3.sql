/* 
������������� �������� �� �� ����� ������� � ��� PL/SQL.
������� 3 - ����������� ��������� ����� �� ����� �������. 
�������� ���������
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

/* ������������ �� ������������ */

-- ��������� �������-������� � �������� ��� �������� EMP
-- DROP TABLE emp_log;
CREATE TABLE emp_log (
	new_empno	 NUMBER,	-- �������� ������� EMPNO
	new_ename	 CHAR(40),	-- ���� �������� ������� ENAME
	new_job		 CHAR(20),	-- ���� �������� ������� JOB
	old_ename	 CHAR(40),	-- ����� �������� ������� ENAME
	old_job	 	 CHAR(20),	-- ����� �������� ������� JOB
	op_type	 	 CHAR(6),	-- ��� �������� ��� �������� EMP
	user_name 	 CHAR(20),	-- ��'� �����������, ���� ������ ��������
	change_date  DATE  	-- ��� ��������� ��������
); 

/* ��������� �������, PL/SQL-���� ����� ����������:
1) �� ������, �� ������������ ��������� 
	INSERT, UPDATE, DELETE
2) ���� �������� ���������� ��� ���� (��� AFTER)
3) ��� ������� ����� ������� EMP (��� FOR EACH ROW)
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

-- ����-����� �������� ������ �������
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

-- ��������� �������
DROP TRIGGER emp_log;

/* ����������� �������� ������� �� ������� ������� �� */
CREATE SEQUENCE emp_empno START WITH 1;

-- ��������� ������� �������� �������� DEFAULT SEQUENCE
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

-- ����-����� �������� ������ �������
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
�������� ��������� �� ��������� ������� �������� ��������
DEFAULT SEQUENCE 
������� ����������� ���� �������, ���� �������, ��:
1) ������� emp
2) PK-������� - empno
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

-- ����� ������ ��������� ���������
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

-- ������ �������� ���������
EXECUTE create_seq('emp','empno');
/* ���������:
ORA-20557: Other errors: code=-1031, msg=ORA-01031: 
insufficient privileges
������� �������: ��������� �������� 
�� ������������� � "AUTHID DEFINER".
� �� ��� ��������� ������ ��������� ��������� 
��'���� �� ���� ������
��������� ����� ��������� ��������� "AUTHID CURRENT_USER"
*/

/* ����� ������ ��������� ���������.
��������� ����� AUTHID CURRENT_USER
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

-- ������ �������� ���������
EXECUTE create_seq('emp','empno');
/* ���������: 
ORA-20557: Other errors: code=-24344, 
msg=ORA-24344: success with compilation error.
������� ������� ������� �� ��� ��������� ���������� ������
*/

/* ��� ��������� ������� ����� �������� ����� 
�� ������� �������
*/
SELECT * 
FROM user_errors
WHERE
    type = 'TRIGGER';
/* ���������: 
PLS-00103: Encountered the symbol "/" The symbol "/" 
was ignored.
������� �������: ��������� ������ ������ "/" 
��������� ����� ��������� �������.
� � �������� EXECUTE IMMEDIATE ������� 
���������� ������ �� ����������.
*/

/* ����� ������ ��������� ���������
� ��������� ����������� ������� "/" � trigger_code_str
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


-- ������ ��������� ���������
EXECUTE create_seq('emp','empno');

-- ����-����� �������� ������ �������
-- 1
INSERT INTO emp (ename,job,hiredate,sal,deptno) VALUES(
	'name5','JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),20,10);
-- 2
SELECT empno, ename 
FROM emp 
WHERE 
    ename = 'name5';

/* ϳ������� �������������� ������������ 
(Materialized View - MV) */

/*
��� ����� ��������� MV:
1) ��������� �������� ����� �� ����� SQL-������
2) ������������ ������� ���������� 
	����� �������� ������� �� MV
*/

-- ��������� �������-���� (�������� �����)
-- DROP TABLE REPORT1;
CREATE TABLE REPORT1 AS
	SELECT JOB, COUNT(JOB) AS ECOUNT FROM EMP GROUP BY JOB;

/* ��������� �������, ����
��������� �� ������ INSERT,UPDATE,DELETE
ϲ��� �������� ���������� ��� ���� (BEFORE)
��� ������� ����� ������� EMP,
����������� ���� ���������� (FOR EACH ROW).
������ ������� ���� ������� REPORT.
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

-- ����-����� �������� ������ �������
-- ������ ��������� �������� �����
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

-- ���������� �������
ALTER TRIGGER REPORT1 DISABLE;

/* �INSTEAD OF� ������ ��� ��������� 
����������� ������������ (VIEW)
CREATE [OR REPLACE] TRIGGER ��'�_�������
INSTEAD OF
INSERT|DELETE|UPDATE|UPDATE OF ������� 
ON ��'�_������������� 
[FOR EACH ROW]
[DECLARE�] 
BEGIN  ��������� ��������� 
[EXCEPTION ��������� �������] 
END;
*/

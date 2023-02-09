/* 
������������� �������� �� �� ����� ������� � ��� PL/SQL.
������� 2 - ������� ��������� �������� �����. 
�������� ������������
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

/* ����������� ������� ������ ���������� �������� */

-- ������ �������� �����, �� �� � ���������� � ����� �������
DELETE FROM dept;

-- ������� ������� �� ������������ ���������� ���������
CREATE OR REPLACE TRIGGER dept_del_cascade
  AFTER DELETE ON dept
  FOR EACH ROW
BEGIN
  DELETE FROM emp
	WHERE emp.deptno = :OLD.deptno;
END;
/
SHOW ERRORS

-- ����-����� �������� ������ �������
-- 1
DELETE FROM dept;
-- 2 
SELECT * 
FROM emp;
--
ROLLBACK;

-- ³��������� �������
ALTER TRIGGER dept_del_cascade DISABLE;

/***
������������ ���������-����������� ��������
���������� �������� �� ����� ���������
***/

/* �������� ������� �������� ���������� �������� �� ����� ���������:
1) ������ ���������� ��������� PK-������� � ��'����� � FK-��������
	SQLCODE=-2292: integrity constraint violated - child record found
2) ������ ��������� FK-������� �������� PK-�������
	SQLCODE=-2291: integrity constraint violated - parent key not found
*/

-- ������������ ���������-����������� ��������
-- ������ ���������� ��������� PK-������� � ��'����� � FK-��������
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
		-- ���� ����� �� ������� ���, ��������� ������ �������
		WHEN NO_DATA_FOUND THEN 
			NULL;
END;
/
SHOW ERRORS

-- ����-���� �������� ������ �������
DELETE FROM dept;

-- ������������ ���������-����������� ��������
-- ������ ��������� FK-������� �������� PK-�������
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

-- ����-����� �������� ������ �������
-- 1
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(1,'name1','JOB1',
	to_date('01/01/2020','dd/mm/yyyy'),100,60);
-- 2
INSERT INTO emp (empno,ename,job,hiredate,sal,deptno) 
	VALUES(1,'name1','JOB1',to_date('01/01/2020','dd/mm/yyyy'),100,10);

/******* ������������ �������� ������ ���������� �������� *******/

/* ���������� ������� ����� �������, �� ���������� ���������� ��������� */

-- ��������� ������� � ����������� ���������� ������� � ����� ������
CREATE TABLE job_classification (
	job	 	VARCHAR(10) PRIMARY KEY,
	min_sal number(4,2),
	max_sal number(4,2)
);

INSERT INTO job_classification VALUES ('JOB1',10,30);
INSERT INTO job_classification VALUES ('JOB2',20,60);

/* ��������� �������, PL/SQL-���� ����� ����������:
1) �� ������, �� ������������ ��������� INSERT, UPDATE;
2) ����� ������� ����������� ��� ���� (BEFORE);
3) ��� ������� ����� ������� EMP, �� ������������ ���� ��������� (FOR EACH ROW)
*/
CREATE OR REPLACE TRIGGER sal_check 
	BEFORE INSERT OR UPDATE ON emp 
	FOR EACH ROW
DECLARE
	min_sal_ job_classification.min_sal%TYPE;
	max_sal_ job_classification.max_sal%TYPE;
	sal_out_of_range EXCEPTION;
BEGIN
	/* �������� ��������� �� ������������
	����� ��� ���� ������ ��������� � ������� 
	JOB_CLASSIFICATION � MIN_SAL � MAX_SAL */
	SELECT min_sal, max_sal INTO min_sal_, max_sal_ 
	FROM job_classification
	WHERE TRIM(job) = :NEW.job;
	/* ���� ����� ����� ��������� ����� �� �����,
	�� ��������� ���� �������� ������������,
	���������� ��������� ��������,
	� �������� �����������. */
	IF (:NEW.sal < min_sal_ OR :NEW.sal > max_sal_) THEN 
		RAISE sal_out_of_range;
	END IF;
EXCEPTION
	-- ������� ���������� �� ������������� ��������� ������ �����������
	WHEN sal_out_of_range THEN
		RAISE_APPLICATION_ERROR(-20300, 
				'salary ' 
				|| TO_CHAR(:NEW.sal)
				|| ' out of job classification '
				|| RTRIM(:NEW.JOB)|| ' for employee ' 
				|| :NEW.ename
		);
	/* ������� ����������, ���� ������� ������ � ��������
		������� � ������� JOB_CLASSIFICATION
	*/
	WHEN NO_DATA_FOUND THEN
		RAISE_APPLICATION_ERROR(-20301, 
				'incorrect job ' || :NEW.job);
END;
/
SHOW ERRORS

-- ����-����� �������� ������ �������
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


-- ³��������� �������
ALTER TRIGGER sal_check DISABLE;


/* ���������� ��������� � ������� ������� 
����� 6 ������������ */
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

-- ����-���� �������� ������ �������
-- 1
INSERT INTO Emp VALUES 
	(7910,'IVANOV','SOFT_ENG',null,TO_DATE('1981-11-17', 
	'YYYY-MM-DD'),5000,null,30);

-- ³��������� �������
ALTER TRIGGER incorrect_emp_statistic DISABLE;


/* ������ �������� ������, ���� ��������� 
������������� ����������� ��������,
��� �������� ������� �������� �� ���������, 
� ����� �� ������ */
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

-- ����-����� �������� ������ �������
-- 
SELECT AVG(sal) FROM emp WHERE deptno = 10;
-- 
SELECT empno,ename,sal FROM emp WHERE deptno = 10;
-- 1
UPDATE emp SET sal = 5000 WHERE empno = 7782;
/* ���������: 
ORA-04091: table STUDENT.EMP is mutating, trigger/function may not see it
���������:
1) UPDATE-����� �� SELECT-����� � ������� ������ 
	�������� ������� SAL 
2) � ������� Oracle ���� ����������, 
	�� ������� ��������� SELECT-�����:
	�) � ����������� ����, �� ��� ��������?
	�) ��� ��� ���������� ����� ���?
*/

/* 
�� ������� ������� ���� ��������� DML-��������, 
	�� �������������� �������� ��������,
	���� � �� ������� �������:
1) DML-�������� ��� �� � ��������, 
	�� � ������������� �������� - ����� ������������ �������
2) DQL-�������� ��� �� � �������� �������, 
	�� � ������������� AFTER-�������� (������ �� Oracle 12)
	��� ���� ������ ������� (������ � Oracle 12)
	- ����� ������������ ������� �� ������������ 
		������ �� �����
	
��� �������� ��������� �������� �������
ORA-04091: table ������� is mutating,  
	trigger/function may not see it 


�������� �������� �������:
����� 1. ������������ ��������� �������, 
	PL/SQL-������� �� ����� ������. ����������� ��� �������:
1) �������� AFTER-������, �� ������� ��������� �������
2) �������� AFTER-������, �� ��������� ������� ������� 
	�� ����� ����� �� ���������.

����� 2. ������������ ������������ (Compound) �������,
���� ���� ��������� ������ PL/SQL-�����
��������� ������� �� ������� ���� �������:
BEFORE EACH ROW, AFTER EACH ROW, BEFORE STATEMENT, 
AFTER STATEMENT
*/

/* ��������� ������������ (Compound) �������
CREATE [OR REPLACE] TRIGGER ��'�_������� 
FOR INSERT|DELETE|UPDATE|UPDATE OF �������
ON ��'�_������� COMPOUND TRIGGER
BEFORE STATEMENT IS 
BEGIN 
�
END BEFORE STATEMENT;
BEFORE EACH ROW IS 
BEGIN 
�
END BEFORE EACH ROW;
�
*/

/*
���������� ����� - ���������� ���� �������� (BULK) 
	�������� ����� �� ���� ������� ����� INSERT-��������, 
	���� ���� ��������������� � ������� 
	� BULK COLLECT �� FORALL-����������.

������� ������ (Compound-������), ��������� �� ������� �������.
����� ������������ � ������ �������:
1) BEFORE STATEMENT
2) BEFORE EACH ROW
3) AFTER EACH ROW
4) AFTER STATEMENT
*/

-- �������� ������� Compound-�������
CREATE OR REPLACE TRIGGER compound_trigger_example
	FOR UPDATE OF Sal ON Emp 
/* ��������� ���������� COMPOUND TRIGGER */
COMPOUND TRIGGER
-- ��������� PL/SQL-����� ���� BEFORE STATEMENT
BEFORE STATEMENT IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('BEFORE STATEMENT');
END BEFORE STATEMENT;  
-- ��������� PL/SQL-����� ���� BEFORE EACH ROW
BEFORE EACH ROW IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('BEFORE EACH ROW');
END BEFORE EACH ROW;  
-- ��������� PL/SQL-����� AFTER STATEMENT
AFTER STATEMENT IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('AFTER STATEMENT');
END AFTER STATEMENT;  
-- ��������� PL/SQL-����� AFTER EACH ROW
AFTER EACH ROW IS
	BEGIN	
		DBMS_OUTPUT.PUT_LINE('AFTER EACH ROW');
END AFTER EACH ROW;
END;
/
SHOW ERRORS

-- ����-���� �������� ������ �������
UPDATE emp SET sal = 5000 WHERE empno = 3;

-- �������� ������
DROP TRIGGER compound_trigger_example;

/* �������� ������, ���� ��������� 
������������� ����������� ��������,
��� �������� ������� �������� �� ���������, 
� ����� �� ������ */
CREATE OR REPLACE TRIGGER avg_sal_check
	FOR UPDATE OF Sal ON Emp 
	-- ��������� ���������� COMPOUND TRIGGER
	COMPOUND TRIGGER
	
	avg_sal emp.sal%TYPE;
	sal_out_of_range EXCEPTION;
	deptno_ emp.deptno%TYPE;
	sal_ emp.sal%TYPE;
/* ��������� ����� ���� BEFORE EACH ROW,
� ����� ���������� �������� ���� �������� */
BEFORE EACH ROW IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('BEFORE EACH ROW');
	deptno_ := :NEW.DEPTNO;
	sal_ := :NEW.SAL;
END BEFORE EACH ROW;  
/* ��������� ����� AFTER STATEMENT,
� ����� ����������� ������� �������� 
��� �������� ��������*/
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

-- ����-����� �������� ������ �������
-- 
SELECT AVG(sal) FROM emp WHERE deptno = 10;
-- 
SELECT empno,ename,sal FROM emp WHERE deptno = 10;
-- 1
UPDATE emp SET sal = 5000 WHERE empno = 7782;
/* ���������:
ORA-20301: ERROR! sal > average salary for dept = 10
*/

-- ³��������� �������
ALTER TRIGGER avg_sal_check DISABLE;


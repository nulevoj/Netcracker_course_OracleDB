/* 
������: "Data Manipulation Language (DML) � ���������� �������� � ���� Oracle" 
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- ������� 1 �������������� ���� INSERT-��������, ������������ ������ �����������
-- � ������ �������, ���� ����� �� ���� �������������.
-- ����� �������� = 'Odessa Office' � ������������ � ���� ������ ���, 
-- �� � ������� ���� ��������.
-- ����������: ��'� = 'IVANOV', ������ = 'STUDENT', ���� ����������� = ������� ����,
-- �������� = 0, ����� = 0, ��������� � ���������� � ��'�� KING.

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

-- 2. �������� �� ������� �� ����������: ename, dname, sal.
-- ��'� ����� ������� �� ���� ��'����� � ��'�� ������
-- ��������� �� ��������, � ������ ����������� ��������� �����
-- ��� �������� ��������������� �������� 1 = 0 ��� ���������� ������ �������.

-- 2.1
CREATE TABLE MANAGER AS 
SELECT ename, dname, sal FROM emp e, dept d
		WHERE e.deptno = d.deptno AND 1=0;   
CREATE TABLE SALESMAN AS 
SELECT ename, dname, sal FROM emp e, dept d
		WHERE e.deptno = d.deptno AND 1=0;  

-- 2.2 ����� ������� ������ � �� ������� ��� ���� ����������� ���� �����	
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

-- ������� 3 ���� ������ �� �������� �����������
-- � ������� = 7698 �� ��� �, �� � ����������� � ������� = 7499.
UPDATE  emp
  SET  (job, deptno) = 
				  (SELECT job, deptno
                          FROM    emp
                          WHERE   empno = 7499)
  WHERE   empno = 7698;

-- ������� 4 ��� ��� �����������, �� �������� � ��� DALLAS
-- �������� �������� �� 10%

-- 4.1 - ������ �� ������������ ���������
UPDATE EMP E SET SAL = SAL * 0.1 + SAL
WHERE EXISTS
	(
		SELECT NULL FROM DEPT D, LOC L
		WHERE D.DEPTNO = E.DEPTNO
			AND D.LOCNO = L.LOCNO
			AND L.LNAME = 'DALLAS'
	);

-- 4.2 - ������ �� ����������� ���������� ��������
UPDATE 
	( 
		SELECT E.EMPNO,E.SAL
		FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
				JOIN LOC L ON (D.LOCNO = L.LOCNO)
		WHERE L.LNAME = 'DALLAS'
	)
	SET SAL = SAL * 0.1 + SAL;
  		
-- ������� 5 �������� ��� ����������� �� �������� SALES
DELETE FROM EMP
 WHERE DEPTNO =  
		       (SELECT DEPTNO
 			        FROM DEPT
 			        WHERE DNAME ='SALES');

ROLLBACK;

-- ������� 6 ������ ������ ��������� ��� ����������� �� �������� SALES
-- ������������ ��������� ������� �� �������
DELETE FROM	(
			SELECT * FROM EMP 
			WHERE DEPTNO = 
				(SELECT DEPTNO FROM DEPT
					WHERE DNAME ='SALES')
			);

ROLLBACK;
				
-- ������� 7 �������� �� ��������, �� �� ����� �����������.
-- ������������ ������������ ��������.
DELETE FROM DEPT D
	WHERE NOT EXISTS  
		       (SELECT DEPTNO
 			    FROM EMP E
 			    WHERE E.DEPTNO = D.DEPTNO);

ROLLBACK;

/* ������� 8. �������� INSERT/UPDATE ����� � �������� MERGE
*/

-- 8.1 �������� ���� ������� emp
CREATE TABLE EMP_ALL AS
	SELECT * FROM EMP;
	
-- 8.2 ������ ���� �������� ��� ����������� ��
UPDATE emp SET deptno = 20;

-- 8.3 �������� �����������, ����� ����� ���� ���� ���������� � �
DELETE FROM emp
	WHERE ename like 'A%';

-- 8.4 ³������� ������ ���� �������� ������ ����������� �����������,
-- � ����� �������� ��������� �����������
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
		

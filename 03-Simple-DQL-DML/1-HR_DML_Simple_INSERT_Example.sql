/* 
�������� ������� INSERT-������
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- ������  ������ INSERT-�������
INSERT INTO	table [(column [, column...])]
	VALUES (value [, value...]);

/* ���������� ��� SQL-������ 
- ������� SQL �� ������ �� �������. 
- ������� SQL ������ ���������� � ������ ��� �������� �����.
- ������ ����� �� ������ ������������ �� �������������.
- ������� ������ ������ ������������ � ����� ������.
- ³������ ���������������� ��� ���������� ���������� ���������� ���� 
�� ���� ���������� (Code Conventions).
- ������� SQL ����������� �������� (;)
*/

-- �������� ����� � �������� ��� ������� ���� ��������
INSERT INTO Loc 
VALUES (1,'ODESA');

-- �������� ����� � �������� �� ����������� ���� ��������
INSERT INTO Loc 
    (locno, lname) 
VALUES (2,'KYIV');

-- ������ �������� ����� � �������� ��������� ���������� �����
INSERT INTO Loc 
    (locno, lname) 
VALUES (1,'NEW_ODESA');

-- ������ ���������� �������� ����� �� �������� ��������� ������������ �����
INSERT INTO Loc 
   (locno, lname) 
VALUES (3,'ODESA');

-- �������� ����� � �������� �� ����������� ���� ��������
INSERT INTO Loc 
   (locno, lname) 
VALUES (3,'NEW_ODESA');

-- �������� ����� � ���������, ������������ � ������� ODESA
INSERT INTO Dept 
   (deptno, dname, locno) 
VALUES (1,'NC OFFICE',1);

-- ������ �������� ����� � ���������, ������������ � ��������� ������� 
-- (FK �� �������� � �������� PK)
INSERT INTO Dept 
   (deptno, dname, locno) 
VALUES (2,'NC OFFICE 2',4);

-- ��������� ���� ������� opendate - ���� �������� ��������
ALTER TABLE Dept ADD opendate date;

-- �������� ����� � ��������� � ������������ ����� �������� (�������� opendate)
INSERT INTO Dept 
   (deptno, dname, locno) 
VALUES (2,'NC OFFICE 2',2);

-- �������� �� ������ ����� � ��������� � ������������ ����� ��������
INSERT INTO Dept 
   (deptno, dname, locno, opendate) 
VALUES (3,'NC OFFICE 3',2,NULL);

-- ������ �������� �� ������ ����� � ��������� � ����� ��������
INSERT INTO Dept 
   (deptno, dname, locno, opendate) 
VALUES (4,'NC OFFICE 4',2,'01/09/2021');

-- ������������ �������� ������� �������� ���� = 'dd/mm/yyyy'
ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy';

-- �������� �� ������ ����� � ��������� � ����� ��������
INSERT INTO Dept 
   (deptno, dname, locno, opendate) 
VALUES (4,'NC OFFICE 4',2,'01/09/2021');

-- �������� ����� �� ������������, � ����� ���� �������� �� �������� 
-- (���� ������������ �������� NULL)
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (1,'KING','DIRECTOR',NULL,'01/01/2020',5000,NULL,1);

-- �������� ����� �� ������������, � ����� � ������� (KING) �� ������
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (2,'TOD','MANAGER',1,'01/02/2020',4000,1000,1);

-- �������� ����� �� ������������, � ����� � �������
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (3,'SCOTT','MANAGER',1, '15/02/2020',3000,NULL,3);

-- �������� ����� �� ������������, � ����� � ������� �� ������
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (4,'BLAKE','SALESMAN',3,'10/03/2020',3500,500,3);

-- �������� ����� �� ������������, � ����� � ������� �� ������
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (5,'ALLEN','SALESMAN',3,'20/04/2020',3000,500,3);


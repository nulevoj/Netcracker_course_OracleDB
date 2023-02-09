/* 
������ "���������� ��������� ������������� � ���� Oracle"
*/

SET LINESIZE 2000
SET PAGESIZE 100

/*

�� ���� ����������� (SEQUENCE)?
1) ����������� ������ ������� �����
2) ��������������� ��� ���������� ������� ��������� ������
3) ������� ��� ������� �� ���������� ���������
��� �������� ���������� ��������� � ���'���

*/

/* ������� CREATE SEQUENCE */

CREATE SEQUENCE sequence
	[INCREMENT BY n]
	[START WITH n]
	[{MAXVALUE n | NOMAXVALUE}]
	[{MINVALUE n | NOMINVALUE}]
	[{CYCLE | NOCYCLE}]
	[{CACHE n | NOCACHE}];

/*
���� ���������:
INCREMENT BY � ������� ��������
	��� ���������� ������� ����������;
MINVALUE, MAXVALUE � �������� �� ����������� ��������
	�������� �������;
START WITH � ��������� �������� �������� ��������,
	�� ������������� �������� � MINVALUE = 1;
CYCLE � ���������� ��������� �� MINVALUE
	���� ����������� �������� MAXVALUE;
CACHE - ���������� ������������ �������
	� ���������� ���'�� ��� ����������� �������,
	�� ������������� ���������� 20 �������
*/

-- ��������� ��������� ������������� �������� PK locno
SELECT MAX(locno) FROM Loc; -- ������� = 3

-- C�������� ���������� ��� ��������� ��������� ������� 
-- ��������� � MAX(locno) + 1, ��������� 3+1 = 4
CREATE SEQUENCE loc_locno START WITH 4;

-- ��������� ��������� ������������� �������� PK deptno
SELECT MAX(deptno) FROM Dept; -- ������� = 4

-- ��������� ���������� ��� ��������� ���������
-- ������� �������������� ��������
CREATE SEQUENCE dept_deptno START WITH 5;

/* 

������������� NEXTVAL � CURRVAL:
1) NEXTVAL ������� ���� ����������� ����� �����������
2) NEXTVAL ������� �������� �������� ��� ������� �������,
   ����� ���� ���� ���������� ��� ����������.
3) CURRVAL ������ ������� ����������� ����� �����������
4) NEXTVAL �� ���� ���������� ���� � ���,
   ��� � CURRVAL ���������� ��������
5) ���������� �������� ��������� � ���������� ���'��,
   �� ������������� ��� 20 ����������� ������� ����������

*/

-- ��������� ������ �������� ����������
SELECT dept_deptno.NEXTVAL FROM DUAL;

-- ��������� ��������� �������� ����������
SELECT dept_deptno.CURRVAL FROM DUAL;

/*
��������� ������� �����������:

1) ��������� ������� ����������� � ���'�� �������� �������� �������� ������� �� ��� �������.
2) �������� � ������������� ��������� ���:
	- ���������� �������� ������� �� ������������ ������� ROLLBACK,
	- ������������ ����������� � �������� ��������
3) ���� ����������� ���� �������� � ���������� NOCACHE,
	�� �������� �������� ����� ��������,
	����������� ����� �� ������� USER_SEQUENCES
4) ��� �������� (�� ������������� = 20 �������)
	������� LAST_NUMBER ������ �� ������� ��������,
	� �������� ���� 20 ���������.
5) �� ��������� ��������� LAST_NUMBER
	������ ��������, ���������� �����������
	���� ������� �������� ������� NEXTVAL

*/

SELECT SEQUENCE_NAME,LAST_NUMBER
	FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME IN ('LOC_LOCNO','DEPT_DEPTNO'); 

/* 
���� ����������� �������� ���������� � Oracle < 12c ����������, 
������� �����:
1) ��������� ��������� ����������
2) �������� ��������� ���������� � ����� ���������� ���������
*/

DROP SEQUENCE loc_locno;
CREATE SEQUENCE loc_locno START WITH 20;

-- ���� ����������� �������� ���������� � Oracle 12
ALTER SEQUENCE loc_locno RESTART START WITH 20;

-- �������� ���� �������
INSERT INTO Loc (locno, lname )
	VALUES (loc_locno.NEXTVAL, 'ODESA 2');

-- �������� ������ �������� � ���� �������
INSERT INTO dept (deptno, dname, locno )
	VALUES (dept_deptno.NEXTVAL, 'NEW DEPART 2',
			loc_locno.CURRVAL);

-- ��������� ��������� ������������� �������� PK empno
SELECT MAX(empno) FROM Emp;

-- ��������� ���������� ��� ��������� ���������
-- ������� �������������� �����������
CREATE SEQUENCE emp_empno START WITH 6;

/*
��������� ������ �����������:
��'� = 'PETROV', ������ = 'STUDENT', ���� ����������� = ������� ����,
�������� = 0, ����� = 0, ������� = 'KIEV'
����� �������� = 'Odesa NC'
*/

INSERT INTO Loc (locno, lname )
	VALUES (loc_locno.NEXTVAL, 'KIEV');
INSERT INTO dept (deptno, dname, locno)
    VALUES (dept_deptno.NEXTVAL, 'Odesa NC', 
			loc_locno.CURRVAL);
INSERT INTO emp (empno, ename, job, hiredate, sal, 
				comm, deptno)
    VALUES (emp_empno.NEXTVAL, 'PETROV', 'STUDENT', 
				SYSDATE-40, 100, 0, dept_deptno.CURRVAL);

/* ������������ ���������� � ����� DEFAULT ��� Oracle < 12c � ����������.
������� ��������������� ������ ��� ������������� ������� ����������.
Oracle >= 12c ������� ��� �������:
1) ���������� ��������� �� ������ DEFAULT
2) ������������ ����������� IDENTITY �������
*/

-- Oracle >= 12c. ���������� ��������� �� ������ DEFAULT
ALTER TABLE Loc MODIFY 
	(locno number DEFAULT loc_locno.nextval NOT NULL);

INSERT INTO Loc (lname) VALUES ('TEST');
SELECT * FROM Loc;

 
/* Oracle >= 12c. 
IDENTITY-�������, ����������:
1) ����������� ����� ��� �������� ������� ��� �������� ���� �������
2) ��� ����� ������� INTEGER, LONG, NUMBER
3) �� ����� �� ����������, ���������� ����� create sequence,
   IDENTITY-��������� �������� ����������
   ��������� ������� �������� ���� �����������
������ ���������� �������:
GENERATED [ ALWAYS | BY DEFAULT [ON NULL]]
AS IDENTITY [ ( ����� ) ]

1) GENERATED ALWAYS AS IDENTITY -
   ��������� ��������� ������ ��������,
   �� ���������� �� ������ ������ ���������
2) GENERATED BY DEFAULT AS IDENTITY -
   ��������� ��������� ������ ��������,
   ���� ��� ������� ����� �� ��������� �������� ������� IDENTITY
3) GENERATED BY DEFAULT ON NULL AS IDENTITY -
   ��������� ��������� ������ ��������,
   ���� ��� ������� ����� �������� IDENTITY-������� = NULL
	
*/

-- ������� ������ IDENTITY-������� ���� GENERATED ALWAYS
DROP TABLE identity_demo;
CREATE TABLE identity_demo (
    id NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1,
    description VARCHAR2(10)
);

INSERT INTO identity_demo(description)
VALUES('Oracle1');
	
SELECT * 
FROM identity_demo;

-- ������ ����������� �������� �������� ���� �����������
INSERT INTO identity_demo(id,description)
	VALUES(2,'Oracle2'); 
-- ��������� ������� - ERROR at line 1: 
-- ORA-32795: cannot insert into a generated always identity column

-- ���� ���� IDENTITY-������� �� ��� GENERATED BY DEFAULT
-- � ����� ���������� ���������
ALTER TABLE identity_demo 
	MODIFY ( id NUMBER GENERATED BY DEFAULT AS IDENTITY START WITH 2);	
  
INSERT INTO identity_demo(description)
	VALUES('Oracle2');
SELECT * 
FROM identity_demo;

INSERT INTO identity_demo(id,description)
	VALUES(2,'Oracle3');

SELECT * 
FROM identity_demo;

-- ���� ���� IDENTITY-������� �� GENERATED BY DEFAULT ON NULL
-- � ����� ���������� ���������
ALTER TABLE identity_demo 
	MODIFY ( id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 4);

INSERT INTO identity_demo(description)
	VALUES('Oracle');
SELECT * 
FROM identity_demo;

INSERT INTO identity_demo(id,description)
	VALUES(2,'Oracle');

SELECT * 
FROM identity_demo;
INSERT INTO identity_demo(id,description)
	VALUES(NULL,'Oracle');

SELECT * 
FROM identity_demo;

-- ��������� ����� �������
ALTER TABLE identity_demo 
	DROP COLUMN id;

-- ��������� ���� ������� 
ALTER TABLE identity_demo 
	ADD id NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1;

/* 
������������� �������� �� �� ����� ������� � ��� PL/SQL.
������� 1 - ����� ����������-���������� �� ��������� �������. 
�������� ���������
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

COL LOCNO FORMAT 99999
COL LNAME FORMAT A20
COL DEPTNO FORMAT 99999
COL DNAME FORMAT A20
COL EMPNO FORMAT 99999
COL ENAME FORMAT A20

/*
������ � �� ��������� PL/SQL, ��� ���������� �����������, 
	���� ����������� ����� ������ ����, 
	��� ���������� ��������� ��䳺�.
��䳿, � ����� ����� ��'����� �������:
- ���������� DML (INSERT, UPDATE ��� DELETE)
- ���������� DDL (CREATE TABLE, ALTER TABLE)
- ��䳿 �� (���� ��� ����� ����������� � �������, 
	��� ������� ��� ������� ��, ��� �������� �������)

������ ������������ DML-�������
1) ��������� ��������������� �������� �� ���� ���� 
	������������ ��;
2) ������������ �������� ������ ��������� ������� ��;
3) ������������ �������� ������ ������� �����;
4) ����������� �������� ������� � ������� ������� �� 
	( ��������� �������������� �������������� ������������ );
5) ������������ ���������� ������������ (���������� �������).

³������� �� ��������� �� ����������� �����������
1) ������� ������� ��������� � ���� ��������: 
	Oracle ������� �� ����������� � ������� �� ����� ����
2) ������� �� ����� ������ ���������
3) ������������ ������� ����� ����������� 
	�� ������������ ���������
*/

/* ��������� DML-�������
CREATE [OR REPLACE] TRIGGER ��'�_������� 
BEFORE|AFTER
INSERT|DELETE|UPDATE|UPDATE OF �������_�������
ON ��'�_������� 
[FOR EACH ROW]
[WHEN(�)]
[DECLARE�] 
BEGIN  
������� ��������� 
[EXCEPTION ��������� �������] 
END;

1) BEFORE|AFTER - ������� ������ ����������� ������� � 
	�� �� ���� ������� �������� ��䳿
	BEFORE-������ � ���������� ������
	AFTER-������ � ����������-����������� ������
	г�� ������� ��䳿 ����� ���������� 
	�� ��������� ��������� OR, 
	��������� DELETE OR INSERT
2) UPDATE OF ������� - ������, ��'������ � ����������� 
	UPDATE ���� ���� ������ 
	��� ������ ��������, ��������� ������
3) ON ��'�_������� - ������ ������ DML ������� ���� 
	��'������ � ���� ��������
4) FOR EACH ROW � �������� ������, ���� ���� ����������� 
	��� ������� ����� ������� ��� �������� DML-�������
	���� ���������� FOR EACH ROW ������� ����������� 
	������ ���� ������� (table level trigger) - 
	������ ���� ����������� ����� �� ������ ���� 
	��� �������� DML-�������
*/

/* ������������ NEW �� OLD
��� ������� ��������� ������� ��������� ���� PL/SQL 
	������� �� �������� �� ��������� ������, 
	�� ������������ ������ �� ������ � 
	������������ NEW �� OLD
�� ��������� ��������� �������� ������, ���� ��������� 
	� ��������� %ROWTYPE, 
	�� ����������� �� ����� �������, � ���� ��'����� ������,                  
	���������: NEW.�������, OLD.�������
��� �������, ��'������ � ����������� INSERT, 
	��������� OLD �� ������ �����, 
	��� �� ������� ������ ������� � �������� ������� ����
��� �������, ��'������ � ����������� DELETE, 
	������������ ����� ��������� OLD, 
	� ��������� NEW ���������� ������, 
	��� �� ����� �����������
*/

/* ���������� WHEN
�������� ������ ����� ��� ������� ����������� 
	��������� ���� �������
���� ����������������� ����� � �������� ��������
����� ������ ������ ������ ����������� � �����
����� ���������������� NEW �� OLD ������� ������� ���������
����� ��������������� ����� �������� �������
���������������� ������� ��������� �������
�������: WHEN (NEW.������� != OLD.�������)
*/

/* ������������ NEW �� OLD � PL/SQL-�����
� PL/SQL-����� ��������� �� NEW-����� �� OLD-�����  
	����� ������� �������� ����������: :NEW �� :OLD
��� �������, ���� ���������� UPDATE-�������, 
	������������ ����� ���������:
	- OLD-����� ������ ������ �������� ����� ������� 
	�� ���������;
	- NEW-������ ������ ��������, �� ������ 
	� ����� ������� ���� ���������
�������� ���� OLD-������ ������� ��������
�������� ���� NEW-������ ����� �������� � ������ 
	���� BEFORE
NEW �� OLD ������� ���������� � ����� ��������� 
	���������� ��� ��������, 
	�� ������������ � �������, ����� �� ����� ����
*/

/* ���������� DML-������
Oracle ������� ���� ������� ��� ���������� DML-������, 
	����������� ������, 
	���������� �������� ���� ������, ���� ��������� �� 䳿, 
	���'���� � ������ DML-���������
1) INSERTING � ������� TRUE, ���� ������ �������� � ������� 
	�� ������� ������ � �������, � ���� �� ���'������
	�� FALSE � ������������ �������
2) UPDATING � ������� TRUE, ���� ������ �������� � ������� 
	�� ��������� ������ � �������, 
	� ���� �� ���'������ �� FALSE � ������������ �������
3) UPDATING(�������) � �������� ��������� ������� � �������
4) DELETING � ������� TRUE, ���� ������ �������� � ������� 
	�� ��������� ������ � �������, � ���� �� ���'������ 
	�� FALSE � ������������ �������
*/

/* ���������� ���������� ��� �������
- �� ������������� ������� � �� ������� ����������� 
	������������ � ������ �������� ����������, 
	���� � ����� ������� ������� ��������������� COMMIT/ROLLBACK
- ��� ��������� ������� ���������� �� ����, ��������� �, 
	�� ���� ������� DML-��������, ��� ��������� ������
- ������, � ����� ����������� DML-�������, 
	���� ��������� ������������� ����� DML-������
- ���� ��� ���� �������� ��䳿 ��������� 
	����� ������ �������, ��: 
	(�� ���� ���� < 11) ������� ����������� �� ���������, 
	FOLLOWS � ������������ ������� ������� ���������� �������
*/

/* ��������� ���������
������ ����� ��������:
CREATE OR REPLACE TRIGGER ��'�_������� �

������ ����� ��������:
DROP TRIGGER ��'�_�������;

������ ����� ��������������:
ALTER TRIGGER ��'�_������� DISABLE;

������ ����� �������� ����������:
ALTER TRIGGER ��'�_������� ENABLE;
*/

/* ��������� ������� ��������� ���������� PL/SQL-����� */

-- �������� ����������� ������ ��� �������� ����������� 
-- �� ����� ���� ��������� ����� � ������� LOC
CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT ON loc
BEGIN
	DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
END;
/

-- ����-���� �������� ������ �������
-- 1
INSERT INTO loc VALUES (2,'ODESA');
ROLLBACK;

/* ������ �������� ����������� ������ ��� ��������� 
����������� �� �����
���� ��������� ����� �� ������� LOC ������������ STUDENT
*/

CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT ON loc
	WHEN (USER = 'STUDENT')
BEGIN
	DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
END;
/
-- ������� 
-- ORA-04077: WHEN clause cannot be used with table level triggers

/* ������ ��������� ������������ ������� 
��� ��������� ����������� �� �����
���� ��������� ����� �� ������� LOC ������������ STUDENT
*/
CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT ON loc
BEGIN
	DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
END;
/

-- ����-���� �������� ������ �������
-- 1
INSERT INTO loc VALUES (2,'ODESA');
ROLLBACK;

/* �������� ����������� ������ ��� ��������� 
����������� �� ����� ���� ���������, 
���� �� ��������� ����� ������� LOC
*/
CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT OR UPDATE OR DELETE ON loc
BEGIN
	IF INSERTING THEN 
		DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
	ELSIF UPDATING THEN 
		DBMS_OUTPUT.PUT_LINE('UPDATING LOC ... ');
	ELSIF DELETING THEN 
		DBMS_OUTPUT.PUT_LINE('DELETING LOC ... ');
	END IF;	
END;
/
SHOW ERRORS

-- ����-����� �������� ������ �������
-- 1
INSERT INTO loc VALUES (2,'ODESA');
-- 2
UPDATE loc SET lname = 'NEW ODESA' WHERE locno = 2;
-- 3
DELETE FROM loc WHERE locno = 2;

/* �������� ����������� ������ ��� ��������� 
����������� �� �����
���� ���������, ���� �� ��������� ����� ������� LOC
����������� ������ ���������� �� ������� ����� � �������
*/
CREATE OR REPLACE TRIGGER loc_control_quantity
	AFTER INSERT OR UPDATE OR DELETE ON loc
DECLARE
		loc_quantity loc.locno%TYPE;
BEGIN
	SELECT COUNT(locno) INTO loc_quantity
		FROM loc;
	DBMS_OUTPUT.PUT_LINE('Loc quantity = ' || loc_quantity);
END;
/
SHOW ERRORS

-- ����-���� �������� ������ �������
-- 1
UPDATE loc SET lname = 'ODESA' WHERE locno = 2;
/* ���������: ����������� ������� loc_control_quantity 
���������� ������,��� �� ���� �������� �������:
Loc quantity = 6
UPDATING LOC ... 
*/

/* ��������� ������, ��� �� ����������� �������
������������ ������ ���� ������� loc_control_after
*/
CREATE OR REPLACE TRIGGER loc_control_quantity
	AFTER INSERT OR UPDATE OR DELETE ON loc
	FOLLOWS loc_control_after
DECLARE
		loc_quantity loc.locno%TYPE;
BEGIN
	SELECT count(locno) INTO loc_quantity
		FROM loc;
	DBMS_OUTPUT.PUT_LINE('Loc quantity = ' || loc_quantity);
END;
/
SHOW ERRORS

-- ����-���� �������� ������ �������
-- 1
UPDATE loc SET lname = 'ODESA' WHERE locno = 1;
/* ���������: ����������� ������� loc_control_quantity 
���������� ������:
UPDATING LOC ... 
Loc quantity = 6
*/

-- �������� ���������� ������ ��� �������� ������������ STUDENT 
-- �������� ����� �� ������� LOC
CREATE OR REPLACE TRIGGER loc_control_before_insert
	BEFORE INSERT ON loc
	FOR EACH ROW
	WHEN (USER = 'STUDENT')
BEGIN
	RAISE_APPLICATION_ERROR(-20500,
							'User ' 
							|| USER || ' can not INSERT'
	);
END;
/

-- ����-���� �������� ������ �������
-- 1
INSERT INTO loc VALUES (2,'ODESSA2');

/* �������� ���������� ������ ��� �������� 
������������ STUDENT 
���������� �������� �������� 
������� LNAME ������� LOC �� ����� ��������
*/
CREATE OR REPLACE TRIGGER loc_control_before_update_lname
	BEFORE UPDATE OF lname ON loc
	FOR EACH ROW
	WHEN (USER = 'STUDENT' AND NEW.lname = OLD.lname)
BEGIN
	RAISE_APPLICATION_ERROR(-20501,
							'User ' 
							|| USER 
							|| ' can not UPDATE SUCH VALUE OF lname'
	);
END;
/

ALTER TRIGGER loc_control_quantity DISABLE;
ALTER TRIGGER loc_control_before_insert DISABLE;
ALTER TRIGGER loc_control_after DISABLE;

-- ����-���� �������� ������ �������
UPDATE loc SET lname = 'ODESSA' WHERE lname = 'ODESSA';

-- �������� ���������� ������ ��� �������� ������������ STUDENT 
-- ���������� �������� �������� ������� ������� LOC ���� 17:00
CREATE OR REPLACE TRIGGER loc_control_before_update_time
	BEFORE UPDATE ON loc
	FOR EACH ROW
	WHEN (USER = 'STUDENT')
BEGIN
	IF TO_NUMBER(TO_CHAR(SYSDATE,'HH24')) >= 17 THEN 
		RAISE_APPLICATION_ERROR(-20501,'User ' 
								|| USER 
								|| ' can not UPDATE after 17:00'
		);
	END IF;
END;
/

-- ����-���� �������� ������ �������
UPDATE loc 
SET lname = 'ODESA' 
WHERE lname = 'ODESA';

-- ³�������� ������ loc_control_before_update_time
ALTER TRIGGER loc_control_before_update_time DISABLE;

-- ����-���� �������� ������ �������, �� ����������
UPDATE loc 
SET lname = 'ODESA' W
HERE lname = 'ODESA';

-- �������� ������ loc_control_before_update_time
ALTER TRIGGER loc_control_before_update_time ENABLE;

-- �������� ������ loc_control_before_update_time
DROP TRIGGER loc_control_before_update_time;

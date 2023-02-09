/* 
������������� �������� �� �� ����� ������� � ��� PL/SQL.
������� 4 - DDL-������� �� DB-�������. 
�������� ���������
*/

SET LINESIZE 2000
SET PAGESIZE 60

/* ������������ DDL-���� - ����, ��� ������ ��
������� �� ��������� �������� CREATE, ALTER, DROP

ϳ� ��� ������� DDL-��䳿 ������� ������� ���������:
ORA_SYSEVENT � ��� ��䳿, �� ��������� ������ ������� 
	(CREATE, ALTER, DROP);
ORA_LOGIN_USER � ��'� �����������;
ORA_DATABASE_NAME � ��'� ��;
ORA_CLIENT_IP_ADDRESS � IP-������ �볺���;
ORA_DICT_OBJ_TYPE � ��� ��'���� ��, 
	���'������� � DDL-�����������, 
	�� ��������� ������ ������� (���������, TABLE, INDEX);
ORA_DICT_OBJ_NAME � ��'� ��'���� ��
*/

/* ��������� ��������� ������� �� DDL-��䳿 

CREATE [OR REPLACE] TRIGGER ��'�_�������
BEFORE|AFTER
��'�_DDL_��������
ON ��'�_�����.SCHEMA 
[WHEN(�)]
[DECLARE�]
BEGIN
 ��������� ���������
[EXCEPTION ��������� �������]
END;
*/

/* ������� ������������ DDL-���� */

-- �������� ������� ��������� DDL-����
-- DROP TABLE who_created_object;
CREATE TABLE who_created_object (
	who_done_it VARCHAR2(30),
    when_created DATE,
    obj_name VARCHAR2(30),
    obj_type VARCHAR2(30)
);

-- �������� ������ ��������� ���� ��������� ��'����
-- DROP TRIGGER track_created_objects;
CREATE OR REPLACE TRIGGER track_created_objects
	AFTER CREATE ON STUDENT.SCHEMA
BEGIN
	INSERT into who_created_object VALUES(
		ORA_LOGIN_USER, 
		SYSDATE, 
		ORA_DICT_OBJ_NAME, 
		ORA_DICT_OBJ_TYPE);
END;
/
SHOW ERRORS;

-- ����-����� �������� ������ �������
-- 1 �������� �������
-- DROP TABLE TEST3;
CREATE TABLE TEST3 ( 
	ID INTEGER, 
	NAME VARCHAR2(10)
);
-- 2 ��������� ������� ��������� ����
SELECT * 
FROM who_created_object;

/* ������������ ���� ��:
LOGON � �� ��� ������� ������ Oracle;
LOGOFF � ��� ����������� ��������� ������ Oracle;
STARTUP � ��� ������� ��;
SHUTDOWN � ��� ����������� ������� ��; 
SERVERERROR � � ��� ���������� ������� Oracle.
*/

/* ������� ������������ ���� �� */

-- �������� ������� ��������� ����
-- DROP TABLE database_audit;
CREATE TABLE database_audit (
	user_name varchar(20),
	logon_on_time date
);

-- �������� ������ ��������� ����
-- DROP TRIGGER database_audit;
CREATE OR REPLACE TRIGGER database_audit
	AFTER LOGON ON DATABASE
BEGIN
	INSERT INTO database_audit VALUES(USER, SYSDATE);
END;
/
SHOW ERRORS;

-- ����-����� �������� ������ �������
-- 1 ����� �� �������� ����� ������������

-- 2 ��������� ������� ��������� ����
SELECT * 
FROM database_audit;



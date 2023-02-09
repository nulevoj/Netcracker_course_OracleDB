/* 
������ "�������� ���������, ������� ����� PL/SQL � ���� Oracle".
��������

*/

/* 
��������� ��������� � �� ������ ���� ����������, ��������� ����� PL/SQL.
��������� ���������� � ��� �����, ���� � ���������� ����������.
��������� ��������� ���� ���������� SQL-��������� �� ����������� ������ � ��������.
��������� ��������� ����� ��������� � ���� ��������� ���������, ��������� ������� 
	��� �������, � ����� ������������� � ����� ���������� SQL*Plus.
*/

/* ��������� ��������� ���������� � ���� �������� ������: 
1) ��������� ������ � ����
	- ��'� ���������
	- ���� �� ������� �� �������� ����� (�������� ���������)
2) ҳ�� ��������� � �� ���� PL/SQL-����
��������, �� ��������� �� ��� ������� ���������, ����������� ���������� �����������
*/

/* ��������� ��������� PL/SQL
CREATE PROCEDURE ��'� 
[(��������, [���������] 
IS
[����������]
BEGIN
���������, �� �����������
[EXCEPTION
��������� �������]
END [��'�];
*/

/* �������� ��������� ���������� ��������
increase_prices 
increase_prices (percent_increase NUMBER)
increase_salary_find_tax
 (increase_percent IN NUMBER := 7,
  sal IN OUT NUMBER, tax OUT NUMBER)
1) ��������� increase_percent �������� �������� �� �������������, �� ������� 7 
2) ���� ����� � �������� �� ������ ���� ������������ ������: ����� ������� 
	��� ��������� ��� ����� NUMBER, ��� �� NUMBER(10,2)
*/

/* ����� ��������� IN
����� IN ������, �� �� ��� ������� ��������� ���� ������� � ����� 
	��������� ������ ��������, ��� ����� ��������� �� ����� �������� 
	�������� ��� ����-���� ����� ������� ������������ ����.
��� ����� ��������������� �� �������������.
�� ��������� �������� ���� ��������� �����, ������ ��� �������������� �����.
*/

/* ����� ��������� OUT
����� OUT ������, �� ��������� ���� ��������������� 
	��� �������� �� ��������, ����� ��� ���������� �������� 
	� �� ��������, � ��� ���� ���� ���������.
��� �������� ��������� �� ����� ���������� �������� �� �������������. 
	���� ����� ������ �������� ����� � �� ������.
��������� ��������, �� ������� ����������� ��������� ���������, �� ���� ������.
*/

/* ����� ��������� IN OUT
����� IN OUT ������, �� �������� ��������� ����� ���������� 
	� ������ � ��������� �� ����� �������, �� �������.
��� ��������� � ������� IN OUT �� ����� ���������� �������� �� �������������.
��������� ��������, �� ������� ����������� ���������, �� ���� ������.
*/

/* ��������� ��������� ���������
1) ������ ���������
	CREATE PROCEDURE ���������_��������� IS ���_���������
2) ��������� �� ������
	CREATE OR REPLACE ���������_��������� IS ���_���������
� ��� ���������� ������� ���������, ���������� ��� ������� ����� �������� �������� SHOW ERRORS;
*/

/* ������ ��������� ���������
1) ��������� ������
	EXECUTE my_first_proc;
2) � ��� �����
   BEGIN
	my_second_proc(2,3);
   END;
*/

/* ��'�������� ���������� �� ��������� ���������
��'�������� �� ��������: ��������� �������� ����������� � ���������� ������
	EXECUTE my_first_proc (��������� ��������1, ��������� ��������2);
��'�������� �� ��'��: ��������� �������� ����������� � ���������� ����
	EXECUTE my_first_proc (���������� ��������2 => ��������� ��������2, ���������� ��������1 => ��������� ��������1);
������ ��'��������
*/

SET SERVEROUTPUT ON

-- 1 --------------------------------------------
CREATE OR REPLACE PROCEDURE combine_and_format_names 
	( first_name_inout IN OUT VARCHAR2,
		last_name_inout IN OUT VARCHAR2,
		full_name_out OUT VARCHAR2,
		name_format_in IN VARCHAR2:='LAST, FIRST'
	)
IS
BEGIN
	first_name_inout:=UPPER(first_name_inout); 
	last_name_inout:=UPPER(last_name_inout);
	IF name_format_in='LAST, FIRST'	THEN
		full_name_out:=last_name_inout || ', ' ||
		first_name_inout;
	ELSIF name_format_in='FIRST, LAST' THEN
		full_name_out:=first_name_inout || ', ' || 
		last_name_inout;
	END IF;
END;
/

-- 2 ������� ������� ��������� ���������
DECLARE
	first_name_inout varchar2(30);
	last_name_inout varchar2(30);
	v_full_name varchar2(30);
BEGIN
	first_name_inout := 'Sidorov';
	last_name_inout := 'Ivan';
	COMBINE_AND_FORMAT_NAMES(first_name_inout,
		last_name_inout,v_full_name,'LAST, FIRST');
	DBMS_OUTPUT.PUT_LINE(v_full_name);
END;
/

-- 3 ����� ������� ��������� ���� ���������
CREATE OR REPLACE PROCEDURE combine_and_format_names 
	( first_name_in IN VARCHAR2,
		last_name_in IN VARCHAR2,
		full_name_out OUT VARCHAR2,
		name_format_in IN VARCHAR2:='LAST, FIRST'
	)
IS
	first_name_out VARCHAR2(30);
	last_name_out VARCHAR2(30);
BEGIN
	first_name_out:=UPPER(first_name_in); 
	last_name_out:=UPPER(last_name_in);
	IF name_format_in='LAST, FIRST'	THEN
		full_name_out:=last_name_out || ', ' || first_name_out;
	ELSIF name_format_in='FIRST, LAST' THEN
		full_name_out:=first_name_out || ', ' || last_name_out;
	END IF;
	dbms_output.put(full_name_out);	
END;
/

-- ��������� ���������� ��� ������� � SQLPlus
show errors;

-- 4 ������� ������� ��������� ���������
DECLARE
	v_full_name varchar2(30);
BEGIN
	combine_and_format_names('Sidorov','Ivan',
			v_full_name,'LAST, FIRST');
	DBMS_OUTPUT.PUT_LINE(v_full_name);
END;
/
 
/* ��������� ������� PL/SQL
������� PL/SQL ����� �� ��������� PL/SQL: ���� ����� �� ��������� �� ���
�� ����� �� ������� ���������, �� � ������� ����������, ������ ������� 
	������ � �������� ���������, ����� �� ���������� � ����� ��� 
	������� �� �������� �� �������������, �� ������������ ����� ��� ���������
��'�������� ��������� � ���������� ��������� ������� � �� ��������, � �� ������
*/

/* ��������� ������� PL/SQL
CREATE FUNCTION ��'� [(��������, [���������])
RETURN ���_�����_��_������������
IS
[����������]
BEGIN
���������, �� �����������
[EXCEPTION
��������� �������]
END [��'�];
*/

/* ��������� ��������� �������
1) CREATE FUNCTION ���������_������� IS ���_�������
2) CREATE OR REPLACE ���������_������� IS ���_�������
*/

/* ������ ��������� �������
BEGIN
  DBMS_OUTPUT.PUT_LINE(my_first_func);
END;

*/

-- 5  ������� � ������ ��������� �������
CREATE OR REPLACE FUNCTION f_combine_and_format_names ( 
    first_name_in IN VARCHAR2,
    last_name_in IN VARCHAR2,
    name_format_in IN VARCHAR2:='LAST, FIRST'
)
RETURN VARCHAR2
IS
	first_name_out VARCHAR2(30);
	last_name_out VARCHAR2(30);
	full_name_out VARCHAR2(60);
BEGIN
	first_name_out:=UPPER(first_name_in); 
	last_name_out:=UPPER(last_name_in);
	IF name_format_in='LAST, FIRST'	THEN
		full_name_out:=last_name_out || ', ' || first_name_out;
	ELSIF name_format_in='FIRST, LAST' THEN
		full_name_out:=first_name_out || ', ' || last_name_out;
	END IF;
	RETURN full_name_out;
END;
/
SHOW ERROR;

-- 6 ������� ������� ��������� ������� �� ��������� ������� SQL*Plus EXECUTE
EXECUTE DBMS_OUTPUT.PUT_LINE(f_combine_and_format_names('Sidorov','Ivan','LAST, FIRST'));
		

-- 7 ������� 2 � ������ ��������� �������
CREATE OR REPLACE FUNCTION GET_COUNT_EMP ( v_job emp.job%TYPE )
RETURN NUMBER
IS
	sql_str VARCHAR2(500);
	count_emp NUMBER;
BEGIN
	BEGIN
		sql_str := 'SELECT count(*) FROM emp WHERE job = :1';
		EXECUTE IMMEDIATE sql_str INTO count_emp USING IN v_job; 
		RETURN count_emp;
	EXCEPTION
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Error in query:' || sql_str);
	END;
END; 
/ 

-- ������ ��������� ������� �� ������ PL/SQL-�����
EXEC DBMS_OUTPUT.PUT_LINE('Count=' || GET_COUNT_EMP('CLERK'));

-- ������ ��������� ������� ��� �������� ���������� ���������
DELETE FROM loc where lname = 'NEW_YORK';
/* ���������� ���������:
ERROR at line 1:
ORA-02292: integrity constraint 
(STUDENT.DEPT_LOCNO_FK) violated - child record found
*/

/* 8 ��������� ���� (�������) �� ����������� � ������� ���� ������.
��� ����� ���������� ��������� ���������� ������ ��������,
������������ � ����� ���
*/
CREATE OR REPLACE FUNCTION drop_city( city_name loc.lname%TYPE)
RETURN loc.locno%TYPE
IS
	TYPE LocList IS TABLE OF loc.locno%TYPE;
	loc_list LocList;
	TYPE DeptList IS TABLE OF dept.dname%TYPE;
	dept_list DeptList;
BEGIN
	BEGIN
	/* ��������� ������ �� ����������� ������� ������� � �������� */
	DELETE FROM loc WHERE lname = city_name
		RETURNING locno BULK COLLECT INTO loc_list;
	IF SQL%ROWCOUNT = 0 THEN RETURN -1;
	ELSE 
			RETURN loc_list(1);
	END IF;
	EXCEPTION 
		WHEN OTHERS THEN
		  DBMS_OUTPUT.PUT_LINE('Location id #');
		  SELECT dname
				BULK COLLECT INTO dept_list
				from dept d join loc l on (d.locno = d.locno)
				where l.lname = city_name;
			FOR i IN dept_list.FIRST .. dept_list.LAST
			LOOP
				DBMS_OUTPUT.PUT_LINE(dept_list(i));
			END LOOP;
			RETURN -2;
	END; 
END;
/
show errors;

-- ������� ������� ������� �� ������ PL/SQL-�����
EXEC DBMS_OUTPUT.PUT_LINE(drop_city('NEW_YORK'));

-- 9 �� ���� �������
CREATE SEQUENCE users_user_id;
DROP TABLE users;
CREATE TABLE users (
	user_id number(4) PRIMARY KEY,
	user_name varchar(30) UNIQUE NOT NULL,
	password varchar(30) NOT NULL
);

/* ������������ ������� add_user
����� ���������:
1) user_name - ��'� �����������:
	����� �������:
		- ���������� � ��������� �����;
		- ������� ����� �� ����� 30 �������.
2) password - ������ �����������:
	����� �������:
		- ������� ����� �� ����� 8 �������.
��������, �� �����������:
	>0 	- ����������� ������ ��������
	-1 	- ��'� ����������� ���������� � �����
	-2	- ������� ����� � ������� ����� 8 �������
	-3	- ���������� � ����� ��'�� ��� ����
*/

CREATE OR REPLACE FUNCTION add_user ( 	
    user_name IN users.user_name%TYPE,
    password IN users.password%TYPE
)
RETURN users.user_id%TYPE
IS
	user_id users.user_id%TYPE;
	res NUMBER(1);
	user_name_first_letter exception;
	password_length exception;
BEGIN
	/* �������� �����: 
	����� user_name ���������� � ��������� ����� */
	SELECT count(1) INTO res FROM DUAL 
		WHERE REGEXP_LIKE(user_name,'^[a-zA-Z]\D*');
	DBMS_OUTPUT.PUT_LINE('res=' || res);
	IF res = 0 THEN 
	    user_id := -1; 
		RAISE user_name_first_letter; 
	END IF;
	/* �������� �����: 
	������� ����� password �� ����� 8 �������*/
	IF LENGTH(password) < 8 THEN 
	    user_id := -2; 
		RAISE password_length; 	
	END IF;
	/* ��������� ���������� �������� user_id */ 
	SELECT users_user_id.nextval INTO user_id from dual;
	/* �������� ������� ������� user_id,user_name,password � ������� users */
	INSERT INTO users VALUES (user_id,user_name,password);
	RETURN user_id;
EXCEPTION
	WHEN user_name_first_letter THEN
		RAISE_APPLICATION_ERROR(-20551,
			'user_name: first symbol must be a letter');
	WHEN password_length THEN
		RAISE_APPLICATION_ERROR(-20552,
			'password: length >= 8 symbols');
	WHEN others THEN
		RETURN -1;
END;
/

show errors;

/* TestCase �1.
user_name = user1
password = 12345678

���������� ���������:
1) ����� � ������������ "User added with user_id = 1"
2) �� ������� ������� �� ����� select * from users where user_id = 1;
*/
DECLARE
	user_id users.user_id%TYPE;
	user_name users.user_name%TYPE;
	password users.password%TYPE;
BEGIN
	user_name := 'user1';
	password := '12345678';
	user_id := add_user(user_name,password);
	DBMS_OUTPUT.PUT_LINE('User added with user_id = ' || user_id);
END;
/

/* TestCase �2.
����� ���������:
user_name = 1user2
password = 12345678

���������� ���������:
����� � ������������ ��� �������:
ERROR at line 1:
ORA-20555: user_name: first symbol must be a letter
*/
DECLARE
	user_id users.user_id%TYPE;
	user_name users.user_name%TYPE;
	password users.password%TYPE;
BEGIN
	user_name := '1user2';
	password := '12345678';
	user_id := add_user(user_name,password);
END;
/

/* TestCase �3.
����� ���������:
user_name = user2
password = 1234567

���������� ���������:
����� � ������������ ��� �������
ERROR at line 1:
ORA-20552: password: length >= 8 symbols
*/
DECLARE
	user_id users.user_id%TYPE;
	user_name users.user_name%TYPE;
	password users.password%TYPE;
BEGIN
	user_name := 'user2';
	password := '1234567';
	user_id := add_user(user_name,password);
	DBMS_OUTPUT.PUT_LINE('User added with user_id = ' || user_id);
END;
/

/*
������ "������ ��������� SQL-�������� � ���� Oracle".
������� 2 - ������� ���� SQL-������. 
	���� 1 - "Query Parsing"
*/

/*
���� 1 - "Query Parsing" ������ ��� �����:
1) ������������ ����� SQL-������ (Syntax Check) 
	��� �������� ����������� ���� ������
2) ����������� ����� SQL-������ (Semantic Check) 
	��� �������� �����������:
	- ���� ��'���� ��:
		- �������, 
		- �������, 
		- �������;
	- ���� �����:
		- ������� ��������� � �������� �������;
		- ��������� � ��������� ��������� 
			��������� WHERE-�����;
	- ������� ������� �� ��'���� ��
3) ����� ������������� SQL-������ (Shared Pool Check):
	1.1) ���-�������� ����� SQL-������ ����������� ��
		���-����������, �� ���� ����� ��������� 
		���	��������� SQL-������;
	�) ���-�������� ���������� �� ����� ������ 200 ������� �����,
		���� �� ������������ ���������� ����� SQL-������,
		������ �� ���� ��������� �� �������� ���糿 ���-�������,
		���� ��� ����� ������� SQL-������ ���������� ����������;
	�) �������� ����� ���� ��������� �����:
		- ����� ������� ������ �� ��������� �������; 
		- ����� �������� ������ �� PL/SQL-��������/�������;
		- ������������ Bind-������;	
	1.2) ���� ���-�������� �� ��������, 
		��� Parsing = "Hard Parse" �� ������� �� ����� 4,
		������ - Parsing = "Soft Parse" �� ������� �� 3-�� �����,
		���� �� ����� ����������� ���������� 2-�� ����� ���
		SQL-������, ���� ��� �����������
*/

/********************** SQL-����� �� ������ *********************

������ � �� ��������� ����� � SGA, ���:
1) ����������� ��� �������� �������� �� ��� PL/SQL:
	- ������� �������;
	- ����� �������;
2) ����������� � �������� SQL-������ ����������� 
	(Private SQL Area)��� ������� ������;
3) ���������� �� SQL ������� �������� ������� 
	( Shared SQL Area) ��� �������� ������;
4) ���������� � ������� ���� ����:
	- Parent-������;
	- Child-������.

������ ����� �������� ����� ������� SQL-������:
1) �������� �������: �������� �������� SQL ������;
2) SQL Parsing ������� (Parse cursor) 
	�� ���� �� Soft-Parse �� Hard-Parse;
3) ���������� �������� ������ (Output Variables)  
	��� DML-������ INSERT/DELETE/UPDATE �� ������ RETURNING;
4) ��'�������� ������� ������ (Bind Input Variables);
5) ��������� SQL-������ ������� (Execute cursor)
6) ��������� ����� ������� (Fetch cursor)
7) �������� �������: 
	- �������� Private SQL Area;
	- ���������� Shared SQL Area.

*/


/**************** ���������� Parent-������� ******************

Parent-������ �� ������� ����������:
- ������ ��������� ������������� SQL-������;
- ������ ���� ����� � SQL-�������;
- ��� SQL-������ � ��������� ������ 
	(� ����������� ������� �������)
	����� ���� parent-������;
- ����������� �� ��� ����� SQL-������,
	� �� ���-��������;
- ���'������ � �� ����� ����� child-��������;
- ���� ������� ��������� � ��������� ������� v$sqlarea ���������:
	- sql_id - ��������� �������������
	- sql_text - ����� �� �������
	- executions - ������� SQL-������, �� ����������� ������
	- version_count - ������� child-�������
*/

/* ������� 4-� SQL-������ � ��������� ����������� ��������� */
SELECT * FROM emp WHERE empno = 1234;
select * from emp where empno = 1234;
SELECT * FROM emp WHERE empno=1234;
SELECT * FROM emp WHERE empno = 1234;

/* �������� ��� ��� parent-�������,
����� SQL-������ ���� ������ ��������� ������� 1234 */
col sql_text FORMAT A50
SELECT 
    sql_id, 
	hash_value,
    sql_text, 
	executions
FROM v$sqlarea
WHERE 
    sql_text LIKE '%1234';

/* ���������:
SQL_ID        SQL_TEXT                               EXECUTIONS
------------- -------------------------------------- ----------
az5j7hwrjhgb6 select * from emp where empno = 1234       1
5b5bfb9hxk2z5 SELECT * FROM emp WHERE empno = 1234       2
f9d17huzkz979 SELECT * FROM emp WHERE empno=1234         1

��������: � 4-� ��������� ������ ���� 2 ������ ����� 
	�������� �����, �� �������������� ��������� Parent-������,
	�� ������������� ��������� EXECUTIONS=2,
*/


/* ���� ��������� ��������� ����� SQL-������ ����� �������:
ALTER SESSION SET cursor_sharing = <���>,
�� ��� - �� �������� ��������� ����� SQL-������:
	exact ( �� �������������) - ����� ���������� ���� �����;
	force - �������� ������������ ������� ����.
*/
ALTER SESSION SET cursor_sharing=force;

/* �������� ��� SQL-������, �� �����������
���� ��������� ��������� empno
*/
SELECT * FROM emp WHERE empno = 1;
SELECT * FROM emp WHERE empno = 2;

/* ����������� ���� ��������� Parent-������*/
SELECT 
    sql_id, 
    sql_text, 
	executions
FROM v$sqlarea
WHERE 
    sql_text LIKE '%empno = %';
	
/*
���������:
SQL_ID        SQL_TEXT                                   EXECUTIONS
------------- ------------------------------------------ ----------
fqsqtbx489d38 SELECT * FROM emp WHERE empno = :"SYS_B_0"     2

��������: �������� ���� Parent-������, ����:
	- ������� ��������������� �������� Bind-����� "SYS_B_0";
	- ��'���� ��� SQL-������, �� ����� ������ ���-�����������.
*/

/**************** ���������� Child-������� ******************

Child-������ �� ������� ����������:
- ���������� �� ���� Parent-������;
- ������ �������� ���� ��������� SQL-������;
- ���� ������� ��������� � ��������� ������� v$sql ���������:
	- sql_id - ��������� ������������� Parent-�������
	- child_number - ��������� ����� Child-������� � ����� Parent-�������
	- optimizer_ - ��������� ���������� SQL-������;
	- plan_hash_value - ��� �������� ��������� �����.
*/


/* ��� child-������� ���� �������� ��������� ����, ����������: 
- parent-������;
- ���-�������� ����������� ����� ���������� �������;
- �������������� ����� ����������
*/

/* ���������� ��� �������� ��������� ������ SQL-������ 
"SELECT count(*) FROM emp"
��� � ������ ����������� ���������� SQL-������:
1) ALTER SESSION SET optimizer_mode = all_rows;
2) ALTER SESSION SET optimizer_mode = first_rows_1;
*/

ALTER SESSION SET optimizer_mode = all_rows;
SELECT count(*) FROM emp;

ALTER SESSION SET optimizer_mode = first_rows_1;
SELECT count(*) FROM emp;

/* ����������� ���� ��������� child-������� */
SELECT sql_id, child_number, optimizer_mode, plan_hash_value
FROM v$sql
WHERE sql_text = 'SELECT count(*) FROM emp';

/* ���������:
SQL_ID        CHILD_NUMBER OPTIMIZER_ PLAN_HASH_VALUE
------------- ------------ ---------- ---------------
d146gxvav359r            0 ALL_ROWS          40514612
d146gxvav359r            1 FIRST_ROWS        40514612

���������:
1) �������� ��� Child-������� �� ������ Parent-�������, 
2) ������ Child-������ �� ������ �������� optimizer_mode
3) Child-������� ����� ��������� �������� ����
*/

/* ��� ���������� �������, ���� ��� �������� child-������ 
�� ��������������� �������� (�� ��������),
����� ���������� ���� ��������� ������� v$sql_shared_cursor,
� ���:
- ����� ������� ���'����� �� ���������� �������,
��� �� �������� �������� ������������;
- ����� ������� ������ ���� �� ���� �������:
	Y - ���������� SQL-������ �� �������� 
		�������� ��������������� ������;
	N - ���������� SQL-������ �������� 
		�������� ��������������� ������.
*/

/* �������� ���������� ������� � SQL_ID = d146gxvav359r */
SELECT *
FROM v$sql_shared_cursor
WHERE 
    sql_id = 'd146gxvav359r';


/* ������� ������������ ��������� 
�������� ������ �� ����� Bind-������ */

CREATE SEQUENCE empno_sequence START WITH 110000;

DECLARE
	v_empno emp.empno%TYPE;
	v_ename emp.ename%TYPE;
	v_job emp.ename%TYPE;
	v_hiredate emp.hiredate%TYPE;
	v_sal emp.sal%TYPE;
	sql_str VARCHAR2(500);
BEGIN
	sql_str := 'INSERT INTO emp(empno, ename, job, hiredate, sal, deptno) ' 
				|| 'VALUES(:1,:2,:3,:4,:5, :6)';
	FOR i IN 1..100 LOOP
		SELECT empno_sequence.NEXTVAL
			INTO v_empno FROM dual;
		v_ename := 'HARDING';
		v_job := 'CLERK';
		v_hiredate := to_date('01/01/1980','DD/MM/YYYY');
		v_sal := 100;
		EXECUTE IMMEDIATE sql_str USING v_empno, v_ename, v_job, v_hiredate, v_sal, 10;
	END LOOP;	
END;
/


/* �������� ������ Child-������� �� �������� SQL-������ */
SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text like 'INSERT INTO emp(empno, ename, job, hiredate%';

/* ���������:
SQL_ID        CHILD_NUMBER EXECUTIONS
------------- ------------ ----------
f7qjqs5xdn5sc            0        100

��������:
1) ��������������� ���� Parent-������ �� Child-������
2) ���� Child-������ ���� ����������� 100 ����,
�� ����� ��� ��������� ������ Hard-Parse �� 99 Soft-Parse,
*/


/*
PL/SQL bind-���� � ��������� SQL-�������. 
�������� "Bind Variable Peeking"

�������� Bind-������: 
1) ���������� ��� �� Parsing �� ������� 
	��������� �������� ����� ��������� ������
������� Bind-������: 
1) ������ ��������� �� ��������� ���� �� ��������� 
	����� ��������� �������� �������, 
	�� ������������ ������������ �� ����������� 
	� ������ ��������;
2) ��� ������, �� ����� ���������� ������� ������ �����, 
	��� �� Parsing ���� ��������� ����� ���� �� ���������, 
	���� ������������� ��������������� Bind-����
3) ��� ������, ���������� ����� ������ �����, 
	��� �� Parsing-���� < ���� �� Execution-����, 
	���� ����� �� Bind-������ ���� ��������
4) �������� ��������� ����� ������������ 
	������ Extendet Cursor Sharing ��� Adaptive Cursor Sharing,
	���� ���������� �������� (Oracle ver >= 11):
	ALTER SYSTEM FLUSH SHARED_POOL;	
*/


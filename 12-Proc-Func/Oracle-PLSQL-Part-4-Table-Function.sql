/* 
������ "������� �� ������� ������� ����� PL/SQL � ���� Oracle".
��������
*/

/* ������� �������
������� ������� (Table function) � �������, �� ���������� 
	�������� ������ � ������ ��������� ������� (nested table), 
	varray-������ ��� ������� REF CURSOR.
������� ������� ������ ����������������� � SQL-����� 
	�� �������� ������� ��, ������������ ��������� ���������� ������� 
	�� �������� ����������, �� �� ����� 
	���������� �������� ���������� �������.
*/

/* ���������� ��������� �������� �������:
1) ��� ��������, �� ����������� - �������� Nested-Table-����;
2) �������� �� ��������������� �������� ������� ����, 
	������ �������: ORA-00902: invalid datatype
3) ��� ��������� ������� ����������� ���� ��������������� 
	CREATE TYPE � IS OBJECT ( � )
4) ������ ������� ������������ ��������� ������ �� �������, 
	��� � ������������� ������������ ������� TABLE, 
	���������, SELECT � FROM TABLE(��'�_�������(�));
*/

SET LINESIZE 2000
SET PAGESIZE 60
SET SERVEROUTPUT ON

/* �������� �������� ������� ��������� ������ ����������� 
	(�����, ��'�, ������), 
	��������� � ������� �� ������� �������
*/

/* ���������� ���� �����
*/
DROP TYPE Emp_short_info_List;
DROP TYPE Emp_short_info;
CREATE TYPE Emp_short_info AS OBJECT (
 empno 	NUMBER(4),
 ename 	VARCHAR(10),
 job 	VARCHAR(10)
);
/
CREATE TYPE Emp_short_info_List IS TABLE OF Emp_short_info;
/

CREATE OR REPLACE FUNCTION get_emp_list(v_deptno IN NUMBER)
RETURN Emp_short_info_List 
AS
	Emp_list Emp_short_info_List := Emp_short_info_List();
BEGIN
	-- �������� �����, ��������� ��������� �� ��������
 	SELECT Emp_short_info(empno,ename,job) -- ���������� ����� �� OBJECT-����
		 BULK COLLECT INTO Emp_list 
		 FROM emp
		 WHERE deptno = v_deptno;
	-- ��������� �������� 
	RETURN Emp_list;
END;
/
SHOW ERROR;

-- ������� ������� �������� ������� 
SELECT empno, ename, job
FROM TABLE(get_emp_list(20))
ORDER BY ename DESC;

/* �������� �������� �������, �� ������� ������� ����������������� 
����������� � �������, �� ����������� �� ������� �������� */

-- ���������� ���� �����
DROP TYPE Emp_sal_info_List;
DROP TYPE Emp_sal_info;
CREATE TYPE Emp_sal_info AS OBJECT (
	ename 	VARCHAR(10),
	sal 	FLOAT
);
/
CREATE TYPE Emp_sal_info_List IS TABLE OF Emp_sal_info;
/

CREATE OR REPLACE FUNCTION get_first_emp_list(first_elements IN NUMBER)
RETURN Emp_sal_info_List
AS
	query_str VARCHAR(1000);
	Emp_list Emp_sal_info_List := Emp_sal_info_List();
BEGIN
	-- ���������� ��������� ����� � ����������� ���� ����
	IF DBMS_DB_VERSION.VERSION < 12 THEN
			query_str := 'WITH emp_sort_sal AS
			(
				SELECT Emp_sal_info(ename, sal) -- ���������� ����� �� OBJECT-����
				FROM emp 
				ORDER BY sal DESC
			),
			emp_sort_sal_rownum AS
			(
				SELECT ROWNUM r, ename, sal from emp_sort_sal
			)
			SELECT ename, sal 
			FROM emp_sort_sal_rownum
			WHERE r <= :1';
	ELSE
			query_str := 'SELECT Emp_sal_info(ename, sal) -- ���������� ����� �� OBJECT-����
			 FROM emp 
			 ORDER BY sal DESC 
			 FETCH FIRST :1 ROWS ONLY';
	END IF;
	-- �������� ��������� �����, ��������� ��������� �� ��������
	EXECUTE IMMEDIATE query_str 
			BULK COLLECT INTO Emp_list
			USING IN first_elements;
	-- ��������� �������� 
	RETURN Emp_list;
END get_first_emp_list;
/
SHOW ERROR;

-- ������� ������� �������� ������� 
SELECT ename, sal
FROM TABLE(get_first_emp_list(5));

/* ������� (Pipelined) �������. 
�������� ��������� �������:
1) ������������ ����������������, ������������ ��������� 
	��������� �������;
2) ���������� ��������� ���������� ����� �� ���������;
3) ���������� ���� ��������� �� �����, �� �����-�������� �������� 
	�� ������������� � �����, ������������ ����� ������� �����, 
	� ������������ ���������;
4) ���������� ������ ��������� ���'�� �� ������� 
	��������� ����������� ������������ ������� � �����.
*/

/* ���������� ��������� ��������� �������:
1) �������� ���� ��������������� �������� �������������� ����;
2) � ��������� ������� ��������������� ����� ������� 
	� RETURN Nested-Table-��� PIPELINED �;
3) � �� ������� ��������������� �������� PIPE ROW (������� ��������);
4) ��������� � ������� ����������� ������ ���� ��������� 
	��������� PIPE ROW, ���� �������� RETURN �� ����'�������.
*/

/* �������� �������� ������� ��������� ������ ����������� 
	(�����, ��'�, ������), 
	��������� � ������� �� ������� �������.
��������� ������ � ������ ������ � ��������� ��������� ��������
*/
CREATE OR REPLACE PACKAGE employee_pkg IS
	-- ���������� ���� �� PL/SQL-������, �� ����������� �����������
	TYPE emp_short_info IS RECORD (
		empno 	NUMBER(4),
		ename 	VARCHAR(10),
		job 	VARCHAR(10)
	);
	TYPE Emp_short_info_List IS TABLE OF emp_short_info;
	FUNCTION get_first_emp_list(v_deptno IN NUMBER)
		RETURN Emp_short_info_List PIPELINED;
END employee_pkg;
/
SHOW ERROR;
-- ��������� ��� ������
CREATE OR REPLACE PACKAGE BODY employee_pkg IS
	FUNCTION get_first_emp_list(v_deptno IN NUMBER)
		RETURN Emp_short_info_List PIPELINED
	AS
	BEGIN
		FOR elem IN (SELECT empno,ename,job 
					FROM emp
					WHERE deptno = v_deptno) LOOP
			-- ��������� ������� �������� � �������
			PIPE ROW(elem);
		END LOOP;
	END;
END employee_pkg; 
/
SHOW ERROR;

-- ������� ������� �������� �������� �������
SELECT empno, ename, job
FROM TABLE(employee_pkg.get_first_emp_list(20))
ORDER BY ename DESC;

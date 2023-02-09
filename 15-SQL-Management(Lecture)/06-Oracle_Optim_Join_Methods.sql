/*
������ "������ ��������� SQL-�������� � ���� Oracle".
������� 6 - ������� ���� SQL-������. ���� 2-"Query Optimization".
����� ������ ������ ��'���� �� ��������� (Join Methods)
*/

SET LINESIZE 2000
SET PAGESIZE 60
SET SERVEROUTPUT ON

/*
�������� �'������� ������� "������� �����" - "Nested Loop Joins". 
����� ���������:
1) ���������� ������� ������� (outer table) � 
������� �� ������� ������ �'������� (driving table) 
�� ����� ������� (inner table).
2) ��� ������� ����� ������� ������� ����������� �� ����� 
����� �������:

�������� �'������� ������� "���������� � �������" - "Sort merge joins"
����� ��������������� ��� ����-�'������� ������� (��������� <, <=, >, >=)
��� ������� ������� "Sort merge joins" ������ �� "Nested Loop Joins".
����� ���������:
1) join key - ���������� ����� ������� �� ����������-������ 
	�'������� (���� ��� ��� ���������� ��� � ������� �� �������, 
	���� ������������);
2) Merge join - �'������� ��� ������ (merging) ������� 
	�� ������������ ����������.

�������� �'������� ������� �� ���-��������� - "Hash Join"
	��������������� ��� �'������� ������� ������ �����.

����� ���������:
1) ��� ����� � ���� ������� � ���'�� 
�������� ���-������� ����� �'������� (join key)
2) ��������� ������ ������� �� ����������� 
�� ������ � ���-�������� ��� ��������� ������������� ������ �����

*/

-- ������� ������ �� ���� �������� �'�������
SELECT e.ename, d.dname
	FROM emp e, dept d
	WHERE 
		e.deptno = d.deptno;

/* ���������:
------------------------------------------------
| Id  | Operation                    | Name    |
------------------------------------------------
|   0 | SELECT STATEMENT             |         |
|   1 |  NESTED LOOPS                |         |
|   2 |   NESTED LOOPS               |         |
|   3 |    TABLE ACCESS FULL         | EMP     |
|*  4 |    INDEX UNIQUE SCAN         | DEPT_PK |
|   5 |   TABLE ACCESS BY INDEX ROWID| DEPT    |
------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - access("E"."DEPTNO"="D"."DEPTNO")
*/

-- ��������� B-tree-������� ��� ������� deptno
CREATE INDEX deptno_index ON emp (deptno);

-- ������� ������ �� ���� �������� �'�������
SELECT e.ename, d.dname
	FROM emp e, dept d
	WHERE 
		e.deptno = d.deptno;

/* ���������:
-----------------------------------------------------
| Id  | Operation                    | Name         |
-----------------------------------------------------
|   0 | SELECT STATEMENT             |              |
|   1 |  NESTED LOOPS                |              |
|   2 |   NESTED LOOPS               |              |
|   3 |    TABLE ACCESS FULL         | DEPT         |
|*  4 |    INDEX RANGE SCAN          | DEPTNO_INDEX |
|   5 |   TABLE ACCESS BY INDEX ROWID| EMP          |
-----------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - access("E"."DEPTNO"="D"."DEPTNO")
*/

-- ������� ������ �� ����� ���������� �'�������
SELECT e.ename, d.dname, l.lname
	FROM emp e, dept d, loc l
	WHERE 
		e.deptno = d.deptno
		AND d.locno = l.locno;

/* ���������:
--------------------------------------------------
| Id  | Operation                      | Name    |
--------------------------------------------------
|   0 | SELECT STATEMENT               |         |
|   1 |  NESTED LOOPS                  |         |
|   2 |   NESTED LOOPS                 |         |
|   3 |    NESTED LOOPS                |         |
|   4 |     TABLE ACCESS FULL          | EMP     |
|   5 |     TABLE ACCESS BY INDEX ROWID| DEPT    |
|*  6 |      INDEX UNIQUE SCAN         | DEPT_PK |
|*  7 |    INDEX UNIQUE SCAN           | LOC_PK  |
|   8 |   TABLE ACCESS BY INDEX ROWID  | LOC     |
--------------------------------------------------
*/

-- ��������� B-tree-������� ��� ������� locno
CREATE INDEX locno_index ON dept(locno);

/* ���������:
-------------------------------------------------------
| Id  | Operation                      | Name         |
-------------------------------------------------------
|   0 | SELECT STATEMENT               |              |
|   1 |  NESTED LOOPS                  |              |
|   2 |   NESTED LOOPS                 |              |
|   3 |    NESTED LOOPS                |              |
|   4 |     TABLE ACCESS FULL          | LOC          |
|   5 |     TABLE ACCESS BY INDEX ROWID| DEPT         |
|*  6 |      INDEX RANGE SCAN          | LOCNO_INDEX  |
|*  7 |    INDEX RANGE SCAN            | DEPTNO_INDEX |
|   8 |   TABLE ACCESS BY INDEX ROWID  | EMP          |
-------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   6 - access("D"."LOCNO"="L"."LOCNO")
   7 - access("E"."DEPTNO"="D"."DEPTNO")
*/


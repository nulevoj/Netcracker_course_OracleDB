/* 
������ "SQL-������� � ���������� �'������� �������. Oracle-�����"

*/

SET LINESIZE 120
SET PAGESIZE 100

/*

1) Oracle ������� SQL-����� SQL-������
	� ���������� �'������� �������
2) Oracle ���������� SQL-����� �� ��� Oracle-�����

���������� Oracle-����� �'������� �������:
1) �'������� ��������������� ��� ��������� ����� � ���� �� ����� �������
2) ����� �'������� ����������� � ���������� WHERE.
3) ���� �������� ��'� ������� ����������� � ������ ��������,
	�� ��� ����������� �������� � ������ ���� �������.

*/

-- ������ SQL-������ �������� �'������� Oracle-�����
SELECT	
    table1.column, 
    table2.column
FROM 
    table1, 
    table2
WHERE
    table1.column1 OPER table2.column2;


/* ��������� �'������� - ��� "���������" �'�������

1) � Oracle-���� ��������� �'������� ��������� ���������,
	���� � WHERE-���� ��������� �������� ����� �'������� �������,
	�������� � FROM-����
2) ��� �������� ����������� �'������� � Oracle-����,
	������ �������� ����� �'������� � ���������� WHERE.

*/

-- �������� ��������� �'������� �������
SELECT 
    ename, 
	dname
FROM 
    emp, 
    dept, 
	loc;

/* ��²-�'������� ������� */

-- ���-�'������� �������
SELECT 
    e.empno, 
	e.ename, 
	e.deptno, 
	d.dname
FROM 
    emp e, 
	dept d
WHERE 
    e.deptno=d.deptno;

-- ���-�'������� ����� �������
SELECT 
    e.empno, 
	e.ename, 
	e.deptno, 
	d.dname, 
	l.locno, 
	l.lname
	FROM emp e, dept d, loc l
	WHERE 	e.deptno=d.deptno AND 
			d.locno=l.locno;

/* ����-�'������� ������� */

-- ������� ������� ����-�'������� �������
SELECT e.ename, e.sal, d.dname
	FROM emp e, dept d
	WHERE e.deptno > d.deptno;

/* ���Ͳ�ͪ �'������� �������

���������� Oracle-�����:
1) ��������������� ����������� �������� (+)
2) �������� ������������� � ���� �'�������,
���������, �������� �� ���� FK-�������
3) ���� ��������� �� ���������:
- ��� ��������� �������������� �'�������
�������� (+) ���� ����������� ��������;
- ��� ��������� ���������������� �'�������
�������� (+) ���� ���� ������;

	*/
	
-- ������� �������������� �'������� (������ �1)
SELECT 
    e.ename, 
	d.deptno, 
	d.dname
FROM emp e, dept d
WHERE
    d.deptno = e.deptno(+)
ORDER BY e.deptno;

-- ������� �������������� �'������� (������ �2)
SELECT 
    e.ename, 
	d.deptno, 
	d.dname
FROM emp e, dept d
WHERE 
    e.deptno(+) = d.deptno
ORDER BY e.deptno;

-- ������� ���������������� �'�������
SELECT 
    e.ename, 
    d.deptno, 
	d.dname
FROM 
    emp e, 
	dept d
WHERE 
    e.deptno(+) = d.deptno
ORDER BY e.deptno;

/* �����'������� ������� */

-- �������� ����� ��� ������� �����������
-- "Employee with name=<ename> works for <ename>"
SELECT 
    'Employee ' 
     || worker.ename 
	 || ' works for '
	 || manager.ename AS "Employee"
FROM 
    emp worker, 
    emp manager
WHERE 
    worker.mgr = manager.empno;


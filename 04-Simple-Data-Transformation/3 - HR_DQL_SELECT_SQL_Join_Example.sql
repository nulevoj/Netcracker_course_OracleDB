/* 
������ "SQL-������� � ���������� �'������� �������. SQL-�����"
*/

SET LINESIZE 2000
SET PAGESIZE 100

/*

���� �'������� �������:
1) ��������� �'�������
2) ���-�'�������
3) ����-�'�������
4) ������ �'�������
5) �����'�������

*/

/* ��������� �'������� - ��� "˲Ͳ��" �'�������

��������� �'������� ��������� �� �����
����������� �������, ����:
1) ����� �'������� �������
2) ����� �'������� ����������
3) � ��������� �'������� �� ����� ����� �������-��������
	�'��������� � ���� ������� ����� �������-��������

*/
-- ��������� ����������� �'������� �������
SELECT ename,dname
FROM emp CROSS JOIN dept;

/* ��²-�'������� ������� */

-- ��������� ���������� ��� ������� �� ���� �������
-- ��� ����������� KING:
-- �������� ��������� ����� � ����� �������
-- ���� 1. ��������� ���������� ��� �����������
SELECT empno, ename, deptno
FROM Emp 
WHERE 
    ename = 'KING';

-- ���� 2. ��������� ���������� ��� �������
SELECT 
    dname, 
	locno
FROM Dept 
WHERE 
    deptno = 1;
-- ���� 3. ��������� ���������� ��� �������
SELECT lname
FROM Loc 
WHERE 
    locno = 1;

-- ��������� ����� � ������������� ����'������ -
-- �������� �'������ ������� ( JOIN = INNER JOIN )
SELECT 
    emp.empno, 
	emp.ename, 
	emp.deptno, 
	dept.dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno)
WHERE 
    emp.ename = 'KING';

SELECT 
    emp.empno, 
	emp.ename, 
	emp.deptno, 
	dept.dname
FROM emp INNER JOIN dept ON (emp.deptno=dept.deptno)
WHERE 
    emp.ename = 'KING';

/* ��̲�� ���� ������� �� �� ������Ͳ��

����� ������������ ��������� �������:
1) ���� ����� ������� ������ ������ ��������
	����� SQL-������ �� ��� �� ���� �����������
2) ���� ��������� ������ ����� �������
	�� ������� ��������������,
	���� ����� ��������� ��������� � ��������� ������ ����
3) ���� ����� ������� ����� ��������� �������,
	��������� ������ ������� ������� ����
	
*/
	
-- �������� ��� ��������� ���������

-- ������ �������� ������� ��� ������� ���� �������
SELECT 
    empno, 
	ename, 
	deptno, 
	dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno);
-- ��������� ������� - ERROR at line 1: 
-- ORA-00918: column ambiguously defined

-- ��������� ������ � ����� ����������� ���� �������
SELECT 
    emp.empno, 
	emp.ename, 
	dept.deptno, 
	dept.dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno);

-- ����������� ���������� � ���� ���� �������
-- ���� ��������������� ������ '*'
-- ��� �������� ���������� ���� �������
SELECT *
FROM emp JOIN dept ON (emp.deptno=dept.deptno);

-- ������������ ��������� �������
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno=d.deptno);

-- �'������� ������� � ������������ �����������
-- ���� ����'������� - NATURAL JOIN
SELECT *
FROM emp NATURAL JOIN dept ;

-- ������ ������� ��������� � NATURAL JOIN
SELECT e.*
FROM emp e NATURAL JOIN dept d;
-- ��������� ������� - ERROR at line 1:
-- ORA-25155: column used in NATURAL join cannot have qualifier

-- ��������� ���������� ��� ������� �� ���� �������
-- ��� ����������� KING ����� ����'������� ����� �������:
-- 1) �'������� ����� ���� ������� emp �� dept
-- 2) �'����� ����� ���� �������:
-- 		- ������� �� ��������� 1-�� �'�������
-- 		- ����� loc
SELECT 
    e.empno, 
    e.ename, 
    e.deptno, 
	d.dname, 
	l.locno, 
	l.lname
FROM emp e JOIN dept d ON (e.deptno=d.deptno)
						JOIN loc l ON (d.locno=l.locno)
WHERE 
    e.ename = 'KING';
	
/* ����-�'������� �������

���������������� �������� ���������, ����� �� �������� '=' :
>
<
>=
<=
!= ��� <>

*/

-- ������� ������� ����-�'������� �������

SELECT 	
    e.ename, 
	e.sal, 
	d.dname
FROM emp e JOIN dept d ON (e.deptno > d.deptno);

/* ���Ͳ�ͪ �'������� �������

���� ���������� �'�������:
1) ���������� �'������� LEFT JOIN = LEFT OUTER JOIN -
	�) ������� �� ����� � ��� �������,
		����� ���� � ����� ������� ���� ����.
	b) ��������� ����������� �� ���������,
		���� ���� ����������� ������� � PK-��������,
		� �������� - ������� � FK-��������
2) ������������ �'������� RIGHT JOIN = RIGHT OUTER JOIN
	a) ������� �� ����� �� ����� �������,
		����� ���� � ��� ������� ���� ����.
	b) ��������� ����������� �� ���������,
		���� ������ ����������� ������� � PK-��������,
		� ���� - ������� � FK-��������
3) ��� �������� ���� �'������� � �������������

*/
	
-- ��������� ������ ��������
-- �� ����������� ������ �����������, �� �������� � ��� 
SELECT 
    d.dname, 
	e.ename
FROM dept d JOIN emp e ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- ��������� ������ �Ѳ� ��������
-- �� ����������� ������ �����������, �� �������� � ���
-- ��������� �������� ����� �� ��������� �����������
-- �� ����� ����� �'������� LEFT JOIN
SELECT 
    d.dname, 
	e.ename
FROM dept d LEFT JOIN emp e ON (d.deptno = e.deptno) 
ORDER BY d.dname;
		
-- ���������� ���������� �������,
-- ��� � ������������� �'�������� RIGHT JOIN
SELECT 
    d.dname, 
	e.ename
FROM emp e RIGHT JOIN dept d ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- ����� NULL-������� �� �������
SELECT 
    d.dname, 
	NVL(e.ename,'UNDEFINED') AS ename
FROM emp e RIGHT JOIN dept d ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- ������ ����� (����������) �'�������
-- FULL JOIN (LEFT JOIN + RIGHT JOIN)
SELECT 
    d.dname, 
	e.ename
FROM dept d FULL JOIN emp e ON (d.deptno = e.deptno) 
ORDER BY d.dname;

-- ������ �'������� � ������������ ����������� ��������� ��������
SELECT *
FROM dept NATURAL LEFT JOIN emp;
		
/* �����'������� �������

����������:
1) ��������������� ����� �������� ������� (������� ����)
	���� �������;
2) ��������������, � ���������, ���� � �������
	� FK-�������, �� ���������� �� PK-������� ���� � �������

*/

-- �������� ��� ������� ����������� �����
-- "Employee <ename> works for <ename>"
SELECT 
    'Employee ' 
	|| worker.ename 
	|| ' works for '
	|| manager.ename AS "Employee"
FROM 
    emp worker JOIN emp manager 
        ON (worker.mgr = manager.empno);


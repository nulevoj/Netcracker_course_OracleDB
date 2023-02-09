/* 
������ "SQL-������� �� ���������� ��� ���������"
*/

/*

�������� ������ � ���������:
1) ��'�������
	a) UNION ALL � ��������� ��� ����� ����� ������
		�� ���������� ����� ������
	b) UNION � ��'������� ������ �����,
		��������� � ��������� ���� ������
		� ����������� �������� (������� UNION ALL)
2) ������� - INTERSECT � ������� ������ �����,
	��������� � ��������� ���� ������
3) ������� - MINUS - ������ ������ �����,
	����� ����� � ����� ������, �� ������ � ����� ������

�������� ������ � ���������
��������� �������������� ����:
1) ��������� ��������� ���������� ����� ������ ���� ���������;
2) ����������� ���� ����� ������� ����� ���������.
*/

/* �������� UNION, UNION ALL
���������: 
<�����1> 
UNION [ALL] 
<�����2> 
UNION [ALL] 
<�����3> .....; 
������� �������� ���������� ������:
1) ����� � ������� ��������� �������� ������ �������� � ��� �������, �� ��'���������;
2) ���� ����� � ��������� �������� ����� ���� �����.
*/

-- ��������� ���������� ��� �����������:
-- 1) ��������� �� ����� MANAGER �� ��������� ����� 4000
-- ���
-- 2) ��������� �� ����� SALESMAN �� ��������� ����� 3500.
-- ������������ �������� ������
SELECT ename,job,sal FROM emp 
WHERE
	(job ='MANAGER' AND sal < 4000) 
	OR (job = 'SALESMAN' AND sal < 3500);

-- ������ �� UNION ALL. ������ �������� ���������� ��� �����������.  
select 
    ename,
	job,
	sal 
from emp 
where 
    job = 'MANAGER' and sal < 4000
UNION ALL
select 
    ename,
	job 
from emp 
where 
    job = 'SALESMAN' and sal < 3500;
-- ��������� ������� - ERROR at line 1:
-- ORA-01789: query block has incorrect number of result columns

-- ��������, ������ ��������� ������
select 
     ename,
	 job,
	 sal 
from emp 
where 
     job = 'MANAGER' and sal < 4000
UNION ALL
select 
     ename,
	 job,
	 sal 
from emp
where 
    job = 'SALESMAN' and sal < 3500;

-- ��������� ���� �����������:
-- � ��������� <= 2000 ���
-- �� ��������� >= 1500.
-- ������ �� UNION ALL.
select 
    ename,
	sal 
from emp 
where 
     sal <= 4000
UNION ALL
select 
    ename,
	sal 
from emp 
where 
     sal >= 1500;

-- ������ � UNION � ���������� ��������
select ename,sal from emp where sal <= 4000
UNION
select ename,sal from emp where sal >= 1500;

-- ��������� ����� ���������� �� ������������� �� ����������� �������� �������.
-- ��� ������� ������� ����� "�����:"
select 
    dname, 
    count(emp.empno) emp_count
from emp, dept
where 
     emp.deptno = dept.deptno
group by dname
union all
select 
    '�����:', 
    count(emp.empno)
from emp; 

-- ��������� ���� ����������� �� ��������� � ������� > 3000 �� < 4000
-- ��������������� INTERSECT
select ename 
from emp 
where 
    sal < 4000
INTERSECT
select ename 
from emp 
where 
     sal > 3000;

-- ��������� ���� ����������� �� ��������� < 4000, ��� �� > 3000
-- ��������������� MINUS
select ename 
from emp 
where  
    sal < 4000
MINUS
select ename from emp
where 
    sal > 3000;


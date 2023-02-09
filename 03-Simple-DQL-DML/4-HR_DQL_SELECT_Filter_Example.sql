/* 
�������� SELECT-������ 
� ������������ �������� "������" (������������)
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- ������  ������ SELECT-�������
SELECT [DISTINCT] {*, column [alias], ...}
FROM table
[WHERE condition(s)];

/*
SELECT - ������� ����
FROM � � �������
WHERE � �� ���������� ����� ���������
*/

/*
��������� ���������:
A = B
>
>=	
<
<=	
<> ��� !=
*/

-- ��������� ���� ����������� �� ��������� > 3000
SELECT 
    ename, 
	sal 
FROM emp 
WHERE 
    sal > 3000;

-- ��������� ���������� ��� ����������� �� �������� KING
SELECT 
    empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp 
WHERE 
    ename = 'KING';

/*
������ ���������:
BETWEEN ... AND ...
IN(list)
LIKE
IS NULL
*/


-- ��������� ���� ����������� �� ��������� � ������� �� 3000 �� 3500
SELECT 
    ename, 
	sal 
FROM emp 
WHERE 
    sal BETWEEN 3000 AND 3500;

-- ��������� ���� ����������� �� ��������� � ������� �� 3000 �� 3500
-- (��������� ������ �� ����������� ���������)
SELECT 
    ename, 
	sal 
FROM emp 
WHERE 
    sal >= 3000 
	AND sal <= 3500;

	
-- ��������� ���� ����������� �� ���������, 
-- ��� ���� ����� ����������� ������ ���� �� ������� 2 ��� 4
SELECT 
    empno, ename, sal, mgr
FROM emp
WHERE 
    empno IN (2, 4);

/*
������������ ��������� LIKE:
- �������������� �������� LIKE ��� ������ �� ��������.
- ����� ������ ���� ������ �� �������, ��� � �����.
- ������ % ������� ����-��� ������� �������.
- ������ _ ������� ����-���� ��������� ������.
- ������� ������� ����� ���������.
- �������������� ������������� ESCAPE ��� ������ ������� "%" or "_".
*/
	
-- ��������� ���� �����������, �� ����� � ���� ����� ����� = L
SELECT ename
FROM emp
WHERE 
    ename LIKE '_L%';

-- ��������� ���� �������, �� ��������� ������ �����������
SELECT lname
FROM Loc
WHERE 
    lname LIKE '%#_%%' ESCAPE '#';

-- ��������� ���� �����������, � ���� ����� ����� = B, ����� = A
SELECT ename
FROM emp
WHERE 
    ename LIKE 'B_A%';
	
/*
�������� ������������� �������� NULL:
- NULL � �� ��������, ��� �������, �� ��������� �� ������������;
- NULL � �� �� �� ����, �� ���� ��� �����;
- ��������� ������, �� ������ NULL, � NULL;
- �������� IS NULL ��������������� ��� ��������, �� �������� �������� � NULL
*/
	
-- ��������� ������ ���� �������� �����������, � ����� ���� ��������
select 
    12*sal+comm AS salary
FROM emp
WHERE 
    comm IS NULL;	


/*
����� ���������:
AND
OR
NOT
*/

-- ��������� ������ �����������, � ���� �������� >= 3500 �� ������ = 'SALESMAN'
SELECT 
    empno, 
	ename, 
	job, 
	sal
FROM emp
WHERE 
    sal >= 3500 
    AND job = 'SALESMAN';
			
-- ��������� ������ �����������, �� ����� �������� >= 3500 �� ������ = 'SALESMAN'
SELECT 
    empno, 
    ename, 
	job, 
	sal
FROM emp
WHERE 
    sal >= 3500
	OR job = 'SALESMAN';


-- ��������� ����, ������ �����������, ������ ���� �� ������� �� ������: 
-- 'MANAGER','SALESMAN'
SELECT 
    ename, 
	job
FROM emp
WHERE 
    job NOT IN ('MANAGER','SALESMAN');

-- ��������� ����, ������ �����������, ������ ���� �� ������� �� ������: 
-- 'MANAGER','SALESMAN'
-- (��������� ������ �� ����������� ���������)
SELECT 
    ename, 
	job
FROM emp
WHERE 
    job != 'MANAGER' 
	AND job != 'SALESMAN';

/*
������� �� ������� ���� ������������ ������� ������: 
-- 1) not (P and Q) = (not P) or (not Q)
-- 2) not (P or Q) = (not P) and (not Q) 
*/

-- ��������� ����, ������ �����������, ������ ���� �� ������� �� ������: 
-- 'MANAGER','SALESMAN'
-- ��������������� ���� �������� NOT �� AND
SELECT 
    ename, 
	job
FROM emp
WHERE 
    NOT (job = 'MANAGER') 
	AND NOT (job = 'SALESMAN');

-- ��������� ����, ������ �����������, ������ ���� �� ������� �� ������: 
-- 'MANAGER','SALESMAN'
-- ��������������� ���� �������� NOT �� OR
SELECT 
    ename, 
	job
FROM emp
WHERE
    NOT (job = 'MANAGER' 
        OR job = 'SALESMAN');

/*
��������� ��������:
1	�� ��������� ���������
2	NOT
3	AND
4	OR
*/
	 
-- ��������� ����, ������ �� �������� �����������,
-- �� �������� �� ����� 'SALESMAN' ���
-- �������� �� ����� = 'MANAGER' �� ��������� >3500
SELECT 
    ename, 
	job, 
	sal
FROM emp
WHERE  
    job = 'SALESMAN'
	OR job = 'MANAGER'
	AND sal > 3500;

-- ��������� ����, ������ �� �������� �����������,
-- �� �������� �� ����� 'SALESMAN' ���
-- �� ����� = 'MANAGER', � ����� ��������� �������� >3500

SELECT 
    ename, 
	job, 
	sal
FROM emp
WHERE 
    (job='SALESMAN' 
        OR job='MANAGER')
	 AND sal>3500;


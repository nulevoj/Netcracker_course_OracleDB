/* 
�������� ������� DELETE/UPDATE-������
*/

-- ������ ������ UPDATE-�������
UPDATE table
SET	column = value [, column = value]
[WHERE condition];

-- ���� �������� ����� ����������� � ������� = 1
UPDATE emp
SET sal = 5500
WHERE 
    empno = 1;

-- ���� �������� �� �������� ����������� � ������� = 2
UPDATE emp
SET sal = 5500, 
    comm = 500
WHERE 
    empno = 2;

-- ������ ���� ���� �������� ����������� (������)
UPDATE emp
SET deptno = 5
WHERE 
    empno = 1;

-- ������ ���� ���� �������� ����������� (������)
UPDATE emp
SET deptno = 3
WHERE 
    empno = 1;

-- ������ ������ DELETE-�������
DELETE FROM table
	[WHERE condition];

-- ������ ��������� ��� ��������
DELETE FROM dept;

-- ��������� �����������, ����� ����� ���� ���� = 'B'
DELETE FROM emp
WHERE 
    ename like 'B%';

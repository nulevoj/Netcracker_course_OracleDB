/* 
������ "Data Query Language (DQL) � ���������� �������� � ���� Oracle" 
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- ������� 1 �������� ������ ������ �����������,
-- �������� ���� ����� �� �������� ����������� � ��'�� JONES
-- ������ 1 � ������������ ���� ������.
-- 1.1. �������� ����� �������� ����������� � ��'�� JONES
SELECT SAL FROM EMP WHERE  ENAME = 'JONES';
/* ³������:
   SAL
--------
  2975
*/	  
-- 1.2 �������� ������ ������ �����������,
-- �������� ���� ����� �� �������� 2975
SELECT ENAME
FROM   EMP
WHERE  SAL > 2975;

-- ������� 1. ������ 2 � ������������ �����'������� ������� EMP
SELECT OTHER_EMP.ENAME
FROM   EMP OTHER_EMP, EMP JONES
WHERE  	JONES.ENAME = 'JONES'
		AND OTHER_EMP.SAL > JONES.SAL;

-- ������� 1. ������ 3 - ������������ ���������� ������ (��������)
SELECT ENAME
FROM   EMP
WHERE  SAL > 
			(
			SELECT SAL
              FROM EMP WHERE ENAME = 'JONES'
			);

-- ������� 1. ������ 3, ��� � ������������ 1-� �����������
SELECT ENAME FROM EMP WHERE  SAL > (SELECT SAL FROM EMP WHERE ENAME = 'JONES');

-- ������� 1. ������ 3, ��� � ������������ 2-� �����������
SELECT ENAME 
FROM EMP 
WHERE  
	(SELECT SAL FROM EMP WHERE ENAME = 'JONES') < SAL;

-- ������� 2 ��������� ��������� ������������ ��������.
-- �������� ������ �����������, � ����:
-- 1) �������� ����� �� �������� ����������� � ��'�� JONES
-- 2) ������ �������� � ������� ����������� ALLEN
SELECT 	ENAME
FROM   	EMP
WHERE  	SAL <
			( 
			SELECT SAL
            FROM EMP WHERE ENAME = 'JONES'
			)
		AND 
		JOB = 
			(
			SELECT JOB 
			FROM EMP WHERE ENAME = 'ALLEN'
			);
		
-- ������� 3 ������������ ���������� ������� � ���������
-- �������� ������ �����������, �������� ���� ��������
SELECT ENAME, JOB, SAL
FROM EMP
WHERE SAL =
			(SELECT MIN(SAL) FROM EMP);
			
-- ������� 4 ������������ ���������� HAVING � �������
-- �������� ������ ��������, � ���� ������� �������� �����������
-- ����� �������� �������� ����������� � ��� ������
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING AVG(SAL) >
				(SELECT AVG(SAL) FROM EMP);

-- ������� 5 �� �� ��� �� ��� �������?
SELECT EMPNO, ENAME
FROM   EMP
WHERE  SAL = 
			(SELECT MIN(SAL) FROM EMP
				GROUP BY  DEPTNO);
		
-- ������� 6 �� ���� �������� ��� �����?
SELECT ENAME, JOB
FROM EMP
WHERE JOB = 
			(SELECT JOB
				FROM EMP WHERE ENAME='SMYTHE');
-- ������� ��������� ��������� ��������

-- ������� 7 ������������ ��������� ANY � �������������� ���������
-- �������� ������ �����������, �� �� � ��������,
-- � �������� ���� ����� �� ����-��� ��������, ��� ��������� ������
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE 	SAL < ANY 
				(SELECT SAL FROM EMP 
					WHERE JOB = 'CLERK')	
		AND JOB <> 'CLERK';

-- ������� 8 ����� ����� � ����������� ����,
-- �� "< ANY" ������ "����� �������������"
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE 	SAL <
				(SELECT MAX(SAL) FROM EMP 
					WHERE JOB = 'CLERK')	
		AND JOB <> 'CLERK';

-- ������� 9 ������������ ��������� ALL � �������������� ���������
-- �������� ������ �����������, �������� ���� �����
-- ����������� �������� �������� � ����� ���������
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE SAL > ALL 
				(SELECT AVG(SAL)
					FROM EMP GROUP BY DEPTNO);

-- ������� 10 ����� ����� � ����������� ����,
-- �� ">ALL" ������ "����� �������������"
SELECT  EMPNO, ENAME, JOB
FROM EMP
WHERE SAL >  
			(SELECT MAX(AVG(SAL))
				FROM EMP GROUP BY DEPTNO);


-- ������� 11 ������� ��'�, ����� ��������, �������� �� ������
-- ����-����� ����������, � ����� �������� �� ������ ���������
-- ��������� �� ��������� �� ��������� ����-����� ���������� � ������� 30.
-- ������ 1. �� �������, �� � ���������� �������� ��������
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE (SAL, COMM) IN 
					(SELECT SAL, COMM
          			FROM EMP 
         			WHERE DEPTNO = 30);

-- ������ 2. �������, �� � ���������� �������� ����������
-- ������������ ���� ������
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE (SAL, COMM) IN 
					(SELECT SAL, COMM
          			FROM EMP 
         			WHERE DEPTNO = 30 
						AND COMM IS NOT NULL)
	AND COMM IS NOT NULL
UNION ALL
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE SAL IN 
					(SELECT SAL
          			FROM EMP 
         			WHERE DEPTNO = 30 
						AND COMM IS NULL)
	AND COMM IS NULL
;


-- ������� 11. ������ 2. ���� ������������ ��������� �������
-- ����� ������� ������������ NVL
SELECT ENAME, DEPTNO, SAL, COMM 
FROM EMP 
WHERE (SAL, NVL(COMM,-1)) IN 
							(SELECT SAL, NVL(COMM,-1)
							FROM EMP 
							WHERE DEPTNO = 30);

-- ������� 12 ������������ �������� � ���������� FROM.
-- ������� ����������� � ������ ���������,
-- �� ������� �������� � ����������� � �� ���������
SELECT  A.ENAME, A.SAL, A.DEPTNO, B.SALAVG
FROM  EMP A, 
			(SELECT DEPTNO, AVG(SAL) SALAVG
			FROM EMP
			GROUP BY DEPTNO) B
WHERE   A.DEPTNO = B.DEPTNO
AND     A.SAL > B.SALAVG;
 
-- ������� 12.2 ������������ �������� � �������� WITH.
-- ������� ����������� � ������ ���������,
-- �� ������� �������� � ����������� � �� ���������
WITH 
AVG_SAL AS
	(
		SELECT DEPTNO, AVG(SAL) SALAVG
		FROM EMP
		GROUP BY DEPTNO
	)
SELECT A.ENAME, A.SAL, A.DEPTNO, B.SALAVG
FROM EMP A, AVG_SAL B
	WHERE 	A.DEPTNO = B.DEPTNO
			AND A.SAL > B.SALAVG;

-- ������� 13 �������� ������ ��������, � ���� �������� �����������.
-- ������ 1. 
SELECT  D.DNAME
	FROM DEPT D, EMP E 
	WHERE D.DEPTNO = E.DEPTNO;

-- ������ 2. ������������ ��������� DISTINCT
SELECT  DISTINCT D.DNAME
	FROM DEPT D, EMP E 
	WHERE D.DEPTNO = E.DEPTNO;

-- ������ 3. ������������ ��������� IN
SELECT d.dname
	FROM dept d
	WHERE d.deptno IN (
			SELECT e.deptno 
			FROM emp e);

-- ������ 4. ������������ ��������� EXISTS
SELECT D.DNAME
	FROM DEPT D
	WHERE EXISTS (
			SELECT E.DEPTNO 
			FROM EMP E 
			WHERE E.DEPTNO = D.DEPTNO);
-- г����� � ������ ����, ��� �������� ��������� ���� ����������.
-- ������������: -- ���� ������� ����� � ������� >
-- ������� ����� ��������� ������ - ������������� EXISTS, ������ - IN

	
-- ������� 14 �������� ������ �����������, �� �� ����� ��������
SELECT EMPLOYEE.ENAME
FROM EMP EMPLOYEE
WHERE NOT EXISTS
			(SELECT MANAGER.MGR
			FROM EMP MANAGER
			WHERE MGR = EMPLOYEE.EMPNO);
			
SELECT D.DNAME
	FROM DEPT D
	WHERE NOT EXISTS (
			SELECT E.DEPTNO 
			FROM EMP E 
			WHERE E.DEPTNO = D.DEPTNO);

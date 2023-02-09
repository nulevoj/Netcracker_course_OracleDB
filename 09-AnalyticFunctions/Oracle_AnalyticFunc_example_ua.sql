
/* 

�������� ��� ������ -
"���������� ������������ ���������� ������� 
� ���� Oracle"

*/

/*
������������ ��������� ������ � SQLPlus
*/

SET LINESIZE 2000
SET PAGESIZE 100

COL empno FORMAT 99999
COL deptno FORMAT 99999
COL sum_sal FORMAT 999999
COL sal FORMAT 99999
COL job FORMAT A10
COL ename FORMAT A8
COL hiredate FORMAT A10


/* �������� 1:
�������� �������, �������, ������, 
���� ����������� �� �������� �����������
� ��������� ����������� �������� ������� �� ����������

������� ��������� ����������:
ENAME    DEPTNO JOB        HIREDATE      SAL
-------- ------ ---------- ---------- ------
MILLER       10 CLERK      23-JAN-82    1300
CLARK        10 MANAGER    09-JUN-81    1500
KING         10 PRESIDENT  17-NOV-81    5000
FORD         20 ANALYST    03-DEC-81    3000
SCOTT        20 ANALYST    09-DEC-82    3000
SMITH        20 CLERK      17-DEC-80     800
ADAMS        20 CLERK      12-JAN-83    1100
JONES        20 MANAGER    02-APR-81    2975
JAMES        30 CLERK      03-DEC-81     950
BLAKE        30 MANAGER    01-MAY-81    2850
ALLEN        30 SALESMAN   20-FEB-81    1600
WARD         30 SALESMAN   22-FEB-81    1250
TURNER       30 SALESMAN   08-SEP-81    1500
MARTIN       30 SALESMAN   28-SEP-81    1250
IVANOV       50 STUDENT    03-NOV-22       0

*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal
FROM emp
ORDER BY deptno, job, hiredate;

/* �������� 2: 
�������� ������� �������� ����������� 
� ������� �������� 
� ���������� ��������.

������� ��������� ����������:
DEPTNO JOB        SUM_SAL
------ ---------- -------
    10 CLERK         1300
    10 MANAGER       1500
    10 PRESIDENT     5000
    20 ANALYST       6000
    20 CLERK         1900
    20 MANAGER       2975
    30 CLERK          950
    30 MANAGER       2850
    30 SALESMAN      5600
    50 STUDENT          0

������ ������ � ����������� ������������� 
����������� ����� � �������� ���������

*/

SELECT 
    deptno,
	job,
	SUM(sal) sum_sal 
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;

/* �������� 3: 
�������� �������, �������, ������ ����������� 
� ���������� ������� ������� �������� ���������� 
� �� ��������� � ��������.

������� ��������� ����������:
ENAME    DEPTNO JOB        SUM_SAL
-------- ------ ---------- -------
MILLER       10 CLERK         1300
CLARK        10 MANAGER       1500
KING         10 PRESIDENT     5000
FORD         20 ANALYST       6000 (6000 = 3000 + 3000)
SCOTT        20 ANALYST       6000 (6000 = 3000 + 3000)
SMITH        20 CLERK         1900 (1900 = 800 + 1100)
ADAMS        20 CLERK         1900 (1900 = 800 + 1100)
JONES        20 MANAGER       2975
JAMES        30 CLERK          950
BLAKE        30 MANAGER       2850
MARTIN       30 SALESMAN      5600
TURNER       30 SALESMAN      5600
WARD         30 SALESMAN      5600
ALLEN        30 SALESMAN      5600
IVANOV       50 STUDENT          0

������ ���������� ������ � ���������� ���������� 
� ����� 1-�� �� 2-�� �������.
*/

WITH 
emp_sum_sal AS (
	SELECT 
	    deptno, 
		job, 
		SUM(sal) AS sum_sal 
	FROM emp 
	GROUP BY deptno, job
)
SELECT 
    e.ename, 
	e.deptno, 
	e.job, 
	s.sum_sal
FROM 
    emp e, 
    emp_sum_sal s
WHERE 	
    e.deptno = s.deptno 
	AND e.job = s.job
ORDER BY e.deptno, e.job;

/* �������� 4:
�������� �������, �������, ������, ���� �����������, �������� ���������� 
� ���������� ������� �������������� ���� ������� ����������
� ���� ��������� � �� ��������, 
�� ����������� ����������� �� ������ ����� �����������.

������� ��������� ����������:
ENAME    DEPTNO JOB        HIREDATE      SAL SUM_SAL
-------- ------ ---------- ---------- ------ -------
MILLER       10 CLERK      23-JAN-82    1300    1300
CLARK        10 MANAGER    09-JUN-81    1500    1500
KING         10 PRESIDENT  17-NOV-81    5000    5000
FORD         20 ANALYST    03-DEC-81    3000    3000
SCOTT        20 ANALYST    09-DEC-82    3000    6000 (6000=3000+3000)
SMITH        20 CLERK      17-DEC-80     800     800
ADAMS        20 CLERK      12-JAN-83    1100    1900
JONES        20 MANAGER    02-APR-81    2975    2975
JAMES        30 CLERK      03-DEC-81     950     950
BLAKE        30 MANAGER    01-MAY-81    2850    2850
ALLEN        30 SALESMAN   20-FEB-81    1600    1600
WARD         30 SALESMAN   22-FEB-81    1250    2850 (2850=1600+1250)
TURNER       30 SALESMAN   08-SEP-81    1500    4350 (4350=2850+1500)
MARTIN       30 SALESMAN   28-SEP-81    1250    5600
IVANOV       50 STUDENT    03-NOV-22       0       0

������ ���������� ������ 
� ����������� ������������� ��������� ������
*/

WITH emp_sum_sal AS
(
	SELECT e1.ename, e1.deptno, e1.job,
			e1.hiredate, e1.sal, e2.sal sum_sal
	FROM emp e1, emp e2
	WHERE 	e1.deptno = e2.deptno
			AND e1.job = e2.job
			AND e1.hiredate >= e2.hiredate
            -- ORDER BY e1.deptno, e1.job, e1.hiredate
)
SELECT 
    ename,
	deptno,
	job,
	hiredate,
	sal,
	sum(sum_sal) AS sum_sal
FROM emp_sum_sal
GROUP BY ename, deptno, job, hiredate, sal
ORDER BY deptno, job, hiredate;

/* �������� 4:
�������� �������, �������, ������, �������� ����������� 
� ���������� ������� ������� (������) �������� ������� ���������� 
�� �������� �������� �� ���������.

������� ��������� ����������:
ENAME    DEPTNO JOB           SAL    PERSENT
-------- ------ ---------- ------ ----------
MILLER       10 CLERK        1300         17
CLARK        10 MANAGER      1500         19
KING         10 PRESIDENT    5000         64
FORD         20 ANALYST      3000         28
SCOTT        20 ANALYST      3000         28
SMITH        20 CLERK         800          7
ADAMS        20 CLERK        1100         10
JONES        20 MANAGER      2975         27
JAMES        30 CLERK         950         10
BLAKE        30 MANAGER      2850         30
MARTIN       30 SALESMAN     1250         13
WARD         30 SALESMAN     1250         13
TURNER       30 SALESMAN     1500         16
ALLEN        30 SALESMAN     1600         17

������ ���������� ������ ������ 
� ����������� ������������� ��������� ������
*/

WITH 
emp_sum_sal AS (
    SELECT deptno,
	sum(sal) sum_sal
	FROM emp
	GROUP BY deptno
)
SELECT
    e.ename,
	e.deptno,
	e.job,
	e.sal,
	round(100*e.sal/s.sum_sal) AS persent
FROM emp e, emp_sum_sal s
WHERE
    s.sum_sal != 0
    AND e.deptno = s.deptno 
ORDER BY e.deptno, e.job;

/* �������� 5:
�������� 5-�� ������� ����������������� 
����������� (�������, ��������)

������� ��������� ����������:
ENAME       SAL
-------- ------
KING       5000
SCOTT      3000
FORD       3000
JONES      2975
BLAKE      2850

г����� ������ � ����������� ������������� ��������� ������
��� ���� Oracle ���� < 12c. 
������������ �������� ������� ROWNUM
*/

WITH 
emp_sort_sal AS (
    SELECT ename, sal
    FROM emp
    ORDER BY sal DESC
),
emp_sort_sal_rownum AS (
    SELECT 
	    ROWNUM AS r,
	    ename, 
	    sal 
	FROM emp_sort_sal
)
SELECT
    ename, 
	sal 
FROM emp_sort_sal_rownum
WHERE 
    r <= 5;

/* �������� 5: 
������ 2 ���������� ������ ������ 
��� ���� Oracle ���� >= 12c
� ������������� ����� "Top-N"-������:
[ OFFSET offset { ROW | ROWS } ]
[ FETCH { FIRST | NEXT } [ { rowcount | percent PERCENT } ]
    { ROW | ROWS } { ONLY | WITH TIES } ]
*/

SELECT 
    ename, 
	sal 
FROM Emp 
ORDER BY sal DESC
FETCH FIRST 5 ROWS ONLY;

/* �������� 6:
�������� ������ ����������� (�������, �������, ��������) 
�� ���������� ���������� �������� ������� ��������.

������� ��������� ����������:
ENAME    DEPTNO    SAL
-------- ------ ------
IVANOV       50      0
BLAKE        30   2850
KING         10   5000
FORD         20   3000
SCOTT        20   3000

������ ���������� ������ ������ 
� ����������� ������������� ��������� ������
*/

WITH
emp_sum_sal AS (
    SELECT 
	    deptno, 
	    MAX(sal) max_sal 
	FROM emp 
	GROUP BY deptno
)
SELECT 
    e1.ename, 
	e1.deptno, 
	e1.sal
FROM emp e1
WHERE 
    EXISTS (
		SELECT *
		FROM emp_sum_sal e2
		WHERE e2.deptno = e1.deptno 
			AND e2.max_sal = e1.sal
	);

/* �������� 7:
�������� ���� ����������� (�������, �������, ��������) 
� ���������� ���������� �������� ������� ��������.

г����� ??????

*/

SELECT ename, deptno, sal 
FROM emp
ORDER BY deptno ASC, sal DESC;

-- ������ ���� ???
select e1.deptno, e1.sal
  from (
         select e2.deptno, e2.sal,
                (
                  select count(1)
                    from emp e0
                   where e2.deptno = e0.deptno
                     and e2.sal >= e0.sal
                ) as rn
           from emp e2
		   order by deptno, rn desc
       ) e1
 where rn <= 2
 ORDER BY e1.deptno;

/* **************************************** ********************************
���� 1. ϲ�������� ��������Ҳ� �� ������� � ������� ���������� 
					(PARTITION BY, ORDER BY) 
* ************************************************** ********************** */

/*
�������� ������� ����� ��������� ���������:
<�����_�������>(<��������>,< �������� >, . . . ) 
OVER ( <����_����_�����>)

������� ���������� <�����_�������>:
1) ��������� ���������� ������� (������� ���������) (COUNT, SUM, �);
2) �������� �������.

<����_����_�����> ������ ������:
1) �����������;
2) �������������;
3) ����.

*/

/*
������ ����������� - PARTITION BY. 
����������:
1) ������ ������� ����������� ������� �� �����;
2) ���������:
    PARTITION BY ����� [,�����] [, �����] 
3) �� ������ ���������� ����������:
3.1) �������� ������� �������������� �� ����� ����� ���������
3.2) ��� ����� ���� ����� �������� ������� ����������;
3.3) ���� �� ������� ����������� �����������, ��� ����������� ������� 
    ��������� ���� ������. 
*/

/* �������� 1:
�������� �������, �������, ������ ���������� 
� ���������� ������� ������� �������� ���������� � ���� ��������� 
� �� ��������.

������� ��������� ����������:
ENAME    DEPTNO JOB        SUM_SAL
-------- ------ ---------- -------
MILLER       10 CLERK         1300
CLARK        10 MANAGER       1500
KING         10 PRESIDENT     5000
FORD         20 ANALYST       6000
SCOTT        20 ANALYST       6000
SMITH        20 CLERK         1900
ADAMS        20 CLERK         1900
JONES        20 MANAGER       2975
JAMES        30 CLERK          950
BLAKE        30 MANAGER       2850
TURNER       30 SALESMAN      5600
MARTIN       30 SALESMAN      5600
WARD         30 SALESMAN      5600
ALLEN        30 SALESMAN      5600
IVANOV       50 STUDENT          0

г����� ������ ����������� ������ ����������� PARTITION BY
*/

SELECT 
    ename, 
	deptno, 
	job,
	SUM(sal) OVER (PARTITION BY deptno, job) sum_sal 
FROM emp;

/*
������ ������������� ORDER BY.
����������:
1) ���� ������� ���������� ����� � ����� ����;
2) ��������� ORDER BY:
2.1) <�����> [ASC | DESC] [NULLS FIRST | NULLS LAST];
2.2) NULLS FIRST �� NULLS LAST �����, 
    �� ��� ������������ ����� ���� �������� NULL - �� ������� �� ���������;
3) ����� ��������������� ���� � ����� ����.
*/

/* �������� 2:
�������� �������, �������, ������, ���� �����������, �������� ���������� 
� ���������� ������� �������������� ���� ������� ���������� 
� ���� ��������� � �� ��������, 
�� ����������� ��� �� ������ ����� �����������.

������� ��������� ����������:
ENAME    DEPTNO JOB        HIREDATE      SAL SUM_SAL
-------- ------ ---------- ---------- ------ -------
MILLER       10 CLERK      23-JAN-82    1300    1300
CLARK        10 MANAGER    09-JUN-81    1500    1500
KING         10 PRESIDENT  17-NOV-81    5000    5000
FORD         20 ANALYST    03-DEC-81    3000    3000
SCOTT        20 ANALYST    09-DEC-82    3000    6000
SMITH        20 CLERK      17-DEC-80     800     800
ADAMS        20 CLERK      12-JAN-83    1100    1900
JONES        20 MANAGER    02-APR-81    2975    2975
JAMES        30 CLERK      03-DEC-81     950     950
BLAKE        30 MANAGER    01-MAY-81    2850    2850
ALLEN        30 SALESMAN   20-FEB-81    1600    1600
WARD         30 SALESMAN   22-FEB-81    1250    2850
TURNER       30 SALESMAN   08-SEP-81    1500    4350
MARTIN       30 SALESMAN   28-SEP-81    1250    5600
IVANOV       50 STUDENT    03-NOV-22       0       0

г����� ����������� ������ ������������� ORDER BY
*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal, 
	SUM(sal) OVER (
	             PARTITION BY deptno, job 
		         ORDER BY hiredate
			 ) sum_sal 
FROM emp; 

/*
�������� �� ������������ ������:
1) � ����� ��� ������ ������������� � ������� ����� �� �����������
 ���������� �������� ���� ������� �� ��� ���� �����������, 
 ������ ����������� �� ��������� �� �������;
2) � ����� �� ������� ������������� � ������� ����� �� ����������� 
 ���������� ���� ������� ��������� �����, 
 �� ����� � ����������� ���� ����������� ����������, 
 ������������� �� ��������� ����� �����������;
*/

/* �������� 3: �������� ������� ����������� � ����� �����������, ���������. 
��� ������� ����� ��������� ������� ������ �� �������� ������������ 
�� ������� ������� ����

������� ��������� ����������:
ENAME    HIREDATE      SAL SUM_SAL
-------- ---------- ------ -------
SMITH    17-DEC-80     800     800
ALLEN    20-FEB-81    1600    2400
WARD     22-FEB-81    1250    3650
JONES    02-APR-81    2975    6625
BLAKE    01-MAY-81    2850    9475
CLARK    09-JUN-81    1500   10975
TURNER   08-SEP-81    1500   12475
MARTIN   28-SEP-81    1250   13725
KING     17-NOV-81    5000   18725
JAMES    03-DEC-81     950   22675
FORD     03-DEC-81    3000   22675
MILLER   23-JAN-82    1300   23975
SCOTT    09-DEC-82    3000   26975
ADAMS    12-JAN-83    1100   28075
IVANOV   03-NOV-22       0   28075

*/

SELECT 
    ename, 
	hiredate, 
	sal, 
	SUM(sal) OVER (ORDER BY hiredate) sum_sal
FROM emp;

/*
�������� �� ������: 
1) ��� ������ ���������� ������ ��������� �� �����;
2) � ������� ����� �� ����������� ���������� ���� ������� ��������� �����, 
 �� ����� � ����������� ���� ����������� ����������, 
 ������������� �� ��������� ����� �����������;
3) ��� ����� � ���������� ���������� ���� ����������� �������� 
 ������������� � ��� ������ ����, 
 ������� �������� �� ������������� James �� Ford
*/

/* �������� 4: ������� ������ ������� ������ �� �������� ������������ 
� ��������� �� ������� �� ������ �� �����������

������� ��������� ����������:
       M          Y   SUM_SAL
---------- ---------- -------
        12       1980     800
         2       1981    3650
         4       1981    6625
         5       1981    9475
         6       1981   10975
         9       1981   13725
        11       1981   18725
        12       1981   22675
         1       1982   23975
        12       1982   26975
         1       1983   28075
        11       2022   28075

*/

WITH 
m_y_sal AS (
    SELECT 
	    extract (month from hiredate) m,
	    extract (year from hiredate) y, 
		sal 
		FROM emp
),
m_y_sal_sum AS (
    SELECT m,y,SUM(sal) sal from m_y_sal group by m,y
)
SELECT 
    m, 
	y, 
	SUM(sal) OVER (ORDER BY y,m) sum_sal 
FROM m_y_sal_sum;

/*
�������� �� ������:
1) ���������������� ������� ������ � ���������� WITH
2) ����� m_y_sal ������ �������� ���������� �� ������� 
 �� ������ �� ����������� �� ������
3) ����� m_y_sal_sum ��'���� �������� ����������, 
����������� � ���� ����� 
*/

/* 
�������� 4: 
������ 2 ������ ��� ������������ �����������
*/

WITH 
m_y_sal AS (
    SELECT 
	    extract(month FROM hiredate) AS m,
	    extract (year FROM hiredate) AS y, 
		sal 
	FROM emp
)
SELECT 
    m, 
	y, 
	SUM(sal) OVER (ORDER BY y,m) AS sum_sal 
FROM m_y_sal;

/*
�������� 5: ������� ������ ������� ������ �� �������� ������������ 
� ��������� �� ������ �� �� ���� ������ ������

������� ��������� ����������:
         M          Y SUM_SAL
---------- ---------- -------
        11       1980       0
        12       1980     800
         1       1981     800
         2       1981    3650
         3       1981    3650
         4       1981    6625
         5       1981    9475
         6       1981   10975
         7       1981   10975
         8       1981   10975
         9       1981   13725
        10       1981   13725
        11       1981   18725
        12       1981   22675
         1       1982   23975
         2       1982   23975
         3       1982   23975
         4       1982   23975
         5       1982   23975
         6       1982   23975
         7       1982   23975
...

*/

WITH 
m_y_sal AS (
    SELECT 
	    extract (month from hiredate) AS m, 
		extract(year from hiredate) AS y, 
		sal 
	FROM emp
),
m_y_sal_sum AS (
    SELECT
	    m,
		y,
		SUM(sal) AS sal
	FROM m_y_sal 
	GROUP BY m,y
),
month_list AS (
    SELECT 
	    ROWNUM AS m
	FROM dual 
	CONNECT BY LEVEL <= 12
),
year_list AS (
    SELECT distinct extract(year FROM hiredate) AS y 
	FROM emp
),
month_year_list AS (
	SELECT y, m
	FROM month_list, year_list
),
m_y_sal_sum_add AS (
	SELECT l.y,l.m,NVL(s.sal,0) sal 
	FROM month_year_list l LEFT JOIN m_y_sal_sum s 
	    ON (l.m = s.m AND l.y = s.y) 
)
SELECT 
    m,
    y,
	SUM(sal) OVER (ORDER BY y,m) AS sum_sal 
FROM m_y_sal_sum_add;

/*
�������� �� ������������ ������:
1) ���������������� ������� ������ � ���������� WITH
2) ����� m_y_sal ������ �������� ���������� �� ������� �� ������ 
 �� ����������� �� ������
3) ����� m_y_sal_sum ��'���� �������� ����������, ����������� � ���� ����� � ��
4) ����� month_list ������ ������� ������ ������ 
 ��� ����-����� ����������� ���� �����������
5) ����� year_list ������ �������� ������� ���� ����������� �����������
6) ����� month_year_list ������ ������� ������ � ���� 
 � ������� ��� ����������� ����������� �� ����� ����������� ����� 
 ���� ������ � ��������� ������
7) ����� m_y_sal_sum_add ������ ������� ��� ������ � ���� �� month_year_list
*/

/*************************************************************************
���� 2. ���ֲ� ²���
********************** ****************************************************/

/*
����������� ������ ����:
1) �������� ������ ����, �� ����������� ��� ������� ����'�����. 
��� ������ ����� � ����� �����, � ���� ����������� ��������� �������;
2) ��������������� �� �������� ������ �������������;

C��������:
[RANGE | ROWS ] <�������_����> ���
[ RANGE | ROWS ] BETWEEN <�������_����> AND <�����_����>
RANGE - ���� �� ��������� ������� ����� (������� ��������)
ROWS - ���� � ������� ���� ��������� ����� (�������� ��������)

�������� <�������_����>, <�����_����>:
1) UNBOUND PRECEDING - ����� ����, �� �����������;;
2) <��������> PRECEDING � ���������� ����� ������;
3) CURRENT ROW � �������� �����;
4) <��������> FOLLOWING � ���������� ������ ������;
5) UNBOUNDED FOLLOWING � ������ ����, �� �����������;
�� �������������:
<�������_����> = UNBOUNDED PRECEDING, 
<�����_����> = CURRENT ROW

*/

/* �������� 1: �������� �������, �������, ������, ���� �����������, �������� ���������� 
� ���������� ������� �������������� ���� ������� ���������� 
� �� ��������� �� ������ ����� �����������.

������� ��������� ����������:
ENAME    DEPTNO JOB        HIREDATE      SAL SUM_SAL
-------- ------ ---------- ---------- ------ -------
MILLER       10 CLERK      23-JAN-82    1300    1300
CLARK        10 MANAGER    09-JUN-81    1500    1500
KING         10 PRESIDENT  17-NOV-81    5000    5000
FORD         20 ANALYST    03-DEC-81    3000    3000
SCOTT        20 ANALYST    09-DEC-82    3000    6000
SMITH        20 CLERK      17-DEC-80     800     800
ADAMS        20 CLERK      12-JAN-83    1100    1900
JONES        20 MANAGER    02-APR-81    2975    2975
JAMES        30 CLERK      03-DEC-81     950     950
BLAKE        30 MANAGER    01-MAY-81    2850    2850
ALLEN        30 SALESMAN   20-FEB-81    1600    1600
WARD         30 SALESMAN   22-FEB-81    1250    2850
TURNER       30 SALESMAN   08-SEP-81    1500    4350
MARTIN       30 SALESMAN   28-SEP-81    1250    5600
IVANOV       50 STUDENT    03-NOV-22       0       0


г����� ����������� ������ ������������� ORDER BY
*/

SELECT 
    ename,
	deptno,
	job,
	hiredate,
	sal,
	SUM(sal) OVER (
	             PARTITION BY deptno, job 
	             ORDER BY hiredate
			 ) AS sum_sal 
FROM emp; 

/*
��������� ������ ������ �������� ��������� ������������ ������,
�� ��������������� ���� "�� �������������"
*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal,
	SUM(sal) OVER ( 
	             PARTITION BY deptno, job 
	             ORDER BY hiredate 
				 ROWS BETWEEN UNBOUNDED PRECEDING 
				 AND CURRENT ROW
			 ) AS sum_sal 
FROM emp; 

/* ��������� ���������� ��� ����� �������� ����
1) ROWS BETWEEN <��������> PRECEDING AND UNBOUNDED FOLLOWING 
- ����� ���� ���� ��������� - �������� � ������ ������ ������������ 
	������ ����� ����� �����
- ������ ���� ����� - �������� � ��������;
- ����������� ������� (������������ �������) - ����� ���� ���������, 
	������������ � ���� ��, � ���� ���� �������� �� ������� ���������� 
2) ROWS BETWEEN <��������1> PRECEDING AND <��������2> FOLLOWING 
- ����� �� ������ ��� �������� ���� ��������� ����� � ��� ����, 
- ���������, 1-� ����� �� ��������� �� 2-� ����� ���� ���������
� �������� �������, ���� �����, � ������ ���� �������� 
   (����� �� ������������), � ���� ���� �������� (�����). 
*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal,
	SUM(sal) OVER (
	             ORDER BY hiredate 
				 ROWS 
				     BETWEEN CURRENT ROW 
				     AND UNBOUNDED FOLLOWING
			 ) AS row_and_un_fol,
    SUM(sal) OVER (
	             ORDER BY hiredate 
				 ROWS 
				     BETWEEN UNBOUNDED PRECEDING 
				     AND CURRENT ROW
			 ) AS un_pr_and_row,
	SUM(sal) OVER (
	             ORDER BY hiredate 
				 ROWS 
				     BETWEEN UNBOUNDED PRECEDING 
				     AND UNBOUNDED FOLLOWING
			 ) un_pr_and_un_fol
FROM emp; 
 

/*
�������� �� ��������� ���������� �� ������� ROWS �� RANGE:
1) JAMES �� FORD ������� �� ������ ��������� � 
�������������� � ����������� �������� ��������� ������������� 
 ("�� ���������" - RANGE);
2) ������������� �� RANGE ���������� ��������� ��������� � 
 ����������� �������� ��� �����;
3) ������������� �� ROWS ������������ ����������� � "��-����", 
 �������� ������ ������. 
*/

/*
�������� 2: ������� �������� ����������� �� �� ������ �������� 
�� ������ ������ �� ������ ������� ������ �����������

������� ��������� ����������:
ENAME    HIREDATE      SAL    AVG_SAL
-------- ---------- ------ ----------
SMITH    17-DEC-80     800        800
ALLEN    20-FEB-81    1600       1200
WARD     22-FEB-81    1250       1217
JONES    02-APR-81    2975       1656
BLAKE    01-MAY-81    2850       1895
CLARK    09-JUN-81    1500       1829
TURNER   08-SEP-81    1500       2206
MARTIN   28-SEP-81    1250       2015
KING     17-NOV-81    5000       2313
JAMES    03-DEC-81     950       2200
FORD     03-DEC-81    3000       2200
MILLER   23-JAN-82    1300       2167
SCOTT    09-DEC-82    3000       3000
ADAMS    12-JAN-83    1100       2050
IVANOV   03-NOV-22       0          0

*/

SELECT 
    ename, 
	hiredate, 
	sal, 
	ROUND( 
	    AVG(sal) OVER	(
	                   ORDER BY hiredate 
					   RANGE 
					       BETWEEN INTERVAL '6' MONTH PRECEDING 
					       AND CURRENT ROW 
				 )
	) AS avg_sal 
FROM emp; 

/*
�������� 3: ������� ������� �������� �� �������� ������������ 
�� ���������� ����� �������������, ����������� � ���� �� ���������� 
� ������������ � ������� ��������� ��������

������� ��������� ����������:
DEPTNO ENAME    JOB           SAL    AVG_SAL
------ -------- ---------- ------ ----------
    10 KING     PRESIDENT    5000       5000
    10 CLARK    MANAGER      1500       3250
    10 MILLER   CLERK        1300       2600
    20 SCOTT    ANALYST      3000       3000
    20 FORD     ANALYST      3000       3000
    20 JONES    MANAGER      2975       2992
    20 ADAMS    CLERK        1100       2358
    20 SMITH    CLERK         800       1625
    30 BLAKE    MANAGER      2850       2850
    30 ALLEN    SALESMAN     1600       2225
    30 TURNER   SALESMAN     1500       1983
    30 MARTIN   SALESMAN     1250       1450
    30 WARD     SALESMAN     1250       1333
    30 JAMES    CLERK         950       1150
    50 IVANOV   STUDENT         0          0

*/

SELECT
    deptno,
	ename,
	job,
	sal, 
	ROUND(AVG(sal) OVER(
	                   PARTITION BY deptno 
					   ORDER BY sal DESC 
					   ROWS 
					       BETWEEN 2 PRECEDING 
					       AND CURRENT ROW 
				   )
	) AS avg_sal
FROM emp;

/*
���� 3 - ���� ²������ ����ֲ�: �������Ͳ, ������ײ, �̲�����, ���˲���Ͳ
*/

/* ��������� ������� ROW_NUMBER()

������� ����� ����� � ��� ���:
1) ��������� ���������, �� ����������� �� ����;
2) ��������� "����������" ��������� - 
 �������� ����� �� �������� ������� ����� �� ����������� 
 �� ������ ��� ����� �����;
3) ������������ ��������� ������ ������� ��������� � 
 ��������� �� �������� �� ���������� �����.
*/

/*
�������� 1: ������� ����������� �� ����������� ������� 
����������� �� ������� � �������� �� ���������

������� ��������� ����������:
ENAME       SAL SALBACK  SALFORWART
-------- ------ ------------- ----------
IVANOV        0            15          1
SMITH       800            14          2
JAMES       950            13          3
ADAMS      1100            12          4
WARD       1250            11          5
MARTIN     1250            10          6
MILLER     1300             9          7
CLARK      1500             7          8
TURNER     1500             8          9
ALLEN      1600             6         10
BLAKE      2850             5         11
JONES      2975             4         12
FORD       3000             3         13
SCOTT      3000             2         14
KING       5000             1         15


*/
SELECT ename, sal, 
	ROW_NUMBER() 
		OVER ( ORDER BY sal DESC) AS salback, 
	ROW_NUMBER () 
		OVER (ORDER BY sal) AS salforward
FROM emp; 

/*
�������� 2: ������� �'��� ������� ����������������� �����������

������� ��������� ����������:
ENAME       SAL
-------- ------
KING       5000
FORD       3000
SCOTT      3000
JONES      2975
BLAKE      2850

*/

WITH 
emp_sort_sal_rownum AS (
    SELECT ename, sal, 
	    ROW_NUMBER() OVER ( ORDER BY sal DESC ) AS r 
	FROM emp
)
SELECT 
    ename, 
	sal 
FROM emp_sort_sal_rownum
WHERE 
    r <= 5;

/*	
�������� 3: ������� �'��� ������� ����������������� �����������

������� ��������� ����������:
ENAME       SAL
-------- ------
IVANOV        0
SMITH       800
JAMES       950
ADAMS      1100
MARTIN     1250

*/

WITH 
emp_sort_sal_rownum AS (
    SELECT 
	    ename, 
		sal, 
	    ROW_NUMBER() OVER (
                         ORDER BY sal ASC 
					 ) AS r 
		FROM emp
)
SELECT 
    ename, 
	sal 
FROM emp_sort_sal_rownum
WHERE 
    r <= 5;

/*
�������� 4: ������� ����������� �� ����������� ������� �� ������� 
�� ���������� ������ � ����� ���� �� ��������� � �������

������� ��������� ����������:
     NUM DEPTNO JOB        ENAME       SAL
---------- ------ ---------- -------- ------
         1     10 CLERK      MILLER     1300
         1     10 MANAGER    CLARK      1500
         1     10 PRESIDENT  KING       5000
         1     20 ANALYST    SCOTT      3000
         2     20 ANALYST    FORD       3000
         1     20 CLERK      SMITH       800
         2     20 CLERK      ADAMS      1100
         1     20 MANAGER    JONES      2975
         1     30 CLERK      JAMES       950
         1     30 MANAGER    BLAKE      2850
         1     30 SALESMAN   MARTIN     1250
         2     30 SALESMAN   WARD       1250
         3     30 SALESMAN   TURNER     1500
         4     30 SALESMAN   ALLEN      1600
         1     50 STUDENT    IVANOV        0

*/

SELECT 
    ROW_NUMBER() OVER ( 
	                 PARTITION BY deptno, 
		             job ORDER BY sal
	             ) AS num, 
    deptno, 
	job, 
	ename, 
	sal
FROM emp;

/* �������� 5: ������� ���� ����������� 
(�������, �������, ������, ��������) 
�� ���������� ���������� �������� ������� ��������.

������� ��������� ����������:
DEPTNO ENAME    JOB           SAL
------ -------- ---------- ------
    10 KING     PRESIDENT    5000
    10 CLARK    MANAGER      1500
    20 FORD     ANALYST      3000
    20 SCOTT    ANALYST      3000
    30 BLAKE    MANAGER      2850
    30 ALLEN    SALESMAN     1600
    50 IVANOV   STUDENT         0

*/

WITH 
emp_row_number AS (
    SELECT 
	    deptno,
		ename,
		job,sal, 
	    ROW_NUMBER() OVER(
		                 PARTITION BY deptno 
						 ORDER BY sal DESC
					 ) AS r 
	FROM emp
)	
SELECT 
    deptno,
	ename,
	job,
	sal 
FROM emp_row_number
WHERE r <= 2;


/* 
��������� ������� ������������ RANK():
1) ������� ���� ����� - ������� ������� ����� � ������ ������������� ������
2) ���� ������������ �� �������� �� ������� ������� ������� ����� �����, 
 �� ��������� ������ �����;
3) ���� ���������� ��� ����� ��� ������� ������, �� ������� �� ����������� ORDER BY;
4) ����� � ���������� ���������� ��������� ���� � ��� ����� ����.

��������� ������� ������������ DENSE_RANK():
1) ������� ���� ����� - ������� ������� ����� � ������ ������������� ������ 
 ��� ������� ����������;
2) ���� ������������ �� �������� �� ������� ������� ����� ������� 
 ����� �����, �� ��������� ������ �����;
3) ���� ���������� ��� ����� ��� ������� ������,
 �� ������� �� ����������� ORDER BY;
4) ����� � ���������� ���������� ��������� ���� � ��� ����� ����.
*/

/*
�������� 6: 
������� ������ ��� ��������� ��������� ������������ RANK() �� DENSE_RANK():
*/
SELECT 
	ROW_NUMBER () OVER (ORDER BY sal) AS salnumber,
	RANK() OVER (ORDER BY sal) AS salrank,
	DENSE_RANK() OVER (ORDER BY sal) AS saldenserank, 
	ename, deptno, job, sal
FROM emp;

/* 
�������� 7: ��� ������� ����������� �������� �������� ���� 
���� �������� ����� ����� ���������� ���� � ��������

������� ��������� ����������:
ENAME    DEPTNO JOB           SAL SALDENSERANK
-------- ------ ---------- ------ ------------
MILLER       10 CLERK        1300            1
CLARK        10 MANAGER      1500            2
KING         10 PRESIDENT    5000            3
SMITH        20 CLERK         800            1
ADAMS        20 CLERK        1100            2
JONES        20 MANAGER      2975            3
SCOTT        20 ANALYST      3000            4
FORD         20 ANALYST      3000            4
JAMES        30 CLERK         950            1
MARTIN       30 SALESMAN     1250            2
WARD         30 SALESMAN     1250            2
TURNER       30 SALESMAN     1500            3
ALLEN        30 SALESMAN     1600            4
BLAKE        30 MANAGER      2850            5
IVANOV       50 STUDENT         0            1

*/

SELECT 
    ename, 
	deptno, 
	job, 
	sal,
	DENSE_RANK() OVER(
	                 PARTITION BY deptno 
					 ORDER BY sal
				 ) AS saldenserank
FROM emp;

/*
�������� �������:
1) �������� ������� �� ������ ���� ����������
2) ����� ���������� ���������� ����� ��������
*/

/*
�������� 8: ������� ����������������� �����������,
����� ������� ���� ����������� �� ���������� ����

������� ��������� ����������:
ENAME       SAL
-------- ------
ADAMS      1100

*/

WITH 
emp_dense_rank AS (
    SELECT 
	    ename,
		sal,
		DENSE_RANK() OVER( ORDER BY sal ) AS r
	FROM emp
)
SELECT 
    ename,
	sal
FROM emp_dense_rank
WHERE 
    r = 4;

/*
������� NTILE.
����������:
1) ����� �����, ��� �������� �����, 
 ��� ����� ����� ������������� �� ����������� ����� �������
2) ���������:
2.1) NTILE(<�������_����>)
2.2) ����� ������������� � ����������� ����� ������� � <�������_����>.
*/

/*
�������� 9: ������� ����������� �� ������ �� �'��� ����
��� ��������� ����������� �������
� ����������� ��������� �������� ��������

������� ��������� ����������:
 SALNTILE ENAME       SAL
---------- -------- ------
         1 IVANOV        0
         1 SMITH       800
         1 JAMES       950
         2 ADAMS      1100
         2 MARTIN     1250
         2 WARD       1250
         3 MILLER     1300
         3 CLARK      1500
         3 TURNER     1500
         4 ALLEN      1600
         4 BLAKE      2850
         4 JONES      2975
         5 SCOTT      3000
         5 FORD       3000
         5 KING       5000

*/

SELECT 
	NTILE(5) OVER (ORDER BY sal) AS salntile, 
	ename, 
	sal 
FROM emp;

/*
����������� �������� �������. 
������� ��������� ������:
1) PERCENT_RANK() - ������� ������� ����� = (RANK - 1) / (total_rows - 1),
  total_rows � �������� ������� ����� � �������.
2) CUME_DIST() - ������� ������� ����� ����� = (row_num) / (total_rows),
  row_num � ������� �����, �� ��������� ��������� �����
3) RATIO_TO_REPORT(<�������>) � ������ �������� ������� ��������� ����� 
  � �������� ��� ������� �� ��� ������
*/

/*
�������� 10. �������� PERCENT_RANK()
*/

SELECT 
	RANK() OVER (ORDER BY sal) AS salrank,
	PERCENT_RANK() OVER (ORDER BY sal) AS salrank,
	ename, sal
FROM emp;

/*
�������� 11. �������� CUME_DIST
*/

SELECT 
    RANK() OVER (ORDER BY sal) AS salrank,
    CUME_DIST() OVER (ORDER BY sal) AS saldist,
	ename, 
	sal
FROM emp;

/*
�������� 12: ��������� �����������, � ���� ���� (�����) ������� = 0.75
� ������ ����������� � ���������� ��������

������� ��������� ����������:
JOB        ENAME       SAL  CUME_DIST
---------- -------- ------ ----------
CLERK      ADAMS      1100        .75
SALESMAN   TURNER     1500        .75

*/
 
WITH 
emp_job_dist AS (
    SELECT 
	    job, 
		ename, 
		sal, 
	    CUME_DIST() OVER (
		                PARTITION BY job 
						ORDER BY sal
					) AS cume_dist 
	FROM emp
) 
SELECT * 
FROM emp_job_dist 
WHERE 
    cume_dist = 0.75; 

/*
�������� 13. ��������� ������ �������� ������� ����������� 
� ����������� ���� ������� ��� �����������

������� ��������� ����������:
ENAME       SAL   SALSHARE
-------- ------ ----------
KING       5000  .17809439
BLAKE      2850 .101513802
CLARK      1500 .053428317
JONES      2975 .105966162
MARTIN     1250 .044523598
TURNER     1500 .053428317
JAMES       950 .033837934
WARD       1250 .044523598
FORD       3000 .106856634
SMITH       800 .028495102
SCOTT      3000 .106856634
MILLER     1300 .046304541
IVANOV        0          0
ALLEN      1600 .056990205
ADAMS      1100 .039180766

*/

SELECT 	
    ename, 
	sal, 
	RATIO_TO_REPORT(sal) OVER () AS salshare 
FROM emp; 

/*
�������� 14. ��������� ����������, � ���� ������ �������� 
� ���� ����������� � ���������� �������� ������� 
������� �� �������� ���� ������� � ��� ����.

������� ��������� ����������:
JOB        ENAME       SAL   SALSHARE
---------- -------- ------ ----------
ANALYST    FORD       3000         .5
ANALYST    SCOTT      3000         .5

*/

WITH 
emp_job_ratio AS (	
    SELECT 	
	    job, 
		ename, 
		sal, 
	    RATIO_TO_REPORT(sal) OVER (PARTITION BY job) AS salshare 
	FROM emp
) 
SELECT * 
FROM emp_job_ratio 
WHERE 
    salshare = 0.5;

/* 
������� ��������� ������������ ����� LAG.
����������:
1) ������� ������� �������� �������� �����,
������������ ��������� ����� � ���� � �������� � ��������� ��;
2) ���������:
2.1) LAG(<�������>, [<�������>],[<�������� �� �������������>])
2.2) �� ���������� <�������>=1 � ��������� �� ��������� �����;
2.3) ����������� <�������� �� ����������>,
���� ������ �������� �� ��� ����,
� ����� ��� ������� ����� �����.

*/

/*
������� ��������� ������������ ����� LEAD.
����������:
1) ������� �������� �������� �����, ���������� �� �������� ������
� ���� � �������� � ����� �������;
2) ���������:
2.1) LEAD(<�������>, [<�������>],[<�������� �� �������������>])
2.2) �� ���������� <�������>=1 � ��������� ��������� �����;
2.3) ����������� <�������� �� ����������>,
���� ������ �������� �� ��� ����,
� ����� ��� ���������� ����� �����.
*/

/*
�������� 15. ������� ������� �������� ���������� 
�� 12 ������ ��� ���� ��
��������� �� ���� � �������� �� ��������� 
�� ������������ �� ���������� ����

������� ��������� ����������:
        M          Y    SUM_SAL PRIOR_YEAR      p_y_%  NEXT_YEAR      n_y_%
---------- ---------- ---------- ---------- ---------- ---------- ----------
        12       1980        800        800        100      22675       2834
        12       1981      22675        800          4      26975        119
        12       1982      26975      22675         84      28075        104
        12       1983      28075      26975         96      28075        100
        12       2022      28075      28075        100      28075        100


*/

WITH 
m_y_sal AS (
	SELECT 	EXTRACT(Month FROM HireDate) m, 
			EXTRACT (Year FROM HireDate) as y, Sal FROM emp
),
m_y_sal_sum AS (
	SELECT m, y, SUM(Sal) Sal 
	FROM m_y_sal 
	GROUP BY m, y
),
month_list AS (
	SELECT rownum as m FROM dual CONNECT BY level <= 12
),
year_list AS ( 	
	SELECT distinct extract (year from hiredate) y 
	FROM emp
),
month_year_list AS ( 
	SELECT y,m 
	FROM month_list, year_list
),
m_y_sal_sum_add AS ( 
	SELECT l.y,l.m,NVL(s.sal,0) Sal 
	from month_year_list l LEFT JOIN m_y_sal_sum s on (l.m = s.m and l.y = s.y) 
),
m_y_sal_sum2 AS ( 
	SELECT m, y, SUM(Sal) OVER (ORDER BY y, m) Sum_Sal 
	FROM m_y_sal_sum_add
),
m_y_sal_sum_l AS ( 
	SELECT m, y, Sum_Sal, 
			LAG(Sum_Sal,1,Sum_Sal) OVER	(ORDER BY y, m)	Prior_Year, 
			LEAD(Sum_Sal, 1, Sum_Sal) OVER (ORDER BY y, m) Next_Year 
	FROM m_y_sal_sum2 where m = 12
)
SELECT 	m,y,sum_sal,prior_year,ROUND(100*prior_year/sum_sal) "p_y_%",
		next_year, ROUND(100*next_year/sum_sal) "n_y_%" 
FROM m_y_sal_sum_l;

/*
������� ��������� ������������ ����� FIRST_VALUE,LAST_VALUE
����������:
1) �������������� ��� ������ ������������� 
 ��� ���������� �������� � ������������� �����;
2) ���������:
2.1) FIRST_VALUE(<�������>) - ������� ����� �������� �������� ����� �����;
2.2) LAST_VALUE(<�������>) - ������� ������ �������� �������� ����� �����;
2.3) NTH_VALUE(<�������>, <�������>) - ������� ����� �������� �������� �����
� ���� �� ���������� ��������� (��� Oracle 11g);
3) ������� ���������� ��� ����������� ������ ������������� ASC � DESC.
*/

/*
�������� 16. 
������� �����������, ���� ��������, 
������� �� ����������� �������� �����������,
������� �� �������� �������� ����������� � ���� ������ �������.

������� ��������� ����������:
DEPTNO ENAME       SAL    MAX_SAL  max_sal_%    MIN_SAL  min_sal_%
------ -------- ------ ---------- ---------- ---------- ----------
    10 KING       5000       5000        100       1300         26
    10 CLARK      1500       5000        333       1300         87
    10 MILLER     1300       5000        385       1300        100
    20 SCOTT      3000       3000        100        800         27
    20 FORD       3000       3000        100        800         27
    20 JONES      2975       3000        101        800         27
    20 ADAMS      1100       3000        273        800         73
    20 SMITH       800       3000        375        800        100
    30 BLAKE      2850       2850        100        950         33
    30 ALLEN      1600       2850        178        950         59
    30 TURNER     1500       2850        190        950         63
    30 MARTIN     1250       2850        228        950         76
    30 WARD       1250       2850        228        950         76
    30 JAMES       950       2850        300        950        100

*/

WITH 
emp_first_last_sal AS ( 
    SELECT 
	    deptno, ename, sal,
	    FIRST_VALUE(sal) OVER (
		                     PARTITION BY deptno ORDER BY sal DESC 
				             rows 
							     between unbounded preceding 
							     and unbounded following
						 ) as max_sal, 
	    LAST_VALUE(sal) OVER (
		                     PARTITION BY deptno ORDER BY sal DESC 
				             rows 
							     between unbounded preceding 
								 and unbounded following
						) as min_sal 
	FROM emp 
)
SELECT 
    deptno, 
	ename, 
	sal,max_sal, 
	round(100*max_sal/sal) AS "max_sal_%", 
	min_sal,
	round(100*min_sal/sal) AS "min_sal_%" 
FROM emp_first_last_sal 
WHERE 
    sal != 0
ORDER BY deptno;

/*
������� �������� ���� ������������ ���������� �������:

1) �������� �� ������ ������������.
������ ���������� ������ �� �� ������������ �������� 
������� ������������,
���� ����� ������������ � ������ ��������� ������������.

2) �������� ������������ �� ������.
��, �� ������������ �������� ������������ ���� ���� ������,
����� ���������� � ���� �����.
�� ����� ����������� ���� ����� 
�� ����������� ��� ���������� ���������.

3) ����������� ��������� �� ������.
� ������������� ���������� ������� ���� ������� 
������������� ���������� �� �볺�� -
���� ������� ����������� �� ������,
������� ����� ������ ���������� �����������������
��� �������� ���������� ������� ������ �����.

4) �������� ����������� ������� ������.
��������� ���������� ���������� ������� ���'����
� ������������ ������� ������� ������,
������������� ��� ����� �������� ��������� ����������.

*/

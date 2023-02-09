/*
������ "������ ��������� SQL-�������� � ���� Oracle".
������� 8 - ������� ���� SQL-������. ���� 2-"Query Optimization".
���������� SQL-������ �� ��������� �����
*/


SET LINESIZE 2000
SET PAGESIZE 30

/* 1 �������� ����� ���������� SQL-������ */
ALTER SESSION SET SQL_TRACE = TRUE;

/* 2 �������� � ���� ���������� ����� �������������� ������ */
ALTER SYSTEM SET TIMED_STATISTICS = TRUE; 

/* 3 ������� ������������� ������� � ���� ����� ����������
��� ���� ���������� �������������
*/
ALTER SESSION SET TRACEFILE_IDENTIFIER = 'MY_TRACE1';

/* 4 ����� ��������� �� ���� ����� */
ALTER SYSTEM SET MAX_DUMP_FILE_SIZE = UNLIMITED; 

/* 5 �������� SQL-�����, ���� ���� ��������� */
SELECT  a.ename, a.sal, a.deptno, b.salavg
 FROM  emp a, (SELECT   deptno, avg(sal) salavg
                  FROM     emp
                 GROUP BY deptno) b
 WHERE   a.deptno = b.deptno
 AND     a.sal > b.salavg;

/* 5 �������� ����� ���������� SQL-������ */
ALTER SESSION SET SQL_TRACE = FALSE;

/* 6 ��������� ������� �� ������� ���������� */
SELECT value 
FROM v$diag_info 
WHERE 
    name = 'Diag Trace'; 

/* ���������:
/opt/oracle/diag/rdbms/xe/XE/trace 
*/

/* 7 � ������� ������ ���� �� ����������� trc 
�� ���������� ��������� "MY_TRACE2" */
cd /opt/oracle/diag/rdbms/xe/XE/trace 
ls | grep "MY_TRACE1".trc

/* ���������: XE_ora_25858_MY_TRACE2.trc */

/* �������� ���� ���������� � ������������� ������ tkprof
tkprof <file.trc> <file.tkp>
*/
tkprof XE_m002_29302.trc /tmp/MY_TRACE1.tkp

/* 
�������� ������ ������:
count - ������ ���� ���� �������� �������� ������� OCI;
cpu - ����������� ��� ��������� �� �������;
elapsed - �������� ��� ���������;
disk (pr) - ������� �������� ������ ����� � �����;
query (cr) - ������� ����� ������, ��������� �� ��� ������� (����� consistent);
current - ������� ����� ������, ��������� �� ��� ����������� (����� current);
rows - ������� �����, ���������� �������� fetch ��� execute
*/

/* ������� ����� ���������� ����� ���������� /tmp/MY_TRACE1.tkp
call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        1      0.01       0.04          0          0          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch     1048      0.54       1.18      12475      13408          0       15706
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total     1050      0.56       1.23      12475      13408          0       15706

Misses in library cache during parse: 1
Optimizer mode: FIRST_ROWS
Parsing user id: 5  (SYSTEM)
Number of plan statistics captured: 1

Rows (1st) Rows (avg) Rows (max)  Row Source Operation
---------- ---------- ----------  ---------------------------------------------------
     15706      15706      15706  NESTED LOOPS  (cr=13408 pr=12475 pw=0 time=1114701 us cost=758 size=3400 card=100)
         1          1          1   VIEW  (cr=7998 pr=7996 pw=0 time=954909 us cost=744 size=48 card=3)
         1          1          1    HASH GROUP BY (cr=7998 pr=7996 pw=0 time=954905 us cost=2231 size=21 card=3)
   1100014    1100014    1100014     TABLE ACCESS FULL EMP (cr=7998 pr=7996 pw=0 time=359421 us cost=2184 size=7700098 card=1100014)
     15706      15706      15706   TABLE ACCESS FULL EMP (cr=5410 pr=4479 pw=0 time=150514 us cost=14 size=1800 card=100)


Rows     Execution Plan
-------  ---------------------------------------------------
      0  SELECT STATEMENT   MODE: FIRST_ROWS
  15706   HASH JOIN
      1    VIEW
      1     HASH (GROUP BY)
1100014      TABLE ACCESS   MODE: ANALYZED (FULL) OF 'EMP' (TABLE)
  15706    TABLE ACCESS   MODE: ANALYZED (FULL) OF 'EMP' (TABLE)
*/

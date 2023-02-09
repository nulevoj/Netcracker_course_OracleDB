/*
������ "������ ��������� SQL-�������� � ���� Oracle".
������� 9 - �������� ������������ ���������� SQL-������
*/

/*
����� �������� ���������� SQL-������:
1) �� ������� �������� ������������
	���������� ������������ ��� ���������� �������;
2) ������� ����������� ���� ��������� ����.

���� 1 - "Optimize access structures" ������ �����:
1) Database design and normalization;
2) Tables: heap or index-organized tables:
heap-organized table - �������� �������, ��� ������ ����� ��������������;
index-organized table - ������� ���:
	- �������� � ��������� ORGANIZATION INDEX, 
	- ������ ����� � ������� �������� � �������� 
		�� ���������� ���������� �����;
3) Indexes;
4) Materialized views;
5) Partitioning schemes;
6) Statistics.

���� 2 - "Rewrite SQL statements" ������ �����:
1) ���������� ��������� ��������� � ��������
2) �������������� EXISTS ������ IN, ������� EXISTS ������߹ 
	������� �� ����� �� ������ ����� ���������.
3) �������������� CASE ��/��� DECODE, ��� �������� ����������� 
	��������� ������� ����� �����, �������� ��� ������� ���������
4) �������������� JOIN ������ ��������
5) �������� ������� ����������� ���� �����, 
	�������� � WHERE-����
6) �������� ��������� WHERE-�����, ������ ��������� �� �������
	� ����������� ������� ��������� ��������� � ��������� ��������
7) ��������, ���� �� �������, ����� ��������� ���������
	�� <>, NOT IN, NOT EXISTS � LIKE ��� ����������� '%' 
	��� ������������ ��������� � ����������
8) �� ������������ ������� �� ������������ ��������� 
	���� ���� ���������� ��������������� �������;
9) �������� ���������� ��������� �� ������ UNION
	�������������� UNION ALL;
10) �������� DISTINCT;
11) �������������� PL/SQL, �������� ������ �� ����������� �����������
	�� Bind-������� 
12) ��������� ������� (Hints), ��� ��������

*/

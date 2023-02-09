/*
������ "������ ��������� SQL-�������� � ���� Oracle".
������� 1 - ������� ���� SQL-������
*/

/********** ���� �� "����� ��������" ��� ���������� ***************

1) �� ����� ��������� SQL ���� ������ ������� �� ����� 
����������� ����������� ���������;
2) ��������� ������� ��� ����� ��� ��� ��������� �������;
3) �������� SQL �������� �� ������������� ��� ��������� �������:
	- ��������� ���� ������� �������, �� ��� ���� �������;
	- ��������� �� ����� ��������� ��������� ������
4) ��� ����� ���� ������� ����� ��������� ��������� ������
5) ��� ����� ������� �������� ��������������:
	�) ������� ��������� ������ �� ���� ������� 
		� ���� ���� ���� ������;
	�) SQL ���� ������ ������� ����� ����, 
	�� ������� ��������: 
		- ���� ������� ��'���� �� ���������; 
		- ������� ����� ��������, 
		- ������ �� ��������� �� ���������.
6) ������� �� SQL-����� ������� ����:
	- ���������� - ��������� �� ������� ����������;
	- ������� - ��������� ������� ���������
		����������� ������������, � ����� � SQL-�����
7) ��� �������� ��������� ������ ���� ���������� 
	������ SQL-����� � ������ ����������� 
	�������� ������� �� �����, ���������:
	�) ����� ���������� ���'���, 
		��������� ��� ��������� ������ �� SQL-�����;  
	�) ������� �������� ����� ������ ��:
		- ������� ����������� ���'����, ��� ���������� ������;
		- �������� ������������� ���'����, 
			��� ������������� ������;
*/

/********** ���� �� "��� ��������" ��� ���������� ***************

1) ��� ������� ���� � ������� SQL-������ �� ���������� 
	������ ��������, ���� ���� ���������� �����쳺, 
	�� ��� �� ���� ���������, �������� SQL-�����;
2) ��� ������ ������� ��������� SQL-������ 
	��������� ���� ������ ���� � �������� �����:
	- ���� ������� ��������� �������;
	- ��� ���� ���� ��� ������ ������������ ������, 
	��������� ��� �� ��������� ������ 
	��� ��������� ������� ������� ������� �������
3) ��� ��������� ���������� ������ (� ��������� ������� 
	������������ ��� � �� ���������� ������ 
	� ��������� � ������� ���������� ���'��)
	���� �������� ���� ���� ���������;
4) ��� ������� ���������� ������ �������� ���� 
	�� ��������� SQL-������	��� ���� ����� ������� 
	��� �� ������������, 
	�� ���� �������� ��������������� ������ 
	�������� ������������� ������ �������
5) �������� ��������� ������ ������� �������:
	- ������� ������ ������ ���� �� "��� ��������" - 
		����� ������ ��������� ������� ����;
	- ������� ������������, �� ������� ���������� 
		� ������������� ������;
	- ������� ������� ���� SQL-������
*/

/**************** ������� ���� SQL-������ *********************

������� ���� SQL-������ ������ �������� ��� �����.

���� 1 - "Query Parsing" ������ ��� �����:
1) ������������ ����� (Syntax Check) 
	��� �������� ����������� ���� ������
2) ����������� ����� (Semantic Check) 
	��� �������� �����������:
	- ���� ��'���� ��:
		- �������, 
		- �������, 
		- �������;
	- ���� �����:
		- ������� ��������� � �������� �������;
		- ��������� � ��������� ��������� 
			��������� WHERE-�����;
	- ������� ������� �� ��'���� ��
3) ����� ������������� SQL-������ (Shared Pool Check):
	1.1) ���-�������� ����� SQL-������ ����������� ��
		���-����������, �� ���� ������ ��������� 
		���	���������� SQL-������;
	�) ���-�������� ���������� �� ����� ������ 200 ������� �����,
		���� �� ������������ ���������� ����� SQL-������,
		������ �� ���� ��������� �� �������� ���糿 ���-�������,
		���� ��� ����� ������� SQL-������ ���������� ����������;
	�) �������� ����� ���� ��������� �����:
		- ����� ������� ������ �� ��������� �������; 
		- ����� �������� ������ �� PL/SQL-��������/�������;
		- ������������ Bind-������;	
	1.2) ���� ���-�������� �� ��������, 
		��� Parsing = "Hard Parse" �� ������� �� ����� 2,
		������ - Parsing = "Soft Parse" �� ������� �� 3-�� �����,
		���� �� ����� ����������� ���������� 2-�� ����� ���
		SQL-������, ���� ��� �����������

���� 2 - "Query Optimization" ������ �'��� �����:
1) ������������� SQL-������ (Query Transformations):
	�����, �� ������� ���������� SQL-����� ��� ��������� 
	������� ��������� ����� ��������� ������, ���������:
	- ����� ���� ���������� ������� �� �� SQL-������;
	- ������������ �������� �� ��������� JOIN;
	- ����� ��������� OR �� ��������� �� ���� ��������, 
		��`������� ���������� UNION ALL 
2) ������ ������������ ��������� ����� (Query Plan Estimator): 
	- �������������� (cardinality) - ������� ������� ����� �������;
	- ������������� (selectivity) - ������� ����� �������,
		�� ������ ������� �� SQL-�����;
	- ������� (cost) - ������� ������������ ��������� 
		�� �������� �����/������ �����.
3) ��������� �������� ������; 
4) ���� ������� ����� � ��������� �������
5) ���������� ���������� ������ ����� 1-2 � Shared Pool
��� ������������ � ���������� SQL-��������

���� 3 - "Query Plan Execution" ������ �������� �����: 
1) ��������� ����� �������� ��������� ����� ������,
	�� ��� ����� ����������� System Global Area (SGA) � 
	����� �������� ������ ����� ��� ��������� 
	� ������� ������� ������ ���������� ���� ����� Oracle,
	��� ����� ����� �������� ������ �� ������ ���������:
	�) ��������� "Database buffer cache", ��� �� ����������:
	- �� ����, �� ��������� ��������� ��� ������,
		����������� ���� � ��������� ����,
	- ���� ����� � ���� �������, �� ������� ��������� 
		� ����� �� �������� � ��������� ����;
	- �� ������� �����������, ��������� �� ��, 
		����� ������� ������ �� ��������� ����;
	- ��� ����� ����� ��������� ����, 
		��� ����� ����� ����� ����������� � ���, 
		��������� ������� �������� � ���� ��������
		������������� ���'����.
	�) ���������� "Shared Pool", ��� ������ ����:
	- SQL-������, �� ����� �������� ���������������;
	- ������� ���� �����, ���������:
		- ������ ������ ������������; 
		- ��������� ������� � �������;
		- ������ ������� ������������ �� �������;
	- �������� ����� ���� PL/SQL-��������/�������
2) ������������ �� �������� ������ �� SQL-����� 
	� ������ �������� ���������-�볺����, 
	��� �������� SQL-�����

*/

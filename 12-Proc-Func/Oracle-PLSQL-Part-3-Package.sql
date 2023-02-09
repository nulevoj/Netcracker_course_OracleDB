/* 
������ "�������� ������ ����� PL/SQL � ���� Oracle".
��������
*/

/* ������ � PL/SQL
1) PL/SQL ���� ������ (packages) ��� �������� ��������� 
	�������, ��������, ���� ������ �� �������
2) ����� �� ������������ �� ���
3) ������������ �� ��� ������ ����� ���������� ������
4) ����� ������� ���� ��� ������ �����, ������� �������� 
	� �������� �������������, � �����, �� � �����, ���� ���������
*/

/* ��������� ������������ ������
CREATE OR REPLACE PACKAGE ��'�_������ 
IS
 [���������� ������_�_����]
 [������������ �������]
 [��������� �������_�_��������]
END [��'�_������]; 
*/

/* ��������� ��� ������
CREATE OR REPLACE PACKAGE BODY ��'�_������
IS
 [������� ����������]
 [���� ������������ ������� ������] ,
 [���� ������������ �������/��������]
 BEGIN
  [���������, �� �����������]
 [EXCEPTION]
  [��������� �������]
END [��'�_������];
*/

/* ����������
ҳ�� ������ ������ ���� ���������� ��� �������, 
	������� �� ��������, ���������� � ���� ������������
��� ��������� �� ��������, ������ �� ������� ������ 
	��������������� ������� ��'�_������.��'���_������
� ����� ������ ���� ������ � �������� ��������
����� ���� ���� ����, �� ����������, 
	���� ����������� ��� ������� �������� �� ������
*/

-- ��������� ��������� ������ -----------------------------
CREATE OR REPLACE PACKAGE employee_pkg IS
	FUNCTION f_combine_and_format_names(
		first_name_inout IN OUT VARCHAR2,
		last_name_inout IN OUT VARCHAR2,
		name_format_in IN VARCHAR2:='LAST, FIRST')
	RETURN VARCHAR2;
END employee_pkg;
/

-- ��������� ��� ������ 
CREATE OR REPLACE PACKAGE BODY employee_pkg IS
FUNCTION f_combine_and_format_names(first_name_inout IN OUT VARCHAR2,
   last_name_inout IN OUT VARCHAR2,
   name_format_in IN VARCHAR2:='LAST, FIRST')
   RETURN VARCHAR2
IS
 full_name_out VARCHAR2(100);
BEGIN
  first_name_inout:=UPPER(first_name_inout); 
  last_name_inout:=UPPER(last_name_inout); 
  IF name_format_in='LAST, FIRST'
  THEN
    full_name_out:=last_name_inout || ', ' || first_name_inout;
  ELSIF name_format_in='FIRST, LAST'
  THEN
    full_name_out:=first_name_inout || ', ' || last_name_inout;
  END IF;
  RETURN full_name_out;     
END;
END employee_pkg;
/

-- ������� �������
DECLARE
	first_name VARCHAR2(100);
    last_name VARCHAR2(100);
BEGIN
	first_name := 'Sidorov';
	last_name := 'Ivan';
	DBMS_OUTPUT.PUT_LINE(employee_pkg.f_combine_and_format_names(
							first_name, last_name,'LAST, FIRST'));
END;
/
 
/* ��������� ������
�����: DBMS_OUTPUT
�����: DBMS_RANDOM 
�����: DBMS_CRYPTO 
�����: DBMS_DESCRIBE
�����: DBMS_FILE_TRANSFER
�����: DBMS_JOB 	
�����: DBMS_REDEFINITION
�����: DBMS_UTILITY
�����: UTL_RECOMP 
�����: UTL_SMTP
�����: UTL_TCP
*/

/* ����������� ����� DBMS_RANDOM
����� ������ �������������� ��������. 
����� ������:
string(opt CHAR, len NUMBER) - ����� ������� ������� len
�������� opt: 
'a','A' - ����� � ����-����� ������; 
'l','L' - ����� � �������� ������; 
'p','P' - ����-�� �������� �������; 
'u','U' - ����� � ��������� ������; 
'x','X' - ����-�� ����� � ��������� ������ �� �����; 
value   - ����� � ������� �� 0 �� 1;
value(low  NUMBER, high NUMBER) - ����� � ������� �� low �� high
*/
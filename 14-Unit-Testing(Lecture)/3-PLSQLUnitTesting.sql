/* 
������ "�������� ���������� (Unit Testing) PL/SQL ���� Oracle".
������� 2 - �������� ���������� � ������������� PL/SQL

������� user_name_is_correct(user_name VARCHAR).
��� ������� TC ����������� ���������� ���, ����:
1) ������� ������ ��������� ������ ������� � ���������� �����������
2) �������� �� ����� ����������� ��� ��������� ���������:
   'Passed' - ���������� �������;
   'Failed' - ���������� �� �������

TC1 (���������� ���� �������������): 
	����� ���: user_name = user1
	���������� ��������� = true
TC2 (������������ ���� �������������):
	����� ���: user_name = 1user1
	���������� ��������� = false
TC3 (������������ ���� �������������):
	����� ���: user_name = user1234567891011
	���������� ��������� = false
*/

SET LINESIZE 2000
SET PAGESIZE 100
SET SERVEROUTPUT ON

DECLARE
    TYPE tc_elem IS RECORD (
		     input_value 	VARCHAR(30),
		     expected_result NUMBER
	     );
	TYPE tc_array IS TABLE OF tc_elem;
	tc tc_array := tc_array(
                       tc_elem('user1',1),
		               tc_elem('1user1',-1),
		               tc_elem('user1234567891011',-1)
                   );
BEGIN
    FOR i IN 1..tc.COUNT LOOP
	    DBMS_OUTPUT.PUT('TC' || i || ': ');
	    IF user_name_is_correct(tc(i).input_value) = tc(i).expected_result THEN
            DBMS_OUTPUT.PUT_LINE('Passed');
	    ELSE
	        DBMS_OUTPUT.PUT_LINE('Failed');
	    END IF;	
    END LOOP; 
END;
/

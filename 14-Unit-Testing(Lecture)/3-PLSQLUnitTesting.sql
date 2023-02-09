/* 
Лекція "Модульне тестування (Unit Testing) PL/SQL СУБД Oracle".
Частина 2 - Модульне тестування з використанням PL/SQL

Функція user_name_is_correct(user_name VARCHAR).
Для кожного TC створюється програмний код, який:
1) порівнює дійсний результат роботи функції з очікуваним результатом
2) виводить на екран повідомлення про результат порівняння:
   'Passed' - результати співпали;
   'Failed' - результати не співпали

TC1 (правильний клас еквівалентності): 
	вхідні дані: user_name = user1
	очікуваний результат = true
TC2 (неправильний клас еквівалентності):
	вхідні дані: user_name = 1user1
	очікуваний результат = false
TC3 (неправильний клас еквівалентності):
	вхідні дані: user_name = user1234567891011
	очікуваний результат = false
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

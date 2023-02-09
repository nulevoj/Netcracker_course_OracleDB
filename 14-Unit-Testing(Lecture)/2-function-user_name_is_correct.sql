/* Функція user_name_is_correct(user_name VARCHAR):
вхідні параметри:
1) user_name - ім'я користувача:
- умова 1) - рядок починається з латинської літери;
- умова 2) - довжина рядка не більше 15 символів;
результат функції: 
1 - ім'я користувача відповідає умовам;
-1 - ім'я користувача не відповідає умовам.
*/
CREATE OR REPLACE FUNCTION user_name_is_correct(
    user_name VARCHAR
)
RETURN NUMBER
IS
BEGIN
    IF regexp_like(user_name,'^[a-zA-Z][a-zA-Z0-9]*') 
	   AND length(user_name) <= 15 THEN
	    RETURN 1;
	ELSE 
	    RETURN -1;
	END IF;
END;
/


/* Using PL/SQL Basic Block Coverage to Maintain Quality 
Аналізатор покриття коду 
*/
https://docs.oracle.com/en/database/oracle/oracle-database/21/adfns/basic-block-coverage.html


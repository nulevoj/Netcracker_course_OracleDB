/* 
Лекція "Програмні пакети мовою PL/SQL в СУБД Oracle".
Приклади
*/

/* Пакети в PL/SQL
1) PL/SQL надає пакети (packages) для спільного зберігання 
	функцій, процедур, типів записів та курсорів
2) Пакет має специфікацію та тіло
3) Специфікацію та тіло пакета можна створювати окремо
4) Можна замінити одне тіло пакета іншим, зберігши сумісність 
	з існуючою специфікацією, і пакет, як і раніше, буде працювати
*/

/* Створення специфікації пакету
CREATE OR REPLACE PACKAGE ім'я_пакету 
IS
 [оголошення змінних_і_типів]
 [специфікації курсорів]
 [заголовки функцій_і_процедур]
END [ім'я_пакету]; 
*/

/* Створення тіла пакету
CREATE OR REPLACE PACKAGE BODY ім'я_пакету
IS
 [локальні оголошення]
 [повні специфікації курсорів пакету] ,
 [повні специфікації функцій/процедур]
 BEGIN
  [оператори, що виконуються]
 [EXCEPTION]
  [обробники винятків]
END [ім'я_пакету];
*/

/* Зауваження
Тіло пакета містить повні визначення всіх курсорів, 
	функцій та процедур, оголошених у його специфікації
Для звернення до процедур, змінних та функцій пакета 
	використовується нотація ім'я_пакету.об'єкт_пакету
У пакеті можуть бути описані і «приватні» елементи
Пакет може мати блок, що виконується, 
	який викликається при першому зверненні до пакета
*/

-- Створення заголовка пакету -----------------------------
CREATE OR REPLACE PACKAGE employee_pkg IS
	FUNCTION f_combine_and_format_names(
		first_name_inout IN OUT VARCHAR2,
		last_name_inout IN OUT VARCHAR2,
		name_format_in IN VARCHAR2:='LAST, FIRST')
	RETURN VARCHAR2;
END employee_pkg;
/

-- Створення тіла пакету 
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

-- приклад виклику
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
 
/* Стандартні пакети
Пакет: DBMS_OUTPUT
Пакет: DBMS_RANDOM 
Пакет: DBMS_CRYPTO 
Пакет: DBMS_DESCRIBE
Пакет: DBMS_FILE_TRANSFER
Пакет: DBMS_JOB 	
Пакет: DBMS_REDEFINITION
Пакет: DBMS_UTILITY
Пакет: UTL_RECOMP 
Пакет: UTL_SMTP
Пакет: UTL_TCP
*/

/* Стандартний пакет DBMS_RANDOM
Пакет генерує псевдовипадкові значення. 
Склад пакету:
string(opt CHAR, len NUMBER) - рядок символів довжини len
значення opt: 
'a','A' - літери в будь-якому регістрі; 
'l','L' - літери в нижньому регістрі; 
'p','P' - будь-які друковані символи; 
'u','U' - літери у верхньому регістрі; 
'x','X' - будь-які літери у верхньому регістрі та числа; 
value   - числа в діапазоні від 0 до 1;
value(low  NUMBER, high NUMBER) - числа в діапазоні від low до high
*/
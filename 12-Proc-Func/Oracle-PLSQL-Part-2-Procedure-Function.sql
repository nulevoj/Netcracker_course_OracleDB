/* 
Лекція "Збережені процедури, функції мовою PL/SQL в СУБД Oracle".
Приклади

*/

/* 
Збережена процедура – це певний набір інструкцій, написаних мовою PL/SQL.
Процедура зберігається в базі даних, тому і називається збереженою.
Збережена процедура може виконувати SQL-оператори та маніпулювати даними у таблицях.
Збережену процедуру можна викликати з іншої збереженої процедури, збереженої функції 
	або тригера, а також безпосередньо з рядка запрошення SQL*Plus.
*/

/* Збережена процедура складається з двох основних частин: 
1) Заголовок включає в себе
	- ім'я процедури
	- опис її вхідних та вихідних даних (формальні параметри)
2) Тіло процедури – це блок PL/SQL-коду
Значення, що задаються під час виклику процедури, називаються фактичними параметрами
*/

/* Структура процедури PL/SQL
CREATE PROCEDURE ім'я 
[(параметр, [параметр…] 
IS
[оголошення]
BEGIN
оператори, що виконуються
[EXCEPTION
обробники винятків]
END [ім'я];
*/

/* Приклади заголовків збережених процедур
increase_prices 
increase_prices (percent_increase NUMBER)
increase_salary_find_tax
 (increase_percent IN NUMBER := 7,
  sal IN OUT NUMBER, tax OUT NUMBER)
1) Параметру increase_percent присвоєно значення за замовчуванням, що дорівнює 7 
2) Типи даних у процедурі не можуть мати специфікацій розміру: можна вказати 
	для параметра тип даних NUMBER, але не NUMBER(10,2)
*/

/* Режим параметру IN
Режим IN означає, що під час виклику процедура може зчитати з цього 
	параметра вхідне значення, але цьому параметру не можна надавати 
	значення або будь-яким іншим методом модифікувати його.
Цей режим використовується за замовчуванням.
Як фактичний параметр може виступати змінна, літерал або обчислювальний вираз.
*/

/* Режим параметру OUT
Режим OUT означає, що процедура може використовувати 
	цей параметр як вихідний, тобто для повернення значення 
	в ту програму, з якої вона була викликана.
Для вихідних параметрів не можна встановити значення за замовчуванням. 
	Йому можна надати значення тільки в тілі модуля.
Фактичний параметр, що відповідає формальному вихідному параметру, має бути змінною.
*/

/* Режим параметрУ IN OUT
Режим IN OUT означає, що значення параметра можна передавати 
	в модуль і повертати їх назад програмі, що викликає.
Для параметрів з режимом IN OUT не можна встановити значення за замовчуванням.
Фактичний параметр, що відповідає формальному параметру, має бути змінною.
*/

/* Створення збереженої процедури
1) Просте створення
	CREATE PROCEDURE заголовок_процедури IS тіло_процедури
2) Створення із заміною
	CREATE OR REPLACE заголовок_процедури IS тіло_процедури
У разі виникнення помилок компіляції, інформацію про помилки можна отримати командою SHOW ERRORS;
*/

/* Виклик збереженої процедури
1) Динамічний виклик
	EXECUTE my_first_proc;
2) В коді блоків
   BEGIN
	my_second_proc(2,3);
   END;
*/

/* Зв'язування формальних та фактичних параметрів
Зв'язування за позицією: фактичний параметр асоціюється з формальним неявно
	EXECUTE my_first_proc (фактичний параметр1, фактичний параметр2);
Зв'язування за ім'ям: фактичний параметр асоціюється з формальним явно
	EXECUTE my_first_proc (формальний параметр2 => фактичний параметр2, формальний параметр1 => фактичний параметр1);
Змішане зв'язування
*/

SET SERVEROUTPUT ON

-- 1 --------------------------------------------
CREATE OR REPLACE PROCEDURE combine_and_format_names 
	( first_name_inout IN OUT VARCHAR2,
		last_name_inout IN OUT VARCHAR2,
		full_name_out OUT VARCHAR2,
		name_format_in IN VARCHAR2:='LAST, FIRST'
	)
IS
BEGIN
	first_name_inout:=UPPER(first_name_inout); 
	last_name_inout:=UPPER(last_name_inout);
	IF name_format_in='LAST, FIRST'	THEN
		full_name_out:=last_name_inout || ', ' ||
		first_name_inout;
	ELSIF name_format_in='FIRST, LAST' THEN
		full_name_out:=first_name_inout || ', ' || 
		last_name_inout;
	END IF;
END;
/

-- 2 Приклад виклику збереженої процедури
DECLARE
	first_name_inout varchar2(30);
	last_name_inout varchar2(30);
	v_full_name varchar2(30);
BEGIN
	first_name_inout := 'Sidorov';
	last_name_inout := 'Ivan';
	COMBINE_AND_FORMAT_NAMES(first_name_inout,
		last_name_inout,v_full_name,'LAST, FIRST');
	DBMS_OUTPUT.PUT_LINE(v_full_name);
END;
/

-- 3 Інший приклад реалізації цієї процедури
CREATE OR REPLACE PROCEDURE combine_and_format_names 
	( first_name_in IN VARCHAR2,
		last_name_in IN VARCHAR2,
		full_name_out OUT VARCHAR2,
		name_format_in IN VARCHAR2:='LAST, FIRST'
	)
IS
	first_name_out VARCHAR2(30);
	last_name_out VARCHAR2(30);
BEGIN
	first_name_out:=UPPER(first_name_in); 
	last_name_out:=UPPER(last_name_in);
	IF name_format_in='LAST, FIRST'	THEN
		full_name_out:=last_name_out || ', ' || first_name_out;
	ELSIF name_format_in='FIRST, LAST' THEN
		full_name_out:=first_name_out || ', ' || last_name_out;
	END IF;
	dbms_output.put(full_name_out);	
END;
/

-- виведення повідомлень про помилку в SQLPlus
show errors;

-- 4 Приклад виклику збереженої процедури
DECLARE
	v_full_name varchar2(30);
BEGIN
	combine_and_format_names('Sidorov','Ivan',
			v_full_name,'LAST, FIRST');
	DBMS_OUTPUT.PUT_LINE(v_full_name);
END;
/
 
/* Збережена функція PL/SQL
Функція PL/SQL схожа на процедуру PL/SQL: вона також має заголовок та тіло
На відміну від виклику процедури, що є окремим оператором, виклик функції 
	завжди є частиною оператора, тобто він включається у вираз або 
	служить як значення за замовчуванням, що присвоюється змінній при оголошенні
Зв'язування фактичних і формальних параметрів можливе і за позицією, і за назвою
*/

/* Структура функції PL/SQL
CREATE FUNCTION ім'я [(параметр, [параметр…])
RETURN тип_даних_що_повертаються
IS
[оголошення]
BEGIN
оператори, що виконуються
[EXCEPTION
обробники винятків]
END [ім'я];
*/

/* Створення збереженої функції
1) CREATE FUNCTION заголовок_функції IS тіло_функції
2) CREATE OR REPLACE заголовок_функції IS тіло_функції
*/

/* Виклик збереженої функції
BEGIN
  DBMS_OUTPUT.PUT_LINE(my_first_func);
END;

*/

-- 5  Приклад у вигляді збереженої функції
CREATE OR REPLACE FUNCTION f_combine_and_format_names ( 
    first_name_in IN VARCHAR2,
    last_name_in IN VARCHAR2,
    name_format_in IN VARCHAR2:='LAST, FIRST'
)
RETURN VARCHAR2
IS
	first_name_out VARCHAR2(30);
	last_name_out VARCHAR2(30);
	full_name_out VARCHAR2(60);
BEGIN
	first_name_out:=UPPER(first_name_in); 
	last_name_out:=UPPER(last_name_in);
	IF name_format_in='LAST, FIRST'	THEN
		full_name_out:=last_name_out || ', ' || first_name_out;
	ELSIF name_format_in='FIRST, LAST' THEN
		full_name_out:=first_name_out || ', ' || last_name_out;
	END IF;
	RETURN full_name_out;
END;
/
SHOW ERROR;

-- 6 Приклад виклику збереженої функції за допомогою команди SQL*Plus EXECUTE
EXECUTE DBMS_OUTPUT.PUT_LINE(f_combine_and_format_names('Sidorov','Ivan','LAST, FIRST'));
		

-- 7 Приклад 2 у вигляді збереженої функції
CREATE OR REPLACE FUNCTION GET_COUNT_EMP ( v_job emp.job%TYPE )
RETURN NUMBER
IS
	sql_str VARCHAR2(500);
	count_emp NUMBER;
BEGIN
	BEGIN
		sql_str := 'SELECT count(*) FROM emp WHERE job = :1';
		EXECUTE IMMEDIATE sql_str INTO count_emp USING IN v_job; 
		RETURN count_emp;
	EXCEPTION
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Error in query:' || sql_str);
	END;
END; 
/ 

-- виклик збереженої функції за межами PL/SQL-блоку
EXEC DBMS_OUTPUT.PUT_LINE('Count=' || GET_COUNT_EMP('CLERK'));

-- Спроба видалення локацій без контролю каскадного видалення
DELETE FROM loc where lname = 'NEW_YORK';
/* Очікуваний результат:
ERROR at line 1:
ORA-02292: integrity constraint 
(STUDENT.DEPT_LOCNO_FK) violated - child record found
*/

/* 8 Видалення міста (локації) із поверненням з функції його номера.
При спробі каскадного видалення виводиться перелік підрозділів,
розташованих у цьому місті
*/
CREATE OR REPLACE FUNCTION drop_city( city_name loc.lname%TYPE)
RETURN loc.locno%TYPE
IS
	TYPE LocList IS TABLE OF loc.locno%TYPE;
	loc_list LocList;
	TYPE DeptList IS TABLE OF dept.dname%TYPE;
	dept_list DeptList;
BEGIN
	BEGIN
	/* видалення записів із збереженням значень колонок у колекції */
	DELETE FROM loc WHERE lname = city_name
		RETURNING locno BULK COLLECT INTO loc_list;
	IF SQL%ROWCOUNT = 0 THEN RETURN -1;
	ELSE 
			RETURN loc_list(1);
	END IF;
	EXCEPTION 
		WHEN OTHERS THEN
		  DBMS_OUTPUT.PUT_LINE('Location id #');
		  SELECT dname
				BULK COLLECT INTO dept_list
				from dept d join loc l on (d.locno = d.locno)
				where l.lname = city_name;
			FOR i IN dept_list.FIRST .. dept_list.LAST
			LOOP
				DBMS_OUTPUT.PUT_LINE(dept_list(i));
			END LOOP;
			RETURN -2;
	END; 
END;
/
show errors;

-- приклад виклику функції за межами PL/SQL-блоку
EXEC DBMS_OUTPUT.PUT_LINE(drop_city('NEW_YORK'));

-- 9 Ще один приклад
CREATE SEQUENCE users_user_id;
DROP TABLE users;
CREATE TABLE users (
	user_id number(4) PRIMARY KEY,
	user_name varchar(30) UNIQUE NOT NULL,
	password varchar(30) NOT NULL
);

/* Специфікація функції add_user
Вхідні параметри:
1) user_name - ім'я користувача:
	рядок символів:
		- починається з латинської літери;
		- довжина рядка не більше 30 символів.
2) password - пароль користувача:
	рядок символів:
		- довжина рядка не менше 8 символів.
Значення, що повертається:
	>0 	- користувача успішно створено
	-1 	- ім'я користувача починається з цифри
	-2	- довжина рядка з паролем менше 8 символів
	-3	- користувач з таким ім'ям вже існує
*/

CREATE OR REPLACE FUNCTION add_user ( 	
    user_name IN users.user_name%TYPE,
    password IN users.password%TYPE
)
RETURN users.user_id%TYPE
IS
	user_id users.user_id%TYPE;
	res NUMBER(1);
	user_name_first_letter exception;
	password_length exception;
BEGIN
	/* перевірка умови: 
	рядок user_name починається з латинської літери */
	SELECT count(1) INTO res FROM DUAL 
		WHERE REGEXP_LIKE(user_name,'^[a-zA-Z]\D*');
	DBMS_OUTPUT.PUT_LINE('res=' || res);
	IF res = 0 THEN 
	    user_id := -1; 
		RAISE user_name_first_letter; 
	END IF;
	/* перевірка умови: 
	довжина рядка password не менше 8 символів*/
	IF LENGTH(password) < 8 THEN 
	    user_id := -2; 
		RAISE password_length; 	
	END IF;
	/* генерація унікального значення user_id */ 
	SELECT users_user_id.nextval INTO user_id from dual;
	/* внесення значень колонок user_id,user_name,password в таблицю users */
	INSERT INTO users VALUES (user_id,user_name,password);
	RETURN user_id;
EXCEPTION
	WHEN user_name_first_letter THEN
		RAISE_APPLICATION_ERROR(-20551,
			'user_name: first symbol must be a letter');
	WHEN password_length THEN
		RAISE_APPLICATION_ERROR(-20552,
			'password: length >= 8 symbols');
	WHEN others THEN
		RETURN -1;
END;
/

show errors;

/* TestCase №1.
user_name = user1
password = 12345678

Очікуваний результат:
1) Рядок з повідомленням "User added with user_id = 1"
2) не порожня відповідь на запит select * from users where user_id = 1;
*/
DECLARE
	user_id users.user_id%TYPE;
	user_name users.user_name%TYPE;
	password users.password%TYPE;
BEGIN
	user_name := 'user1';
	password := '12345678';
	user_id := add_user(user_name,password);
	DBMS_OUTPUT.PUT_LINE('User added with user_id = ' || user_id);
END;
/

/* TestCase №2.
Вхідні параметри:
user_name = 1user2
password = 12345678

Очікуваний результат:
Рядок з повідомленням про помилку:
ERROR at line 1:
ORA-20555: user_name: first symbol must be a letter
*/
DECLARE
	user_id users.user_id%TYPE;
	user_name users.user_name%TYPE;
	password users.password%TYPE;
BEGIN
	user_name := '1user2';
	password := '12345678';
	user_id := add_user(user_name,password);
END;
/

/* TestCase №3.
Вхідні параметри:
user_name = user2
password = 1234567

Очікуваний результат:
Рядок з повідомленням про помилку
ERROR at line 1:
ORA-20552: password: length >= 8 symbols
*/
DECLARE
	user_id users.user_id%TYPE;
	user_name users.user_name%TYPE;
	password users.password%TYPE;
BEGIN
	user_name := 'user2';
	password := '1234567';
	user_id := add_user(user_name,password);
	DBMS_OUTPUT.PUT_LINE('User added with user_id = ' || user_id);
END;
/

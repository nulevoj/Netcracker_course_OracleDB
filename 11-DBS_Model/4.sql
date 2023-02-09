
-- Етап 4. Динамічні SQL-команди мови PL/SQL СУБД Oracle

/*
	4.1. Виконайте введення 5 рядків у таблицю бази даних 
	із динамічною генерацією команди. 
	Значення первинного ключа генеруються автоматично, 
	решта даних дублюється.
*/

DECLARE
	v_id student.student_id%TYPE;
	v_room student.room_id%TYPE;
	v_name student.name%TYPE;
	v_faculty student.faculty%TYPE;
	v_date student.date_of_birth%TYPE;
	v_email student.email%TYPE;
	v_phone student.phone%TYPE;
	sql_str VARCHAR2(500);
BEGIN
	sql_str := 'INSERT INTO student '
		|| '(student_id, room_id, name, faculty, date_of_birth, email, phone) '
		|| 'VALUES (:1, :2, :3, :4, :5, :6, :7)';
	FOR i IN 1..5 LOOP
		v_id := student_sq.NEXTVAL;
		v_room := 3;
		v_name := 'Artem';
		v_faculty := 'DevOps';
		v_date := TO_DATE('10/04/2001', 'DD/MM/YYYY');
		v_email := 'Art_mo9@gmail.com';
		v_phone := '+38(050)243-74-28';
		EXECUTE IMMEDIATE sql_str
			USING v_id, v_room, v_name, v_faculty, v_date, v_email, v_phone;
	END LOOP;
END;

ROLLBACK;

/*
	PL/SQL procedure successfully completed.
*/

/*
	4.2. Скласти динамічний запит створення таблиці, 
	іменами колонок якої будуть значення будь-якої символьної колонки. 
	Попередньо виконати перевірку існування таблиці з її видаленням.
	
	Створю таблицю з назвами факультетів
*/



DROP TABLE student_new;

DECLARE
	sql_str VARCHAR2(500);
BEGIN
	sql_str := 'CREATE TABLE student_new (';
	FOR item IN (SELECT DISTINCT REGEXP_REPLACE(faculty, ' ', '_') fac FROM student) LOOP
		sql_str := sql_str 
			|| item.fac
			|| ' VARCHAR2(20),';
	END LOOP;
	sql_str := RTRIM(sql_str,',') || ')';
    DBMS_OUTPUT.PUT_LINE(sql_str);
	EXECUTE IMMEDIATE sql_str;
END;

SELECT * FROM student_new;

/*
	CREATE TABLE student_new (
		Databases VARCHAR2(20),
		Computer_science VARCHAR2(20),
		Cyber_security VARCHAR2(20),
		Game_Dev VARCHAR2(20),
		Design VARCHAR2(20))
*/

/*
	4.3. Команда ALTER SEQUENCE може змінювати початкове значення генератора 
	починаючи з СУБД версії 12. Для ранніх версій доводиться виконувати дві команди: 
	видалення генератора та створення генератора з новим початковим значенням.
	З урахуванням вашої предметної області створити анонімний PL/SQL-блок, 
	який викликатиме один із варіантів SQL-запитів зміни початкового значення генератора 
	залежно від значення версії СУБД.
*/

CREATE SEQUENCE sq;

DECLARE
	version NUMBER(2) := DBMS_DB_VERSION.VERSION;
	start_value NUMBER(5) := 100;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Oracle version: ' || version);
	IF version < 12 THEN
		EXECUTE IMMEDIATE 'DROP SEQUENCE sq';
        EXECUTE IMMEDIATE 'CREATE SEQUENCE sq START WITH ' || start_value;
	ELSE
        EXECUTE IMMEDIATE 'ALTER SEQUENCE sq RESTART START WITH ' || start_value;
	END IF;
END;

/*
	PL/SQL procedure successfully completed.
*/



-- Етап 2. Збережені процедури та функції

/*
	2.1. Повторити виконання завдання 1 етапу 1, 
	створивши процедуру з вхідним параметром у вигляді кількості рядків, що вносяться.
	Навести приклад виконання створеної процедури.
*/

create or replace PROCEDURE timer(counter IN OUT INTEGER)
IS
	t1 INTEGER;
	t2 INTEGER;
	delta INTEGER;
BEGIN
	DBMS_OUTPUT.PUT_LINE('counter = ' || counter);
    t1 := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..counter LOOP
        INSERT INTO hostel (
            hostel_id,
            address,
            rating,
            amount_of_floors,
            amount_of_rooms)
        VALUES (
            hostel_sq.nextval,
            'Chinese Street',
            7.47,
            5,
            40);
    END LOOP;
    t2 := DBMS_UTILITY.GET_TIME;
    delta := t2 - t1;
    DBMS_OUTPUT.PUT_LINE('Delta time (centisec): ' || delta);
	ROLLBACK;
END;



DECLARE
    a NUMBER(5) := 5000;
BEGIN
    timer(a);
END;

/*
	counter = 5000
	Delta time (centisec): 54
*/

/*
	2.2. Створити функцію, яка повертає суму значень 
	однієї з цілих колонок однієї з таблиць. 
	Навести приклад виконання створеної функції.
	
	Вивести скільки студентів можна розмістити у гуртожитку
*/

create or replace PROCEDURE amount
	(
		result OUT INTEGER,
		id IN INTEGER
	)
IS
BEGIN
	SELECT SUM(max_amount_of_students) "a" INTO result FROM room WHERE hostel_id = id;
    DBMS_OUTPUT.PUT_LINE('Max amount of students in hostel #' || id || ': ' || result);
END;



DECLARE
	max_amount NUMBER;
BEGIN
	amount(max_amount, 1);
END;

/*
	Max amount of students in hostel #1: 8
*/



-- Етап 3. Програмні пакети

/*
	3.1. Оформіть рішення завдань етапу 2 у вигляді програмного пакета. 
	Наведіть приклад виклику збереженої процедури та функції, враховуючи назву пакету.
*/

CREATE OR REPLACE PACKAGE hostel_pac IS
	PROCEDURE timer(counter IN OUT INTEGER);
	PROCEDURE amount(result OUT INTEGER, id IN INTEGER);
END hostel_pac;

CREATE OR REPLACE PACKAGE BODY hostel_pac IS
	PROCEDURE timer(counter IN OUT INTEGER)
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
	
	PROCEDURE amount
		(
			result OUT INTEGER,
			id IN INTEGER
		)
	IS
	BEGIN
		SELECT SUM(max_amount_of_students) "a" INTO result FROM room WHERE hostel_id = id;
		DBMS_OUTPUT.PUT_LINE('Max amount of students in hostel #' || id || ': ' || result);
	END;
END hostel_pac;



DECLARE
    a NUMBER(5) := 5000;
	max_amount NUMBER;
BEGIN
    timer(a);
	amount(max_amount, 1);
END;

/*
	Package HOSTEL_PAC compiled
	Package Body HOSTEL_PAC compiled
	PL/SQL procedure successfully completed.
	
	counter = 5000
	Delta time (centisec): 52
	Max amount of students in hostel #1: 8
*/


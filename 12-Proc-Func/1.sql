
-- Етап 1. Колекції PL/SQL

/*
	1.1. Повторіть виконання завдання 4 етапу 1 із попередньої лабораторної роботи:
	− циклічно внести 5000 рядків;
	− визначити загальний час на внесення зазначених рядків;
	− вивести на екран значення часу. 
*/

DECLARE
    t1 INTEGER;
    t2 INTEGER;
    delta INTEGER;
BEGIN
    t1 := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..5000 LOOP
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
END;

ROLLBACK;

/*
	Delta time (centisec): 56
*/

/*
	1.2. Повторіть виконання попереднього завдання, 
	порівнявши час виконання циклічних внесень рядків, 
	використовуючи два способи: FOR і FORALL.
*/

DROP TABLE hostel1;
DROP TABLE hostel2;

CREATE TABLE hostel1(
	hostel_id NUMBER(5),
	address VARCHAR(50)
);
CREATE TABLE hostel2(
	hostel_id NUMBER(5),
	address VARCHAR(50)
);

DECLARE
    TYPE id_tab IS TABLE OF hostel.hostel_id%TYPE INDEX BY PLS_INTEGER;
    TYPE address_tab IS TABLE OF hostel.address%TYPE INDEX BY PLS_INTEGER;
    ids id_tab;
    addresses address_tab;
    iterations CONSTANT PLS_INTEGER := 5000;
    t1 INTEGER; t2 INTEGER; delta1 INTEGER; delta2 INTEGER;
BEGIN
    FOR i IN 1..iterations LOOP
        ids(i) := i;
        addresses(i) := 'Iv-' || TO_CHAR(i);
    END LOOP;
    t1 := DBMS_UTILITY.GET_TIME;
    
    FOR j IN 1..iterations LOOP
        INSERT INTO hostel1 (hostel_id, address)
        VALUES (ids(j), addresses(j));
    END LOOP;
    t2 := DBMS_UTILITY.GET_TIME;
    delta1 := t2 - t1;

    t1 := DBMS_UTILITY.GET_TIME;
    FORALL i IN 1..iterations
        INSERT INTO hostel2 (hostel_id, address)
        VALUES (ids(i), addresses(i));
    t2 := DBMS_UTILITY.GET_TIME;
    delta2 := t2 - t1;
    
    DBMS_OUTPUT.PUT_LINE('Execution time (sec)');
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE('FOR-loop: ' || TO_CHAR((delta1)/100));
    DBMS_OUTPUT.PUT_LINE('FORALL-operator:   ' || TO_CHAR((delta2)/100));
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
END;

ROLLBACK;

/*
	Execution time (sec)
	FOR-loop: .35
	FORALL-operator:   .01
*/

/*
	1.3. Для однієї з таблиць отримайте рядки з використанням курсору 
	та пакетної обробки SELECT-операції з оператором BULK COLLECT.
*/

DEClARE
	TYPE hstl IS TABLE OF hostel%ROWTYPE;
	hostel_list hstl;
BEGIN
	SELECT hostel_id, address, rating, amount_of_floors, amount_of_rooms, hierarchy
		BULK COLLECT INTO hostel_list FROM hostel;
	DBMS_OUTPUT.PUT_LINE('hostel list: ');
	FOR i IN hostel_list.FIRST .. hostel_list.LAST
		LOOP
			DBMS_OUTPUT.PUT_LINE(
				hostel_list(i).hostel_id || ' | ' ||
				hostel_list(i).address || ' | ' ||
				hostel_list(i).rating
			);
		END LOOP;
END;

/*
	hostel list: 
	24 | Ocean Avenue, 375 | 7.65
	25 | quiet quiet place | 6.66
	1 | Zelena St. 5 | 5.5
	2 | Chill road 65 | 8.75
	4 | Victory Square, 4 | 9.23
	5 | Blue Square, 1 | 6.52
*/



-- Етап 2. Обробка виняткових ситуацій у PL/SQL СУБД Oracle

/*
	2.1. Повторити виконання завдання 3 етапу 1, 
	забезпечивши контроль відсутності даних у відповіді на запит із використанням винятку.
*/

DECLARE
    v_room_avg_area room.area%TYPE;
BEGIN
    SELECT area
    INTO v_room_avg_area
    FROM room
    WHERE hostel_id = -2;
    DBMS_OUTPUT.PUT_LINE('avg area of room = ' || v_room_avg_area);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('no data found');
END;

/*
	no data found
*/

/*
	2.2. Повторити виконання завдання 3 етапу 1, 
	забезпечивши контроль отримання багаторядкової відповіді на запит.
*/

DECLARE
    v_room_avg_area room.area%TYPE;
BEGIN
    SELECT area
    INTO v_room_avg_area
    FROM room
    WHERE hostel_id = 1;
    DBMS_OUTPUT.PUT_LINE('avg area of room = ' || v_room_avg_area);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('no data found');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('only one value is expected');
END;

/*
	only one value is expected
*/

/*
	2.3. Повторити виконання завдання 3 етапу 1, 
	забезпечивши контроль за внесенням унікальних значень.
*/

BEGIN
	INSERT INTO student(
        student_id,
        room_id,
        name,
        faculty,
        date_of_birth,
        email,
        phone)
	VALUES(
        1,
        2,
        'Roman',
        'Design',
        TO_DATE('11/03/2002', 'DD/MM/YYYY'),
        'brasla@ukr.net',
        '+38(096)395-29-91');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('row with this PK is already exist');
END;

/*
	row with this PK is already exist
*/


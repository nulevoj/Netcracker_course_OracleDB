
-- Етап 1. Основи мовних конструкцій мови PL/SQL СУБД Oracle

/*
	1.1. Виберіть таблицю бази даних, що містить стовпець типу date. 
	Оголосіть змінні, що відповідають стовпцям цієї таблиці, 
	використовуючи посилальні типи даних. Надайте змінним значення, 
	використовуйте SQL-функції для формування значень послідовності, 
	перетворення дати до вибраного стилю. Виведіть на екран рядок.
*/

DECLARE
    v_student student%ROWTYPE;
BEGIN
    v_student.student_id := student_sq.nextval;
    v_student.room_id := 2;
    v_student.name := 'Roman';
    v_student.faculty := 'Design';
    v_student.date_of_birth := TO_DATE('11/03/2002', 'DD/MM/YYYY');
    v_student.email := 'brasla@ukr.net';
    v_student.phone := '+38(096)395-29-91';
    DBMS_OUTPUT.PUT_LINE('name = ' || v_student.name);
    DBMS_OUTPUT.PUT_LINE('faculty = ' || v_student.faculty);
    DBMS_OUTPUT.PUT_LINE('date_of_birth = ' || v_student.date_of_birth);
    DBMS_OUTPUT.PUT_LINE('email = ' || v_student.email);
    DBMS_OUTPUT.PUT_LINE('phone = ' || v_student.phone);
END;

/*
	name = Roman
	faculty = Design
	date_of_birth = 11-MAR-02
	email = brasla@ukr.net
	phone = +38(096)395-29-91
*/

/*
	1.2. Додати інформацію до однієї з таблиць, обрану у попередньому завданні.
	Використовувати формування нового значення послідовності та перетворення формату дати.
*/

DECLARE
	v_student student.student_id%TYPE;
BEGIN
	v_student := student_sq.NEXTVAL;
	INSERT INTO student(
        student_id,
        room_id,
        name,
        faculty,
        date_of_birth,
        email,
        phone)
	VALUES(
        v_student,
        2,
        'Roman',
        'Design',
        TO_DATE('11/03/2002', 'DD/MM/YYYY'),
        'brasla@ukr.net',
        '+38(096)395-29-91');
END;

/*
	PL/SQL procedure successfully completed.
*/

/*
	1.3. Для однієї з таблиць створити команду отримання середнього значення 
	однієї з цілих колонок, використовуючи умову вибірки за заданим значенням іншої колонки. 
	Результат присвоїти змінній і вивести на екран.
*/

DECLARE
    v_room_avg_area room.area%TYPE;
BEGIN
    SELECT AVG(area)
    INTO v_room_avg_area
    FROM room
    WHERE hostel_id = 1;
    DBMS_OUTPUT.PUT_LINE('avg area of room = ' || v_room_avg_area);
END;

/*
	avg area of room = 72
*/

/*
	1.4. Виконайте введення 5 рядків у таблицю бази даних, 
	використовуючи цикл з параметрами. Значення первинного ключа 
	генеруються автоматично, решта даних дублюється.
*/

BEGIN
    FOR i IN 1..5 LOOP
        INSERT INTO student(
            student_id,
            room_id,
            name,
            faculty,
            date_of_birth,
            email,
            phone)
        VALUES(
            student_sq.nextval,
            2,
            'john',
            'Design',
            TO_DATE('08/12/2001', 'DD/MM/YYYY'),
            'halfy@ukr.net',
            '+38(066)574-35-88');
    END LOOP;
END;

/*
	PL/SQL procedure successfully completed.
*/



/*
	1.1. Для всіх таблиць нової БД створити генератори послідовності, 
	щоб забезпечити автоматичне створення нових значень колонок, 
	які входять у первинний ключ. 
	Врахувати наявність рядків у таблицях. 
	Виконати тестове внесення одного рядка до кожної таблиці.
*/

CREATE SEQUENCE hostel_sq START WITH 3 INCREMENT BY 1;
CREATE SEQUENCE room_sq START WITH 3 INCREMENT BY 1;
CREATE SEQUENCE student_sq START WITH 5 INCREMENT BY 1;
CREATE SEQUENCE technique_sq START WITH 3 INCREMENT BY 1;
CREATE SEQUENCE furniture_sq START WITH 3 INCREMENT BY 1;

INSERT INTO hostel(
        hostel_id,
        adress,
        rating,
        amount_of_floors,
        amount_of_rooms
    )
    VALUES(
        hostel_sq.NEXTVAL,
        'Victory Square, 4',
        9.23,
        7,
        50
);

INSERT INTO room(
        room_id,
        hostel_id,
        room_number,
        area,
        inspection_date,
        amount_of_windows,
        max_amount_of_students
    )
    VALUES(
        room_sq.NEXTVAL,
        2,
        1,
        45,
        TO_DATE('22/09/22', 'DD/MM/YY'),
        2,
        2
);

INSERT INTO student(
        student_id,
        room_id,
        name,
        faculty,
        date_of_birth
    )
    VALUES(
        student_sq.NEXTVAL,
        3,
        'Vasiliy',
        'Cyber security',
        TO_DATE('14/03/03', 'DD/MM/YY')
);

INSERT INTO technique(
        technique_id,
        room_id,
        fridge,
        microwave,
        TV
    )
    VALUES(
        technique_sq.NEXTVAL,
        3,
        1,
        1,
        1
);

INSERT INTO furniture(
        furniture_id,
        room_id,
        amount_of_beds,
        amount_of_tables,
        amount_of_wardrobes,
        amount_of_bedsideTables
    )
    VALUES(
        furniture_sq.NEXTVAL,
        3,
        2,
        1,
        2,
        2
);

/*
	1.2 Для всіх пар взаємопов'язаних таблиць створити транзакції, 
	що включають дві INSERT-команди внесення рядка в дві таблиці кожної пари 
	з урахуванням зв'язку між PK-колонкою першої таблиці і FK-колонкою 2-ї таблиці 
	пари з використанням псевдоколонок NEXTVAL і CURRVAL.
*/

INSERT INTO hostel(
        hostel_id,
        adress,
        rating,
        amount_of_floors,
        amount_of_rooms
    )
    VALUES(
        hostel_sq.NEXTVAL,
        'Blue Square, 1',
        6.52,
        4,
        40
);

INSERT INTO room(
        room_id,
        hostel_id,
        room_number,
        area,
        inspection_date,
        amount_of_windows,
        max_amount_of_students
    )
    VALUES(
        room_sq.NEXTVAL,
        hostel_sq.CURRVAL,
        1,
        63,
        TO_DATE('12/08/22', 'DD/MM/YY'),
        2,
        3
);

INSERT INTO student(
        student_id,
        room_id,
        name,
        faculty,
        date_of_birth
    )
    VALUES(
        student_sq.NEXTVAL,
        room_sq.CURRVAL,
        'Vitaliy',
        'Computer science',
        TO_DATE('06/02/01', 'DD/MM/YY')
);

INSERT INTO technique(
        technique_id,
        room_id,
        fridge,
        microwave,
        TV
    )
    VALUES(
        technique_sq.NEXTVAL,
        room_sq.CURRVAL,
        1,
        0,
        0
);

INSERT INTO furniture(
        furniture_id,
        room_id,
        amount_of_beds,
        amount_of_tables,
        amount_of_wardrobes,
        amount_of_bedsideTables
    )
    VALUES(
        furniture_sq.NEXTVAL,
        room_sq.CURRVAL,
        3,
        1,
        2,
        2
);


/*
	1.3 Отримати інформацію про створені генератори послідовностей, 
	використовуючи системну таблицю СУБД Oracle.
*/

SELECT * FROM USER_SEQUENCES;

/*
	SEQUENCE_NAME	MIN_VALUE	MAX_VALUE						INCREMENT_BY
1	FURNITURE_SQ	1			9999999999999999999999999999	1
2	HOSTEL_SQ		1			9999999999999999999999999999	1
3	ROOM_SQ			1			9999999999999999999999999999	1
4	STUDENT_SQ		1			9999999999999999999999999999	1
5	TECHNIQUE_SQ	1			9999999999999999999999999999	1
*/

/*
	1.4 Використовуючи СУБД Oracle >= 12 для однієї з таблиць 
	створити генерацію унікальних значень PK-колонки через DEFAULT-оператор. 
	Виконати тестове внесення одного рядка до таблиці.
*/

ALTER TABLE hostel MODIFY (hostel_id NUMBER DEFAULT hostel_sq.NEXTVAL NOT NULL);
ALTER TABLE room MODIFY (room_id NUMBER DEFAULT room_sq.NEXTVAL NOT NULL);
ALTER TABLE student MODIFY (student_id NUMBER DEFAULT student_sq.NEXTVAL NOT NULL);
ALTER TABLE technique MODIFY (technique_id NUMBER DEFAULT technique_sq.NEXTVAL NOT NULL);
ALTER TABLE furniture MODIFY (furniture_id NUMBER DEFAULT furniture_sq.NEXTVAL NOT NULL);

INSERT INTO student(
        room_id,
        name,
        faculty,
        date_of_birth
    )
    VALUES(
        4,
        'Oleg',
        'Computer science',
        TO_DATE('16/12/01', 'DD/MM/YY')
);


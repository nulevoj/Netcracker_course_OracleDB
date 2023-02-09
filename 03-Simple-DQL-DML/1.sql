/*
    1.1 Для кожної таблиці БД створити команди внесення даних, тобто внести по два рядки.
*/
INSERT INTO hostel (
        hostel_id, 
        adress, 
        rating, 
        amount_of_floors, 
        amount_of_rooms
    )
    VALUES (
        1, 
        'Zelena St. 5', 
        5.5, 
        4, 
        40
);

INSERT INTO hostel (
        hostel_id, 
        adress, 
        rating, 
        amount_of_floors, 
        amount_of_rooms
    )
    VALUES (
        2, 
        'Chill road 65', 
        8.75, 
        6, 
        55
);
    
INSERT INTO room (
        room_id, 
        hostel_id, 
        room_number, 
        area, 
        inspection_date, 
        amount_of_windows, 
        max_amount_of_students
        )
    VALUES (
        1, 
        1,
        1,
        96,
        TO_DATE ('11/10/2022', 'DD/MM/YYYY'),
        3,
        4
);
    
INSERT INTO room (
        room_id, 
        hostel_id, 
        room_number, 
        area, 
        inspection_date, 
        amount_of_windows, 
        max_amount_of_students
        )
    VALUES (
        2, 
        1,
        2,
        55,
        TO_DATE ('9/10/2022', 'DD/MM/YYYY'),
        1,
        2
);

INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty
    )
    VALUES (
    1,
    1,
    'Nikolay',
    'Game Dev'
);
    
INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty
    )
    VALUES (
    2,
    1,
    'Konstantin',
    'Game Dev'
);

INSERT INTO technique (
    technique_id,
    room_id,
    fridge,
    microwave,
    TV
    )
    VALUES (
    1,
    1,
    1,
    1,
    1
);

INSERT INTO technique (
    technique_id,
    room_id,
    fridge,
    microwave,
    TV
    )
    VALUES (
    2,
    2,
    0,
    0,
    1
);

INSERT INTO furniture (
    furniture_id,
    room_id,
    amount_of_beds,
    amount_of_tables,
    amount_of_wardrobes,
    amount_of_bedsideTables
    )
    VALUES (
    1,
    1,
    4,
    2,
    2,
    4
);

INSERT INTO furniture (
    furniture_id,
    room_id,
    amount_of_beds,
    amount_of_tables,
    amount_of_wardrobes,
    amount_of_bedsideTables
    )
    VALUES (
    2,
    2,
    2,
    1,
    1,
    1
);

/*
	1.2 Для однієї з таблиць створити команду додавання колонки типу date з урахуванням предметної області.
*/

ALTER TABLE Student ADD date_of_birth DATE;

/*
	1.3 Для зазначеної таблиці створити команду на внесення одного рядка, 
	але з невизначеним значенням колонки типу date.
*/

INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty
    )
    VALUES (
    3,
    2,
    'Oleg',
    'Design'
);

/*
	1.4 Створити команду налаштування формату date = dd/mm/yyyy.
*/

ALTER SESSION SET nls_date_format = 'dd/mm/yyyy';

/*
	1.5 Для задіяної в завданні 1.2 таблиці створити ще одну команду на внесення одного рядка 
	з урахуванням значення колонки типу date.
*/

INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty,
	date_of_birth
    )
    VALUES (
    4,
    2,
    'Kirill',
    'Design',
	TO_DATE ('15/04/2002', 'DD/MM/YYYY')
);

/*
	1.6 Для однієї з таблиць, що містить обмеження цілісності потенційного ключа, виконати 
	команду додавання нового рядка зі значенням колонки, що порушує це обмеження. 
	Перевірити реакцію СКБД на таку зміну.
*/

INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty,
	date_of_birth
    )
    VALUES (
    4,
    1,
    'Vova',
    'Sys admin',
	TO_DATE ('30/01/2003', 'DD/MM/YYYY')
);

-- ORA-00001: unique constraint (SYECHYN.STUDENT_PK) violated

/*
	1.7 Для однієї з таблиць, що містить обмеження цілісності зовнішнього ключа, виконати
	команду додавання нового рядка зі значенням колонки зовнішнього ключа, який відсутній у
	колонці первинного ключа відповідної таблиці. Перевірити реакцію СКБД на подібне додавання,
	яке порушує обмеження цілісності зовнішнього ключа.
*/

INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty,
	date_of_birth
    )
    VALUES (
    5,
    3,
    'Vova',
    'Sys admin',
	TO_DATE ('30/01/2003', 'DD/MM/YYYY')
);

-- ORA-02291: integrity constraint (SYECHYN.STUDENT_FK) violated - parent key not found

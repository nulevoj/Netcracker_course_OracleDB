
/*
	3.1 Створити нового користувача, ім'я якого = «ваше_прізвище_латиницею»+'EAV', 
	наприклад, blazhko_eav, з правами, достатніми для створення та заповнення таблиць БД EAV.
*/

CREATE USER syechyn_eav IDENTIFIED BY pass1234;
GRANT CONNECT TO syechyn_eav;
GRANT RESOURCE TO syechyn_eav;
GRANT CREATE VIEW TO syechyn_eav;
ALTER USER syechyn_eav quota unlimited on USERS;

/*
	3.2 Створити таблиці БД EAV та заповнити таблиці об'єктних типів та атрибутних типів, 
	взявши рішення з лабораторної роботи No5.
*/

CREATE TABLE objtype (
    object_type_id NUMBER(20),
    parent_id NUMBER(20),
    code VARCHAR2(20),
    name VARCHAR2(200),
    description VARCHAR2(1000)
);

ALTER TABLE objtype ADD CONSTRAINT objtype_pk
    PRIMARY KEY (object_type_id);
ALTER TABLE objtype ADD CONSTRAINT objtype_code_unique
    UNIQUE (code);
ALTER TABLE objtype 
    MODIFY(code NOT NULL);
ALTER TABLE objtype ADD CONSTRAINT objtype_fk
    FOREIGN KEY (parent_id) REFERENCES objtype(object_type_id);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        1,
        NULL,
        'Hostel',
        'Гуртожиток',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        2,
        1,
        'Room',
        'Кімната',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        3,
        2,
        'Student',
        'Студент',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        4,
        2,
        'Technique',
        'Технічне обладнання',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        5,
        2,
        'Furniture',
        'Меблеве обладнання',
        NULL
);


CREATE TABLE attrtype (
	attr_id NUMBER(20),
	object_type_id NUMBER(20),
	object_type_id_ref NUMBER(20),
	code VARCHAR2(30),
	name VARCHAR2(200)
);

ALTER TABLE attrtype ADD CONSTRAINT attrtype_PK
	PRIMARY KEY (attr_id);
ALTER TABLE attrtype ADD CONSTRAINT attrtype_object_type_id_FK
	FOREIGN KEY (object_type_id) REFERENCES objtype (object_type_id);
ALTER TABLE attrtype ADD CONSTRAINT attrtype_object_type_id_ref_FK
	FOREIGN KEY (object_type_id_ref) REFERENCES objtype (object_type_id);

CREATE SEQUENCE attrtype_sq START WITH 1 INCREMENT BY 1;

INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        1,
        NULL,
        'adress',
        'Адреса'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        1,
        NULL,
        'rating',
        'Оцінка гуртожитку'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        1,
        NULL,
        'amount_of_floors',
        'Кількість поверхів'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        1,
        NULL,
        'amount_of_rooms',
        'Загальна кількість кімнат'
);

-- room
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        2,
        1,
        'hostel_id',
        'Посилання на гуртожиток'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        2,
        NULL,
        'room_number',
        'Номер кімнати в гуртожитку'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        2,
        NULL,
        'area',
        'Площа кімнати'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        2,
        NULL,
        'inspection_date',
        'Дата перевірки кімнати'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        2,
        NULL,
        'amount_of_windows',
        'Кількість вікон'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        2,
        NULL,
        'max_amount_of_students',
        'Макс. кількість студентів'
);
-- student
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        3,
        2,
        'room_id',
        'Посилання на кімнату'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        3,
        NULL,
        'name',
        'Ім*я'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        3,
        NULL,
        'faculty',
        'Факультет'
);
-- technique
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        4,
        2,
        'room_id',
        'Посилання на кімнату'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        4,
        NULL,
        'fridge',
        'Наявність холодильника'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        4,
        NULL,
        'microwave',
        'Наявність мікрохвильовки'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        4,
        NULL,
        'TV',
        'Наявність телевізора'
);
-- furniture
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        5,
        2,
        'room_id',
        'Посилання на кімнату'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        5,
        NULL,
        'amount_of_beds',
        'Кількість ліжок'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        5,
        NULL,
        'amount_of_tables',
        'Кількість столів'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        5,
        NULL,
        'amount_of_wardrobes',
        'Кількість шаф'
);
INSERT INTO attrtype (
        attr_id,
        object_type_id,
        object_type_id_ref,
        code,
        name
    )
    VALUES (
        attrtype_sq.NEXTVAL,
        5,
        NULL,
        'amount_of_bedsideTables',
        'Кількість тумбочок'
);

/*
	3.3 Створити генератор послідовності таблиці OBJECTS БД EAV, 
	ініціалізувавши його початковим значенням з урахуванням вже заповнених значень.
*/

CREATE SEQUENCE objects_sq START WITH 5 INCREMENT BY 1;

/*
	3.4 Налаштувати права доступу нового користувача до таблиць схеми даних із таблицями 
	реляційної БД вашої предметної області, створеної в лабораторній роботі No2.
*/

GRANT SELECT ON syechyn.hostel TO syechyn_eav;
GRANT SELECT ON syechyn.room TO syechyn_eav;
GRANT SELECT ON syechyn.student TO syechyn_eav;
GRANT SELECT ON syechyn.technique TO syechyn_eav;
GRANT SELECT ON syechyn.furniture TO syechyn_eav;

/*
	3.5 Створити множину запитів типу INSERT INTO ... SELECT, які автоматично заповнять 
	таблицю OBJECTS, взявши потрібні дані з реляційної бази даних вашої предметної області.
*/

CREATE TABLE objects (
    object_id NUMBER(20),
    parent_id NUMBER(20),
    object_type_id NUMBER(20),
    name VARCHAR2(2000),
    description VARCHAR2(4000)
);

ALTER TABLE objects ADD CONSTRAINT objects_PK
    PRIMARY KEY (object_id);
ALTER TABLE objects ADD CONSTRAINT objects_parent_id_FK
    FOREIGN KEY (parent_id) REFERENCES objects (object_id);
ALTER TABLE objects ADD CONSTRAINT objects_object_type_id_FK
    FOREIGN KEY (object_type_id) REFERENCES objtype (object_type_id);


-- Hostel
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    ) SELECT 
        objects_sq.NEXTVAL,
        NULL,
        objtype.object_type_id,
        hostel.adress,
        NULL
    FROM objtype, syechyn.hostel hostel
    WHERE objtype.code = 'Hostel';

-- Room
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    ) SELECT 
        objects_sq.NEXTVAL,
        NULL,
        objtype.object_type_id,
        'Room ' || room.room_number,
        NULL
    FROM objtype, syechyn.room room
    WHERE objtype.code = 'Room';

-- Student
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    ) SELECT 
        objects_sq.NEXTVAL,
        NULL,
        objtype.object_type_id,
        student.name,
        NULL
    FROM objtype, syechyn.student student
    WHERE objtype.code = 'Student';

-- Technique
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    ) SELECT 
        objects_sq.NEXTVAL,
        NULL,
        objtype.object_type_id,
        'Technique ' || technique.technique_id,
        NULL
    FROM objtype, syechyn.technique technique
    WHERE objtype.code = 'Technique';

-- Furniture
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    ) SELECT 
        objects_sq.NEXTVAL,
        NULL,
        objtype.object_type_id,
        'Furniture ' || furniture.furniture_id,
        NULL
    FROM objtype, syechyn.furniture furniture
    WHERE objtype.code = 'Furniture';


SELECT object_id,
        object_type_id,
        name
    FROM objects;
/*
	OBJECT_ID	OBJECT_TYPE_ID	NAME
1	5			1				Zelena St. 5
2	6			1				Chill road 65
3	7			1				Victory Square, 4
4	8			1				Blue Square, 1
5	24			2				Room 1
6	25			2				Room 2
7	26			2				Room 1
8	27			2				Room 1
9	28			3				Nikolay
10	29			3				Konstantin
11	30			3				Vasiliy
12	31			3				Vitaliy
13	32			3				Oleg
14	33			3				Oleg
15	34			3				Kirill
16	35			4				Technique 1
17	36			4				Technique 2
18	37			4				Technique 3
19	38			4				Technique 4
20	39			5				Furniture 1
21	40			5				Furniture 2
22	41			5				Furniture 3
23	42			5				Furniture 4
*/


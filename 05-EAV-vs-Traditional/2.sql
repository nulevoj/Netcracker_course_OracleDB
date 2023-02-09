
/*
	2.1. Створити таблицю описів атрибутних типів.
*/

CREATE TABLE attrtype (
	attr_id NUMBER(20),
	object_type_id NUMBER(20),
	object_type_id_ref NUMBER(20),
	code VARCHAR2(20),
	name VARCHAR2(200)
);

ALTER TABLE attrtype ADD CONSTRAINT attrtype_PK
	PRIMARY KEY (attr_id);
ALTER TABLE attrtype ADD CONSTRAINT attrtype_object_type_id_FK
	FOREIGN KEY (object_type_id) REFERENCES objtype (object_type_id);
ALTER TABLE attrtype ADD CONSTRAINT attrtype_object_type_id_ref_FK
	FOREIGN KEY (object_type_id_ref) REFERENCES objtype (object_type_id);

/*
	2.2 Для раніше використаних класів UML-діаграми заповнити описи атрибутних типів.
*/
-- hostel
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
	2.3 Отримати інформацію про атрибутні типи.
*/

SELECT o.code,
        a.attr_id,
        a.code,
        a.name
    FROM objtype o, attrtype a
    WHERE o.object_type_id = a.object_type_id
    ORDER BY a.object_type_id, a.attr_id;

/*
	CODE		ATTR_ID		CODE						NAME
1	Hostel		1			adress						Адреса
2	Hostel		2			rating						Оцінка гуртожитку
3	Hostel		3			amount_of_floors			Кількість поверхів
4	Hostel		4			amount_of_rooms				Загальна кількість кімнат
5	Room		5			hostel_id					Посилання на гуртожиток
6	Room		6			room_number					Номер кімнати в гуртожитку
7	Room		7			area						Площа кімнати
8	Room		8			inspection_date				Дата перевірки кімнати
9	Room		9			amount_of_windows			Кількість вікон
10	Room		12			max_amount_of_students		Макс. кількість студентів
11	Student		13			room_id						Посилання на кімнату
12	Student		14			name						Ім*я
13	Student		15			faculty						Факультет
14	Technique	16			room_id						Посилання на кімнату
15	Technique	17			fridge						Наявність холодильника
16	Technique	18			microwave					Наявність мікрохвильовки
17	Technique	19			TV							Наявність телевізора
18	Furniture	20			room_id						Посилання на кімнату
19	Furniture	21			amount_of_beds				Кількість ліжок
20	Furniture	22			amount_of_tables			Кількість столів
21	Furniture	23			amount_of_wardrobes			Кількість шаф
22	Furniture	24			amount_of_bedsideTables		Кількість тумбочок
*/

/*
	2.4 Отримати інформацію про атрибутні типи та можливі зв'язки між ними типу «іменована асоціація».
*/

SELECT o.code,
        a.attr_id,
        a.code,
        a.name,
        o_ref.code o_ref
    FROM objtype o, attrtype a
        LEFT JOIN objtype o_ref
        ON (a.object_type_id_ref = o_ref.object_type_id)
    WHERE o.object_type_id = a.object_type_id
    ORDER BY a.object_type_id, a.attr_id;

/*
	CODE		ATTR_ID		CODE						NAME							O_REF
1	Hostel		1			adress						Адреса							(null)
2	Hostel		2			rating						Оцінка гуртожитку				(null)
3	Hostel		3			amount_of_floors			Кількість поверхів				(null)
4	Hostel		4			amount_of_rooms				Загальна кількість кімнат		(null)
5	Room		5			hostel_id					Посилання на гуртожиток			Hostel
6	Room		6			room_number					Номер кімнати в гуртожитку		(null)
7	Room		7			area						Площа кімнати					(null)
8	Room		8			inspection_date				Дата перевірки кімнати			(null)
9	Room		9			amount_of_windows			Кількість вікон					(null)
10	Room		12			max_amount_of_students		Макс. кількість студентів		(null)
11	Student		13			room_id						Посилання на кімнату			Room
12	Student		14			name						Ім*я							(null)
13	Student		15			faculty						Факультет						(null)
14	Technique	16			room_id						Посилання на кімнату			Room
15	Technique	17			fridge						Наявність холодильника			(null)
16	Technique	18			microwave					Наявність мікрохвильовки		(null)
17	Technique	19			TV							Наявність телевізора			(null)
18	Furniture	20			room_id						Посилання на кімнату			Room
19	Furniture	21			amount_of_beds				Кількість ліжок					(null)
20	Furniture	22			amount_of_tables			Кількість столів				(null)
21	Furniture	23			amount_of_wardrobes			Кількість шаф					(null)
22	Furniture	24			amount_of_bedsideTables		Кількість тумбочок				(null)
*/
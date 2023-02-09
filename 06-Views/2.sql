
/*
	Використовується БД зберігання об'єктно-реляційної моделі EAV, 
	створена та заповнена у лабораторній роботі No 5
*/

/*
	2.1 Створити віртуальну таблицю, структура та вміст якої відповідає рішенню 
	завдання 2.3 з лабораторної роботи No5, але враховує опцію «WITH READ ONLY»: 
	отримати інформацію про атрибутні типи. Отримати вміст таблиці.
*/

CREATE OR REPLACE VIEW objtype_attrtype (
        obj_code,
        attr_id,
        attr_code,
        attr_name
    ) AS
    SELECT o.code,
            a.attr_id,
            a.code,
            a.name
        FROM objtype o, attrtype a
        WHERE o.object_type_id = a.object_type_id
        ORDER BY a.object_type_id, a.attr_id
        WITH READ ONLY;

SELECT * FROM objtype_attrtype;
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
	2.2 Виконати видалення одного рядка з віртуальної таблиці, 
	створеної у попередньому завданні. Прокоментувати реакцію СУБД.
*/

DELETE FROM objtype_attrtype WHERE attr_id = 1;

/*
	ORA-42399: cannot perform a DML operation on a read-only view
	View, відкритий у режимі читання, не доступний для редагування
*/

/*
	2.3 Створити віртуальну таблицю, що містить дві колонки: 
	назва класу, кількість екземплярів об'єктів класу. Отримати вміст таблиці.
*/

CREATE OR REPLACE VIEW obj_count (
        obj_type,
        obj_count
    ) AS
    SELECT objtype.name,
            COUNT (objects.object_id)
        FROM objtype, objects
        WHERE objects.object_type_id = objtype.object_type_id
        GROUP BY objtype.name;

SELECT * FROM obj_count;

/*
	OBJ_TYPE	OBJ_COUNT
1	Гуртожиток	2
2	Кімната		2
*/

/*
	2.4 Перевірити можливість виконання операції зміни даних у віртуальній таблиці, 
	створеної у попередньому завданні. Прокоментувати реакцію СУБД.
*/

UPDATE obj_count
SET obj_count = 1
WHERE obj_count.obj_type = 'Кімната';

/*
	SQL Error: ORA-01732: data manipulation operation not legal on this view
	Результат агрегуючих функцій змінювати не можна
*/



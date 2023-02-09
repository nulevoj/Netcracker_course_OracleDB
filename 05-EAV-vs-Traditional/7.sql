
/*
	7.1 Виконати запит до БД, результат якого відповідає результату виконання запиту 
	на підставі рішення завдання No 4.2 лабораторної роботи No 3:
	
	Для однієї з таблиць створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови: 
	символьне значення однієї з колонок має співпадати з якимось константним значенням.
*/

SELECT hostels.object_id id,
        hostels.name name,
        address.value address,
        rating.value rating,
        amount_of_floors.value amount_of_floors,
        amount_of_rooms.value amount_of_rooms
    FROM objects hostels,
        objtype hostels_type,
        attributes address,
        attributes rating,
        attributes amount_of_floors,
        attributes amount_of_rooms
    WHERE hostels_type.code = 'Hostel'
    AND hostels_type.object_type_id = hostels.object_type_id
    AND hostels.object_id = address.object_id
    AND hostels.object_id = rating.object_id
    AND hostels.object_id = amount_of_floors.object_id
    AND hostels.object_id = amount_of_rooms.object_id
    AND address.attr_id = 1
    AND rating.attr_id = 2
    AND amount_of_floors.attr_id = 3
    AND amount_of_rooms.attr_id = 4
    AND rating.value >= 7;

/*
	ID	NAME		ADDRESS			RATING	AMOUNT_OF_FLOORS	AMOUNT_OF_ROOMS
1	2	Hostel Two	Chill road 65	8.75	6					55
*/

/*
	7.2 Виконати запит до БД, результат якого відповідає результату виконання запиту 
	на підставі рішення завдання No 6.1 лабораторної роботи No 3: 
	
	Для однієї з таблиць створити команду отримання кількості рядків таблиці.
*/

SELECT COUNT(object_id) "Hostels count"
    FROM objects
    WHERE object_type_id = 1;

/*
	Hostels count
1	2
*/

/*
	7.3 Виконати запит до БД, результат якого відповідає результату виконання запиту 
	на підставі рішення завдання No 3.2 лабораторної роботи No 4: 
	
	Для двох таблиць, пов'язаних через PK-колонку та FK-колонку, створити команду отримання двох 
	колонок першої та другої таблиць з використанням екві-з’єднання таблиць. Використовувати префікси.
*/

SELECT hostels.name "Hostel name",
        room_number.value "Room number",
        area.value "Area"
    FROM objects hostels,
        objects rooms,
        attributes room_number,
        attributes area
    WHERE hostels.object_id = rooms.parent_id
    AND rooms.object_id = room_number.object_id
    AND rooms.object_id = area.object_id
    AND room_number.attr_id = 6
    AND area.attr_id = 7;

/*
	Hostel name		Room number		Area
1	Hostel One		1				96
2	Hostel One		2				55
*/


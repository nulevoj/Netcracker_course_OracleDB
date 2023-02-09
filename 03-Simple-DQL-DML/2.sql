/*
	2.1 Для однієї з таблиць створити команду отримання значень всіх колонок 
	(явно перерахувати) у всіх рядках.
*/

SELECT
    hostel_id,
    adress,
    rating,
    amount_of_floors,
    amount_of_rooms
    FROM hostel;

/*

	HOSTEL_ID	ADRESS				RATING		AMOUNT_OF_FLOORS	AMOUNT_OF_ROOMS
1	1			Zelena St. 5		5.5			4					40
2	2			Chill road 65		8.75		6					55

*/


/*
	2.2 Для однієї з таблиць створити команду отримання цілого числа колонки 
	з використанням будь-якої арифметичної операції. 
	При виведенні на екран визначити для зазначеної колонки нову назву псевдоніма.
*/

SELECT
    room_id,
    room_number,
    area,
    max_amount_of_students,
    area / max_amount_of_students area_per_student
    FROM room;

/*

ROOM_ID		ROOM_NUMBER		AREA	MAX_AMOUNT_OF_STUDENTS		AREA_PER_STUDENT
1			1				96		4							24
2			2				55		2							27.5

*/


/*
	2.3 Для однієї з таблиць, що містить колонку зовнішнього ключа створити команду 
	отримання значення колонки без дублювання значень.
*/

SELECT DISTINCT room_id FROM student;

/*

	ROOM_ID
1	1
2	2

*/


/*
	2.4 Для однієї з таблиць створити команду отримання результату конкатенації значень 
	будь-яких двох колонок. При виведенні на початок рядка виведення додати літерал «UNION=».
*/

SELECT 
    'UNION = ' || name || ' is a student of ' || faculty || ' faculty'
	AS student
    FROM student;

/*

	STUDENT
1	UNION = Nikolay is a student of Game Dev faculty
2	UNION = Konstantin is a student of Game Dev faculty
3	UNION = Oleg is a student of Design faculty
4	UNION = Kirill is a student of Design faculty

*/


/*
	2.5 Модернізувати рішення завдання 2.2, отримавши в порядку зростання значення псевдоніму.
*/

SELECT
    room_id,
    room_number,
    area,
    max_amount_of_students,
    area / max_amount_of_students area_per_student
    FROM room
    ORDER BY area_per_student ASC;


/*

	ROOM_ID 	ROOM_NUMBER 	AREA 	MAX_AMOUNT_OF_STUDENTS	 	AREA_PER_STUDENT
1	1			1				96		4							24
2	2			2				55		2							27.5

*/

/*
	2.6 Для однієї з таблиць створити команду отримання значення двох колонок, 
	значення яких відсортовані в порядку зростання (для першої колонки) 
	та в порядку зменшення (друга колонка).
*/

SELECT
    area,
    max_amount_of_students
	FROM room
	ORDER BY area ASC, max_amount_of_students DESC;

/*
	AREA, 	MAX_AMOUNT_OF_STUDENTS
1	55		2
2	96		4

*/
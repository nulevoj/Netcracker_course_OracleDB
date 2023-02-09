
/*
	3.1 Для будь-яких двох таблиць створити команду отримання декартового добутку.
*/

SELECT
    room.room_number,
    student.name,
    student.faculty
    FROM room CROSS JOIN student;

/*
	ROOM_NUMBER		NAME		FACULTY
1	1				Nikolay		Game Dev
2	1				Konstantin	Game Dev
3	1				Vasiliy		Cyber security
4	1				Vitaliy		Computer science
5	1				Oleg		Computer science
6	1				Oleg		Design
7	1				Kirill		Design
8	2				Nikolay		Game Dev
9	2				Konstantin	Game Dev
10	2				Vasiliy		Cyber security
11	2				Vitaliy		Computer science
12	2				Oleg		Computer science
13	2				Oleg		Design
14	2				Kirill		Design
15	1				Nikolay		Game Dev
16	1				Konstantin	Game Dev
17	1				Vasiliy		Cyber security
18	1				Vitaliy		Computer science
19	1				Oleg		Computer science
20	1				Oleg		Design
21	1				Kirill		Design
22	1				Nikolay		Game Dev
23	1				Konstantin	Game Dev
24	1				Vasiliy		Cyber security
25	1				Vitaliy		Computer science
26	1				Oleg		Computer science
27	1				Oleg		Design
28	1				Kirill		Design
*/


/*
	3.2 Для двох таблиць, пов'язаних через PK-колонку та FK-колонку, 
	створити команду отримання двох колонок першої та другої таблиць 
	з використанням екві-з’єднання таблиць. Використовувати префікси.
*/

SELECT
    room.room_number,
    room.area,
    room.max_amount_of_students,
    student.name,
    student.faculty
    FROM room INNER JOIN student ON(student.room_id = room.room_id);
	
/*
	ROOM_NUMBER		AREA	MAX_AMOUNT_OF_STUDENTS	NAME		FACULTY
1	1				96		4						Konstantin	Game Dev
2	1				96		4						Nikolay		Game Dev
3	2				55		2						Oleg		Design
4	2				55		2						Kirill		Design
5	1				45		2						Vasiliy		Cyber security
6	1				63		3						Oleg		Computer science
7	1				63		3						Vitaliy		Computer science
*/

/*
	3.3 Повторити рішення попереднього завдання, 
	застосувавши автоматичне визначення умов екві-з’єднання.
*/

SELECT
    room.room_number,
    room.area,
    room.max_amount_of_students,
    student.name,
    student.faculty
    FROM room NATURAL JOIN student;

/*
	3.4 Повторити рішення завдання 3.2, замінивши еквіз'єднання на зовнішнє з'єднання 
	(лівостороннє або правостороннє), яке дозволить побачити рядки таблиці з PK-колонкою, 
	не пов'язані з FK-колонкою.
*/

SELECT
    hostel.hostel_id,
    hostel.adress,
    room.room_id,
    room.hostel_id,
    room.area
    FROM hostel LEFT OUTER JOIN room ON(hostel.hostel_id = room.hostel_id);

/*
	HOSTEL_ID	ADRESS				ROOM_ID		HOSTEL_ID_1		AREA
1	1			Zelena St. 5		1			1				96
2	1			Zelena St. 5		2			1				55
3	2			Chill road 65		3			2				45
4	4			Victory Square, 4	(null)		(null)			(null)
5	5			Blue Square, 1		4			5				63
*/

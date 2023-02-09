
/*
	Етап 1. DQL із вкладеними запитами.
*/

/*
	1. Виконання простих однорядкових підзапитів із екві-з'єднанням або тета-з'єднанням.
	На рисунку 1 показані приклади простих однорядкових підзапитів з екві-з'єднанням або тета-з'єднанням.
	Створіть схожий запит, використовуючи одну або дві таблиці вашої бази даних.
	
	Обрати кімнати, в яких площа більша або дорівнює площі кімнати з id = 2.
*/

SELECT room_id id,
        area,
        amount_of_windows
    FROM room
    WHERE area >= (
        SELECT area
            FROM room
            WHERE room_id = 2
        );
/*
	ID	AREA	AMOUNT_OF_WINDOWS
1	1	96		3
2	2	55		1
3	4	63		2
*/

/*
	2. Використання агрегатних функцій у підзапитах.
	На рисунку 2 показаний приклад використання агрегатних функцій у підзапитах.
	Створіть схожий запит, використовуючи одну або дві таблиці вашої бази даних.
	
	Обрати кімнати, в яких кількість вікон дорівнює максимальній кількості вікон серед усіх кімнат.
*/

SELECT room_id id,
        area,
        amount_of_windows
    FROM room
    WHERE amount_of_windows = ( SELECT MAX(amount_of_windows) FROM room );
/*
	ID	AREA	AMOUNT_OF_WINDOWS
1	1	96		3
*/

/*
	3. Пропозиція HAVING із підзапитами.
	На рисунку 3 показаний приклад використання пропозиції HAVING у підзапиті.
	Створіть схожий запит, використовуючи одну або дві таблиці вашої бази даних.
	
	Обрати гуртожитки, в яких середня площа більша або дорівнює 
	середній площі усіх кімнат з усіх гуртожитків.
*/

SELECT hostel_id,
        AVG(area)
    FROM room
    GROUP BY hostel_id
    HAVING AVG(area) >= ( SELECT AVG(area) FROM room );
/*
	HOSTEL_ID	AVG(AREA)
1	1			75.5
*/

/*
	4. Виконання багаторядкових підзапитів.
	На рисунку 4 показаний приклад використання операторів ALL, ANY у багаторядкових підзапитах.
	Створіть схожий запит, використовуючи одну або дві таблиці вашої бази даних.
	
	Обрати кімнати, в яких кількість вікон більше або дорівнює 
	середньому значенню в будь-якому гуртожитку.
*/

SELECT room_id id,
        hostel_id,
        area,
        amount_of_windows
    FROM room
    WHERE amount_of_windows >= ANY (
        SELECT AVG(amount_of_windows)
            FROM room
            GROUP BY hostel_id
        );

/*
	ID	HOSTEL_ID	AREA	AMOUNT_OF_WINDOWS
1	1	1			96		3
2	4	5			63		2
3	3	2			45		2
*/

/*
	5. Використання оператора WITH для структуризації запиту.
	На рисунку 5 показаний приклад використання підзапитів в операторі WITH.
	Створіть схожий запит, використовуючи одну або дві таблиці вашої бази даних.
	
	Обрати кімнати, в яких площа більша ніж середня площа у їх гуртожитках.
*/

WITH area_avg
    AS (
        SELECT hostel_id,
            AVG (area) asd
        FROM room
        GROUP BY hostel_id 
    ) 
    SELECT room_id,
            room.hostel_id,
            area,
            amount_of_windows
        FROM room, area_avg
        WHERE area_avg.hostel_id = room.hostel_id
        AND room.area >= area_avg.asd;

/*
	ROOM_ID		HOSTEL_ID	AREA	AMOUNT_OF_WINDOWS
1	1			1			96		3
2	3			2			45		2
3	4			5			63		2
*/

/*
	6. Використання кореляційних підзапитів.
	На рисунку 6 показаний приклад використання кореляційних підзапитів з оператором EXISTS.
	Створіть схожий запит, використовуючи одну або дві таблиці вашої бази даних.
	
	Обрати гуртожитки, на яких немає посилань у таблиці кімнат.
*/

SELECT hostel.hostel_id,
        hostel.address
    FROM hostel
    WHERE NOT EXISTS (
        SELECT room.hostel_id
            FROM room
            WHERE room.hostel_id = hostel.hostel_id);

/*
	HOSTEL_ID	ADDRESS
1	4			Victory Square, 4
*/


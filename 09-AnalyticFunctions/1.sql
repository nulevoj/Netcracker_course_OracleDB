
/*
	1. Одна з колонок таблиці повинна містити значення, що повторюються, 
	для виділення підгруп, інша колонка повинна мати числові значення. 
	Створіть запит, який отримає усереднені (avg) значення другої колонки 
	кожного рядка в кожній підгрупі.
*/

SELECT
	hostel_id,
	room_id,
	room_number,
	area,
	AVG(area) OVER (PARTITION BY hostel_id) avg_area
	FROM room;

/*
 HOSTEL_ID    ROOM_ID ROOM_NUMBER       AREA   AVG_AREA
---------- ---------- ----------- ---------- ----------
         1          1           1         96 72.3333333
         1          2           2         55 72.3333333
         1         23           3         66 72.3333333
         2          3           1         45         45
         5          4           1         63         63
*/

/*
	2. Одна з колонок таблиці повинна містити значення, що повторюються, 
	для виділення підгруп, інша колонка повинна мати числові значення. 
	Створіть запит, який отримає накопичувальні підсумки другої колонки.
*/

SELECT
	hostel_id,
	room_id,
	room_number,
	area,
	SUM(area) OVER (ORDER BY hostel_id, room_id) total_area
	FROM room;

/*
 HOSTEL_ID    ROOM_ID ROOM_NUMBER       AREA TOTAL_AREA
---------- ---------- ----------- ---------- ----------
         1          1           1         96         96
         1          2           2         55        151
         1         23           3         66        217
         2          3           1         45        262
         5          4           1         63        325
*/

/*
	3. Виконайте попереднє завдання, отримавши накопичувальні підсумки в кожній підгрупі окремо.
*/

SELECT
	hostel_id,
	room_id,
	room_number,
	area,
	SUM(area) OVER (PARTITION BY hostel_id ORDER BY room_number) total_area
	FROM room;

/*
 HOSTEL_ID    ROOM_ID ROOM_NUMBER       AREA TOTAL_AREA
---------- ---------- ----------- ---------- ----------
         1          1           1         96         96
         1          2           2         55        151
         1         23           3         66        217
         2          3           1         45         45
         5          4           1         63         63
*/


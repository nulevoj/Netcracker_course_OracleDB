
/*
	1. Одна з колонок таблиці повинна містити значення, що повторюються, 
	для виділення підгруп, інша колонка повинна мати числові значення. 
	Створіть запит, який отримає накопичувальні підсумки другої колонки 
	від початку вікна до поточного рядка.
*/

SELECT
	hostel_id,
	room_id,
	room_number,
	area,
	SUM(area) OVER (ORDER BY hostel_id, room_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total_area
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
	2. Одна з колонок таблиці повинна містити значення, що повторюються, 
	для виділення підгруп, інша колонка повинна мати числові значення.
	Створіть запит, який отримає накопичувальні підсумки другої колонки
	попереднього та поточного рядка (ковзаюче вікно розміром 2 рядки).
*/

SELECT
	hostel_id,
	room_id,
	room_number,
	area,
	SUM(area) OVER (ORDER BY hostel_id, room_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) total_area
	FROM room;

/*
 HOSTEL_ID    ROOM_ID ROOM_NUMBER       AREA TOTAL_AREA
---------- ---------- ----------- ---------- ----------
         1          1           1         96         96
         1          2           2         55        151
         1         23           3         66        121
         2          3           1         45        111
         5          4           1         63        108
*/

/*
	3. Одна з колонок таблиці повинна містити значення, що повторюються, 
	для виділення підгруп, інша колонка повинна мати числові значення.
	Створіть запит, який отримає:
	- накопичувальні підсумки другої колонки від початку вікна 
	до поточного рядка для кожного вікна цілком
	- накопичувальний результат порядково (для демонстрації 
	відмінностей роботи типу RANG від ROWS).
*/

SELECT
	hostel_id,
	room_id,
	room_number,
	area,
	SUM(area) OVER (ORDER BY hostel_id, room_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) area_rows,
	SUM(area) OVER (ORDER BY hostel_id, room_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) area_range
	FROM room;

/*
 HOSTEL_ID    ROOM_ID ROOM_NUMBER       AREA  AREA_ROWS AREA_RANGE
---------- ---------- ----------- ---------- ---------- ----------
         1          1           1         96         96         96
         1          2           2         55        151        151
         1         23           3         66        217        217
         2          3           1         45        262        262
         5          4           1         63        325        325
*/


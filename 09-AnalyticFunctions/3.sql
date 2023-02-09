
/*
	1. Класифікуйте значення однієї з колонок на 3 категорії залежно 
	від загальної суми значень у будь-якій числовій колонці.
*/

SELECT
    hostel_id,
    address,
    rating,
    NTILE(3) OVER (ORDER BY rating) AS hostel_ntile
    FROM hostel;

/*
 HOSTEL_ID ADDRESS                            RATING HOSTEL_NTILE
---------- ------------------------------ ---------- ------------
         1 Zelena St. 5                          5.5            1
         5 Blue Square, 1                       6.52            1
        25 quiet quiet place                    6.66            2
        24 Ocean Avenue, 375                    7.65            2
         2 Chill road 65                        8.75            3
         4 Victory Square, 4                    9.23            3
*/

/*
	2. Складіть запит, який поверне списки лідерів у підгрупах, 
	отриманих у першому завданні етапу 1.
*/

WITH ntile AS (
    SELECT
        hostel_id,
        address,
        rating,
        NTILE(3) OVER (ORDER BY rating) AS hostel_ntile
        FROM hostel),
    ranks as(
    SELECT 
        hostel_id,
        address,
        rating,
        RANK() OVER (PARTITION BY hostel_ntile ORDER BY rating) rank
        FROM ntile)
SELECT
    hostel_id,
    address,
    rating,
    rank
FROM ranks
WHERE rank = 1;

/*
 HOSTEL_ID ADDRESS                            RATING       RANK
---------- ------------------------------ ---------- ----------
         1 Zelena St. 5                          5.5          1
        25 quiet quiet place                    6.66          1
         2 Chill road 65                        8.75          1
*/

/*
	3. Модифікуйте рішення попереднього завдання, 
	повернувши по 2 лідери у кожній підгрупі.
*/

WITH ntile AS (
    SELECT
        hostel_id,
        address,
        rating,
        NTILE(3) OVER (ORDER BY rating) AS hostel_ntile
        FROM hostel),
    ranks as(
    SELECT 
        hostel_id,
        address,
        rating,
        RANK() OVER (PARTITION BY hostel_ntile ORDER BY rating) rank
        FROM ntile)
SELECT
    hostel_id,
    address,
    rating,
    rank
FROM ranks
WHERE rank = 1
OR rank = 2;

/*
 HOSTEL_ID ADDRESS                            RATING       RANK
---------- ------------------------------ ---------- ----------
         1 Zelena St. 5                          5.5          1
         5 Blue Square, 1                       6.52          2
        25 quiet quiet place                    6.66          1
        24 Ocean Avenue, 375                    7.65          2
         2 Chill road 65                        8.75          1
         4 Victory Square, 4                    9.23          2
*/

/*
	4. Складіть запит, який повертає рейтинг будь-якого з перерахованих 
	значень відповідно до вашої предметноїобласті: 
	товарів/послуг/співробітників/клієнтів тощо.
*/

SELECT
    hostel_id,
    address,
    rating,
    RANK() OVER (ORDER BY rating DESC) rank
    FROM hostel;

/*
 HOSTEL_ID ADDRESS                            RATING       RANK
---------- ------------------------------ ---------- ----------
         4 Victory Square, 4                    9.23          1
         2 Chill road 65                        8.75          2
        24 Ocean Avenue, 375                    7.65          3
        25 quiet quiet place                    6.66          4
         5 Blue Square, 1                       6.52          5
         1 Zelena St. 5                          5.5          6
*/

/*
	5. Одна з колонок таблиці повинна містити значення, що повторюються, 
	для виділення підгруп, інша колонка повинна мати числові значення. 
	Створіть запит, який отримає перше значення у кожній підгрупі.
*/

WITH first_val AS (
    SELECT
        hostel_id,
        room_id,
        room_number,
        area,
        FIRST_VALUE(area) OVER (PARTITION BY hostel_id ORDER BY area DESC) first
    FROM room)
SELECT 
    hostel_id,
    room_id,
    room_number,
    area
FROM first_val
WHERE area = first;

/*
 HOSTEL_ID    ROOM_ID ROOM_NUMBER       AREA
---------- ---------- ----------- ----------
         1          1           1         96
         2          3           1         45
         5          4           1         63
*/



-- Етап 3. Використання курсорів у PL/SQL СУБД Oracle

/*
	3.1. Виконайте DELETE-запит із попередніх рішень, 
	додавши аналіз даних із неявного курсору. 
	Наприклад, кількість віддалених рядків
*/

BEGIN
    DELETE FROM student;
    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);
END;

ROLLBACK;

/*
	Rows deleted: 8
*/

/*
	3.2. Повторіть виконання завдання 3 етапу 1 з використанням явного курсору.
*/

DECLARE
	CURSOR avg_area_list IS
		SELECT hostel_id, AVG(area) avg
		FROM room
		GROUP BY hostel_id;
BEGIN
	FOR item IN avg_area_list LOOP
		DBMS_OUTPUT.PUT_LINE(RPAD(item.hostel_id, 10, ' ') || item.avg);
	END LOOP;
END;

/*
	1         72.33333333333333333333333333333333333333
	2         45
	5         63
*/

/*
	3.3. У попередній лабораторній роботі розглядався приклад.
	З урахуванням вашої предметної області створити анонімний PL/SQL-блок, 
	який викликатиме один із варіантів подібних SQL-запитів залежно від значення версії СУБД.
	При вирішенні використовувати:
	− значення змінної DBMS_DB_VERSION.VERSION;
	− явний курсор із параметричним циклом.
	
	отримати 3 найбільших за площею кімнати
*/

BEGIN
	DBMS_OUTPUT.PUT_LINE('Oracle version: ' || DBMS_DB_VERSION.VERSION);
	IF DBMS_DB_VERSION.VERSION < 12 THEN
        DECLARE
            CURSOR room_list IS
                WITH room_area AS (
                    SELECT room_id, area
                    FROM room
                    ORDER BY area DESC),
                room_rownum AS (
                    SELECT ROWNUM AS rn,
                        room_id,
                        area
                    FROM room_area)
            SELECT room_id, area
            FROM room_rownum
            WHERE rn <= 3;
        BEGIN
            FOR item IN room_list LOOP
                DBMS_OUTPUT.PUT_LINE(RPAD(item.room_id, 10, ' ') || item.area);
            END LOOP;
        END;
    ELSE
        DECLARE
            CURSOR room_list IS
                SELECT room_id, area
                FROM room
                ORDER BY area DESC
                FETCH FIRST 3 ROWS ONLY;
        BEGIN
            FOR item IN room_list LOOP
                DBMS_OUTPUT.PUT_LINE(RPAD(item.room_id, 10, ' ') || item.area);
            END LOOP;
        END;
    END IF;
END;

/*
	Oracle version: 18
	1         96
	23        66
	4         63
*/


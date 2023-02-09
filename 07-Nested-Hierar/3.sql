
/*
	Етап 3. Ієрархічні та рекурсивні запити
*/

/*
	1. Виберіть таблицю вашої БД, до якої потрібно додати нову колонку,
	яка стане FK-колонкою для PK-колонки цієї таблиці та буде використана для зберігання ієрархії.
	Використовується команда ALTER TABLE таблиця ADD колонка тип_даних;
	Заповніть дані для створеної колонки, виконавши серію команд UPDATE.
*/

ALTER TABLE hostel ADD hierarchy NUMBER(9);
ALTER TABLE hostel ADD CONSTRAINT hierarchy_FK FOREIGN KEY (hierarchy) REFERENCES hostel(hostel_id);
UPDATE hostel SET hierarchy = 2 WHERE hostel_id = 1;
UPDATE hostel SET hierarchy = 4 WHERE hostel_id = 2;
UPDATE hostel SET hierarchy = 5 WHERE hostel_id = 4;
SELECT * FROM hostel;

/*
	HOSTEL_ID	ADDRESS				RATING	AMOUNT_OF_FLOORS	AMOUNT_OF_ROOMS		HIERARCHY
1	1			Zelena St. 5		5.5		4					40					2
2	2			Chill road 65		8.75	6					55					4
3	4			Victory Square, 4	9.23	7					50					5
4	5			Blue Square, 1		6.52	4					40					(null)
*/

/*
	2. Використовуючи створену колонку, отримайте дані з таблиці 
	через ієрархічний зв'язок типу «зверху-вниз».
*/

SELECT hostel_id,
        hierarchy,
        address,
        rating,
        LEVEL
    FROM hostel
    START WITH hierarchy IS NULL
    CONNECT BY PRIOR hostel_id = hierarchy
    ORDER BY LEVEL;

/*
	HOSTEL_ID	ADDRESS				RATING	AMOUNT_OF_FLOORS	AMOUNT_OF_ROOMS		HIERARCHY
1	5			Blue Square, 1		6.52	4					40					(null)
2	4			Victory Square, 4	9.23	7					50					5
3	2			Chill road 65		8.75	6					55					4
4	1			Zelena St. 5		5.5		4					40					2
*/

/*
	3. Згенеруйте унікальну послідовність чисел, використовуючи рекурсивний запит,
	в діапазоні від 1 до 100. На основі отриманого результату створіть запит, 
	що виводить на екран список ще не внесених значень однієї з PK-колонок 
	однієї з таблиць БД за прикладом на рисунку 11.
*/

SELECT SQ.RN
    FROM (SELECT ROWNUM AS RN
            FROM hostel CONNECT BY LEVEL <= (SELECT MAX(hostel_id) FROM hostel)
        ) SQ
    WHERE SQ.RN NOT IN (SELECT hostel_id FROM hostel)
    AND SQ.RN <= 100
    ORDER BY (RN);


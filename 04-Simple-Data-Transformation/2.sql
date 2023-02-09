
/*
	2.1 Для однієї з таблиць створити команду отримання символьних значень 
	колонки з переведенням першого символу у верхній регістр, інших у нижній. 
	При виведенні на екран визначити для вказаної колонки нову назву псевдоніму.
*/

SELECT INITCAP(name) AS person FROM student;
/*
	PERSON
1	Nikolay
2	Konstantin
3	Vasiliy
4	Vitaliy
5	Oleg
6	Oleg
7	Kirill
*/

/*
	2.2. Модифікувати рішення попереднього завдання, 
	створивши команду оновлення значення вказаної колонки у таблиці.
*/

UPDATE student SET name = INITCAP(name);

/*
	2.3 Для однієї з символьних колонок однієї з таблиць створити команду 
	отримання мінімальної, середньої та максимальної довжин рядків.
*/

SELECT 
    MIN(LENGTH(name)) AS Min,
    AVG(LENGTH(name)) AS Avg,
    MAX(LENGTH(name)) AS Max
    FROM student;

/*
	MIN		AVG											MAX
1	4		6.42857142857142857142857142857142857143	10
*/

/*
	2.4 Для колонки типу date однієї з таблиць отримати кількість днів, 
	тижнів та місяців, що пройшли до сьогодні.
*/

SELECT
	name,
    date_of_birth,
    ROUND(SYSDATE-date_of_birth) AS Days,
    ROUND((SYSDATE-date_of_birth)/7) AS Weeks,
    ROUND(MONTHS_BETWEEN (SYSDATE, date_of_birth)) AS Months
    FROM student;


/*
	NAME		DATE_OF_BIRTH	DAYS	WEEKS	MONTHS
1	Nikolay		(null)			(null)	(null)	(null)
2	Konstantin	(null)			(null)	(null)	(null)
3	Vasiliy		14-MAR-03		7159	1023	235
4	Vitaliy		06-FEB-01		7925	1132	260
5	Oleg		16-DEC-01		7612	1087	250
6	Oleg		(null)			(null)	(null)	(null)
7	Kirill		15-APR-02		7492	1070	246
*/



/*
	1. Одна з колонок таблиць повинна містити строкове значення з трьома різними буквами 
	у першій позиції. Створіть запит, який отримає три рядки таблиці з урахуванням трьох букв,
	використовуючи оператор LIKE.
*/

SELECT student_id, name FROM student
    WHERE name LIKE 'V%' 
    OR name LIKE 'O%' 
	OR name LIKE 'K%'
    ORDER BY name;

/*
	STUDENT_ID	NAME
1	4			Kirill
2	2			Konstantin
3	7			Oleg
4	3			Oleg
5	5			Vasiliy
6	6			Vitaliy
*/

/*
	2. Повторіть завдання 1, використовуючи регулярні вирази з альтернативними варіантами.
*/

SELECT student_id, name FROM student
	WHERE regexp_like(name, '^(V|O|K)')
    ORDER BY name;

/*
	STUDENT_ID	NAME
1	4			Kirill
2	2			Konstantin
3	7			Oleg
4	3			Oleg
5	5			Vasiliy
6	6			Vitaliy
*/

/*
	3. Одна з колонок таблиць повинна містити строкове значення з цифрами від 3 до 8 
	у будь-якій позиції. Створіть запит, який отримає рядки таблиці з урахуванням присутності 
	у вказаній колонці будь-якої цифри від 3 до 8.
*/

SELECT hostel_id, address FROM hostel
	WHERE regexp_like(address, '[3-8]');

/*
	HOSTEL_ID	ADDRESS
1	24			Ocean Avenue, 375
2	1			Zelena St. 5
3	2			Chill road 65
4	4			Victory Square, 4
*/

/*
	4. Створіть запит, який отримає рядки таблиці з урахуванням відсутності 
	в зазначеній колонці будь-якої цифри від 3 до 8.
*/

SELECT * FROM hostel
	WHERE regexp_like(address, '[^3-8]$');

/*
	HOSTEL_ID	ADDRESS
1	25			quiet quiet place
2	5			Blue Square, 1
*/

/*
	5. Створіть запит, який отримає рядки таблиці з урахуванням присутності 
	в раніше вказаній колонці поєднання будь-яких трьох цифр розміщених підряд від 3 до 8.
*/

SELECT hostel_id, address FROM hostel
	WHERE regexp_like(address, '[3-8]{3}');

/*
	HOSTEL_ID	ADDRESS
1	24			Ocean Avenue, 375
*/


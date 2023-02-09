
/*
	1. Створіть запит, який отримає рядки таблиці з урахуванням присутності 
	в раніше вказаній колонці поєднання будь-яких двох підряд розташованих цифр, 
	або трьох підряд розташованих букв.
*/

SELECT hostel_id, address FROM hostel
	WHERE regexp_like(address, '(\d{2})|(([[:alpha:]]){3})');

/*
	HOSTEL_ID	ADDRESS
1	24			Ocean Avenue, 375
2	25			quiet quiet place
3	1			Zelena St. 5
4	2			Chill road 65
5	4			Victory Square, 4
6	5			Blue Square, 1
*/

/*
	2. Одна з колонок таблиць повинна містити строкове значення 
	з двома однаковими буквами, що повторюються підряд. Створіть запит, 
	який отримає рядки таблиці з таким значенням колонки.
*/

SELECT hostel_id, address FROM hostel
	WHERE regexp_like(address, '([[:alpha:]])\1');

/*
	HOSTEL_ID	ADDRESS
1	2			Chill road 65
*/

/*
	3. Одна з колонок таблиць повинна містити строкове значення з двома однаковими словами, 
	що повторюються підряд. Створіть запит, який отримає рядки таблиці з таким значенням колонки.
*/

SELECT hostel_id, address FROM hostel
	WHERE regexp_like(address, '([[:alpha:]]+)([[:space:]]+)\1');

/*
	HOSTEL_ID	ADDRESS
1	25			quiet quiet place
*/

/*
	4. Одна з колонок таблиць повинна містити строкове значення з номером мобільного 
	телефону у форматі +XX(XXX)XXX-XX-XX, де X – цифра. Створіть запит, 
	який отримає рядки таблиці з таким значенням колонки.
*/

SELECT student_id, name, phone FROM student
	WHERE regexp_like(phone, '\+\d{2}\(\d{3}\)\d{3}\-\d{2}\-\d{2}');

/*
	STUDENT_ID		NAME		PHONE
1	1				Nikolay		+38(067)132-32-43
2	2				Konstantin	+38(066)982-25-34
3	5				Vasiliy		+38(066)234-35-76
4	6				Vitaliy		+38(067)756-74-36
5	7				Oleg		+38(096)763-27-85
*/

/*
	5. Одна з колонок таблиць має містити строкове значення з електронною поштовою 
	адресою у форматі EEE@EEE.EEE.UA, де E – будь-яка латинська буква. Створіть запит, 
	який отримає рядки таблиці з таким значенням колонки.
*/

SELECT student_id, name, email FROM student
	WHERE regexp_like(email, '[a-zA-z0-9_.]+\@[a-zA-z0-9_.]+(\.[a-zA-z0-9_.]+){1,2}');

/*
	STUDENT_ID		NAME		EMAIL
1	1				Nikolay		nik_nova@ukr.net
2	7				Oleg		o_963@gmail.com
3	25				Maria		m_nc_edu@ukr.net
4	3				Oleg		olejiq1@gmail.com
5	4				Kirill		kira_123@gmail.com
*/


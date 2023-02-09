
/*
	1. Одна з колонок таблиць повинна містити строкове значення з двома словами, 
	розділеними пробілом. Виконайте команду UPDATE, помінявши місцями ці два слова.
*/

UPDATE student
    SET faculty = regexp_replace(
        faculty,
        '^(\S+)\s(\S+)$',
        '\2 \1');
SELECT student_id, name, faculty 
    FROM student
    ORDER BY faculty;
ROLLBACK;

/*
	STUDENT_ID		NAME		FACULTY
1	25				Maria		Databases
2	4				Kirill		Design
3	2				Konstantin	Dev Game
4	3				Oleg		Dev Game
5	1				Nikolay		Dev Game
6	7				Oleg		science Computer
7	6				Vitaliy		science Computer
8	5				Vasiliy		security Cyber
*/

/*
	2. Одна з колонок таблиць має містити строкове значення з електронною поштовою 
	адресою у форматі EEE@EEE.EEE.UA, де E – будь-яка латинська буква. Створіть запит, 
	вилучення логіна користувача з електронної адреси (підстрока перед символом @).
*/

SELECT student_id, 
        email,
        regexp_replace(
            email,
            '([a-zA-z0-9_.]+)\@[a-zA-z0-9_.]+(\.[a-zA-z0-9_.]+){1,2}',
            '\1') login
	FROM student
    WHERE email IS NOT NULL
    ORDER BY email;

/*
	STUDENT_ID	EMAIL					LOGIN
1	4			kira_123@gmail.com		kira_123
2	25			m_nc_edu@ukr.net		m_nc_edu
3	1			nik_nova@ukr.net		nik_nova
4	7			o_963@gmail.com			o_963
5	3			olejiq1@gmail.com		olejiq1	
*/

/*
	3. Одна з колонок таблиць повинна містити строкове значення з номером мобільного 
	телефону у форматі +XX(XXX)XXX-XX-XX, де X – цифра. Виконайте команду UPDATE, 
	додавши перед номером телефону фразу «Mobile:».
*/

UPDATE student
    SET phone = regexp_replace(
        phone,
        '^(\+\d{2}\(\d{3}\)\d{3}\-\d{2}\-\d{2})$',
        'Mobile: \1');

SELECT student_id, name, phone 
    FROM student
    WHERE phone IS NOT NULL
    ORDER BY name;

/*
	STUDENT_ID	NAME		PHONE
1	2			Konstantin	Mobile: +38(066)982-25-34
2	1			Nikolay		Mobile: +38(067)132-32-43
3	3			Oleg		Mobile: +38(050)810-29-93
4	7			Oleg		Mobile: +38(096)763-27-85
5	5			Vasiliy		Mobile: +38(066)234-35-76
6	6			Vitaliy		Mobile: +38(067)756-74-36
*/

/*
	4. Додайте до колонки з електронною адресою обмеження цілісності, 
	що забороняє вносити дані, відмінні від формату електронної адреси, 
	використовуючи команду ALTER TABLE таблиця ADD CONSTRAINT обмеження CHECK (умова). 
	Перевірте роботу обмеження на двох прикладах UPDATE-запитів із правильними 
	та неправильними значеннями колонки.
*/

ALTER TABLE student ADD CONSTRAINT email_is_correct CHECK (
	regexp_like(email, '[a-zA-z0-9_.]+\@[a-zA-z0-9_.]+(\.[a-zA-z0-9_.]+){1,2}'));

UPDATE student SET email='qwert12345' WHERE student_id = 2;
UPDATE student SET email='konst_44@ukr.net' WHERE student_id = 2;

/*
	5. Видаліть зайві дані з колонки з номером мобільного телефону, 
	залишивши тільки номер телефону в заданому форматі.
*/

UPDATE student
    SET phone = regexp_substr(phone, '(\+\d{2}\(\d{3}\)\d{3}\-\d{2}\-\d{2})');

SELECT student_id, name, phone 
    FROM student
    WHERE phone IS NOT NULL
    ORDER BY name;

/*
	STUDENT_ID	NAME		PHONE
1	2			Konstantin	+38(066)982-25-34
2	1			Nikolay		+38(067)132-32-43
3	3			Oleg		+38(050)810-29-93
4	7			Oleg		+38(096)763-27-85
5	5			Vasiliy		+38(066)234-35-76
6	6			Vitaliy		+38(067)756-74-36
*/

/*
	6. Додайте в колонку з мобільним телефоном обмеження цілісності, 
	що забороняє вносити дані, відмінні від формату, записаного в завданні 3. 
	Перевірте роботу обмеження на двох прикладах UPDATE-запитів 
	із правильними та неправильними значеннями колонки.
*/

ALTER TABLE student ADD CONSTRAINT phone_is_correct CHECK (
	regexp_like(phone, '\+\d{2}\(\d{3}\)\d{3}\-\d{2}\-\d{2}'));

UPDATE student SET phone='0508102993' WHERE student_id = 3;
UPDATE student SET phone='+38(050)810-29-93' WHERE student_id = 3;


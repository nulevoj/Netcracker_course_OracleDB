
/*
	Етап 2. DML із вкладеними запитами.
*/

/*
	1. Багатотабличне внесення даних.
	На рисунку 7 показаний приклад використання багатотабличного внесення даних.
	Створіть один схожий запит, виконавши одночасне внесення до двох таблиць вашої БД.
	
	Внести до бази даних одну кімнату до гуртожитку з адресою 'Zelena St. 5',
	та студента який в ній проживає
*/

INSERT ALL
    INTO room (
        room_id,
        hostel_id,
        room_number,
        area,
        inspection_date,
        amount_of_windows,
        max_amount_of_students)
    VALUES (
        room_sq.NEXTVAl,
        hostel_id,
        3,
        66,
        TO_DATE ('07/11/2022', 'DD/MM/YYYY'),
        2,
        2)
    INTO student (
        student_id,
        room_id,
        name,
        faculty )
    VALUES (
        student_sq.NEXTVAL,
        room_sq.CURRVAL,
        'Maria',
        'Databases' )
SELECT hostel_id
FROM hostel
WHERE hostel.address = 'Zelena St. 5';

/*
	2. Використання багатостовпцевих підзапитів при зміні даних.
	На рисунку 8 показаний приклад використання багатостовпцевих підзапитів при зміні даних.
	Створіть один схожий запит на зміну двох колонок однієї таблиці вашої БД, 
	використовуючи багатостовпцевий підзапит.
	
	Переселити студента з id=3 до студента з id=1, та перевести на відповідний факультет
*/

UPDATE student
    SET (
        room_id,
        faculty ) = (
            SELECT room_id,
                faculty
            FROM student
            WHERE student_id = 1)
    WHERE student_id = 3;

/*
	3. Видалення рядків із використанням кореляційних підзапитів.
	На рисунку 9 показаний приклад використання кореляційних підзапитів під час видалення рядків.
	Створіть один схожий запит на видалення рядків таблиці за допомогою EXISTS або NOT EXISTS.
	
	Видалити гуртожитки, на яких немає посилань у таблиці кімнат.
*/

DELETE FROM hostel
    WHERE NOT EXISTS (
    SELECT room.hostel_id
    FROM room
    WHERE room.hostel_id = hostel.hostel_id );

/*
	4. Поєднаний INSERT/UPDATE запит – оператор MERGE.
	На рисунку 10 показаний приклад використання оператора MERGE.
	Створіть один схожий запит на видалення, використовуючи одну або дві таблиці вашої бази даних.
*/

CREATE TABLE student_all AS SELECT * FROM student;
UPDATE student_all SET faculty = 'Game Dev';
DELETE FROM student_all WHERE name LIKE '_i%';

MERGE INTO student_all
    USING student
        ON (student.student_id = student_all.student_id)
    WHEN MATCHED THEN
        UPDATE SET student_all.faculty = student.faculty
    WHEN NOT MATCHED THEN
        INSERT (
            student_id,
            room_id,
            name,
            faculty,
            date_of_birth
        ) VALUES (
            student.student_id,
            student.room_id,
            student.name,
            student.faculty,
            student.date_of_birth
    );


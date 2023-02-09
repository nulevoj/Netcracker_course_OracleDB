
/*
	4.1 Повторити рішення завдання 3.1
*/

SELECT
    room.room_number,
    student.name,
    student.faculty
    FROM room, student;

/*
	4.2 Повторити рішення завдання 3.2
*/

SELECT
    room.room_number,
    room.area,
    room.max_amount_of_students,
    student.name,
    student.faculty
    FROM room, student
    WHERE student.room_id = room.room_id;

/*
	4.3 Повторити рішення завдання 3.4
*/

SELECT
    hostel.hostel_id,
    hostel.adress,
    room.room_id,
    room.hostel_id,
    room.area
    FROM hostel, room
    WHERE hostel.hostel_id = room.hostel_id (+);


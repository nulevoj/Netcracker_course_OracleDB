
DROP TABLE furniture CASCADE CONSTRAINTS;
DROP TABLE technique CASCADE CONSTRAINTS;
DROP TABLE student CASCADE CONSTRAINTS;
DROP TABLE room CASCADE CONSTRAINTS;
DROP TABLE hostel CASCADE CONSTRAINTS;

CREATE TABLE hostel(
	hostel_id NUMBER(3),
	address VARCHAR(30),
	rating NUMBER(4,2),
	amount_of_floors NUMBER(1),
	amount_of_rooms NUMBER(2)
);

CREATE TABLE room(
	room_id NUMBER(5),
	hostel_id NUMBER(3),
	room_number NUMBER(2),
	area NUMBER(3),
	inspection_date DATE,
	amount_of_windows NUMBER(1),
	max_amount_of_students NUMBER(1)
);

CREATE TABLE student(
	student_id NUMBER(9),
	room_id NUMBER(5),
	name VARCHAR(50),
	faculty VARCHAR(50)
);

CREATE TABLE technique(
	technique_id NUMBER(5),
	room_id NUMBER(5),
	fridge NUMBER(1), -- bool
	microwave NUMBER(1), -- bool
	TV NUMBER(1) -- bool
);

CREATE TABLE furniture(
	furniture_id NUMBER(5),
	room_id NUMBER(5),
	amount_of_beds NUMBER(1),
	amount_of_tables NUMBER(1),
	amount_of_wardrobes NUMBER(1),
	amount_of_bedsideTables NUMBER(1)
);

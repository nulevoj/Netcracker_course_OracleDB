
INSERT INTO student (
    student_id,
    room_id,
    name,
    faculty,
	date_of_birth
    )
    VALUES (
    4,
    2,
    'Kirill',
    'Design',
	TO_DATE ('15/04/2002', 'DD/MM/YYYY')
);

/*

Code	Line / Position		Description
L004	6 / 1				Incorrect indentation type found in file.
L003	7 / 5				Expected 0 indentations, found 1 [compared to line 01]
L003	8 / 5				Expected 0 indentations, found 1 [compared to line 01]
L004	13 / 1				Incorrect indentation type found in file.
L017	13 / 9				Function name not immediately followed by parenthesis.

*/


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

/*

Code	Line / Position		Description
L003	2 / 5				Expected 0 indentations, found 1 [compared to line 01]
L003	3 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	4 / 5				Expected 0 indentations, found 1 [compared to line 01]
L003	5 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	6 / 5				Expected 0 indentations, found 1 [compared to line 01]
L003	7 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	19 / 5				Expected 2 indentations, found 1 [compared to line 13]

*/

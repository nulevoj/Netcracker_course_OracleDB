
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


/*
	1.1. Створити таблицю опису об'єктних типів.
*/

CREATE TABLE objtype (
    object_type_id NUMBER(20),
    parent_id NUMBER(20),
    code VARCHAR2(20),
    name VARCHAR2(200),
    description VARCHAR2(1000)
);

ALTER TABLE objtype ADD CONSTRAINT objtype_pk
    PRIMARY KEY (object_type_id);
ALTER TABLE objtype ADD CONSTRAINT objtype_code_unique
    UNIQUE (code);
ALTER TABLE objtype 
    MODIFY(code NOT NULL);
ALTER TABLE objtype ADD CONSTRAINT objtype_fk
    FOREIGN KEY (parent_id) REFERENCES objtype(object_type_id);

/*
	1.2 Нехай у лабораторній роботі No1 було створено UML-діаграму концептуальних класів. 
	Для трьох класів з UML-діаграми, пов'язаних між собою, бажано зв'язком «узагальнення», 
	«агрегатна асоціація» та «іменована асоціація», заповнити опис об'єктних типів.
*/

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        1,
        NULL,
        'Hostel',
        'Гуртожиток',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        2,
        1,
        'Room',
        'Кімната',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        3,
        2,
        'Student',
        'Студент',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        4,
        2,
        'Technique',
        'Технічне обладнання',
        NULL
);

INSERT INTO objtype(
        object_type_id,
        parent_id,
        code,
        name,
        description
    )
    VALUES(
        5,
        2,
        'Furniture',
        'Меблеве обладнання',
        NULL
);

/*
	1.3 Отримати інформацію про об'єктні типи.
*/

SELECT * FROM objtype ORDER BY objtype.object_type_id;

/*
	OBJECT_TYPE_ID		PARENT_ID	CODE		NAME					DESCRIPTION
1	1					(null)		Hostel		Гуртожиток				(null)
2	2					1			Room		Кімната					(null)
3	3					2			Student		Студент					(null)
4	4					2			Technique	Технічне обладнання		(null)
5	5					2			Furniture	Меблеве обладнання		(null)
*/

/*
	1.4 Отримати інформацію про об'єктні типи та можливі зв'язки між ними типу «узагальнення», 
	«агрегатна асоціація».
*/

SELECT p.object_type_id,
        p.code,
        c.object_type_id OBJ_T_ID_LINK,
        c.code CODE_LINK
    FROM objtype c, objtype p
    WHERE p.object_type_id = c.parent_ID(+);

/*
	OBJECT_TYPE_ID	CODE		OBJ_T_ID_LINK	CODE_LINK
1	1				Hostel		2				Room
2	2				Room		3				Student
3	2				Room		4				Technique
4	2				Room		5				Furniture
5	4				Technique	(null)			(null)
6	5				Furniture	(null)			(null)
7	3				Student		(null)			(null)
*/


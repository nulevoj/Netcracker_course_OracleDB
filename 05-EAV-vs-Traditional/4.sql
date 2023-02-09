
/*
	4.1 Створити таблицю описів екземплярів об'єктів.
*/

CREATE TABLE objects (
    object_id NUMBER(20),
    parent_id NUMBER(20),
    object_type_id NUMBER(20),
    name VARCHAR2(2000),
    description VARCHAR2(4000)
);

ALTER TABLE objects ADD CONSTRAINT objects_PK
    PRIMARY KEY (object_id);
ALTER TABLE objects ADD CONSTRAINT objects_parent_id_FK
    FOREIGN KEY (parent_id) REFERENCES objects (object_id);
ALTER TABLE objects ADD CONSTRAINT objects_object_type_id_FK
    FOREIGN KEY (object_type_id) REFERENCES objtype (object_type_id);

/*
	4.2 На основі вмісту двох рядків двох таблиць, заповнених у лабораторній роботі No3, 
	заповнити описи екземплярів об'єктів.
*/

INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    )
    VALUES (
        1,
        NULL,
        1,
        'Zelena St. 5',
        NULL
);
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    )
    VALUES (
        2,
        NULL,
        1,
        'Chill road 65',
        NULL
);
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    )
    VALUES (
        3,
        1,
        2,
        'Room 1',
        NULL
);
INSERT INTO objects (
        object_id,
        parent_id,
        object_type_id,
        name,
        description
    )
    VALUES (
        4,
        1,
        2,
        'Room 2',
        NULL
);

/*
	4.3 Отримати колекцію екземплярів об'єктів для одного з об'єктних типів, використовуючи його код.
*/

SELECT object_id, name
    FROM objects
    WHERE object_type_id = 1;
	
/*
	OBJECT_ID	NAME
1	1			Zelena St. 5
2	2			Chill road 65
*/

/*
	4.4 Отримати один екземпляр об'єкта заданого імені для одного з об'єктних типів, використовуючи його код.
*/

SELECT hostels.object_id,
        hostels.name
    FROM objects hostels, objtype
    WHERE hostels.object_id = 1
    AND objtype.code = 'Hostel'
    AND objtype.object_type_id = hostels.object_type_id;

/*
	OBJECT_ID	NAME
1	1			Zelena St. 5
*/


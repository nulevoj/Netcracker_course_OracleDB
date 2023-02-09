
/*
	5.1 Створити таблицю описів значень атрибутів екземплярів об'єктів.
*/

CREATE TABLE ATTRIBUTES (
    attr_id NUMBER(10),
    object_id NUMBER(20),
    value VARCHAR2(4000),
    date_value date,
    list_value_id NUMBER(10)
);

ALTER TABLE attributes ADD CONSTRAINT attributes_PK
    PRIMARY KEY (attr_id, object_id);
ALTER TABLE attributes ADD CONSTRAINT attributes_list_value_id_FK
    FOREIGN KEY (list_value_id) REFERENCES lists (list_value_id);
ALTER TABLE attributes ADD CONSTRAINT attributes_attr_id_FK
    FOREIGN KEY (attr_id) REFERENCES attrtype (attr_id);
ALTER TABLE attributes ADD CONSTRAINT attributes_object_id_FK
    FOREIGN KEY (object_id) REFERENCES objects (object_id);

/*
	5.2 На основі вмісту двох рядків двох таблиць, заповнених у лабораторній роботі No3, 
	та опису атрибутів екземплярів об'єктів, заповнити описи значень атрибутів екземплярів об'єктів.
*/

--1
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        1,
        1,
        'Zelena St. 5'
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        2,
        1,
        5.5
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        3,
        1,
        4
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        4,
        1,
        40
);
--2
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        1,
        2,
        'Chill road 65'
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        2,
        2,
        8.75
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        3,
        2,
        6
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        4,
        2,
        55
);
--3
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        5,
        3,
        1
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        6,
        3,
        1
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        7,
        3,
        96
);
INSERT INTO attributes (
        attr_id,
        object_id,
        date_value
    )
    VALUES(
        8,
        3,
        TO_DATE ('11/10/2022', 'DD/MM/YYYY')
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        9,
        3,
        3
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        12,
        3,
        4
);
--4
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        5,
        4,
        1
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        6,
        4,
        2
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        7,
        4,
        55
);
INSERT INTO attributes (
        attr_id,
        object_id,
        date_value
    )
    VALUES(
        8,
        4,
        TO_DATE ('09/10/2022', 'DD/MM/YYYY')
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        9,
        4,
        1
);
INSERT INTO attributes (
        attr_id,
        object_id,
        value
    )
    VALUES(
        12,
        4,
        2
);

/*
	5.3 Модифікувати рішення завдання 4.3, отримавши колекцію екземплярів об'єктів 
	за заданим значенням одного з атрибутів об'єктів.
*/

SELECT hostels.object_id,
        hostels.name,
        address.value address
    FROM objects hostels,
        objtype hostels_type,
        attributes address
    WHERE hostels_type.code = 'Hostel'
    AND hostels_type.object_type_id = hostels.object_type_id
    AND hostels.object_id = address.object_id
    AND address.attr_id = 1;

/*
	OBJECT_ID	NAME				ADDRESS
1	1			Zelena St. 5		Zelena St. 5
2	2			Chill road 65		Chill road 65
*/



/*
	3.1 Створити таблицю описів листових значень.
*/

CREATE TABLE lists (
    attr_id NUMBER(10),
    list_value_id NUMBER(10),
    value VARCHAR(4000)
);

ALTER TABLE lists ADD CONSTRAINT lists_PK
    PRIMARY KEY (list_value_id);
ALTER TABLE lists ADD CONSTRAINT lists_attr_id_FK
    FOREIGN KEY (attr_id) REFERENCES attrtype(attr_id);

/*
	3.2 Для одного з атрибутних типів, який може містити кінцеву множину можливих значень, 
	заповнити описи листових значень.
*/

INSERT INTO lists (
        attr_id,
        list_value_id,
        value
        )
    VALUES(
        1,
        1,
        'Zelena St., 5'
);
INSERT INTO lists (
        attr_id,
        list_value_id,
        value
        )
    VALUES(
        1,
        2,
        'Chill road, 65'
);
INSERT INTO lists (
        attr_id,
        list_value_id,
        value
        )
    VALUES(
        1,
        3,
        'Victory Square, 4'
);
INSERT INTO lists (
        attr_id,
        list_value_id,
        value
        )
    VALUES(
        1,
        4,
        'Blue Square, 1'
);

/*
	3.3 Отримати інформацію про листові значення.
*/

SELECT o.code,
        a.attr_id,
        a.code,
        a.name,
        l.list_value_id,
        l.value
    FROM objtype o, attrtype a, lists l
    WHERE o.object_type_id = a.object_type_id
        AND a.attr_id = l.attr_id
    ORDER BY a.object_type_id, a.attr_id;

/*
	CODE	ATTR_ID		CODE	NAME	LIST_VALUE_ID	VALUE
1	Hostel	1			adress	Адреса	1				Zelena St., 5
2	Hostel	1			adress	Адреса	2				Chill road, 65
3	Hostel	1			adress	Адреса	3				Victory Square, 4
4	Hostel	1			adress	Адреса	4				Blue Square, 1
*/


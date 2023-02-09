
/*
	6.1 Створити таблицю описів зв'язків "іменована асоціація" між екземплярами об'єктів.
*/

CREATE TABLE objreference (
    attr_id NUMBER(20),
    reference NUMBER(20),
    object_id NUMBER(20)
);

ALTER TABLE objreference ADD CONSTRAINT objreference_PK
	PRIMARY KEY (attr_id, reference, object_id);
ALTER TABLE objreference ADD CONSTRAINT objreference_reference_FK
	FOREIGN KEY(reference) REFERENCES objects(object_id);
ALTER TABLE objreference ADD CONSTRAINT objreference_object_id_FK
	FOREIGN KEY (object_id) REFERENCES objects(object_id);
ALTER TABLE objreference ADD CONSTRAINT objreference_attr_id_FK
	FOREIGN KEY (attr_id) REFERENCES attrtype (attr_id);

/*
	6.2 Заповнити таблицю зв'язків з урахуванням можливих зв'язків «іменована асоціація» 
	між раніше створеними екземплярами об'єктів класів.
*/

INSERT INTO objreference (attr_id, object_id, reference) VALUES (5, 3, 1);
INSERT INTO objreference (attr_id, object_id, reference) VALUES (5, 4, 1);


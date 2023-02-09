/* 

Лекція Об'єктно-реляційна модель
EAV/CR – Entity-Attribute-Value with Classes and Relationships 
(Сутність-Атрибут-Значення з Класами та Відношеннями)" 

Автор: Олександр Блажко та Марія Глава 
викладачі НЦ Netcracker-Одеська політехніка

*/

SET LINESIZE 2000
SET PAGESIZE 100

drop table OBJTYPE CASCADE CONSTRAINTS;
drop table ATTRTYPE CASCADE CONSTRAINTS;
drop table LISTS CASCADE CONSTRAINTS;
drop table OBJECTS CASCADE CONSTRAINTS;
drop table ATTRIBUTES CASCADE CONSTRAINTS;
drop table OBJREFERENCE CASCADE CONSTRAINTS;

/* 1 ТАБЛИЦЯ ОПИСІВ ОБ'ЄКТНИХ ТИПІВ */

CREATE TABLE OBJTYPE (
	OBJECT_TYPE_ID NUMBER(20),
	PARENT_ID      NUMBER(20),
	CODE           VARCHAR2(20),
	NAME           VARCHAR2(200),
	DESCRIPTION    VARCHAR2(1000)
);

ALTER TABLE OBJTYPE ADD CONSTRAINT OBJTYPE_PK
	PRIMARY KEY (OBJECT_TYPE_ID);
ALTER TABLE OBJTYPE ADD CONSTRAINT OBJTYPE_CODE_UNIQUE
	UNIQUE (CODE);
ALTER TABLE OBJTYPE 
	MODIFY (CODE NOT NULL);
ALTER TABLE OBJTYPE ADD CONSTRAINT OBJTYPE_FK
	FOREIGN KEY (PARENT_ID) REFERENCES OBJTYPE(OBJECT_TYPE_ID);

COMMENT ON TABLE OBJTYPE IS 'Таблиця описів обєктних типів';
COMMENT ON COLUMN OBJTYPE.OBJECT_TYPE_ID IS 'Ідентифікатор обєктного типу';
COMMENT ON COLUMN OBJTYPE.PARENT_ID IS 'Посилання на ідентифікатор батьківського обєктного типу';
COMMENT ON COLUMN OBJTYPE.CODE IS 'Назва обєктного типу в англійському кодуванні';
COMMENT ON COLUMN OBJTYPE.NAME IS 'Назва обєктного типу в національному кодуванні (для GUI)';
COMMENT ON COLUMN OBJTYPE.DESCRIPTION IS 'розгорнутий опис обєктного типу в національному кодуванні (для GUI)';

/* 
При переході від UML-діаграми до моделі EAV рекомендується:
1) кожен клас - це рядок у таблиці OBJTYPE з ім'ям класу у колонці NAME
2) зв'язок типу "узагальнення" між класами можна зберегти у колонки:
- OBJECT_TYPE_ID – ідентифікатор класу-спадкоємця;
- PARENT_ID – ідентифікатор класу-батька
3) зв'язок типу "агрегатна асоціація" між класами можна зберегти в колонки:
- OBJECT_TYPE_ID – ідентифікатор класу типу "приватне";
- PARENT_ID – ідентифікатор класу типу "ціле"
*/

-- Приклад створення об'єктного типу (класу) "Місто"
INSERT INTO OBJTYPE (OBJECT_TYPE_ID,PARENT_ID,CODE,NAME,DESCRIPTION) 
	VALUES (1,NULL,'LOC','Місто',NULL);
	
-- Приклад створення об'єктного типу (класу) "Підрозділи",
-- який має зв'язок "агрегатна асоціація" з класом "Місто",
-- при цьому клас "Місто" визначає поняття "ціле",
-- а клас "Підрозділ" - "частина"
INSERT INTO OBJTYPE (OBJECT_TYPE_ID,PARENT_ID,CODE,NAME,DESCRIPTION) 
	VALUES (2,1,'DEPT','Підрозділ',NULL);
	
-- Приклад створення об'єктного типу (класу) "Співробітник"
INSERT INTO OBJTYPE (OBJECT_TYPE_ID,PARENT_ID,CODE,NAME,DESCRIPTION) 
	VALUES (3,NULL,'EMP','Співробітник',NULL);
	
-- Приклад створення об'єктного типу (класу) "Менеджер",
-- який має зв'язок "узагальнення" з класом "Співробітник"
INSERT INTO OBJTYPE (OBJECT_TYPE_ID,PARENT_ID,CODE,NAME,DESCRIPTION) 
	VALUES (4,3,'MGR','Менеджер',NULL);

-- Отримання інформації про об'єктні типи
SELECT OBJECT_TYPE_ID,PARENT_ID,CODE,NAME
	FROM OBJTYPE;
	
-- Отримання інформації про об'єктні типи та зв'язки "агрегатна асоціація/узагальнення"
SELECT P.OBJECT_TYPE_ID,P.CODE,
	C.OBJECT_TYPE_ID OBJ_T_ID_LINK, C.CODE CODE_LINK
	FROM OBJTYPE C, OBJTYPE P
	WHERE P.OBJECT_TYPE_ID = C.PARENT_ID(+);
	
/* 2 ТАБЛИЦЯ ОПИСІВ АТРИБУТНИХ ТИПІВ */
CREATE TABLE ATTRTYPE (
    ATTR_ID      		NUMBER(20),
    OBJECT_TYPE_ID 		NUMBER(20),
	OBJECT_TYPE_ID_REF 	NUMBER(20),
    CODE         		VARCHAR2(20),
    NAME         		VARCHAR2(200)
);

ALTER TABLE ATTRTYPE ADD CONSTRAINT ATTRTYPE_PK
	PRIMARY KEY (ATTR_ID);
ALTER TABLE ATTRTYPE ADD CONSTRAINT ATTRTYPE_OBJECT_TYPE_ID_FK
	FOREIGN KEY (OBJECT_TYPE_ID) REFERENCES OBJTYPE (OBJECT_TYPE_ID);
ALTER TABLE ATTRTYPE ADD CONSTRAINT ATTRTYPE_OBJECT_TYPE_ID_REF_FK
	FOREIGN KEY (OBJECT_TYPE_ID_REF) REFERENCES OBJTYPE (OBJECT_TYPE_ID);

COMMENT ON TABLE ATTRTYPE 
	IS 'Таблиця описів атрибутних типів';
COMMENT ON COLUMN ATTRTYPE.OBJECT_TYPE_ID
	IS 'посилання на ідентифікатор обєктного типу класу, що характеризує цей атрибутний тип';
COMMENT ON COLUMN ATTRTYPE.OBJECT_TYPE_ID_REF 
	IS 'посилання на ідентифікатор обєктного типу класу, який для кратності "один-до-багатьох" знаходиться у відношенні "один"
при відношенні "багато", в якому знаходиться обєктний тип класу з ATTRTYPE.OBJECT_TYPE_ID';
COMMENT ON COLUMN ATTRTYPE.CODE 
	IS 'назва атрибутного типу в англійському кодуванні';
COMMENT ON COLUMN ATTRTYPE.NAME 
	IS 'назва атрибутного типу в національному кодуванні (для GUI)';

-- Приклади заповнення таблиці ATTRTYPE
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (1,1,NULL,'NAME','Назва');
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (2,2,NULL,'NAME','Назва');
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (3,3,NULL,'NAME','Прізвище');
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (4,3,NULL,'SAL','Зарплата');
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (5,3,NULL,'JOB','Посада');
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (6,3,NULL,'HIREDATE','Дата зарахування');

-- Приклад заповнення, коли об'єктний тип "Співробітник" пов'язаний
-- іменованою асоціацією "Робота" з об'єктним типом "Підрозділ"
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (7,3,2,'WORK','Робота');

-- Приклад заповнення, коли об'єктний тип "Співробітник" пов'язаний
-- іменованою асоціацією "Управління" з об'єктним типом "Менеджер"
INSERT INTO ATTRTYPE (ATTR_ID,OBJECT_TYPE_ID,OBJECT_TYPE_ID_REF,CODE,NAME) 
	VALUES (8,3,4,'MANAGE','Управление');

-- встановлення параметрів форматування колонок для SQLPlus

COL OBJECT_TYPE_ID FORMAT 9999999
COL PARENT_ID FORMAT 9999999
COL CODE FORMAT A10
COL NAME FORMAT A20
COL ATTR_ID FORMAT 9999999
COL OBJECT_ID FORMAT 9999999
COL LIST_VALUE_ID FORMAT 9999999
COL VALUE FORMAT A20

-- Отримання інформації про атрибутні типи
SELECT O.CODE,A.ATTR_ID,A.CODE,A.NAME
	FROM OBJTYPE O, ATTRTYPE A
	WHERE O.OBJECT_TYPE_ID = A.OBJECT_TYPE_ID
	ORDER BY A.OBJECT_TYPE_ID,A.ATTR_ID;
	
-- Отримання інформації про атрибутні типи
-- і можливі зв'язки "іменована асоціація"
SELECT O.CODE,A.ATTR_ID,A.CODE,A.NAME, O_REF.CODE O_REF
	FROM OBJTYPE O, ATTRTYPE A LEFT JOIN OBJTYPE O_REF ON 
								(A.OBJECT_TYPE_ID_REF = O_REF.OBJECT_TYPE_ID)
	WHERE O.OBJECT_TYPE_ID = A.OBJECT_TYPE_ID
	ORDER BY A.OBJECT_TYPE_ID,A.ATTR_ID;

/* 2.2 ТАБЛИЦЯ ДЛЯ ЗБЕРІГАННЯ ЛИСТОВИХ ЗНАЧЕНЬ */
CREATE TABLE LISTS (
	ATTR_ID NUMBER(10),
	LIST_VALUE_ID NUMBER(10),
	VALUE VARCHAR(4000)
);

ALTER TABLE LISTS ADD CONSTRAINT LISTS_PK
	PRIMARY KEY (LIST_VALUE_ID);
ALTER TABLE LISTS ADD CONSTRAINT LISTS_ATTR_ID_FK
	FOREIGN KEY (ATTR_ID) REFERENCES ATTRTYPE(ATTR_ID);

-- Додавання різних значень для атрибута посада
INSERT INTO LISTS(ATTR_ID, LIST_VALUE_ID, VALUE) 
	VALUES(5, 1, 'PRESIDENT');
INSERT INTO LISTS(ATTR_ID, LIST_VALUE_ID, VALUE) 
	VALUES(5, 2, 'ADMINISTRATION VICE PRESIDENT');
INSERT INTO LISTS(ATTR_ID, LIST_VALUE_ID, VALUE) 
	VALUES(5, 3, 'ADMINISTRATION ASSISTANT');
INSERT INTO LISTS(ATTR_ID, LIST_VALUE_ID, VALUE) 
	VALUES(5, 4, 'FINANCE MANAGER');

-- Отримання інформації про листові значення
SELECT O.CODE,A.ATTR_ID,A.CODE,A.NAME,L.LIST_VALUE_ID, L.VALUE
	FROM OBJTYPE O, ATTRTYPE A, LISTS L
	WHERE 	O.OBJECT_TYPE_ID = A.OBJECT_TYPE_ID 
			AND A.ATTR_ID = L.ATTR_ID
	ORDER BY A.OBJECT_TYPE_ID,A.ATTR_ID;

/* 3 ТАБЛИЦЯ ОПИСІВ ЕКЗЕМПЛЯРІВ ОБ'ЄКТІВ */
CREATE TABLE OBJECTS (
	OBJECT_ID      NUMBER(20),
	PARENT_ID      NUMBER(20),
	OBJECT_TYPE_ID NUMBER(20),
	NAME           VARCHAR2(2000),
	DESCRIPTION    VARCHAR2(4000)
);

ALTER TABLE OBJECTS ADD CONSTRAINT OBJECTS_PK
	PRIMARY KEY (OBJECT_ID);
ALTER TABLE OBJECTS ADD CONSTRAINT OBJECTS_PARENT_ID_FK
	FOREIGN KEY (PARENT_ID) REFERENCES OBJECTS (OBJECT_ID);
ALTER TABLE OBJECTS ADD CONSTRAINT OBJECTS_OBJECT_TYPE_ID_FK
	FOREIGN KEY (OBJECT_TYPE_ID) REFERENCES OBJTYPE (OBJECT_TYPE_ID);

COMMENT ON TABLE OBJECTS IS 'Таблиця описів екземплярів об`єктів';

-- Створення екземпляра об'єкта "LOC"("Місто")
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME,DESCRIPTION) 
	VALUES (1,NULL,1,'Odessa',NULL);

-- Створення екземпляра об'єкта "DEPT"("Підрозділ")
-- як спадкоємця екземпляра об'єкта "Місто"
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME,DESCRIPTION) 
	VALUES (2,1,2,'Odessa Office',NULL);

-- Створення екземпляра об'єкта "EMP"("Співробітник")
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME,DESCRIPTION) 
	VALUES (3,NULL,3,'Petrov Petr',NULL);
-- Створення екземпляра об'єкта "EMP"("Співробітник")
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME,DESCRIPTION) 
	VALUES (4,NULL,3,'Sidorov Sidor',NULL);
-- Створення екземпляра об'єкта класу "MGR"("Менеджер")
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME,DESCRIPTION)
	VALUES (5,NULL,4,'Ivanov Ivan',NULL);

-- Створення екземпляра об'єкта "LOC"("Місто")
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME,DESCRIPTION) 
	VALUES (6,NULL,1,'New York',NULL);

-- Отримання колекції екземплярів об'єктів різних класів
SELECT OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME
	FROM OBJECTS;

-- Отримання колекції екземплярів об'єктів класу ("Місто")
-- через ідентифікатор об'єктного типу = 1
SELECT OBJECT_ID,NAME
	FROM OBJECTS
	WHERE OBJECT_TYPE_ID = 1;

-- Отримання колекції екземплярів об'єктів класу ("Співробітник")
-- через ідентифікатор об'єктного типу = 3
SELECT OBJECT_ID,NAME
FROM OBJECTS
WHERE 
    OBJECT_TYPE_ID = 3;

-- Отримання колекції екземплярів об'єктів класу "LOC" ("Місто")
SELECT LOC.OBJECT_ID,LOC.NAME
FROM OBJECTS LOC, OBJTYPE OT 
WHERE 	
    OT.CODE = 'LOC' 
	AND OT.OBJECT_TYPE_ID = LOC.OBJECT_TYPE_ID;

-- Отримання колекції екземплярів об'єктів класу "EMP" ("Співробітник")
SELECT EMP.OBJECT_ID,EMP.NAME
FROM OBJECTS EMP, OBJTYPE OT
WHERE 	
    OT.CODE = 'EMP'
    AND EMP.OBJECT_TYPE_ID = OT.OBJECT_TYPE_ID;

-- Отримання колекції екземплярів об'єктів класу "MGR"("Менеджер")
SELECT EMP.OBJECT_ID,EMP.NAME
FROM OBJECTS EMP, OBJTYPE EMP_TYPE
WHERE 
	EMP_TYPE.CODE = 'MGR' AND 
	EMP.OBJECT_TYPE_ID = EMP_TYPE.OBJECT_TYPE_ID;

-- Отримання екземпляра об'єктів класу "DEPT"
-- з ім'ям 'Odessa Office'
SELECT DEPT.OBJECT_ID,DEPT.NAME
FROM OBJECTS DEPT, OBJTYPE DEPT_TYPE
WHERE 
	DEPT.NAME = 'Odessa Office'
	AND DEPT_TYPE.CODE = 'DEPT'
	AND DEPT_TYPE.OBJECT_TYPE_ID = DEPT.OBJECT_TYPE_ID;

/* 4 ТАБЛИЦЯ ОПИСІВ ЗНАЧЕНЬ АТРИБУТІВ ЕКЗЕМПЛЯРІВ ОБ'ЄКТІВ */
CREATE TABLE ATTRIBUTES (
	ATTR_ID NUMBER(10),
	OBJECT_ID NUMBER(20),
	VALUE VARCHAR2(4000),
	DATE_VALUE DATE,
	LIST_VALUE_ID NUMBER(10)
);  

ALTER TABLE ATTRIBUTES ADD CONSTRAINT ATTRIBUTES_PK
	PRIMARY KEY (ATTR_ID, OBJECT_ID);
ALTER TABLE ATTRIBUTES ADD CONSTRAINT ATTRIBUTES_LIST_VALUE_ID_FK
	FOREIGN KEY (LIST_VALUE_ID) REFERENCES LISTS (LIST_VALUE_ID);
ALTER TABLE ATTRIBUTES ADD CONSTRAINT ATTRIBUTES_ATTR_ID_FK
	FOREIGN KEY (ATTR_ID) REFERENCES ATTRTYPE (ATTR_ID);
ALTER TABLE ATTRIBUTES ADD CONSTRAINT ATTRIBUTES_OBJECT_ID_FK
	FOREIGN KEY (OBJECT_ID) REFERENCES OBJECTS (OBJECT_ID);

COMMENT ON TABLE ATTRIBUTES IS 'Таблиця описів атрибутів екземплярів обєктів';
COMMENT ON COLUMN ATTRIBUTES.VALUE IS 'Значення атрибута екземпляра обєкта у вигляді рядка чи числа';
COMMENT ON COLUMN ATTRIBUTES.DATE_VALUE IS 'Значення атрибута екземпляра обєкта у вигляді дати';

-- Встановлення співробітника Petrov Petr:
-- 1) ім'я = Petrov Petr
INSERT INTO ATTRIBUTES(ATTR_ID, OBJECT_ID, VALUE)
	VALUES(3, 3, 'Petrov Petr');
-- 2) посада = 'Finance Manager' 
INSERT INTO ATTRIBUTES(ATTR_ID, OBJECT_ID, LIST_VALUE_ID)
	VALUES(5, 3, 4);
-- 3) зарплата = 100
INSERT INTO ATTRIBUTES(ATTR_ID, OBJECT_ID, VALUE)
	VALUES(4, 3, 100);
-- 4) дата зарахування = '10/09/2022'
INSERT INTO ATTRIBUTES(ATTR_ID, OBJECT_ID, DATE_VALUE)
	VALUES(6, 3, TO_DATE('10/09/2022','DD/MM/YYYY'));

--  Встановлення співробітнику Sidorov Sidor посади Administration Assistant
INSERT INTO ATTRIBUTES(ATTR_ID, OBJECT_ID, LIST_VALUE_ID)
	VALUES(5, 4, 3);

-- Встановлення співробітника Petrov Petr посади President
INSERT INTO ATTRIBUTES(ATTR_ID, OBJECT_ID, LIST_VALUE_ID)
	VALUES(5, 5, 1);

-- Отримання списку імен та зарплат працівників.
-- Класичний реляційний приклад рішення
SELECT ENAME,SAL
	FROM EMP;

-- EAV-приклад рішення:
-- Отримання колекції екземплярів класу "EMP"
-- зі значеннями атрибутів NAME, SAL
-- форматування виводу для SQLPlus: COL SAL FORMAT A10
SELECT EMP.NAME, A.VALUE SAL
FROM OBJECTS EMP, OBJTYPE EMP_TYPE, ATTRIBUTES A
WHERE 
	EMP_TYPE.CODE = 'EMP'
	AND EMP_TYPE.OBJECT_TYPE_ID = EMP.OBJECT_TYPE_ID
	AND EMP.OBJECT_ID = A.OBJECT_ID
	AND A.ATTR_ID = 4 /* ідентифікатор атрибуту SAL */ ;

-- Отримання списку імен, зарплат та дат зарахування співробітників
-- Класичний реляційний приклад рішення
-- форматування виводу для SQLPlus: COL SAL FORMAT 999999
SELECT ENAME, SAL, HIREDATE
	FROM EMP;

-- EAV-приклад рішення:
-- отримання колекції екземплярів класу "EMP"
-- зі значеннями атрибутів NAME, SAL, HIREDATE
-- форматування виводу для SQLPlus: COL SAL FORMAT A10
SELECT EMP.NAME, SAL.VALUE SAL, HIREDATE.DATE_VALUE HIREDATE
FROM OBJECTS EMP, OBJTYPE EMP_TYPE, ATTRIBUTES SAL, ATTRIBUTES HIREDATE
WHERE 
	EMP_TYPE.CODE = 'EMP'
	AND EMP_TYPE.OBJECT_TYPE_ID = EMP.OBJECT_TYPE_ID
	AND EMP.OBJECT_ID = SAL.OBJECT_ID
	AND SAL.ATTR_ID = 4 /* ідентифікатор атрибуту SAL */
	AND EMP.OBJECT_ID = HIREDATE.OBJECT_ID
	AND HIREDATE.ATTR_ID = 6 /* ідентифікатор атрибуту HIREDATE*/ ;

-- EAV-приклад рішення:
-- отримання колекції екземплярів класу "EMP"
-- зі значеннями атрибутів NAME, SAL, HIREDATE, JOB
-- форматування виводу для SQLPlus:
-- 		COL SAL FORMAT A10 
-- 		COL JOB FORMAT A20
SELECT EMP.NAME, SAL.VALUE SAL, HIREDATE.DATE_VALUE HIREDATE, 
		JOB_LIST.VALUE JOB
FROM OBJECTS EMP, OBJTYPE EMP_TYPE, ATTRIBUTES SAL, 
ATTRIBUTES HIREDATE, ATTRIBUTES JOB, LISTS JOB_LIST
WHERE 
	EMP_TYPE.CODE = 'EMP'
	AND EMP_TYPE.OBJECT_TYPE_ID = EMP.OBJECT_TYPE_ID
	AND EMP.OBJECT_ID = SAL.OBJECT_ID
	AND SAL.ATTR_ID = 4 /* ідентифікатор атрибуту SAL */
	AND EMP.OBJECT_ID = HIREDATE.OBJECT_ID
	AND HIREDATE.ATTR_ID = 6 /* ідентифікатор атрибуту HIREDATE*/ 
	AND EMP.OBJECT_ID = JOB.OBJECT_ID
	AND JOB.ATTR_ID = 5 /* ідентифікатор атрибуту JOB */ 
	AND JOB.LIST_VALUE_ID = JOB_LIST.LIST_VALUE_ID;

/* 5 ТАБЛИЦЯ ОПИСІВ ЗВ'ЯЗКІВ "ІМЕНОВА АСОЦІАЦІЯ" МІЖ ЕКЗЕМПЛЯРАМИ ОБ'ЄКТІВ */
CREATE TABLE OBJREFERENCE (
	ATTR_ID   NUMBER(20),
	REFERENCE NUMBER(20),
	OBJECT_ID NUMBER(20)
); 

ALTER TABLE OBJREFERENCE ADD CONSTRAINT OBJREFERENCE_PK
	PRIMARY KEY (ATTR_ID,REFERENCE,OBJECT_ID);
ALTER TABLE OBJREFERENCE ADD CONSTRAINT OBJREFERENCE_REFERENCE_FK
	FOREIGN KEY(REFERENCE) REFERENCES OBJECTS(OBJECT_ID);
ALTER TABLE OBJREFERENCE ADD CONSTRAINT OBJREFERENCE_OBJECT_ID_FK
	FOREIGN KEY (OBJECT_ID) REFERENCES OBJECTS(OBJECT_ID);
ALTER TABLE OBJREFERENCE ADD CONSTRAINT OBJREFERENCE_ATTR_ID_FK
	FOREIGN KEY (ATTR_ID) REFERENCES ATTRTYPE (ATTR_ID);

COMMENT ON TABLE OBJREFERENCE IS 'Таблиця описів звязків між екземплярами обєктів';
COMMENT ON COLUMN OBJREFERENCE.ATTR_ID IS 'посилання на атрибутний тип як асоціативний звязок між екземплярами обєктів';
COMMENT ON COLUMN OBJREFERENCE.REFERENCE IS 'посилання на екземпляр 1-го обєкта асоціативного звязку з кратністю "один"';
COMMENT ON COLUMN OBJREFERENCE.OBJECT_ID IS 'посилання на екземпляр 2-го обєкта асоціативного звязку з кратністю "багато"';

/* При переході від UML-діаграми до ORM рекомендується:
4) зв'язок типу "іменована асоціація"
подати у вигляді зв'язку між колонками OBJREFERENCE.OBJECT_ID та OBJREFERENCE.REFERENCE
*/

/*
Екземпляр об'єкта "Співробітник" - "Ivanov Ivan" (OBJECT_ID = 5)
зв'язаний з екземпляром об'єкта "Odessa Office" ( OBJECT_ID = 2 )
атрибутним зв'язком "WORK" (ATTR_ID = 7) за кратністю "багато до одного"
*/
INSERT INTO OBJREFERENCE (ATTR_ID,OBJECT_ID,REFERENCE) 
	VALUES (7,5,2);

/*
Екземпляр об'єкта "Співробітник" - "Petrov Petr" (OBJECT_ID = 3)
зв'язаний з екземпляром об'єкта "Odessa Office" ( OBJECT_ID = 2 )
атрибутним зв'язком "WORK" (ATTR_ID = 7) за кратністю "багато до одного"
*/
INSERT INTO OBJREFERENCE (ATTR_ID,OBJECT_ID,REFERENCE) 
	VALUES (7,3,2);
/*
Екземпляр об'єкта "Співробітник" - "Sidorov Sidor" (OBJECT_ID = 4)
зв'язаний з екземпляром об'єкта "Odessa Office" ( OBJECT_ID = 2 )
атрибутним зв'язком "" (ATTR_ID = 8) за кратністю "багато до одного"
*/
INSERT INTO OBJREFERENCE (ATTR_ID,OBJECT_ID,REFERENCE) 
	VALUES (7,4,2);

/*
Екземпляр об'єкта "Співробітник" - "Sidorov Sidor" (OBJECT_ID = 4)
зв'язаний з екземпляром об'єкта "Менеджер" - "Petrov Petr" (OBJECT_ID = 3)
атрибутним зв'язком "MANAGE" (ATTR_ID = 8) за кратністю "багато до одного"
*/
INSERT INTO OBJREFERENCE (ATTR_ID,OBJECT_ID,REFERENCE) 
	VALUES (8,4,3);
/*
Екземпляр об'єкта "Співробітник" - "Ivanov Ivan" (OBJECT_ID = 5)
зв'язаний з екземпляром об'єкта "Менеджер" - "Petrov Petr" (OBJECT_ID = 3)
атрибутним зв'язком "MANAGE" (ATTR_ID = 8) за кратністю "багато до одного"
*/
INSERT INTO OBJREFERENCE (ATTR_ID,OBJECT_ID,REFERENCE) 
	VALUES (8,5,3);

COMMIT;


/*
Завдання (класична форма): отримати список імен співробітників,
працюючих у підрозділі 'Odessa Office'.
*/

SELECT ENAME 
	FROM EMP E, DEPT D
	WHERE 
		D.DNAME = 'Odessa Office'
		AND E.DEPTNO = D.DEPTNO;
		
/* Завдання (об'єктно-орієнтована форма): отримати колекцію екземплярів об'єктів
класу 'EMP' ('Співробітник'), які пов'язані з екземплярами об'єктів класу
"DEPT" ("Підрозділ"), що містять атрибут Name='Odessa Office'.
При створенні запиту рекомендується підготувати три окремі запити
на отримання:
1) колекції екземплярів об'єкту типу "EMP"
2) колекції екземплярів об'єкта типу "DEPT",
	які містять атрибут Name='Odessa Office'
3) зв'язки між екземплярами об'єкта типу "EMP" та "DEPT"
	з використанням асоціативного зв'язку "WORK"
*/

SELECT EMP.NAME
FROM 
	OBJECTS EMP, OBJTYPE EMP_TYPE,/* псевдоніми таблиць 1-ї умови*/
	OBJECTS DEPT, OBJTYPE DEPT_TYPE,/* псевдоніми таблиць 2-ї умови*/
	ATTRTYPE DEPT_ATTR, 
	OBJREFERENCE DEPT_REF /* псевдоніми таблиць 3-ї умови */
WHERE 
	/* 1) колекції екземплярів об'єкту типу "EMP" */
	EMP_TYPE.CODE = 'EMP'
	AND EMP_TYPE.OBJECT_TYPE_ID = EMP.OBJECT_TYPE_ID
	/* 2) колекції екземплярів об'єкту типу "DEPT" 
			які містять атрибут Name='Odessa Office' */
	AND DEPT.NAME = 'Odessa Office'
	AND DEPT_TYPE.CODE = 'DEPT'
	AND DEPT_TYPE.OBJECT_TYPE_ID = DEPT.OBJECT_TYPE_ID
	/* 3) отримання "WORK" зв'язку типу "іменована асоціація"
			між екземплярами об'єктів класу "EMP" та "DEPT" */
	AND DEPT_ATTR.CODE = 'WORK'
	AND DEPT_ATTR.ATTR_ID = DEPT_REF.ATTR_ID
	AND DEPT_REF.OBJECT_ID = EMP.OBJECT_ID
	AND DEPT_REF.REFERENCE = DEPT.OBJECT_ID;

/* 
Наведений раніше приклад використовує таблицю OBJTYPE та ATTRTYPE
для вказівки потрібних типів об'єктів чи зв'язків через імена у колонці CODE.
Позитивна сторона такого опису, пов'язана з читабельністю запиту,
удвічі збільшує кількість таблиць та зв'язків між ними,
що може збільшити час виконання запиту.
Тому рекомендується виключати такі зв'язки та
замінювати їх коментарями до ідентифікаторів у самому коді.
*/

SELECT EMP.NAME
FROM OBJECTS EMP,OBJECTS DEPT,OBJREFERENCE DEPT_REF
WHERE 
/* 1) отримання колекції екземплярів об'єкту типу "EMP"*/
EMP.OBJECT_TYPE_ID = 3 /* EMP */ 
/* 2) отримання екземплярів об'єкта типу "DEPT"
	з ім'ям "Odessa Office" */
AND DEPT.NAME = 'Odessa Office'
AND DEPT.OBJECT_TYPE_ID = 2 /* DEPT */
/* 3) отримання зв'язку між екземплярами об'єкта типу "EMP" та
	"DEPT" з використанням асоціативного зв'язку "WORK" */
AND DEPT_REF.ATTR_ID = 7 /* WORK */
AND DEPT_REF.OBJECT_ID = EMP.OBJECT_ID
AND DEPT_REF.REFERENCE = DEPT.OBJECT_ID;

/* Статистика заповнення таблиць */
SELECT 'OBJTYPE' TABLE_NAME,COUNT(OBJECT_TYPE_ID) COUNT FROM OBJTYPE
UNION ALL
SELECT 'ATTRTYPE',COUNT(OBJECT_TYPE_ID) COUNT FROM ATTRTYPE
UNION ALL
SELECT 'LISTS',COUNT(ATTR_ID) COUNT FROM LISTS
UNION ALL
SELECT 'OBJECTS',COUNT(OBJECT_ID) COUNT FROM OBJECTS
UNION ALL
SELECT 'ATTRIBUTES',COUNT(ATTR_ID) COUNT FROM ATTRIBUTES
UNION ALL
SELECT 'OBJREFERENCE',COUNT(ATTR_ID) COUNT FROM OBJREFERENCE;


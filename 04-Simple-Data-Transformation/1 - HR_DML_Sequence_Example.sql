/* 
Лекція "Генератори унікальних послідовностей у СКБД Oracle"
*/

SET LINESIZE 2000
SET PAGESIZE 100

/*

Що таке послідовність (SEQUENCE)?
1) автоматично генерує унікальні числа
2) використовується для формування значень первинних ключів
3) скорочує час доступу до результатів генерації
при кешуванні результатів генерації в пам'ять

*/

/* Команда CREATE SEQUENCE */

CREATE SEQUENCE sequence
	[INCREMENT BY n]
	[START WITH n]
	[{MAXVALUE n | NOMAXVALUE}]
	[{MINVALUE n | NOMINVALUE}]
	[{CYCLE | NOCYCLE}]
	[{CACHE n | NOCACHE}];

/*
Опис параметрів:
INCREMENT BY – зміщення значення
	при наступному виклику генератора;
MINVALUE, MAXVALUE – мінімальне та максимальне значення
	діапазону значень;
START WITH – початкове значення всередині діапазону,
	за замовчуванням збігається з MINVALUE = 1;
CYCLE – повернення лічильника до MINVALUE
	після перевищення значення MAXVALUE;
CACHE - збереження згенерованих значень
	в оперативній пам'яті для прискорення доступу,
	за замовчуванням зберігається 20 значень
*/

-- Отримання поточного максимального значення PK locno
SELECT MAX(locno) FROM Loc; -- відповідь = 3

-- Cтворення генератора для генерації унікальних значень 
-- починаючи з MAX(locno) + 1, наприклад 3+1 = 4
CREATE SEQUENCE loc_locno START WITH 4;

-- Отримання поточного максимального значення PK deptno
SELECT MAX(deptno) FROM Dept; -- відповідь = 4

-- Створення генератора для генерації унікальних
-- значень ідентифікатора підрозділу
CREATE SEQUENCE dept_deptno START WITH 5;

/* 

Псевдостовпці NEXTVAL і CURRVAL:
1) NEXTVAL повертає нове згенероване число послідовності
2) NEXTVAL повертає унікальне значення при кожному виклику,
   навіть якщо його викликають різні транзакції.
3) CURRVAL зберігає поточне згенероване число послідовності
4) NEXTVAL має бути викликаний хоча б раз,
   щоб у CURRVAL зберігалося значення
5) згенеровані значення кешуються в оперативній пам'яті,
   за замовчуванням для 20 паралельних викликів транзакцій

*/

-- Генерація нового значення генератора
SELECT dept_deptno.NEXTVAL FROM DUAL;

-- Отримання поточного значення генератора
SELECT dept_deptno.CURRVAL FROM DUAL;

/*
Кешування значень послідовності:

1) Кешування значень послідовності у пам'яті дозволяє збільшити швидкість доступу до цих значень.
2) Пропуски в послідовностях виникають при:
	- скасування внесених значень за результатами команди ROLLBACK,
	- використання послідовності в декількох таблицях
3) Якщо послідовність була створена з параметром NOCACHE,
	її наступне значення можна побачити,
	сформувавши запит до таблиці USER_SEQUENCES
4) При кешуванні (за замовчуванням = 20 значень)
	атрибут LAST_NUMBER містить не поточне значення,
	а значення після 20 генерацій.
5) За відсутності кешування LAST_NUMBER
	містить значення, сформоване генератором
	після виклику наступної команди NEXTVAL

*/

SELECT SEQUENCE_NAME,LAST_NUMBER
	FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME IN ('LOC_LOCNO','DEPT_DEPTNO'); 

/* 
Зміна початкового значення генератора в Oracle < 12c заборонено, 
Можливе тільки:
1) видалення існуючого генератора
2) повторне створення генератора з новим початковим значенням
*/

DROP SEQUENCE loc_locno;
CREATE SEQUENCE loc_locno START WITH 20;

-- Зміна початкового значення генератора в Oracle 12
ALTER SEQUENCE loc_locno RESTART START WITH 20;

-- Внесення нової локації
INSERT INTO Loc (locno, lname )
	VALUES (loc_locno.NEXTVAL, 'ODESA 2');

-- Внесення нового підрозділу у новій локації
INSERT INTO dept (deptno, dname, locno )
	VALUES (dept_deptno.NEXTVAL, 'NEW DEPART 2',
			loc_locno.CURRVAL);

-- Отримання поточного максимального значення PK empno
SELECT MAX(empno) FROM Emp;

-- Створення генератора для генерації унікальних
-- значень ідентифікатора співробітника
CREATE SEQUENCE emp_empno START WITH 6;

/*
Реєстрація нового співробітника:
ім'я = 'PETROV', посада = 'STUDENT', дата зарахування = поточна дата,
зарплата = 0, премія = 0, локація = 'KIEV'
назва підрозділу = 'Odesa NC'
*/

INSERT INTO Loc (locno, lname )
	VALUES (loc_locno.NEXTVAL, 'KIEV');
INSERT INTO dept (deptno, dname, locno)
    VALUES (dept_deptno.NEXTVAL, 'Odesa NC', 
			loc_locno.CURRVAL);
INSERT INTO emp (empno, ename, job, hiredate, sal, 
				comm, deptno)
    VALUES (emp_empno.NEXTVAL, 'PETROV', 'STUDENT', 
				SYSDATE-40, 100, 0, dept_deptno.CURRVAL);

/* Використання генератора в опції DEFAULT для Oracle < 12c – заборонено.
Потрібно використовувати тригер для автоматичного виклику генератора.
Oracle >= 12c пропонує два варіанти:
1) стандартне включення до секції DEFAULT
2) використання спеціальноъ IDENTITY колонки
*/

-- Oracle >= 12c. Стандартне включення до секції DEFAULT
ALTER TABLE Loc MODIFY 
	(locno number DEFAULT loc_locno.nextval NOT NULL);

INSERT INTO Loc (lname) VALUES ('TEST');
SELECT * FROM Loc;

 
/* Oracle >= 12c. 
IDENTITY-колонка, особливості:
1) створюється тільки при створенні таблиці або додаванні нової колонки
2) тип даних колонки INTEGER, LONG, NUMBER
3) на відміну від генератора, створеного через create sequence,
   IDENTITY-генератор дозволяє заборонити
   самостійно вносити значення поза генератором
Шаблон визначення колонки:
GENERATED [ ALWAYS | BY DEFAULT [ON NULL]]
AS IDENTITY [ ( опції ) ]

1) GENERATED ALWAYS AS IDENTITY -
   генератор самостійно генерує значення,
   не дозволяючи це робити іншими способами
2) GENERATED BY DEFAULT AS IDENTITY -
   генератор самостійно генерує значення,
   якщо при внесенні даних не вказується значення колонки IDENTITY
3) GENERATED BY DEFAULT ON NULL AS IDENTITY -
   генератор самостійно генерує значення,
   якщо при внесенні даних значення IDENTITY-колонки = NULL
	
*/

-- Приклад роботи IDENTITY-колонки типу GENERATED ALWAYS
DROP TABLE identity_demo;
CREATE TABLE identity_demo (
    id NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1,
    description VARCHAR2(10)
);

INSERT INTO identity_demo(description)
VALUES('Oracle1');
	
SELECT * 
FROM identity_demo;

-- Спроба самостійного внесення значення поза генератором
INSERT INTO identity_demo(id,description)
	VALUES(2,'Oracle2'); 
-- Результат команди - ERROR at line 1: 
-- ORA-32795: cannot insert into a generated always identity column

-- Зміна типу IDENTITY-колонки на тип GENERATED BY DEFAULT
-- з новим початковим значенням
ALTER TABLE identity_demo 
	MODIFY ( id NUMBER GENERATED BY DEFAULT AS IDENTITY START WITH 2);	
  
INSERT INTO identity_demo(description)
	VALUES('Oracle2');
SELECT * 
FROM identity_demo;

INSERT INTO identity_demo(id,description)
	VALUES(2,'Oracle3');

SELECT * 
FROM identity_demo;

-- Зміна типу IDENTITY-колонки на GENERATED BY DEFAULT ON NULL
-- з новим початковим значенням
ALTER TABLE identity_demo 
	MODIFY ( id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 4);

INSERT INTO identity_demo(description)
	VALUES('Oracle');
SELECT * 
FROM identity_demo;

INSERT INTO identity_demo(id,description)
	VALUES(2,'Oracle');

SELECT * 
FROM identity_demo;
INSERT INTO identity_demo(id,description)
	VALUES(NULL,'Oracle');

SELECT * 
FROM identity_demo;

-- Видалення старої колонки
ALTER TABLE identity_demo 
	DROP COLUMN id;

-- Додавання нової колонки 
ALTER TABLE identity_demo 
	ADD id NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1;

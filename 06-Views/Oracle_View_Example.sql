/* 

Лекція "Віртуальні таблиці (представлення - VIEW) та інтеграція даних"

*/

SET LINESIZE 2000
SET PAGESIZE 100

/* СТВОРЕННЯ ВІРТУАЛЬНИХ ТАБЛИЦЬ (VIEW) У РЕЛЯЦІЙНІЙ БД */

/*

Цілі використання віртуальних таблиць як користувальницьких представлень про БД
1) спрощення процесу створення складних запитів:
	- структуризація складних запитів;
	- виділення частин, що повторюються у різних запитах
2) незалежність програмного коду від структур даних:
	- незалежності від реальних назв таблиць;
	- незалежності від реальних назв колонок;
	- незалежності від реальних зв'язків між таблицями.
3) багаторольове представлення про вміст БД 
4) санкціонований доступ до даних:
	- вертикальна фрагментація таблиць;
	- горизонтальна фрагментація таблиць

*/


/*
Шаблон створення віртуальної таблиці
*/
CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW view_name
[(alias[, alias]...)]
AS subquery
[WITH READ ONLY];

/* 
Опис мовної конструкції:
- CREATE - створення віртуальної таблиці
- CREATE OR REPLACE - створення або зміна, якщо вже існує
- alias[, alias]... - список псевдонімів
- subquery - довільний SELECT-запит;
- WITH READ ONLY - опція заборони на марну спробу зміни
	віртуальної таблиці
*/

/*
Якщо під час створення віртуальних таблиць виникне помилка
"ORA-01031: insufficient privileges" - "недостатньо привілеїв",
тоді від імені адмін-користувача виконати команду надання необхідних прав:
GRANT CREATE VIEW TO ім'я_користувача;
Зміна прав доступу набирає чинності лише після повторного входу користувача до системи 
*/

/* Створення віртуальної таблиці, яка:
1) містить номери та прізвища співробітників
2) співробітники працюють на посаді SALESMAN
*/
CREATE OR REPLACE VIEW SALESMAN_LIST
(EMPNO,ENAME,JOB)
AS
SELECT EMPNO,ENAME,JOB
	FROM EMP
	WHERE JOB = 'SALESMAN';

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM SALESMAN_LIST;


/* Створення віртуальної таблиці, яка:
1) містить номери, прізвища співробітників та назви підрозділів
2) співробітники працюють на посаді CLERK
*/
CREATE OR REPLACE VIEW CLERK_LIST
(NO,NAME,JOB,DEPT)
AS
SELECT E.EMPNO,E.ENAME,E.JOB,D.DNAME
	FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
	WHERE E.JOB = 'CLERK';

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM CLERK_LIST;

/* ВИКОНАННЯ DML-ОПЕРАЦІЙ НАД ВІРТУАЛЬНИМИ ТАБЛИЦЯМИ

Умова виконання DML-операцій (INSERT, UPDATE, DELETE)
над віртуальною таблицею - СУБД зможе врахувати всі обмеження цілісності,
існуючі у реальних таблицях.

*/

-- Оновлення існуючого рядка віртуальної таблиці
UPDATE SALESMAN_LIST SET JOB = 'CLERK'
	WHERE ENAME = 'ALLEN';

-- Отримання вмісту віртуальної таблиці
SELECT * FROM SALESMAN_LIST;
ROLLBACK;

-- Додавання нового рядка до віртуальної таблиці
INSERT INTO SALESMAN_LIST (EMPNO,ENAME,JOB)
	VALUES (EMP_EMPNO_SEQ.NEXTVAL, 'CAT', 'SALESMAN');

-- Отримання вмісту віртуальної таблиці
-- з новим рядком
SELECT * 
FROM SALESMAN_LIST;

-- отримання нового рядка у таблиці EMP
SELECT * 
FROM EMP 
WHERE 
    ENAME = 'CAT';

-- Оновлення існуючого рядка віртуальної таблиці
UPDATE CLERK_LIST SET JOB = 'SALESMAN'
WHERE 
    NAME = 'MILLER';

-- Отримання вмісту віртуальної таблиці
SELECT * FROM SALESMAN_LIST;
ROLLBACK;

-- Спроба оновлення існуючого рядка віртуальної таблиці
UPDATE CLERK_LIST SET DEPT = 'OFFICE 15'
	WHERE NAME = 'MILLER';
	
-- Результат виконання команди - 
-- Помилка: ORA-01779: cannot modify a column which maps to a non key-preserved table
-- Немає можливості оновити колонку, яка неоднозначно зіставляється із реальною таблицею.

/* 
Створення віртуальної таблиці, для якої:
1) вміст береться з БД EAV
2) структура збігається із структурою таблиці LOC
Форматування:
COL NAME FORMAT A20
COL ENAME FORMAT A20

*/

CREATE VIEW LOC_EAV
(EMPNO,ENAME)
AS
SELECT LOC.OBJECT_ID,LOC.NAME
	FROM OBJECTS LOC, OBJTYPE OT 
	WHERE 	OT.CODE = 'LOC' AND
			OT.OBJECT_TYPE_ID = LOC.OBJECT_TYPE_ID;

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM LOC_EAV;

/* НЕВІДНОВЛЮВАНІ ВІРТУАЛЬНІ ТАБЛИЦІ ТА ОПЦІЯ WITH READ ONLY

Умови НЕ ВИКОНАННЯ DML-операцій над віртуальною таблицею -
	це наявність у SQL-запиті наступних характеристик:
– агрегуючі функції;
– пропозиція GROUP BY;
- ключове слово DISTINCT;
- обчислювані колонки із застосуванням різних виразів;
- операції роботи з множинами.

Процес перевірки можливості оновлення віртуальної таблиці
вимагає додаткового часу та ресурсів сервера.
Тому якщо наперед відомо, що віртуальна таблиця
ніколи не буде оновлюватися з боку застосунків,
рекомендується її створювати з опцією WITH READ ONLY

*/

/* Створення віртуальної таблиці,
яка по кожному підрозділу формує кількість працюючих співробітників.
Віртуальна таблиця не може бути оновлюваною
*/
CREATE OR REPLACE VIEW EMP_DEPT_REPORT
(DEPTNO,EMP_COUNT)
AS
SELECT DEPTNO, COUNT(EMPNO)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO
WITH READ ONLY;

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM EMP_DEPT_REPORT;

-- Спроба модифікувати віртуальну таблицю
UPDATE EMP_DEPT_REPORT SET EMP_COUNT = 15
WHERE 
    DEPTNO = 1;
	
-- Результат виконання команди - Помилка:
-- ORA-01732: data manipulation operation not legal on this view

/* Створення віртуальної таблиці, яка:
1) містить номери та прізвища співробітників
2) співробітники працюють на посаді SALESMAN
3) забороняє змінювати вміст віртуальної таблиці
*/
CREATE OR REPLACE VIEW SALESMAN_LIST
(EMPNO,ENAME,JOB)
AS
SELECT EMPNO,ENAME,JOB
	FROM EMP
	WHERE JOB = 'SALESMAN'
WITH READ ONLY;

-- Отримати список співробітників
SELECT * 
FROM SALESMAN_LIST;

/* Спроба видалення з віртуальної таблиці */
DELETE FROM SALESMAN_LIST;

-- Результат виконання - повідомлення про помилку
-- ORA-42399: cannot perform a DML operation on a read-only view

/* ВІРТУАЛІЗАЦІЯ ТАБЛИЦЬ БД EAV */

-- Форматування в SQLPlus
COL OBJECT_TYPE_ID FORMAT 9999999
COL PARENT_ID FORMAT 9999999
COL CODE FORMAT A10
COL NAME FORMAT A20
COL ATTR_ID FORMAT 9999999
COL OBJECT_ID FORMAT 9999999
COL LIST_VALUE_ID FORMAT 9999999
COL VALUE FORMAT A20
COL CLASSNAME FORMAT A10
COL OBJECTNAME FORMAT A20
COL PARENTNAME FORMAT A20

/* Створення віртуальної таблиці, що містить
інформацію про атрибутні типи 
*/
CREATE VIEW ATTRTYPE_LIST 
(OBJECT_CODE,ATTR_ID,ATTR_CODE,NAME)
AS
SELECT O.CODE,A.ATTR_ID,A.CODE,A.NAME
	FROM OBJTYPE O, ATTRTYPE A
	WHERE O.OBJECT_TYPE_ID = A.OBJECT_TYPE_ID
	ORDER BY A.OBJECT_TYPE_ID,A.ATTR_ID;

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM ATTRTYPE_LIST;

/* Створення або зміна віртуальної таблиці, що містить
інформацію про атрибутні типи та
можливі зв'язки "іменована асоціація"
*/
CREATE OR REPLACE VIEW ATTRTYPE_LIST 
(OBJECT_CODE,ATTR_ID,ATTR_CODE,OBJECT_REF)
AS
SELECT O.CODE, A.ATTR_ID, A.CODE, O_REF.CODE
FROM OBJTYPE O, 
	    ATTRTYPE A LEFT JOIN OBJTYPE O_REF ON 
		    (A.OBJECT_TYPE_ID_REF = O_REF.OBJECT_TYPE_ID)
WHERE 
    O.OBJECT_TYPE_ID = A.OBJECT_TYPE_ID
ORDER BY A.OBJECT_TYPE_ID,A.ATTR_ID;

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM ATTRTYPE_LIST;

/* Створення або зміна віртуальної таблиці, що містить колонки:
CLASSNAME,OBJECT_ID,OBJECTNAME,PARENT_ID
Форматування SQLPlus:
COL CLASSNAME FORMAT A10
COL OBJECTNAME FORMAT A20
COL PARENTNAME FORMAT A20
*/
CREATE OR REPLACE VIEW OBJECT_LIST
(CLASSNAME,OBJECT_ID,OBJECTNAME,PARENT_ID,PARENTNAME)
AS
SELECT OT.CODE, O.OBJECT_ID, O.NAME AS OBJECTNAME, O.PARENT_ID, PO.NAME AS PARENTNAME
FROM OBJECTS O JOIN OBJTYPE OT ON (O.OBJECT_TYPE_ID = OT.OBJECT_TYPE_ID)
       LEFT JOIN OBJECTS PO ON (O.PARENT_ID = PO.OBJECT_ID);

-- Отримання вмісту віртуальної таблиці
SELECT * 
FROM OBJECT_LIST
ORDER BY CLASSNAME;

/* ВИДАЛЕННЯ ВІРТУАЛЬНИХ ТАБЛИЦЬ - DROP VIEW
Видалення не пов'язане із втратою даних, оскільки дані
зберігаються у реальних таблицях, які входять у запит віртуальної таблиці
*/
DROP VIEW ATTRTYPE_LIST;


/* УПРАВЛІННЯ СХЕМАМИ ДАНИХ КОРИСТУВАЧІВ */

-- Створення нового користувача з правом встановлення з'єднання 
-- до власної схеми даних
CREATE USER BLAZHKO_EAV IDENTIFIED BY p1234;
GRANT CONNECT TO BLAZHKO_EAV;

-- (Звичайний користувач) 
-- Отримання вмісту таблиці LOC,
-- розташованої у схемі даних іншого користувача (STUDENT)
SELECT * FROM STUDENT.LOC;

-- (Адміністратор) 
-- Надання прав доступу на читання вмісту таблиці 
GRANT SELECT ON STUDENT.LOC TO BLAZHKO_EAV;

-- (Адміністратор)
-- Створення віртуальної таблиці, що обмежує доступ
-- до рядків реальної таблиці
CREATE OR REPLACE VIEW BLAZHKO_EAV.LOC
(LOCNO,LNAME)
AS
SELECT LOCNO, LNAME 
	FROM STUDENT.LOC
	WHERE LNAME LIKE 'O%';

-- (Звичайний користувач)
-- Отримання вмісту таблиці LOC,
-- розташованої у схемі даних іншого користувача (STUDENT).
-- Примітка: За замовчуванням, Oracle спочатку шукає імена таблиць
-- у поточній схемі даних користувача,
-- тому першою буде знайдено віртуальну таблицю LOC із схеми даних BLAZHKO_EAV
SELECT * FROM LOC;

-- (Звичайний користувач) 
-- Зміна назви схеми даних, яка використовується за замовчуванням,
ALTER SESSION SET CURRENT_SCHEMA=STUDENT;

-- (Звичайний користувач) 
-- Отримання назви поточної схеми даних користувача
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL;

-- (Звичайний користувач) 
-- Отримання вмісту таблиці під назвою LOC.
-- Примітка: першою буде знайдено реальну таблицю LOC у поточній схемі даних STUDENT.
SELECT * FROM LOC;

-- (Звичайний користувач) 
-- Отримання вмісту таблиці у поточній схемі даних
ALTER SESSION SET CURRENT_SCHEMA=BLAZHKO_EAV;
SELECT * FROM LOC;

-- (Адміністратор) 
-- Зняття прав доступу на читання вмісту реальної таблиці LOC
REVOKE SELECT ON STUDENT.LOC FROM BLAZHKO_EAV;

-- (Звичайний користувач) 
-- Спроба отримання вмісту віртуальної таблиці 
SELECT * FROM BLAZHKO_EAV.LOC;
-- В результаті виконання запиту виникає помилка:
-- ORA-04063: view "BLAZHKO_EAV.LOC" has errors
-- Віртуальна таблиця не знає про те,
-- що прибрано права на читання реальної таблиці 


/* ВИКОНАННЯ МАСОВИХ INSERT-ОПЕРАЦІЙ НА ОСНОВІ РЕЗУЛЬТАТІВ SELECT-ЗАПИТІВ */

/*
Властивості конструкції "INSERT INTO ... SELECT ...":
1) вираз INSERT може містити підзапит;
2) пропозиція VALUES відсутня;
3) результат підзапиту повинен задовольняти кількості та типам колонок.

Порядок створення команди:
1) визначити стовпці результуючого набору
	як майбутні джерела для значень стовпців нових рядків;
2) визначити SQL-запит щодо формування результуючого набору;
3) визначити команду INSERT із підключеним SQL-запитом
	замість виразу VALUES.
*/

/* Множинне внесення нових значень локацій */
SELECT LOC_LOCNO.NEXTVAL FROM DUAL; -- 61
INSERT INTO LOC (LOCNO,LNAME)
	SELECT 80,'LOCATION 8' FROM DUAL
	UNION ALL
	SELECT 81,'LOCATION 9' FROM DUAL
	UNION ALL
	SELECT 82,'LOCATION 10' FROM DUAL;

/* ІНТЕГРАЦІЯ БАЗ ДАНИХ */

-- Надання необхідних прав для роботи зі схемою даних
GRANT RESOURCE TO BLAZHKO_EAV;
GRANT CREATE VIEW TO BLAZHKO_EAV;
ALTER USER BLAZHKO_EAV quota unlimited on USERS;

-- Створення генератора послідовності для таблиці
SELECT MAX(OBJECT_ID) FROM OBJECTS; -- 6
CREATE SEQUENCE OBJECTS_OBJECT_ID START WITH 7;

-- Надання прав доступу до таблиці LOC схеми даних STUDENT
GRANT SELECT ON STUDENT.LOC TO BLAZHKO_EAV;
GRANT SELECT ON STUDENT.DEPT TO BLAZHKO_EAV;
GRANT SELECT ON STUDENT.EMP TO BLAZHKO_EAV;

/* 
Заповнення таблиці OBJECTS екземплярами об'єктів класу "LOC"
на основі вмісту таблиці STUDENT.LOC
*/
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME)
	SELECT OBJECTS_OBJECT_ID.NEXTVAL,NULL,OT.OBJECT_TYPE_ID,L.LNAME
	FROM OBJTYPE OT, STUDENT.LOC L
	WHERE 
	    OT.CODE = 'LOC';

-- Отримання колекції екземплярів об'єктів класу "LOC"
-- Використовується віртуальна таблиця OBJECT_LIST
SELECT * 
FROM OBJECT_LIST
WHERE 
    CLASSNAME = 'LOC';

/* 
Заповнення таблиці OBJECTS екземплярами об'єктів класу "DEPT"
на основі вмісту таблиці STUDENT.DEPT з урахуванням
наявності агрегатної асоціації між
екземплярами об'єктів класу "LOC" та екземплярами об'єкта класу "DEPT"
Враховується, що клас "LOC" знаходиться в кратності "один"
по відношенню до класу " DEPT " (кратність "багато"), тобто.
OBJECTS.PARENT_ID містить посилання на екземпляри об'єктів класу "LOC"
*/	
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME)
	SELECT OBJECTS_OBJECT_ID.NEXTVAL,O2.OBJECT_ID,OT.OBJECT_TYPE_ID,D.DNAME
	FROM OBJTYPE OT, STUDENT.LOC L, STUDENT.DEPT D, OBJECTS O2
	WHERE 	OT.CODE = 'DEPT'
			AND L.LOCNO = D.LOCNO
			AND L.LNAME = O2.NAME;

/* 
Заповнення таблиці OBJECTS екземплярами об'єктів класу "EMP"
на основі вмісту таблиці STUDENT.EMP
*/	
INSERT INTO OBJECTS (OBJECT_ID,PARENT_ID,OBJECT_TYPE_ID,NAME)
	SELECT OBJECTS_OBJECT_ID.NEXTVAL,NULL,OT.OBJECT_TYPE_ID,E.ENAME
	FROM OBJTYPE OT, STUDENT.EMP E
	WHERE 
	    OT.CODE = 'EMP';

/* 
Заповнення таблиці OBJREFERENCE зв'язками типу "іменована асоціація"
між екземплярами об'єктів класу "DEPT" та екземплярами об'єктів класу "EMP".
Враховується, що клас DEPT знаходиться в кратності один
по відношенню до класу "EMP" (кратність "багато"), тобто
OBJREFERENCE.REFERENCE містить посилання на екземпляри об'єктів класу "DEPT",
а OBJREFERENCE.OBJECT_ID містить посилання на екземпляри об'єктів класу "EMP"
*/	
INSERT INTO OBJREFERENCE (ATTR_ID,OBJECT_ID,REFERENCE)
	SELECT AT.ATTR_ID, O_EMP.OBJECT_ID, O_DEPT.OBJECT_ID
		FROM ATTRTYPE AT, OBJECT_LIST O_DEPT, OBJECT_LIST O_EMP, 
			STUDENT.DEPT DEPT JOIN STUDENT.EMP EMP ON (DEPT.DEPTNO = EMP.DEPTNO) 
		WHERE 	AT.CODE = 'WORK'
				/* відновлення зв'язку між екземплярами об'єктів класів
					з рядками таблиць реляційної БД */
				AND O_DEPT.OBJECTNAME = DEPT.DNAME 
				AND O_EMP.OBJECTNAME = EMP.ENAME;

/* 
Лекція "Табличні та конвеєрні функції мовою PL/SQL в СУБД Oracle".
Приклади
*/

/* Табличні функції
Табличні функції (Table function) – функції, що повертають 
	колекцію записів у вигляді вкладених таблиць (nested table), 
	varray-масивів або курсорів REF CURSOR.
Табличні функції можуть використовуватися в SQL-запиті 
	як звичайна таблиця БД, забезпечуючи створення тимчасових таблиць 
	за складним алгоритмом, які не можна 
	реалізувати засобами віртуальних таблиць.
*/

/* Особливості створення табличної функції:
1) тип значення, що повертається - колекція Nested-Table-типу;
2) колекція має використовувати елементи відомого типу, 
	інакше помилка: ORA-00902: invalid datatype
3) для створення власних структурних типів використовується 
	CREATE TYPE … IS OBJECT ( … )
4) виклик функції еквівалентний виконанню запиту до таблиці, 
	але з використанням перетворюючої функції TABLE, 
	наприклад, SELECT … FROM TABLE(ім'я_функції(…));
*/

SET LINESIZE 2000
SET PAGESIZE 60
SET SERVEROUTPUT ON

/* Створити табличну функцію отримання списку співробітників 
	(номер, ім'я, посада), 
	працюючих у підрозділі із заданим номером
*/

/* Визначення типів даних
*/
DROP TYPE Emp_short_info_List;
DROP TYPE Emp_short_info;
CREATE TYPE Emp_short_info AS OBJECT (
 empno 	NUMBER(4),
 ename 	VARCHAR(10),
 job 	VARCHAR(10)
);
/
CREATE TYPE Emp_short_info_List IS TABLE OF Emp_short_info;
/

CREATE OR REPLACE FUNCTION get_emp_list(v_deptno IN NUMBER)
RETURN Emp_short_info_List 
AS
	Emp_list Emp_short_info_List := Emp_short_info_List();
BEGIN
	-- виконати запит, передавши результат до колекції
 	SELECT Emp_short_info(empno,ename,job) -- приведення даних до OBJECT-типу
		 BULK COLLECT INTO Emp_list 
		 FROM emp
		 WHERE deptno = v_deptno;
	-- повернути колекцію 
	RETURN Emp_list;
END;
/
SHOW ERROR;

-- Приклад виклику табличної функції 
SELECT empno, ename, job
FROM TABLE(get_emp_list(20))
ORDER BY ename DESC;

/* Створити табличну функцію, що повертає найбільш високооплачуваних 
співробітників у кількості, що визначається як вхідний параметр */

-- Визначення типів даних
DROP TYPE Emp_sal_info_List;
DROP TYPE Emp_sal_info;
CREATE TYPE Emp_sal_info AS OBJECT (
	ename 	VARCHAR(10),
	sal 	FLOAT
);
/
CREATE TYPE Emp_sal_info_List IS TABLE OF Emp_sal_info;
/

CREATE OR REPLACE FUNCTION get_first_emp_list(first_elements IN NUMBER)
RETURN Emp_sal_info_List
AS
	query_str VARCHAR(1000);
	Emp_list Emp_sal_info_List := Emp_sal_info_List();
BEGIN
	-- сформувати динамічний запит з урахуванням версії СУБД
	IF DBMS_DB_VERSION.VERSION < 12 THEN
			query_str := 'WITH emp_sort_sal AS
			(
				SELECT Emp_sal_info(ename, sal) -- приведення даних до OBJECT-типу
				FROM emp 
				ORDER BY sal DESC
			),
			emp_sort_sal_rownum AS
			(
				SELECT ROWNUM r, ename, sal from emp_sort_sal
			)
			SELECT ename, sal 
			FROM emp_sort_sal_rownum
			WHERE r <= :1';
	ELSE
			query_str := 'SELECT Emp_sal_info(ename, sal) -- приведення даних до OBJECT-типу
			 FROM emp 
			 ORDER BY sal DESC 
			 FETCH FIRST :1 ROWS ONLY';
	END IF;
	-- виконати динамічний запит, передавши результат до колекції
	EXECUTE IMMEDIATE query_str 
			BULK COLLECT INTO Emp_list
			USING IN first_elements;
	-- повернути колекцію 
	RETURN Emp_list;
END get_first_emp_list;
/
SHOW ERROR;

-- Приклад виклику табличної функції 
SELECT ename, sal
FROM TABLE(get_first_emp_list(5));

/* Конвеєрні (Pipelined) функції. 
Переваги конвеєрних функцій:
1) використання багатопотокового, паралельного виконання 
	табличних функцій;
2) виключення проміжного збереження даних між процесами;
3) скорочення часу отримання на запит, бо рядки-елементи колекції 
	не накопичуються у буфері, повертаючись одним набором рядків, 
	а повертаються порядково;
4) скорочення обсягів необхідної пам'яті за рахунок 
	відсутності необхідності накопичувати відповідь у буфері.
*/

/* Особливості створення конвеєрних функцій:
1) колекція може використовувати елементи нестандартного типу;
2) у заголовку функції використовується форма виклику 
	… RETURN Nested-Table-тип PIPELINED …;
3) у тілі функції використовується оператор PIPE ROW (елемент колекції);
4) результат з функції повертається відразу після виконання 
	оператора PIPE ROW, тому оператор RETURN не обов'язковий.
*/

/* Створити табличну функцію отримання списку співробітників 
	(номер, ім'я, посада), 
	працюючих у підрозділі із заданим номером.
Повторити рішення у вигляді пакету з конвеєрною табличною функцією
*/
CREATE OR REPLACE PACKAGE employee_pkg IS
	-- оголошення типу як PL/SQL-запису, що визначається програмістом
	TYPE emp_short_info IS RECORD (
		empno 	NUMBER(4),
		ename 	VARCHAR(10),
		job 	VARCHAR(10)
	);
	TYPE Emp_short_info_List IS TABLE OF emp_short_info;
	FUNCTION get_first_emp_list(v_deptno IN NUMBER)
		RETURN Emp_short_info_List PIPELINED;
END employee_pkg;
/
SHOW ERROR;
-- Створення тіла пакету
CREATE OR REPLACE PACKAGE BODY employee_pkg IS
	FUNCTION get_first_emp_list(v_deptno IN NUMBER)
		RETURN Emp_short_info_List PIPELINED
	AS
	BEGIN
		FOR elem IN (SELECT empno,ename,job 
					FROM emp
					WHERE deptno = v_deptno) LOOP
			-- повернути елемент колекції з функції
			PIPE ROW(elem);
		END LOOP;
	END;
END employee_pkg; 
/
SHOW ERROR;

-- Приклад виклику конвеєрної табличної функції
SELECT empno, ename, job
FROM TABLE(employee_pkg.get_first_emp_list(20))
ORDER BY ename DESC;

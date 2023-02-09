/* 
Лекція "Динамічні SQL-команди мови PL/SQL СУБД Oracle"
Приклади команд.
*/

/* Динамічний запит необхідний у разі виконання команд:
	1) по визначенню даних, наприклад, CREATE;
	2) по контролю за доступом до даним, наприклад, GRANT
	3) по контролю за сесійним середовищем, наприклад, ALTER SESSION
	4) зі зміни імен таблиць, колонок у командах SELECT, INSERT, UPDATE, DELETE
	5) щодо безпечної зміни значень колонок в умовах WHERE-фрази
*/

/* Синтаксис динамічного DDL-запиту

EXECUTE IMMEDIATE dyn_str
де 
dyn_str – рядок із запитом;

Рядок не повинен закінчуватися символом ";"
*/

BEGIN
	EXECUTE IMMEDIATE 'CREATE USER student1 IDENTIFIED BY 1234';
END;
/

/* Синтаксис динамічного DQL-запиту

EXECUTE IMMEDIATE dyn_str
[INTO { define_var, ... | record} ]
[USING [IN | OUT | IN OUT] bind_arg , ...];
где 
dyn_str – рядок із запитом;
define_var – змінна, що зберігає отримані 
	в SELECT-запиті колонки;
record  - користувальницький запис або %ROWTYPE-запис, 
	що зберігає колонки із SELECT-запиту
*/

-- Отримання однорядкової відповіді за умовою, що динамічно визначається
DECLARE 
	sql_str VARCHAR2(500);
	v_job emp.job%TYPE;
	count_emp NUMBER;
BEGIN
	BEGIN
		sql_str := 'SELECT count(*) FROM emp WHERE job = :1';
		v_job := 'CLERK';
		EXECUTE IMMEDIATE sql_str INTO count_emp USING IN v_job; 
		DBMS_OUTPUT.PUT_LINE('Count=' || count_emp);
	EXCEPTION
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Error in query:' || sql_str);
	END;
END; 
/ 

/* Синтаксис динамічного DML-запиту

EXECUTE IMMEDIATE dyn_str
[INTO {define_var, ... | record}]
[USING [IN | OUT | IN OUT ] bind_arg , ...]
[{RETURNING | RETURN} INTO bind_arg , … ];
де IN 	bind_arg  - вхідний параметр (за замовчуванням), 
				що передає в рядок dyn_str значення;
		OUT bind_arg  - вихідний параметр, 
				що повертає відповідь на запит рядка dyn_str;
*/

-- Приклад внесення даних через динамічні запити
DECLARE
	v_empno emp.empno%TYPE;
	v_ename emp.ename%TYPE;
	v_job emp.ename%TYPE;
	v_deptno emp.deptno%TYPE;
	v_hiredate emp.hiredate%TYPE;
	v_sal emp.sal%TYPE;
	sql_str VARCHAR2(500);
BEGIN
	sql_str := 'INSERT INTO emp(empno, ename, job, deptno, hiredate, sal)' 
					|| ' VALUES(:1,:2,:3,:4,:5,:6)';
	FOR i IN 1..100 LOOP
		v_empno := Emp_empno_seq.NEXTVAL;
		v_ename := 'HARDING';
		v_job := 'CLERK';
		v_deptno := 10;
		v_hiredate := to_date('01/01/1980','DD/MM/YYYY');
		v_sal := 100;
		EXECUTE IMMEDIATE sql_str 
			USING v_empno, v_ename, v_job, 
					v_deptno, v_hiredate, v_sal;
	END LOOP;	
END;
/

/* Створити таблицю з назвою departments_new, 
Імена колонок – назви підрозділів
Типи колонок - VARCHAR2(10)
*/
DECLARE 
	create_str VARCHAR2(500);
BEGIN
	-- ініціалізація рядка з командою створення таблиці
	create_str := 'CREATE TABLE departments_new2 (';
	FOR emp_rec IN (SELECT dname FROM dept) LOOP
		-- включення до рядка нового імені колонки 
		-- як назви підрозділу та типом VARCHAR2(10)
		create_str := create_str || emp_rec.dname 
					|| ' VARCHAR2(10),';
	END LOOP;
	create_str := RTRIM(create_str,',') || ')';
	DBMS_OUTPUT.PUT_LINE(create_str);
	EXECUTE IMMEDIATE create_str;
END;
/

-- перевірити наявність таблиці
descr departments_new

/* Створити таблицю з назвою departments_new, 
Імена колонок – назви підрозділів
Типи колонок - VARCHAR2(10)
Якщо таблиця вже існує, попередньо її видалити
*/

-- 1 Перший варіант рішення
DECLARE 
	create_str VARCHAR2(500);
	v_count NUMBER;
	CURSOR c1 IS
		SELECT dname FROM dept;
BEGIN
	-- перевірити наявність таблиці
	SELECT COUNT(*) INTO v_count 
		FROM all_tables 
		WHERE table_name= upper('departments_new') AND 
				owner=upper('system');
	IF v_count != 0 THEN
		EXECUTE IMMEDIATE 'DROP TABLE departments_new';
	END IF;
	-- ініціалізація рядка з командою створення таблиці
	create_str := 'CREATE TABLE departments_new (';
	FOR emp_rec IN c1 LOOP
		-- включення до рядка нового імені колонки
		-- як назви підрозділу та типом VARCHAR2(10)
		create_str := create_str || emp_rec.dname || ' VARCHAR2(10),';
	END LOOP;
	-- завершення оформлення команди з попереднім виключенням зайвої коми
	create_str := RTRIM(create_str,',') || ')';
	EXECUTE IMMEDIATE create_str;
END;
/

-- 2 Другий варіант рішення
DECLARE 
	create_str VARCHAR2(500);
	v_count NUMBER;
	CURSOR c1 IS
		SELECT dname FROM dept;
BEGIN
	-- перевірити наявність таблиці
	SELECT 1 INTO v_count
		FROM all_tables 
		WHERE table_name= upper('departments_new') AND 
				owner=upper('system');
	IF SQL%FOUND THEN
		EXECUTE IMMEDIATE 'DROP TABLE departments_new';
	END IF;
	-- ініціалізація рядка з командою створення таблиці
	create_str := 'CREATE TABLE departments_new (';
	FOR emp_rec IN c1 LOOP
		-- включення до рядка нового імені колонки
		-- як назви підрозділу та типом VARCHAR2(10)
		create_str := create_str || emp_rec.dname || ' VARCHAR2(10),';
	END LOOP;
	-- завершення оформлення команди з попереднім виключенням зайвої коми
	create_str := RTRIM(create_str,',') || ')';
	EXECUTE IMMEDIATE create_str;
END;
/

-- 3 Третій варіант рішення
DECLARE 
	create_str VARCHAR2(500);
	v_count NUMBER;
	CURSOR c1 IS
		SELECT dname FROM;
BEGIN
	BEGIN
		-- спроба видалення таблиці
		EXECUTE IMMEDIATE 'DROP TABLE departments_new';
	EXCEPTION
		-- якщо таблиця була відсутня, спрацьовує помилка
		WHEN OTHERS THEN
			-- ігнорування помилки
			NULL;
	END;
	-- ініціалізація рядка з командою створення таблиці
	create_str := 'CREATE TABLE departments_new (';
	FOR emp_rec IN c1 LOOP
		-- включення до рядка нового імені колонки 
		-- як назви підрозділу та типом VARCHAR2(10)
		create_str := create_str || emp_rec.dname || ' VARCHAR2(10),';
	END LOOP;
	-- завершення оформлення команди з попереднім виключенням зайвої коми
	create_str := RTRIM(create_str,',') || ')';
	EXECUTE IMMEDIATE create_str;
END;
/

-- Приклад оголошення курсору з динамічним запитом.
-- Використовується тип курсорної змінної - SYS_REFCURSOR
DECLARE
	salary_total integer := 0;
	TYPE emp_rec_type IS RECORD 
			( ename emp.ename%TYPE, sal emp.sal%TYPE );
	emp_rec emp_rec_type;
	/* оголошення змінної слабкого курсорного типу  */
	emp_list_cursor SYS_REFCURSOR;
	table_name varchar2(20) := 'emp';
BEGIN
	DBMS_OUTPUT.PUT_LINE('EmpName   Salary');
	/* відкриття курсору з динамічним запитом  */
	OPEN emp_list_cursor FOR 'SELECT ename, sal FROM ' || table_name;
	FETCH emp_list_cursor INTO emp_rec;
	WHILE emp_list_cursor%FOUND LOOP
		salary_total := salary_total + emp_rec.sal;
		DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.ename,10,' ') || emp_rec.sal);
		FETCH emp_list_cursor INTO emp_rec;
	END LOOP;
	CLOSE emp_list_cursor;
	DBMS_OUTPUT.PUT_LINE('Salary Total = ' || salary_total); 
END;
/

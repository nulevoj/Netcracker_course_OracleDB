/* 
Лекція "Основи мовних конструкцій мови PL/SQL СУБД Oracle"
Приклади команд.
*/

set linesize 120
set pagesize 60



/* Структура блоку PL/SQL 
DECLARE – необов'язкова секція 
	– змінні, курсори, виключення, що визначаються користувачем 
BEGIN – обов'язкове ключове слово
	– Вирази SQL
	– Вирази PL/SQL
EXCEPTION – необов'язкова секція
	– Дії, які виконуються при виникненні помилок
END; – обов'язкове ключове слово
*/

/* Типи блоків
1) Анонімний блок PL/SQL
[DECLARE]
BEGIN
  --statements
[EXCEPTION]
END;

2) Процедура
PROCEDURE name
IS
BEGIN
  --statements
[EXCEPTION]
END;

3) Функція
FUNCTION name
RETURN datatype
IS
BEGIN
  --statements
  RETURN value;
[EXCEPTION]
END;
*/

/* 
Приклад програми "Hello World!" на мові Ada 
*/

with Text_IO; 
use Text_IO;
procedure hello is
begin
   Text_IO.Put_Line("Hello world!");
end hello;

/* 
PL/SQL працює на сервері і за замовчуванням 
не може надсилати будь-які повідомлення до клієнта 
Необхідно встановити режим пересилання повідомлень
від сервера до клієнту:
1) в sqlplus використовується команда "SET SERVEROUTPUT ON"
2) в sql developer використовується пункт меню "View"->"DBMS Output" 
	з подальшим додаванням у секції "DBMS Output" вікна налагодження
	через символ "+"

*/

/*
Виведення налагоджувальних повідомлень у PL/SQL 
Використання пакетної процедури
DBMS_OUTPUT.Put_Line(string VARCHAR2) - виведення на екран рядка 	
	з переведенням на новий рядок,
де  string - рядок повідомлення, за замовчуванням, максимальної довжини 32767 байт
*/

SET SERVEROUTPUT ON

BEGIN
	Dbms_Output.Put_Line('Hello world!');
END;
/

/* Типи змінних
1) Змінні PL/SQL 
	– Скалярні
	– Посилальні
	– Складені
	– LOB (large objects)
2) Змінні не-PL/SQL 
	– Зв'язані та хост змінні

 Синтаксис опису змінних PL/SQL
identifier [CONSTANT] datatype [NOT NULL]   
		[:= | DEFAULT expr];

 Правила іменування
1) Дві змінні можуть мати одне й те саме ім'я, 
		якщо вони розташовані у різних блоках.
2) Ім'я змінної не повинно співпадати з іменами стовпців таблиці, 
		що використовується в блоці.
*/

/* Приклади привласнення значень змінним
1) Задати визначену дату найму для нового співробітника:
	v_hiredate := '31-DEC-98'; 
2) Задати ім'я співробітника   = 'Maduro.' 
	v_ename := 'Maduro';
*/

/* Основні скалярні типи даних
VARCHAR2 (maximum_length)
NUMBER [(precision, scale)]
DATE
CHAR [(maximum_length)]
LONG
LONG RAW
BOOLEAN
BINARY_INTEGER или PLS_INTEGER – 4-х байтне ціле зі знаком,
		що забезпечує більш компактне зберігання та 
		покращену швидкість обробки ніж NUMBER

 Основні відмінності у розмірностях типів даних
Data Type	Max Size in PL/SQL		Max Size in SQL
CHAR		32,767 bytes			2,000 bytes
NCHAR		32,767 bytes			2,000 bytes
VARCHAR2	32,767 bytes			4,000 bytes
NVARCHAR2	32,767 bytes			4,000 bytes
*/

/* Приклад оголошення змінних,
які відповідають іменам колонок таблиці EMP
*/
DECLARE 
	v_empno NUMBER(4); -- N співробітника
	v_ename VARCHAR2(10); -- ім'я співробітника
	v_job VARCHAR2(10); -- посада співробітника
	v_mgr NUMBER(4); -- N начальника співробітника
	v_hiredate DATE; -- дата прийняття на роботу співробітника 
	v_sal FLOAT; -- з/п співробітника
	v_comm FLOAT; -- премія співробітника
	v_deptno NUMBER(2); -- код співробітника
BEGIN
	NULL;
END;
/

/* Посилальні типи даних:
1) змінні, що часто оголошуються, пов'язані з колонками таблиць,
2) тип даних змінних повинен збігатися з типом даних колонки таблиці
3) посилальний тип даних для:
	a) простої змінної;
	b) складеної змінної - PL/SQL-запису;
4) оголошення посилального типу даних для простої змінної:
	ім'я_змінної ім'я_таблиці.ім'я_колонки%TYPE
5) оголошення посилального типу даних для PL/SQL-запису таблиці:
	ім'я_змінної ім'я_таблиці%ROWTYPE
6) оголошення PL/SQL-запису власної структури:
	a) створення нового типу даних:
		TYPE ім'я_типу_запису IS RECORD (
					ім'я_поля_1 тип_поля_1, 
					ім'я_поля_2 тип_поля_2, 
					… );
	b) оголошення PL/SQL-запису:
		ім'я_змінної ім'я_типу_запису

*/

-- Приклад використання простих посилальних типів даних
DECLARE
	v_empno emp.empno%TYPE; 
	v_ename emp.ename%TYPE; 
	v_job emp.job%TYPE; 
	v_mgr emp.mgr%TYPE; 
	v_hiredate emp.hiredate%TYPE; 
	v_sal emp.sal%TYPE; 
	v_comm emp.comm%TYPE; 
	v_deptno emp.deptno%TYPE; 
	v_min_sal v_sal%TYPE := 500;
	v_max_sal v_sal%TYPE := 7000;
BEGIN
	DBMS_OUTPUT.PUT_LINE('v_min_sal=' || v_min_sal);
	DBMS_OUTPUT.PUT_LINE('v_max_sal=' || v_max_sal);
END;
/

-- Приклад використання PL/SQL-записів таблиці.
-- Ефект проявляється, якщо застосовується більшість колонок таблиці
DECLARE
	v_emp emp%ROWTYPE; 
BEGIN
	v_emp.empno := Emp_empno_seq.NEXTVAL;
	v_emp.ename := 'OD'; 
	v_emp.job := 'STUDENT'; 
	v_emp.mgr := 7839; 
	v_emp.hiredate := TO_DATE('22/11/2022','DD/MM/YYYY'); 
	v_emp.sal := 100; 
	v_emp.comm := NULL; 
	v_emp.deptno := 10; 	
	DBMS_OUTPUT.PUT_LINE('v_empno=' || v_emp.empno);
END;
/

/*SQL функції PL/SQL
Доступні:
	- Однорядкові числові 
	- Однорядкові символьні
	- Перетворення даних
	- Дата
Недоступні:
	- GREATEST 
	- LEAST
	- DECODE
	- Групові функції
*/

/* Вкладеність PL/SQL-блоків та видимість змінних
1) Вирази  можуть  бути  вкладені  всюди,  
	де  дозволені  виконувані  вирази.
2) Вкладені  блоки  стають  виразами.
3) Секція  винятків  може  містити   вкладені  блоки.
4) Область  видимості  об'єкта – частина  програми,  
	з  якої  можна  посилатися  на  об'єкт.

Ідентифікатор є видимим у областях, у яких ви можете на нього послатися, 
	не використовуючи мітку блоку:
	- Блок може переглядати блок, що заключає його.
	- Блок не може переглядати розміщені в ньому блоки.
*/

-- Вкладеність PL/SQL-блоків та видимість змінних
DECLARE
	V_MESSAGE VARCHAR2(255) := ' eligible for commission';
BEGIN 
	DECLARE
		V_MESSAGE VARCHAR2(255) := ' NOT eligible for commission';
	BEGIN
		V_MESSAGE := 'CLERK' || V_MESSAGE;
		DBMS_OUTPUT.PUT_LINE(V_MESSAGE);
	END;
    V_MESSAGE := 'SALESMAN' || V_MESSAGE;
	DBMS_OUTPUT.PUT_LINE(V_MESSAGE);
END;
/

/* SQL-вирази  в  PL/SQL:
- Виводити ряди даних із БД, використовуючи команду SELECT. 
	Тільки один набір даних може бути повернутий.
- Змінювати структуру рядів у БД, використовуючи команди DML.
- Керувати транзакціями за допомогою команд COMMIT,  ROLLBACK   та   SAVEPOINT.
- Визначати відповідь DML-операцій через приховані курсори.
*/

/* Ініціалізація змінних через вибірку даних з таблиць БД
SELECT select_list
INTO	 {variable_name[, variable_name]... | record_name}   
FROM	 table
WHERE	 condition;

Допускається тільки однорядкова відповідь на SELECT-запит.
*/

-- Вивести дані по локації знаходження заданого підрозділу
DECLARE
	v_dname DEPT.DNAME%TYPE;
	v_loc LOC%ROWTYPE;
BEGIN
	v_dname := 'SALES';
	SELECT l.locno,l.lname INTO v_loc
	FROM dept d, loc l
	WHERE 	dname = v_dname
			AND d.locno = l.locno;
	DBMS_OUTPUT.PUT_LINE(
	                'locno=' 
	                || v_loc.locno 
					|| ' lname=' 
					|| v_loc.lname
				);
END;
/

-- Вивести результат агрегації даних за одним підрозділом
DECLARE
	v_sum_sal emp.sal%TYPE;
	v_deptno NUMBER NOT NULL := 10;
BEGIN
	SELECT SUM(sal) INTO v_sum_sal
	FROM emp
	WHERE deptno = v_deptno;
	DBMS_OUTPUT.PUT_LINE('v_sum_sal=' || v_sum_sal);
END;
/

-- Спроба вивести результат агрегації даних за локацією підрозділу
DECLARE
	v_sum_sal emp.sal%TYPE;
BEGIN
	SELECT SUM(sal) INTO v_sum_sal
	FROM emp
	GROUP BY deptno;
	DBMS_OUTPUT.PUT_LINE('v_sum_sal=' || v_sum_sal);
END;
/
/* Результат виконання:
ERROR at line 1:
ORA-01422: exact fetch returns more than requested number of rows
*/

/*
Використання DML-команд:
- синтаксис не змінюється;
- залишається можливість управління транзакціями командами  COMMIT, ROLLBACK

*/

-- Додати  інформацію  про  нового  співробітника  в  таблицю  emp
DECLARE
	v_empno emp.empno%TYPE;
BEGIN
	v_empno := Emp_empno_seq.NEXTVAL;
	INSERT INTO emp(empno, ename, job,deptno,hiredate,sal)
	VALUES(v_empno, 
			'HARDING', 'CLERK', 10,
			to_date('01/01/1980','DD/MM/YYYY'),100);
END;
/

-- Збільшити  зарплату  всім  співробітникам,  
-- які працюють  аналітиками
DECLARE
	v_sal_increase emp.sal%TYPE := 2000;
BEGIN
	UPDATE emp SET sal = sal + v_sal_increase
		WHERE job = 'ANALYST';
END;
/

-- Видалити  рядки,  які відносяться до підрозділу № 10
DECLARE
	v_deptno emp.deptno%TYPE := 10;
BEGIN
	DELETE FROM emp
		WHERE deptno = v_deptno;
END;
/

/* Приклад використання керуючої конструкції.
Використовуються змінні пакета DBMS_DB_VERSION:
DBMS_DB_VERSION.VERSION
DBMS_DB_VERSION.RELEASE
*/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Version=' || DBMS_DB_VERSION.VERSION);
	DBMS_OUTPUT.PUT_LINE('Release=' || DBMS_DB_VERSION.RELEASE);
	IF DBMS_DB_VERSION.VERSION >= 12 THEN
		DBMS_OUTPUT.PUT_LINE('You can use OFFSET in SELECT');
	ELSE
		DBMS_OUTPUT.PUT_LINE('You can not use OFFSET in SELECT');
	END IF;
END;
/

/* Управління потоком виконання PL/SQL
Ви можете змінювати послідовність виконання виразів, 
використовуючи умовні вирази IF та циклічні структури управління.
Умовні вирази  IF:
	IF-THEN-END IF
	IF-THEN-ELSE-END IF
	IF-THEN-ELSIF-END IF

Синтаксис
	IF condition THEN
		statements;
	[ELSIF condition THEN 
		statements;]
	[ELSE 
		statements;]
	END IF;
*/

/* Приклад використання керуючої конструкції
*/
DECLARE 
	v_empno emp.empno%TYPE; 
	v_ename emp.ename%TYPE; 
	v_job emp.job%TYPE; 
	v_mgr emp.mgr%TYPE; 
	v_hiredate emp.hiredate%TYPE; 
	v_sal emp.sal%TYPE; 
	v_comm emp.comm%TYPE; 
	v_deptno emp.deptno%TYPE; 
	annual_sal v_sal%TYPE;
BEGIN
	v_empno:= 7839;
	SELECT (sal+NVL(comm,0))*12 INTO annual_sal 
	FROM emp
	WHERE empno = V_empno;
	IF annual_sal > 30000  THEN
		v_job := 'SALESMAN'; 
		v_deptno := 30; 
		v_comm := v_sal * 0.20; 
	ELSIF annual_sal < 10000 THEN
		v_job := 'CLERK'; 
		v_deptno := 40; 
		v_comm := v_sal * 0.10;
	END IF;
	DBMS_OUTPUT.PUT_LINE('v_job=' || v_job);
END;
/

--
SELECT * FROM EMP;
--
ROLLBACK;

/* Управління ітераціями: LOOP вирази
1) Цикли багаторазово повторюють вираз чи послідовність виразів.
2) Існує три типи циклів:
	- Звичайний  цикл
	- Цикл  WHILE
	- Цикл  FOR

Синтаксис
LOOP               			-- delimiter       
  statement1;				-- statements
  . . .
  EXIT [WHEN condition];	-- EXIT statement
END LOOP;					-- delimiter

where:	condition		is a Boolean variable or expression (TRUE, FALSE, or NULL);

*/
-- Приклад використання циклічної конструкції з постумовою
DECLARE
	i number;
BEGIN
	i:=1;
	LOOP
		INSERT INTO emp
					(empno, ename, job, deptno,hiredate,sal)
		VALUES(	Emp_empno_seq.NEXTVAL, 
				'HARDING ' || TO_CHAR(i), 
				'CLERK', 10,
				to_date(TO_CHAR(i) || '/01/1980','DD/MM/YYYY'),
				100);
		i := i + 1;
		EXIT WHEN i > 10;
	END LOOP;	
END;
/

SELECT * FROM EMP;
ROLLBACK;

/* Циклічна конструкція з передумовою - цикл WHILE
Використовуйте цикл WHILE, щоб повторювати вирази, поки умова дорівнює TRUE.

Синтаксис
WHILE condition LOOP
  statement1;
  statement2;
  . . .
END LOOP;

*/

-- Приклад використання циклічної конструкції з передумовою
DECLARE
	i number;
BEGIN
	i :=1;
	WHILE i <= 10 LOOP
		INSERT INTO emp
				(empno, ename, job, deptno,
					hiredate,sal)
			VALUES(
				Emp_empno_seq.NEXTVAL, 'HARDING', 
				'CLERK', 10,
				to_date('01/01/1980','DD/MM/YYYY'),
				100);
		i := i + 1;
	END LOOP;	
END;
/

/* Циклічна конструкція з параметром - цикл FOR
1) Використовуйте цикл FOR, щоб спростити перевірку кількості ітерацій.
2) Не оголошуйте індекс, він оголошується неявно;
3) Не привласнюйте значення лічильнику

Синтаксис
FOR counter in [REVERSE] 
    lower_bound..upper_bound LOOP  
  statement1;
  statement2;
  . . .
END LOOP;

*/

-- Приклад використання циклічної конструкції з параметром
BEGIN
	FOR i IN 1..10 LOOP
		INSERT INTO emp
					(empno, ename, job, 
					deptno,hiredate,sal)
			VALUES(
					Emp_empno_seq.NEXTVAL, 
					'HARDING', 'CLERK', 10,
					to_date('01/01/1980','DD/MM/YYYY'),
					100);
	END LOOP;	
END;
/

--
SELECT * FROM EMP;
--
ROLLBACK;

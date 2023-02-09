/* 
Лекція "Колекції у мові PL/SQL СУБД Oracle"
Приклади.
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

/* 
Мова PL/SQL створювалася для швидкої обробки даних з реляційної БД.
Але в подальшому, наприклад, 
	з приходом об'єктно-реляційних моделей обробки даних
	з'явилась необхідність працювати із масивами даних, 
	або в ООП - колекціями.
Історично було запропоновано три типи колекцій:
1) Varray - масиви змінної довжини;
2) Nested table - вкладені таблиці;
3) Associative array - асоціативні масиви (індексовані таблиці)
*/

/* Синтаксична конструкція визначення типу VARRAY-колекції:
TYPE ім'я_типу IS 
{ VARRAY | VARYING ARRAY } (розмір) OF тип_елементу [NOT NULL]; 
де розмір - максимальна кількість елементів, не може бути змінено;
	тип_елементу - будь-який тип даних PL/SQL, 
	крім VARRAY, TABLE, BOOLEAN, LONG, REF CURSOR.
Ініціалізація колекції:
	ім'я_змінної := ім'я_типу( значення, … )
*/

/* Приклад використання Varray-колекції
*/

DECLARE
	-- Створення Varray-колекції із трьох елементів
	TYPE rec_var1 IS VARRAY (3) OF NUMBER(4);
	-- Створення Varray-колекції із 4-х елементів типу rec_var1
	TYPE rec_var2 IS VARRAY (4) OF rec_var1;
	-- об'ява змінних нового типу Varray-колекцій
	r1 rec_var1; 
	r2 rec_var2;
BEGIN
	/* Ініціалізація Varray-колекції із трьох елементів */
	r1 := rec_var1(212, 12, 333);
	/* Ініціалізація Varray-колекції із 4-х елементів типу rec_var1 */
	r2 := rec_var2(
					rec_var1(1, 100, 32),
					rec_var1(2, 110, 300),
					rec_var1(3, 120, 98),
					rec_var1(3, 120, 98)
          );
END;
/	

/* Функції керування елементами колекції:
COUNT - ф-ція повертає реальну кількість елементів колекції;
LIMIT - ф-ція повертає розмір varray-масиву

Виключення:
SUBSCRIPT_BEYOND_COUNT - доступ до невизначених елементів колекції
SUBSCRIPT_OUTSIDE_LIMIT - доступ за межі колекції
*/

/* Приклад неправильного використання функції LIMIT */
DECLARE
	TYPE rec_var1 IS VARRAY (5) OF NUMBER(4);
	r1 rec_var1; 
BEGIN
	r1 := rec_var1(212, 12, 333);
	DBMS_OUTPUT.PUT_LINE('r1:=(');
	FOR i IN 1..r1.LIMIT LOOP
	   DBMS_OUTPUT.PUT_LINE(r1(i)); 
    END LOOP; 
	DBMS_OUTPUT.PUT_LINE(');');
END;
/	
/* Очікуваний результат:
ERROR at line 1:
ORA-06533: Subscript beyond count
ORA-06512: at line 8
*/

/* Контроль помилки через виключення SUBSCRIPT_BEYOND_COUNT */
DECLARE
	TYPE rec_var1 IS VARRAY (5) OF NUMBER(4);
	r1 rec_var1; 
BEGIN
	r1 := rec_var1(212, 12, 333);
	DBMS_OUTPUT.PUT_LINE('r1:=(');
	FOR i IN 1..r1.LIMIT LOOP
	   DBMS_OUTPUT.PUT_LINE(r1(i)); 
    END LOOP; 
	DBMS_OUTPUT.PUT_LINE(');');
EXCEPTION
    WHEN SUBSCRIPT_BEYOND_COUNT THEN
	    DBMS_OUTPUT.PUT_LINE('Error access to undefined element');
END;
/	

/* Приклад правильного використання функції COUNT */
DECLARE
	TYPE rec_var1 IS VARRAY (5) OF NUMBER(4);
	r1 rec_var1; 
BEGIN
	r1 := rec_var1(212, 12, 333);
	DBMS_OUTPUT.PUT_LINE('r1:=(');
	FOR i IN 1..r1.COUNT LOOP
	   DBMS_OUTPUT.PUT_LINE(r1(i)); 
    END LOOP; 
	DBMS_OUTPUT.PUT_LINE(');');
END;
/	

/* Синтаксична конструкція визначення типу "Nested Table"-колекції):
TYPE ім'я_типу IS TABLE OF тип_елементу [NOT NULL]; 
	де тип_елементу  - будь-який тип PL/SQL, 
	крім VARRAY, TABLE, BOOLEAN, LONG, REF CURSOR.
Вкладена таблиця - це одновимірний масив з індексами цілого типу 
	в діапазоні від 1 до 2147483647. 
Вкладена таблиця може динамічно збільшуватися.
*/	  

/* Приклад створення "Nested table"-колекції 
*/

DECLARE
  /* Створення "Nested table"-колекції */
  TYPE rec_table IS TABLE OF VARCHAR2(10);
  tab1 rec_table;
BEGIN
  /* Ініціалізації колекції */
  tab1 := rec_table('elem1', 'elem2', 'elem3');
  /* перегляд елементів колекції у циклі */
  DBMS_OUTPUT.PUT_LINE('Elem list:'); 
  FOR i IN 1..tab1.COUNT LOOP
	DBMS_OUTPUT.PUT_LINE(tab1(i));  
  END LOOP;    
END; 
/

/* Додаткові функції керування елементами колекції:
LIMIT - ф-ція повертає розмір чи NULL;
EXISTS(n) - Якщо n-ий елемент колекції існує, функція повертає TRUE;
PRIOR(n) - ф-ція повертає індекс елемента, що передує зазначеному параметру n. 
		Якщо елемент немає, то повертається NULL
NEXT(n)	- ф-ція повертає індекс елемента, що йде за вказаним параметром n. 
		Якщо елемент немає, то повертається NULL
DELETE(m,n)	- процедура видаляє елементи із вкладеної чи індексованої таблиці. 
		Якщо параметри не задані, то видаляються всі елементи, 
		інакше видаляється n-ий елемент вкладеної таблиці, а якщо задано 
		обидва параметри, видаляються всі елементи в діапазоні від n до m
FIRST, LAST	- ф-ції повертають найменший та найбільший індекс елементів. 
		Для порожньої вкладеної таблиці обидві функції повертають значення NULL. 
		Для Varray-масивів виклик функції FIRST завжди повертає значення 1
EXTEND(n,i)	- ф-ція збільшує розмір вкладеної чи індексованої таблиці. 
		Якщо параметри не задані, то додається один null-елемент, 
		і якщо вказано лише параметр n, то додаються n null-элементов. 
		Якщо встановлено обидва параметри, то додаються n елементів, 
		які є копіями i-го елемента.
TRIM(n)	- ф-ція видаляє n останніх елементів вкладеної або індексованої таблиці. 
		Якщо параметри не вказані, видаляється один останній елемент, 
		а при заданні параметра видаляються n останніх елементів колекції.
*/

/* Приклад створення "Nested table"-колекції 
та керування елементами
*/
DECLARE
  /* Створення "Nested table"-колекції */
  TYPE rec_table IS TABLE OF VARCHAR2(10);
  tab1 rec_table;
BEGIN
  /* Ініціалізації колекції */
  tab1 := rec_table('elem1', 'elem2', 'elem3');
  /* перегляд елементів колекції у циклі */
  DBMS_OUTPUT.PUT_LINE('Elem list:'); 
  FOR i IN 1..tab1.COUNT LOOP
	DBMS_OUTPUT.PUT_LINE(tab1(i));  
  END LOOP; 
  /* Видалення останнього (3-го) елемента */
  tab1.DELETE(tab1.LAST);
  /* Видалення двох останніх елементів: (2-го та 3-го) */
  tab1.TRIM(tab1.COUNT);
  DBMS_OUTPUT.PUT_LINE('Elem list:'); 
  FOR i IN 1..tab1.COUNT LOOP
	DBMS_OUTPUT.PUT_LINE(tab1(i));  
  END LOOP;    
END; 
/

/* Приклад Використання "Nested table"-колекції
з динамічною зміною розміру
*/
DECLARE
  /* Створення колекції типу "Вкладена таблиця" */
  TYPE rec_table IS TABLE OF VARCHAR2(10);
  /* Ініціалізація змінної порожньої колекції */
  tab1 rec_table := rec_table();
BEGIN
  /* Додавання до колекції 3-х елементів */
  tab1.EXTEND(3);
  tab1(1) := 'elem1'; tab1(2) := 'elem2'; tab1(3) := 'elem3'; 
  /* перегляд елементів колекції у циклі */
  DBMS_OUTPUT.PUT_LINE('Elem list:'); 
  FOR i IN 1..tab1.COUNT LOOP
	DBMS_OUTPUT.PUT_LINE(tab1(i));  
  END LOOP;    
END; 
/

/* Синтаксична конструкція визначення типу (Associative array): 
TYPE ім'я_типу 
IS 
	TABLE OF тип_елементу [NOT NULL] 
	INDEX BY тип_ключа; 

де тип_елемента - будь-який тип PL/SQL, 
		крім VARRAY, TABLE, BOOLEAN, LONG, REF CURSOR
   тип_ключа - будь-який тип PL/SQL, 
		крім VARRAY, TABLE, BOOLEAN, LONG, REF CURSOR
Індексована таблиця - це варіант вкладеної таблиці, 
	в якій елементами є пара <ключ, значення>
*/

-- Приклад використання асоціативної таблиці
DECLARE
  /* Створення колекції типу "асоціативна таблиця"
   з елементами, що зберігають зарплати співробітників,
   для яких ключем є ім'я співробітника */
   TYPE salary IS TABLE OF NUMBER INDEX BY VARCHAR2(20);
   salary_list salary; name VARCHAR2(20);
BEGIN
   /* Додати три елементи до колекції */
   salary_list('Rajnish') := 62000;
   salary_list('Minakshi') := 75000;
   salary_list('Martin') := 100000;
   /* Перехід до 1-го елемента колекції за ключем */
   name := salary_list.FIRST;
   WHILE name IS NOT null LOOP
      DBMS_OUTPUT.PUT_LINE('Salary of ' || name || ' is ' || 
								TO_CHAR(salary_list(name)));
	  /* Перехід до наступного елемента колекції за ключем */
      name := salary_list.NEXT(name);
   END LOOP;
END;
/

/* Рекомендації із використання типів кодлекцій:
Varray-колекції корисні коли:
	- відомо максимальну кількість елементів;
	- доступ до елементів виконується послідовно;
	- невеликий розмір колекцій.
При перенесенні бізнес-логіки з Java в PL/SQL:
	- Arrays перетворюються на Varrays;
	- Sets перетворюються на Nested tables;
	- Hash tables та інші види невпорядкованих пошукових таблиць 
		перетворюються на Associative Arrays.
*/

/* Визначення часу виконання SQL-запитів:
1-й варіант - груба оцінка через
встановлення режиму утиліти SQLPlus отримання часу виконання запиту
SET TIMING ON
Формат часу: години:хвилини:секунди:сантисекунди (десяті секунди)
*/

SET TIMING ON

BEGIN
	FOR i IN 1..1000 LOOP
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

ROLLBACK;

/*  2-й варіант - оцінка з точністю до сантисекунди
визначення часу виконання запиту
через функцію DBMS_UTILITY.get_time 
отримання часу в сотих секунди 
*/

DECLARE
	t1 INTEGER; -- момент часу початку виконання запиту
	t2 INTEGER; -- момент часу завершення виконання запиту
	delta INTEGER; -- час виконання запиту
BEGIN
	-- отримання моменту часу початку процесу
	t1 := DBMS_UTILITY.get_time;
	FOR i IN 1..1000 LOOP
		INSERT INTO emp
					(empno, ename, job, 
					deptno,hiredate,sal)
			VALUES(
					Emp_empno_seq.NEXTVAL, 
					'HARDING', 'CLERK', 10,
					to_date('01/01/1980','DD/MM/YYYY'),
					100);
	END LOOP;
	-- отримання моменту часу завершення процесу
	t2 := DBMS_UTILITY.get_time;
	-- визначення різниці моментів часу
	delta := t2 - t1;
	DBMS_OUTPUT.PUT_LINE('Time (centisec) = ' || delta);
END;
/

ROLLBACK;

/*  3-й варіант - оцінка з точністю до мілісекунди
визначення часу виконання запиту
через системну змінну SYSTIMESTAMP
*/

DECLARE
	t1 TIMESTAMP; -- момент часу початку виконання запиту
	t2 TIMESTAMP; -- момент часу завершення виконання запиту
	delta INTEGER; -- час виконання запиту
BEGIN
	-- отримання моменту часу початку процесу
	t1 := SYSTIMESTAMP;
	-- виконання команд
	-- ...
	-- отримання моменту часу завершення процесу
	t2 := SYSTIMESTAMP;	
	-- визначення різниці через перетворення форматів дата->рядок->ціле
	delta := TO_NUMBER(TO_CHAR(t2, 'HHMISS.FF3'),'999999.999') - 
				TO_NUMBER(TO_CHAR(t1, 'HHMISS.FF3'),'999999.999');
				
END;
/

-- Приклад визначення часу виконання запиту

DECLARE
	t1 TIMESTAMP;
	t2 TIMESTAMP;
	delta NUMBER;
BEGIN
	t1 := SYSTIMESTAMP;
	FOR i IN 1..1000 LOOP
		INSERT INTO emp
					(empno, ename, job, 
					deptno,hiredate,sal)
			VALUES(
					Emp_empno_seq.NEXTVAL, 
					'HARDING', 'CLERK', 10,
					to_date('01/01/1980','DD/MM/YYYY'),
					100);
	END LOOP;
	t2 := SYSTIMESTAMP;
	delta := TO_NUMBER(TO_CHAR(t2, 'HHMISS.FF3'),'999999.999') - 
			TO_NUMBER(TO_CHAR(t1, 'HHMISS.FF3'),'999999.999');
	DBMS_OUTPUT.PUT_LINE('Time (millisec) = ' || delta);
END;
/

ROLLBACK;

/* Пакетна обробка даних у PL/SQL забезпечується:
	- оператором FORALL пакетної обробки DML-операцій;
	- оператором BULK COLLECT пакетної обробки колекцій
*/

/* Оператор FORALL
Ще раз про архітектуру PL/SQL:
1) SQL-команди виконуються модулем-виконавцем SQL-команд;
2) PL/SQL-команди виконуються модулем-виконавцем PL/SQL;
3) якщо в блок PL/SQL включено SQL-команди, 
	СУБД виконує перемикання між вказаними виконавцями;
4) таке перемикання відоме як перемикання контексту як приклад
	перемикання процесору під час квазіпаралельного виконання процесів.
5) процес перемикання контексту потребує додаткового часу;
6) перемикання контексту виконується і під час 
	виклику PL/SQL-функцій у SQL-запиті;
7) коли SQL-команд багато, перемикання контексту 
	суттєво впливають на час виконання модуля PL/SQL.
	
FORALL-оператор - це не оператор циклу, 
	а вказівка виконавцю PL/SQL 
	виконувати всі операції в одному пакеті
	за одне перемикання контексту на SQL-виконавець;

Синтаксична конструкція:
FORALL змінна IN визначення_діапазону_для_колекції
*/

-- Приклад пакетної обробки з оператором FORALL
DECLARE
   TYPE NumList IS VARRAY(20) OF NUMBER;
   depts NumList := NumList(10, 20, 30);  
BEGIN
   /* видалення множини записів з отриманням
   діапазону видалення з колекції */
   FORALL i IN depts.FIRST..depts.LAST
      DELETE FROM emp WHERE deptno = depts(i);
END;
/

ROLLBACK;

/* Порівняння часу виконання двома способами: 
1) FOR-цикл
2) FORALL-оператор
*/

-- Створити дві таблиці
DROP TABLE emp1;
DROP TABLE emp2;
CREATE TABLE emp1 (empno INTEGER, ename VARCHAR2(15));
CREATE TABLE emp2 (empno INTEGER, ename VARCHAR2(15));

/* Провести експеримент із заповнення двох таблиць 
-- двома способами : FOR і FORALL.
-- Використовується функція DBMS_UTILITY.get_time отримання часу в сотих секунди 
*/

DECLARE
  TYPE NumTab IS TABLE OF emp.empno%TYPE INDEX BY PLS_INTEGER;
  TYPE NameTab IS TABLE OF emp.ename%TYPE INDEX BY PLS_INTEGER;
  empnos  NumTab; enames NameTab;
  iterations CONSTANT PLS_INTEGER := 5000;
  t1 INTEGER; t2 INTEGER; delta1 INTEGER; delta2 INTEGER;
BEGIN
  FOR j IN 1..iterations LOOP
     empnos(j) := j; enames(j) := 'Iv-' || TO_CHAR(j);
  END LOOP;
  t1 := DBMS_UTILITY.get_time;
  FOR i IN 1..iterations LOOP
     INSERT INTO emp1 VALUES (empnos(i), enames(i));
  END LOOP;
  t2 := DBMS_UTILITY.get_time;
  delta1 := t2 - t1;
  t1 := DBMS_UTILITY.get_time;
  FORALL i IN 1..iterations
     INSERT INTO emp2 VALUES (empnos(i), enames(i));
  t2 := DBMS_UTILITY.get_time;
  delta2 := t2 - t1;
  DBMS_OUTPUT.PUT_LINE('Execution time (sec)');
  DBMS_OUTPUT.PUT_LINE('-------------------------------');
  DBMS_OUTPUT.PUT_LINE('FOR-loop: ' || TO_CHAR((delta1)/100));
  DBMS_OUTPUT.PUT_LINE('FORALL-operator:   ' || TO_CHAR((delta2)/100));
  DBMS_OUTPUT.PUT_LINE('-------------------------------');
  BEGIN
      /* якщо get_time < 0.01, delta2 = 0 */
	  DBMS_OUTPUT.PUT_LINE('For FORALL-operator time > ' || 
								TO_CHAR(ROUND(delta1/delta2)) || ' times' );
  EXCEPTION
		WHEN ZERO_DIVIDE THEN 
			DBMS_OUTPUT.PUT_LINE('For FORALL-operators - more times!!!');
  END;
  COMMIT;
END;
/

/* Пакетна обробка з оператором BULK COLLECT:
1) якщо SELECT-запит отримає багато рядків, 
рекомендується результат зразу зберігати у вигляді коллекції
2) зберігання відбувається швидше ніж робота з курсором
3) оператор BULK COLLECT використовується в операціях та частинах операцій: 
SELECT INTO,  
FETCH INTO,
RETURNING INTO
*/

-- Приклад пакетної обробки SELECT-операції з оператором BULK COLLECT
DECLARE
   TYPE Employee IS TABLE OF emp%ROWTYPE;
   emp_list Employee;
BEGIN
  SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno
     BULK COLLECT INTO emp_list FROM emp;
  DBMS_OUTPUT.PUT_LINE('Employee list:');
  FOR i IN emp_list.FIRST .. emp_list.LAST
       LOOP
         DBMS_OUTPUT.PUT_LINE(emp_list(i).empno || ':' || 
		 emp_list(i).ename || ':' || emp_list(i).ename || ':' || 
		 emp_list(i).job || ':' || emp_list(i).mgr || ':' || 
		 emp_list(i).hiredate || ':' || emp_list(i).sal || ':' ||
		 emp_list(i).comm || ':' || emp_list(i).deptno );
       END LOOP;
END;
/

-- Приклад пакетної обробки DML-операції з оператором BULK COLLECT
DECLARE
   TYPE EmpList IS TABLE OF emp%ROWTYPE;
   emp_list EmpList;
BEGIN
   /* видалення записів із збереженням значень колонок у колекції */
   DELETE FROM emp WHERE deptno = 10
      RETURNING empno,ename,job,mgr,hiredate,sal,comm,deptno
	  BULK COLLECT INTO emp_list;
   DBMS_OUTPUT.PUT_LINE('Deleted ' || SQL%ROWCOUNT || ' rows:');
   FOR i IN emp_list.FIRST .. emp_list.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE('Employee #' || emp_list(i).ename);
   END LOOP;
END;
/

ROLLBACK;


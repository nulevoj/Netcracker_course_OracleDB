/* 
Лекція "Обробка виняткових ситуацій у PL/SQL СУБД Oracle"
Приклади команд.
*/

set linesize 2000
set pagesize 60

SET SERVEROUTPUT ON

/* У разі виникнення виняткової ситуації виконання коду зупиняється
	на операторі, який спричинив помилку.
Управління передається тій частині блоку, яка обробляє помилку
	як виняткову ситуацію – виняток.
Якщо блок не містить виконуваної секції, PL/SQL намагається знайти виконувану секцію 
	у включаючому базовому блоці, тобто у блоці, який є
	зовнішнім по відношенню до коду, що спричинив помилку.
*/

/* Секція обробки винятків:
EXCEPTION
  WHEN ім'я_винятку_1
  THEN дії, що вживаються у разі виникнення винятку_1
  WHEN ім'я_винятку_2
  THEN  дії, що вживаються у разі виникнення винятку_2
  WHEN OTHERS
  THEN дії, що вживаються у разі виникнення всіх інших винятків
*/

/* Типи винятків:
1) Системний виняток
	визначено Oracle і зазвичай ініціюється виконуваним ядром PL/SQL,
	що виявив помилку. Одні системні винятки мають імена,
	інші – тільки номери та описи.
2) Іменований виняток
	Оголошується в секції оголошень, а для ініціювання винятку 
	використовується команда
	RAISE ім'я_винятку;
3) Нейменований або анонімний виняток
	не оголошується у секції оголошень, а викликається функцією
	RAISE_APPLICATION_ERROR (code, msg),
		де code - код помилки (від -20999 до -20000),
		msg – рядок з повідомленням про помилку
*/

/* Системні винятки в PL/SQL:
INVALID_NUMBER, VALUE_ERROR – помилка, пов'язана з перетворенням, усіченням
	або перевіркою обмежень числових чи символьних даних
DUP_VAL_ON_INDEX – ініціюється для INSERT або UPDATE під час спроби
	зберегти значення, що повторюються, в стовпцях з обмеженням UNIQUE
NO_DATA _FOUND – Спроба виконати SELECT INTO,
	коли SELECT повертає нульову кількість рядків
TOO_MANY_ROWS – SELECT INTO в PL/SQL повернув більше одного рядка
CURSOR _ALREADY_OPEN – ініціюється при спробі відкрити вже відкритий курсор
INVALID_CURSOR – ініціюється при посиланні на неіснуючий курсор,
	коли відбувається спроба застосувати команду FETCH до відкритого курсора
	або при спробі закрити не відкритий курсор
STORAGE_ERROR – програмі не вистачає системної пам'яті
TIME_OUT_ON_RESOURCE – програма надто довго чекала
	доступності деякого ресурсу
ZERO_DIVIDE – спроба ділення на нуль
PROGRAM_ERROR – Внутрішня помилка. Зазвичай означає,
	що вам потрібно звернутися до служби підтримки Oracle
OTHERS – Всі інші винятки та внутрішні помилки,
	які не охоплюються винятками, визначеними у базовому блоці.
	Використовується в тих випадках, коли ви точно не знаєте,
	який іменований виняток належить обробляти,
	і хочете обробляти будь-які винятки, що збуджуються
*/

-- Спроба отримати результат агрегації даних по локації підрозділу
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

/* Контролює спробу отримати результат агрегації даних
з локації підрозділу.
Використовується виняток "TOO_MANY_ROWS",
коли SELECT INTO повернув більше одного рядка.
*/
DECLARE
	v_sum_sal emp.sal%TYPE;
BEGIN
	SELECT SUM(sal) INTO v_sum_sal
	FROM emp
	GROUP BY deptno;
	DBMS_OUTPUT.PUT_LINE('v_sum_sal=' || v_sum_sal);
EXCEPTION
	WHEN TOO_MANY_ROWS THEN
		DBMS_OUTPUT.PUT_LINE('Only one value is expected');
END;
/
/* Результат виконання:
ERROR at line 1:
ORA-20555: Only one value is expected
*/

-- Спроба отримати неіснуючі дані
DECLARE
	v_dname DEPT.DNAME%TYPE;
	v_loc LOC.LNAME%TYPE;
BEGIN
	v_dname := 'SALES1111';
	SELECT lname INTO v_loc
	FROM dept d, loc l
	WHERE 	dname = v_dname
			AND d.locno = l.locno;
	DBMS_OUTPUT.PUT_LINE('LOC=' || v_loc);
END;
/
/* Результат виконання:
ERROR at line 1:
ORA-01403: no data found
*/

/* Контролює спроби отримати неіснуючі дані.
Використовується виняток "NO_DATA_FOUND",
коли SELECT INTO не повертає рядок.
*/
DECLARE
	v_dname DEPT.DNAME%TYPE;
	v_loc LOC.LNAME%TYPE;
BEGIN
	v_dname := 'SALES1111';
	SELECT lname INTO v_loc
	FROM dept d, loc l
	WHERE 	dname = v_dname
			AND d.locno = l.locno;
	DBMS_OUTPUT.PUT_LINE('LOC=' || v_loc);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Department not found');
END;
/

-- Спроба внести назву підрозділу із існуючим номером
INSERT INTO dept(deptno, dname,locno) 
	VALUES(10, 'SALES',10);
/* Результат виконання:
ERROR at line 1:
ORA-00001: unique constraint (STUDENT.DEPT_PK) violated
*/

/* Контроль спроби внести назву підрозділу
з існуючим номером
*/
BEGIN
	INSERT INTO dept(deptno, dname,locno) 
		VALUES(10, 'SALES',10);
EXCEPTION
	WHEN DUP_VAL_ON_INDEX  THEN
		DBMS_OUTPUT.PUT_LINE('Department number is already exists!');
END;
/

-- Спроба некоректного перетворення даних
SELECT '10qqqqq'*100 FROM dual; 
/* Результат виконання:
ERROR at line 1:
ORA-01722: invalid number
*/

/* Контроль спроби некоректного перетворення даних
*/
DECLARE
	v_comm emp.comm%TYPE;
BEGIN
SELECT 'qqqqq'*100 INTO v_comm FROM dual; 
EXCEPTION
	WHEN INVALID_NUMBER THEN
		DBMS_OUTPUT.PUT_LINE('Incorrect data!');
END;
/

-- Спроба некоректного перетворення даних
DECLARE
	v_comm emp.comm%TYPE;
BEGIN
	v_comm := TO_NUMBER('qqqqq'); 
END;
/

/* Контроль спроби некоректного перетворення даних
*/
DECLARE
	v_comm emp.comm%TYPE;
BEGIN
	v_comm := TO_NUMBER('qqqqq'); 
EXCEPTION
	WHEN VALUE_ERROR THEN
		DBMS_OUTPUT.PUT_LINE('Incorrect data!');
END;
/

-- Спроба некоректного ділення на нуль
DECLARE
	v_comm emp.comm%TYPE;
BEGIN
	v_comm := 100/0;
END;
/
/* Результат виконання:
ERROR at line 1:
ORA-01476: divisor is equal to zero
*/

/* Контроль спроби некоректного ділення на нуль
*/
DECLARE
	v_comm emp.comm%TYPE;
BEGIN
	v_comm := 100/0;
EXCEPTION
	WHEN ZERO_DIVIDE THEN
		DBMS_OUTPUT.PUT_LINE('Incorrect data!');
END;
/

/* Контроль невідомих системних винятків.

Якщо в результаті виконання PL/SQL-коду або SQL-команди
виник невідомий системний виняток,
його можна обробити через системний виняток OTHERS.
При обробці рекомендується використовувати системні змінні:
1) SQLCODE повертає код помилки, 
	який зазвичай збігається з номером помилки ORA
2) SQLERRM повертає текстове повідомлення, що описує помилку

*/

/* Задача 1: забезпечити контроль спроби видалення підрозділу,
в якому є співробітники.
*/

-- Крок 1. Проведення експерименту та аналіз кодів помилки 
DECLARE
	v_deptno dept.deptno%TYPE;
BEGIN
	-- отримати перший номер підрозділу, що попався, 
	-- в якому є співробітники
	SELECT deptno INTO v_deptno FROM dept d
		WHERE EXISTS 
			(SELECT NULL FROM emp e 
				WHERE e.deptno = d.deptno)
		FETCH FIRST 1 ROWS ONLY;
	-- спробувати видалити підрозділ, 
	-- в якому є співробітники
	DELETE FROM dept where deptno = v_deptno;
EXCEPTION WHEN OTHERS THEN 
	DBMS_OUTPUT.PUT_LINE('SQLCODE=' || SQLCODE);
	DBMS_OUTPUT.PUT_LINE('SQLERRM=' || SQLERRM);
END;
/
/* Результат експерименту:
SQLCODE=-2292
SQLERRM=ORA-02292: integrity constraint (STUDENT.EMP_DEPTNO_FK) 
	violated - child record found
*/

-- Крок 2. Впровадження контролю нового системного винятку 
DECLARE
	v_deptno dept.deptno%TYPE;
BEGIN
	-- отримати перший номер підрозділу, що попався, 
	-- в якому є співробітники
	SELECT deptno INTO v_deptno FROM dept d
		WHERE EXISTS 
			(SELECT NULL FROM emp e 
				WHERE e.deptno = d.deptno)
		FETCH FIRST 1 ROWS ONLY;
	-- спробувати видалити підрозділ, 
	-- в якому є співробітники
	DELETE FROM dept where deptno = v_deptno;
EXCEPTION WHEN OTHERS THEN 
	IF SQLCODE = -2292 THEN
		DBMS_OUTPUT.PUT_LINE('In department with deptno=' 
				|| v_deptno 
				|| ' exists employees!');
		DBMS_OUTPUT.PUT_LINE('You can not delete it!');
	END IF;
END;
/


/* Задача 2: забезпечити контроль спроби додавання
нового співробітника до неіснуючого підрозділу.
*/

-- Крок 1. Проведення експерименту та аналіз кодів помилки 
DECLARE
	v_deptno dept.deptno%TYPE;
BEGIN
	-- отримати перший номер неіснуючого підрозділу, що попався
	SELECT deptno INTO v_deptno FROM 
	(SELECT ROWNUM AS deptno
		FROM DUAL CONNECT BY LEVEL <= 
				(SELECT MAX(DEPTNO) FROM DEPT)
	) missing_deptno
	WHERE deptno NOT IN (SELECT DEPTNO FROM DEPT)
	FETCH FIRST 1 ROWS ONLY;
	-- спробувати додати співробітника до неіснуючого підрозділу
	INSERT INTO emp	(empno, ename, deptno)
			VALUES(Emp_empno_seq.NEXTVAL, 'NEW BLACK', v_deptno);
EXCEPTION WHEN OTHERS THEN 
	DBMS_OUTPUT.PUT_LINE('SQLCODE=' || SQLCODE);
	DBMS_OUTPUT.PUT_LINE('SQLERRM=' || SQLERRM);
END;
/
/* Результат експерименту:
SQLCODE=-2291
SQLERRM=ORA-02291: integrity constraint (STUDENT.EMP_DEPTNO_FK) 
	violated - parent key not found
*/

-- Крок 2. Впровадження контролю нового системного винятку
DECLARE
	v_deptno dept.deptno%TYPE;
BEGIN
	-- отримати перший номер неіснуючого підрозділу, що попався
	SELECT deptno INTO v_deptno 
		FROM 
		(SELECT ROWNUM AS deptno
			FROM DUAL CONNECT BY LEVEL <= 
				(SELECT MAX(DEPTNO) FROM DEPT)
		) missing_deptno
		WHERE deptno NOT IN (SELECT DEPTNO FROM DEPT)
		FETCH FIRST 1 ROWS ONLY;
	-- спробувати додати співробітника до неіснуючого підрозділу
	INSERT INTO emp	(empno, ename, deptno)
			VALUES(Emp_empno_seq.NEXTVAL, 'NEW BLACK', v_deptno);
EXCEPTION WHEN OTHERS THEN 
	IF SQLCODE = -2291 THEN
		DBMS_OUTPUT.PUT_LINE('department with deptno=' || v_deptno 
				|| ' NOT EXISTS!');
		DBMS_OUTPUT.PUT_LINE('You can not add this employee!');
	END IF;
END;
/

/* Іменовані винятки:
1) оголошуються у секції оголошень, 
2) для ініціювання винятку використовується команда
	RAISE ім'я_винятку;

*/

-- Приклад використання іменованого винятку
DECLARE
	v_sum_sal emp.sal%TYPE;
	v_deptno NUMBER NOT NULL := 10;
	sum_sal_small exception;
BEGIN
	SELECT SUM(sal) INTO v_sum_sal FROM emp
	WHERE deptno = v_deptno;
	IF v_sum_sal < 10000 THEN 
		RAISE sum_sal_small;
	END IF;
EXCEPTION
	WHEN sum_sal_small THEN  
		DBMS_OUTPUT.PUT_LINE('SUM IS TOO SMALL!');
END;
/

/* Неіменований або анонімний виняток:
1) не оголошується у секції оголошень
2) викликається функцією RAISE_APPLICATION_ERROR (code, msg),
	де code - код помилки (від -20999 до -20000),
	msg – рядок з повідомленням про помилку

Найчастіше використовується для посилення важливості помилки,
замінюючи просте попереджувальне повідомлення про помилку
на реальне повідомлення про помилку з аварійним завершенням
роботи PL/SQL-блоку

*/

-- Приклад розв'язання задачі 2 з використанням неіменованого винятку
DECLARE
	v_deptno dept.deptno%TYPE;
BEGIN
	-- отримати перший номер неіснуючого підрозділу, що попався
	SELECT deptno INTO v_deptno 
		FROM 
		(SELECT ROWNUM AS deptno
			FROM DUAL CONNECT BY LEVEL <= 
				(SELECT MAX(DEPTNO) FROM DEPT)
		) missing_deptno
		WHERE deptno NOT IN (SELECT DEPTNO FROM DEPT)
		FETCH FIRST 1 ROWS ONLY;
	-- спробувати додати співробітника до неіснуючого підрозділу
	INSERT INTO emp	(empno, ename, deptno)
			VALUES(Emp_empno_seq.NEXTVAL, 'NEW BLACK', v_deptno);
EXCEPTION WHEN OTHERS THEN 
	IF SQLCODE = -2291 THEN
		RAISE_APPLICATION_ERROR(-20557,
			'department with deptno=' || v_deptno 
			|| ' NOT EXISTS!' || ' You can not add this employee!');
	END IF;
END;
/

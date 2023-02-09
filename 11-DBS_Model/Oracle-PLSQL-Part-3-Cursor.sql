/* 
Лекція "Використанням курсорів у PL/SQL СУБД Oracle"
Приклади команд.
*/

SET LINESIZE 120
SET PAGESIZE 60

SET SERVEROUTPUT ON

/* Курсор – це приватна робоча область SQL,
що розташовується в ОЗП.
Існує два типи курсорів:
1) неявні курсори - автоматично створюються сервером для:
	- попереднього аналізу SQL-команд;
	- виконання SQL-команд;
	- зберігання частини результату SQL-команд.
2) явні курсори - явно створюються програмістом.

   Поняття курсору:
1) Курсор є спеціальним елементом PL/SQL, з яким зв'язаний 
	SQL-оператор SELECT
2) Використовуючи курсор, можна окремо обробляти 
	кожен рядок результату зв'язаного з ним SQL-оператора
3) Курсор оголошується в розділі оголошень базового блоку
4) Він відкривається командою OPEN, 
	а вибірка рядків здійснюється за допомогою FETCH

   Порівняння явних та неявних курсорів:
- Неявний курсор працює тільки з одним рядком даних, тому в тих випадках,
	коли зв'язаний з курсором оператор може повертати 
	більше одного рядка результатів, слід використовувати явний курсор;
- Крім того, після звернення до явних курсорів 
	вони деякий час залишаються в пам'яті бази даних,
	і якщо ви введете той же курсорний оператор SELECT, 
	поки попередній знаходиться в пам'яті,
	то отримаєте результати набагато швидше
*/

/* Атрибути курсора:
SQL%ROWCOUNT - кількість рядків, які повернула остання SQL-команда;
SQL%FOUND - логічний атрибут, який повертає TRUE, 
	якщо остання команда повернула 1 або більше рядків;
SQL%NOTFOUND - логічний атрибут, який повертає TRUE, 
	якщо остання команда не повернула жодного рядка;
SQL%ISOPEN - логічний атрибут, який повертає TRUE, 
	якщо курсор відкритий, але для неявного курсору завжди дорівнює FALSE, 
	оскільки він автоматично закривається після виконання команди
*/

-- Приклад отримання атрибутів неявного курсору
BEGIN
	DELETE FROM emp;
	DBMS_OUTPUT.PUT_LINE('Total deleted rows = ' || SQL%ROWCOUNT);
END;
/

ROLLBACK;

/* Оголошення явного курсору. Синтаксис:

CURSOR ім'я_курсора 
	[([параметр_1 [, параметр_2...])]
[RETURN специфікація_повернення]
IS
	select-команда
	[FOR UPDATE [OF таблиця_або_стовпець_1
	[, таблиця_або_стовпець_2...]]
];
*/

/* Курсорний PL/SQL-запис:
a) PL/SQL-запис, заснований на явному курсорі;
b) поля запису збігаються по імені, типу та порядку 
	зі списком стовпців у курсорному операторі SELECT
c) оголошення запису з такими ж полями, як у курсорі: 
	ім'я_запису ім'я_курсора%ROWTYPE
*/

/* Команди управління явним курсором:
a) OPEN ім'я_курсора:
	- виділити в ОЗП спеціальну структуру даних для зберігання курсору;
	- виконати SELECT-запит;
	- встановити курсор на перший рядок відповіді на запит
b) FETCH ім'я_курсора INTO [ PL/SQL-запис | список_змінних ] :
	- отримати поточний рядок з курсору;
	- скопіювати дані рядка курсору в PL/SQL-запис або список змінних;
	- перевести курсор до наступного рядка відповіді на запит
c) CLOSE ім'я_курсора:
	- очистити структуру даних в ОЗП;
	- видалити курсор
*/

-- Приклад отримання списку працівників. Використання явного курсору
DECLARE
	CURSOR emp_list IS
		SELECT ename, deptno FROM emp;
	emp_rec emp_list%ROWTYPE; /* курсорний PL/SQL-запис */
BEGIN
	/* відкриття курсору: виконання запиту та встановлення на перший рядок відповіді*/
	OPEN emp_list; 
	/* копіювання рядка відповіді в змінну та перехід на новий рядок*/
	FETCH emp_list INTO emp_rec;
	DBMS_OUTPUT.PUT_LINE(RPAD('ename',10,' ') || 'deptno');
	WHILE emp_list%FOUND LOOP
		DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.ename,10,' ') || emp_rec.deptno);
		FETCH emp_list INTO emp_rec;
	END LOOP;
	/* закриття курсору: очищення пам'яті від відповіді на запит */
	CLOSE emp_list;
END;
/

/* Перед тим як намагатися вибрати з курсору черговий запис,
	слід перевірити за допомогою атрибутів FOUND і NOTFOUND, чи є ще записи.
Вибірки з порожнього курсору будуть весь час давати останній запис, 
	не призводячи до помилки
Фактична обробка записів з курсору зазвичай виконується всередині циклу
При написанні такого циклу непогано почати з перевірки, чи знайдено запис у курсорі:
	- якщо так, можна продовжувати потрібну обробку;
	- в іншому випадку слід вийти з циклу
Те саме можна зробити більш коротким шляхом, використавши курсорний цикл FOR,
	при цьому PL/SQL буде здійснювати відкриття, вибірку та закриття курсору без вашої участі
*/

/* Курсорний цикл FOR
1) синтаксис:
	FOR запис_курсора IN ім'я_курсора LOOP
		Тіло циклу
	END LOOP;
2) всі операції управління курсором (OPEN,FETCH,CLOSE) 
	виконуються автоматично
*/

-- Приклад отримання списку працівників. 
-- Використання явного курсору у курсорному циклі
DECLARE
	CURSOR emp_list IS
		SELECT ename, deptno FROM emp;
	emp_rec emp_list%ROWTYPE; /* змінна-запис */
BEGIN	
	DBMS_OUTPUT.PUT_LINE(RPAD('ename',10,' ') || 'deptno');
	FOR emp_rec IN emp_list LOOP
		DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.ename,10,' ') 
								|| emp_rec.deptno);
	END LOOP;
END;
/

-- Приклад отримання списку працівників.
-- Використання неявного курсору в курсорному циклі
BEGIN	
	DBMS_OUTPUT.PUT_LINE(RPAD('ename',10,' ') || 'deptno');
	FOR emp_rec IN (SELECT ename, deptno FROM emp) 
	LOOP
		DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.ename,10,' ') 
								|| emp_rec.deptno);
	END LOOP;
END;
/

-- Приклад отримання списку співробітників, які працюють у заданому підрозділі.
-- Використання явного курсору з параметром у курсорному циклі
DECLARE
	CURSOR emp_list(v_deptno NUMBER) IS
		SELECT ename, deptno FROM emp
		WHERE deptno = v_deptno;
	emp_rec emp_list%ROWTYPE; /* змінна-запис */
	v_deptno emp.deptno%TYPE := 10;
BEGIN	
	DBMS_OUTPUT.PUT_LINE('Emp List of department with id=' 
							|| v_deptno);
	-- функція RPAD форматує виведення значень колонок
	DBMS_OUTPUT.PUT_LINE(RPAD('ename',10,' ') || 'deptno');
	FOR emp_rec IN emp_list(v_deptno) 
	LOOP
		DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.ename,10,' ') 
								|| emp_rec.deptno);
	END LOOP;
END;
/

-- Приклад отримання списку співробітників, які працюють у заданому підрозділі.
-- Використання неявного курсору зі змінною у курсорному циклі
DECLARE
	v_deptno emp.deptno%TYPE := 10;
BEGIN	
	DBMS_OUTPUT.PUT_LINE('Emp List of department with id=' 
							|| v_deptno);
	DBMS_OUTPUT.PUT_LINE(RPAD('ename',10,' ') || 'deptno');
	FOR emp_rec IN (
					SELECT ename, deptno 
						FROM emp 
						WHERE deptno = v_deptno
					) 
	LOOP
		DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.ename,10,' ') 
								|| emp_rec.deptno);
	END LOOP;
END;
/

/* Конструкція WHERE CURRENT OF
Коли курсор відкривається для оновлення або видалення вибраних записів, 
можна використовувати конструкцію
	WHERE CURRENT OF ім'я_курсора
для доступу до таблиці та рядка, які відповідають останнім записам, 
вибраним у конструкції WHERE оператора UPDATE або DELETE

*/

/* Записи PL/SQL
1) Запис PL/SQL – це набір даних базових типів
2) До нього можна звертатися, як до єдиного цілого 
3) Для доступу до окремих полів запису застосовується нотація ім'я_запису.ім'я_поля

Записи можуть мати один із трьох типів:
- Засновані на таблиці
	Мають поля, що збігаються за ім'ям та типом зі стовпцями таблиці.
	Якщо курсор вибирає весь рядок, наприклад оператором
		SELECT * FROM ім'я_таблиці, 
	то записи, що повертаються їм,  можна безпосередньо копіювати в змінну-запис, 
		засновану на таблиці ім'я_таблиці
	Оголошення запису на основі таблиці 
		ім'я_запису ім'я_таблиці%ROWTYPE;

-Засновані на курсорі
	Поля цих записів збігаються за ім'ям, типом і порядком 
		із заключним списком стовпців у курсорному операторі SELECT
		CURSOR ім'я_курсора IS 
		SELECT колонка1, колонка2, … FROM …;
	Оголошення запису з такими ж полями, як і в курсорі
		ім'я_запису ім'я_курсора%ROWTYPE;

- Визначені програмістом
	Для створення власного запису потрібно повідомити PL/SQL його ім'я 
		та структуру через оголошення нового типу:
		TYPE ім'я_типу_запису IS RECORD
		(
			ім'я_поля_1 тип_поля_1, ім'я_поля_2 тип_поля_2, …
		);
	Фактичне оголошення запису має вигляд
		ім'я_змінної ім'я_типу_запису
*/

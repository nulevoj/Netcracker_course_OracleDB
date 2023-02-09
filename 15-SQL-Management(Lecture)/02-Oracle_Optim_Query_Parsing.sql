/*
Лекція "Основи керування SQL-запитами в СУБД Oracle".
Частина 2 - Життєвий цикл SQL-запиту. 
	Етап 1 - "Query Parsing"
*/

/*
Етап 1 - "Query Parsing" містить три кроки:
1) синтаксичний аналіз SQL-запиту (Syntax Check) 
	для контролю правильності мови запиту
2) семантичний аналіз SQL-запиту (Semantic Check) 
	для контролю правильності:
	- назв об'єктів БД:
		- таблиць, 
		- колонок, 
		- функцій;
	- типів даних:
		- вхідних параметрів у викликах функцій;
		- операторів в операціях порівняння 
			предикатів WHERE-фрази;
	- привілеїв доступу до об'єктів БД
3) аналіз повторюваності SQL-запиту (Shared Pool Check):
	1.1) хеш-значення рядка SQL-запиту порівнюється із
		хеш-значеннями, які було раніше збережено 
		для	попередніх SQL-запитів;
	а) хеш-значення формуються на основі перших 200 символів рядка,
		тому не рекомендуєься створювати великі SQL-запити,
		інакше це може призвести до класичної колізії хеш-значень,
		коли два різних великих SQL-запити вважаються однаковими;
	б) проблема колізій може вирішитися через:
		- заміну частини запиту на віртуальну таблицю; 
		- заміну складних запитів на PL/SQL-поцедури/функції;
		- впровадження Bind-змінних;	
	1.2) якщо хеш-значення не знайдено, 
		тоді Parsing = "Hard Parse" та перехід до кроку 4,
		інакше - Parsing = "Soft Parse" та перехід до 3-го етапу,
		тому що можна використати результати 2-го етапу для
		SQL-запиту, який вже виконувався
*/

/********************** SQL-запит як курсор *********************

Курсор – це структура даних в SGA, яка:
1) враховується при керуванні запитами на мові PL/SQL:
	- неявних курсорів;
	- явних курсорів;
2) розташована у приватній SQL-області користувача 
	(Private SQL Area)для безпеки роботи;
3) посилається на SQL область спільного доступу 
	( Shared SQL Area) для швидкості роботи;
4) складається з курсорів двох типів:
	- Parent-курсор;
	- Child-курсор.

Основні етапи життєвого циклу курсору SQL-запиту:
1) відкриття курсору: виділення приватної SQL області;
2) SQL Parsing курсору (Parse cursor) 
	та вибір між Soft-Parse та Hard-Parse;
3) визначення вихідних змінних (Output Variables)  
	для DML-команд INSERT/DELETE/UPDATE із фразою RETURNING;
4) зв'язування наявних змінних (Bind Input Variables);
5) виконання SQL-запиту курсору (Execute cursor)
6) отримання даних курсору (Fetch cursor)
7) закриття курсору: 
	- очищення Private SQL Area;
	- збереження Shared SQL Area.

*/


/**************** Особливості Parent-курсору ******************

Parent-курсор має наступні властивості:
- містить унікальний ідентифікатор SQL-запиту;
- зберігає зміст рядка з SQL-запитом;
- два SQL-запити з однаковим змістом 
	(з урухуванням регістрів символів)
	мають один parent-курсор;
- порівнюються не самі рядки SQL-запити,
	а їх хеш-значення;
- пов'язаний з не менше одним child-курсором;
- опис курсору доступний у віртуальній таблиці v$sqlarea структури:
	- sql_id - унікальний ідентифікатор
	- sql_text - рядок із запитом
	- executions - кількість SQL-запитів, які використали курсор
	- version_count - кількість child-курсорів
*/

/* Приклад 4-х SQL-запитів з однаковим результатом виконання */
SELECT * FROM emp WHERE empno = 1234;
select * from emp where empno = 1234;
SELECT * FROM emp WHERE empno=1234;
SELECT * FROM emp WHERE empno = 1234;

/* Отримати дані про parent-курсори,
рядок SQL-запитів який містить загальний підрядок 1234 */
col sql_text FORMAT A50
SELECT 
    sql_id, 
	hash_value,
    sql_text, 
	executions
FROM v$sqlarea
WHERE 
    sql_text LIKE '%1234';

/* Результат:
SQL_ID        SQL_TEXT                               EXECUTIONS
------------- -------------------------------------- ----------
az5j7hwrjhgb6 select * from emp where empno = 1234       1
5b5bfb9hxk2z5 SELECT * FROM emp WHERE empno = 1234       2
f9d17huzkz979 SELECT * FROM emp WHERE empno=1234         1

Коментар: з 4-х виконаних запитів лише 2 запити мають 
	ідентичні рядки, які використовують загальний Parent-курсор,
	що підтверджується значенням EXECUTIONS=2,
*/


/* Зміна алгоритму порівняння рядків SQL-запитів через команду:
ALTER SESSION SET cursor_sharing = <тип>,
де тип - це алгоритм порівняння рядків SQL-запитів:
	exact ( за замовчуванням) - повне співпадіннях двох рядків;
	force - часткове неспівпадання окремих літер.
*/
ALTER SESSION SET cursor_sharing=force;

/* Виконати два SQL-запити, які відрізняються
лише значенням стовпчика empno
*/
SELECT * FROM emp WHERE empno = 1;
SELECT * FROM emp WHERE empno = 2;

/* Переглянути опис створених Parent-курсор*/
SELECT 
    sql_id, 
    sql_text, 
	executions
FROM v$sqlarea
WHERE 
    sql_text LIKE '%empno = %';
	
/*
Результат:
SQL_ID        SQL_TEXT                                   EXECUTIONS
------------- ------------------------------------------ ----------
fqsqtbx489d38 SELECT * FROM emp WHERE empno = :"SYS_B_0"     2

Коментар: створено один Parent-курсор, який:
	- пропонує використовувати внутрішню Bind-змінну "SYS_B_0";
	- об'єднує два SQL-запити, які стали штучно хеш-ідентичними.
*/

/**************** Особливості Child-курсору ******************

Child-курсор має наступні властивості:
- посилається на один Parent-курсор;
- зберігає фізичний план виконання SQL-запиту;
- опис курсору доступний у віртуальній таблиці v$sql структури:
	- sql_id - унікальний ідентифікатор Parent-курсору
	- child_number - унікальний номер Child-курсору в межах Parent-курсору
	- optimizer_ - параметри оптимізації SQL-запиту;
	- plan_hash_value - хеш значення фізичного плану.
*/


/* Для child-курсора ключ является составной ключ, включающий: 
- parent-курсор;
- хеш-значение физического плана выполнения запроса;
- характеристики среды выполнения
*/

/* Розглянемо два приклади виконання одного SQL-запиту 
"SELECT count(*) FROM emp"
але з різними параметрами оптимізації SQL-запиту:
1) ALTER SESSION SET optimizer_mode = all_rows;
2) ALTER SESSION SET optimizer_mode = first_rows_1;
*/

ALTER SESSION SET optimizer_mode = all_rows;
SELECT count(*) FROM emp;

ALTER SESSION SET optimizer_mode = first_rows_1;
SELECT count(*) FROM emp;

/* Переглянути опис створених child-курсорів */
SELECT sql_id, child_number, optimizer_mode, plan_hash_value
FROM v$sql
WHERE sql_text = 'SELECT count(*) FROM emp';

/* Результат:
SQL_ID        CHILD_NUMBER OPTIMIZER_ PLAN_HASH_VALUE
------------- ------------ ---------- ---------------
d146gxvav359r            0 ALL_ROWS          40514612
d146gxvav359r            1 FIRST_ROWS        40514612

Комментар:
1) створено два Child-курсори від одного Parent-курсору, 
2) кожний Child-курсор має власне значення optimizer_mode
3) Child-курсори мають однаковий фізичний план
*/

/* Для визначення причини, чому вже існуючий child-курсор 
не використовується повторно (не хешується),
можна розглянути вміст віртуальної таблиці v$sql_shared_cursor,
в якій:
- кожна колонка пов'язана із властивістю курсора,
яка НЕ дозволяє повторне використання;
- кожна колонка приймає одне із двох значень:
	Y - властивість SQL-запиту НЕ дозволяє 
		повторно використовувати курсор;
	N - властивість SQL-запиту дозволяє 
		повторно використовувати курсор.
*/

/* Отримати властивості курсору з SQL_ID = d146gxvav359r */
SELECT *
FROM v$sql_shared_cursor
WHERE 
    sql_id = 'd146gxvav359r';


/* Приклад демонстрації підвищення 
швидкості запитів на основі Bind-змінних */

CREATE SEQUENCE empno_sequence START WITH 110000;

DECLARE
	v_empno emp.empno%TYPE;
	v_ename emp.ename%TYPE;
	v_job emp.ename%TYPE;
	v_hiredate emp.hiredate%TYPE;
	v_sal emp.sal%TYPE;
	sql_str VARCHAR2(500);
BEGIN
	sql_str := 'INSERT INTO emp(empno, ename, job, hiredate, sal, deptno) ' 
				|| 'VALUES(:1,:2,:3,:4,:5, :6)';
	FOR i IN 1..100 LOOP
		SELECT empno_sequence.NEXTVAL
			INTO v_empno FROM dual;
		v_ename := 'HARDING';
		v_job := 'CLERK';
		v_hiredate := to_date('01/01/1980','DD/MM/YYYY');
		v_sal := 100;
		EXECUTE IMMEDIATE sql_str USING v_empno, v_ename, v_job, v_hiredate, v_sal, 10;
	END LOOP;	
END;
/


/* Отримати список Child-курсорів із шаблоном SQL-запиту */
SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text like 'INSERT INTO emp(empno, ename, job, hiredate%';

/* Результат:
SQL_ID        CHILD_NUMBER EXECUTIONS
------------- ------------ ----------
f7qjqs5xdn5sc            0        100

Коментар:
1) використовується один Parent-курсор та Child-курсор
2) один Child-курсор було використано 100 разів,
що вказує про виконання одного Hard-Parse та 99 Soft-Parse,
*/


/*
PL/SQL bind-змінні в динамічних SQL-запитах. 
Проблема "Bind Variable Peeking"

Перевага Bind-змінних: 
1) скорочують час на Parsing за рахунок 
	кешування фізичних планів виконання запитів
Недоліки Bind-змінних: 
1) можуть призвести до збільшення часу на виконання 
	через відсутність реальних значень, 
	що враховуються оптимізатором та порівнюються 
	зі вмістом гістограм;
2) для запитів, які часто обробляють невеликі обсяги даних, 
	час на Parsing може виявитися більше часу на виконання, 
	тому рекомендується використовувати Bind-змінні
3) для запитів, обробляють великі обсяги даних, 
	час на Parsing-етап < часу на Execution-етап, 
	тому ефект від Bind-змінних може зникнути
4) проблема вирішується через використання 
	режиму Extendet Cursor Sharing або Adaptive Cursor Sharing,
	який включається командою (Oracle ver >= 11):
	ALTER SYSTEM FLUSH SHARED_POOL;	
*/


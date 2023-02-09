/* 
Програмування активних БД на основі тригерів у мові PL/SQL.
Частина 1 - Прості інформуюче-доповнюючі та обмежуючі тригери. 
Приклади створення
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON

COL LOCNO FORMAT 99999
COL LNAME FORMAT A20
COL DEPTNO FORMAT 99999
COL DNAME FORMAT A20
COL EMPNO FORMAT 99999
COL ENAME FORMAT A20

/*
Тригер – це процедура PL/SQL, яка виконується автоматично, 
	коли здійснюється деяка задана подія, 
	яка називається тригерною подією.
Події, з якими можна зв'язати тригери:
- Інструкції DML (INSERT, UPDATE або DELETE)
- Інструкції DDL (CREATE TABLE, ALTER TABLE)
- Події БД (вхід або вихід користувача в систему, 
	при запуску або зупинці БД, при виникнені помилок)

Області застосування DML-тригерів
1) реалізація спеціалізованого контролю за всіми діями 
	користувачів БД;
2) забезпечення складних правил цілістності таблиць БД;
3) забезпечення складних правил безпеки даних;
4) автоматичне внесення значень в колонки таблиць БД 
	( створення спеціалізованих матеріалізованих представлень );
5) забезпечення оновлюємих представлень (віртуальних таблиць).

Відмінності між тригерами та збереженими процедурами
1) Тригери неможна викликати з коду програми: 
	Oracle викликає їх автоматично у відповідь на певну подію
2) Тригери не мають списку параметрів
3) Специфікація тригера трохи відрізняється 
	від специфікації процедури
*/

/* Синтаксис DML-тригера
CREATE [OR REPLACE] TRIGGER ім'я_тригера 
BEFORE|AFTER
INSERT|DELETE|UPDATE|UPDATE OF колонка_таблиці
ON ім'я_таблиці 
[FOR EACH ROW]
[WHEN(…)]
[DECLARE…] 
BEGIN  
виконуємі оператори 
[EXCEPTION обробники винятків] 
END;

1) BEFORE|AFTER - Визначає момент спрацювання тригеру – 
	до чи після наступу тригерної події
	BEFORE-тригер – обмежуючий тригер
	AFTER-тригер – інформуюче-доповнюючий тригер
	Різні тригерні події можна комбінувати 
	за допомогою оператора OR, 
	наприклад DELETE OR INSERT
2) UPDATE OF колонки - тригер, зв'язаний з інструкцією 
	UPDATE може бути задано 
	для списку стовпців, розділених комами
3) ON ім'я_таблиці - кожний тригер DML повинен бути 
	зв'язаний з однією таблицею
4) FOR EACH ROW – рядковий тригер, який буде запускатися 
	для кожного рядка таблиці при виконанні DML-команди
	Якщо пропозиція FOR EACH ROW відсутня створюється 
	тригер рівня таблиці (table level trigger) - 
	тригер буде запускатися тільки по одному разу 
	при виконанні DML-команди
*/

/* Псевдозаписи NEW та OLD
При запуску рядкового тригеру виконуюче ядро PL/SQL 
	створює та заповнює дві структури данних, 
	які фуекціонують подібно до записів – 
	псевдозаписи NEW та OLD
Їх структура ідентична структурі запису, який оголошено 
	з атрибутом %ROWTYPE, 
	що створюється на основі таблиці, з якою зв'язано тригер,                  
	наприклад: NEW.колонка, OLD.колонка
Для тригерів, зв'язаних з інструкцією INSERT, 
	структура OLD не містить даних, 
	так як старого набору значень у операції вставки немає
Для тригерів, зв'язаних з інструкцією DELETE, 
	заповнюється тільки структура OLD, 
	а структура NEW залишається пустою, 
	так як запис видаляється
*/

/* Пропозиція WHEN
Дозволяє задати логіку для винятку непотрібного 
	виконання коду тригеру
Може використовуватися тільки в рядкових тригерах
Логічні вирази завжди повинні заключатися в дужки
Перед ідентифікаторами NEW та OLD неможна вводити двокрапку
Можна використовувати тільки вбудовані функції
Користувальницькі функції викликати неможна
Приклад: WHEN (NEW.колонка != OLD.колонка)
*/

/* Псевдозаписи NEW та OLD в PL/SQL-блоці
В PL/SQL-блоці посилання на NEW-запис та OLD-запис  
	слова потрібно починати двокрапкою: :NEW та :OLD
Для тригеру, який перехоплює UPDATE-команду, 
	заповнюються обидві структури:
	- OLD-запис містить вихідні значення рядку таблиці 
	до оновлення;
	- NEW-запись містить значення, які будуть 
	в рядку таблиці після оновлення
Значення полів OLD-запису неможна змінювати
Значення полів NEW-запису можна змінювати в тригері 
	типу BEFORE
NEW та OLD неможна передавати в якості параметрів 
	процедурам або функціям, 
	які викликаються з тригера, тільки їх окремі поля
*/

/* Визначення DML-команд
Oracle пропонує набір функцій для визначення DML-команд, 
	запустивших тригер, 
	дозволяючи створити один тригер, який виконував би дії, 
	пов'язані з різними DML-командами
1) INSERTING – повертає TRUE, якщо тригер запущено у відповідь 
	на вставку запису в таблицю, з якою він пов'язаний
	та FALSE в протилежному випадку
2) UPDATING – повертає TRUE, якщо тригер запущено у відповідь 
	на оновлення запису в таблиці, 
	з якою він пов'язаний та FALSE в протилежному випадку
3) UPDATING(колонка) – контроль оновлення колонки в таблиці
4) DELETING – повертає TRUE, якщо тригер запущено у відповідь 
	на видалення запису з таблиці, з якою він пов'язаний 
	та FALSE в протилежному випадку
*/

/* Особливості оформлення тіла тригера
- За замовчуванням команди в тілі тригеру автоматично 
	оформлюються у вигляді атомарної транзакції, 
	тому в цьому випадку неможна використовувати COMMIT/ROLLBACK
- При виникненні винятків відміняються всі зміни, включаючи ті, 
	які були виконані DML-командою, яка запустила тригер
- Тригер, в якому виконуються DML-команди, 
	може викликати спрацювування інших DML-команд
- Якщо для однієї тригерної події визначено 
	більше одного тригеру, то: 
	(до СУБД версії < 11) порядок спрацювання не визначено, 
	FOLLOWS – встановлення порядку виклику однотипних тригерів
*/

/* Управління тригерами
Тригер можна змінювати:
CREATE OR REPLACE TRIGGER ім'я_тригера …

Тригер можна видаляти:
DROP TRIGGER ім'я_тригера;

Тригер можна деактивовувати:
ALTER TRIGGER ім'я_тригера DISABLE;

Тригер можна повторно активувати:
ALTER TRIGGER ім'я_тригера ENABLE;
*/

/* Управління умовами виконання тригерного PL/SQL-блоку */

-- Створити інформуючий тригер для виведеня повідомлення 
-- на екран після додавання рядка в таблицю LOC
CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT ON loc
BEGIN
	DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
END;
/

-- Тест-кейс перевірки роботи тригера
-- 1
INSERT INTO loc VALUES (2,'ODESA');
ROLLBACK;

/* Спроба створити інформуючий тригер для виведення 
повідомлення на екран
після додавання рядка до таблиці LOC користувачем STUDENT
*/

CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT ON loc
	WHEN (USER = 'STUDENT')
BEGIN
	DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
END;
/
-- Помилка 
-- ORA-04077: WHEN clause cannot be used with table level triggers

/* Успішне створення інформуючого тригеру 
для виведення повідомлення на екран
після додавання рядка до таблиці LOC користувачем STUDENT
*/
CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT ON loc
BEGIN
	DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
END;
/

-- Тест-кейс перевірки роботи тригера
-- 1
INSERT INTO loc VALUES (2,'ODESA');
ROLLBACK;

/* Створити інформуючий тригер для виведення 
повідомлення на екран після додавання, 
зміни чи видалення рядка таблиці LOC
*/
CREATE OR REPLACE TRIGGER loc_control_after
	AFTER INSERT OR UPDATE OR DELETE ON loc
BEGIN
	IF INSERTING THEN 
		DBMS_OUTPUT.PUT_LINE('INSERTING INTO LOC ... ');
	ELSIF UPDATING THEN 
		DBMS_OUTPUT.PUT_LINE('UPDATING LOC ... ');
	ELSIF DELETING THEN 
		DBMS_OUTPUT.PUT_LINE('DELETING LOC ... ');
	END IF;	
END;
/
SHOW ERRORS

-- Тест-кейси перевірки роботи тригера
-- 1
INSERT INTO loc VALUES (2,'ODESA');
-- 2
UPDATE loc SET lname = 'NEW ODESA' WHERE locno = 2;
-- 3
DELETE FROM loc WHERE locno = 2;

/* Створити інформуючий тригер для виведення 
повідомлення на екран
після додавання, зміни чи видалення рядка таблиці LOC
Повідомлення містить статистику за кількістю рядків у таблиці
*/
CREATE OR REPLACE TRIGGER loc_control_quantity
	AFTER INSERT OR UPDATE OR DELETE ON loc
DECLARE
		loc_quantity loc.locno%TYPE;
BEGIN
	SELECT COUNT(locno) INTO loc_quantity
		FROM loc;
	DBMS_OUTPUT.PUT_LINE('Loc quantity = ' || loc_quantity);
END;
/
SHOW ERRORS

-- Тест-кейс перевірки роботи тригера
-- 1
UPDATE loc SET lname = 'ODESA' WHERE locno = 2;
/* Результат: повідомлення тригера loc_control_quantity 
виконалось першим,так як було створено останнім:
Loc quantity = 6
UPDATING LOC ... 
*/

/* Повторити рішення, але із зазначенням тригеру
виконуватися суворо після тригера loc_control_after
*/
CREATE OR REPLACE TRIGGER loc_control_quantity
	AFTER INSERT OR UPDATE OR DELETE ON loc
	FOLLOWS loc_control_after
DECLARE
		loc_quantity loc.locno%TYPE;
BEGIN
	SELECT count(locno) INTO loc_quantity
		FROM loc;
	DBMS_OUTPUT.PUT_LINE('Loc quantity = ' || loc_quantity);
END;
/
SHOW ERRORS

-- Тест-кейс перевірки роботи тригера
-- 1
UPDATE loc SET lname = 'ODESA' WHERE locno = 1;
/* Результат: повідомлення тригера loc_control_quantity 
виконалось другим:
UPDATING LOC ... 
Loc quantity = 6
*/

-- Створити обмежуючий тригер для заборони користувачеві STUDENT 
-- додавати рядок до таблиці LOC
CREATE OR REPLACE TRIGGER loc_control_before_insert
	BEFORE INSERT ON loc
	FOR EACH ROW
	WHEN (USER = 'STUDENT')
BEGIN
	RAISE_APPLICATION_ERROR(-20500,
							'User ' 
							|| USER || ' can not INSERT'
	);
END;
/

-- Тест-кейс перевірки роботи тригера
-- 1
INSERT INTO loc VALUES (2,'ODESSA2');

/* Створити обмежуючий тригер для заборони 
користувачеві STUDENT 
намагатися змінювати значення 
колонки LNAME таблиці LOC на старе значення
*/
CREATE OR REPLACE TRIGGER loc_control_before_update_lname
	BEFORE UPDATE OF lname ON loc
	FOR EACH ROW
	WHEN (USER = 'STUDENT' AND NEW.lname = OLD.lname)
BEGIN
	RAISE_APPLICATION_ERROR(-20501,
							'User ' 
							|| USER 
							|| ' can not UPDATE SUCH VALUE OF lname'
	);
END;
/

ALTER TRIGGER loc_control_quantity DISABLE;
ALTER TRIGGER loc_control_before_insert DISABLE;
ALTER TRIGGER loc_control_after DISABLE;

-- Тест-кейс перевірки роботи тригера
UPDATE loc SET lname = 'ODESSA' WHERE lname = 'ODESSA';

-- Створити обмежуючий тригер для заборони користувачеві STUDENT 
-- намагатися змінювати значення колонок таблиці LOC після 17:00
CREATE OR REPLACE TRIGGER loc_control_before_update_time
	BEFORE UPDATE ON loc
	FOR EACH ROW
	WHEN (USER = 'STUDENT')
BEGIN
	IF TO_NUMBER(TO_CHAR(SYSDATE,'HH24')) >= 17 THEN 
		RAISE_APPLICATION_ERROR(-20501,'User ' 
								|| USER 
								|| ' can not UPDATE after 17:00'
		);
	END IF;
END;
/

-- Тест-кейс перевірки роботи тригера
UPDATE loc 
SET lname = 'ODESA' 
WHERE lname = 'ODESA';

-- Відключити тригер loc_control_before_update_time
ALTER TRIGGER loc_control_before_update_time DISABLE;

-- Тест-кейс перевірки роботи тригерів, що залишилися
UPDATE loc 
SET lname = 'ODESA' W
HERE lname = 'ODESA';

-- Увімкнути тригер loc_control_before_update_time
ALTER TRIGGER loc_control_before_update_time ENABLE;

-- Видалити тригер loc_control_before_update_time
DROP TRIGGER loc_control_before_update_time;

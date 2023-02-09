/* Лекція "Модульне тестування (Unit Testing) PL/SQL СУБД Oracle".
Частина 3 - Модульне тестування з використанням пакету utPLSQL

-- Сайт проекту utPLSQL (доступний, чомусь, лише через VPN )
http://www.utplsql.org/

-- GitHub-репрзиторій проекту utPLSQL
https://github.com/utPLSQL/utPLSQL


/* Інсталяція utPLSQL
*/

https://github.com/utPLSQL/utPLSQL/releases/download/v3.1.13/utPLSQL.zip
unzip utPLSQL.zip
cd ./utPLSQL/source


-- Виконати скрипт
chmod +x ./install.sh
./install.sh

/* Встановити пакет в схему даних користувача student10 */
sqlplus sys@localhost:1521/XEPDB1 as sysdba 

@create_utplsql_owner.sql student10 p1234 users
@install.sql student10
grant execute on DBMS_CRYPTO to student10;
@install_ddl_trigger.sql student10
@create_synonyms_and_grants_for_public.sql student10
@create_user_grants.sql student10

/*
Більшість програмних бібліотек для тестування 
використовують анотації як макро-включення 
у програмний код відповідної мови програмування, забезпечуючи:
1) зберігання тестової конфігурації разом із тестовою логікою 
	в тестовому пакеті; 
2) відмову від зайвих додаткових конфігураційних файлів
3) іменування анотацій на основі популярних платформа тестування, 
	наприклад, JUnit. 
4) автоматичний запуск відповідних анотованих пакетів, 
їх налаштовання та формування звітності про результати тестування

Опис більшості анотацій має наступний синтаксис:
--%name(text)
де  name - назва анотації
	text - необов’язковий супроводжувальний текст
Анатоції поділяються на:
- анатоція рівня пакету;
- анотація рівня процедури.

Приклади основних анатоцій рівня пакету:
--%suite( <description> ) - головна та єдина необхідна анатоція
	для визначення комплекту тестування з можливим описом, 
	який буде виведено на екран під час тестування
--%suitepath( <path> ) - анотація логічного групування анатоцій

Основною анотацією рівня процедури є:
--%test( <description> ) - анотація вказує, що процедура/функція
	буде використовуватися для модульного тестування

Між анотаціями --%suite та --%test треба вказати один пустий рядок
*/

/* Перевірити роботу utPLSQL 
*/

-- Очистити екран
clear screen;

-- Включити режим отримання повідомлень від сервера
SET SERVEROUTPUT ON

-- Створити PL/SQL-пакет для тестування
CREATE OR REPLACE PACKAGE test_function AS
    --%suite(test package)
END;
/

-- Запустити процес тестування (1-й варіант)
-- через анонімний PL/SQL-блок
BEGIN 
    ut.run(); 
END;
/
/* Результат виконання:
test package
Finished in .013382 seconds
0 tests, 0 failed, 0 errored, 0 disabled, 0 warning(s)
*/

-- Запустити процес тестування (2-й варіант)
-- через SQLPlus-командний виклик
EXEC ut.run();

-- Запустити процес тестування (3-й варіант)
-- через табличну функцію
SELECT * 
FROM TABLE(ut.run());

/*
Створити PL/SQL-пакет для тестування функції 
user_name_is_correct(user_name VARCHAR)
*/

CREATE OR REPLACE PACKAGE test_package 
IS
	--%suite(test package)
	
 	--%test(Test procedure for testing function user_name_is_correct)
    PROCEDURE ut_user_name_is_correct;
END;
/

CREATE OR REPLACE PACKAGE BODY test_package 
IS
    PROCEDURE ut_user_name_is_correct AS
	BEGIN
	    ut.expect( user_name_is_correct('user1') ).to_equal(1);
		ut.expect( user_name_is_correct('1user1') ).to_equal(-1);
		ut.expect( user_name_is_correct('user1234567891011') ).to_equal(-1);
    END ut_user_name_is_correct;
END test_package;
/
SHOW ERROR;

/* Запустити процес тестування пакету test_package
*/
BEGIN 
    ut.run('test_package'); 
END;
/
/* Результат:
test package
Test procedure for testing function user_name_is_correct [.084 sec]
Finished in .089835 seconds
1 tests, 0 failed, 0 errored, 0 disabled, 0 warning(s)
*/

/* Для експерименту змінити очікуване значення для 2-го тесту
*/
CREATE OR REPLACE PACKAGE BODY test_package 
IS
    PROCEDURE ut_user_name_is_correct AS
	BEGIN
	    ut.expect( user_name_is_correct('user1') ).to_equal(1);
		ut.expect( user_name_is_correct('1user1') ).to_equal(1);
		ut.expect( user_name_is_correct('user1234567891011') ).to_equal(-1);
    END ut_user_name_is_correct;
END test_package;
/
SHOW ERROR;

/* Запустити процес тестування пакету test_package
*/
BEGIN 
    ut.run('test_package'); 
END;
/

/* Результат:
test package
Test procedure for testing function user_name_is_correct [.314 sec] (FAILED - 1)
Failures:
1) ut_user_name_is_correct
Actual: -1 (number) was expected to equal: 1 (number)
at "STUDENT10.TEST_PACKAGE.TEST_USER_NAME_IS_CORRECT", line 7 ut.expect(
user_name_is_correct('1user1') ).to_equal(1);
Finished in .328384 seconds
1 tests, 1 failed, 0 errored, 0 disabled, 0 warning(s)
*/

/* Запустити процес тестування всіх пакетів
*/
BEGIN 
    ut.run(); 
END;
/


/* Запуск utPLSQL через командний рядок 
для забезпечення Unit Testing in Continuous Integration
*/
https://github.com/utPLSQL/utPLSQL-cli

/* Отримання останньої версії 
утиліти utplsql в ОС Windows
*/
https://github.com/utPLSQL/utPLSQL-cli/releases


/* Автоматичне отримання останньої версії 
утиліти utplsql в ОС Linux
*/

#!/bin/bash
# Get the url to latest release "zip" file
DOWNLOAD_URL=$(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL-cli/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g')
# Download the latest release "zip" file
curl -Lk "${DOWNLOAD_URL}" -o utplsql-cli.zip
# Extract downloaded "zip" file
unzip -q utplsql-cli.zip


/* Запустити процес тестування для всіх пакетів 
*/
utplsql run student10/p1234@91.219.60.189:1521/XEPDB1

/* Запустити процес тестування пакету test_package
*/
utplsql run student10/p1234@91.219.60.189:1521/XEPDB1 -p=test_package
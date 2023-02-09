/*
Лекція "Основи керування SQL-запитами в СУБД Oracle".
Частина 6 - Життєвий цикл SQL-запиту. Етап 2-"Query Optimization".
Аналіз методів методів зв'язків між таблицями (Join Methods)
*/

SET LINESIZE 2000
SET PAGESIZE 60
SET SERVEROUTPUT ON

/*
Алгоритм з'єднання таблиць "вкладені цикли" - "Nested Loop Joins". 
Кроки алгоритму:
1) визначення провідної таблиці (outer table) – 
таблиці на зовнішній стороні з'єднання (driving table) 
та відомої таблиці (inner table).
2) для кожного рядка провідної таблиці вибираються всі рядки 
відомої таблиці:

Алгоритм з'єднання таблиць "сортування зі злиттям" - "Sort merge joins"
часто використовується для тета-з'єднання таблиць (оператори <, <=, >, >=)
Для великих таблиць "Sort merge joins" швидше ніж "Nested Loop Joins".
Кроки алгоритму:
1) join key - сортування рядків таблиць по стовпчиках-ключам 
	з'єднання (якщо дані вже відсортовані або є індекси за ключами, 
	крок пропускається);
2) Merge join - з'єднання або злиття (merging) таблиць 
	по відсортованих стовпчиках.

Алгоритм з'єднання таблиць за хеш-значенням - "Hash Join"
	використовується для з'єднання великих наборів даних.

Кроки алгоритму:
1) для меншої з двох таблиць у пам'яті 
будується хеш-таблиця ключа з'єднання (join key)
2) сканується велика таблиця та порівнюється 
за ключом з хеш-таблицею для отримання результуючого набору рядків

*/

-- Приклад запиту на одну операцію з'єднання
SELECT e.ename, d.dname
	FROM emp e, dept d
	WHERE 
		e.deptno = d.deptno;

/* Результат:
------------------------------------------------
| Id  | Operation                    | Name    |
------------------------------------------------
|   0 | SELECT STATEMENT             |         |
|   1 |  NESTED LOOPS                |         |
|   2 |   NESTED LOOPS               |         |
|   3 |    TABLE ACCESS FULL         | EMP     |
|*  4 |    INDEX UNIQUE SCAN         | DEPT_PK |
|   5 |   TABLE ACCESS BY INDEX ROWID| DEPT    |
------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - access("E"."DEPTNO"="D"."DEPTNO")
*/

-- Створення B-tree-індексу для колонки deptno
CREATE INDEX deptno_index ON emp (deptno);

-- Приклад запиту на одну операцію з'єднання
SELECT e.ename, d.dname
	FROM emp e, dept d
	WHERE 
		e.deptno = d.deptno;

/* Результат:
-----------------------------------------------------
| Id  | Operation                    | Name         |
-----------------------------------------------------
|   0 | SELECT STATEMENT             |              |
|   1 |  NESTED LOOPS                |              |
|   2 |   NESTED LOOPS               |              |
|   3 |    TABLE ACCESS FULL         | DEPT         |
|*  4 |    INDEX RANGE SCAN          | DEPTNO_INDEX |
|   5 |   TABLE ACCESS BY INDEX ROWID| EMP          |
-----------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - access("E"."DEPTNO"="D"."DEPTNO")
*/

-- Приклад запиту із двома операціями з'єднання
SELECT e.ename, d.dname, l.lname
	FROM emp e, dept d, loc l
	WHERE 
		e.deptno = d.deptno
		AND d.locno = l.locno;

/* Результат:
--------------------------------------------------
| Id  | Operation                      | Name    |
--------------------------------------------------
|   0 | SELECT STATEMENT               |         |
|   1 |  NESTED LOOPS                  |         |
|   2 |   NESTED LOOPS                 |         |
|   3 |    NESTED LOOPS                |         |
|   4 |     TABLE ACCESS FULL          | EMP     |
|   5 |     TABLE ACCESS BY INDEX ROWID| DEPT    |
|*  6 |      INDEX UNIQUE SCAN         | DEPT_PK |
|*  7 |    INDEX UNIQUE SCAN           | LOC_PK  |
|   8 |   TABLE ACCESS BY INDEX ROWID  | LOC     |
--------------------------------------------------
*/

-- Створення B-tree-індексу для колонки locno
CREATE INDEX locno_index ON dept(locno);

/* Результат:
-------------------------------------------------------
| Id  | Operation                      | Name         |
-------------------------------------------------------
|   0 | SELECT STATEMENT               |              |
|   1 |  NESTED LOOPS                  |              |
|   2 |   NESTED LOOPS                 |              |
|   3 |    NESTED LOOPS                |              |
|   4 |     TABLE ACCESS FULL          | LOC          |
|   5 |     TABLE ACCESS BY INDEX ROWID| DEPT         |
|*  6 |      INDEX RANGE SCAN          | LOCNO_INDEX  |
|*  7 |    INDEX RANGE SCAN            | DEPTNO_INDEX |
|   8 |   TABLE ACCESS BY INDEX ROWID  | EMP          |
-------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   6 - access("D"."LOCNO"="L"."LOCNO")
   7 - access("E"."DEPTNO"="D"."DEPTNO")
*/


/*
Лекція "Основи керування SQL-запитами в СУБД Oracle".
Частина 4 - Життєвий цикл SQL-запиту. Етап 2-"Query Optimization".
Генератори даних для заповнення таблиць псевдовипадковими даними
*/

SET LINESIZE 2000
SET PAGESIZE 60

SET SERVEROUTPUT ON


/* Заповнення штучними даними таблиці співробітників 
(100000 співробітників) для проведення експериментів 
з великим обсягом таблиці (збільшити розмірність колонки empno)
*/
ALTER TABLE emp MODIFY empno NUMERIC(9);

-- генерація 100 000 записів таблиці EMP
DECLARE
	min_empno emp.empno%TYPE;
	TYPE Jobs IS TABLE OF emp.job%TYPE;
	job_list Jobs;
	TYPE Deptno IS TABLE OF emp.deptno%TYPE;
	deptno_list Deptno;
	TYPE Emps IS TABLE OF emp%ROWTYPE;
	emp_list Emps := Emps();
	job_elem NUMERIC(2);
	row_count CONSTANT PLS_INTEGER := 100000;
BEGIN
	SELECT max(empno) INTO min_empno from emp;
	emp_list.EXTEND(row_count);
	-- Отримання колекції назв посад
	SELECT distinct job BULK COLLECT INTO job_list from emp;
	-- Отримання колекції допустимих номерів підрозділів
	SELECT deptno BULK COLLECT INTO deptno_list from dept;
	FOR j IN 1..row_count LOOP
	emp_list(j).empno := min_empno + j;
	-- генерація імен співробітників у вигляді рядка довжиною 7 символів
	-- з псевдовипадковою появою символів у верхньому регістрі
	emp_list(j).ename := DBMS_RANDOM.STRING('U',7);
	emp_list(j).mgr := NULL;
	-- генерація назв посад
	-- з псевдовипадковою появою рядків-констант колекції
	emp_list(j).job := job_list(ROUND(DBMS_RANDOM.VALUE(1,job_list.count))));
	-- генерація дат зарахування на роботу
	-- у діапазоні '01/01/2000' + псевдовипадкове число в діапазоні (1,1000)
	emp_list(j).hiredate:=to_date('01/01/2000','DD/MM/YYYY')+
	ROUND(DBMS_RANDOM.VALUE(1,1000));
	-- генерація зарплат як псевдовипадкове число в діапазоні (1000,3000)
	emp_list(j).sal := DBMS_RANDOM.VALUE(1,3)*1000;
	-- генерація комісійних як псевдовипадкове число в діапазоні (100,1500)
	emp_list(j).comm := ROUND(DBMS_RANDOM.VALUE(1,15))*100;
	-- генерація ідентифікаторів підрозділів
	-- з псевдовипадковою появою значень номерів підрозділів із колекції		emp_list(j).deptno := deptno_list(ROUND(DBMS_RANDOM.VALUE(1,deptno_list.count))); 
	END LOOP;
	FORALL j IN emp_list.FIRST..emp_list.LAST
		INSERT INTO emp (empno, ename, job, 
							mgr,hiredate, sal, 
							comm, deptno)
			VALUES(emp_list(j).empno,emp_list(j).ename,emp_list(j).job,
					emp_list(j).mgr,emp_list(j).hiredate,emp_list(j).sal,
					emp_list(j).comm,emp_list(j).deptno);
END;
/
SHOW ERRORS

--
COMMIT;

-- 
SELECT empno,ename,job,deptno 
FROM emp
WHERE empno > 1000
FETCH FIRST 100 ROWS ONLY;

/*
Генератор даних для заповнення таблиць псевдовипадковими даними
із нормальним законом розподілу ймовірності появи значень у стовпчиках
*/


/* При генерації нових рядків може виникнути помилка нестачі простору
-- Інформація про простори:
select file_name, bytes, autoextensible, maxbytes
from dba_data_files where tablespace_name='SYSTEM';
- Команда розширення простору на 6Гб
alter database datafile 'C:\oraclexe\app\oracle\oradata\xe\SYSTEM.DBF'
	resize 6000m;
*/


/* Функція генерації псевдовипадкової величини з
використанням нормального закону розподілу ймовірності появи величин
normal_rnd = (rnd + rnd + rnd + rnd + rnd + rnd + rnd + rnd) / 8;
*/

CREATE OR REPLACE FUNCTION normal_random(min_val NUMERIC, max_val NUMERIC)
RETURN NUMERIC
IS
BEGIN 
	RETURN 
		TRUNC((
				DBMS_RANDOM.VALUE(min_val,max_val) + 
				DBMS_RANDOM.VALUE(min_val,max_val) +
				DBMS_RANDOM.VALUE(min_val,max_val) + 
				DBMS_RANDOM.VALUE(min_val,max_val) + 
				DBMS_RANDOM.VALUE(min_val,max_val) + 
				DBMS_RANDOM.VALUE(min_val,max_val) + 
				DBMS_RANDOM.VALUE(min_val,max_val) + 
				DBMS_RANDOM.VALUE(min_val,max_val) 
		)/8);
END;
/
SHOW ERRORS;

select normal_random(1,4) from dual;

-- генерация 100000 записей таблицы EMP
DECLARE
	min_empno emp.empno%TYPE;
	TYPE Jobs IS TABLE OF emp.job%TYPE;
	job_list Jobs;
	TYPE Deptno IS TABLE OF emp.deptno%TYPE;
	deptno_list Deptno;
	TYPE Emps IS TABLE OF emp%ROWTYPE;
	emp_list Emps := Emps();
	job_elem NUMERIC(2);
	row_count CONSTANT PLS_INTEGER := 100000;
BEGIN
	SELECT max(empno) INTO min_empno from emp;
	emp_list.EXTEND(row_count);
	-- Отримання колекції назв посад
	SELECT distinct job BULK COLLECT INTO job_list from emp;
	-- Отримання колекції допустимих номерів підрозділів
	SELECT deptno BULK COLLECT INTO deptno_list from dept;
	FOR j IN 1..row_count LOOP
	emp_list(j).empno := min_empno + j;
	-- генерація імен співробітників у вигляді рядка довжиною 7 символів
	-- з псевдовипадковою появою символів у верхньому регістрі
	emp_list(j).ename := DBMS_RANDOM.STRING('U',7);
	emp_list(j).mgr := NULL;
	-- генерація назв посад
	-- з псевдовипадковою появою рядків-констант колекції
	emp_list(j).job := job_list(normal_random(1,job_list.count));
	-- генерація дат зарахування на роботу
	-- у діапазоні '01/01/2000' + псевдовипадкове число в діапазоні (1,1000)
	emp_list(j).hiredate:=to_date('01/01/2000','DD/MM/YYYY')+
	normal_random(1,1000);
	-- генерація зарплат як псевдовипадкове число в діапазоні (1000,3000)
	emp_list(j).sal := normal_random(1,3)*1000;
	- генерація комісійних як псевдовипадкове число в діапазоні (100,1500)
	emp_list(j).comm := normal_random(1,15)*100;
	-- генерація ідентифікаторів підрозділів
	-- з псевдовипадковою появою значень номерів підрозділів із колекції		emp_list(j).deptno := deptno_list(normal_random(1,deptno_list.count)); 
	END LOOP;
	FORALL j IN emp_list.FIRST..emp_list.LAST
		INSERT INTO emp (empno, ename, job, 
							mgr,hiredate, sal, 
							comm, deptno)
			VALUES(emp_list(j).empno,emp_list(j).ename,emp_list(j).job,
					emp_list(j).mgr,emp_list(j).hiredate,emp_list(j).sal,
					emp_list(j).comm,emp_list(j).deptno);
END;
/
SHOW ERRORS

--
COMMIT;

-- 
SELECT empno,ename,job,deptno 
FROM emp
WHERE empno > 1000
FETCH FIRST 100 ROWS ONLY;


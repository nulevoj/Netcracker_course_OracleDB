/* 
Назва: Приклади запитів до лекції з ієрархічних запитів в Oracle
*/

SET LINESIZE 2000
SET PAGESIZE 100

/* 1 Вибрати співробітників відповідно до посадової ієрархії,
починаючи із співробітника верхньої ієрархії.
Використання ієрархічного зв'язку типу «зверху-вниз»
*/
SELECT ENAME, EMPNO, MGR, LEVEL
FROM EMP 
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR 
ORDER BY LEVEL;

/* 2 Вибрати співробітників відповідно до посадової ієрархії,
починаючи із співробітника верхньої ієрархії.
Сортувати співробітників за іменами всередині одного рівня ієрархії:
*/
SELECT ENAME, EMPNO, MGR, LEVEL
FROM EMP 
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR 
ORDER SIBLINGS BY ENAME;

/* 3 Вибрати всіх керівників працівника на ім'я SMITH.
Використання ієрархічного зв'язку типу «знизу-вгору»:
*/
SELECT empno, ename, empno, mgr, level
FROM emp START WITH ename='SMITH'
CONNECT BY prior mgr = empno 
ORDER BY level DESC;

-- 4 Вибрати співробітників, які не мають підлеглих
SELECT ENAME, EMPNO, MGR, LEVEL
FROM EMP 
WHERE CONNECT_BY_ISLEAF = 1
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR 
ORDER SIBLINGS BY ENAME;

-- 5 Вибрати співробітників відповідно до посадової ієрархії, починаючи зі співробітника верхньої ієрархії.
-- Оформити у вигляді відступів
SELECT LPAD('.', 8*(LEVEL-1), '.') || ENAME AS "HIERARCHY"
FROM EMP 
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

-- 6 Отримати список рядків з атрибутами: "Номер співробітника", "Номер керівника"
-- Перший (історичний) спосіб
SELECT TO_NUMBER(SUBSTR(SCBP,1,INSTR(SCBP,'.')-1)) MGR,
	EMPNO
FROM 
(	SELECT EMPNO,
	LTRIM(SYS_CONNECT_BY_PATH(EMPNO,'.'),'.') ||'.' SCBP
    FROM EMP
	CONNECT BY PRIOR MGR=EMPNO
)
ORDER BY 1;
   
-- 7 Отримати список рядків з атрибутами: "Номер співробітника", "Номер керівника"
-- Другий спосіб (використання CONNECT_BY_ROOT)
SELECT CONNECT_BY_ROOT empno "EmpNumber",
         empno "MgrNumber"
     FROM emp
  CONNECT BY PRIOR mgr=empno
  ORDER BY 1;

-- 8 Зміна ієрархії, що веде до зациклювання
UPDATE EMP SET MGR = 7369 
	WHERE EMPNO = 7839;

-- 9 Вибрати співробітників з циклічною ієрархією (помилкова спроба)
SELECT empno, ename, empno, mgr, level
FROM emp 
START WITH ename='SMITH'
CONNECT BY prior mgr = empno 
ORDER BY level DESC;

-- 10 Вибрати співробітників з циклічною ієрархією (успішна спроба)
SELECT empno, ename, empno, mgr, level
FROM emp 
START WITH ename='SMITH'
CONNECT BY NOCYCLE prior mgr = empno 
ORDER BY level DESC;

-- 11 Вибрати співробітників, які приводять до зациклювання
SELECT empno, ename, empno, mgr, level
FROM emp 
WHERE CONNECT_BY_ISCYCLE = 1
START WITH ename='SMITH'
CONNECT BY NOCYCLE prior mgr = empno 
ORDER BY level DESC;

-- 12 Зміна ієрархії, що виключає зациклювання
UPDATE EMP E1 SET MGR = NULL
WHERE EXISTS
	(SELECT empno FROM emp E2
		WHERE CONNECT_BY_ISCYCLE = 1 AND
		E1.empno = E2.empno
		START WITH ename='SMITH'
		CONNECT BY NOCYCLE prior mgr = empno 
	);

-- 13 Згенерувати послідовність значень від 1 до max, наприклад, до 100
SELECT ROWNUM AS RN FROM DUAL
CONNECT BY LEVEL <= 100

-- 14 Вибрати номери підрозділів, які пропущені у таблиці dept.
SELECT SQ.RN
FROM (SELECT ROWNUM AS RN 
		FROM DUAL CONNECT BY LEVEL <= 
					(SELECT MAX(DEPTNO) FROM DEPT)
	) SQ
WHERE SQ.RN NOT IN (SELECT DEPTNO FROM DEPT) 
ORDER BY RN;

-- 15 Згенерувати послідовність значень від 1 до 100 (оператор With)
WITH NUMBERS(N) AS
(
	SELECT 1 AS N FROM DUAL
	UNION ALL
	SELECT N+1 FROM NUMBERS WHERE N < 100)
SELECT N FROM NUMBERS;

-- 16 Згенерувати послідовність чисел Фібоначчі (кожне наступне число дорівнює сумі двох попередніх чисел)
-- Приклад: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
WITH fib_numbers(n, fn, "fn-1", "fn-2") AS
(
	SELECT 1 n, 1 fn, 1 "fn-1", 0 "fn-2" from dual
		UNION ALL
	SELECT n+1, "fn-1"+"fn-2", "fn-1"+"fn-2", "fn-1"
	FROM fib_numbers WHERE n <= 100)
SELECT fn FROM fib_numbers;

/* 17 Вивести значення календаря на поточний місяць поточного року:
- номер дня в місяці (дві цифри),
- повна назва місяця англійською великими літерами (у верхньому регістрі),
- рік (чотири цифри),
- повна назва дня тижня англійською малими літерами (у нижньому регістрі).
Кожне "підполе" має бути відокремлено від наступного одним пробілом.
В результаті не повинно бути початкових та хвостових пробілів.
Кількість рядків, що повертаються, повинна точно відповідати кількості днів у поточному місяці.
Рядки мають бути впорядковані за номерами днів у місяці за зростанням
*/

-- Перший спосіб
SELECT TO_CHAR(d
     , 'DD fmMONTH YYYY day'
     , 'NLS_DATE_LANGUAGE=AMERICAN') AS d
FROM (SELECT TRUNC(SYSDATE,'MM')+rownum-1 AS d FROM dual
      CONNECT BY ROWNUM <= TO_CHAR(LAST_DAY(SYSDATE), 'DD'))
ORDER BY d;
-- Другий спосіб
SELECT TO_CHAR(TRUNC(SYSDATE,'MM')+rownum-1
             , 'DD fmMONTH YYYY day'
             , 'NLS_DATE_LANGUAGE=AMERICAN') AS d
FROM dual
CONNECT BY ROWNUM <= TO_CHAR(LAST_DAY(SYSDATE), 'DD')
ORDER BY d;


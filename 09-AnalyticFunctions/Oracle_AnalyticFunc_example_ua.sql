
/* 

Приклади для лекції -
"Особливості використання аналітичних функцій 
у СУБД Oracle"

*/

/*
Налаштування параметрів роботи з SQLPlus
*/

SET LINESIZE 2000
SET PAGESIZE 100

COL empno FORMAT 99999
COL deptno FORMAT 99999
COL sum_sal FORMAT 999999
COL sal FORMAT 99999
COL job FORMAT A10
COL ename FORMAT A8
COL hiredate FORMAT A10


/* Завдання 1:
Отримати прізвище, підрозділ, посаду, 
дату зарахування та зарплату співробітників
з відповідним сортуванням вказаних значень за зростанням

Приклад очікуємого результату:
ENAME    DEPTNO JOB        HIREDATE      SAL
-------- ------ ---------- ---------- ------
MILLER       10 CLERK      23-JAN-82    1300
CLARK        10 MANAGER    09-JUN-81    1500
KING         10 PRESIDENT  17-NOV-81    5000
FORD         20 ANALYST    03-DEC-81    3000
SCOTT        20 ANALYST    09-DEC-82    3000
SMITH        20 CLERK      17-DEC-80     800
ADAMS        20 CLERK      12-JAN-83    1100
JONES        20 MANAGER    02-APR-81    2975
JAMES        30 CLERK      03-DEC-81     950
BLAKE        30 MANAGER    01-MAY-81    2850
ALLEN        30 SALESMAN   20-FEB-81    1600
WARD         30 SALESMAN   22-FEB-81    1250
TURNER       30 SALESMAN   08-SEP-81    1500
MARTIN       30 SALESMAN   28-SEP-81    1250
IVANOV       50 STUDENT    03-NOV-22       0

*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal
FROM emp
ORDER BY deptno, job, hiredate;

/* Завдання 2: 
Отримати сумарну зарплату співробітників 
у кожному підрозділу 
з однаковими посадами.

Приклад очікуємого результату:
DEPTNO JOB        SUM_SAL
------ ---------- -------
    10 CLERK         1300
    10 MANAGER       1500
    10 PRESIDENT     5000
    20 ANALYST       6000
    20 CLERK         1900
    20 MANAGER       2975
    30 CLERK          950
    30 MANAGER       2850
    30 SALESMAN      5600
    50 STUDENT          0

Варіант рішення зі стандартним застосуванням 
угруповання даних з функцією агрегації

*/

SELECT 
    deptno,
	job,
	SUM(sal) sum_sal 
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;

/* Завдання 3: 
Отримати прізвище, підрозділ, посаду співробітників 
з одночасним показом сумарної зарплати працівників 
у їх підрозділах з посадами.

Приклад очікуємого результату:
ENAME    DEPTNO JOB        SUM_SAL
-------- ------ ---------- -------
MILLER       10 CLERK         1300
CLARK        10 MANAGER       1500
KING         10 PRESIDENT     5000
FORD         20 ANALYST       6000 (6000 = 3000 + 3000)
SCOTT        20 ANALYST       6000 (6000 = 3000 + 3000)
SMITH        20 CLERK         1900 (1900 = 800 + 1100)
ADAMS        20 CLERK         1900 (1900 = 800 + 1100)
JONES        20 MANAGER       2975
JAMES        30 CLERK          950
BLAKE        30 MANAGER       2850
MARTIN       30 SALESMAN      5600
TURNER       30 SALESMAN      5600
WARD         30 SALESMAN      5600
ALLEN        30 SALESMAN      5600
IVANOV       50 STUDENT          0

Варіант класичного рішення з вкладеними підзапитами 
з рішень 1-го та 2-го завдань.
*/

WITH 
emp_sum_sal AS (
	SELECT 
	    deptno, 
		job, 
		SUM(sal) AS sum_sal 
	FROM emp 
	GROUP BY deptno, job
)
SELECT 
    e.ename, 
	e.deptno, 
	e.job, 
	s.sum_sal
FROM 
    emp e, 
    emp_sum_sal s
WHERE 	
    e.deptno = s.deptno 
	AND e.job = s.job
ORDER BY e.deptno, e.job;

/* Завдання 4:
Отримати прізвище, підрозділ, посаду, дату зарахування, зарплату працівників 
з одночасним показом накопичувальної суми зарплат працівників
у їхніх підрозділах з їх посадами, 
що виплачується працівникам за кожною датою зарахування.

Приклад очікуємого результату:
ENAME    DEPTNO JOB        HIREDATE      SAL SUM_SAL
-------- ------ ---------- ---------- ------ -------
MILLER       10 CLERK      23-JAN-82    1300    1300
CLARK        10 MANAGER    09-JUN-81    1500    1500
KING         10 PRESIDENT  17-NOV-81    5000    5000
FORD         20 ANALYST    03-DEC-81    3000    3000
SCOTT        20 ANALYST    09-DEC-82    3000    6000 (6000=3000+3000)
SMITH        20 CLERK      17-DEC-80     800     800
ADAMS        20 CLERK      12-JAN-83    1100    1900
JONES        20 MANAGER    02-APR-81    2975    2975
JAMES        30 CLERK      03-DEC-81     950     950
BLAKE        30 MANAGER    01-MAY-81    2850    2850
ALLEN        30 SALESMAN   20-FEB-81    1600    1600
WARD         30 SALESMAN   22-FEB-81    1250    2850 (2850=1600+1250)
TURNER       30 SALESMAN   08-SEP-81    1500    4350 (4350=2850+1500)
MARTIN       30 SALESMAN   28-SEP-81    1250    5600
IVANOV       50 STUDENT    03-NOV-22       0       0

Варіант класичного рішення 
зі стандартним застосуванням вкладених запитів
*/

WITH emp_sum_sal AS
(
	SELECT e1.ename, e1.deptno, e1.job,
			e1.hiredate, e1.sal, e2.sal sum_sal
	FROM emp e1, emp e2
	WHERE 	e1.deptno = e2.deptno
			AND e1.job = e2.job
			AND e1.hiredate >= e2.hiredate
            -- ORDER BY e1.deptno, e1.job, e1.hiredate
)
SELECT 
    ename,
	deptno,
	job,
	hiredate,
	sal,
	sum(sum_sal) AS sum_sal
FROM emp_sum_sal
GROUP BY ename, deptno, job, hiredate, sal
ORDER BY deptno, job, hiredate;

/* Завдання 4:
Отримати прізвище, підрозділ, посаду, зарплату співробітників 
з одночасним показом відсотка (частки) зарплати кожного працівника 
від загальної зарплати за підрозділом.

Приклад очікуємого результату:
ENAME    DEPTNO JOB           SAL    PERSENT
-------- ------ ---------- ------ ----------
MILLER       10 CLERK        1300         17
CLARK        10 MANAGER      1500         19
KING         10 PRESIDENT    5000         64
FORD         20 ANALYST      3000         28
SCOTT        20 ANALYST      3000         28
SMITH        20 CLERK         800          7
ADAMS        20 CLERK        1100         10
JONES        20 MANAGER      2975         27
JAMES        30 CLERK         950         10
BLAKE        30 MANAGER      2850         30
MARTIN       30 SALESMAN     1250         13
WARD         30 SALESMAN     1250         13
TURNER       30 SALESMAN     1500         16
ALLEN        30 SALESMAN     1600         17

Варіант класичного рішення задачі 
зі стандартним застосуванням вкладених запитів
*/

WITH 
emp_sum_sal AS (
    SELECT deptno,
	sum(sal) sum_sal
	FROM emp
	GROUP BY deptno
)
SELECT
    e.ename,
	e.deptno,
	e.job,
	e.sal,
	round(100*e.sal/s.sum_sal) AS persent
FROM emp e, emp_sum_sal s
WHERE
    s.sum_sal != 0
    AND e.deptno = s.deptno 
ORDER BY e.deptno, e.job;

/* Завдання 5:
Отримати 5-ть найбільш високооплачуваних 
співробітників (прізвище, зарплата)

Приклад очікуємого результату:
ENAME       SAL
-------- ------
KING       5000
SCOTT      3000
FORD       3000
JONES      2975
BLAKE      2850

Рішення задачі зі стандартним застосуванням вкладених запитів
для СУБД Oracle версії < 12c. 
Використання системної колонки ROWNUM
*/

WITH 
emp_sort_sal AS (
    SELECT ename, sal
    FROM emp
    ORDER BY sal DESC
),
emp_sort_sal_rownum AS (
    SELECT 
	    ROWNUM AS r,
	    ename, 
	    sal 
	FROM emp_sort_sal
)
SELECT
    ename, 
	sal 
FROM emp_sort_sal_rownum
WHERE 
    r <= 5;

/* Завдання 5: 
Варіант 2 класичного рішення задачі 
для СУБД Oracle версії >= 12c
з використанням опції "Top-N"-запиту:
[ OFFSET offset { ROW | ROWS } ]
[ FETCH { FIRST | NEXT } [ { rowcount | percent PERCENT } ]
    { ROW | ROWS } { ONLY | WITH TIES } ]
*/

SELECT 
    ename, 
	sal 
FROM Emp 
ORDER BY sal DESC
FETCH FIRST 5 ROWS ONLY;

/* Завдання 6:
Отримати список співробітників (прізвище, підрозділ, зарплата) 
із найбільшими зарплатами всередині кожного підрозділу.

Приклад очікуємого результату:
ENAME    DEPTNO    SAL
-------- ------ ------
IVANOV       50      0
BLAKE        30   2850
KING         10   5000
FORD         20   3000
SCOTT        20   3000

Варіант класичного рішення задачі 
зі стандартним застосуванням вкладених запитів
*/

WITH
emp_sum_sal AS (
    SELECT 
	    deptno, 
	    MAX(sal) max_sal 
	FROM emp 
	GROUP BY deptno
)
SELECT 
    e1.ename, 
	e1.deptno, 
	e1.sal
FROM emp e1
WHERE 
    EXISTS (
		SELECT *
		FROM emp_sum_sal e2
		WHERE e2.deptno = e1.deptno 
			AND e2.max_sal = e1.sal
	);

/* Завдання 7:
Отримати двох співробітників (прізвище, підрозділ, зарплата) 
з найменшими зарплатами всередині кожного підрозділу.

Рішення ??????

*/

SELECT ename, deptno, sal 
FROM emp
ORDER BY deptno ASC, sal DESC;

-- перший крок ???
select e1.deptno, e1.sal
  from (
         select e2.deptno, e2.sal,
                (
                  select count(1)
                    from emp e0
                   where e2.deptno = e0.deptno
                     and e2.sal >= e0.sal
                ) as rn
           from emp e2
		   order by deptno, rn desc
       ) e1
 where rn <= 2
 ORDER BY e1.deptno;

/* **************************************** ********************************
ЕТАП 1. ПІДРАХУНОК РЕЗУЛЬТАТІВ ЗА ГРУПАМИ І ПОРЯДОК ОБЧИСЛЕННЯ 
					(PARTITION BY, ORDER BY) 
* ************************************************** ********************** */

/*
Аналітичні функції мають наступний синтаксис:
<назва_функції>(<аргумент>,< аргумент >, . . . ) 
OVER ( <опис_зрізу_даних>)

Варіанти визначення <назва_функції>:
1) стандартні статистичні функції (функції агрегації) (COUNT, SUM, …);
2) додаткові функції.

<опис_зрізу_даних> включає секції:
1) угруповання;
2) упорядкування;
3) вікна.

*/

/*
Секція угруповання - PARTITION BY. 
Особливості:
1) логічно розбиває результуючу множину на групи;
2) синтаксис:
    PARTITION BY вираз [,вираз] [, вираз] 
3) не зменшує деталізації результату:
3.1) аналітичні функції застосовуються до кожної групи незалежно
3.2) для кожної нової групи значення функцій скидаються;
3.3) якщо не вказати конструкцію угруповання, вся результуюча множина 
    вважається однією групою. 
*/

/* Завдання 1:
Отримати прізвище, підрозділ, посаду працівників 
з одночасним показом сумарної зарплати працівників у їхніх підрозділах 
з їх посадами.

Приклад очікуємого результату:
ENAME    DEPTNO JOB        SUM_SAL
-------- ------ ---------- -------
MILLER       10 CLERK         1300
CLARK        10 MANAGER       1500
KING         10 PRESIDENT     5000
FORD         20 ANALYST       6000
SCOTT        20 ANALYST       6000
SMITH        20 CLERK         1900
ADAMS        20 CLERK         1900
JONES        20 MANAGER       2975
JAMES        30 CLERK          950
BLAKE        30 MANAGER       2850
TURNER       30 SALESMAN      5600
MARTIN       30 SALESMAN      5600
WARD         30 SALESMAN      5600
ALLEN        30 SALESMAN      5600
IVANOV       50 STUDENT          0

Рішення задачі використовує секцію угруповання PARTITION BY
*/

SELECT 
    ename, 
	deptno, 
	job,
	SUM(sal) OVER (PARTITION BY deptno, job) sum_sal 
FROM emp;

/*
Секція упорядкування ORDER BY.
Особливості:
1) задає критерій сортування даних у кожній групі;
2) синтаксис ORDER BY:
2.1) <вираз> [ASC | DESC] [NULLS FIRST | NULLS LAST];
2.2) NULLS FIRST та NULLS LAST вказує, 
    де при упорядкуванні мають бути значення NULL - на початку чи наприкінці;
3) рядки упорядковуються лише у межах груп.
*/

/* Завдання 2:
Отримати прізвище, підрозділ, посаду, дату зарахування, зарплату працівників 
з одночасним показом накопичувальної суми зарплат працівників 
у їхніх підрозділах з їх посадами, 
що виплачується ним за кожною датою зарахування.

Приклад очікуємого результату:
ENAME    DEPTNO JOB        HIREDATE      SAL SUM_SAL
-------- ------ ---------- ---------- ------ -------
MILLER       10 CLERK      23-JAN-82    1300    1300
CLARK        10 MANAGER    09-JUN-81    1500    1500
KING         10 PRESIDENT  17-NOV-81    5000    5000
FORD         20 ANALYST    03-DEC-81    3000    3000
SCOTT        20 ANALYST    09-DEC-82    3000    6000
SMITH        20 CLERK      17-DEC-80     800     800
ADAMS        20 CLERK      12-JAN-83    1100    1900
JONES        20 MANAGER    02-APR-81    2975    2975
JAMES        30 CLERK      03-DEC-81     950     950
BLAKE        30 MANAGER    01-MAY-81    2850    2850
ALLEN        30 SALESMAN   20-FEB-81    1600    1600
WARD         30 SALESMAN   22-FEB-81    1250    2850
TURNER       30 SALESMAN   08-SEP-81    1500    4350
MARTIN       30 SALESMAN   28-SEP-81    1250    5600
IVANOV       50 STUDENT    03-NOV-22       0       0

Рішення використовує секцію упорядкування ORDER BY
*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal, 
	SUM(sal) OVER (
	             PARTITION BY deptno, job 
		         ORDER BY hiredate
			 ) sum_sal 
FROM emp; 

/*
Коментарі до попереднього рішення:
1) у запиті без секції впорядкування у кожному рядку по співробітнику
 виводиться загальна сума зарплат по всій групі співробітників, 
 логічно згрупованих за підрозділом та посадою;
2) у запиті із секцією упорядкування у кожному рядку по співробітнику 
 виводиться сума зарплат попередніх рядків, 
 які раніше з урахуванням дати зарахування працівників, 
 підсумовованих із зарплатою цього співробітника;
*/

/* Завдання 3: Отримати прізвища співробітників з датою зарахування, зарплатою. 
Для кожного рядка визначити витрати компанії на зарплату співробітникам 
на вказану поточну дату

Приклад очікуємого результату:
ENAME    HIREDATE      SAL SUM_SAL
-------- ---------- ------ -------
SMITH    17-DEC-80     800     800
ALLEN    20-FEB-81    1600    2400
WARD     22-FEB-81    1250    3650
JONES    02-APR-81    2975    6625
BLAKE    01-MAY-81    2850    9475
CLARK    09-JUN-81    1500   10975
TURNER   08-SEP-81    1500   12475
MARTIN   28-SEP-81    1250   13725
KING     17-NOV-81    5000   18725
JAMES    03-DEC-81     950   22675
FORD     03-DEC-81    3000   22675
MILLER   23-JAN-82    1300   23975
SCOTT    09-DEC-82    3000   26975
ADAMS    12-JAN-83    1100   28075
IVANOV   03-NOV-22       0   28075

*/

SELECT 
    ename, 
	hiredate, 
	sal, 
	SUM(sal) OVER (ORDER BY hiredate) sum_sal
FROM emp;

/*
Коментар до рішення: 
1) без секції групування групою вважається всі рядки;
2) у кожному рядку по співробітнику виводиться сума зарплат попередніх рядків, 
 які раніше з урахуванням дати зарахування працівників, 
 підсумовованих із зарплатою цього співробітника;
3) для рядків з однаковими значеннями дати зарахування зарплати 
 підсумовуються в цій умовній групі, 
 оскільки виконано за співробітниками James та Ford
*/

/* Завдання 4: Вибрати поточні витрати компанії на зарплату співробітникам 
з розбивкою за місяцями та роками їх зарахування

Приклад очікуємого результату:
       M          Y   SUM_SAL
---------- ---------- -------
        12       1980     800
         2       1981    3650
         4       1981    6625
         5       1981    9475
         6       1981   10975
         9       1981   13725
        11       1981   18725
        12       1981   22675
         1       1982   23975
        12       1982   26975
         1       1983   28075
        11       2022   28075

*/

WITH 
m_y_sal AS (
    SELECT 
	    extract (month from hiredate) m,
	    extract (year from hiredate) y, 
		sal 
		FROM emp
),
m_y_sal_sum AS (
    SELECT m,y,SUM(sal) sal from m_y_sal group by m,y
)
SELECT 
    m, 
	y, 
	SUM(sal) OVER (ORDER BY y,m) sum_sal 
FROM m_y_sal_sum;

/*
Коментарі до рішення:
1) використовуються вкладені запити з оператором WITH
2) запит m_y_sal вибирає зарплати працівників за місяцями 
 та роками їх зарахування на роботу
3) запит m_y_sal_sum об'єднує зарплати працівників, 
зарахованих в один місяць 
*/

/* 
Завдання 4: 
Варіант 2 рішення без попереднього угруповання
*/

WITH 
m_y_sal AS (
    SELECT 
	    extract(month FROM hiredate) AS m,
	    extract (year FROM hiredate) AS y, 
		sal 
	FROM emp
)
SELECT 
    m, 
	y, 
	SUM(sal) OVER (ORDER BY y,m) AS sum_sal 
FROM m_y_sal;

/*
Завдання 5: Вибрати поточні витрати компанії на зарплату співробітникам 
з розбивкою по місяцім за всі роки роботи компанії

Приклад очікуємого результату:
         M          Y SUM_SAL
---------- ---------- -------
        11       1980       0
        12       1980     800
         1       1981     800
         2       1981    3650
         3       1981    3650
         4       1981    6625
         5       1981    9475
         6       1981   10975
         7       1981   10975
         8       1981   10975
         9       1981   13725
        10       1981   13725
        11       1981   18725
        12       1981   22675
         1       1982   23975
         2       1982   23975
         3       1982   23975
         4       1982   23975
         5       1982   23975
         6       1982   23975
         7       1982   23975
...

*/

WITH 
m_y_sal AS (
    SELECT 
	    extract (month from hiredate) AS m, 
		extract(year from hiredate) AS y, 
		sal 
	FROM emp
),
m_y_sal_sum AS (
    SELECT
	    m,
		y,
		SUM(sal) AS sal
	FROM m_y_sal 
	GROUP BY m,y
),
month_list AS (
    SELECT 
	    ROWNUM AS m
	FROM dual 
	CONNECT BY LEVEL <= 12
),
year_list AS (
    SELECT distinct extract(year FROM hiredate) AS y 
	FROM emp
),
month_year_list AS (
	SELECT y, m
	FROM month_list, year_list
),
m_y_sal_sum_add AS (
	SELECT l.y,l.m,NVL(s.sal,0) sal 
	FROM month_year_list l LEFT JOIN m_y_sal_sum s 
	    ON (l.m = s.m AND l.y = s.y) 
)
SELECT 
    m,
    y,
	SUM(sal) OVER (ORDER BY y,m) AS sum_sal 
FROM m_y_sal_sum_add;

/*
Коментарі до попереднього рішення:
1) використовуються вкладені запити з оператором WITH
2) запит m_y_sal вибирає зарплати працівників за місяцями та роками 
 їх зарахування на роботу
3) запит m_y_sal_sum об'єднує зарплати працівників, зарахованих в один місяць і рік
4) запит month_list генерує множину номерів місяців 
 для будь-якого майбутнього року зарахування
5) запит year_list вибирає унікальну множину років зарахування співробітників
6) запит month_year_list вибирає множину місяців і років 
 в діапазоні дат зарахування співробітників на основі декартового твору 
 двох множин з попередніх запитів
7) запит m_y_sal_sum_add вибирає множину усіх місяців і років із month_year_list
*/

/*************************************************************************
ЕТАП 2. СЕКЦІЯ ВІКНА
********************** ****************************************************/

/*
Особливосты секції вікна:
1) дозволяє задати вікно, що переміщається або жорстко прив'язане. 
для набору даних у межах групи, з якою працюватиме аналітична функція;
2) використовується за наявності секції упорядкування;

Cинтаксис:
[RANGE | ROWS ] <початок_вікна> або
[ RANGE | ROWS ] BETWEEN <початок_вікна> AND <кінець_вікна>
RANGE - вікно за діапазоном значень даних (логічний інтервал)
ROWS - вікно зі зміщення щодо поточного рядка (фізичний інтервал)

Значення <початок_вікна>, <кінець_вікна>:
1) UNBOUND PRECEDING - нижня межа, що переміщається;;
2) <значення> PRECEDING – фіксований нижній кордон;
3) CURRENT ROW – поточний рядок;
4) <значення> FOLLOWING – фіксований верхній кордон;
5) UNBOUNDED FOLLOWING – верхня межа, що переміщається;
За замовчуванням:
<початок_вікна> = UNBOUNDED PRECEDING, 
<кінець_вікна> = CURRENT ROW

*/

/* Завдання 1: Отримати прізвище, підрозділ, посаду, дату зарахування, зарплату працівників 
з одночасним показом накопичувальної суми зарплат працівників 
у їх підрозділах за кожною датою зарахування.

Приклад очікуємого результату:
ENAME    DEPTNO JOB        HIREDATE      SAL SUM_SAL
-------- ------ ---------- ---------- ------ -------
MILLER       10 CLERK      23-JAN-82    1300    1300
CLARK        10 MANAGER    09-JUN-81    1500    1500
KING         10 PRESIDENT  17-NOV-81    5000    5000
FORD         20 ANALYST    03-DEC-81    3000    3000
SCOTT        20 ANALYST    09-DEC-82    3000    6000
SMITH        20 CLERK      17-DEC-80     800     800
ADAMS        20 CLERK      12-JAN-83    1100    1900
JONES        20 MANAGER    02-APR-81    2975    2975
JAMES        30 CLERK      03-DEC-81     950     950
BLAKE        30 MANAGER    01-MAY-81    2850    2850
ALLEN        30 SALESMAN   20-FEB-81    1600    1600
WARD         30 SALESMAN   22-FEB-81    1250    2850
TURNER       30 SALESMAN   08-SEP-81    1500    4350
MARTIN       30 SALESMAN   28-SEP-81    1250    5600
IVANOV       50 STUDENT    03-NOV-22       0       0


Рішення використовує секцію упорядкування ORDER BY
*/

SELECT 
    ename,
	deptno,
	job,
	hiredate,
	sal,
	SUM(sal) OVER (
	             PARTITION BY deptno, job 
	             ORDER BY hiredate
			 ) AS sum_sal 
FROM emp; 

/*
Наступний варіант рішення повторює результат попереднього рішення,
бо використовується вікно "за замовчуванням"
*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal,
	SUM(sal) OVER ( 
	             PARTITION BY deptno, job 
	             ORDER BY hiredate 
				 ROWS BETWEEN UNBOUNDED PRECEDING 
				 AND CURRENT ROW
			 ) AS sum_sal 
FROM emp; 

/* Порівняння результатів для різних діапазонів вікон
1) ROWS BETWEEN <значення> PRECEDING AND UNBOUNDED FOLLOWING 
- нижня межа вікна фіксована - збігається з першим рядком упорядкованої 
	деяким чином групи рядків
- верхня межа повзе - збігається з поточною;
- наростаючий підсумок (кумулятивний агрегат) - розмір вікна змінюється, 
	розширюючись в один бік, і саме вікно рухається за рахунок розширення 
2) ROWS BETWEEN <значення1> PRECEDING AND <значення2> FOLLOWING 
- нижня та верхня межі фіксовані щодо поточного рядка в цій групі, 
- наприклад, 1-й рядок до поточного та 2-й рядок після поточного
– отримуємо агрегат, який ковзає, – розміри вікна фіксовані 
   (нікуди не розширюються), а саме вікно рухається (ковзає). 
*/

SELECT 
    ename, 
	deptno, 
	job, 
	hiredate, 
	sal,
	SUM(sal) OVER (
	             ORDER BY hiredate 
				 ROWS 
				     BETWEEN CURRENT ROW 
				     AND UNBOUNDED FOLLOWING
			 ) AS row_and_un_fol,
    SUM(sal) OVER (
	             ORDER BY hiredate 
				 ROWS 
				     BETWEEN UNBOUNDED PRECEDING 
				     AND CURRENT ROW
			 ) AS un_pr_and_row,
	SUM(sal) OVER (
	             ORDER BY hiredate 
				 ROWS 
				     BETWEEN UNBOUNDED PRECEDING 
				     AND UNBOUNDED FOLLOWING
			 ) un_pr_and_un_fol
FROM emp; 
 

/*
Коментарі до порівняння результатів під впливом ROWS та RANGE:
1) JAMES та FORD надійшли на роботу одночасно і 
нерозрізняються з урахуванням логічного інтервалу підсумовування 
 ("за значенням" - RANGE);
2) підсумовування за RANGE сформувало загальний результат – 
 максимальне значення для групи;
3) підсумовування по ROWS упорядкувало співробітників у "міні-групі", 
 утвореній рівними датами. 
*/

/*
Завдання 2: вибрати зарплати співробітників та їх середні зарплати 
за останні півроку на момент прийому нового співробітника

Приклад очікуємого результату:
ENAME    HIREDATE      SAL    AVG_SAL
-------- ---------- ------ ----------
SMITH    17-DEC-80     800        800
ALLEN    20-FEB-81    1600       1200
WARD     22-FEB-81    1250       1217
JONES    02-APR-81    2975       1656
BLAKE    01-MAY-81    2850       1895
CLARK    09-JUN-81    1500       1829
TURNER   08-SEP-81    1500       2206
MARTIN   28-SEP-81    1250       2015
KING     17-NOV-81    5000       2313
JAMES    03-DEC-81     950       2200
FORD     03-DEC-81    3000       2200
MILLER   23-JAN-82    1300       2167
SCOTT    09-DEC-82    3000       3000
ADAMS    12-JAN-83    1100       2050
IVANOV   03-NOV-22       0          0

*/

SELECT 
    ename, 
	hiredate, 
	sal, 
	ROUND( 
	    AVG(sal) OVER	(
	                   ORDER BY hiredate 
					   RANGE 
					       BETWEEN INTERVAL '6' MONTH PRECEDING 
					       AND CURRENT ROW 
				 )
	) AS avg_sal 
FROM emp; 

/*
Завдання 3: вибрати середню зарплату за поточним співробітником 
та попередніми двома співробітниками, згрупованим у групі за підрозділами 
і відсортованим у порядку зростання зарплати

Приклад очікуємого результату:
DEPTNO ENAME    JOB           SAL    AVG_SAL
------ -------- ---------- ------ ----------
    10 KING     PRESIDENT    5000       5000
    10 CLARK    MANAGER      1500       3250
    10 MILLER   CLERK        1300       2600
    20 SCOTT    ANALYST      3000       3000
    20 FORD     ANALYST      3000       3000
    20 JONES    MANAGER      2975       2992
    20 ADAMS    CLERK        1100       2358
    20 SMITH    CLERK         800       1625
    30 BLAKE    MANAGER      2850       2850
    30 ALLEN    SALESMAN     1600       2225
    30 TURNER   SALESMAN     1500       1983
    30 MARTIN   SALESMAN     1250       1450
    30 WARD     SALESMAN     1250       1333
    30 JAMES    CLERK         950       1150
    50 IVANOV   STUDENT         0          0

*/

SELECT
    deptno,
	ename,
	job,
	sal, 
	ROUND(AVG(sal) OVER(
	                   PARTITION BY deptno 
					   ORDER BY sal DESC 
					   ROWS 
					       BETWEEN 2 PRECEDING 
					       AND CURRENT ROW 
				   )
	) AS avg_sal
FROM emp;

/*
ЕТАП 3 - ВИДИ ВІКОННИХ ФУНКЦІЙ: АГРЕГАТНІ, РАНЖУЮЧІ, ЗМІШЕННЯ, АНАЛІТИЧНІ
*/

/* Аналітична функція ROW_NUMBER()

Повертає номер рядка у вікні для:
1) створення нумерації, що відрізняється від набір;
2) створення "ненаскрізної" нумерації - 
 виділення групи із загальної множини рядків та нумерування 
 їх окремо для кожної групи;
3) використання одночасно кількох способів нумерації – 
 нумерація не залежить від сортування рядків.
*/

/*
Завдання 1: Вибрати співробітників із зазначенням порядку 
проходження їх зарплат зі спадання та зростання

Приклад очікуємого результату:
ENAME       SAL SALBACK  SALFORWART
-------- ------ ------------- ----------
IVANOV        0            15          1
SMITH       800            14          2
JAMES       950            13          3
ADAMS      1100            12          4
WARD       1250            11          5
MARTIN     1250            10          6
MILLER     1300             9          7
CLARK      1500             7          8
TURNER     1500             8          9
ALLEN      1600             6         10
BLAKE      2850             5         11
JONES      2975             4         12
FORD       3000             3         13
SCOTT      3000             2         14
KING       5000             1         15


*/
SELECT ename, sal, 
	ROW_NUMBER() 
		OVER ( ORDER BY sal DESC) AS salback, 
	ROW_NUMBER () 
		OVER (ORDER BY sal) AS salforward
FROM emp; 

/*
Завдання 2: вибрати п'ять найбільш високооплачуваних співробітників

Приклад очікуємого результату:
ENAME       SAL
-------- ------
KING       5000
FORD       3000
SCOTT      3000
JONES      2975
BLAKE      2850

*/

WITH 
emp_sort_sal_rownum AS (
    SELECT ename, sal, 
	    ROW_NUMBER() OVER ( ORDER BY sal DESC ) AS r 
	FROM emp
)
SELECT 
    ename, 
	sal 
FROM emp_sort_sal_rownum
WHERE 
    r <= 5;

/*	
Завдання 3: вибрати п'ять найбільш низькооплачуваних співробітників

Приклад очікуємого результату:
ENAME       SAL
-------- ------
IVANOV        0
SMITH       800
JAMES       950
ADAMS      1100
MARTIN     1250

*/

WITH 
emp_sort_sal_rownum AS (
    SELECT 
	    ename, 
		sal, 
	    ROW_NUMBER() OVER (
                         ORDER BY sal ASC 
					 ) AS r 
		FROM emp
)
SELECT 
    ename, 
	sal 
FROM emp_sort_sal_rownum
WHERE 
    r <= 5;

/*
Завдання 4: вибрати співробітників із зазначенням порядку їх зарплат 
за зростанням окремо в кожній групі за підрозділом з посадою

Приклад очікуємого результату:
     NUM DEPTNO JOB        ENAME       SAL
---------- ------ ---------- -------- ------
         1     10 CLERK      MILLER     1300
         1     10 MANAGER    CLARK      1500
         1     10 PRESIDENT  KING       5000
         1     20 ANALYST    SCOTT      3000
         2     20 ANALYST    FORD       3000
         1     20 CLERK      SMITH       800
         2     20 CLERK      ADAMS      1100
         1     20 MANAGER    JONES      2975
         1     30 CLERK      JAMES       950
         1     30 MANAGER    BLAKE      2850
         1     30 SALESMAN   MARTIN     1250
         2     30 SALESMAN   WARD       1250
         3     30 SALESMAN   TURNER     1500
         4     30 SALESMAN   ALLEN      1600
         1     50 STUDENT    IVANOV        0

*/

SELECT 
    ROW_NUMBER() OVER ( 
	                 PARTITION BY deptno, 
		             job ORDER BY sal
	             ) AS num, 
    deptno, 
	job, 
	ename, 
	sal
FROM emp;

/* Завдання 5: вибрати двох співробітників 
(прізвище, підрозділ, посада, зарплата) 
із найбільшими зарплатами всередині кожного підрозділу.

Приклад очікуємого результату:
DEPTNO ENAME    JOB           SAL
------ -------- ---------- ------
    10 KING     PRESIDENT    5000
    10 CLARK    MANAGER      1500
    20 FORD     ANALYST      3000
    20 SCOTT    ANALYST      3000
    30 BLAKE    MANAGER      2850
    30 ALLEN    SALESMAN     1600
    50 IVANOV   STUDENT         0

*/

WITH 
emp_row_number AS (
    SELECT 
	    deptno,
		ename,
		job,sal, 
	    ROW_NUMBER() OVER(
		                 PARTITION BY deptno 
						 ORDER BY sal DESC
					 ) AS r 
	FROM emp
)	
SELECT 
    deptno,
	ename,
	job,
	sal 
FROM emp_row_number
WHERE r <= 2;


/* 
Аналітична функція ранжирування RANK():
1) повертає ранг рядка - позицію кожного рядка в секції результуючого набору
2) ранг обчислюється як збільшена на одиницю кількість значень рангів рядків, 
 що передують даному рядку;
3) ранг збільшується при кожній зміні значень виразів, що входять до конструкції ORDER BY;
4) рядки з однаковими значеннями отримують один і той самий ранг.

Аналітична функція ранжирування DENSE_RANK():
1) повертає ранг рядка - позицію кожного рядка у секції результуючого набору 
 без проміжків ранжування;
2) ранг обчислюється як збільшене на одиницю кількість різних значень 
 рангів рядків, що передують даному рядку;
3) ранг збільшується при кожній зміні значень виразів,
 що входять до конструкції ORDER BY;
4) рядки з однаковими значеннями отримують один і той самий ранг.
*/

/*
Завдання 6: 
тестова вибірка для порівняння алгоритмів ранжирування RANK() та DENSE_RANK():
*/
SELECT 
	ROW_NUMBER () OVER (ORDER BY sal) AS salnumber,
	RANK() OVER (ORDER BY sal) AS salrank,
	DENSE_RANK() OVER (ORDER BY sal) AS saldenserank, 
	ename, deptno, job, sal
FROM emp;

/* 
Завдання 7: для кожного співробітника показати відносний ранг 
його зарплати серед інших працівників того ж підрозділу

Приклад очікуємого результату:
ENAME    DEPTNO JOB           SAL SALDENSERANK
-------- ------ ---------- ------ ------------
MILLER       10 CLERK        1300            1
CLARK        10 MANAGER      1500            2
KING         10 PRESIDENT    5000            3
SMITH        20 CLERK         800            1
ADAMS        20 CLERK        1100            2
JONES        20 MANAGER      2975            3
SCOTT        20 ANALYST      3000            4
FORD         20 ANALYST      3000            4
JAMES        30 CLERK         950            1
MARTIN       30 SALESMAN     1250            2
WARD         30 SALESMAN     1250            2
TURNER       30 SALESMAN     1500            3
ALLEN        30 SALESMAN     1600            4
BLAKE        30 MANAGER      2850            5
IVANOV       50 STUDENT         0            1

*/

SELECT 
    ename, 
	deptno, 
	job, 
	sal,
	DENSE_RANK() OVER(
	                 PARTITION BY deptno 
					 ORDER BY sal
				 ) AS saldenserank
FROM emp;

/*
Аналітичні функції:
1) аналітичні функції не можуть бути вкладеними
2) ефект вкладеності реалізується через підзапити
*/

/*
Завдання 8: вибрати низькооплачуваних співробітників,
рівень зарплат яких знаходиться на четвертому місці

Приклад очікуємого результату:
ENAME       SAL
-------- ------
ADAMS      1100

*/

WITH 
emp_dense_rank AS (
    SELECT 
	    ename,
		sal,
		DENSE_RANK() OVER( ORDER BY sal ) AS r
	FROM emp
)
SELECT 
    ename,
	sal
FROM emp_dense_rank
WHERE 
    r = 4;

/*
Функція NTILE.
Особливості:
1) номер групи, якій належить рядок, 
 при цьому рядки розподіляються на упорядковані групи кількості
2) синтаксис:
2.1) NTILE(<кількість_груп>)
2.2) рядки розподіляються в упорядковані групи кількості з <кількість_груп>.
*/

/*
Завдання 9: вибрати співробітників із поділом на п'ять груп
для виконання паралельних завдань
з урахуванням зростання значення зарплати

Приклад очікуємого результату:
 SALNTILE ENAME       SAL
---------- -------- ------
         1 IVANOV        0
         1 SMITH       800
         1 JAMES       950
         2 ADAMS      1100
         2 MARTIN     1250
         2 WARD       1250
         3 MILLER     1300
         3 CLARK      1500
         3 TURNER     1500
         4 ALLEN      1600
         4 BLAKE      2850
         4 JONES      2975
         5 SCOTT      3000
         5 FORD       3000
         5 KING       5000

*/

SELECT 
	NTILE(5) OVER (ORDER BY sal) AS salntile, 
	ename, 
	sal 
FROM emp;

/*
Нестандартні аналітичні функції. 
Функції підрахунку часток:
1) PERCENT_RANK() - відносна позиція рядка = (RANK - 1) / (total_rows - 1),
  total_rows – загальна кількість рядків у таблиці.
2) CUME_DIST() - відносна позиція рядка групи = (row_num) / (total_rows),
  row_num – кількість рядків, що передують поточному рядку
3) RATIO_TO_REPORT(<колонка>) – частка значення колонки поточного рядка 
  у загальній сумі значень по всіх рядках
*/

/*
Завдання 10. Перевірка PERCENT_RANK()
*/

SELECT 
	RANK() OVER (ORDER BY sal) AS salrank,
	PERCENT_RANK() OVER (ORDER BY sal) AS salrank,
	ename, sal
FROM emp;

/*
Завдання 11. Перевірка CUME_DIST
*/

SELECT 
    RANK() OVER (ORDER BY sal) AS salrank,
    CUME_DIST() OVER (ORDER BY sal) AS saldist,
	ename, 
	sal
FROM emp;

/*
Завдання 12: визначити співробітників, у яких ранг (рівень) зарплат = 0.75
у групах співробітників з однаковими посадами

Приклад очікуємого результату:
JOB        ENAME       SAL  CUME_DIST
---------- -------- ------ ----------
CLERK      ADAMS      1100        .75
SALESMAN   TURNER     1500        .75

*/
 
WITH 
emp_job_dist AS (
    SELECT 
	    job, 
		ename, 
		sal, 
	    CUME_DIST() OVER (
		                PARTITION BY job 
						ORDER BY sal
					) AS cume_dist 
	FROM emp
) 
SELECT * 
FROM emp_job_dist 
WHERE 
    cume_dist = 0.75; 

/*
Завдання 13. Визначити частку зарплати кожного співробітника 
з урахуванням суми зарплат всіх співробітників

Приклад очікуємого результату:
ENAME       SAL   SALSHARE
-------- ------ ----------
KING       5000  .17809439
BLAKE      2850 .101513802
CLARK      1500 .053428317
JONES      2975 .105966162
MARTIN     1250 .044523598
TURNER     1500 .053428317
JAMES       950 .033837934
WARD       1250 .044523598
FORD       3000 .106856634
SMITH       800 .028495102
SCOTT      3000 .106856634
MILLER     1300 .046304541
IVANOV        0          0
ALLEN      1600 .056990205
ADAMS      1100 .039180766

*/

SELECT 	
    ename, 
	sal, 
	RATIO_TO_REPORT(sal) OVER () AS salshare 
FROM emp; 

/*
Завдання 14. Визначити працівників, у яких частка зарплати 
у групі співробітників з однаковими посадами дорівнює 
половині від загальної суми зарплат у цій групі.

Приклад очікуємого результату:
JOB        ENAME       SAL   SALSHARE
---------- -------- ------ ----------
ANALYST    FORD       3000         .5
ANALYST    SCOTT      3000         .5

*/

WITH 
emp_job_ratio AS (	
    SELECT 	
	    job, 
		ename, 
		sal, 
	    RATIO_TO_REPORT(sal) OVER (PARTITION BY job) AS salshare 
	FROM emp
) 
SELECT * 
FROM emp_job_ratio 
WHERE 
    salshare = 0.5;

/* 
Функція відносного розташування рядка LAG.
Особливості:
1) функція повертає значення атрибута рядка,
попередньому поточному рядку в групі зі зміщенням у зворотний бік;
2) синтаксис:
2.1) LAG(<атрибут>, [<зміщення>],[<значення за замовчуванням>])
2.2) за умовчанням <зміщення>=1 – посилання на попередній рядок;
2.3) повертається <значення за умовчанням>,
якщо індекс виходить за межі вікна,
а також для першого рядка групи.

*/

/*
Функція відносного розташування рядка LEAD.
Особливості:
1) повертає значення атрибута рядка, наступного за поточним рядком
у групі зі зміщенням у пряму сторону;
2) синтаксис:
2.1) LEAD(<атрибут>, [<зміщення>],[<значення за замовчуванням>])
2.2) за умовчанням <зміщення>=1 – посилання наступний рядок;
2.3) повертається <значення за умовчанням>,
якщо індекс виходить за межі вікна,
а також для останнього рядка групи.
*/

/*
Завдання 15. Вибрати середню зарплату працівників 
за 12 місяців усіх років та
визначити її зміну у відсотках по відношенню 
до попереднього та наступного року

Приклад очікуємого результату:
        M          Y    SUM_SAL PRIOR_YEAR      p_y_%  NEXT_YEAR      n_y_%
---------- ---------- ---------- ---------- ---------- ---------- ----------
        12       1980        800        800        100      22675       2834
        12       1981      22675        800          4      26975        119
        12       1982      26975      22675         84      28075        104
        12       1983      28075      26975         96      28075        100
        12       2022      28075      28075        100      28075        100


*/

WITH 
m_y_sal AS (
	SELECT 	EXTRACT(Month FROM HireDate) m, 
			EXTRACT (Year FROM HireDate) as y, Sal FROM emp
),
m_y_sal_sum AS (
	SELECT m, y, SUM(Sal) Sal 
	FROM m_y_sal 
	GROUP BY m, y
),
month_list AS (
	SELECT rownum as m FROM dual CONNECT BY level <= 12
),
year_list AS ( 	
	SELECT distinct extract (year from hiredate) y 
	FROM emp
),
month_year_list AS ( 
	SELECT y,m 
	FROM month_list, year_list
),
m_y_sal_sum_add AS ( 
	SELECT l.y,l.m,NVL(s.sal,0) Sal 
	from month_year_list l LEFT JOIN m_y_sal_sum s on (l.m = s.m and l.y = s.y) 
),
m_y_sal_sum2 AS ( 
	SELECT m, y, SUM(Sal) OVER (ORDER BY y, m) Sum_Sal 
	FROM m_y_sal_sum_add
),
m_y_sal_sum_l AS ( 
	SELECT m, y, Sum_Sal, 
			LAG(Sum_Sal,1,Sum_Sal) OVER	(ORDER BY y, m)	Prior_Year, 
			LEAD(Sum_Sal, 1, Sum_Sal) OVER (ORDER BY y, m) Next_Year 
	FROM m_y_sal_sum2 where m = 12
)
SELECT 	m,y,sum_sal,prior_year,ROUND(100*prior_year/sum_sal) "p_y_%",
		next_year, ROUND(100*next_year/sum_sal) "n_y_%" 
FROM m_y_sal_sum_l;

/*
Функції відносного розташування рядка FIRST_VALUE,LAST_VALUE
Особливості:
1) застосовуються для вибору максимального 
 або мінімального значення в результуючому наборі;
2) синтаксис:
2.1) FIRST_VALUE(<атрибут>) - повертає перше значення атрибута рядка групи;
2.2) LAST_VALUE(<атрибут>) - повертає останнє значення атрибута рядка групи;
2.3) NTH_VALUE(<атрибут>, <зміщення>) - повертає перше значення атрибута рядка
у групі із зазначеним усуненням (для Oracle 11g);
3) функції еквівалентні при використанні секції впорядкування ASC і DESC.
*/

/*
Завдання 16. 
Вибрати співробітників, їхню зарплату, 
відсоток від максимальної зарплати співробітника,
відсоток від мінімальної зарплати співробітника у тому самому підрозділі.

Приклад очікуємого результату:
DEPTNO ENAME       SAL    MAX_SAL  max_sal_%    MIN_SAL  min_sal_%
------ -------- ------ ---------- ---------- ---------- ----------
    10 KING       5000       5000        100       1300         26
    10 CLARK      1500       5000        333       1300         87
    10 MILLER     1300       5000        385       1300        100
    20 SCOTT      3000       3000        100        800         27
    20 FORD       3000       3000        100        800         27
    20 JONES      2975       3000        101        800         27
    20 ADAMS      1100       3000        273        800         73
    20 SMITH       800       3000        375        800        100
    30 BLAKE      2850       2850        100        950         33
    30 ALLEN      1600       2850        178        950         59
    30 TURNER     1500       2850        190        950         63
    30 MARTIN     1250       2850        228        950         76
    30 WARD       1250       2850        228        950         76
    30 JAMES       950       2850        300        950        100

*/

WITH 
emp_first_last_sal AS ( 
    SELECT 
	    deptno, ename, sal,
	    FIRST_VALUE(sal) OVER (
		                     PARTITION BY deptno ORDER BY sal DESC 
				             rows 
							     between unbounded preceding 
							     and unbounded following
						 ) as max_sal, 
	    LAST_VALUE(sal) OVER (
		                     PARTITION BY deptno ORDER BY sal DESC 
				             rows 
							     between unbounded preceding 
								 and unbounded following
						) as min_sal 
	FROM emp 
)
SELECT 
    deptno, 
	ename, 
	sal,max_sal, 
	round(100*max_sal/sal) AS "max_sal_%", 
	min_sal,
	round(100*min_sal/sal) AS "min_sal_%" 
FROM emp_first_last_sal 
WHERE 
    sal != 0
ORDER BY deptno;

/*
Загальні висновки щодо використання аналітичних функцій:

1) Лаконічне та просте формулювання.
Багато аналітичних запитів до БД традиційними засобами 
складно формулюються,
тому важко осмислюються і погано піддаються налагодженню.

2) Зниження навантаження на мережу.
Те, що стандартними засобами формулюється лише серією запитів,
тепер згортається в один запит.
По мережі надсилається лише запит 
та повертається вже остаточний результат.

3) Перенесення обчислень на сервер.
З використанням аналітичних функцій немає потреби 
організовувати розрахунки на клієнті -
вони повністю виконуються на сервері,
ресурси якого можуть ефективніше використовуватися
для швидкого оброблення великих обсягів даних.

4) Найкраща ефективність обробки запитів.
Алгоритми обчислення аналітичних функцій пов'язані
зі спеціальними планами обробки запитів,
оптимізованими для більшої швидкості одержання результату.

*/

/* 
Лекція  "Вбудовані функції Oracle для перетворення даних"
*/

SET LINESIZE 2000
SET PAGESIZE 100

/* 
Функції перетворення регістру символів рядків:
LOWER('SQL Course')
UPPER('SQL Course')
INITCAP('SQL Course')
*/

-- Отримання інформації про співробітника на ім'я petrov
-- Передбачається, що ім'я отримано у нижньому регістрі
SELECT empno, ename, deptno
FROM emp
WHERE 
    ename = 'petrov';

-- Отримання співробітника на ім'я petrov
-- (успішний варіант 1)
-- недолік - затримка на зміну значення колонки у всіх рядках 
SELECT empno, ename, deptno
FROM emp
WHERE 
    LOWER(ename) = 'petrov';

-- Отримання співробітника на ім'я petrov
-- (успішний, ефективний варіант)
-- перевага - зміна значення лише одного рядка
SELECT empno, ename, deptno
FROM emp
WHERE 
    ename = UPPER('Petrov');
	 
-- Отримання імен співробітників у форматі:
-- Перша літера - велика, інші - маленькі
SELECT 
    empno, 
    INITCAP(ename) AS ENAME
FROM emp; 

/*
Функції маніпулювання символами:
CONCAT(рядок1, рядок2) - конкатенація лише двох рядків
SUBSTR(рядок,початок виділення,довжина) - виділення підрядка з рядка
LENGTH(рядок) - визначення довжини рядка у символах
INSTR(рядок, підрядок) - визначення початку знаходження підрядка у рядку
LPAD(рядок,кількість,символ) - доповнення рядка зліва символами до заданої довжини рядка
RPAD(рядок,кількість,символ) - доповнення рядка праворуч символами до заданої довжини рядка
LTRIM (рядок, символ) - видалення символів зліва
RTRIM (рядок, символ) - видалення символів праворуч
*/
	
-- Отримання результатів виконання функцій CONCAT, LENGTH, INSTR
-- для співробітника, перші дві літери якого збігаються з 'PE'
SELECT 
    ename, 
    CONCAT(ename, job) AS CONCAT, 
    LENGTH(ename) AS LEN, 
    INSTR(ename, 'T') AS INSTR
FROM emp
WHERE 
    SUBSTR(ename,1,2) = 'PE';
			
-- Отримання результатів виконання функцій LPAD, RPAD, LTRIM, RTRIM
-- для співробітника, перші дві літери якого збігаються з 'PE'
SELECT 
    ename, 
    LPAD(ename,10,'+') AS LPAD,
    RPAD(ename,10,'+') AS RPAD,
    LTRIM(ename,'P') AS LTRIM,
    RTRIM(ename,'V') AS RTRIM
FROM emp
WHERE 
    SUBSTR(ename,1,2) = 'PE';

-- Отримання довжини імен усіх працівників
SELECT 
    ename,
	LENGTH(ename)
FROM emp;

-- Отримання мінімальної довжини імені співробітника
SELECT MIN(LENGTH(ename))
FROM emp;

/*
Числові функції
ROUND: округляє значення до вказаного виду
ROUND(45.926, 2) = 45.93
TRUNC: округляє у менший бік до зазначеного виду
TRUNC(45.926, 2) = 45.92
MOD: повертає залишок від ділення
MOD(1600, 300) = 100
*/
			
-- Перевірка роботи функції ROUND
SELECT 
    ROUND(45.925), 
	ROUND(45.923,0),
	ROUND(45.923,-1)
FROM DUAL;
	
-- Перевірка роботи функції TRUNC
SELECT 	
    TRUNC(45.923,2), 
	TRUNC(45.923),
	TRUNC(45.923,-1)
FROM DUAL;
	
-- Отримання залишку від ділення
SELECT 
    ename, 
    sal, 
	MOD(sal, 30)
FROM emp;

/* 

Функції роботи з датами

*/
	
-- Отримання поточної дати (використання вбудованої таблиці DUAL)
SELECT SYSDATE FROM DUAL;

-- Зміна формату дати
ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy';

-- Отримання кількох тижнів періоду часу роботи співробітників
SELECT 
    ename, 
    ROUND((SYSDATE-hiredate)/7) WEEKS
FROM emp;

-- Отримання кількості місяців у часовому періоді
-- (враховувати локалізацію)
SELECT MONTHS_BETWEEN (SYSDATE,'01/01/2020') 
FROM DUAL;

-- Отримання дати через 6 місяців від зазначеної дати,
-- дати останнього місяця від зазначеної дати,
-- Дати найближчого дня тижня від зазначеної дати
SELECT 
	ADD_MONTHS ('20.10.2011',6),
	LAST_DAY('20-10-2011'),
	NEXT_DAY ('20/10/2011','FRIDAY') 
FROM DUAL;
		
-- Отримання дати для найближчої п'ятниці після 01.01.2023 (Новий рік!)
SELECT NEXT_DAY ('01/01/2023','FRIDAY') 
FROM dual;

-- Визначення дня тижня зарахування на роботу працівника
SELECT hiredate-TRUNC(hiredate,'DAY') AS Week_Num,hiredate, to_char(hiredate,'DAY'), hiredate
FROM emp;

/* 

Функції перетворення типів:
1) неявне перетворення типів;
	char, varchar -> number
	date -> varchar
	number -> varchar

2) явне перетворення типів:
	to_number
	to_char
	to_date

*/

/*

Функція TO_CHAR для дат
TO_CHAR(date, 'fmt')
Модель формату:
1) Заключається в одинарні лапки і чутлива до регістру
2) Може включати коректні елементи форматування
3) Елемент fm служить для видалення зайвих пробілів і попередніх нулів
4) Відокремлений від дати комою

Елементи формату:
YEAR		Рік.
YYYY		4-значний рік.
YYY,YY,Y	Останні 3, 2 або 1 цифра(и) року.
Q			Квартал року (1, 2, 3, 4; JAN-MAR = 1).
MM			Місяць (01-12; JAN = 01).
MON			Скорочена назва місяця.
MONTH		Назва місяця, доповнена пробілами довжиною до 9 символів.
RM			Римська цифра RM (I-XII; JAN = I).
WW			Тиждень року (1-53), де тиждень 1 починається 
			в перший день року і продовжується до сьомого дня року.
W			Тиждень місяця (1-5), де тиждень 1 починається
			першого дня місяця і закінчується сьомим.
IW			Тиждень року (1-52 або 1-53) на основі стандарту ISO.
D			День тижня (1-7).
DAY			Назва дня.
DD			День місяця (1-31).
DDD			День року (1-366).
DY			Скорочена назва дня.
J			юліанський день; кількість днів з 1 січня 4712 до н.е.
HH12		Час дня (1-12).
HH24		Час дня (0-23).
MI			Хвилини (0-59).
SS			Секунди (0-59).
SSSSS		Секунди після опівночі (0-86399).
FF			Дробні секунди.

*/

-- Отримання дати у спец. форматі
SELECT 
    ename, 
    TO_CHAR(hiredate, 'fmDD Month YYYY') HIREDATE1,
    TO_CHAR(hiredate, 'DD Month YYYY') HIREDATE2
FROM emp;

-- Отримання дати у спец. форматі
SELECT 
    ename, 	
    TO_CHAR(hiredate, '"(" DY-DAY ")" DD Month "of" YYYY "year"') HIREDATE
FROM emp;

-- Функція повертає тип даних CHAR, тому іноді праворуч від рядка результату можуть розташовуватися пробіли,
-- які бажано прибирати функцією RTRIM
SELECT 
    LENGTH(TO_CHAR(hiredate,'DAY')),
	RTRIM(TO_CHAR(hiredate,'DAY'))
FROM emp;

/*
Функція TO_CHAR для чисел
1) використовується для отримання символьного представлення чисел
	з попереднім перетворенням форми
2) TO_CHAR(number, 'fmt')
Елементи формату:
9 - цифра
. - десяткова крапка
, - кома-роздільник тисяч

*/

-- Отримання зарплати у форматі $99,999 для співробітника на ім'я SCOTT
SELECT 
    TO_CHAR(sal,'$99,999') SALARY
FROM emp;

/*

Функції TO_NUMBER та TO_DATE:
TO_NUMBER(char[, 'fmt']) - перетворення символьного рядка до числа
TO_DATE(char[, 'fmt']) - Перетворення символьного рядка до виду дати

*/
-- Перетворення рядка з датою формату "11 October 2012 year" на дату поточного формату
SELECT 
    TO_DATE('11 October 2012 year','DD Month YYYY "year"') 
FROM dual;

-- Перетворення рядка з датою формату "The October of 11th 2012 year"
-- у рядок з датою формату "2012/11/10"
SELECT 
    TO_CHAR(TO_DATE(
	    'The October of 11th 2012 year','"The" Month "of" DD"th" YYYY "year"'
	),'YYYY/DD/MM')
FROM dual;

/*
Як позбутися NULL? Функція NVL
1) Перетворює null на реальне значення
2) Може використовуватися для дат, символьних та числових даних.
3) Типи даних повинні співпадати

*/

-- Отримання зарплати співробітників за рік
-- з урахуванням NULL-значень у комісійних
SELECT 
    ename, 
	sal, 
	comm, 
	(sal*12)+NVL(comm,0)
FROM emp;

/*
Функція DECODE
1) схожа на вираз CASE або IF-THEN-ELSE стандарту SQL
CASE <вираз, що перевіряється>
  WHEN <вираз 1, що порівнюється>
  THEN <значення 1, що повертається>
  …
  WHEN <вираз N, що порівнюється>
  THEN <значення N, що повертається>
  [ELSE <значення, що повертається]
END

2) Полегшує виконання умовних запитів

3) шаблон
DECODE(col/expression, search1, result1 
      			   [, search2, result2,...,]
      			   [, default])

*/	

-- Отримання надбавки до зарплати з урахуванням посади співробітника.
-- SQL-стандарт
SELECT job, sal,
	CASE 
		WHEN job = 'DIRECTOR' THEN SAL*1.1
		WHEN job = 'SALESMAN' THEN SAL*1.15
		WHEN job = 'MANAGER' THEN SAL*1.20
		ELSE SAL
	END AS REVISED_SALARY
	FROM emp;

-- Отримання надбавки до зарплати з урахуванням посади співробітника.
-- Функція DECODE
SELECT 
    job, 
	sal,
	DECODE(job, 'DIRECTOR',  SAL*1.1,
                     'SALESMAN',   SAL*1.15,
                     'MANAGER', SAL*1.20,
                                SAL
	) AS REVISED_SALARY
FROM emp;

	







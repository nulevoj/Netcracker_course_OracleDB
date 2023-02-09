/* 
Приклади простих INSERT-команд
*/

SET LINESIZE 2000
SET PAGESIZE 100

-- Шаблон  простої INSERT-команди
INSERT INTO	table [(column [, column...])]
	VALUES (value [, value...]);

/* Особливості всіх SQL-команд 
- Команди SQL не чутливі до регістру. 
- Команди SQL можуть складатися з одного або декількох рядків.
- Ключові слова не можуть переноситися та скорочуватися.
- Команди можуть можуть розміщуватися в різних рядках.
- Відступи використовуються для покращення візуального сприйняття коду 
та його читальності (Code Conventions).
- Команда SQL завершується символом (;)
*/

-- внесення рядку з локацією без вказівки назв стовпців
INSERT INTO Loc 
VALUES (1,'ODESA');

-- внесення рядка з локацією із зазначенням назв стовпців
INSERT INTO Loc 
    (locno, lname) 
VALUES (2,'KYIV');

-- спроба внесення рядка з існуючим значенням первинного ключа
INSERT INTO Loc 
    (locno, lname) 
VALUES (1,'NEW_ODESA');

-- спроба повторного внесення рядка із існуючим значенням потенційного ключа
INSERT INTO Loc 
   (locno, lname) 
VALUES (3,'ODESA');

-- внесення рядка з локацією із зазначенням назв стовпців
INSERT INTO Loc 
   (locno, lname) 
VALUES (3,'NEW_ODESA');

-- внесення рядка з підрозділом, розташованим у локації ODESA
INSERT INTO Dept 
   (deptno, dname, locno) 
VALUES (1,'NC OFFICE',1);

-- спроба внесення рядка з підрозділом, розташованим у неіснуючій локації 
-- (FK не збігається з існуючим PK)
INSERT INTO Dept 
   (deptno, dname, locno) 
VALUES (2,'NC OFFICE 2',4);

-- додавання нової колонки opendate - дата відкриття підрозділу
ALTER TABLE Dept ADD opendate date;

-- внесення рядка з підрозділом з невизначеною датою відкриття (стовпець opendate)
INSERT INTO Dept 
   (deptno, dname, locno) 
VALUES (2,'NC OFFICE 2',2);

-- внесення ще одного рядка з підрозділом з невизначеною датою відкриття
INSERT INTO Dept 
   (deptno, dname, locno, opendate) 
VALUES (3,'NC OFFICE 3',2,NULL);

-- спроба внесення ще одного рядка з підрозділом з датою відкриття
INSERT INTO Dept 
   (deptno, dname, locno, opendate) 
VALUES (4,'NC OFFICE 4',2,'01/09/2021');

-- встановлення бажаного формату ввесення дати = 'dd/mm/yyyy'
ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy';

-- внесення ще одного рядка з підрозділом з датою відкриття
INSERT INTO Dept 
   (deptno, dname, locno, opendate) 
VALUES (4,'NC OFFICE 4',2,'01/09/2021');

-- внесення рядка із співробітником, у якого немає керівника та комісійних 
-- (явне використання значення NULL)
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (1,'KING','DIRECTOR',NULL,'01/01/2020',5000,NULL,1);

-- внесення рядка із співробітником, у якого є керівник (KING) та комісійні
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (2,'TOD','MANAGER',1,'01/02/2020',4000,1000,1);

-- внесення рядка із співробітником, у якого є керівник
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (3,'SCOTT','MANAGER',1, '15/02/2020',3000,NULL,3);

-- внесення рядка із співробітником, у якого є керівник та комісійні
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (4,'BLAKE','SALESMAN',3,'10/03/2020',3500,500,3);

-- внесення рядка із співробітником, у якого є керівник та комісійні
INSERT INTO Emp 
   (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
VALUES (5,'ALLEN','SALESMAN',3,'20/04/2020',3000,500,3);


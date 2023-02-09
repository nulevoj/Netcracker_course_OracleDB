/* ������ "�������� ���������� (Unit Testing) PL/SQL ���� Oracle".
������� 3 - �������� ���������� � ������������� ������ utPLSQL

-- ���� ������� utPLSQL (���������, ������, ���� ����� VPN )
http://www.utplsql.org/

-- GitHub-���������� ������� utPLSQL
https://github.com/utPLSQL/utPLSQL


/* ���������� utPLSQL
*/

https://github.com/utPLSQL/utPLSQL/releases/download/v3.1.13/utPLSQL.zip
unzip utPLSQL.zip
cd ./utPLSQL/source


-- �������� ������
chmod +x ./install.sh
./install.sh

/* ���������� ����� � ����� ����� ����������� student10 */
sqlplus sys@localhost:1521/XEPDB1 as sysdba 

@create_utplsql_owner.sql student10 p1234 users
@install.sql student10
grant execute on DBMS_CRYPTO to student10;
@install_ddl_trigger.sql student10
@create_synonyms_and_grants_for_public.sql student10
@create_user_grants.sql student10

/*
��������� ���������� ������� ��� ���������� 
�������������� �������� �� �����-��������� 
� ���������� ��� �������� ���� �������������, ������������:
1) ��������� ������� ������������ ����� �� �������� ������ 
	� ��������� �����; 
2) ������ �� ������ ���������� ��������������� �����
3) ���������� �������� �� ����� ���������� ��������� ����������, 
	���������, JUnit. 
4) ������������ ������ ��������� ���������� ������, 
�� ������������ �� ���������� ������� ��� ���������� ����������

���� ������� �������� �� ��������� ���������:
--%name(text)
��  name - ����� ��������
	text - ������������� ����������������� �����
�������� ���������� ��:
- �������� ���� ������;
- �������� ���� ���������.

�������� �������� �������� ���� ������:
--%suite( <description> ) - ������� �� ����� ��������� ��������
	��� ���������� ��������� ���������� � �������� ������, 
	���� ���� �������� �� ����� �� ��� ����������
--%suitepath( <path> ) - �������� �������� ���������� ��������

�������� ��������� ���� ��������� �:
--%test( <description> ) - �������� �����, �� ���������/�������
	���� ����������������� ��� ���������� ����������

̳� ���������� --%suite �� --%test ����� ������� ���� ������ �����
*/

/* ��������� ������ utPLSQL 
*/

-- �������� �����
clear screen;

-- �������� ����� ��������� ���������� �� �������
SET SERVEROUTPUT ON

-- �������� PL/SQL-����� ��� ����������
CREATE OR REPLACE PACKAGE test_function AS
    --%suite(test package)
END;
/

-- ��������� ������ ���������� (1-� ������)
-- ����� �������� PL/SQL-����
BEGIN 
    ut.run(); 
END;
/
/* ��������� ���������:
test package
Finished in .013382 seconds
0 tests, 0 failed, 0 errored, 0 disabled, 0 warning(s)
*/

-- ��������� ������ ���������� (2-� ������)
-- ����� SQLPlus-��������� ������
EXEC ut.run();

-- ��������� ������ ���������� (3-� ������)
-- ����� �������� �������
SELECT * 
FROM TABLE(ut.run());

/*
�������� PL/SQL-����� ��� ���������� ������� 
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

/* ��������� ������ ���������� ������ test_package
*/
BEGIN 
    ut.run('test_package'); 
END;
/
/* ���������:
test package
Test procedure for testing function user_name_is_correct [.084 sec]
Finished in .089835 seconds
1 tests, 0 failed, 0 errored, 0 disabled, 0 warning(s)
*/

/* ��� ������������ ������ ��������� �������� ��� 2-�� �����
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

/* ��������� ������ ���������� ������ test_package
*/
BEGIN 
    ut.run('test_package'); 
END;
/

/* ���������:
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

/* ��������� ������ ���������� ��� ������
*/
BEGIN 
    ut.run(); 
END;
/


/* ������ utPLSQL ����� ��������� ����� 
��� ������������ Unit Testing in Continuous Integration
*/
https://github.com/utPLSQL/utPLSQL-cli

/* ��������� �������� ���� 
������ utplsql � �� Windows
*/
https://github.com/utPLSQL/utPLSQL-cli/releases


/* ����������� ��������� �������� ���� 
������ utplsql � �� Linux
*/

#!/bin/bash
# Get the url to latest release "zip" file
DOWNLOAD_URL=$(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL-cli/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g')
# Download the latest release "zip" file
curl -Lk "${DOWNLOAD_URL}" -o utplsql-cli.zip
# Extract downloaded "zip" file
unzip -q utplsql-cli.zip


/* ��������� ������ ���������� ��� ��� ������ 
*/
utplsql run student10/p1234@91.219.60.189:1521/XEPDB1

/* ��������� ������ ���������� ������ test_package
*/
utplsql run student10/p1234@91.219.60.189:1521/XEPDB1 -p=test_package
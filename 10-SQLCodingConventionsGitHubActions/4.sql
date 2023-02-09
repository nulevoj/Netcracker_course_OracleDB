
SELECT
	name,
    date_of_birth,
    ROUND(SYSDATE-date_of_birth) AS Days,
    ROUND((SYSDATE-date_of_birth)/7) AS Weeks,
    ROUND(MONTHS_BETWEEN (SYSDATE, date_of_birth)) AS Months
    FROM student;

/*

Code	Line / Position		Description
L004	2 / 1				Incorrect indentation type found in file.
L014	4 / 11				Unquoted identifiers must be consistently lower case.
L006	4 / 18				Missing whitespace before -
L006	4 / 18				Missing whitespace after -
L014	4 / 37				Unquoted identifiers must be consistently lower case.
L014	5 / 12				Unquoted identifiers must be consistently lower case.
L006	5 / 19				Missing whitespace before -
L006	5 / 19				Missing whitespace after -
L006	5 / 34				Missing whitespace before /
L006	5 / 34				Missing whitespace after /
L014	5 / 41				Unquoted identifiers must be consistently lower case.
L017	6 / 25				Function name not immediately followed by parenthesis.
L014	6 / 27				Unquoted identifiers must be consistently lower case.
L014	6 / 55				Unquoted identifiers must be consistently lower case.
L003	7 / 5				Expected 0 indentations, found 1 [compared to line 01]

*/

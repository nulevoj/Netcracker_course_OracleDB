
SELECT
    name,
    date_of_birth,
    ROUND(sysdate - date_of_birth) AS days,
    ROUND((sysdate - date_of_birth) / 7) AS weeks,
    ROUND(MONTHS_BETWEEN(sysdate, date_of_birth)) AS months
FROM student;

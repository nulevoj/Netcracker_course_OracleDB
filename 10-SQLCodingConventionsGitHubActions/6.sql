
CREATE OR REPLACE VIEW obj_count (
        obj_type,
        obj_count
    ) AS
    SELECT objtype.name,
            COUNT (objects.object_id)
        FROM objtype, objects
        WHERE objects.object_type_id = objtype.object_type_id
        GROUP BY objtype.name;

/*

Code	Line / Position		Description
L003	2 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	3 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	4 / 5				Expected 0 indentations, found 1 [compared to line 01]
L003	5 / 5				Expected 0 indentations, found 1 [compared to line 01]
L036	5 / 5				Select targets should be on a new line unless there is only one select target.
L003	6 / 13				Expected 0 indentations, found 3 [compared to line 01]
L013	6 / 13				Column expression without alias. Use explicit `AS` clause.
L017	6 / 18				Function name not immediately followed by parenthesis.
L003	7 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	8 / 9				Expected 0 indentations, found 2 [compared to line 01]
L003	9 / 9				Expected 0 indentations, found 2 [compared to line 01]

*/

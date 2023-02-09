
CREATE OR REPLACE VIEW obj_count (
    obj_type,
    obj_count
) AS
SELECT
    objtype.name,
    COUNT(objects.object_id) AS objects_count
FROM objtype, objects
WHERE objects.object_type_id = objtype.object_type_id
GROUP BY objtype.name;

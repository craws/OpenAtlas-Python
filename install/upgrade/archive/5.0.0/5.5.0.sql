-- Upgrade 5.4.0 to 5.5.0
-- Be sure to backup the database and read the upgrade notes before executing this!

BEGIN;

-- Remove leading and trailing white spaces from names
UPDATE model.entity SET name = TRIM(name);

-- #929: Module options
UPDATE web.settings SET name = 'table_rows' WHERE name = 'default_table_rows';
INSERT INTO web.settings (name, value) VALUES
    ('module_geonames', 'True'),
    ('module_map_overlay', 'True'),
    ('module_notes', 'True'),
    ('module_sub_units', 'True');

COMMIT;

-- Upgrade 5.5.1 to 5.6.0
-- Be sure to backup the database and read the upgrade notes before executing this!

BEGIN;

-- #930 Wikidata API
INSERT INTO web.settings (name, value) VALUES ('module_wikidata', 'True');

-- #1348 Refactor forms - fix capitalization for automatic standard type detection
UPDATE web.form SET name = 'Source Translation' WHERE name = 'Source translation';
UPDATE model.entity SET name = 'Source Translation' WHERE name = 'Source translation';
UPDATE web.hierarchy SET name = 'Source Translation' WHERE name = 'Source translation';

-- #1393 Split profile option - removing obsolete layout value
DELETE FROM web.user_settings WHERE name = 'layout';

COMMIT;

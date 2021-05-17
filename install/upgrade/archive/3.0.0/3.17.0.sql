-- Upgrade 3.15.0 to 3.17.0
-- Be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Type hierarchy fixes

UPDATE web.hierarchy SET multiple = True WHERE value_type = True;

COMMIT;

-- Upgrade 5.5.0 to 5.5.1
-- Be sure to backup the database and read the upgrade notes before executing this!

BEGIN;

-- Cleanup for #1380: Empty date comment is saved as 'None'
UPDATE model.entity SET begin_comment = NULL WHERE begin_comment = 'None';
UPDATE model.entity SET end_comment = NULL WHERE end_comment = 'None';

COMMIT;

-- Upgrade to 3.2.0, be sure to backup the database and read the update notes before executing this!

-- Delete logged locations from user logs because they are just duplicates from places
BEGIN;
DELETE FROM web.user_log WHERE entity_id IN (SELECT id FROM model.entity WHERE system_type = 'place location');
COMMIT;

-- Upgrade 6.0.x to 6.1.0
-- Be sure to backup the database and read the upgrade notes before executing this!

BEGIN;

-- #1457: Public notes
ALTER TABLE web.user_notes ADD COLUMN "public" boolean DEFAULT false NOT NULL;
ALTER TABLE web.user_notes DROP CONSTRAINT IF EXISTS user_notes_user_id_entity_id_key;

-- Remove obsolete settings
DELETE FROM web.settings WHERE name IN ('debug_mode', 'module_notes');
DELETE FROM web.user_settings WHERE name = 'module_notes';

END;

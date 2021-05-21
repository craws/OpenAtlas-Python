-- Upgrade 6.1.0 to 6.2.0
-- Be sure to backup the database and read the upgrade notes before executing this!

-- Remove obsolete settings
ALTER TABLE web.reference_system DROP COLUMN "precision_default_id";

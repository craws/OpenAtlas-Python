-- Upgrade to 3.7.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Add settings
INSERT INTO web.settings (name, value) VALUES ('logo_file_id', '');
INSERT INTO web.settings (name, value) VALUES ('site_header', '');

COMMIT;

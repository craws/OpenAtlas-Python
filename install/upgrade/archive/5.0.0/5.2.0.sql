-- Upgrade 5.1.x to 5.2.0
-- Be sure to backup the database and read the upgrade notes before executing this!

BEGIN;

-- Renaming system types (nodes) to standard types
ALTER TABLE web.hierarchy RENAME COLUMN system TO standard;

-- #1167: Settings and profile
DELETE FROM web.settings WHERE name = 'minimum_tablesorter_search';
ALTER TABLE ONLY web.settings ADD CONSTRAINT settings_name_key UNIQUE (name);

INSERT INTO web.settings (name, value) VALUES ('map_zoom_max', '18');
INSERT INTO web.settings (name, value) VALUES ('map_zoom_default', '12');
INSERT INTO web.settings (name, value) VALUES ('geonames_username', 'openatlas');
INSERT INTO web.settings (name, value) VALUES ('geonames_url', 'https://www.geonames.org/');
UPDATE web.user_settings SET name = 'map_zoom_max' WHERE name = 'max_zoom';
UPDATE web.user_settings SET name = 'map_zoom_default' WHERE name = 'default_zoom';

COMMIT;

-- Upgrade to 3.3.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Settings for file upload
INSERT INTO web.settings (name, value) VALUES
('file_upload_max_size', '10'),
('file_upload_allowed_extension', 'gif jpeg jpg pdf png txt zip'),
('file_upload_display_extension', 'gif jpeg jpg png');

-- License type for file upload
INSERT INTO model.entity (class_code, name, description) VALUES ('E55', 'License', 'Types for a file license');
INSERT INTO model.entity (class_code, name) VALUES
('E55', 'Proprietary license'),
('E55', 'Open license'),
('E55', 'Public domain'),
('E55', 'CC BY 4.0'),
('E55', 'CC BY-SA 4.0');

INSERT INTO model.link (property_code, range_id, domain_id) VALUES
('P127', (SELECT id FROM model.entity WHERE name='License'), (SELECT id FROM model.entity WHERE name='Proprietary license')),
('P127', (SELECT id FROM model.entity WHERE name='License'), (SELECT id FROM model.entity WHERE name='Open license')),
('P127', (SELECT id FROM model.entity WHERE name='Open license'), (SELECT id FROM model.entity WHERE name='Public domain')),
('P127', (SELECT id FROM model.entity WHERE name='Open license'), (SELECT id FROM model.entity WHERE name='CC BY 4.0')),
('P127', (SELECT id FROM model.entity WHERE name='Open license'), (SELECT id FROM model.entity WHERE name='CC BY-SA 4.0'));

INSERT INTO web.hierarchy (id, name, multiple, system, directional) VALUES ((SELECT id FROM model.entity WHERE name='License'), 'License', False, True, False);
INSERT INTO web.form (name, extendable) VALUES ('File', True);
INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES ((SELECT id FROM web.hierarchy WHERE name LIKE 'License'),(SELECT id FROM web.form WHERE name LIKE 'File'));

-- Clean up former language identifier
UPDATE web.user_settings SET value = 'en' WHERE name = 'language' AND value = '1';
UPDATE web.user_settings SET value = 'de' WHERE name = 'language' AND value = '2';

COMMIT;

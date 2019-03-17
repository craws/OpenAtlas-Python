-- Upgrade to 3.14.0 to 3.15.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Adding external reference types
INSERT INTO model.entity (class_code, name, description) VALUES ('E55', 'External Reference', 'Categories for the classification of external references like a link to Wikipedia');
INSERT INTO model.entity (class_code, name) VALUES ('E55', 'Link');
INSERT INTO model.link (property_code, range_id, domain_id) VALUES ('P127', (SELECT id FROM model.entity WHERE name='External Reference'), (SELECT id FROM model.entity WHERE name='Link'));
INSERT INTO web.hierarchy (id, name, multiple, system, directional, value_type) VALUES ((SELECT id FROM model.entity WHERE name='External Reference'), 'External Reference', False, True, False, False);
INSERT INTO web.form (name, extendable) VALUES ('External Reference', True);
INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES ((SELECT id FROM web.hierarchy WHERE name='External Reference'),(SELECT id FROM web.form WHERE name='External Reference'));

COMMIT;

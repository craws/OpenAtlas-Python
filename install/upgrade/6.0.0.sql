-- Upgrade 5.7.x to 6.0.0
-- Be sure to backup the database and read the upgrade notes before executing this!

BEGIN;

-- #1456 Artificial objects
INSERT INTO model.entity (class_code, name, description) VALUES ('E55', 'Artifact', '');
INSERT INTO model.entity (class_code, name) VALUES ('E55', 'Coin'), ('E55', 'Statue');
INSERT INTO model.link (property_code, range_id, domain_id) VALUES
('P127', (SELECT id FROM model.entity WHERE name='Artifact'), (SELECT id FROM model.entity WHERE name='Coin')),
('P127', (SELECT id FROM model.entity WHERE name='Artifact'), (SELECT id FROM model.entity WHERE name='Statue'));

INSERT INTO web.form (name, extendable) VALUES ('Artifact', True);
INSERT INTO web.hierarchy (id, name, multiple, standard, directional, value_type, locked) VALUES
((SELECT id FROM model.entity WHERE name='Artifact'), 'Artifact', False, True, False, False, False);
INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES
((SELECT id FROM web.hierarchy WHERE name='Artifact'), (SELECT id FROM web.form WHERE name='Artifact'));

-- #1091 Reference systems for types
INSERT INTO web.form (name, extendable) VALUES ('Type', True);

-- If you executed above at an upgrade of a development version before use this instead
-- UPDATE model.entity SET name = 'Artifact' WHERE LOWER(name) = 'artificial object';
-- UPDATE model.entity SET system_type = 'artifact' WHERE LOWER(system_type) = 'artificial object';
-- UPDATE web.form SET name = 'Artifact' WHERE name = 'Artificial Object';
-- UPDATE web.hierarchy SET name = 'Artifact' WHERE name = 'Artificial Object';

-- #1091 Refactor modules
ALTER TABLE model.entity ADD COLUMN system_class text;
UPDATE model.entity SET system_class = 'acquisition' WHERE class_code = 'E8';
UPDATE model.entity SET system_class = 'activity' WHERE class_code ='E7';
UPDATE model.entity SET system_class = 'actor_appellation' WHERE class_code = 'E82';
UPDATE model.entity SET system_class = 'administrative_unit' WHERE class_code = 'E53' AND system_type IS NULL;
UPDATE model.entity SET system_class = 'appellation' WHERE class_code = 'E41';
UPDATE model.entity SET system_class = 'artifact' WHERE class_code = 'E22' AND system_type IN ('artificial object', 'artifact');
UPDATE model.entity SET system_class = 'bibliography' WHERE class_code = 'E31' AND system_type = 'bibliography';
UPDATE model.entity SET system_class = 'edition' WHERE class_code = 'E31' AND system_type = 'edition';
UPDATE model.entity SET system_class = 'external_reference' WHERE class_code = 'E31' AND system_type = 'external reference';
UPDATE model.entity SET system_class = 'feature' WHERE class_code = 'E18' AND system_type = 'feature';
UPDATE model.entity SET system_class = 'file' WHERE class_code = 'E31' AND system_type = 'file';
UPDATE model.entity SET system_class = 'find' WHERE class_code = 'E22' AND system_type = 'find';
UPDATE model.entity SET system_class = 'group' WHERE class_code = 'E74';
UPDATE model.entity SET system_class = 'human_remains' WHERE class_code = 'E20' AND system_type = 'human remains';
UPDATE model.entity SET system_class = 'artifact', class_code = 'E22' WHERE class_code = 'E84';
UPDATE model.entity SET system_class = 'group', class_code = 'E74' WHERE class_code = 'E40';
UPDATE model.entity SET system_class = 'move' WHERE class_code = 'E9';
UPDATE model.entity SET system_class = 'object_location' WHERE class_code = 'E53' AND system_type = 'place location';
UPDATE model.entity SET system_class = 'person' WHERE class_code = 'E21';
UPDATE model.entity SET system_class = 'place' WHERE class_code = 'E18' AND system_type = 'place';
UPDATE model.entity SET system_class = 'reference_system' WHERE class_code = 'E32';
UPDATE model.entity SET system_class = 'source' WHERE class_code = 'E33' AND system_type = 'source content';
UPDATE model.entity SET system_class = 'source_translation' WHERE class_code = 'E33' AND system_type = 'source translation';
UPDATE model.entity SET system_class = 'stratigraphic_unit' WHERE class_code = 'E18' AND system_type = 'stratigraphic unit';
UPDATE model.entity SET system_class = 'type' WHERE class_code = 'E55';

ALTER TABLE model.entity ALTER COLUMN system_class SET NOT NULL;

-- #1091 Restructure and rename standard types
UPDATE web.hierarchy SET name = UPPER(substring(name FROM 1 FOR 1)) || LOWER(substring(name FROM 2 FOR LENGTH(name))) WHERE standard = True;
UPDATE model.entity AS e SET name = h.name FROM web.hierarchy AS h WHERE e.id = h.id AND h.standard = True;
INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM web.hierarchy WHERE name = 'Information carrier'), (SELECT id FROM web.hierarchy WHERE name = 'Artifact')),
    ('P127', (SELECT id FROM web.hierarchy WHERE name = 'Find'), (SELECT id FROM web.hierarchy WHERE name = 'Artifact'));
DELETE FROM web.hierarchy WHERE name IN ('Information carrier', 'Find', 'Legal body');
UPDATE model.entity SET description = 'Definitions of an actor''s function within a group. An actor can for example be member of a group and this membership is defined by a certain function during a certain period of time. E.g. actor "Charlemagne" is member of the group "Frankish Reign" from 768 to 814 in the function of "King" and he is member of the group "Roman Empire" from 800 to 814 in the function "Emperor".'
WHERE class_code = 'E55' AND name = 'Actor function';

-- #1091 Restructure and rename forms
UPDATE web.form SET name = LOWER(REPLACE(name, ' ', '_'));
INSERT INTO web.hierarchy_form (hierarchy_id, form_id)
    (SELECT hf.hierarchy_id, (SELECT id FROM web.form WHERE name = 'artifact') FROM web.hierarchy_form hf
    JOIN web.form f ON hf.form_id = f.id AND f.name = 'find');
UPDATE web.hierarchy_form SET form_id = (SELECT id FROM web.form WHERE name = 'group') WHERE form_id = (SELECT id FROM web.form WHERE name = 'legal_body');

-- Split event form to acquisition, activity, move
INSERT INTO web.form (name, extendable) VALUES
    ('acquisition', True),
    ('activity', True),
    ('move', True);
INSERT INTO web.hierarchy_form (hierarchy_id, form_id)
    (SELECT hf.hierarchy_id, (SELECT id FROM web.form WHERE name = 'acquisition') FROM web.hierarchy_form hf
    JOIN web.form f ON hf.form_id = f.id AND f.name = 'event');
INSERT INTO web.hierarchy_form (hierarchy_id, form_id)
    (SELECT hf.hierarchy_id, (SELECT id FROM web.form WHERE name = 'activity') FROM web.hierarchy_form hf
    JOIN web.form f ON hf.form_id = f.id AND f.name = 'event');
INSERT INTO web.hierarchy_form (hierarchy_id, form_id)
    (SELECT hf.hierarchy_id, (SELECT id FROM web.form WHERE name = 'move') FROM web.hierarchy_form hf
    JOIN web.form f ON hf.form_id = f.id AND f.name = 'event');

-- Split references systems for events to 3 sub forms
INSERT INTO web.reference_system_form (reference_system_id, form_id)
    (SELECT rsf.reference_system_id, (SELECT id FROM web.form WHERE name = 'activity') FROM web.reference_system_form rsf WHERE rsf.form_id = (SELECT id FROM web.form WHERE name = 'event'));
INSERT INTO web.reference_system_form (reference_system_id, form_id)
    (SELECT rsf.reference_system_id, (SELECT id FROM web.form WHERE name = 'acquisition') FROM web.reference_system_form rsf WHERE rsf.form_id = (SELECT id FROM web.form WHERE name = 'event'));
INSERT INTO web.reference_system_form (reference_system_id, form_id)
    (SELECT rsf.reference_system_id, (SELECT id FROM web.form WHERE name = 'move') FROM web.reference_system_form rsf WHERE rsf.form_id = (SELECT id FROM web.form WHERE name = 'event'));

DELETE FROM web.form WHERE name IN ('event', 'information_carrier', 'legal_body');

-- Connect find with standard artifact type
INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES (
    (SELECT id FROM web.hierarchy WHERE name = 'Artifact'),
    (SELECT id FROM web.form WHERE name = 'find'));

-- Remove duplicates, set combined unique key (form_id, hierarchy_id) in web.hierarchy_form
DELETE FROM web.hierarchy_form a USING web.hierarchy_form b WHERE a.id < b.id AND a.hierarchy_id = b.hierarchy_id AND a.form_id = b.form_id;
ALTER TABLE ONLY web.hierarchy_form ADD CONSTRAINT hierarchy_form_hierarchy_id_form_id_key UNIQUE (hierarchy_id, form_id);

-- Add locations to former information carrier to be to use maps for them as artifacts
-- If there are duplicate information carrier names they will have to be made unique before
INSERT INTO model.entity (class_code, system_class, name)
    (SELECT 'E53', 'object_location', 'Location of ' || name FROM model.entity WHERE system_type = 'information carrier');
INSERT INTO model.link (property_code, domain_id, range_id)
    (SELECT 'P53', i.id, l.id FROM model.entity i JOIN model.entity l ON 'Location of ' || i.name = l.name WHERE i.system_type = 'information carrier');

------------
-- Cleanup--
------------

-- Delete dates from physical objects
UPDATE model.entity SET
    begin_from = Null,
    begin_to = Null,
    begin_comment = Null,
    end_from = Null,
    end_to = Null,
    end_comment = Null
WHERE system_class = 'object_location';

-- Delete geom duplicates which could happened because of former bugs or imports
DELETE FROM gis.point a USING gis.point b WHERE a.id < b.id
AND a.entity_id = b.entity_id
AND a.name = b.name
AND a.geom = b.geom
AND a.type = b.type
AND a.description = b.description;

DELETE FROM gis.linestring a USING gis.linestring b WHERE a.id < b.id
AND a.entity_id = b.entity_id
AND a.name = b.name
AND a.geom = b.geom
AND a.type = b.type
AND a.description = b.description;

DELETE FROM gis.polygon a USING gis.polygon b WHERE a.id < b.id
AND a.entity_id = b.entity_id
AND a.name = b.name
AND a.geom = b.geom
AND a.type = b.type
AND a.description = b.description;

ALTER TABLE model.entity DROP COLUMN system_type;

END;

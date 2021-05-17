-- Upgrade to 3.4.0, be sure to backup the database and read the update notes before executing this!

SET search_path = model;
BEGIN;

-- Remove display extension from settings because it moved to configuration file
DELETE FROM web.settings WHERE name = 'file_upload_display_extension';

-- Add system_type place to existing places
UPDATE model.entity SET system_type = 'place' WHERE class_code = 'E18';

-- Add archaeological types
INSERT INTO entity (class_code, name, description) VALUES ('E55', 'Feature', 'Classification of the archaeological feature e.g. grave, pit, ...');
INSERT INTO entity (class_code, name) VALUES ('E55', 'Grave'), ('E55', 'Pit');
INSERT INTO link (property_code, range_id, domain_id) VALUES
('P127', (SELECT id FROM entity WHERE name='Feature'), (SELECT id FROM entity WHERE name='Grave')),
('P127', (SELECT id FROM entity WHERE name='Feature'), (SELECT id FROM entity WHERE name='Pit'));

INSERT INTO entity (class_code, name, description) VALUES ('E55', 'Stratigraphic Unit', 'Classification of the archaeological stratigraphic unit e.g. burial, deposit, ...');
INSERT INTO entity (class_code, name) VALUES ('E55', 'Burial'), ('E55', 'Deposit');
INSERT INTO link (property_code, range_id, domain_id) VALUES
('P127', (SELECT id FROM entity WHERE name='Stratigraphic Unit'), (SELECT id FROM entity WHERE name='Burial')),
('P127', (SELECT id FROM entity WHERE name='Stratigraphic Unit'), (SELECT id FROM entity WHERE name='Deposit'));

INSERT INTO entity (class_code, name, description) VALUES ('E55', 'Find', 'Classification of the archaeological find e.g. weapon, jewellery ...');
INSERT INTO entity (class_code, name) VALUES ('E55', 'Weapon'), ('E55', 'Jewellery');
INSERT INTO link (property_code, range_id, domain_id) VALUES
('P127', (SELECT id FROM entity WHERE name='Find'), (SELECT id FROM entity WHERE name='Weapon')),
('P127', (SELECT id FROM entity WHERE name='Find'), (SELECT id FROM entity WHERE name='Jewellery'));

INSERT INTO web.hierarchy (id, name, multiple, system, directional) VALUES
((SELECT id FROM entity WHERE name='Feature'), 'Feature', False, True, False),
((SELECT id FROM entity WHERE name='Stratigraphic Unit'), 'Stratigraphic Unit', False, True, False),
((SELECT id FROM entity WHERE name='Find'), 'Find', False, True, False);

INSERT INTO web.form (name, extendable) VALUES ('Feature', True), ('Stratigraphic Unit', True), ('Find', True);

INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES
((SELECT id FROM web.hierarchy WHERE name LIKE 'Feature'),(SELECT id FROM web.form WHERE name LIKE 'Feature')),
((SELECT id FROM web.hierarchy WHERE name LIKE 'Stratigraphic Unit'),(SELECT id FROM web.form WHERE name LIKE 'Stratigraphic Unit')),
((SELECT id FROM web.hierarchy WHERE name LIKE 'Find'),(SELECT id FROM web.form WHERE name LIKE 'Find'));


-- Add subunits to delete_entity_related trigger function
DROP FUNCTION IF EXISTS model.delete_entity_related() CASCADE;
CREATE FUNCTION delete_entity_related() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            -- Delete dates (E61) and aliases (E41, E82)
            IF OLD.class_code IN ('E6', 'E7', 'E8', 'E12', 'E21', 'E40', 'E74', 'E18', 'E22') THEN
                DELETE FROM model.entity WHERE id IN (
                    SELECT range_id FROM model.link WHERE domain_id = OLD.id AND class_code IN ('E41', 'E61', 'E82'));
            END IF;

            -- Delete the location (E53)
            IF OLD.class_code IN ('E18', 'E22') THEN
                DELETE FROM model.entity WHERE id = (SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code = 'P53');
            END IF;

            -- If it is a document (E33) delete the translations (E33)
            IF OLD.class_code = 'E33' THEN
                DELETE FROM model.entity WHERE id = (SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code = 'P73');
            END IF;

            RETURN OLD;
        END;
    $$;
ALTER FUNCTION model.delete_entity_related() OWNER TO openatlas;
CREATE TRIGGER on_delete_entity BEFORE DELETE ON entity FOR EACH ROW EXECUTE PROCEDURE delete_entity_related();

COMMIT;

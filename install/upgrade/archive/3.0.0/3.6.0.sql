-- Upgrade to 3.6.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Add value types

ALTER TABLE web.hierarchy ADD COLUMN value_type boolean;
COMMENT ON COLUMN web.hierarchy.value_type IS 'True if links to this type can have numeric values';
ALTER TABLE web.hierarchy ALTER column value_type SET DEFAULT false;
UPDATE web.hierarchy SET value_type = false;
ALTER TABLE web.hierarchy ALTER column value_type SET NOT NULL;

INSERT INTO model.entity (class_code, name, description) VALUES ('E55', 'Dimensions', 'Physical dimensions like weight and height.');
INSERT INTO model.entity (class_code, name, description) VALUES ('E55', 'Height', 'In centimeters'), ('E55', 'Weight', 'In gram');
INSERT INTO model.link (property_code, range_id, domain_id) VALUES
('P127', (SELECT id FROM model.entity WHERE name='Dimensions'), (SELECT id FROM model.entity WHERE name='Height')),
('P127', (SELECT id FROM model.entity WHERE name='Dimensions'), (SELECT id FROM model.entity WHERE name='Weight'));
INSERT INTO web.hierarchy (id, name, value_type) VALUES ((SELECT id FROM model.entity WHERE name='Dimensions'), 'Dimensions', True);
INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES ((SELECT id FROM web.hierarchy WHERE name LIKE 'Dimensions'),(SELECT id FROM web.form WHERE name LIKE 'Find'));

-- Remove invalid links from information carrier
DELETE FROM model.link WHERE id in (
    SELECT l.id FROM model.link l JOIN model.entity e ON l.domain_id = e.id AND e.class_code = 'E84' AND l.property_code = 'P67');

-- Fix possible invalid date links
UPDATE model.link SET property_code = 'OA5' WHERE id in (
    SELECT l.id FROM model.link l JOIN model.entity e ON l.domain_id = e.id AND l.property_code = 'OA1' AND e.class_code IN ('E6', 'E7', 'E8', 'E12'));
UPDATE model.link SET property_code = 'OA6' WHERE id in (
    SELECT l.id FROM model.link l JOIN model.entity e ON l.domain_id = e.id AND l.property_code = 'OA2' AND e.class_code IN ('E6', 'E7', 'E8', 'E12'));

-- Fix inconsistent system type spelling
UPDATE model.entity SET system_type = 'stratigraphic unit' WHERE system_type = 'stratigraphic_unit';

-- Fix possible invalid type for "Source translation"
UPDATE model.entity SET class_code = 'E55' WHERE class_code = 'E53' and name = 'Source translation';

-- Fix possible invalid file/reference links
UPDATE model.link SET domain_id = range_id, range_id = domain_id WHERE id IN (
    SELECT l.id FROM model.link l
    JOIN model.entity d ON l.domain_id = d.id
    JOIN model.entity r ON l.range_id = r.id
    WHERE d.system_type = 'file' AND r.system_type IN ('edition', 'information carrier', 'bibliography') AND l.property_code = 'P67');

COMMIT;

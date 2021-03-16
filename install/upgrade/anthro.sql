
BEGIN;

-- Todo: add this to install SQL

-- #1445: Tool - Anthropological sex estimation
INSERT INTO model.entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Sex estimation', 'Used for biological sex estimation of human remains.'),
    ('E55', 'type', '111Feminine', NULL),
    ('E55', 'type', '111Feminine likely', NULL),
    ('E55', 'type', '111Indifferent', NULL),
    ('E55', 'type', '111Masculine', NULL),
    ('E55', 'type', '111Masculine likely', NULL),
    ('E55', 'type', '111Not preserved', NULL);
INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='111Feminine'), (SELECT id FROM model.entity WHERE name='Sex estimation')),
    ('P127', (SELECT id FROM model.entity WHERE name='111Feminine likely'), (SELECT id FROM model.entity WHERE name='Sex estimation')),
    ('P127', (SELECT id FROM model.entity WHERE name='111Indifferent'), (SELECT id FROM model.entity WHERE name='Sex estimation')),
    ('P127', (SELECT id FROM model.entity WHERE name='111Masculine'), (SELECT id FROM model.entity WHERE name='Sex estimation')),
    ('P127', (SELECT id FROM model.entity WHERE name='111Masculine likely'), (SELECT id FROM model.entity WHERE name='Sex estimation')),
    ('P127', (SELECT id FROM model.entity WHERE name='111Not preserved'), (SELECT id FROM model.entity WHERE name='Sex estimation'));

UPDATE model.entity SET name = 'Feminine' WHERE name = '111Feminine';
UPDATE model.entity SET name = 'Feminine likely' WHERE name = '111Feminine likely';
UPDATE model.entity SET name = 'Indifferent' WHERE name = '111Indifferent';
UPDATE model.entity SET name = 'Masculine' WHERE name = '111Masculine';
UPDATE model.entity SET name = 'Masculine likely' WHERE name = '111Masculine likely';
UPDATE model.entity SET name = 'Not preserved' WHERE name = '111Not preserved';

INSERT INTO web.hierarchy (id, name, multiple, standard, directional, value_type, locked) VALUES
((SELECT id FROM model.entity WHERE name='Sex estimation'), 'Sex estimation', False, True, False, False, True);

END;


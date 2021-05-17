
BEGIN;

-- Todo: add this to install SQL


-- #1445: Tool - Anthropological sex estimation

INSERT INTO model.entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Features for sexing', 'Bone features used for biological sex estimation of human remains.'),
    ('E55', 'type', '#-remove-#Skull', NULL),
    ('E55', 'type', '#-remove-#Mandible', NULL),
    ('E55', 'type', '#-remove-#Pelvis', NULL),
    ('E55', 'type', '#-remove-#Robusticity', NULL);

INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Skull'), (SELECT id FROM model.entity WHERE name='Features for sexing')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Mandible'), (SELECT id FROM model.entity WHERE name='Features for sexing')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis'), (SELECT id FROM model.entity WHERE name='Features for sexing')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Robusticity'), (SELECT id FROM model.entity WHERE name='Features for sexing'));


INSERT INTO model.entity (class_code, system_class, name) VALUES
    ('E55', 'type', '#-remove-#Glabella'),
    ('E55', 'type', '#-remove-#Arcus superciliaris'),
    ('E55', 'type', '#-remove-#Tuber frontalis and parietalis'),
    ('E55', 'type', '#-remove-#Inclinatio frontalis'),
    ('E55', 'type', '#-remove-#Processus mastoideus'),
    ('E55', 'type', '#-remove-#Relief of planum nuchale'),
    ('E55', 'type', '#-remove-#Protuberantia occipitalis externa'),
    ('E55', 'type', '#-remove-#Processus zygomaticus'),
    ('E55', 'type', '#-remove-#Os zygomaticum'),
    ('E55', 'type', '#-remove-#Crista supramastoideum'),
    ('E55', 'type', '#-remove-#Margo supraorbitalis'),
    ('E55', 'type', '#-remove-#Shape of orbita');

INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Glabella'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Arcus superciliaris'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Tuber frontalis and parietalis'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Inclinatio frontalis'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Processus mastoideus'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Relief of planum nuchale'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Protuberantia occipitalis externa'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Processus zygomaticus'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Os zygomaticum'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Crista supramastoideum'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Margo supraorbitalis'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Shape of orbita'), (SELECT id FROM model.entity WHERE name='#-remove-#Skull'));

INSERT INTO model.entity (class_code, system_class, name) VALUES
    ('E55', 'type', '#-remove-#Overall apperence'),
    ('E55', 'type', '#-remove-#Mentum'),
    ('E55', 'type', '#-remove-#Angulus'),
    ('E55', 'type', '#-remove-#Margo inferior (M2)'),
    ('E55', 'type', '#-remove-#Angle');

INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Overall apperence'), (SELECT id FROM model.entity WHERE name='#-remove-#Mandible')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Mentum'), (SELECT id FROM model.entity WHERE name='#-remove-#Mandible')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Angulus'), (SELECT id FROM model.entity WHERE name='#-remove-#Mandible')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Margo inferior (M2)'), (SELECT id FROM model.entity WHERE name='#-remove-#Mandible')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Angle'), (SELECT id FROM model.entity WHERE name='#-remove-#Mandible'));

INSERT INTO model.entity (class_code, system_class, name) VALUES
    ('E55', 'type', '#-remove-#Sulcus praeauricularis'),
    ('E55', 'type', '#-remove-#Incisura ischiadica major'),
    ('E55', 'type', '#-remove-#Angulus pubis'),
    ('E55', 'type', '#-remove-#Arc composé'),
    ('E55', 'type', '#-remove-#Os coxae'),
    ('E55', 'type', '#-remove-#Foramen obturatum'),
    ('E55', 'type', '#-remove-#Corpus ossis ischii'),
    ('E55', 'type', '#-remove-#Crista iliaca'),
    ('E55', 'type', '#-remove-#Fossa iliaca'),
    ('E55', 'type', '#-remove-#Pelvis major'),
    ('E55', 'type', '#-remove-#Auricular area'),
    ('E55', 'type', '#-remove-#Sacrum'),
    ('E55', 'type', '#-remove-#Fossa acetabuli');

INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Sulcus praeauricularis'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Incisura ischiadica major'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Angulus pubis'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Arc composé'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Os coxae'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Foramen obturatum'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Corpus ossis ischii'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Crista iliaca'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Fossa iliaca'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis major'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Auricular area'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Sacrum'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Fossa acetabuli'), (SELECT id FROM model.entity WHERE name='#-remove-#Pelvis'));

INSERT INTO model.entity (class_code, system_class, name) VALUES
    ('E55', 'type', '#-remove-#Humerus'),
    ('E55', 'type', '#-remove-#Femur');

INSERT INTO model.link (property_code, domain_id, range_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Humerus'), (SELECT id FROM model.entity WHERE name='#-remove-#Robusticity')),
    ('P127', (SELECT id FROM model.entity WHERE name='#-remove-#Femur'), (SELECT id FROM model.entity WHERE name='#-remove-#Robusticity'));

INSERT INTO web.hierarchy (id, name, multiple, standard, directional, value_type, locked) VALUES
((SELECT id FROM model.entity WHERE name='Features for sexing'), 'Features for sexing', False, True, False, False, True);

UPDATE model.entity SET name = substr(name, 11, length(name)) WHERE name LIKE '#-remove-#%';

END;

SET search_path = model;

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Bibliography', 'Categories for bibliographical entries as used for example in BibTeX, e.g. Book, Inbook, Article etc.'),
    ('E55', 'type', 'Inbook', Null),
    ('E55', 'type', 'Article', Null),
    ('E55', 'type', 'Book', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Bibliography'), (SELECT id FROM entity WHERE name='Inbook')),
    ('P127', (SELECT id FROM entity WHERE name='Bibliography'), (SELECT id FROM entity WHERE name='Article'))   ,
    ('P127', (SELECT id FROM entity WHERE name='Bibliography'), (SELECT id FROM entity WHERE name='Book'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Edition', 'Categories for the classification of written sources'' editions like charter editions, chronicle edition etc.'),
    ('E55', 'type', 'Charter Edition', Null),
    ('E55', 'type', 'Letter Edition', Null),
    ('E55', 'type', 'Chronicle Edition', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Edition'), (SELECT id FROM entity WHERE name='Charter Edition')),
    ('P127', (SELECT id FROM entity WHERE name='Edition'), (SELECT id FROM entity WHERE name='Letter Edition')),
    ('P127', (SELECT id FROM entity WHERE name='Edition'), (SELECT id FROM entity WHERE name='Chronicle Edition'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'External reference', 'Categories for the classification of external references like a link to Wikipedia'),
    ('E55', 'type', 'Link', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='External reference'), (SELECT id FROM entity WHERE name='Link'));

INSERT INTO model.entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'External reference match', 'SKOS based definition of the confidence degree that concepts can be used interchangeable.'),
    ('E55', 'type', 'exact match', 'High degree of confidence that the concepts can be used interchangeably.'),
    ('E55', 'type', 'close match', 'Concepts are sufficiently similar that they can be used interchangeably in some information retrieval applications.');
INSERT INTO model.link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='External reference match'), (SELECT id FROM model.entity WHERE name='exact match')),
    ('P127', (SELECT id FROM model.entity WHERE name='External reference match'), (SELECT id FROM model.entity WHERE name='close match'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Actor function', 'Definitions of an actor''s function within a group. An actor can for example be member of a group and this membership is defined by a certain function during a certain period of time. E.g. actor "Charlemagne" is member of the group "Frankish Reign" from 768 to 814 in the function of "King" and he is member of the group "Roman Empire" from 800 to 814 in the function "Emperor".'),
    ('E55', 'type', 'Bishop', Null),
    ('E55', 'type', 'Abbot', Null),
    ('E55', 'type', 'Pope', Null),
    ('E55', 'type', 'Emperor', Null),
    ('E55', 'type', 'Count', Null),
    ('E55', 'type', 'King', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Actor function'), (SELECT id FROM entity WHERE name='Bishop')),
    ('P127', (SELECT id FROM entity WHERE name='Actor function'), (SELECT id FROM entity WHERE name='Abbot')),
    ('P127', (SELECT id FROM entity WHERE name='Actor function'), (SELECT id FROM entity WHERE name='Pope')),
    ('P127', (SELECT id FROM entity WHERE name='Actor function'), (SELECT id FROM entity WHERE name='Emperor')),
    ('P127', (SELECT id FROM entity WHERE name='Actor function'), (SELECT id FROM entity WHERE name='Count')),
    ('P127', (SELECT id FROM entity WHERE name='Actor function'), (SELECT id FROM entity WHERE name='King'));

INSERT INTO entity (class_code, system_class, name) VALUES
    ('E55', 'type', 'Artifact'),
    ('E55', 'type', 'Coin'),
    ('E55', 'type', 'Statue');
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Artifact'), (SELECT id FROM entity WHERE name='Coin')),
    ('P127', (SELECT id FROM entity WHERE name='Artifact'), (SELECT id FROM entity WHERE name='Statue'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Involvement', 'Categories to define the involvement of an actor within an event. E.g. "Napoleon" participated in the event "Invasion of Russia" as "Commander" or "Michelangelo" performed the event "painting of the Sistine chapel" as "Artist".'),
    ('E55', 'type', 'Creator', Null),
    ('E55', 'type', 'Sponsor', Null),
    ('E55', 'type', 'Victim', Null),
    ('E55', 'type', 'Offender', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Involvement'), (SELECT id FROM entity WHERE name='Creator')),
    ('P127', (SELECT id FROM entity WHERE name='Involvement'), (SELECT id FROM entity WHERE name='Sponsor')),
    ('P127', (SELECT id FROM entity WHERE name='Involvement'), (SELECT id FROM entity WHERE name='Victim')),
    ('P127', (SELECT id FROM entity WHERE name='Involvement'), (SELECT id FROM entity WHERE name='Offender'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Sex', 'Categories for sex like female, male.'),
    ('E55', 'type', 'Female', Null),
    ('E55', 'type', 'Male', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Sex'), (SELECT id FROM entity WHERE name='Female')),
    ('P127', (SELECT id FROM entity WHERE name='Sex'), (SELECT id FROM entity WHERE name='Male'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Event', 'Categories for the type of events like Change of property, Conflict, Movement, Attendance etc.'),
    ('E55', 'type', 'Change of Property', Null),
    ('E55', 'type', 'Donation', Null),
    ('E55', 'type', 'Sale', Null),
    ('E55', 'type', 'Exchange', Null),
    ('E55', 'type', 'Conflict', Null),
    ('E55', 'type', 'Battle', Null),
    ('E55', 'type', 'Raid', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Event'), (SELECT id FROM entity WHERE name='Change of Property')),
    ('P127', (SELECT id FROM entity WHERE name='Event'), (SELECT id FROM entity WHERE name='Conflict')),
    ('P127', (SELECT id FROM entity WHERE name='Change of Property'), (SELECT id FROM entity WHERE name='Donation')),
    ('P127', (SELECT id FROM entity WHERE name='Change of Property'), (SELECT id FROM entity WHERE name='Sale')),
    ('P127', (SELECT id FROM entity WHERE name='Change of Property'), (SELECT id FROM entity WHERE name='Exchange')),
    ('P127', (SELECT id FROM entity WHERE name='Conflict'), (SELECT id FROM entity WHERE name='Battle')),
    ('P127', (SELECT id FROM entity WHERE name='Conflict'), (SELECT id FROM entity WHERE name='Raid'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Source', 'Types for historical sources like charter, chronicle, letter etc.'),
    ('E55', 'type', 'Charter', Null),
    ('E55', 'type', 'Testament', Null),
    ('E55', 'type', 'Letter', Null),
    ('E55', 'type', 'Contract', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Source'), (SELECT id FROM entity WHERE name='Charter')),
    ('P127', (SELECT id FROM entity WHERE name='Source'), (SELECT id FROM entity WHERE name='Testament')),
    ('P127', (SELECT id FROM entity WHERE name='Source'), (SELECT id FROM entity WHERE name='Letter')),
    ('P127', (SELECT id FROM entity WHERE name='Source'), (SELECT id FROM entity WHERE name='Contract'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'License', 'Types for the licensing of a file'),
    ('E55', 'type', 'Proprietary license', Null),
    ('E55', 'type', 'Open license', Null),
    ('E55', 'type', 'Public domain', Null),
    ('E55', 'type', 'CC BY 4.0', Null),
    ('E55', 'type', 'CC BY-SA 4.0', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='License'), (SELECT id FROM entity WHERE name='Proprietary license')),
    ('P127', (SELECT id FROM entity WHERE name='License'), (SELECT id FROM entity WHERE name='Open license')),
    ('P127', (SELECT id FROM entity WHERE name='Open license'), (SELECT id FROM entity WHERE name='Public domain')),
    ('P127', (SELECT id FROM entity WHERE name='Open license'), (SELECT id FROM entity WHERE name='CC BY 4.0')),
    ('P127', (SELECT id FROM entity WHERE name='Open license'), (SELECT id FROM entity WHERE name='CC BY-SA 4.0'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Actor actor relation', 'Categories for the relationship between two actors. This may be a mutual relationship (e.g. actor A is friend of actor B and vice versa), or a directional relationship (e.g. actor A is the child of actor B, while actor B is the parent of actor A).'),
    ('E55', 'type', 'Kindredship', Null),
    ('E55', 'type', 'Parent of (Child of)', Null),
    ('E55', 'type', 'Social', Null),
    ('E55', 'type', 'Friend of', Null),
    ('E55', 'type', 'Enemy of', Null),
    ('E55', 'type', 'Mentor of (Student of)', Null),
    ('E55', 'type', 'Political', Null),
    ('E55', 'type', 'Ally of', Null),
    ('E55', 'type', 'Leader of (Retinue of)', Null),
    ('E55', 'type', 'Economical', Null),
    ('E55', 'type', 'Provider of (Customer of)', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Actor actor relation'), (SELECT id FROM entity WHERE name='Kindredship')),
    ('P127', (SELECT id FROM entity WHERE name='Actor actor relation'), (SELECT id FROM entity WHERE name='Social')),
    ('P127', (SELECT id FROM entity WHERE name='Actor actor relation'), (SELECT id FROM entity WHERE name='Political')),
    ('P127', (SELECT id FROM entity WHERE name='Actor actor relation'), (SELECT id FROM entity WHERE name='Economical')),
    ('P127', (SELECT id FROM entity WHERE name='Kindredship'), (SELECT id FROM entity WHERE name='Parent of (Child of)')),
    ('P127', (SELECT id FROM entity WHERE name='Social'), (SELECT id FROM entity WHERE name='Friend of')),
    ('P127', (SELECT id FROM entity WHERE name='Social'), (SELECT id FROM entity WHERE name='Enemy of')),
    ('P127', (SELECT id FROM entity WHERE name='Social'), (SELECT id FROM entity WHERE name='Mentor of (Student of)')),
    ('P127', (SELECT id FROM entity WHERE name='Political'), (SELECT id FROM entity WHERE name='Ally of')),
    ('P127', (SELECT id FROM entity WHERE name='Political'), (SELECT id FROM entity WHERE name='Leader of (Retinue of)')),
    ('P127', (SELECT id FROM entity WHERE name='Economical'), (SELECT id FROM entity WHERE name='Provider of (Customer of)'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Place', 'Types for non-moveable entities (i.e. places) with a certain extent and/or location like Settlement, Burial site, Ritual site, Fortification etc.'),
    ('E55', 'type', 'Settlement', Null),
    ('E55', 'type', 'Military Facility', Null),
    ('E55', 'type', 'Ritual Site', Null),
    ('E55', 'type', 'Burial Site', Null),
    ('E55', 'type', 'Infrastructure', Null),
    ('E55', 'type', 'Economic Site', Null),
    ('E55', 'type', 'Boundary Mark', Null),
    ('E55', 'type', 'Topographical Entity', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Settlement')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Military Facility')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Ritual Site')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Burial Site')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Infrastructure')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Economic Site')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Boundary Mark')),
    ('P127', (SELECT id FROM entity WHERE name='Place'), (SELECT id FROM entity WHERE name='Topographical Entity'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Feature', 'Classification of the archaeological feature e.g. grave, pit, ...'),
    ('E55', 'type', 'Grave', Null),
    ('E55', 'type', 'Pit', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Feature'), (SELECT id FROM entity WHERE name='Grave')),
    ('P127', (SELECT id FROM entity WHERE name='Feature'), (SELECT id FROM entity WHERE name='Pit'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Stratigraphic unit', 'Classification of the archaeological SU e.g. burial, deposit, ...'),
    ('E55', 'type', 'Burial', Null),
    ('E55', 'type', 'Deposit', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Stratigraphic unit'), (SELECT id FROM entity WHERE name='Burial')),
    ('P127', (SELECT id FROM entity WHERE name='Stratigraphic unit'), (SELECT id FROM entity WHERE name='Deposit'));

INSERT INTO model.entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Human remains', 'Human remains, that for example were discovered during archaeological excavations. They are associated with a stratigraphic unit (in most cases a skeleton) that is composed of (P46) one or multiple parts (in most cases bones) that are classified as biological objects (E20). From a hierarchical point of view the human remains are one level below the stratigraphic unit respectively the entity whose sum of parts resembles the individual/skeleton. This way individual bones or body parts can be treated individually and be connected with separate classifications (e.g. Injuries of the right upper arm or caries on a certain tooth).'),
    ('E55', 'type', 'Upper Body', Null),
    ('E55', 'type', 'Lower Body', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='Human remains' AND class_code = 'E55'), (SELECT id FROM model.entity WHERE name='Upper Body')),
    ('P127', (SELECT id FROM model.entity WHERE name='Human remains' AND class_code = 'E55'), (SELECT id FROM model.entity WHERE name='Lower Body'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E53', 'administrative_unit', 'Administrative unit', 'Hierarchy of administrative units like "Austria", "Germany", "Italy" and their respective subunits like "Lower Austria", "Styria" and their subunits etc.'),
    ('E53', 'administrative_unit', 'Austria', Null),
    ('E53', 'administrative_unit', 'Wien', Null),
    ('E53', 'administrative_unit', 'Niederösterreich', Null),
    ('E53', 'administrative_unit', 'Germany', Null),
    ('E53', 'administrative_unit', 'Italy', Null),
    ('E53', 'administrative_unit', 'Czech Republic', Null),
    ('E53', 'administrative_unit', 'Slovakia', Null),
    ('E53', 'administrative_unit', 'Slovenia', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P89', (SELECT id FROM entity WHERE name='Administrative unit'), (SELECT id FROM entity WHERE name='Austria')),
    ('P89', (SELECT id FROM entity WHERE name='Administrative unit'), (SELECT id FROM entity WHERE name='Italy')),
    ('P89', (SELECT id FROM entity WHERE name='Administrative unit'), (SELECT id FROM entity WHERE name='Germany')),
    ('P89', (SELECT id FROM entity WHERE name='Administrative unit'), (SELECT id FROM entity WHERE name='Czech Republic')),
    ('P89', (SELECT id FROM entity WHERE name='Administrative unit'), (SELECT id FROM entity WHERE name='Slovakia')),
    ('P89', (SELECT id FROM entity WHERE name='Administrative unit'), (SELECT id FROM entity WHERE name='Slovenia')),
    ('P89', (SELECT id FROM entity WHERE name='Austria'), (SELECT id FROM entity WHERE name='Wien')),
    ('P89', (SELECT id FROM entity WHERE name='Austria'), (SELECT id FROM entity WHERE name='Niederösterreich'));

INSERT INTO entity (class_code, system_class, name, description) VALUES
    ('E53', 'administrative_unit', 'Historical place', 'Hierarchy of historical places respectively historical administrative units like: Duchy of Bavaria, Lombard Kingdom etc.'),
    ('E53', 'administrative_unit', 'Carantania', Null),
    ('E53', 'administrative_unit', 'Marcha Orientalis', Null),
    ('E53', 'administrative_unit', 'Comitatus Iauntal', Null),
    ('E53', 'administrative_unit', 'Kingdom of Serbia', Null);
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P89', (SELECT id FROM entity WHERE name='Historical place'), (SELECT id FROM entity WHERE name='Carantania')),
    ('P89', (SELECT id FROM entity WHERE name='Historical place'), (SELECT id FROM entity WHERE name='Marcha Orientalis')),
    ('P89', (SELECT id FROM entity WHERE name='Historical place'), (SELECT id FROM entity WHERE name='Comitatus Iauntal')),
    ('P89', (SELECT id FROM entity WHERE name='Historical place'), (SELECT id FROM entity WHERE name='Kingdom of Serbia'));

INSERT INTO entity (class_code, system_class, name) VALUES
    ('E55', 'type', 'Source translation'),
    ('E55', 'type', 'Original Text'),
    ('E55', 'type', 'Translation'),
    ('E55', 'type', 'Transliteration');
INSERT INTO link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM entity WHERE name='Source translation'), (SELECT id FROM entity WHERE name='Original Text')),
    ('P127', (SELECT id FROM entity WHERE name='Source translation'), (SELECT id FROM entity WHERE name='Translation')),
    ('P127', (SELECT id FROM entity WHERE name='Source translation'), (SELECT id FROM entity WHERE name='Transliteration'));

INSERT INTO model.entity (class_code, system_class, name, description) VALUES
    ('E55', 'type', 'Dimensions', 'Physical dimensions like weight and height.'),
    ('E55', 'type', 'Height', 'centimeter'),
    ('E55', 'type', 'Weight', 'gram');
INSERT INTO model.link (property_code, range_id, domain_id) VALUES
    ('P127', (SELECT id FROM model.entity WHERE name='Dimensions'), (SELECT id FROM model.entity WHERE name='Height')),
    ('P127', (SELECT id FROM model.entity WHERE name='Dimensions'), (SELECT id FROM model.entity WHERE name='Weight'));

INSERT INTO web.form (name, extendable) VALUES
    ('acquisition', True),
    ('activity', True),
    ('actor_actor_relation', False),
    ('artifact', True),
    ('bibliography', True),
    ('edition', True),
    ('external_reference', True),
    ('feature', True),
    ('file', True),
    ('find', True),
    ('group', True),
    ('human_remains', True),
    ('involvement', False),
    ('member', False),
    ('move', True),
    ('source', True),
    ('person', True),
    ('place', True),
    ('stratigraphic_unit', True),
    ('source_translation', False),
    ('type', True);

INSERT INTO web.hierarchy (id, name, multiple, standard, directional, value_type, locked) VALUES
    ((SELECT id FROM entity WHERE name='Actor function'), 'Actor function', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Actor actor relation'), 'Actor actor relation', False, True, True, False, False),
    ((SELECT id FROM entity WHERE name='Administrative unit'), 'Administrative unit', True, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Artifact'), 'Artifact', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Bibliography'), 'Bibliography', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Edition'), 'Edition', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Event'), 'Event', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='External reference'), 'External reference', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='External reference match'), 'External reference match', False, True, False, False, True),
    ((SELECT id FROM entity WHERE name='Feature'), 'Feature', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Historical place'), 'Historical place', True, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Human remains' AND class_code = 'E55'), 'Human remains', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Involvement'), 'Involvement', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='License'), 'License', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Source'), 'Source', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Place'), 'Place', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Stratigraphic unit'), 'Stratigraphic unit', False, True, False, False, False),
    ((SELECT id FROM entity WHERE name='Source translation'), 'Source translation', False, False, False, False, False),

    ((SELECT id FROM entity WHERE name='Dimensions'), 'Dimensions', True, False, False, True, False),
    ((SELECT id FROM entity WHERE name='Sex'), 'Sex', False, False, False, False, False);

INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES
    ((SELECT id FROM web.hierarchy WHERE name='Actor function'),(SELECT id FROM web.form WHERE name='member')),
    ((SELECT id FROM web.hierarchy WHERE name='Actor actor relation'),(SELECT id FROM web.form WHERE name='actor_actor_relation')),
    ((SELECT id FROM web.hierarchy WHERE name='Administrative unit'),(SELECT id FROM web.form WHERE name='place')),
    ((SELECT id FROM web.hierarchy WHERE name='Artifact'),(SELECT id FROM web.form WHERE name='artifact')),
    ((SELECT id FROM web.hierarchy WHERE name='Artifact'),(SELECT id FROM web.form WHERE name='find')),
    ((SELECT id FROM web.hierarchy WHERE name='Bibliography'),(SELECT id FROM web.form WHERE name='bibliography')),
    ((SELECT id FROM web.hierarchy WHERE name='Edition'),(SELECT id FROM web.form WHERE name='edition')),
    ((SELECT id FROM web.hierarchy WHERE name='Event'),(SELECT id FROM web.form WHERE name='acquisition')),
    ((SELECT id FROM web.hierarchy WHERE name='Event'),(SELECT id FROM web.form WHERE name='activity')),
    ((SELECT id FROM web.hierarchy WHERE name='Event'),(SELECT id FROM web.form WHERE name='move')),
    ((SELECT id FROM web.hierarchy WHERE name='External reference'),(SELECT id FROM web.form WHERE name='external_reference')),
    ((SELECT id FROM web.hierarchy WHERE name='Feature'),(SELECT id FROM web.form WHERE name='feature')),
    ((SELECT id FROM web.hierarchy WHERE name='Historical place'),(SELECT id FROM web.form WHERE name='place')),
    ((SELECT id FROM web.hierarchy WHERE name='Human remains'),(SELECT id FROM web.form WHERE name='human_remains')),
    ((SELECT id FROM web.hierarchy WHERE name='Involvement'),(SELECT id FROM web.form WHERE name='involvement')),
    ((SELECT id FROM web.hierarchy WHERE name='License'),(SELECT id FROM web.form WHERE name='file')),
    ((SELECT id FROM web.hierarchy WHERE name='Place'),(SELECT id FROM web.form WHERE name='place')),
    ((SELECT id FROM web.hierarchy WHERE name='Source'),(SELECT id FROM web.form WHERE name='source')),
    ((SELECT id FROM web.hierarchy WHERE name='Source translation'),(SELECT id FROM web.form WHERE name='source_translation')),
    ((SELECT id FROM web.hierarchy WHERE name='Stratigraphic unit'),(SELECT id FROM web.form WHERE name='stratigraphic_unit')),

    ((SELECT id FROM web.hierarchy WHERE name='Dimensions'),(SELECT id FROM web.form WHERE name='artifact')),
    ((SELECT id FROM web.hierarchy WHERE name='Dimensions'),(SELECT id FROM web.form WHERE name='find')),
    ((SELECT id FROM web.hierarchy WHERE name='Sex'),(SELECT id FROM web.form WHERE name='person'));

INSERT INTO web.reference_system_form (reference_system_id, form_id) VALUES
    ((SELECT entity_id FROM web.reference_system WHERE name='GeoNames'), (SELECT id FROM web.form WHERE name='place')),
    ((SELECT entity_id FROM web.reference_system WHERE name='Wikidata'), (SELECT id FROM web.form WHERE name='place')),
    ((SELECT entity_id FROM web.reference_system WHERE name='Wikidata'), (SELECT id FROM web.form WHERE name='person')),
    ((SELECT entity_id FROM web.reference_system WHERE name='Wikidata'), (SELECT id FROM web.form WHERE name='group'));

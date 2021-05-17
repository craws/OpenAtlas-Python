-- Upgrade 3.12.0 to 3.13.0
-- Be sure to backup the database and read the update notes before executing this!

-- Since this is a massive upgrade it can take a while it maybe would be be better to export your database,
-- run the script locally and upload the database again
-- SET client_min_messages TO NOTICE;

BEGIN;

-- Complete rebuild of date implementation

-- Disable all triggers
SET session_replication_role = replica;

-- Move type links from model.link_property to model.link
ALTER TABLE model.link ADD COLUMN type_id integer;
ALTER TABLE ONLY model.link ADD CONSTRAINT link_type_id_fkey FOREIGN KEY (type_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;
UPDATE model.link l SET type_id = (SELECT lp.range_id FROM model.link_property lp WHERE lp.property_code = 'P2' and lp.domain_id = l.id);

-- Add new date fields
ALTER TABLE model.entity ADD COLUMN begin_from timestamp without time zone;
ALTER TABLE model.entity ADD COLUMN begin_to timestamp without time zone;
ALTER TABLE model.entity ADD COLUMN begin_comment text;
ALTER TABLE model.entity ADD COLUMN end_from timestamp without time zone;
ALTER TABLE model.entity ADD COLUMN end_to timestamp without time zone;
ALTER TABLE model.entity ADD COLUMN end_comment text;

ALTER TABLE model.link ADD COLUMN begin_from timestamp without time zone;
ALTER TABLE model.link ADD COLUMN begin_to timestamp without time zone;
ALTER TABLE model.link ADD COLUMN begin_comment text;
ALTER TABLE model.link ADD COLUMN end_from timestamp without time zone;
ALTER TABLE model.link ADD COLUMN end_to timestamp without time zone;
ALTER TABLE model.link ADD COLUMN end_comment text;

-- Drop delete trigger, an adapted version will be recreated later
DROP FUNCTION IF EXISTS model.delete_entity_related() CASCADE;
DROP FUNCTION IF EXISTS model.delete_link_dates() CASCADE;

-- Update event, place object, group and legal body dates
UPDATE model.entity e SET (begin_from, begin_to, begin_comment, end_from, end_to, end_comment) = (
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link l ON l.range_id = t.id AND l.property_code IN ('OA1', 'OA5') AND domain_id = e.id AND t.system_type IN ('exact date value', 'from date value')),
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link l ON l.range_id = t.id AND l.property_code IN ('OA1', 'OA5') AND domain_id = e.id AND t.system_type = 'to date value'),
    (SELECT t.description FROM model.entity t JOIN model.link l ON l.range_id = t.id AND l.property_code IN ('OA1', 'OA5') AND domain_id = e.id AND t.system_type IN ('exact date value', 'from date value')),
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link l ON l.range_id = t.id AND l.property_code IN ('OA2', 'OA6') AND domain_id = e.id AND t.system_type IN ('exact date value', 'from date value')),
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link l ON l.range_id = t.id AND l.property_code IN ('OA2', 'OA6') AND domain_id = e.id AND t.system_type = 'to date value'),
    (SELECT t.description FROM model.entity t JOIN model.link l ON l.range_id = t.id AND l.property_code IN ('OA2', 'OA6') AND domain_id = e.id AND t.system_type IN ('exact date value', 'from date value'))
) WHERE e.class_code IN ('E6', 'E7', 'E8', 'E12', 'E18', 'E22', 'E40', 'E74');

-- Update involvement, membership and relation dates
UPDATE model.link el SET (begin_from, begin_to, begin_comment, end_from, end_to, end_comment) = (
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link_property l ON l.range_id = t.id AND l.property_code = 'OA5' AND domain_id = el.id AND t.system_type IN ('exact date value', 'from date value')),
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link_property l ON l.range_id = t.id AND l.property_code = 'OA5' AND domain_id = el.id AND t.system_type = 'to date value'),
    (SELECT t.description FROM model.entity t JOIN model.link_property l ON l.range_id = t.id AND l.property_code = 'OA5' AND domain_id = el.id AND t.system_type IN ('exact date value', 'from date value')),
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link_property l ON l.range_id = t.id AND l.property_code = 'OA6' AND domain_id = el.id AND t.system_type IN ('exact date value', 'from date value')),
    (SELECT t.value_timestamp FROM model.entity t JOIN model.link_property l ON l.range_id = t.id AND l.property_code = 'OA6' AND domain_id = el.id AND t.system_type = 'to date value'),
    (SELECT t.description FROM model.entity t JOIN model.link_property l ON l.range_id = t.id AND l.property_code = 'OA6' AND domain_id = el.id AND t.system_type IN ('exact date value', 'from date value'))
) WHERE el.property_code IN ('P11', 'P14', 'P22', 'P23', 'OA7', 'P107');

-- Update actor dates and places of appearance
CREATE FUNCTION model.update_actors() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

    actor RECORD;
    new_event_id int;

    begin_from_id int;
    begin_from_date timestamp;
    begin_to_id int;
    begin_to_date timestamp;
    begin_property text;
    begin_desc text;
    begin_place_id int;

    end_from_id int;
    end_from_date timestamp;
    end_to_id int;
    end_to_date timestamp;
    end_property text;
    end_desc text;
    end_place_id int;

    count_actor_birth int;
    count_actor_begin_and_place int;
    count_actor_begin int;
    count_actor_begin_place int;
    count_actor_no_begin_data_or_place int;
    count_actor_death int;
    count_actor_end_and_place int;
    count_actor_end int;
    count_actor_end_place int;
    count_actor_no_end_data_or_place int;

    count_group_legal_begin_place int;
    count_group_legal_end_place int;

BEGIN

count_actor_birth = 0;
count_actor_begin_and_place = 0;
count_actor_begin = 0;
count_actor_begin_place = 0;
count_actor_no_begin_data_or_place = 0;
count_actor_death = 0;
count_actor_end_and_place = 0;
count_actor_end = 0;
count_actor_end_place = 0;
count_actor_no_end_data_or_place = 0;
count_group_legal_begin_place = 0;
count_group_legal_end_place = 0;


RAISE NOTICE 'Begin group and legal body update loop';
FOR actor IN SELECT id, name FROM model.entity WHERE class_code IN ('E40', 'E74') LOOP

    -- Begin place
    SELECT l.range_id INTO begin_place_id FROM model.link l
    JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code = 'OA8' AND l.domain_id = actor.id;

    IF begin_place_id IS NOT NULL THEN
        -- If begin_place create an event for it
        INSERT INTO model.entity (class_code, name) VALUES ('E7', 'First appearance of ' || actor.name) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', begin_place_id);
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_begin_place := count_group_legal_begin_place + 1;
    END IF;

    -- End place
    SELECT l.range_id INTO end_place_id FROM model.link l
    JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code = 'OA9' AND l.domain_id = actor.id;

    IF end_place_id IS NOT NULL THEN
        -- IF end_place create an event for it
        INSERT INTO model.entity (class_code, name) VALUES ('E7', 'Last appearance of ' || actor.name) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', end_place_id);
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_end_place := count_group_legal_end_place + 1;
    END IF;

END LOOP;


RAISE NOTICE 'Begin actor update loop';
FOR actor IN SELECT id, name FROM model.entity WHERE class_code = 'E21' LOOP

    -- Begin from
    SELECT t.id, t.value_timestamp, t.description, l.property_code INTO begin_from_id, begin_from_date, begin_desc, begin_property FROM model.link l
    JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code IN ('OA1', 'OA3') AND e.system_type IN ('exact date value', 'from date value')
    JOIN model.entity t ON l.range_id = t.id;

    -- Begin to
    IF begin_from_date IS NOT NULL THEN
        SELECT t.id, t.value_timestamp INTO begin_to_id, begin_to_date FROM model.link l
        JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code IN ('OA1', 'OA3') AND e.system_type = 'to date value'
        JOIN model.entity t ON l.range_id = t.id;
    END IF;

    -- Begin place
    SELECT l.range_id INTO begin_place_id FROM model.link l
    JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code = 'OA8' AND l.domain_id = actor.id;

    -- End from
    SELECT t.id, t.value_timestamp, t.description, l.property_code INTO end_from_id, end_from_date, end_desc, end_property FROM model.link l
    JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code IN ('OA2', 'OA4') AND e.system_type IN ('exact date value', 'from date value')
    JOIN model.entity t ON l.range_id = t.id;

    -- End to
    IF end_from_date IS NOT NULL THEN
        SELECT t.id, t.value_timestamp INTO end_to_id, end_to_date FROM model.link l
        JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code IN ('OA2', 'OA4') AND e.system_type = 'to date value'
        JOIN model.entity t ON l.range_id = t.id;
    END IF;

    -- End place
    SELECT l.range_id INTO end_place_id FROM model.link l
    JOIN model.entity e ON l.domain_id = actor.id AND l.range_id = e.id AND l.property_code = 'OA9' AND l.domain_id = actor.id;

    -- Update begin of actors
    IF begin_property = 'OA3' THEN
        -- If birth: move dates to entities
        UPDATE model.entity SET begin_from = begin_from_date, begin_to = begin_to_date, begin_comment = begin_desc WHERE id = actor.id;
        IF begin_place_id IS NOT NULL THEN
            -- If place move place to an event
            INSERT INTO model.entity (class_code, name) VALUES ('E7', 'First appearance of ' || actor.name) RETURNING id INTO new_event_id;
            INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', begin_place_id);
            INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        END IF;
        count_actor_birth := count_actor_birth + 1;
    ELSEIF begin_from_id IS NOT NULL AND begin_place_id IS NOT NULL THEN
        -- If first appearance date and place create an event with both
        INSERT INTO model.entity (class_code, name, begin_from, begin_to, begin_comment) VALUES ('E7', 'First appearance of ' || actor.name, begin_from_date, begin_to_date, begin_desc) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', begin_place_id);
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_begin_and_place := count_actor_begin_and_place + 1;
    ELSEIF begin_from_id IS NOT NULL THEN
        -- If begin_from create an event for for it
        INSERT INTO model.entity (class_code, name, begin_from, begin_to, begin_comment) VALUES ('E7', 'First appearance of ' || actor.name, begin_from_date, begin_to_date, begin_desc) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_begin := count_actor_begin + 1;
    ELSEIF begin_place_id IS NOT NULL THEN
        -- If begin_place create an event for it
        INSERT INTO model.entity (class_code, name) VALUES ('E7', 'First appearance of ' || actor.name) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', begin_place_id);
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_begin_place := count_actor_begin_place + 1;
    ELSE
        count_actor_no_begin_data_or_place := count_actor_no_begin_data_or_place + 1;
    END IF;

    -- Update end of actors
    IF end_property = 'OA4' THEN
        -- If death: move dates to entities
        UPDATE model.entity SET end_from = end_from_date, end_to = end_to_date, end_comment = end_desc WHERE id = actor.id;
        IF end_place_id IS NOT NULL THEN
            -- If place move place to an event
            INSERT INTO model.entity (class_code, name) VALUES ('E7', 'Last appearance of ' || actor.name) RETURNING id INTO new_event_id;
            INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', end_place_id);
            INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        END IF;
        count_actor_death := count_actor_death + 1;
    ELSEIF end_from_id IS NOT NULL AND end_place_id IS NOT NULL THEN
        -- IF first appearance date and place create an event with both
        INSERT INTO model.entity (class_code, name, end_from, end_to, end_comment) VALUES ('E7', 'Last appearance of ' || actor.name, end_from_date, end_to_date, end_desc) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', end_place_id);
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_end_and_place := count_actor_end_and_place + 1;
    ELSEIF end_from_id IS NOT NULL THEN
        -- IF end_from create an event for for it
        INSERT INTO model.entity (class_code, name, end_from, end_to, end_comment) VALUES ('E7', 'Last appearance of ' || actor.name, end_from_date, end_to_date, end_desc) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_end := count_actor_end + 1;
    ELSEIF end_place_id IS NOT NULL THEN
        -- IF end_place create an event for it
        INSERT INTO model.entity (class_code, name) VALUES ('E7', 'Last appearance of ' || actor.name) RETURNING id INTO new_event_id;
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P7', end_place_id);
        INSERT INTO model.link (domain_id, property_code, range_id) VALUES (new_event_id, 'P11', actor.id);
        count_actor_end_place := count_actor_end_place + 1;
    ELSE
        count_actor_no_end_data_or_place := count_actor_no_end_data_or_place + 1;
    END IF;

END LOOP;

RAISE NOTICE 'Person: % birth, % begin date and place, % begin date, % begin place, % no begin date or place', count_actor_birth, count_actor_begin_and_place, count_actor_begin, count_actor_begin_place, count_actor_no_begin_data_or_place;
RAISE NOTICE 'Person: % death, % end date and place, % end date, % end place, % no end date or place', count_actor_death, count_actor_end_and_place, count_actor_end, count_actor_end_place, count_actor_no_end_data_or_place;
RAISE NOTICE 'Group or legal body: % begin place, % end place', count_group_legal_begin_place, count_group_legal_end_place;

END;$$;
ALTER FUNCTION model.update_actors() OWNER TO openatlas;

-- Execute actor update function, remove afterwards
SELECT model.update_actors();
DROP FUNCTION model.update_actors() CASCADE;

-- Drop obsolete fields
ALTER TABLE model.entity DROP COLUMN value_integer;
ALTER TABLE model.entity DROP COLUMN value_timestamp;

-- Delete date entities
DELETE FROM model.entity WHERE class_code = 'E61';

-- Delete obsolete OA properties
DELETE FROM model.property WHERE code IN ('OA1', 'OA2', 'OA3', 'OA4', 'OA5', 'OA6');
DELETE FROM model.property_i18n WHERE property_code IN ('OA1', 'OA2', 'OA3', 'OA4', 'OA5', 'OA6');

-- Delete former place and date links
DELETE FROM model.link WHERE link.property_code IN ('OA1', 'OA2', 'OA3', 'OA4', 'OA5', 'OA6', 'OA8', 'OA9');

-- Update OA8 and OA9 specification
UPDATE model.property SET name = 'begins in' WHERE code = 'OA8';
UPDATE model.property SET name = 'ends in' WHERE code = 'OA9';
UPDATE model.property_i18n SET text = 'begins in' WHERE attribute = 'name' AND property_code = 'OA8' AND language_code = 'en';
UPDATE model.property_i18n SET text = 'beginnt in' WHERE attribute = 'name' AND property_code = 'OA8' AND language_code = 'de';
UPDATE model.property_i18n SET text = 'ends in' WHERE attribute = 'name' AND property_code = 'OA9' AND language_code = 'en';
UPDATE model.property_i18n SET text = 'endet in' WHERE attribute = 'name' AND property_code = 'OA9' AND language_code = 'de';

-- Drop obsolete model.link_property table
DROP TABLE model.link_property;

-- Recreate delete trigger
CREATE FUNCTION model.delete_entity_related() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            -- Delete aliases (P1, P131)
            IF OLD.class_code IN ('E18', 'E21', 'E40', 'E74') THEN
                DELETE FROM model.entity WHERE id IN (SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code IN ('P1', 'P131'));
            END IF;

            -- Delete location (E53) if it was a place or find
            IF OLD.class_code IN ('E18', 'E22') THEN
                DELETE FROM model.entity WHERE id = (SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code = 'P53');
            END IF;

            -- Delete translations (E33) if it was a document
            IF OLD.class_code = 'E33' THEN
                DELETE FROM model.entity WHERE id IN (SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code = 'P73');
            END IF;

            RETURN OLD;
        END;
    $$;
ALTER FUNCTION model.delete_entity_related() OWNER TO openatlas;
CREATE TRIGGER on_delete_entity BEFORE DELETE ON model.entity FOR EACH ROW EXECUTE PROCEDURE model.delete_entity_related();

-- Re-enable all triggers
SET session_replication_role = DEFAULT;

COMMIT;

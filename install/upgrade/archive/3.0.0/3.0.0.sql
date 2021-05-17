-- Upgrade to 3.0.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Settings
DELETE FROM web.settings WHERE name IN ('mail_transport_password', 'mail_transport_auth', 'mail_transport_ssl', 'mail_transport_type', 'notify_login', 'maintenance', 'offline');
UPDATE web.settings SET name = 'site_name' WHERE name = 'sitename';
UPDATE web.settings SET value = 'en' WHERE name = 'default_language';
UPDATE web.settings SET value = '' WHERE value = 'false';
INSERT INTO web.settings (name, value) VALUES ('minimum_password_length', '12');
INSERT INTO web.settings (name, value) VALUES ('debug_mode', '');

-- Web content (intro and contact text)
DROP TABLE IF EXISTS web.i18n;
DROP TABLE IF EXISTS web.language;
DROP TABLE IF EXISTS web.content;
SET search_path = web, pg_catalog;
CREATE TABLE i18n (
    id integer NOT NULL,
    name text NOT NULL,
    language text NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);
ALTER TABLE i18n OWNER TO openatlas;
CREATE SEQUENCE i18n_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE i18n_id_seq OWNER TO openatlas;
ALTER SEQUENCE i18n_id_seq OWNED BY i18n.id;
ALTER TABLE ONLY i18n ALTER COLUMN id SET DEFAULT nextval('i18n_id_seq'::regclass);
ALTER TABLE ONLY i18n ADD CONSTRAINT i18n_name_language_key UNIQUE (name, language);
ALTER TABLE ONLY i18n ADD CONSTRAINT i18n_pkey PRIMARY KEY (id);
CREATE TRIGGER update_modified BEFORE UPDATE ON i18n FOR EACH ROW EXECUTE PROCEDURE model.update_modified();

-- User (using boolean type, adding a constraint)
ALTER TABLE web."user" ALTER COLUMN "active" DROP DEFAULT;
ALTER TABLE web."user" ALTER COLUMN "active" TYPE bool USING active::bool;
ALTER TABLE web."user" ALTER COLUMN "active" SET DEFAULT FALSE;

ALTER TABLE IF EXISTS ONLY web.user_settings DROP CONSTRAINT IF EXISTS user_settings_user_id_name_value_key;
ALTER TABLE ONLY web.user_settings ADD CONSTRAINT user_settings_user_id_name_key UNIQUE (user_id, name);
UPDATE web.user_settings SET value = 'True' WHERE name IN ('newsletter', 'show_email') AND value = '1';
UPDATE web.user_settings SET value = '' WHERE name IN ('newsletter', 'show_email') AND value = '0';


-- Types
ALTER TABLE model.entity ADD COLUMN system_type text;

-- Place Types
UPDATE model.entity SET name = 'Place' WHERE id = (SELECT id FROM model.entity WHERE name = 'Site');
UPDATE web.hierarchy set name = 'Place' WHERE name = 'Site';

-- Source Type
UPDATE model.entity SET system_type = 'source content'
WHERE id IN (
    SELECT e.id FROM model.entity e
    JOIN model.link l ON e.id = l.domain_id AND l.range_id = (SELECT id FROM model.entity WHERE name = 'Source Content'));

UPDATE model.entity SET system_type = 'source translation'
WHERE id IN (
    SELECT e.id FROM model.entity e
    JOIN model.link l ON e.id = l.range_id AND l.property_id = (SELECT id FROM model.property WHERE code = 'P73'));

DELETE FROM model.entity WHERE id = (SELECT id FROM model.entity WHERE name = 'Source Content');
UPDATE model.entity SET name = 'Source translation' WHERE id = (SELECT id FROM model.entity WHERE name = 'Linguistic object classification');
UPDATE web.hierarchy SET name = 'Source translation' WHERE name = 'Linguistic object classification';
UPDATE model.entity SET name = 'Original text' WHERE id = (SELECT id FROM model.entity WHERE name = 'Source Original Text');
UPDATE model.entity SET name = 'Translation' WHERE id = (SELECT id FROM model.entity WHERE name = 'Source Translation');
UPDATE model.entity SET name = 'Transliteration' WHERE id = (SELECT id FROM model.entity WHERE name = 'Source Transliteration');

INSERT INTO web.form (name, extendable) VALUES ('Source translation', 0);
INSERT INTO web.hierarchy_form (hierarchy_id, form_id) VALUES
    ((SELECT id FROM web.hierarchy WHERE name LIKE 'Source translation'),(SELECT id FROM web.form WHERE name LIKE 'Source translation'));

-- Date Type
UPDATE model.entity SET system_type = 'exact date value'
WHERE id IN (
    SELECT e.id FROM model.entity e
    JOIN model.link l ON e.id = l.domain_id AND l.range_id = (SELECT id FROM model.entity WHERE name = 'Exact date value'));
UPDATE model.entity SET system_type = 'from date value'
WHERE id IN (
    SELECT e.id FROM model.entity e
    JOIN model.link l ON e.id = l.domain_id AND l.range_id = (SELECT id FROM model.entity WHERE name = 'From date value'));
UPDATE model.entity SET system_type = 'to date value'
WHERE id IN (
    SELECT e.id FROM model.entity e
    JOIN model.link l ON e.id = l.domain_id AND l.range_id = (SELECT id FROM model.entity WHERE name = 'To date value'));

DELETE FROM model.entity WHERE id = (SELECT id FROM model.entity WHERE name = 'To date value');
DELETE FROM model.entity WHERE id = (SELECT id FROM model.entity WHERE name = 'Exact date value');
DELETE FROM model.entity WHERE id = (SELECT id FROM model.entity WHERE name = 'From date value');
DELETE FROM model.entity WHERE id = (SELECT id FROM model.entity WHERE name = 'Date value type');

-- References
UPDATE model.entity SET system_type = 'information carrier'
WHERE id IN (SELECT e.id FROM model.entity e JOIN model.class c ON e.class_id = c.id AND c.code = 'E84');

UPDATE model.entity e SET system_type = 'edition'
WHERE id IN (
    SELECT e2.id FROM model.entity e2
    JOIN model.link l ON e2.id = l.domain_id
        AND l.property_id = (SELECT id FROM model.property WHERE code = 'P2')
        AND (l.range_id = (SELECT id FROM model.entity WHERE name = 'Edition')
            OR l.range_id IN (
            SELECT e.id FROM model.entity e
            JOIN model.link l ON e.id = l.domain_id AND l.range_id = (SELECT id FROM model.entity WHERE name = 'Edition'))));

UPDATE model.entity e SET system_type = 'bibliography'
WHERE id IN (
    SELECT e2.id FROM model.entity e2
    JOIN model.link l ON e2.id = l.domain_id
        AND l.property_id = (SELECT id FROM model.property WHERE code = 'P2')
        AND (l.range_id = (SELECT id FROM model.entity WHERE name = 'Bibliography')
            OR l.range_id IN (
            SELECT e.id FROM model.entity e
            JOIN model.link l ON e.id = l.domain_id AND l.range_id = (SELECT id FROM model.entity WHERE name = 'Bibliography'))));

-- Location of places
UPDATE model.entity SET system_type = 'place location' WHERE name LIKE 'Location of%' AND class_id = (SELECT id FROM model.class WHERE code = 'E53');

-- Alter web.hierarchy and form with booleans and clean up
ALTER TABLE ONLY web.hierarchy ADD CONSTRAINT hierarchy_name_key UNIQUE (name);
ALTER TABLE web.hierarchy DROP COLUMN extendable;
ALTER TABLE web.hierarchy ALTER COLUMN multiple DROP DEFAULT;
ALTER TABLE web.hierarchy ALTER COLUMN multiple TYPE bool USING multiple::bool;
ALTER TABLE web.hierarchy ALTER COLUMN multiple SET DEFAULT FALSE;
ALTER TABLE web.hierarchy ALTER COLUMN system DROP DEFAULT;
ALTER TABLE web.hierarchy ALTER COLUMN system TYPE bool USING system::bool;
ALTER TABLE web.hierarchy ALTER COLUMN system SET DEFAULT FALSE;
ALTER TABLE web.hierarchy ALTER COLUMN directional DROP DEFAULT;
ALTER TABLE web.hierarchy ALTER COLUMN directional TYPE bool USING directional::bool;
ALTER TABLE web.hierarchy ALTER COLUMN directional SET DEFAULT FALSE;
ALTER TABLE web.form ALTER COLUMN extendable DROP DEFAULT;
ALTER TABLE web.form ALTER COLUMN extendable TYPE bool USING extendable::bool;
ALTER TABLE web.form ALTER COLUMN extendable SET DEFAULT FALSE;

-- Remove all links to node roots because not needed anymore
DELETE FROM model.link WHERE
    property_id = (SELECT id FROM model.property WHERE code = 'P2')
    AND range_id IN (SELECT id FROM web.hierarchy);

-- Change gender to sex and remove system flag
UPDATE model.entity SET name = 'Sex', description = 'Categories for sex like female, male.'
    WHERE id = (SELECT id from model.entity WHERE name = 'Gender');
UPDATE web.hierarchy SET name = 'Sex', system = False WHERE name = 'Gender';

-- Change foreign keys at entity/class and links/property from id to code
SET search_path = model, pg_catalog;

ALTER TABLE IF EXISTS ONLY entity DROP CONSTRAINT IF EXISTS entity_class_id_fkey;
ALTER TABLE entity ALTER COLUMN class_id TYPE text;
ALTER TABLE entity RENAME class_id TO class_code;
UPDATE entity SET class_code = (SELECT code FROM class WHERE id = class_code::integer);
ALTER TABLE ONLY entity ADD CONSTRAINT entity_class_code_fkey FOREIGN KEY (class_code) REFERENCES class(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY link DROP CONSTRAINT IF EXISTS link_property_id_fkey;
ALTER TABLE link ALTER COLUMN property_id TYPE text;
ALTER TABLE link RENAME property_id TO property_code;
UPDATE link SET property_code = (SELECT code FROM property WHERE id = property_code::integer);
ALTER TABLE ONLY link ADD CONSTRAINT link_property_code_fkey FOREIGN KEY (property_code) REFERENCES property(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY link_property DROP CONSTRAINT IF EXISTS link_property_property_id_fkey;
ALTER TABLE link_property ALTER COLUMN property_id TYPE text;
ALTER TABLE link_property RENAME property_id TO property_code;
UPDATE link_property SET property_code = (SELECT code FROM property WHERE id = property_code::integer);
ALTER TABLE ONLY link_property ADD CONSTRAINT link_property_property_code_fkey FOREIGN KEY (property_code) REFERENCES property(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE class_inheritance RENAME modfied TO modified;
ALTER TABLE IF EXISTS ONLY class_inheritance DROP CONSTRAINT IF EXISTS class_inheritance_sub_id_fkey;
ALTER TABLE class_inheritance ALTER COLUMN sub_id TYPE text;
ALTER TABLE class_inheritance RENAME sub_id TO sub_code;
UPDATE class_inheritance SET sub_code = (SELECT code FROM class WHERE id = sub_code::integer);
ALTER TABLE ONLY class_inheritance ADD CONSTRAINT class_inheritance_sub_code_fkey FOREIGN KEY (sub_code) REFERENCES class(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY class_inheritance DROP CONSTRAINT IF EXISTS class_inheritance_super_id_fkey;
ALTER TABLE class_inheritance ALTER COLUMN super_id TYPE text;
ALTER TABLE class_inheritance RENAME super_id TO super_code;
UPDATE class_inheritance SET super_code = (SELECT code FROM class WHERE id = super_code::integer);
ALTER TABLE ONLY class_inheritance ADD CONSTRAINT class_inheritance_super_code_fkey FOREIGN KEY (super_code) REFERENCES class(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY property_inheritance DROP CONSTRAINT IF EXISTS property_inheritance_sub_id_fkey;
ALTER TABLE property_inheritance ALTER COLUMN sub_id TYPE text;
ALTER TABLE property_inheritance RENAME sub_id TO sub_code;
UPDATE property_inheritance SET sub_code = (SELECT code FROM property WHERE id = sub_code::integer);
ALTER TABLE ONLY property_inheritance ADD CONSTRAINT property_inheritance_sub_code_fkey FOREIGN KEY (sub_code) REFERENCES property(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY property_inheritance DROP CONSTRAINT IF EXISTS property_inheritance_super_id_fkey;
ALTER TABLE property_inheritance ALTER COLUMN super_id TYPE text;
ALTER TABLE property_inheritance RENAME super_id TO super_code;
UPDATE property_inheritance SET super_code = (SELECT code FROM property WHERE id = super_code::integer);
ALTER TABLE ONLY property_inheritance ADD CONSTRAINT property_inheritance_super_code_fkey FOREIGN KEY (super_code) REFERENCES property(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY property DROP CONSTRAINT IF EXISTS property_domain_class_id_fkey;
ALTER TABLE property ALTER COLUMN domain_class_id TYPE text;
ALTER TABLE property RENAME domain_class_id TO domain_class_code;
UPDATE property SET domain_class_code = (SELECT code FROM class WHERE id = domain_class_code::integer);
ALTER TABLE ONLY property ADD CONSTRAINT property_domain_class_code_fkey FOREIGN KEY (domain_class_code) REFERENCES class(code) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS ONLY property DROP CONSTRAINT IF EXISTS property_range_class_id_fkey;
ALTER TABLE property ALTER COLUMN range_class_id TYPE text;
ALTER TABLE property RENAME range_class_id TO range_class_code;
UPDATE property SET range_class_code = (SELECT code FROM class WHERE id = range_class_code::integer);
ALTER TABLE ONLY property ADD CONSTRAINT property_range_class_code_fkey FOREIGN KEY (range_class_code) REFERENCES class(code) ON UPDATE CASCADE ON DELETE CASCADE;

-- Split i18n table for classes and properties, use code as foreign key
CREATE TABLE class_i18n (
    id integer NOT NULL,
    class_code text NOT NULL,
    language_code text NOT NULL,
    attribute text NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified time without time zone
);
ALTER TABLE class_i18n OWNER TO openatlas;
CREATE SEQUENCE class_i18n_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE class_i18n_id_seq OWNER TO openatlas;
ALTER SEQUENCE class_i18n_id_seq OWNED BY class_i18n.id;
ALTER TABLE ONLY class_i18n ALTER COLUMN id SET DEFAULT nextval('class_i18n_id_seq'::regclass);
ALTER TABLE ONLY class_i18n ADD CONSTRAINT class_i18n_class_code_language_code_attribute_key UNIQUE (class_code, language_code, attribute);
ALTER TABLE ONLY class_i18n ADD CONSTRAINT class_i18n_pkey PRIMARY KEY (id);
CREATE TRIGGER update_modified BEFORE UPDATE ON class_i18n FOR EACH ROW EXECUTE PROCEDURE update_modified();
ALTER TABLE ONLY class_i18n ADD CONSTRAINT class_i18n_class_code_fkey FOREIGN KEY (class_code) REFERENCES class(code) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE property_i18n (
    id integer NOT NULL,
    property_code text NOT NULL,
    language_code text NOT NULL,
    attribute text NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);
ALTER TABLE property_i18n OWNER TO openatlas;
CREATE SEQUENCE property_i18n_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE property_i18n_id_seq OWNER TO openatlas;
ALTER SEQUENCE property_i18n_id_seq OWNED BY property_i18n.id;
ALTER TABLE ONLY property_i18n ALTER COLUMN id SET DEFAULT nextval('property_i18n_id_seq'::regclass);
ALTER TABLE ONLY property_i18n ADD CONSTRAINT property_i18n_pkey PRIMARY KEY (id);
ALTER TABLE ONLY property_i18n ADD CONSTRAINT property_i18n_property_code_language_code_attribute_key UNIQUE (property_code, language_code, attribute);
CREATE TRIGGER update_modified BEFORE UPDATE ON property_i18n FOR EACH ROW EXECUTE PROCEDURE update_modified();
ALTER TABLE ONLY property_i18n ADD CONSTRAINT property_i18n_property_code_fkey FOREIGN KEY (property_code) REFERENCES property(code) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO class_i18n (class_code, language_code, attribute, text)
    SELECT c.code, i.language_code, i.table_field, i.text FROM i18n i JOIN class c ON i.table_id = c.id AND i.table_name = 'class';

INSERT INTO property_i18n (property_code, language_code, attribute, text)
    SELECT p.code, i.language_code, i.table_field, i.text FROM i18n i JOIN property p ON i.table_id = p.id AND i.table_name = 'property';

DROP TABLE i18n;

-- Update trigger functions for deleting related entities at delete to avoid orphaned data
DROP FUNCTION IF EXISTS model.delete_dates() CASCADE;
CREATE FUNCTION model.delete_entity_related() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            -- If it is an event, place or actor delete dates (E61) and aliases (E41, E82)
            IF OLD.class_code IN ('E6', 'E7', 'E8', 'E12', 'E21', 'E40', 'E74', 'E18') THEN
                DELETE FROM model.entity WHERE id IN (
                    SELECT range_id FROM model.link WHERE domain_id = OLD.id AND class_code IN ('E41', 'E61', 'E82'));
            END IF;

            -- If it is a physical object (E18) delete the location (E53)
            IF OLD.class_code = 'E18' THEN
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
CREATE TRIGGER on_delete_entity BEFORE DELETE ON model.entity FOR EACH ROW EXECUTE PROCEDURE model.delete_entity_related();

CREATE FUNCTION model.delete_link_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF OLD.property_code IN ('OA5', 'OA6') THEN
                DELETE FROM model.entity WHERE id = OLD.range_id AND class_code = 'E61';
            END IF;
            RETURN OLD;
        END;
    $$;
ALTER FUNCTION model.delete_link_dates() OWNER TO openatlas;
CREATE TRIGGER on_delete_link_property AFTER DELETE ON model.link_property FOR EACH ROW EXECUTE PROCEDURE model.delete_link_dates();

-- Delete obsolete "History of the World" Event
DELETE FROM model.entity WHERE id = (SELECT id from model.entity WHERE name = 'History of the World');

-- Remove an unused description field
ALTER TABLE model.link_property DROP COLUMN description;

-- New logging system
DROP TABLE log.detail;
ALTER TABLE log.log RENAME agent TO info;
ALTER TABLE log.log SET SCHEMA web;
ALTER TABLE web.log RENAME TO system_log;
DROP SCHEMA log;
TRUNCATE web.system_log RESTART IDENTITY;

DELETE FROM web.user_log WHERE table_name = 'link';
ALTER TABLE web.user_log DROP COLUMN table_name;
ALTER TABLE web.user_log RENAME table_id TO entity_id;

COMMIT;

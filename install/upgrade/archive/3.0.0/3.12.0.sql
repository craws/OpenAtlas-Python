-- Upgrade 3.11.0 to 3.12.0
-- Be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Adding settings for minimum character search limits
INSERT INTO web.settings (name, value) VALUES ('minimum_jstree_search', '1');
INSERT INTO web.settings (name, value) VALUES ('minimum_tablesorter_search', '1');

-- Fix possible naming errors at gis point
UPDATE gis.point SET type = 'centerpoint';

-- Profile images
INSERT INTO web.settings (name, value) VALUES ('profile_image_width', '200');
CREATE TABLE web.entity_profile_image (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    image_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE web.entity_profile_image OWNER TO openatlas;
CREATE SEQUENCE web.entity_profile_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE web.entity_profile_image_id_seq OWNER TO openatlas;
ALTER SEQUENCE web.entity_profile_image_id_seq OWNED BY web.entity_profile_image.id;
ALTER TABLE ONLY web.entity_profile_image ALTER COLUMN id SET DEFAULT nextval('web.entity_profile_image_id_seq'::regclass);
ALTER TABLE ONLY web.entity_profile_image ADD CONSTRAINT entity_profile_image_entity_id_key UNIQUE (entity_id);
ALTER TABLE ONLY web.entity_profile_image ADD CONSTRAINT entity_profile_image_pkey PRIMARY KEY (id);
ALTER TABLE ONLY web.entity_profile_image ADD CONSTRAINT entity_profile_image_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY web.entity_profile_image ADD CONSTRAINT entity_profile_image_image_id_fkey FOREIGN KEY (image_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMIT;

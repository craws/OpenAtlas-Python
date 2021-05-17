-- Upgrade 3.19.x to 3.20.0
-- Be sure to backup the database and read the update notes before executing this!

BEGIN;

-- #1043 DataTables - Adaptions for DataTables
UPDATE web.settings SET value = '25' WHERE name= 'default_table_rows' AND value = '20';
UPDATE web.user_settings SET value = '25' WHERE name= 'table_rows' AND value = '20';

-- #978 Image Overlay in Leaflet
CREATE TABLE web.map_overlay (
    id integer NOT NULL,
    image_id integer NOT NULL,
    place_id integer NOT NULL,
    link_id integer NOT NULL,
    bounding_box text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);
COMMENT ON COLUMN web.map_overlay.link_id IS 'Used to remove overlay entry if link is removed';
ALTER TABLE web.map_overlay OWNER TO openatlas;
CREATE SEQUENCE web.map_overlay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE web.map_overlay_id_seq OWNER TO openatlas;
ALTER SEQUENCE web.map_overlay_id_seq OWNED BY web.map_overlay.id;
ALTER TABLE ONLY web.map_overlay ALTER COLUMN id SET DEFAULT nextval('web.map_overlay_id_seq'::regclass);
ALTER TABLE ONLY web.map_overlay ADD CONSTRAINT map_overlay_pkey PRIMARY KEY (id);
CREATE TRIGGER update_modified BEFORE UPDATE ON web.map_overlay FOR EACH ROW EXECUTE PROCEDURE model.update_modified();
ALTER TABLE ONLY web.map_overlay ADD CONSTRAINT map_overlay_image_id_fkey FOREIGN KEY (image_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY web.map_overlay ADD CONSTRAINT map_overlay_place_id_fkey FOREIGN KEY (place_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY web.map_overlay ADD CONSTRAINT map_overlay_link_id_fkey FOREIGN KEY (link_id) REFERENCES model.link(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY web.map_overlay ADD CONSTRAINT map_overlay_image_id_place_id_key UNIQUE (image_id, place_id);

COMMIT;

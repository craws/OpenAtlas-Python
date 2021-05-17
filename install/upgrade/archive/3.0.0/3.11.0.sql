-- Upgrade 3.10.0 to 3.11.0
-- Be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Add settings
INSERT INTO web.settings (name, value) VALUES ('map_cluster_enabled', 'True');
INSERT INTO web.settings (name, value) VALUES ('map_cluster_max_radius', '50');
INSERT INTO web.settings (name, value) VALUES ('map_cluster_disable_at_zoom', '12');

-- Refactor delete_entity_related trigger function
DROP FUNCTION IF EXISTS model.delete_entity_related() CASCADE;
CREATE FUNCTION model.delete_entity_related() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            -- Delete dates (OA1, OA2, OA3, OA4, OA5, OA6) and aliases (P1, P131)
            IF OLD.class_code IN ('E6', 'E7', 'E8', 'E12', 'E18', 'E21', 'E22', 'E40', 'E74') THEN
                DELETE FROM model.entity WHERE id IN (
                    SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code IN ('OA1', 'OA2', 'OA3', 'OA4', 'OA5', 'OA6', 'P1', 'P131'));
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

COMMIT;

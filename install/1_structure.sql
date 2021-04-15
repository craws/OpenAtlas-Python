--
-- PostgreSQL database dump
--

-- Dumped from database version 11.11 (Debian 11.11-0+deb10u1)
-- Dumped by pg_dump version 11.11 (Debian 11.11-0+deb10u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY web.user_settings DROP CONSTRAINT IF EXISTS user_settings_user_id_fkey;
ALTER TABLE IF EXISTS ONLY web.user_notes DROP CONSTRAINT IF EXISTS user_notes_user_id_fkey;
ALTER TABLE IF EXISTS ONLY web.user_notes DROP CONSTRAINT IF EXISTS user_notes_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY web."user" DROP CONSTRAINT IF EXISTS user_group_id_fkey;
ALTER TABLE IF EXISTS ONLY web.user_bookmarks DROP CONSTRAINT IF EXISTS user_bookmarks_user_id_fkey;
ALTER TABLE IF EXISTS ONLY web.user_bookmarks DROP CONSTRAINT IF EXISTS user_bookmarks_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY web.reference_system DROP CONSTRAINT IF EXISTS reference_system_precision_default_id_fkey;
ALTER TABLE IF EXISTS ONLY web.reference_system_form DROP CONSTRAINT IF EXISTS reference_system_form_reference_system_id_fkey;
ALTER TABLE IF EXISTS ONLY web.reference_system_form DROP CONSTRAINT IF EXISTS reference_system_form_form_id_fkey;
ALTER TABLE IF EXISTS ONLY web.reference_system DROP CONSTRAINT IF EXISTS reference_system_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY web.map_overlay DROP CONSTRAINT IF EXISTS map_overlay_place_id_fkey;
ALTER TABLE IF EXISTS ONLY web.map_overlay DROP CONSTRAINT IF EXISTS map_overlay_link_id_fkey;
ALTER TABLE IF EXISTS ONLY web.map_overlay DROP CONSTRAINT IF EXISTS map_overlay_image_id_fkey;
ALTER TABLE IF EXISTS ONLY web.hierarchy DROP CONSTRAINT IF EXISTS hierarchy_id_fkey;
ALTER TABLE IF EXISTS ONLY web.hierarchy_form DROP CONSTRAINT IF EXISTS hierarchy_form_hierarchy_id_fkey;
ALTER TABLE IF EXISTS ONLY web.hierarchy_form DROP CONSTRAINT IF EXISTS hierarchy_form_form_id_fkey;
ALTER TABLE IF EXISTS ONLY web.entity_profile_image DROP CONSTRAINT IF EXISTS entity_profile_image_image_id_fkey;
ALTER TABLE IF EXISTS ONLY web.entity_profile_image DROP CONSTRAINT IF EXISTS entity_profile_image_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY model.property DROP CONSTRAINT IF EXISTS property_range_class_code_fkey;
ALTER TABLE IF EXISTS ONLY model.property_inheritance DROP CONSTRAINT IF EXISTS property_inheritance_super_code_fkey;
ALTER TABLE IF EXISTS ONLY model.property_inheritance DROP CONSTRAINT IF EXISTS property_inheritance_sub_code_fkey;
ALTER TABLE IF EXISTS ONLY model.property_i18n DROP CONSTRAINT IF EXISTS property_i18n_property_code_fkey;
ALTER TABLE IF EXISTS ONLY model.property DROP CONSTRAINT IF EXISTS property_domain_class_code_fkey;
ALTER TABLE IF EXISTS ONLY model.link DROP CONSTRAINT IF EXISTS link_type_id_fkey;
ALTER TABLE IF EXISTS ONLY model.link DROP CONSTRAINT IF EXISTS link_range_id_fkey;
ALTER TABLE IF EXISTS ONLY model.link DROP CONSTRAINT IF EXISTS link_property_code_fkey;
ALTER TABLE IF EXISTS ONLY model.link DROP CONSTRAINT IF EXISTS link_domain_id_fkey;
ALTER TABLE IF EXISTS ONLY model.entity DROP CONSTRAINT IF EXISTS entity_class_code_fkey;
ALTER TABLE IF EXISTS ONLY model.class_inheritance DROP CONSTRAINT IF EXISTS class_inheritance_super_code_fkey;
ALTER TABLE IF EXISTS ONLY model.class_inheritance DROP CONSTRAINT IF EXISTS class_inheritance_sub_code_fkey;
ALTER TABLE IF EXISTS ONLY model.class_i18n DROP CONSTRAINT IF EXISTS class_i18n_class_code_fkey;
ALTER TABLE IF EXISTS ONLY import.entity DROP CONSTRAINT IF EXISTS entity_user_id_fkey;
ALTER TABLE IF EXISTS ONLY import.entity DROP CONSTRAINT IF EXISTS entity_project_id_fkey;
ALTER TABLE IF EXISTS ONLY import.entity DROP CONSTRAINT IF EXISTS entity_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY gis.polygon DROP CONSTRAINT IF EXISTS polygon_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY gis.point DROP CONSTRAINT IF EXISTS point_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY gis.linestring DROP CONSTRAINT IF EXISTS linestring_entity_id_fkey;
DROP TRIGGER IF EXISTS update_modified ON web.user_settings;
DROP TRIGGER IF EXISTS update_modified ON web.user_notes;
DROP TRIGGER IF EXISTS update_modified ON web.user_bookmarks;
DROP TRIGGER IF EXISTS update_modified ON web."user";
DROP TRIGGER IF EXISTS update_modified ON web.reference_system;
DROP TRIGGER IF EXISTS update_modified ON web.map_overlay;
DROP TRIGGER IF EXISTS update_modified ON web.i18n;
DROP TRIGGER IF EXISTS update_modified ON web.hierarchy_form;
DROP TRIGGER IF EXISTS update_modified ON web.hierarchy;
DROP TRIGGER IF EXISTS update_modified ON web."group";
DROP TRIGGER IF EXISTS update_modified ON web.form;
DROP TRIGGER IF EXISTS update_modified ON model.property_inheritance;
DROP TRIGGER IF EXISTS update_modified ON model.property_i18n;
DROP TRIGGER IF EXISTS update_modified ON model.property;
DROP TRIGGER IF EXISTS update_modified ON model.link;
DROP TRIGGER IF EXISTS update_modified ON model.entity;
DROP TRIGGER IF EXISTS update_modified ON model.class_inheritance;
DROP TRIGGER IF EXISTS update_modified ON model.class_i18n;
DROP TRIGGER IF EXISTS update_modified ON model.class;
DROP TRIGGER IF EXISTS on_delete_entity ON model.entity;
DROP TRIGGER IF EXISTS update_modified ON import.project;
DROP TRIGGER IF EXISTS update_modified ON gis.polygon;
DROP TRIGGER IF EXISTS update_modified ON gis.point;
DROP TRIGGER IF EXISTS update_modified ON gis.linestring;
ALTER TABLE IF EXISTS ONLY web."user" DROP CONSTRAINT IF EXISTS user_username_key;
ALTER TABLE IF EXISTS ONLY web.user_settings DROP CONSTRAINT IF EXISTS user_settings_user_id_name_key;
ALTER TABLE IF EXISTS ONLY web.user_settings DROP CONSTRAINT IF EXISTS user_settings_pkey;
ALTER TABLE IF EXISTS ONLY web."user" DROP CONSTRAINT IF EXISTS user_pkey;
ALTER TABLE IF EXISTS ONLY web.user_notes DROP CONSTRAINT IF EXISTS user_notes_pkey;
ALTER TABLE IF EXISTS ONLY web.user_log DROP CONSTRAINT IF EXISTS user_log_pkey;
ALTER TABLE IF EXISTS ONLY web."user" DROP CONSTRAINT IF EXISTS user_email_key;
ALTER TABLE IF EXISTS ONLY web.user_bookmarks DROP CONSTRAINT IF EXISTS user_bookmarks_user_id_entity_id_key;
ALTER TABLE IF EXISTS ONLY web.user_bookmarks DROP CONSTRAINT IF EXISTS user_bookmarks_pkey;
ALTER TABLE IF EXISTS ONLY web."user" DROP CONSTRAINT IF EXISTS unsubscribe_code_key;
ALTER TABLE IF EXISTS ONLY web.settings DROP CONSTRAINT IF EXISTS settings_pkey;
ALTER TABLE IF EXISTS ONLY web.settings DROP CONSTRAINT IF EXISTS settings_name_key;
ALTER TABLE IF EXISTS ONLY web.reference_system DROP CONSTRAINT IF EXISTS reference_system_pkey;
ALTER TABLE IF EXISTS ONLY web.reference_system DROP CONSTRAINT IF EXISTS reference_system_name_key;
ALTER TABLE IF EXISTS ONLY web.reference_system_form DROP CONSTRAINT IF EXISTS reference_system_form_reference_system_id_form_id_key;
ALTER TABLE IF EXISTS ONLY web.reference_system_form DROP CONSTRAINT IF EXISTS reference_system_form_pkey;
ALTER TABLE IF EXISTS ONLY web.map_overlay DROP CONSTRAINT IF EXISTS map_overlay_pkey;
ALTER TABLE IF EXISTS ONLY web.map_overlay DROP CONSTRAINT IF EXISTS map_overlay_image_id_place_id_key;
ALTER TABLE IF EXISTS ONLY web.system_log DROP CONSTRAINT IF EXISTS log_pkey;
ALTER TABLE IF EXISTS ONLY web.i18n DROP CONSTRAINT IF EXISTS i18n_pkey;
ALTER TABLE IF EXISTS ONLY web.i18n DROP CONSTRAINT IF EXISTS i18n_name_language_key;
ALTER TABLE IF EXISTS ONLY web.hierarchy DROP CONSTRAINT IF EXISTS hierarchy_pkey;
ALTER TABLE IF EXISTS ONLY web.hierarchy DROP CONSTRAINT IF EXISTS hierarchy_name_key;
ALTER TABLE IF EXISTS ONLY web.hierarchy_form DROP CONSTRAINT IF EXISTS hierarchy_form_pkey;
ALTER TABLE IF EXISTS ONLY web.hierarchy_form DROP CONSTRAINT IF EXISTS hierarchy_form_hierarchy_id_form_id_key;
ALTER TABLE IF EXISTS ONLY web."group" DROP CONSTRAINT IF EXISTS group_pkey;
ALTER TABLE IF EXISTS ONLY web.form DROP CONSTRAINT IF EXISTS form_pkey;
ALTER TABLE IF EXISTS ONLY web.form DROP CONSTRAINT IF EXISTS form_name_key;
ALTER TABLE IF EXISTS ONLY web.entity_profile_image DROP CONSTRAINT IF EXISTS entity_profile_image_pkey;
ALTER TABLE IF EXISTS ONLY web.entity_profile_image DROP CONSTRAINT IF EXISTS entity_profile_image_entity_id_key;
ALTER TABLE IF EXISTS ONLY model.property DROP CONSTRAINT IF EXISTS property_pkey;
ALTER TABLE IF EXISTS ONLY model.property_inheritance DROP CONSTRAINT IF EXISTS property_inheritance_pkey;
ALTER TABLE IF EXISTS ONLY model.property_i18n DROP CONSTRAINT IF EXISTS property_i18n_property_code_language_code_key;
ALTER TABLE IF EXISTS ONLY model.property_i18n DROP CONSTRAINT IF EXISTS property_i18n_pkey;
ALTER TABLE IF EXISTS ONLY model.property DROP CONSTRAINT IF EXISTS property_code_key;
ALTER TABLE IF EXISTS ONLY model.link DROP CONSTRAINT IF EXISTS link_pkey;
ALTER TABLE IF EXISTS ONLY model.entity DROP CONSTRAINT IF EXISTS entity_pkey;
ALTER TABLE IF EXISTS ONLY model.class DROP CONSTRAINT IF EXISTS class_pkey;
ALTER TABLE IF EXISTS ONLY model.class DROP CONSTRAINT IF EXISTS class_name_key;
ALTER TABLE IF EXISTS ONLY model.class_inheritance DROP CONSTRAINT IF EXISTS class_inheritance_super_id_sub_id_key;
ALTER TABLE IF EXISTS ONLY model.class_inheritance DROP CONSTRAINT IF EXISTS class_inheritance_pkey;
ALTER TABLE IF EXISTS ONLY model.class_i18n DROP CONSTRAINT IF EXISTS class_i18n_pkey;
ALTER TABLE IF EXISTS ONLY model.class_i18n DROP CONSTRAINT IF EXISTS class_i18n_class_code_language_code_key;
ALTER TABLE IF EXISTS ONLY model.class DROP CONSTRAINT IF EXISTS class_code_key;
ALTER TABLE IF EXISTS ONLY import.project DROP CONSTRAINT IF EXISTS project_pkey;
ALTER TABLE IF EXISTS ONLY import.project DROP CONSTRAINT IF EXISTS project_name_key;
ALTER TABLE IF EXISTS ONLY import.entity DROP CONSTRAINT IF EXISTS entity_project_id_origin_id_key;
ALTER TABLE IF EXISTS ONLY import.entity DROP CONSTRAINT IF EXISTS entity_pkey;
ALTER TABLE IF EXISTS ONLY gis.polygon DROP CONSTRAINT IF EXISTS polygon_pkey;
ALTER TABLE IF EXISTS ONLY gis.point DROP CONSTRAINT IF EXISTS point_pkey;
ALTER TABLE IF EXISTS ONLY gis.linestring DROP CONSTRAINT IF EXISTS linestring_pkey;
ALTER TABLE IF EXISTS web.user_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.user_notes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.user_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.user_bookmarks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web."user" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.system_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.reference_system_form ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.map_overlay ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.i18n ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.hierarchy_form ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.hierarchy ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web."group" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.form ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS web.entity_profile_image ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.property_inheritance ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.property_i18n ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.property ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.link ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.entity ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.class_inheritance ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.class_i18n ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS model.class ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS import.project ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS import.entity ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS gis.polygon ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS gis.point ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS gis.linestring ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS web.user_settings_id_seq;
DROP TABLE IF EXISTS web.user_settings;
DROP SEQUENCE IF EXISTS web.user_notes_id_seq;
DROP TABLE IF EXISTS web.user_notes;
DROP SEQUENCE IF EXISTS web.user_log_id_seq;
DROP TABLE IF EXISTS web.user_log;
DROP SEQUENCE IF EXISTS web.user_id_seq;
DROP SEQUENCE IF EXISTS web.user_bookmarks_id_seq;
DROP TABLE IF EXISTS web.user_bookmarks;
DROP TABLE IF EXISTS web."user";
DROP SEQUENCE IF EXISTS web.settings_id_seq;
DROP TABLE IF EXISTS web.settings;
DROP SEQUENCE IF EXISTS web.reference_system_form_id_seq;
DROP TABLE IF EXISTS web.reference_system_form;
DROP TABLE IF EXISTS web.reference_system;
DROP SEQUENCE IF EXISTS web.map_overlay_id_seq;
DROP TABLE IF EXISTS web.map_overlay;
DROP SEQUENCE IF EXISTS web.log_id_seq;
DROP TABLE IF EXISTS web.system_log;
DROP SEQUENCE IF EXISTS web.i18n_id_seq;
DROP TABLE IF EXISTS web.i18n;
DROP SEQUENCE IF EXISTS web.hierarchy_id_seq;
DROP SEQUENCE IF EXISTS web.hierarchy_form_id_seq;
DROP TABLE IF EXISTS web.hierarchy_form;
DROP TABLE IF EXISTS web.hierarchy;
DROP SEQUENCE IF EXISTS web.group_id_seq;
DROP TABLE IF EXISTS web."group";
DROP SEQUENCE IF EXISTS web.form_id_seq;
DROP TABLE IF EXISTS web.form;
DROP SEQUENCE IF EXISTS web.entity_profile_image_id_seq;
DROP TABLE IF EXISTS web.entity_profile_image;
DROP SEQUENCE IF EXISTS model.property_inheritance_id_seq;
DROP TABLE IF EXISTS model.property_inheritance;
DROP SEQUENCE IF EXISTS model.property_id_seq;
DROP SEQUENCE IF EXISTS model.property_i18n_id_seq;
DROP TABLE IF EXISTS model.property_i18n;
DROP TABLE IF EXISTS model.property;
DROP SEQUENCE IF EXISTS model.link_id_seq;
DROP TABLE IF EXISTS model.link;
DROP SEQUENCE IF EXISTS model.entity_id_seq;
DROP TABLE IF EXISTS model.entity;
DROP SEQUENCE IF EXISTS model.class_inheritance_id_seq;
DROP TABLE IF EXISTS model.class_inheritance;
DROP SEQUENCE IF EXISTS model.class_id_seq;
DROP SEQUENCE IF EXISTS model.class_i18n_id_seq;
DROP TABLE IF EXISTS model.class_i18n;
DROP TABLE IF EXISTS model.class;
DROP SEQUENCE IF EXISTS import.project_id_seq;
DROP TABLE IF EXISTS import.project;
DROP SEQUENCE IF EXISTS import.entity_id_seq;
DROP TABLE IF EXISTS import.entity;
DROP SEQUENCE IF EXISTS gis.polygon_id_seq;
DROP TABLE IF EXISTS gis.polygon;
DROP SEQUENCE IF EXISTS gis.point_id_seq;
DROP TABLE IF EXISTS gis.point;
DROP SEQUENCE IF EXISTS gis.linestring_id_seq;
DROP TABLE IF EXISTS gis.linestring;
DROP FUNCTION IF EXISTS model.update_modified();
DROP FUNCTION IF EXISTS model.delete_entity_related();
DROP SCHEMA IF EXISTS web;
DROP SCHEMA IF EXISTS model;
DROP SCHEMA IF EXISTS import;
DROP SCHEMA IF EXISTS gis;
--
-- Name: gis; Type: SCHEMA; Schema: -; Owner: openatlas
--

CREATE SCHEMA gis;


ALTER SCHEMA gis OWNER TO openatlas;

--
-- Name: SCHEMA gis; Type: COMMENT; Schema: -; Owner: openatlas
--

COMMENT ON SCHEMA gis IS 'All geospatial information is stored here';


--
-- Name: import; Type: SCHEMA; Schema: -; Owner: openatlas
--

CREATE SCHEMA import;


ALTER SCHEMA import OWNER TO openatlas;

--
-- Name: SCHEMA import; Type: COMMENT; Schema: -; Owner: openatlas
--

COMMENT ON SCHEMA import IS 'Information about data imports';


--
-- Name: model; Type: SCHEMA; Schema: -; Owner: openatlas
--

CREATE SCHEMA model;


ALTER SCHEMA model OWNER TO openatlas;

--
-- Name: SCHEMA model; Type: COMMENT; Schema: -; Owner: openatlas
--

COMMENT ON SCHEMA model IS 'The main schema, storing CIDOC CRM itself and model related project data';


--
-- Name: web; Type: SCHEMA; Schema: -; Owner: openatlas
--

CREATE SCHEMA web;


ALTER SCHEMA web OWNER TO openatlas;

--
-- Name: SCHEMA web; Type: COMMENT; Schema: -; Owner: openatlas
--

COMMENT ON SCHEMA web IS 'User interface and user account related information';


--
-- Name: delete_entity_related(); Type: FUNCTION; Schema: model; Owner: openatlas
--

CREATE FUNCTION model.delete_entity_related() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            -- Delete aliases (P1, P131)
            IF OLD.class_code IN ('E18', 'E21', 'E40', 'E74') THEN
                DELETE FROM model.entity WHERE id IN (SELECT range_id FROM model.link WHERE domain_id = OLD.id AND property_code IN ('P1', 'P131'));
            END IF;

            -- Delete location (E53) if it was a place, find or human remains
            IF OLD.class_code IN ('E18', 'E20', 'E22') THEN
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

--
-- Name: update_modified(); Type: FUNCTION; Schema: model; Owner: openatlas
--

CREATE FUNCTION model.update_modified() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

   NEW.modified = now();

   RETURN NEW;

END;

$$;


ALTER FUNCTION model.update_modified() OWNER TO openatlas;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: linestring; Type: TABLE; Schema: gis; Owner: openatlas
--

CREATE TABLE gis.linestring (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    name text,
    description text,
    type text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    geom public.geometry(LineString,4326)
);


ALTER TABLE gis.linestring OWNER TO openatlas;

--
-- Name: linestring_id_seq; Type: SEQUENCE; Schema: gis; Owner: openatlas
--

CREATE SEQUENCE gis.linestring_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gis.linestring_id_seq OWNER TO openatlas;

--
-- Name: linestring_id_seq; Type: SEQUENCE OWNED BY; Schema: gis; Owner: openatlas
--

ALTER SEQUENCE gis.linestring_id_seq OWNED BY gis.linestring.id;


--
-- Name: point; Type: TABLE; Schema: gis; Owner: openatlas
--

CREATE TABLE gis.point (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    name text,
    description text,
    type text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    geom public.geometry(Point,4326)
);


ALTER TABLE gis.point OWNER TO openatlas;

--
-- Name: point_id_seq; Type: SEQUENCE; Schema: gis; Owner: openatlas
--

CREATE SEQUENCE gis.point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gis.point_id_seq OWNER TO openatlas;

--
-- Name: point_id_seq; Type: SEQUENCE OWNED BY; Schema: gis; Owner: openatlas
--

ALTER SEQUENCE gis.point_id_seq OWNED BY gis.point.id;


--
-- Name: polygon; Type: TABLE; Schema: gis; Owner: openatlas
--

CREATE TABLE gis.polygon (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    name text,
    description text,
    type text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    geom public.geometry(Polygon,4326)
);


ALTER TABLE gis.polygon OWNER TO openatlas;

--
-- Name: polygon_id_seq; Type: SEQUENCE; Schema: gis; Owner: openatlas
--

CREATE SEQUENCE gis.polygon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gis.polygon_id_seq OWNER TO openatlas;

--
-- Name: polygon_id_seq; Type: SEQUENCE OWNED BY; Schema: gis; Owner: openatlas
--

ALTER SEQUENCE gis.polygon_id_seq OWNED BY gis.polygon.id;


--
-- Name: entity; Type: TABLE; Schema: import; Owner: openatlas
--

CREATE TABLE import.entity (
    id integer NOT NULL,
    project_id integer NOT NULL,
    origin_id text,
    entity_id integer NOT NULL,
    user_id integer,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE import.entity OWNER TO openatlas;

--
-- Name: entity_id_seq; Type: SEQUENCE; Schema: import; Owner: openatlas
--

CREATE SEQUENCE import.entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE import.entity_id_seq OWNER TO openatlas;

--
-- Name: entity_id_seq; Type: SEQUENCE OWNED BY; Schema: import; Owner: openatlas
--

ALTER SEQUENCE import.entity_id_seq OWNED BY import.entity.id;


--
-- Name: project; Type: TABLE; Schema: import; Owner: openatlas
--

CREATE TABLE import.project (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE import.project OWNER TO openatlas;

--
-- Name: project_id_seq; Type: SEQUENCE; Schema: import; Owner: openatlas
--

CREATE SEQUENCE import.project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE import.project_id_seq OWNER TO openatlas;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: import; Owner: openatlas
--

ALTER SEQUENCE import.project_id_seq OWNED BY import.project.id;


--
-- Name: class; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.class (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    comment text
);


ALTER TABLE model.class OWNER TO openatlas;

--
-- Name: COLUMN class.code; Type: COMMENT; Schema: model; Owner: openatlas
--

COMMENT ON COLUMN model.class.code IS 'e.g. E21';


--
-- Name: COLUMN class.name; Type: COMMENT; Schema: model; Owner: openatlas
--

COMMENT ON COLUMN model.class.name IS 'e.g. Person';


--
-- Name: class_i18n; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.class_i18n (
    id integer NOT NULL,
    class_code text NOT NULL,
    language_code text NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified time without time zone
);


ALTER TABLE model.class_i18n OWNER TO openatlas;

--
-- Name: class_i18n_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.class_i18n_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.class_i18n_id_seq OWNER TO openatlas;

--
-- Name: class_i18n_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.class_i18n_id_seq OWNED BY model.class_i18n.id;


--
-- Name: class_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.class_id_seq OWNER TO openatlas;

--
-- Name: class_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.class_id_seq OWNED BY model.class.id;


--
-- Name: class_inheritance; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.class_inheritance (
    id integer NOT NULL,
    super_code text NOT NULL,
    sub_code text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE model.class_inheritance OWNER TO openatlas;

--
-- Name: class_inheritance_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.class_inheritance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.class_inheritance_id_seq OWNER TO openatlas;

--
-- Name: class_inheritance_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.class_inheritance_id_seq OWNED BY model.class_inheritance.id;


--
-- Name: entity; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.entity (
    id integer NOT NULL,
    class_code text NOT NULL,
    name text NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    system_type text,
    begin_from timestamp without time zone,
    begin_to timestamp without time zone,
    begin_comment text,
    end_from timestamp without time zone,
    end_to timestamp without time zone,
    end_comment text,
    system_class text NOT NULL
);


ALTER TABLE model.entity OWNER TO openatlas;

--
-- Name: entity_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.entity_id_seq OWNER TO openatlas;

--
-- Name: entity_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.entity_id_seq OWNED BY model.entity.id;


--
-- Name: link; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.link (
    id integer NOT NULL,
    property_code text NOT NULL,
    domain_id integer NOT NULL,
    range_id integer NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    type_id integer,
    begin_from timestamp without time zone,
    begin_to timestamp without time zone,
    begin_comment text,
    end_from timestamp without time zone,
    end_to timestamp without time zone,
    end_comment text
);


ALTER TABLE model.link OWNER TO openatlas;

--
-- Name: link_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.link_id_seq OWNER TO openatlas;

--
-- Name: link_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.link_id_seq OWNED BY model.link.id;


--
-- Name: property; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.property (
    id integer NOT NULL,
    code text NOT NULL,
    range_class_code text NOT NULL,
    domain_class_code text NOT NULL,
    name text NOT NULL,
    name_inverse text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    comment text
);


ALTER TABLE model.property OWNER TO openatlas;

--
-- Name: property_i18n; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.property_i18n (
    id integer NOT NULL,
    property_code text NOT NULL,
    language_code text NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    text_inverse text
);


ALTER TABLE model.property_i18n OWNER TO openatlas;

--
-- Name: property_i18n_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.property_i18n_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.property_i18n_id_seq OWNER TO openatlas;

--
-- Name: property_i18n_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.property_i18n_id_seq OWNED BY model.property_i18n.id;


--
-- Name: property_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.property_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.property_id_seq OWNER TO openatlas;

--
-- Name: property_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.property_id_seq OWNED BY model.property.id;


--
-- Name: property_inheritance; Type: TABLE; Schema: model; Owner: openatlas
--

CREATE TABLE model.property_inheritance (
    id integer NOT NULL,
    super_code text NOT NULL,
    sub_code text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE model.property_inheritance OWNER TO openatlas;

--
-- Name: property_inheritance_id_seq; Type: SEQUENCE; Schema: model; Owner: openatlas
--

CREATE SEQUENCE model.property_inheritance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE model.property_inheritance_id_seq OWNER TO openatlas;

--
-- Name: property_inheritance_id_seq; Type: SEQUENCE OWNED BY; Schema: model; Owner: openatlas
--

ALTER SEQUENCE model.property_inheritance_id_seq OWNED BY model.property_inheritance.id;


--
-- Name: entity_profile_image; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.entity_profile_image (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    image_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE web.entity_profile_image OWNER TO openatlas;

--
-- Name: entity_profile_image_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.entity_profile_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.entity_profile_image_id_seq OWNER TO openatlas;

--
-- Name: entity_profile_image_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.entity_profile_image_id_seq OWNED BY web.entity_profile_image.id;


--
-- Name: form; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.form (
    id integer NOT NULL,
    name text NOT NULL,
    extendable boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web.form OWNER TO openatlas;

--
-- Name: form_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.form_id_seq OWNER TO openatlas;

--
-- Name: form_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.form_id_seq OWNED BY web.form.id;


--
-- Name: group; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web."group" (
    id integer NOT NULL,
    name text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web."group" OWNER TO openatlas;

--
-- Name: group_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.group_id_seq OWNER TO openatlas;

--
-- Name: group_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.group_id_seq OWNED BY web."group".id;


--
-- Name: hierarchy; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.hierarchy (
    id integer NOT NULL,
    name text NOT NULL,
    multiple boolean DEFAULT false NOT NULL,
    standard boolean DEFAULT false NOT NULL,
    directional boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    value_type boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL
);


ALTER TABLE web.hierarchy OWNER TO openatlas;

--
-- Name: COLUMN hierarchy.id; Type: COMMENT; Schema: web; Owner: openatlas
--

COMMENT ON COLUMN web.hierarchy.id IS 'same as model.entity.id';


--
-- Name: COLUMN hierarchy.name; Type: COMMENT; Schema: web; Owner: openatlas
--

COMMENT ON COLUMN web.hierarchy.name IS 'same as model.entity.name, to ensure unique root type names';


--
-- Name: COLUMN hierarchy.value_type; Type: COMMENT; Schema: web; Owner: openatlas
--

COMMENT ON COLUMN web.hierarchy.value_type IS 'True if links to this type can have numeric values';


--
-- Name: COLUMN hierarchy.locked; Type: COMMENT; Schema: web; Owner: openatlas
--

COMMENT ON COLUMN web.hierarchy.locked IS 'True if these types are not editable';


--
-- Name: hierarchy_form; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.hierarchy_form (
    id integer NOT NULL,
    hierarchy_id integer NOT NULL,
    form_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web.hierarchy_form OWNER TO openatlas;

--
-- Name: hierarchy_form_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.hierarchy_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.hierarchy_form_id_seq OWNER TO openatlas;

--
-- Name: hierarchy_form_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.hierarchy_form_id_seq OWNED BY web.hierarchy_form.id;


--
-- Name: hierarchy_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.hierarchy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.hierarchy_id_seq OWNER TO openatlas;

--
-- Name: hierarchy_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.hierarchy_id_seq OWNED BY web.hierarchy.id;


--
-- Name: i18n; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.i18n (
    id integer NOT NULL,
    name text NOT NULL,
    language text NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web.i18n OWNER TO openatlas;

--
-- Name: i18n_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.i18n_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.i18n_id_seq OWNER TO openatlas;

--
-- Name: i18n_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.i18n_id_seq OWNED BY web.i18n.id;


--
-- Name: system_log; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.system_log (
    id integer NOT NULL,
    priority integer NOT NULL,
    type text,
    message text NOT NULL,
    user_id integer,
    info text,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE web.system_log OWNER TO openatlas;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.log_id_seq OWNER TO openatlas;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.log_id_seq OWNED BY web.system_log.id;


--
-- Name: map_overlay; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.map_overlay (
    id integer NOT NULL,
    image_id integer NOT NULL,
    place_id integer NOT NULL,
    link_id integer NOT NULL,
    bounding_box text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web.map_overlay OWNER TO openatlas;

--
-- Name: COLUMN map_overlay.link_id; Type: COMMENT; Schema: web; Owner: openatlas
--

COMMENT ON COLUMN web.map_overlay.link_id IS 'Used to remove overlay entry if link is removed';


--
-- Name: map_overlay_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.map_overlay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.map_overlay_id_seq OWNER TO openatlas;

--
-- Name: map_overlay_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.map_overlay_id_seq OWNED BY web.map_overlay.id;


--
-- Name: reference_system; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.reference_system (
    entity_id integer NOT NULL,
    name text NOT NULL,
    resolver_url text,
    website_url text,
    precision_default_id integer,
    identifier_example text,
    system boolean DEFAULT false NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE web.reference_system OWNER TO openatlas;

--
-- Name: COLUMN reference_system.system; Type: COMMENT; Schema: web; Owner: openatlas
--

COMMENT ON COLUMN web.reference_system.system IS 'True if integrated in the application. Can not be deleted or renamed in the UI.';


--
-- Name: reference_system_form; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.reference_system_form (
    id integer NOT NULL,
    reference_system_id integer NOT NULL,
    form_id integer NOT NULL
);


ALTER TABLE web.reference_system_form OWNER TO openatlas;

--
-- Name: reference_system_form_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.reference_system_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.reference_system_form_id_seq OWNER TO openatlas;

--
-- Name: reference_system_form_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.reference_system_form_id_seq OWNED BY web.reference_system_form.id;


--
-- Name: settings; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.settings (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


ALTER TABLE web.settings OWNER TO openatlas;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.settings_id_seq OWNER TO openatlas;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.settings_id_seq OWNED BY web.settings.id;


--
-- Name: user; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web."user" (
    id integer NOT NULL,
    group_id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    active boolean DEFAULT false NOT NULL,
    real_name text DEFAULT ''::text NOT NULL,
    email text,
    info text DEFAULT ''::text NOT NULL,
    login_last_success timestamp without time zone,
    login_last_failure timestamp without time zone,
    login_failed_count integer DEFAULT 0 NOT NULL,
    password_reset_code text,
    password_reset_date timestamp without time zone,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    unsubscribe_code text
);


ALTER TABLE web."user" OWNER TO openatlas;

--
-- Name: user_bookmarks; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.user_bookmarks (
    id integer NOT NULL,
    user_id integer NOT NULL,
    entity_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web.user_bookmarks OWNER TO openatlas;

--
-- Name: user_bookmarks_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.user_bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.user_bookmarks_id_seq OWNER TO openatlas;

--
-- Name: user_bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.user_bookmarks_id_seq OWNED BY web.user_bookmarks.id;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.user_id_seq OWNER TO openatlas;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.user_id_seq OWNED BY web."user".id;


--
-- Name: user_log; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.user_log (
    id integer NOT NULL,
    user_id integer NOT NULL,
    entity_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    action text NOT NULL
);


ALTER TABLE web.user_log OWNER TO openatlas;

--
-- Name: user_log_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.user_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.user_log_id_seq OWNER TO openatlas;

--
-- Name: user_log_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.user_log_id_seq OWNED BY web.user_log.id;


--
-- Name: user_notes; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.user_notes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    entity_id integer NOT NULL,
    text text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone,
    public boolean DEFAULT false NOT NULL
);


ALTER TABLE web.user_notes OWNER TO openatlas;

--
-- Name: user_notes_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.user_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.user_notes_id_seq OWNER TO openatlas;

--
-- Name: user_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.user_notes_id_seq OWNED BY web.user_notes.id;


--
-- Name: user_settings; Type: TABLE; Schema: web; Owner: openatlas
--

CREATE TABLE web.user_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone
);


ALTER TABLE web.user_settings OWNER TO openatlas;

--
-- Name: user_settings_id_seq; Type: SEQUENCE; Schema: web; Owner: openatlas
--

CREATE SEQUENCE web.user_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE web.user_settings_id_seq OWNER TO openatlas;

--
-- Name: user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: web; Owner: openatlas
--

ALTER SEQUENCE web.user_settings_id_seq OWNED BY web.user_settings.id;


--
-- Name: linestring id; Type: DEFAULT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.linestring ALTER COLUMN id SET DEFAULT nextval('gis.linestring_id_seq'::regclass);


--
-- Name: point id; Type: DEFAULT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.point ALTER COLUMN id SET DEFAULT nextval('gis.point_id_seq'::regclass);


--
-- Name: polygon id; Type: DEFAULT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.polygon ALTER COLUMN id SET DEFAULT nextval('gis.polygon_id_seq'::regclass);


--
-- Name: entity id; Type: DEFAULT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.entity ALTER COLUMN id SET DEFAULT nextval('import.entity_id_seq'::regclass);


--
-- Name: project id; Type: DEFAULT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.project ALTER COLUMN id SET DEFAULT nextval('import.project_id_seq'::regclass);


--
-- Name: class id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class ALTER COLUMN id SET DEFAULT nextval('model.class_id_seq'::regclass);


--
-- Name: class_i18n id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_i18n ALTER COLUMN id SET DEFAULT nextval('model.class_i18n_id_seq'::regclass);


--
-- Name: class_inheritance id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_inheritance ALTER COLUMN id SET DEFAULT nextval('model.class_inheritance_id_seq'::regclass);


--
-- Name: entity id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.entity ALTER COLUMN id SET DEFAULT nextval('model.entity_id_seq'::regclass);


--
-- Name: link id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.link ALTER COLUMN id SET DEFAULT nextval('model.link_id_seq'::regclass);


--
-- Name: property id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property ALTER COLUMN id SET DEFAULT nextval('model.property_id_seq'::regclass);


--
-- Name: property_i18n id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_i18n ALTER COLUMN id SET DEFAULT nextval('model.property_i18n_id_seq'::regclass);


--
-- Name: property_inheritance id; Type: DEFAULT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_inheritance ALTER COLUMN id SET DEFAULT nextval('model.property_inheritance_id_seq'::regclass);


--
-- Name: entity_profile_image id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.entity_profile_image ALTER COLUMN id SET DEFAULT nextval('web.entity_profile_image_id_seq'::regclass);


--
-- Name: form id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.form ALTER COLUMN id SET DEFAULT nextval('web.form_id_seq'::regclass);


--
-- Name: group id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."group" ALTER COLUMN id SET DEFAULT nextval('web.group_id_seq'::regclass);


--
-- Name: hierarchy id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy ALTER COLUMN id SET DEFAULT nextval('web.hierarchy_id_seq'::regclass);


--
-- Name: hierarchy_form id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy_form ALTER COLUMN id SET DEFAULT nextval('web.hierarchy_form_id_seq'::regclass);


--
-- Name: i18n id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.i18n ALTER COLUMN id SET DEFAULT nextval('web.i18n_id_seq'::regclass);


--
-- Name: map_overlay id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.map_overlay ALTER COLUMN id SET DEFAULT nextval('web.map_overlay_id_seq'::regclass);


--
-- Name: reference_system_form id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system_form ALTER COLUMN id SET DEFAULT nextval('web.reference_system_form_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.settings ALTER COLUMN id SET DEFAULT nextval('web.settings_id_seq'::regclass);


--
-- Name: system_log id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.system_log ALTER COLUMN id SET DEFAULT nextval('web.log_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."user" ALTER COLUMN id SET DEFAULT nextval('web.user_id_seq'::regclass);


--
-- Name: user_bookmarks id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_bookmarks ALTER COLUMN id SET DEFAULT nextval('web.user_bookmarks_id_seq'::regclass);


--
-- Name: user_log id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_log ALTER COLUMN id SET DEFAULT nextval('web.user_log_id_seq'::regclass);


--
-- Name: user_notes id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_notes ALTER COLUMN id SET DEFAULT nextval('web.user_notes_id_seq'::regclass);


--
-- Name: user_settings id; Type: DEFAULT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_settings ALTER COLUMN id SET DEFAULT nextval('web.user_settings_id_seq'::regclass);


--
-- Name: linestring linestring_pkey; Type: CONSTRAINT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.linestring
    ADD CONSTRAINT linestring_pkey PRIMARY KEY (id);


--
-- Name: point point_pkey; Type: CONSTRAINT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.point
    ADD CONSTRAINT point_pkey PRIMARY KEY (id);


--
-- Name: polygon polygon_pkey; Type: CONSTRAINT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.polygon
    ADD CONSTRAINT polygon_pkey PRIMARY KEY (id);


--
-- Name: entity entity_pkey; Type: CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.entity
    ADD CONSTRAINT entity_pkey PRIMARY KEY (id);


--
-- Name: entity entity_project_id_origin_id_key; Type: CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.entity
    ADD CONSTRAINT entity_project_id_origin_id_key UNIQUE (project_id, origin_id);


--
-- Name: project project_name_key; Type: CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.project
    ADD CONSTRAINT project_name_key UNIQUE (name);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: class class_code_key; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class
    ADD CONSTRAINT class_code_key UNIQUE (code);


--
-- Name: class_i18n class_i18n_class_code_language_code_key; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_i18n
    ADD CONSTRAINT class_i18n_class_code_language_code_key UNIQUE (class_code, language_code);


--
-- Name: class_i18n class_i18n_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_i18n
    ADD CONSTRAINT class_i18n_pkey PRIMARY KEY (id);


--
-- Name: class_inheritance class_inheritance_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_inheritance
    ADD CONSTRAINT class_inheritance_pkey PRIMARY KEY (id);


--
-- Name: class_inheritance class_inheritance_super_id_sub_id_key; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_inheritance
    ADD CONSTRAINT class_inheritance_super_id_sub_id_key UNIQUE (super_code, sub_code);


--
-- Name: class class_name_key; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class
    ADD CONSTRAINT class_name_key UNIQUE (name);


--
-- Name: class class_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);


--
-- Name: entity entity_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.entity
    ADD CONSTRAINT entity_pkey PRIMARY KEY (id);


--
-- Name: link link_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.link
    ADD CONSTRAINT link_pkey PRIMARY KEY (id);


--
-- Name: property property_code_key; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property
    ADD CONSTRAINT property_code_key UNIQUE (code);


--
-- Name: property_i18n property_i18n_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_i18n
    ADD CONSTRAINT property_i18n_pkey PRIMARY KEY (id);


--
-- Name: property_i18n property_i18n_property_code_language_code_key; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_i18n
    ADD CONSTRAINT property_i18n_property_code_language_code_key UNIQUE (property_code, language_code);


--
-- Name: property_inheritance property_inheritance_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_inheritance
    ADD CONSTRAINT property_inheritance_pkey PRIMARY KEY (id);


--
-- Name: property property_pkey; Type: CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property
    ADD CONSTRAINT property_pkey PRIMARY KEY (id);


--
-- Name: entity_profile_image entity_profile_image_entity_id_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.entity_profile_image
    ADD CONSTRAINT entity_profile_image_entity_id_key UNIQUE (entity_id);


--
-- Name: entity_profile_image entity_profile_image_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.entity_profile_image
    ADD CONSTRAINT entity_profile_image_pkey PRIMARY KEY (id);


--
-- Name: form form_name_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.form
    ADD CONSTRAINT form_name_key UNIQUE (name);


--
-- Name: form form_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.form
    ADD CONSTRAINT form_pkey PRIMARY KEY (id);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: hierarchy_form hierarchy_form_hierarchy_id_form_id_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy_form
    ADD CONSTRAINT hierarchy_form_hierarchy_id_form_id_key UNIQUE (hierarchy_id, form_id);


--
-- Name: hierarchy_form hierarchy_form_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy_form
    ADD CONSTRAINT hierarchy_form_pkey PRIMARY KEY (id);


--
-- Name: hierarchy hierarchy_name_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy
    ADD CONSTRAINT hierarchy_name_key UNIQUE (name);


--
-- Name: hierarchy hierarchy_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy
    ADD CONSTRAINT hierarchy_pkey PRIMARY KEY (id);


--
-- Name: i18n i18n_name_language_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.i18n
    ADD CONSTRAINT i18n_name_language_key UNIQUE (name, language);


--
-- Name: i18n i18n_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.i18n
    ADD CONSTRAINT i18n_pkey PRIMARY KEY (id);


--
-- Name: system_log log_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.system_log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: map_overlay map_overlay_image_id_place_id_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.map_overlay
    ADD CONSTRAINT map_overlay_image_id_place_id_key UNIQUE (image_id, place_id);


--
-- Name: map_overlay map_overlay_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.map_overlay
    ADD CONSTRAINT map_overlay_pkey PRIMARY KEY (id);


--
-- Name: reference_system_form reference_system_form_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system_form
    ADD CONSTRAINT reference_system_form_pkey PRIMARY KEY (id);


--
-- Name: reference_system_form reference_system_form_reference_system_id_form_id_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system_form
    ADD CONSTRAINT reference_system_form_reference_system_id_form_id_key UNIQUE (reference_system_id, form_id);


--
-- Name: reference_system reference_system_name_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system
    ADD CONSTRAINT reference_system_name_key UNIQUE (name);


--
-- Name: reference_system reference_system_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system
    ADD CONSTRAINT reference_system_pkey PRIMARY KEY (entity_id);


--
-- Name: settings settings_name_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.settings
    ADD CONSTRAINT settings_name_key UNIQUE (name);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: user unsubscribe_code_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."user"
    ADD CONSTRAINT unsubscribe_code_key UNIQUE (unsubscribe_code);


--
-- Name: user_bookmarks user_bookmarks_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_bookmarks
    ADD CONSTRAINT user_bookmarks_pkey PRIMARY KEY (id);


--
-- Name: user_bookmarks user_bookmarks_user_id_entity_id_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_bookmarks
    ADD CONSTRAINT user_bookmarks_user_id_entity_id_key UNIQUE (user_id, entity_id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user_log user_log_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_log
    ADD CONSTRAINT user_log_pkey PRIMARY KEY (id);


--
-- Name: user_notes user_notes_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_notes
    ADD CONSTRAINT user_notes_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_settings
    ADD CONSTRAINT user_settings_pkey PRIMARY KEY (id);


--
-- Name: user_settings user_settings_user_id_name_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_settings
    ADD CONSTRAINT user_settings_user_id_name_key UNIQUE (user_id, name);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: linestring update_modified; Type: TRIGGER; Schema: gis; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON gis.linestring FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: point update_modified; Type: TRIGGER; Schema: gis; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON gis.point FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: polygon update_modified; Type: TRIGGER; Schema: gis; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON gis.polygon FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: project update_modified; Type: TRIGGER; Schema: import; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON import.project FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: entity on_delete_entity; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER on_delete_entity BEFORE DELETE ON model.entity FOR EACH ROW EXECUTE PROCEDURE model.delete_entity_related();


--
-- Name: class update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.class FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: class_i18n update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.class_i18n FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: class_inheritance update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.class_inheritance FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: entity update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.entity FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: link update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.link FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: property update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.property FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: property_i18n update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.property_i18n FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: property_inheritance update_modified; Type: TRIGGER; Schema: model; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON model.property_inheritance FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: form update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.form FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: group update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web."group" FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: hierarchy update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.hierarchy FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: hierarchy_form update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.hierarchy_form FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: i18n update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.i18n FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: map_overlay update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.map_overlay FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: reference_system update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.reference_system FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: user update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web."user" FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: user_bookmarks update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.user_bookmarks FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: user_notes update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.user_notes FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: user_settings update_modified; Type: TRIGGER; Schema: web; Owner: openatlas
--

CREATE TRIGGER update_modified BEFORE UPDATE ON web.user_settings FOR EACH ROW EXECUTE PROCEDURE model.update_modified();


--
-- Name: linestring linestring_entity_id_fkey; Type: FK CONSTRAINT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.linestring
    ADD CONSTRAINT linestring_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: point point_entity_id_fkey; Type: FK CONSTRAINT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.point
    ADD CONSTRAINT point_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: polygon polygon_entity_id_fkey; Type: FK CONSTRAINT; Schema: gis; Owner: openatlas
--

ALTER TABLE ONLY gis.polygon
    ADD CONSTRAINT polygon_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entity entity_entity_id_fkey; Type: FK CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.entity
    ADD CONSTRAINT entity_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entity entity_project_id_fkey; Type: FK CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.entity
    ADD CONSTRAINT entity_project_id_fkey FOREIGN KEY (project_id) REFERENCES import.project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entity entity_user_id_fkey; Type: FK CONSTRAINT; Schema: import; Owner: openatlas
--

ALTER TABLE ONLY import.entity
    ADD CONSTRAINT entity_user_id_fkey FOREIGN KEY (user_id) REFERENCES web."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class_i18n class_i18n_class_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_i18n
    ADD CONSTRAINT class_i18n_class_code_fkey FOREIGN KEY (class_code) REFERENCES model.class(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class_inheritance class_inheritance_sub_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_inheritance
    ADD CONSTRAINT class_inheritance_sub_code_fkey FOREIGN KEY (sub_code) REFERENCES model.class(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class_inheritance class_inheritance_super_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.class_inheritance
    ADD CONSTRAINT class_inheritance_super_code_fkey FOREIGN KEY (super_code) REFERENCES model.class(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entity entity_class_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.entity
    ADD CONSTRAINT entity_class_code_fkey FOREIGN KEY (class_code) REFERENCES model.class(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: link link_domain_id_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.link
    ADD CONSTRAINT link_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: link link_property_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.link
    ADD CONSTRAINT link_property_code_fkey FOREIGN KEY (property_code) REFERENCES model.property(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: link link_range_id_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.link
    ADD CONSTRAINT link_range_id_fkey FOREIGN KEY (range_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: link link_type_id_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.link
    ADD CONSTRAINT link_type_id_fkey FOREIGN KEY (type_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: property property_domain_class_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property
    ADD CONSTRAINT property_domain_class_code_fkey FOREIGN KEY (domain_class_code) REFERENCES model.class(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: property_i18n property_i18n_property_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_i18n
    ADD CONSTRAINT property_i18n_property_code_fkey FOREIGN KEY (property_code) REFERENCES model.property(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: property_inheritance property_inheritance_sub_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_inheritance
    ADD CONSTRAINT property_inheritance_sub_code_fkey FOREIGN KEY (sub_code) REFERENCES model.property(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: property_inheritance property_inheritance_super_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property_inheritance
    ADD CONSTRAINT property_inheritance_super_code_fkey FOREIGN KEY (super_code) REFERENCES model.property(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: property property_range_class_code_fkey; Type: FK CONSTRAINT; Schema: model; Owner: openatlas
--

ALTER TABLE ONLY model.property
    ADD CONSTRAINT property_range_class_code_fkey FOREIGN KEY (range_class_code) REFERENCES model.class(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entity_profile_image entity_profile_image_entity_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.entity_profile_image
    ADD CONSTRAINT entity_profile_image_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entity_profile_image entity_profile_image_image_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.entity_profile_image
    ADD CONSTRAINT entity_profile_image_image_id_fkey FOREIGN KEY (image_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hierarchy_form hierarchy_form_form_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy_form
    ADD CONSTRAINT hierarchy_form_form_id_fkey FOREIGN KEY (form_id) REFERENCES web.form(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hierarchy_form hierarchy_form_hierarchy_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy_form
    ADD CONSTRAINT hierarchy_form_hierarchy_id_fkey FOREIGN KEY (hierarchy_id) REFERENCES web.hierarchy(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hierarchy hierarchy_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.hierarchy
    ADD CONSTRAINT hierarchy_id_fkey FOREIGN KEY (id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_overlay map_overlay_image_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.map_overlay
    ADD CONSTRAINT map_overlay_image_id_fkey FOREIGN KEY (image_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_overlay map_overlay_link_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.map_overlay
    ADD CONSTRAINT map_overlay_link_id_fkey FOREIGN KEY (link_id) REFERENCES model.link(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_overlay map_overlay_place_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.map_overlay
    ADD CONSTRAINT map_overlay_place_id_fkey FOREIGN KEY (place_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reference_system reference_system_entity_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system
    ADD CONSTRAINT reference_system_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reference_system_form reference_system_form_form_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system_form
    ADD CONSTRAINT reference_system_form_form_id_fkey FOREIGN KEY (form_id) REFERENCES web.form(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reference_system_form reference_system_form_reference_system_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system_form
    ADD CONSTRAINT reference_system_form_reference_system_id_fkey FOREIGN KEY (reference_system_id) REFERENCES web.reference_system(entity_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reference_system reference_system_precision_default_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.reference_system
    ADD CONSTRAINT reference_system_precision_default_id_fkey FOREIGN KEY (precision_default_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_bookmarks user_bookmarks_entity_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_bookmarks
    ADD CONSTRAINT user_bookmarks_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_bookmarks user_bookmarks_user_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_bookmarks
    ADD CONSTRAINT user_bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES web."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user user_group_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web."user"
    ADD CONSTRAINT user_group_id_fkey FOREIGN KEY (group_id) REFERENCES web."group"(id) ON UPDATE CASCADE;


--
-- Name: user_notes user_notes_entity_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_notes
    ADD CONSTRAINT user_notes_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES model.entity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_notes user_notes_user_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_notes
    ADD CONSTRAINT user_notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES web."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: web; Owner: openatlas
--

ALTER TABLE ONLY web.user_settings
    ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES web."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


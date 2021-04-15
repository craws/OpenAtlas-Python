
INSERT INTO web.group (name) VALUES
    ('admin'),
    ('contributor'),
    ('editor'),
    ('manager'),
    ('readonly');

INSERT INTO web.user (username, password, active, email, group_id) VALUES (
    'OpenAtlas',
    '$2b$12$O.apSfFsSbpmYLDW/0QgyeHHenbiT0D72NLgOOQ4Rkju/oS15rJTu',
    true,
    'test@example.com',
    (SELECT id FROM web.group WHERE name = 'admin'));

INSERT INTO web.settings (name, value) VALUES
    ('api_public', ''),
    ('default_language', 'en'),
    ('table_rows', '25'),
    ('failed_login_forget_minutes', '1'),
    ('failed_login_tries', '3'),
    ('file_upload_max_size', '10'),
    ('file_upload_allowed_extension', 'gif jpeg jpg pdf png txt zip'),
    ('geonames_username', 'openatlas'),
    ('log_level', '6'),
    ('logo_file_id', ''),
    ('mail', ''),
    ('mail_transport_username', ''),
    ('mail_transport_port', ''),
    ('mail_transport_host', ''),
    ('mail_from_email', ''),
    ('mail_from_name', ''),
    ('mail_recipients_feedback', ''),
    ('map_cluster_disable_at_zoom', '12'),
    ('map_cluster_max_radius', '50'),
    ('map_zoom_default', '12'),
    ('map_zoom_max', '18'),
    ('minimum_jstree_search', '1'),
    ('minimum_password_length', '12'),
    ('module_map_overlay', 'True'),
    ('module_sub_units', 'True'),
    ('profile_image_width', '200'),
    ('random_password_length', '16'),
    ('reset_confirm_hours', '24'),
    ('site_name', 'OpenAtlas');

-- External Reference Systems
INSERT INTO model.entity (name, class_code, description, system_class) VALUES
    ('GeoNames', 'E32', 'Geographical database covering all countries and many places.', 'reference_system'),
    ('Wikidata', 'E32', 'A free and open knowledge base and common source of open data providing persistent identifier and links to other sources.', 'reference_system');

INSERT INTO web.reference_system (system, name, entity_id, resolver_url, website_url, identifier_example)
VALUES (
            true,
            'GeoNames',
            (SELECT id FROM model.entity WHERE name = 'GeoNames' AND class_code = 'E32'),
            'https://www.geonames.org/',
            'https://www.geonames.org/',
            '1234567'),
       (
            true,
            'Wikidata',
            (SELECT id FROM model.entity WHERE name = 'Wikidata' AND class_code = 'E32'),
            'https://www.wikidata.org/entity/',
            'https://www.wikidata.org',
            'Q123');

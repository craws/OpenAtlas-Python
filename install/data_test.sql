
-- Create test user
INSERT INTO web.user (group_id, username, password, active, email) VALUES
    ((SELECT id FROM web.group WHERE name = 'admin'), 'Alice',    '$2b$12$yPQCBsSQdZxESEz79SFiOOZBLG2GZ9Cc2rzVMgZxXyW2y3T499LYK', True,  'alice@example.com'),
    ((SELECT id FROM web.group WHERE name = 'admin'), 'Inactive', '$2b$12$yPQCBsSQdZxESEz79SFiOOZBLG2GZ9Cc2rzVMgZxXyW2y3T499LYK', False, 'inactive@example.com'),
    ((SELECT id FROM web.group WHERE name = 'editor'), 'Editor',  '$2b$12$yPQCBsSQdZxESEz79SFiOOZBLG2GZ9Cc2rzVMgZxXyW2y3T499LYK', True,  'editor@example.com');

INSERT INTO web.user_settings (user_id, name, value) VALUES
    ((SELECT id FROM web.user WHERE username = 'Alice'), 'entity_show_dates', 'True'),
    ((SELECT id FROM web.user WHERE username = 'Alice'), 'entity_show_import', 'True'),
    ((SELECT id FROM web.user WHERE username = 'Alice'), 'entity_show_class', 'True'),
    ((SELECT id FROM web.user WHERE username = 'Alice'), 'entity_show_api', 'True');

-- Citation example
INSERT INTO web.i18n (name, language, text) VALUES
    ('citation_example', 'en', 'citation example');

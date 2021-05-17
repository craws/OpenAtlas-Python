-- Upgrade to 3.5.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Login mails where removed, so also removing setting for it
DELETE FROM web.settings WHERE NAME = 'mail_recipients_login';

COMMIT;

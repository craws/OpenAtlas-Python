-- Upgrade to 3.9.0, be sure to backup the database and read the update notes before executing this!

BEGIN;

-- Fix descriptions of OA shortcuts
UPDATE model.property_i18n SET text = 'OA8 is used to link the beginning of a persistent item''s (E77) life span (or time of usage) with a certain place. E.g to document the birthplace of a person. E77 Persistent Item linked with a E53 Place: E77 (Persistent Item) - P92i (was brought into existence by) - E63 (Beginning of Existence) - P7 (took place at) - E53 (Place) Example: [Albert Einstein (E21)] was brought into existence by [Birth of Albert Einstein (E12)] took place at [Ulm (E53)]'
WHERE property_code = 'OA8' AND language_code = 'en' AND attribute = 'comment';

UPDATE model.property_i18n SET text = 'OA9 is used to link the end of a persistent item''s (E77) life span (or time of usage) with a certain place. E.g to document a person''s place of death. E77 Persistent Item linked with a E53 Place: E77 (Persistent Item) - P93i (was taken out of existence by) - E64 (End of Existence) - P7 (took place at) - E53 (Place) Example: [Albert Einstein (E21)] was taken out of by [Death of Albert Einstein (E12)] took place at [Princeton (E53)]'
WHERE property_code = 'OA9' AND language_code = 'en' AND attribute = 'comment';

COMMIT;

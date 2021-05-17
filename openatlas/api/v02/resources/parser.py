from flask_restful import reqparse

from openatlas import app

app.config['BUNDLE_ERRORS'] = True

default_parser = reqparse.RequestParser()
default_parser.add_argument('download', type=bool, help='{error_msg}', default=False)
default_parser.add_argument('count', type=bool, help='{error_msg}', default=False)

language_parser = default_parser.copy()
language_parser.add_argument(
    'lang',
    type=str,
    help='{error_msg}',
    case_sensitive=False,
    choices=app.config['LANGUAGES'].keys())

entity_parser = default_parser.copy()
entity_parser.add_argument(
    'sort',
    choices=('desc', 'asc'),
    type=str,
    default='asc',
    case_sensitive=False,
    help='{error_msg}. Only "desc" or "asc" will work.')
entity_parser.add_argument(
    'column',
    type=str,
    default=['name'],
    action='append',
    case_sensitive=False,
    help='{error_msg}', choices=(
        'id', 'class_code', 'name', 'description', 'created', 'modified', 'system_class',
        'begin_from', 'begin_to', 'end_from', 'end_to'))
entity_parser.add_argument('filter', type=str, help='{error_msg}', action='append')
entity_parser.add_argument('limit', type=int, default=20, help="Invalid number for limit")
entity_parser.add_argument('first', type=int, help="Not a valid ID")
entity_parser.add_argument('last', type=int, help="Not a valid ID")
entity_parser.add_argument(
    'show',
    type=str,
    help='{error_msg}.',
    action='append',
    case_sensitive=False,
    default=['when', 'types', 'relations', 'names', 'links', 'geometry', 'depictions', 'geonames'],
    choices=(
        'when', 'types', 'relations', 'names', 'links', 'geometry', 'depictions', 'geonames',
        'none'))
entity_parser.add_argument('export', type=str, help='{error_msg}', choices='csv')

query_parser = entity_parser.copy()
query_parser.add_argument('entities', type=int, action='append', help="{error_msg}")
query_parser.add_argument('classes', type=str, action='append', help="{error_msg}")
query_parser.add_argument(
    'codes',
    type=str,
    action='append',
    help="{error_msg}",
    case_sensitive=False,
    choices=('actor', 'event', 'place', 'reference', 'source', 'artifact'))
query_parser.add_argument(
    'system_classes',
    type=str,
    action='append',
    help="{error_msg}",
    case_sensitive=False,
    choices=(
        'acquisition', 'activity', 'actor_appellation', 'administrative_unit', 'appellation',
        'artifact', 'bibliography', 'edition', 'external_reference', 'feature', 'file', 'find',
        'group', 'human_remains', 'move', 'object_location', 'person', 'place', 'source',
        'reference_system', 'stratigraphic_unit', 'source_translation', 'type'))

image_parser = default_parser.copy()
image_parser.add_argument('image_size', type=str, help="Not a valid size")

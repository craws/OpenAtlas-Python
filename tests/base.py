import pathlib
import unittest
from typing import Optional

import psycopg2

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.reference_system import ReferenceSystem


class TestBaseCase(unittest.TestCase):

    def setUp(self) -> None:
        app.testing = True
        app.config['SERVER_NAME'] = 'local.host'
        app.config['WTF_CSRF_ENABLED'] = False
        app.config['WTF_CSRF_METHODS'] = []  # This is the magic to disable CSRF for tests
        self.setup_database()
        self.app = app.test_client()
        self.login()  # Login on default because needed almost everywhere
        with app.app_context():  # type: ignore
            self.app.get('/')  # Needed to get fieldnames below, to initialise g or something
            self.precision_geonames = \
                'reference_system_precision_' + str(ReferenceSystem.get_by_name('GeoNames').id)
            self.precision_wikidata = \
                'reference_system_precision_' + str(ReferenceSystem.get_by_name('Wikidata').id)

    def login(self) -> None:
        with app.app_context():  # type: ignore
            self.app.post('/login', data={'username': 'Alice', 'password': 'test'})

    @staticmethod
    def setup_database() -> None:
        connection = psycopg2.connect(
            database=app.config['DATABASE_NAME'],
            host=app.config['DATABASE_HOST'],
            user=app.config['DATABASE_USER'],
            password=app.config['DATABASE_PASS'],
            port=app.config['DATABASE_PORT'])
        connection.autocommit = True
        cursor = connection.cursor()
        for file_name in ['1_structure.sql',
                          '2_data_model.sql',
                          '3_data_web.sql',
                          '4_data_node.sql',
                          'data_test.sql']:
            with open(pathlib.Path(app.root_path).parent / 'install' / file_name,
                      encoding='utf8') as sqlFile:
                cursor.execute(sqlFile.read())


def insert_entity(name: str,
                  class_: str,
                  origin: Optional[Entity] = None,
                  description: Optional[str] = None) -> Entity:
    entity = Entity.insert(class_, name, description)
    if class_ in ['place', 'feature', 'stratigraphic_unit', 'find', 'artifact']:
        location = Entity.insert('object_location', 'Location of ' + name)
        entity.link('P53', location)
        if origin:
            origin.link('P46', entity)
    return entity

import pathlib

from flask import url_for

from openatlas import app
from openatlas.models.entity import Entity
from tests.base import TestBaseCase


class ExportTest(TestBaseCase):

    def test_export(self) -> None:
        with app.app_context():  # type: ignore
            # Projects
            rv = self.app.get(url_for('import_project_insert'))
            assert b'Name *' in rv.data
            rv = self.app.post(url_for('import_project_insert'), data={'name': 'Project Import'})
            project_id = rv.location.split('/')[-1]
            rv = self.app.get(url_for('import_project_update', id_=project_id))
            assert b'Name *' in rv.data
            rv = self.app.post(
                url_for('import_project_update', id_=project_id),
                data={'name': 'Yup', 'description': 'whoa!'},
                follow_redirects=True)
            assert b'whoa!' in rv.data
            rv = self.app.post(
                url_for('import_project_insert'),
                data={'name': 'Yup'},
                follow_redirects=True)
            assert b'The name is already in use.' in rv.data
            rv = self.app.get(url_for('import_index'))
            assert b'Yup' in rv.data

            # Import data
            rv = self.app.get(url_for('import_data', class_='person', project_id=project_id))
            assert b'File *' in rv.data
            csv = pathlib.Path(app.root_path) / 'static' / 'import' / 'example.csv'
            with open(csv, 'rb') as file:
                rv = self.app.post(
                    url_for('import_data', class_='place', project_id=project_id),
                    data={'file': file, 'duplicate': True},
                    follow_redirects=True)
            assert b'Vienna' in rv.data
            with open(csv, 'rb') as file:
                rv = self.app.post(
                    url_for('import_data', class_='place', project_id=project_id),
                    data={'file': file, 'duplicate': True},
                    follow_redirects=True)
            assert b'IDs already in database' in rv.data
            with open(pathlib.Path(app.root_path) / 'static' / 'favicon.ico', 'rb') as file:
                rv = self.app.post(
                    url_for('import_data', class_='place', project_id=project_id),
                    data={'file': file},
                    follow_redirects=True)
            assert b'File type not allowed' in rv.data
            rv = self.app.get(url_for('import_project_view', id_=project_id))
            assert b'London' in rv.data

            # View an imported entity
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                place_id = Entity.get_by_class('place')[0].id
            rv = self.app.get(url_for('entity_view', id_=place_id))
            assert b'Yup' in rv.data

            rv = self.app.get(
                url_for('import_project_delete', id_=project_id),
                follow_redirects=True)
            assert b'Project deleted' in rv.data

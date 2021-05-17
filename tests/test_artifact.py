from flask import url_for

from openatlas import app
from openatlas.models.entity import Entity
from tests.base import TestBaseCase


class ArtifactTest(TestBaseCase):

    def test_artifact(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                source = Entity.insert('source', 'Necronomicon')

            rv = self.app.get(url_for('insert', class_='artifact'))
            assert b'+ Artifact' in rv.data
            rv = self.app.post(
                url_for('insert', class_='artifact'),
                data={'name': 'Love-letter'},
                follow_redirects=True)
            assert b'Love-letter' in rv.data
            rv = self.app.get(url_for('index', view='artifact'))
            assert b'Love-letter' in rv.data
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                artifact = Entity.get_by_view('artifact')[0]
            rv = self.app.get(url_for('update', id_=artifact.id))
            assert b'Love-letter' in rv.data
            rv = self.app.post(
                url_for('update', id_=artifact.id),
                follow_redirects=True,
                data={'name': 'A little hate', 'description': 'makes nothing better'})
            assert b'Changes have been saved' in rv.data

            # Add to artifact
            rv = self.app.get(url_for('entity_add_source', id_=artifact.id))
            assert b'Link source' in rv.data
            rv = self.app.post(
                url_for('entity_add_source', id_=artifact.id),
                data={'checkbox_values': str([source.id])},
                follow_redirects=True)
            assert b'Necronomicon' in rv.data

            # Add to event
            rv = self.app.get(url_for('insert', class_='move', origin_id=artifact.id))
            assert b'A little hate' in rv.data
            rv = self.app.post(
                url_for('insert', class_='move', origin_id=artifact.id),
                data={'name': 'Event Horizon', 'artifact': [artifact.id]},
                follow_redirects=True)
            assert b'Event Horizon' in rv.data

            rv = self.app.get(url_for('index', view='artifact', delete_id=artifact.id))
            assert b'has been deleted' in rv.data

            # Insert and continue
            rv = self.app.post(
                url_for('insert', class_='artifact'),
                data={'name': 'This will be continued', 'continue_': 'yes'},
                follow_redirects=True)
            assert b'An entry has been created' in rv.data

            # Artifact
            rv = self.app.get(url_for('insert', class_='artifact'))
            assert b'+ Artifact' in rv.data
            rv = self.app.post(
                url_for('insert', class_='artifact'),
                data={'name': 'Lucky coin'},
                follow_redirects=True)
            assert b'An entry has been created' in rv.data
            rv = self.app.get(url_for('index', view='artifact'))
            assert b'Lucky coin' in rv.data

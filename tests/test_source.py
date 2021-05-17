from flask import url_for

from openatlas import app
from openatlas.models.entity import Entity
from tests.base import TestBaseCase


class SourceTest(TestBaseCase):

    def test_source(self) -> None:
        with app.app_context():  # type: ignore
            # Source insert
            rv = self.app.get(url_for('insert', class_='source'))
            assert b'+ Source' in rv.data
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                origin = Entity.insert('person', 'David Duchovny', 'person')
                actor = Entity.insert('person', 'Gillian Anderson Gillian Anderson', 'person')
                artifact = Entity.insert('artifact', 'I care for you')
                inscribed_artifact = Entity.insert('artifact', 'Artifact with text')
                file = Entity.insert('file', 'X-Files')
                reference = Entity.insert('external_reference', 'https://openatlas.eu')

            rv = self.app.post(
                url_for('insert', class_='source', origin_id=origin.id),
                data={'name': 'Test source'},
                follow_redirects=True)
            assert b'An entry has been created' in rv.data
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                source = Entity.get_by_view('source')[0]
            rv = self.app.post(
                url_for('insert', class_='source', origin_id=reference.id),
                data={'name': 'Test source'},
                follow_redirects=True)
            assert b'https://openatlas.eu' in rv.data
            rv = self.app.post(
                url_for('insert', class_='source', origin_id=file.id),
                data={'name': 'Test source'},
                follow_redirects=True)
            assert b'An entry has been created' in rv.data and b'X-Files' in rv.data
            data = {'name': 'Test source', 'continue_': 'yes'}
            rv = self.app.post(url_for('insert', class_='source'), data=data, follow_redirects=True)
            assert b'An entry has been created' in rv.data

            rv = self.app.get(url_for('insert', class_='source', origin_id=artifact.id))
            assert b'I care for you' in rv.data
            rv = self.app.post(
                url_for('insert', class_='source', origin_id=artifact.id),
                data={'name': 'Necronomicon', 'artifact': [artifact.id]},
                follow_redirects=True)
            assert b'I care for you' in rv.data

            rv = self.app.get(url_for('index', view='source'))
            assert b'Test source' in rv.data

            # Link source
            rv = self.app.post(
                url_for('insert', class_='external_reference', origin_id=source.id),
                data={'name': 'https://openatlas.eu'},
                follow_redirects=True)
            assert b'Test source' in rv.data

            self.app.get(url_for('source_add', id_=source.id, origin_id=actor.id, view='actor'))
            rv = self.app.post(
                url_for('source_add', id_=source.id, view='actor'),
                data={'checkbox_values': [actor.id]},
                follow_redirects=True)
            assert b'Gillian Anderson' in rv.data
            rv = self.app.get(url_for('entity_view', id_=source.id))
            assert b'Gillian Anderson' in rv.data
            rv = self.app.get(url_for('source_add', id_=source.id, view='place'))
            assert b'Place' in rv.data

            # Update source
            rv = self.app.get(url_for('update', id_=source.id))
            assert b'Test source' in rv.data
            data = {
                'name': 'Source updated',
                'description': 'some description',
                'artifact': str([inscribed_artifact.id])}
            rv = self.app.post(url_for('update', id_=source.id), data=data, follow_redirects=True)
            assert b'Source updated' in rv.data
            assert b'Artifact with text' in rv.data
            rv = self.app.get(url_for('entity_view', id_=source.id))
            assert b'some description' in rv.data

            # Add to source
            rv = self.app.get(url_for('entity_add_reference', id_=source.id))
            assert b'Link reference' in rv.data
            rv = self.app.post(
                url_for('entity_add_reference', id_=source.id),
                data={'reference': reference.id, 'page': '777'},
                follow_redirects=True)
            assert b'777' in rv.data

            # Translations
            rv = self.app.get(url_for('translation_insert', source_id=source.id))
            assert b'+ Text' in rv.data
            data = {'name': 'Test translation'}
            rv = self.app.post(url_for('translation_insert', source_id=source.id), data=data)
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                translation_id = rv.location.split('/')[-1]
            rv = self.app.get(url_for('entity_view', id_=source.id))
            assert b'Test translation' in rv.data
            self.app.get(url_for('translation_update', id_=translation_id, source_id=source.id))
            rv = self.app.post(
                url_for('translation_update', id_=translation_id, source_id=source.id),
                data={'name': 'Translation updated'},
                follow_redirects=True)
            assert b'Translation updated' in rv.data
            rv = self.app.get(
                url_for('translation_delete', id_=translation_id, source_id=source.id),
                follow_redirects=True)
            assert b'The entry has been deleted.' in rv.data
            data = {'name': 'Translation continued', 'continue_': 'yes'}
            self.app.post(url_for('translation_insert', source_id=source.id), data=data)

            # Delete source
            rv = self.app.get(url_for('index', view='source', delete_id=source.id))
            assert b'The entry has been deleted.' in rv.data

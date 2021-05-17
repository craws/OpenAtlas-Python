import pathlib

from flask import url_for

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.node import Node
from tests.base import TestBaseCase


class FileTest(TestBaseCase):

    def test_event(self) -> None:
        with app.app_context():  # type: ignore
            # Create entities for file
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                actor = Entity.insert('person', 'File keeper')
                reference = Entity.insert('edition', 'Ancient Books')
                node_id = Node.get_hierarchy('Sex').subs[0]

            # Insert
            rv = self.app.get(url_for('insert', class_='file', origin_id=actor.id))
            assert b'+ File' in rv.data
            logo = pathlib.Path(app.root_path) / 'static' / 'images' / 'layout' / 'logo.png'
            with open(logo, 'rb') as img:
                rv = self.app.post(
                    url_for('insert', class_='file', origin_id=actor.id),
                    data={'name': 'OpenAtlas logo', 'file': img},
                    follow_redirects=True)
            assert b'An entry has been created' in rv.data
            with open(logo, 'rb') as img1, open(logo, 'rb') as img2:
                rv = self.app.post(
                    url_for('insert', class_='file', origin_id=actor.id),
                    data={'name': 'OpenAtlas logo', 'file': [img1, img2]},
                    follow_redirects=True)
            assert b'An entry has been created' in rv.data
            with open(logo, 'rb') as img:
                rv = self.app.post(
                    url_for('insert', class_='file', origin_id=reference.id),
                    data={'name': 'OpenAtlas logo', 'file': img},
                    follow_redirects=True)
            assert b'An entry has been created' in rv.data
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                files = Entity.get_by_class('file')
                file_id = files[0].id
                file_id2 = files[1].id

            # Logo
            rv = self.app.get(url_for('admin_logo'), data={'file': file_id}, follow_redirects=True)
            assert b'OpenAtlas logo' in rv.data
            with self.app.get(url_for('display_logo', filename=str(file_id) + '.png')):
                pass   # Test logo display, calling with "with" to prevent unclosed files warning
            rv = self.app.get(url_for('admin_logo', id_=file_id), follow_redirects=True)
            assert b'Remove custom logo' in rv.data
            rv = self.app.get(
                url_for('admin_index', action="remove_logo", id_=0),
                follow_redirects=True)
            assert b'Logo' in rv.data

            with open(pathlib.Path(app.root_path) / 'views' / 'index.py', 'rb') as invalid_file:
                rv = self.app.post(
                    url_for('insert', class_='file', origin_id=actor.id),
                    data={'name': 'Invalid file', 'file': invalid_file},
                    follow_redirects=True)
            assert b'File type not allowed' in rv.data

            rv = self.app.post(
                url_for('insert', class_='file', origin_id=actor.id),
                follow_redirects=True,
                data={'name': 'This is not a file'})
            assert b'This field is required' in rv.data

            # View
            rv = self.app.get(url_for('entity_view', id_=file_id))
            assert b'OpenAtlas logo' in rv.data
            rv = self.app.get(url_for('entity_view', id_=file_id2))
            assert b'OpenAtlas logo' in rv.data

            with self.app.get(url_for('download_file', filename=str(file_id) + '.png')):
                pass  # Calling with "with" to prevent unclosed files warning
            with self.app.get(url_for('display_file', filename=str(file_id) + '.png')):
                pass  # Calling with "with" to prevent unclosed files warning

            # Index
            rv = self.app.get(url_for('index', view='file'))
            assert b'OpenAtlas logo' in rv.data

            # Set and unset as main image
            self.app.get(
                url_for('set_profile_image', id_=file_id, origin_id=actor.id),
                follow_redirects=True)
            self.app.get(url_for('file_remove_profile_image', entity_id=actor.id))

            # Add to reference
            rv = self.app.get(url_for('reference_add', id_=reference.id, view='file'))
            assert b'OpenAtlas logo' in rv.data
            rv = self.app.post(
                url_for('reference_add', id_=reference.id, view='file'),
                data={'file': file_id, 'page': '777'},
                follow_redirects=True)
            assert b'777' in rv.data

            # Update
            rv = self.app.get(url_for('update', id_=file_id))
            assert b'OpenAtlas logo' in rv.data
            rv = self.app.post(
                url_for('update', id_=file_id),
                data={'name': 'Updated file'},
                follow_redirects=True)
            assert b'Changes have been saved' in rv.data and b'Updated file' in rv.data
            rv = self.app.get(url_for('file_add', id_=file_id, view='actor'))
            assert b'Link actor' in rv.data
            rv = self.app.post(
                url_for('file_add', id_=file_id, view='actor'),
                data={'checkbox_values': [actor.id]},
                follow_redirects=True)
            assert b'File keeper' in rv.data
            rv = self.app.post(
                url_for('entity_add_file', id_=node_id),
                data={'checkbox_values': str([file_id])},
                follow_redirects=True)
            assert b'Updated file' in rv.data

            # Delete
            rv = self.app.get(url_for('index', view='file', delete_id=file_id))
            assert b'The entry has been deleted' in rv.data

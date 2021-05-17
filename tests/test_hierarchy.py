from flask import url_for

from openatlas import app
from openatlas.models.node import Node
from tests.base import TestBaseCase


class HierarchyTest(TestBaseCase):

    def test_hierarchy(self) -> None:
        with app.app_context():  # type: ignore
            # Custom types
            data = {
                'name': 'Geronimo',
                'forms': [1, 2, 5, 6, 7, 8],
                'multiple': True,
                'description': 'Very important!'}
            rv = self.app.post(
                url_for('hierarchy_insert', param='custom'),
                follow_redirects=True,
                data=data)
            assert b'An entry has been created' in rv.data
            rv = self.app.post(
                url_for('hierarchy_insert', param='custom'),
                follow_redirects=True,
                data=data)
            assert b'The name is already in use' in rv.data
            with app.test_request_context():
                hierarchy = Node.get_hierarchy('Geronimo')
            rv = self.app.get(url_for('hierarchy_update', id_=hierarchy.id))
            assert b'Geronimo' in rv.data
            data['forms'] = [4]
            rv = self.app.post(
                url_for('hierarchy_update', id_=hierarchy.id),
                data=data,
                follow_redirects=True)
            assert b'Changes have been saved.' in rv.data

            rv = self.app.get(url_for('hierarchy_insert', param='custom'))
            assert b'+ Custom' in rv.data

            data = {'name': 'My secret node', 'description': 'Very important!'}
            rv = self.app.post(url_for('insert', class_='type', origin_id=hierarchy.id), data=data)
            node_id = rv.location.split('/')[-1]
            rv = self.app.get(
                url_for('hierarchy_remove_form', id_=hierarchy.id, form_id=5),
                follow_redirects=True)
            assert b'Changes have been saved.' in rv.data
            rv = self.app.get(url_for('node_delete', id_=node_id), follow_redirects=True)
            assert b'deleted' in rv.data

            rv = self.app.post(
                url_for('hierarchy_update', id_=hierarchy.id),
                data={'name': 'Actor actor relation'},
                follow_redirects=True)
            assert b'The name is already in use' in rv.data
            rv = self.app.post(url_for('hierarchy_delete', id_=hierarchy.id), follow_redirects=True)
            assert b'deleted' in rv.data

            # Value types
            rv = self.app.get(url_for('hierarchy_insert', param='value'))
            assert b'+ Value' in rv.data
            rv = self.app.post(
                url_for('hierarchy_insert', param='value'),
                follow_redirects=True,
                data={'name': 'A valued value', 'forms': [1], 'description': ''})
            assert b'An entry has been created' in rv.data
            with app.test_request_context():
                value_node = Node.get_hierarchy('A valued value')
            rv = self.app.get(url_for('hierarchy_update', id_=value_node.id))
            assert b'valued' in rv.data

            # Test checks
            actor_node = Node.get_hierarchy('Actor actor relation')
            rv = self.app.get(url_for('hierarchy_update', id_=actor_node.id), follow_redirects=True)
            assert b'Forbidden' in rv.data
            rv = self.app.get(url_for('hierarchy_delete', id_=actor_node.id), follow_redirects=True)
            assert b'Forbidden' in rv.data

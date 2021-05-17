from flask import g, url_for

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.node import Node
from tests.base import TestBaseCase


class NodeTest(TestBaseCase):

    def test_node(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                actor_node = Node.get_hierarchy('Actor actor relation')
                dimension_node = Node.get_hierarchy('Dimensions')
                sex_node = Node.get_hierarchy('Sex')
            rv = self.app.get(url_for('node_index'))
            assert b'Actor actor relation' in rv.data
            rv = self.app.get(url_for('insert', class_='type', origin_id=actor_node.id))
            assert b'Actor actor relation' in rv.data
            rv = self.app.post(
                url_for('insert', class_='type', origin_id=actor_node.id),
                data={'name_search': 'new'})
            assert b'Inverse' in rv.data
            data = {
                'name': 'My secret node',
                'name_inverse': 'Do I look inverse?',
                'description': 'Very important!'}
            rv = self.app.post(url_for('insert', class_='type', origin_id=actor_node.id), data=data)
            node_id = rv.location.split('/')[-1]
            rv = self.app.get(url_for('update', id_=node_id))
            assert b'My secret node' in rv.data and b'Super' in rv.data
            self.app.post(url_for('insert', class_='type', origin_id=sex_node.id), data=data)
            rv = self.app.post(url_for('update', id_=node_id), data=data, follow_redirects=True)
            assert b'Changes have been saved.' in rv.data

            # Insert an continue
            data['continue_'] = 'yes'
            rv = self.app.post(
                url_for('insert', class_='type', origin_id=actor_node.id),
                data=data,
                follow_redirects=True)
            assert b'An entry has been created' in rv.data
            data['continue_'] = ''

            # Forbidden system node
            rv = self.app.post(
                url_for('update', id_=actor_node.id),
                data=data,
                follow_redirects=True)
            assert b'Forbidden' in rv.data

            # Update with self as root
            data[str(actor_node.id)] = node_id
            rv = self.app.post(url_for('update', id_=node_id), data=data, follow_redirects=True)
            assert b'Type can&#39;t have itself as super.' in rv.data

            # Update with sub as root
            rv = self.app.post(url_for('insert', class_='type', origin_id=actor_node.id), data=data)
            sub_node_id = rv.location.split('/')[-1].replace('node#tab-', '')
            data[str(actor_node.id)] = sub_node_id
            rv = self.app.post(url_for('update', id_=node_id), data=data, follow_redirects=True)
            assert b'Type can&#39;t have a sub as super.' in rv.data

            # Custom type
            rv = self.app.get(url_for('entity_view', id_=sex_node.id), follow_redirects=True)
            assert b'Male' in rv.data

            # Administrative unit
            rv = self.app.get(
                url_for('entity_view', id_=Node.get_hierarchy('Administrative unit').id),
                follow_redirects=True)
            assert b'Austria' in rv.data

            # Value type
            rv = self.app.get(url_for('entity_view', id_=dimension_node.id), follow_redirects=True)
            assert b'Height' in rv.data
            rv = self.app.get(url_for('entity_view', id_=dimension_node.subs[0]))
            assert b'Unit' in rv.data
            rv = self.app.get(url_for('update', id_=dimension_node.subs[0]))
            assert b'Dimensions' in rv.data

            # Untyped entities

            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                actor = Entity.insert('person', 'Connor MacLeod')
            rv = self.app.get(url_for('show_untyped_entities', id_=sex_node.id))
            assert b'Connor MacLeod' in rv.data
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                actor.link('P2', g.nodes[sex_node.subs[0]])
            rv = self.app.get(url_for('show_untyped_entities', id_=sex_node.id))
            assert b'No entries' in rv.data

            # Delete
            rv = self.app.get(url_for('node_delete', id_=actor_node.id), follow_redirects=True)
            assert b'Forbidden' in rv.data
            rv = self.app.get(url_for('node_delete', id_=sub_node_id), follow_redirects=True)
            assert b'The entry has been deleted.' in rv.data

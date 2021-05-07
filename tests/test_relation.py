from flask import g, url_for

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.link import Link
from openatlas.models.node import Node
from tests.base import TestBaseCase


class RelationTests(TestBaseCase):

    def test_relation(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                actor = Entity.insert('person', 'Connor MacLeod')
                related = Entity.insert('person', 'The Kurgan')

            # Add relationship
            rv = self.app.get(url_for('relation_insert', origin_id=actor.id))
            assert b'Actor actor relation' in rv.data
            relation_id = Node.get_hierarchy('Actor actor relation').id
            relation_sub_id = g.nodes[relation_id].subs[0]
            relation_sub_id2 = g.nodes[relation_id].subs[1]
            data = {
                'actor': str([related.id]),
                relation_id: relation_sub_id,
                'inverse': None,
                'begin_year_from': '-1949',
                'begin_month_from': '10',
                'begin_day_from': '8',
                'begin_year_to': '-1948',
                'end_year_from': '2049',
                'end_year_to': '2050'}
            rv = self.app.post(
                url_for('relation_insert', origin_id=actor.id),
                data=data,
                follow_redirects=True)
            assert b'The Kurgan' in rv.data
            rv = self.app.get(url_for('entity_view', id_=relation_sub_id))
            assert b'Connor' in rv.data
            data['continue_'] = 'yes'
            data['inverse'] = True
            rv = self.app.post(
                url_for('relation_insert', origin_id=actor.id),
                data=data,
                follow_redirects=True)
            assert b'The Kurgan' in rv.data
            rv = self.app.get(url_for('entity_view', id_=actor.id))
            assert b'The Kurgan' in rv.data

            rv = self.app.post(
                url_for('relation_insert', origin_id=related.id),
                data=data,
                follow_redirects=True)
            assert b"link to itself" in rv.data

            # Relation types
            rv = self.app.get(url_for('node_move_entities', id_=relation_sub_id))
            assert b'The Kurgan' in rv.data

            # Update relationship
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                link_id = Link.get_links(actor.id, 'OA7')[0].id
                link_id2 = Link.get_links(actor.id, 'OA7', True)[0].id

            rv = self.app.post(
                url_for('node_move_entities', id_=relation_sub_id),
                follow_redirects=True,
                data={
                    relation_id: relation_sub_id2,
                    'selection': [link_id],
                    'checkbox_values': str([link_id])})
            assert b'Entities were updated' in rv.data
            rv = self.app.post(
                url_for('node_move_entities', id_=relation_sub_id2),
                data={relation_id: '', 'selection': [link_id], 'checkbox_values': str([link_id])},
                follow_redirects=True)
            assert b'Entities were updated' in rv.data

            rv = self.app.get(url_for('relation_update', id_=link_id, origin_id=related.id))
            assert b'Connor' in rv.data
            rv = self.app.post(
                url_for('relation_update', id_=link_id, origin_id=actor.id),
                data={'description': 'There can be only one!', 'inverse': True},
                follow_redirects=True)
            assert b'only one' in rv.data
            rv = self.app.post(
                url_for('relation_update', id_=link_id2, origin_id=actor.id),
                data={'description': 'There can be only one!', 'inverse': None},
                follow_redirects=True)
            assert b'only one' in rv.data

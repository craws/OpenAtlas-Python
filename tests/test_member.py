from flask import url_for

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.link import Link
from tests.base import TestBaseCase


class MemberTests(TestBaseCase):

    def test_member(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                actor = Entity.insert('person', 'Ripley')
                group = Entity.insert('group', 'Space Marines')

            # Add membership
            rv = self.app.get(url_for('member_insert', origin_id=group.id))
            assert b'Actor function' in rv.data
            rv = self.app.post(
                url_for('member_insert', origin_id=actor.id, code='membership'),
                data={'group': str([group.id])},
                follow_redirects=True)
            assert b'Space Marines' in rv.data
            rv = self.app.post(
                url_for('member_insert', origin_id=actor.id, code='membership'),
                data={'group': str([group.id]), 'continue_': 'yes'},
                follow_redirects=True)
            assert b'Space Marines' in rv.data
            rv = self.app.post(
                url_for('member_insert', origin_id=group.id, code='membership'),
                data={'group': str([group.id])})
            assert b"link to itself" in rv.data
            rv = self.app.post(
                url_for('member_insert', origin_id=actor.id),
                data={'actor': str([actor.id])},
                follow_redirects=True)
            assert b"link to itself" in rv.data

            # Add member to group
            data = {'actor': str([actor.id])}
            rv = self.app.post(
                url_for('member_insert', origin_id=group.id),
                data=data,
                follow_redirects=True)
            assert b'Ripley' in rv.data
            data['continue_'] = 'yes'
            rv = self.app.post(
                url_for('member_insert', origin_id=group.id),
                data=data,
                follow_redirects=True)
            assert b'Ripley' in rv.data

            # Update
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                link_id = Link.get_links(group.id, 'P107')[0].id
            rv = self.app.get(url_for('member_update', id_=link_id, origin_id=group.id))
            assert b'Ripley' in rv.data
            rv = self.app.post(
                url_for('member_update', id_=link_id, origin_id=group.id),
                data={'description': 'We are here to help you.'},
                follow_redirects=True)
            assert b'here to help' in rv.data

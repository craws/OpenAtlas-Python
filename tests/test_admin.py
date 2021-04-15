from flask import g, url_for

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.link import Link
from openatlas.models.node import Node
from tests.base import TestBaseCase


class ContentTests(TestBaseCase):

    def test_orphans_and_newsletter(self) -> None:
        with app.app_context():  # type: ignore
            self.app.post(
                url_for('insert', class_='person'),
                data={
                    'name': 'Oliver Twist',
                    self.precision_geonames: '',
                    self.precision_wikidata: ''})
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                Entity.insert('file', 'One forsaken file entity')  # Add orphaned file
            rv = self.app.get(url_for('admin_orphans'))
            assert all(x in rv.data for x in [b'Oliver Twist', b'forsaken'])
            rv = self.app.get(url_for('admin_newsletter'))
            assert b'Newsletter' in rv.data

    def test_logs(self) -> None:
        with app.app_context():  # type: ignore
            rv = self.app.get(url_for('admin_log'))
            assert b'Login' in rv.data
            rv = self.app.get(url_for('admin_log_delete', follow_redirects=True))
            assert b'Login' not in rv.data

    def test_links(self) -> None:
        from openatlas.database.entity import Entity
        from openatlas.database.link import Link
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                id_ = Entity.insert({
                    'name': 'Invalid linked entity',
                    'system_class': 'artifact',
                    'code': 'E13', 'description': ''})
                Link.insert({
                    'property_code': 'P86',
                    'domain_id': id_,
                    'range_id': id_,
                    'description': '',
                    'type_id': None})
                rv = self.app.get(url_for('admin_check_links'))
                assert b'Invalid linked entity' in rv.data

    def test_dates(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                # Create invalid dates for an actor and a relation link
                person = Entity.insert('person', 'Person')
                event = Entity.insert('activity', 'Event')
                person.begin_from = '2018-01-31'
                person.begin_to = '2018-01-01'
                person.update()
                involvement = Link.get_by_id(event.link('P11', person)[0])
                involvement.begin_from = '2017-01-31'
                involvement.begin_to = '2017-01-01'
                involvement.end_from = '2017-01-01'
                involvement.update()
            rv = self.app.get(url_for('admin_check_dates'))
            assert b'Invalid dates <span class="tab-counter">1' in rv.data
            assert b'Invalid link dates <span class="tab-counter">1' in rv.data
            assert b'Invalid involvement dates <span class="tab-counter">1' in rv.data

    def test_duplicates(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                event = Entity.insert('acquisition', 'Event Horizon')
                source = Entity.insert('source', 'Tha source')
                source.link('P67', event)
                source.link('P67', event)
                source_node = Node.get_hierarchy('Source')
                source.link('P2', g.nodes[source_node.subs[0]])
                source.link('P2', g.nodes[source_node.subs[1]])
            rv = self.app.get(url_for('admin_check_link_duplicates'))
            assert b'Event Horizon' in rv.data
            rv = self.app.get(
                url_for('admin_check_link_duplicates', delete='delete'),
                follow_redirects=True)
            assert b'Remove' in rv.data
            rv = self.app.get(
                url_for(
                    'admin_delete_single_type_duplicate',
                    entity_id=source.id,
                    node_id=source_node.subs[0]),
                follow_redirects=True)
            assert b'Congratulations, everything looks fine!' in rv.data

    def test_similar(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                Entity.insert('person', 'I have the same name!')
                Entity.insert('person', 'I have the same name!')
            rv = self.app.post(
                url_for('admin_check_similar'),
                follow_redirects=True,
                data={'classes': 'person', 'ratio': 100})
            assert b'I have the same name!' in rv.data
            rv = self.app.post(
                url_for('admin_check_similar'),
                follow_redirects=True,
                data={'classes': 'file', 'ratio': 100})
            assert b'No entries' in rv.data

    def test_settings(self) -> None:
        with app.app_context():  # type: ignore
            rv = self.app.get(url_for('admin_index'))
            assert b'User' in rv.data

            # Mail
            rv = self.app.get(url_for('admin_settings', category='mail'))
            assert b'Recipients feedback' in rv.data
            rv = self.app.post(
                url_for('admin_settings', category='mail'),
                follow_redirects=True,
                data={
                    'mail': True,
                    'mail_transport_username': 'whatever',
                    'mail_transport_host': 'localhost',
                    'mail_transport_port': '23',
                    'mail_from_email': 'max@example.com',
                    'mail_from_name': 'Max Headroom',
                    'mail_recipients_feedback': 'headroom@example.com'})
            assert b'Max Headroom' in rv.data

            rv = self.app.get(url_for('admin_settings', category='general'))
            assert b'Log level' in rv.data

            # Content
            rv = self.app.post(
                url_for('admin_content', item='citation_example'),
                data={'en': 'citation as example', 'de': ''},
                follow_redirects=True)
            assert b'Changes have been saved' in rv.data
            rv = self.app.get(url_for('insert', class_='edition'))
            assert b'citation as example' in rv.data
            rv = self.app.get(url_for('admin_content', item='legal_notice'))
            assert b'Save' in rv.data
            rv = self.app.post(
                url_for('admin_content', item='legal_notice'),
                data={'en': 'My legal notice', 'de': 'German notice'},
                follow_redirects=True)
            assert b'My legal notice' in rv.data
            self.app.get('/index/setlocale/de')
            rv = self.app.get(url_for('index_content', item='legal_notice'))
            assert b'German notice' in rv.data

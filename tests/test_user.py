from flask import url_for
from werkzeug.exceptions import abort

from openatlas import app
from openatlas.models.user import User
from tests.base import TestBaseCase


class UserTests(TestBaseCase):

    def test_user(self) -> None:
        data = {
            'active': '',
            'username': 'Ripley',
            'email': 'ripley@nostromo.org',
            'password': 'you_never_guess_this',
            'password2': 'you_never_guess_this',
            'group': 'admin',
            'name': 'Ripley Weaver',
            'description': '',
            'send_info': ''}
        data2 = {
            'active': '',
            'username': 'Newt',
            'email': 'newt@nostromo.org',
            'password': 'you_never_guess_this',
            'password2': 'you_never_guess_this',
            'group': 'admin',
            'name': 'Newt',
            'continue_': 'yes',
            'send_info': ''}
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                logged_in_user = User.get_by_username('Alice')
                logged_in_user.remove_newsletter()
                if not logged_in_user:
                    abort(404)  # pragma: no cover
            rv = self.app.get(url_for('user_insert'))
            assert b'+ User' in rv.data
            rv = self.app.post(url_for('user_insert'), data=data)
            user_id = rv.location.split('/')[-1]
            data['password'] = 'too short'
            rv = self.app.post(url_for('user_insert'), data=data)
            assert b'match' in rv.data

            # Test insert with continue
            rv = self.app.post(url_for('user_insert'), follow_redirects=True, data=data2)
            assert b'Newt' not in rv.data

            rv = self.app.get(url_for('user_view', id_=user_id))
            assert b'Ripley' in rv.data
            rv = self.app.get(url_for('user_update', id_=logged_in_user.id))
            assert b'Alice' in rv.data
            data['description'] = 'The warrant officer'
            rv = self.app.post(
                url_for('user_update', id_=user_id),
                data=data,
                follow_redirects=True)
            assert b'The warrant officer' in rv.data
            rv = self.app.get(url_for('admin_index', action='delete_user', id_=user_id))
            assert b'User deleted' in rv.data

            # Test activity log
            data = {'name': 'test', 'description': 'test'}  # insert a reference to show something
            self.app.post(url_for('insert', class_='bibliography'), data=data)
            rv = self.app.get(url_for('user_activity'))
            assert b'Activity' in rv.data
            rv = self.app.get(url_for('user_activity', user_id=user_id))
            assert b'Activity' in rv.data
            data = {'limit': 'all', 'action': 'all', 'user': 'all'}
            rv = self.app.post(url_for('user_activity', data=data))
            assert b'Activity' in rv.data

            # Test missing permission
            self.app.get(url_for('logout'), follow_redirects=True)
            rv = self.app.get(url_for('user_insert'), follow_redirects=True)
            assert b'Forgot your password?' not in rv.data
            self.app.post('/login', data={'username': 'Editor', 'password': 'test'})
            rv = self.app.get(url_for('user_insert'), follow_redirects=True)
            assert b'403 - Forbidden' in rv.data

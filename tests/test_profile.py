from flask import url_for

from openatlas import app
from tests.base import TestBaseCase


class ProfileTests(TestBaseCase):

    def test_profile(self) -> None:
        with app.app_context():  # type: ignore
            rv = self.app.get(url_for('profile_index'))
            assert b'alice@example.com' in rv.data
            rv = self.app.get(url_for('profile_settings', category='profile'))
            assert b'alice@example.com' in rv.data
            rv = self.app.post(
                url_for('profile_settings', category='profile'),
                data={'name': 'Alice Abernathy', 'email': 'alice@umbrella.net', 'show_email': ''},
                follow_redirects=True)
            assert b'saved' in rv.data and b'Alice Abernathy' in rv.data
            rv = self.app.post(
                url_for('profile_settings', category='display'),
                follow_redirects=True,
                data={
                    'language': 'en',
                    'table_rows': 10,
                    'map_zoom_default': 10,
                    'map_zoom_max': 10})
            assert b'saved' in rv.data and b'English' in rv.data

            # Change password
            rv = self.app.get(url_for('profile_password'))
            assert b'Old password' in rv.data
            new_pass = 'you_never_guess_this'
            data = {'password_old': 'test', 'password': new_pass, 'password2': new_pass}
            rv = self.app.post(url_for('profile_password'), data=data, follow_redirects=True)
            assert b'Your password has been updated' in rv.data
            data['password2'] = 'short'
            rv = self.app.post(url_for('profile_password'), data=data, follow_redirects=True)
            assert b'match' in rv.data
            data['password_old'] = new_pass
            rv = self.app.post(url_for('profile_password'), data=data, follow_redirects=True)
            assert b'New password is like old one' in rv.data
            data['password'] = 'short'
            rv = self.app.post(url_for('profile_password'), data=data, follow_redirects=True)
            assert b'too short' in rv.data

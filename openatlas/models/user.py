from __future__ import annotations  # Needed for Python 4.0 type annotations

import datetime
import secrets
import string
from typing import Any, Dict, List, Optional, Tuple

import bcrypt
from flask import session
from flask_babel import lazy_gettext as _
from flask_login import UserMixin, current_user
from flask_wtf import FlaskForm

from openatlas.database.user import User as Db
from openatlas.util.util import sanitize


class User(UserMixin):  # type: ignore

    def __init__(self, row: Dict[str, Any] = None, bookmarks: Optional[List[int]] = None) -> None:
        self.id = row['id']
        self.active = True if row['active'] == 1 else False
        self.username = row['username']
        self.password = row['password']
        self.login_last_success = row['login_last_success']
        self.login_last_failure = row['login_last_failure']
        self.login_failed_count = row['login_failed_count']
        self.real_name = row['real_name']
        self.email = row['email']
        self.description = row['info']
        self.settings = User.get_settings(row['id'])
        self.bookmarks = bookmarks
        self.password_reset_code = row['password_reset_code']
        self.password_reset_date = row['password_reset_date']
        self.unsubscribe_code = row['unsubscribe_code']
        self.group = row['group_name']
        self.created = row['created']
        self.modified = row['modified']

    def update(self) -> None:
        Db.update({
            'id': self.id,
            'username': self.username,
            'real_name': self.real_name,
            'password': self.password,
            'info': self.description,
            'email': self.email,
            'active': self.active,
            'group_name': self.group,
            'login_last_success': self.login_last_success,
            'login_last_failure': self.login_last_failure,
            'login_failed_count': self.login_failed_count,
            'unsubscribe_code': self.unsubscribe_code,
            'password_reset_code': self.password_reset_code,
            'password_reset_date': self.password_reset_date})

    def update_settings(self, form: Any) -> None:
        for field in form:
            if field.type in ['CSRFTokenField', 'HiddenField', 'SubmitField'] or \
                    field.name in ['name', 'email']:
                continue
            value = field.data
            if field.type == 'BooleanField':
                value = 'True' if value else ''
            Db.update_settings(self.id, field.name, value)

    def remove_newsletter(self) -> None:
        Db.remove_newsletter(self.id)

    def update_language(self) -> None:
        Db.update_language(self.id, current_user.settings['language'])

    def login_attempts_exceeded(self) -> bool:
        failed_login_tries = int(session['settings']['failed_login_tries'])
        if not self.login_last_failure or self.login_failed_count < failed_login_tries:
            return False
        last_failure_date = self.login_last_failure
        forget_minutes = int(session['settings']['failed_login_forget_minutes'])
        last_failure_date += datetime.timedelta(minutes=forget_minutes)
        if last_failure_date > datetime.datetime.now():
            return True
        return False  # pragma no cover - not waiting in tests for forget_minutes to pass

    def get_notes_by_entity_id(self, entity_id: int) -> List[Dict[str, Any]]:
        return Db.get_notes_by_entity_id(self.id, entity_id)

    @staticmethod
    def get_all() -> List[User]:
        return [User(row) for row in Db.get_all()]

    @staticmethod
    def get_by_id(user_id: int, with_bookmarks: bool = False) -> Optional[User]:
        user_data = Db.get_by_id(user_id)
        if user_data:
            return User(user_data, Db.get_bookmarks(user_id) if with_bookmarks else None)
        return None  # pragma no cover - something went wrong, e.g. obsolete session values

    @staticmethod
    def get_by_reset_code(code: str) -> Optional[User]:
        user_data = Db.get_by_reset_code(code)
        return User(user_data) if user_data else None

    @staticmethod
    def get_by_email(email: str) -> Optional[User]:
        user_data = Db.get_by_email(email)
        return User(user_data) if user_data else None

    @staticmethod
    def get_by_username(username: str) -> Optional[User]:
        user_data = Db.get_by_username(username)
        return User(user_data) if user_data else None

    @staticmethod
    def get_by_unsubscribe_code(code: str) -> Optional[User]:
        user_data = Db.get_by_unsubscribe_code(code)
        return User(user_data) if user_data else None

    @staticmethod
    def get_activities(limit: int, user_id: int, action: str) -> List[Dict[str, Any]]:
        return Db.get_activities(limit, user_id, action)

    @staticmethod
    def get_created_entities_count(user_id: int) -> int:
        return Db.get_created_entities_count(user_id)

    @staticmethod
    def insert(form: FlaskForm) -> int:
        return Db.insert({
            'username': form.username.data,
            'real_name': form.real_name.data,
            'info': form.description.data,
            'email': form.email.data,
            'active': form.active.data,
            'group_name': form.group.data,
            'password': bcrypt.hashpw(
                form.password.data.encode('utf-8'),
                bcrypt.gensalt()).decode('utf-8')})

    @staticmethod
    def delete(id_: int) -> None:
        Db.delete(id_)

    @staticmethod
    def get_users_for_form() -> List[Tuple[int, str]]:
        return Db.get_users_for_form()

    @staticmethod
    def toggle_bookmark(entity_id: int) -> str:
        if int(entity_id) in current_user.bookmarks:
            Db.delete_bookmark(current_user.id, entity_id)
            label = _('bookmark')
        else:
            Db.insert_bookmark(current_user.id, entity_id)
            label = _('bookmark remove')
        return label

    @staticmethod
    def get_settings(user_id: int) -> Dict[str, Any]:
        settings = {
            'layout': 'default',
            'language': session['language'],
            'newsletter': False,
            'table_show_aliases': True,
            'show_email': False}
        for setting in session['settings']:
            if setting in ['map_zoom_max', 'map_zoom_default', 'table_rows'] \
                    or setting.startswith('module_'):
                settings[setting] = session['settings'][setting]
        for row in Db.get_settings(user_id):
            settings[row['name']] = row['value']
            if row['name'] in ['table_rows']:
                settings[row['name']] = int(row['value'])
        return settings

    @staticmethod
    def generate_password(length: Optional[int] = None) -> str:  # pragma no cover - only for mail
        length = length if length else session['settings']['random_password_length']
        return ''.join(
            secrets.choice(string.ascii_uppercase + string.digits) for _ in range(length))

    @staticmethod
    def insert_note(entity_id: int, note: str, public: bool) -> None:
        Db.insert_note(current_user.id, entity_id, sanitize(note, 'text'), public)

    @staticmethod
    def update_note(id_: int, note: str, public: bool) -> None:
        Db.update_note(id_, sanitize(note, 'text'), public)

    @staticmethod
    def get_note_by_id(id_: int) -> Dict[str, Any]:
        return Db.get_note_by_id(id_)

    @staticmethod
    def get_notes_by_user_id(user_id: int) -> List[Dict[str, Any]]:
        return Db.get_notes_by_user_id(user_id)

    @staticmethod
    def delete_note(id_: int) -> None:
        Db.delete_note(id_)

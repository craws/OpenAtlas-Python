from typing import Any, Dict, List, Optional, Tuple, Union

from flask import g


class User:

    sql = """
        SELECT u.id, u.username, u.password, u.active, u.real_name, u.info, u.created, u.modified,
            u.login_last_success, u.login_last_failure, u.login_failed_count, u.password_reset_code,
            u.password_reset_date, u.email, r.name as group_name, u.unsubscribe_code
        FROM web."user" u
        LEFT JOIN web.group r ON u.group_id = r.id """

    @staticmethod
    def update(data: Dict[str, Any]) -> None:
        sql = """
            UPDATE web.user SET (username, password, real_name, info, email, active,
                login_last_success, login_last_failure, login_failed_count, group_id,
                password_reset_code, password_reset_date, unsubscribe_code) =
            (%(username)s, %(password)s, %(real_name)s, %(info)s, %(email)s, %(active)s,
                %(login_last_success)s, %(login_last_failure)s, %(login_failed_count)s,
                (SELECT id FROM web.group WHERE name LIKE %(group_name)s),
                %(password_reset_code)s, %(password_reset_date)s, %(unsubscribe_code)s)
            WHERE id = %(id)s;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def update_settings(user_id: int, name: str, value: Union[int, str]) -> None:
        sql = """
            INSERT INTO web.user_settings (user_id, "name", "value")
            VALUES (%(user_id)s, %(name)s, %(value)s)
            ON CONFLICT (user_id, name) DO UPDATE SET "value" = excluded.value;"""
        g.cursor.execute(sql, {'user_id': user_id, 'name': name, 'value': value})

    @staticmethod
    def remove_newsletter(user_id: int) -> None:
        sql = "DELETE FROM web.user_settings WHERE name = 'newsletter' AND user_id = %(user_id)s;"
        g.cursor.execute(sql, {'user_id': user_id})

    @staticmethod
    def update_language(user_id: int, value: str) -> None:
        sql = """
            INSERT INTO web.user_settings (user_id, "name", "value")
            VALUES (%(user_id)s, 'language', %(value)s)
            ON CONFLICT (user_id, name) DO UPDATE SET "value" = excluded.value;"""
        g.cursor.execute(sql, {'user_id': user_id, 'value': value})

    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        g.cursor.execute(User.sql + ' ORDER BY username;')
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_bookmarks(user_id: int) -> List[int]:
        sql = 'SELECT entity_id FROM web.user_bookmarks WHERE user_id = %(user_id)s;'
        g.cursor.execute(sql, {'user_id': user_id})
        return [row['entity_id'] for row in g.cursor.fetchall()]

    @staticmethod
    def get_by_id(user_id: int) -> Optional[Dict[str, Any]]:
        g.cursor.execute(User.sql + ' WHERE u.id = %(id)s;', {'id': user_id})
        return dict(g.cursor.fetchone()) if g.cursor.rowcount else None

    @staticmethod
    def get_by_reset_code(code: str) -> Optional[Dict[str, Any]]:
        g.cursor.execute(User.sql + ' WHERE u.password_reset_code = %(code)s;', {'code': code})
        return dict(g.cursor.fetchone()) if g.cursor.rowcount else None

    @staticmethod
    def get_by_email(email: str) -> Optional[Dict[str, Any]]:
        g.cursor.execute(User.sql + ' WHERE LOWER(u.email) = LOWER(%(email)s);', {'email': email})
        return dict(g.cursor.fetchone()) if g.cursor.rowcount else None

    @staticmethod
    def get_by_username(username: str) -> Optional[Dict[str, Any]]:
        sql = User.sql + ' WHERE LOWER(u.username) = LOWER(%(username)s);'
        g.cursor.execute(sql, {'username': username})
        return dict(g.cursor.fetchone()) if g.cursor.rowcount else None

    @staticmethod
    def get_by_unsubscribe_code(code: str) -> Optional[Dict[str, Any]]:
        g.cursor.execute(User.sql + ' WHERE u.unsubscribe_code = %(code)s;', {'code': code})
        return dict(g.cursor.fetchone()) if g.cursor.rowcount else None

    @staticmethod
    def get_activities(limit: int, user_id: int, action: str) -> List[Dict[str, Any]]:
        sql = """
            SELECT id, user_id, entity_id, created, action, 'ignore' AS ignore
            FROM web.user_log WHERE TRUE"""
        sql += ' AND user_id = %(user_id)s' if int(user_id) else ''
        sql += ' AND action = %(action)s' if action != 'all' else ''
        sql += ' ORDER BY created DESC'
        sql += ' LIMIT %(limit)s' if int(limit) else ''
        g.cursor.execute(sql, {'limit': limit, 'user_id': user_id, 'action': action})
        return g.cursor.fetchall()

    @staticmethod
    def get_created_entities_count(user_id: int) -> int:
        sql = "SELECT COUNT(*) FROM web.user_log WHERE user_id = %(user_id)s AND action = 'insert';"
        g.cursor.execute(sql, {'user_id': user_id})
        return g.cursor.fetchone()['count']

    @staticmethod
    def insert(data: Dict[str, Any]) -> int:
        sql = """
            INSERT INTO web.user (username, real_name, info, email, active, password, group_id)
            VALUES (%(username)s, %(real_name)s, %(info)s, %(email)s, %(active)s, %(password)s,
                (SELECT id FROM web.group WHERE name LIKE %(group_name)s))
            RETURNING id;"""
        g.cursor.execute(sql, data)
        return g.cursor.fetchone()['id']

    @staticmethod
    def delete(id_: int) -> None:
        g.cursor.execute('DELETE FROM web."user" WHERE id = %(user_id)s;', {'user_id': id_})

    @staticmethod
    def get_users_for_form() -> List[Tuple[int, str]]:
        g.cursor.execute('SELECT id, username FROM web.user ORDER BY username;')
        return [(row['id'], row['username']) for row in g.cursor.fetchall()]

    @staticmethod
    def insert_bookmark(user_id: int, entity_id: int) -> None:
        sql = """
            INSERT INTO web.user_bookmarks (user_id, entity_id)
            VALUES (%(user_id)s, %(entity_id)s);"""
        g.cursor.execute(sql, {'user_id': user_id, 'entity_id': entity_id})

    @staticmethod
    def delete_bookmark(user_id: int, entity_id: int) -> None:
        sql = """
            DELETE FROM web.user_bookmarks
            WHERE user_id = %(user_id)s AND entity_id = %(entity_id)s;"""
        g.cursor.execute(sql, {'user_id': user_id, 'entity_id': entity_id})

    @staticmethod
    def get_settings(user_id: int) -> List[Dict[str, Any]]:
        sql = 'SELECT "name", value FROM web.user_settings WHERE user_id = %(user_id)s;'
        g.cursor.execute(sql, {'user_id': user_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_notes_by_entity_id(user_id: int, entity_id: int) -> List[Dict[str, Any]]:
        sql = """
            SELECT id, created, public, text, user_id
            FROM web.user_notes
            WHERE entity_id = %(entity_id)s AND (public IS TRUE or user_id = %(user_id)s);"""
        g.cursor.execute(sql, {'entity_id': entity_id, 'user_id': user_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_notes_by_user_id(user_id: int) -> List[Dict[str, Any]]:
        sql = """
            SELECT id, created, public, text, user_id, entity_id
            FROM web.user_notes
            WHERE user_id = %(user_id)s;"""
        g.cursor.execute(sql, {'user_id': user_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_note_by_id(id_: int) -> Dict[str, Any]:
        sql = """
            SELECT id, created, public, text, user_id, entity_id
            FROM web.user_notes
            WHERE id = %(id)s;"""
        g.cursor.execute(sql, {'id': id_})
        return dict(g.cursor.fetchone())

    @staticmethod
    def insert_note(user_id: int, entity_id: int, note: str, public: bool) -> None:
        sql = """
            INSERT INTO web.user_notes (user_id, entity_id, text, public)
            VALUES (%(user_id)s, %(entity_id)s, %(text)s, %(public)s);"""
        g.cursor.execute(sql, {
            'user_id': user_id,
            'entity_id': entity_id,
            'text': note,
            'public': public})

    @staticmethod
    def update_note(id_: int, note: str, public: bool) -> None:
        sql = "UPDATE web.user_notes SET text = %(text)s, public = %(public)s WHERE id = %(id)s;"
        g.cursor.execute(sql, {'id': id_, 'text': note, 'public': public})

    @staticmethod
    def delete_note(id_: int) -> None:
        g.cursor.execute("DELETE FROM web.user_notes WHERE id = %(id)s;", {'id': id_})

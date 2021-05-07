from typing import Any, Dict, List

from flask import g


class Logger:

    @staticmethod
    def log(data: Dict[str, Any]) -> None:
        sql = """
            INSERT INTO web.system_log (priority, type, message, user_id, info)
            VALUES(%(priority)s, %(type)s, %(message)s, %(user_id)s, %(info)s)
            RETURNING id;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def get_system_logs(limit: str, priority: str, user_id: str) -> List[Dict[str, Any]]:
        sql = f"""
            SELECT id, priority, type, message, user_id, info, created FROM web.system_log
            WHERE priority <= %(priority)s
            {' AND user_id = %(user_id)s' if int(user_id) > 0 else ''}
            ORDER BY created DESC
            {' LIMIT %(limit)s' if int(limit) > 0 else ''};"""
        g.cursor.execute(sql, {'limit': limit, 'priority': priority, 'user_id': user_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def delete_all_system_logs() -> None:
        g.cursor.execute('TRUNCATE TABLE web.system_log RESTART IDENTITY;')

    @staticmethod
    def log_user(entity_id: int, user_id: int, action: str) -> None:
        sql = """
            INSERT INTO web.user_log (user_id, entity_id, action)
            VALUES (%(user_id)s, %(entity_id)s, %(action)s);"""
        g.cursor.execute(sql, {'user_id': user_id, 'entity_id': entity_id, 'action': action})

    @staticmethod
    def get_log_for_advanced_view(entity_id: str) -> Dict[str, Any]:
        sql = """
            SELECT ul.created, ul.user_id, ul.entity_id, u.username
            FROM web.user_log ul
            JOIN web.user u ON ul.user_id = u.id
            WHERE ul.entity_id = %(entity_id)s AND ul.action = %(action)s
            ORDER BY ul.created DESC LIMIT 1;"""
        g.cursor.execute(sql, {'entity_id': entity_id, 'action': 'insert'})
        row_insert = g.cursor.fetchone()
        g.cursor.execute(sql, {'entity_id': entity_id, 'action': 'update'})
        row_update = g.cursor.fetchone()
        sql = 'SELECT project_id, origin_id, user_id FROM import.entity WHERE entity_id = %(id)s;'
        g.cursor.execute(sql, {'id': entity_id})
        row_import = g.cursor.fetchone()
        return {
            'creator_id': row_insert['user_id'] if row_insert else None,
            'created': row_insert['created'] if row_insert else None,
            'modifier_id': row_update['user_id'] if row_update else None,
            'modified': row_update['created'] if row_update else None,
            'project_id': row_import['project_id'] if row_import else None,
            'importer_id': row_import['user_id'] if row_import else None,
            'origin_id': row_import['origin_id'] if row_import else None}

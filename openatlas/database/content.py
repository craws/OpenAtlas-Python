from typing import Dict, List

from flask import g


class Content:

    @staticmethod
    def get_content() -> List[Dict[str, str]]:
        g.cursor.execute("SELECT name, language, text FROM web.i18n;")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def update(name: str, language: str, text: str) -> None:
        sql = 'DELETE FROM web.i18n WHERE name = %(name)s AND language = %(language)s'
        g.cursor.execute(sql, {'name': name, 'language': language})
        sql = """
            INSERT INTO web.i18n (name, language, text)
            VALUES (%(name)s, %(language)s, %(text)s);"""
        g.cursor.execute(sql, {'name': name, 'language': language, 'text': text})

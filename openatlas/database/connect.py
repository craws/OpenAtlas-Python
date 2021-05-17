from typing import Any, Dict

from flask import g
from psycopg2 import connect, extras


def open_connection(config: Dict[str, Any]) -> None:
    try:
        g.db = connect(
            database=config['DATABASE_NAME'],
            user=config['DATABASE_USER'],
            password=config['DATABASE_PASS'],
            port=config['DATABASE_PORT'],
            host=config['DATABASE_HOST'])
        g.db.autocommit = True
    except Exception as e:  # pragma: no cover
        print("Database connection failed")
        raise Exception(e)
    g.cursor = g.db.cursor(cursor_factory=extras.DictCursor)


def close_connection() -> None:
    if hasattr(g, 'db'):
        g.db.close()


class Transaction:

    @staticmethod
    def begin() -> None:
        g.cursor.execute('BEGIN')

    @staticmethod
    def commit() -> None:
        g.cursor.execute('COMMIT')

    @staticmethod
    def rollback() -> None:
        g.cursor.execute('ROLLBACK')

from typing import Any, Dict, List

from flask import g


class Date:

    @staticmethod
    def get_invalid_dates() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT id FROM model.entity WHERE
                begin_from > begin_to OR end_from > end_to
                OR (begin_from IS NOT NULL AND end_from IS NOT NULL AND begin_from > end_from)
                OR (begin_to IS NOT NULL AND end_to IS NOT NULL AND begin_to > end_to);""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_invalid_link_dates() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT id FROM model.link WHERE
                begin_from > begin_to OR end_from > end_to
                OR (begin_from IS NOT NULL AND end_from IS NOT NULL AND begin_from > end_from)
                OR (begin_to IS NOT NULL AND end_to IS NOT NULL AND begin_to > end_to);""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def invalid_involvement_dates() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT l.id FROM model.entity actor
            JOIN model.link l ON actor.id = l.range_id
                AND l.property_code IN ('P11', 'P14', 'P22', 'P23')
            JOIN model.entity event ON l.domain_id = event.id
            WHERE
                (actor.begin_from IS NOT NULL AND l.end_from IS NOT NULL
                    AND actor.begin_from > l.end_from)
                OR (actor.begin_to IS NOT NULL AND l.end_to IS NOT NULL
                    AND actor.begin_to > l.end_to)
                OR (actor.begin_from IS NOT NULL AND event.end_from IS NOT NULL
                    AND actor.begin_from > event.end_from)
                OR (actor.begin_to IS NOT NULL AND event.end_to IS NOT NULL
                    AND actor.begin_to > event.end_to)
                OR (l.begin_from IS NOT NULL AND l.end_from IS NOT NULL
                    AND l.begin_from > l.end_from)
                OR (l.begin_to IS NOT NULL AND l.end_to IS NOT NULL
                    AND l.begin_to > l.end_to)
                OR (l.begin_from IS NOT NULL AND event.end_from IS NOT NULL
                    AND l.begin_from > event.end_from)
                OR (l.begin_to IS NOT NULL AND event.end_to IS NOT NULL
                    AND l.begin_to > event.end_to)
                OR (l.end_from IS NOT NULL AND event.end_to IS NOT NULL
                    AND l.end_from > event.end_to);""")
        return [dict(row) for row in g.cursor.fetchall()]

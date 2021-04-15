from typing import Any, Dict, List

from flask import g


class Overlay:

    @staticmethod
    def insert(data: Dict[str, Any]) -> None:
        sql = """
            INSERT INTO web.map_overlay (image_id, place_id, link_id, bounding_box)
            VALUES (%(image_id)s, %(place_id)s, %(link_id)s, %(bounding_box)s);"""
        g.cursor.execute(sql, data)

    @staticmethod
    def update(data: Dict[str, Any]) -> None:
        sql = """
            UPDATE web.map_overlay SET bounding_box = %(bounding_box)s
            WHERE image_id = %(image_id)s AND place_id = %(place_id)s;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def get_by_object(ids: List[int]) -> List[Dict[str, Any]]:
        sql = """
            SELECT o.id, o.place_id, o.image_id, o.bounding_box, i.name
            FROM web.map_overlay o
            JOIN model.entity i ON o.image_id = i.id
            WHERE o.place_id IN %(place_ids)s;"""
        g.cursor.execute(sql, {'place_ids': tuple(ids)})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_by_id(id_: int) -> Dict[str, Any]:
        sql = 'SELECT id, place_id, image_id, bounding_box FROM web.map_overlay WHERE id = %(id)s;'
        g.cursor.execute(sql, {'id': id_})
        return dict(g.cursor.fetchone())

    @staticmethod
    def remove(id_: int) -> None:
        g.cursor.execute('DELETE FROM web.map_overlay WHERE id = %(id)s;', {'id': id_})

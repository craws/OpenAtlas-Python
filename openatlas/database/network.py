from typing import Dict, List, Union

from flask import g


class Network:

    @staticmethod
    def get_edges(classes: List[str], properties: List[str]) -> List[Dict[str, int]]:
        sql = """
            SELECT l.id, l.domain_id, l.range_id FROM model.link l
            JOIN model.entity e ON l.domain_id = e.id AND e.system_class IN %(classes)s
            JOIN model.entity e2 ON l.range_id = e2.id AND e2.system_class IN %(classes)s
            WHERE property_code IN %(properties)s """
        g.cursor.execute(sql, {'classes': tuple(classes), 'properties': tuple(properties)})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_entities(classes: List[str]) -> List[Dict[str, Union[int, str]]]:
        sql = """
            SELECT e.id, e.name, e.system_class
            FROM model.entity e
            WHERE system_class IN %(classes)s """
        g.cursor.execute(sql, {'classes': tuple(classes)})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_object_mapping() -> Dict[int, int]:
        g.cursor.execute("""
            SELECT e.id, l.range_id
            FROM model.entity e
            JOIN model.link l ON e.id = domain_id AND l.property_code = 'P53';""")
        return {row['range_id']: row['id'] for row in g.cursor.fetchall()}

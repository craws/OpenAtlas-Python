from typing import Any, Dict, List, Union

from flask import g


class Node:

    @staticmethod
    def get_nodes(system_class: str, property_: str) -> List[Dict[str, Any]]:
        sql = """
            SELECT e.id, e.name, e.class_code, e.description, e.system_class, e.created, e.modified,
                es.id AS super_id, COUNT(l2.id) AS count, COUNT(l3.id) AS count_property,
                COALESCE(to_char(e.begin_from, 'yyyy-mm-dd BC'), '') AS begin_from, e.begin_comment,
                COALESCE(to_char(e.begin_to, 'yyyy-mm-dd BC'), '') AS begin_to,
                COALESCE(to_char(e.end_from, 'yyyy-mm-dd BC'), '') AS end_from, e.end_comment,
                COALESCE(to_char(e.end_to, 'yyyy-mm-dd BC'), '') AS end_to
            FROM model.entity e

            -- Get super
            LEFT JOIN model.link l ON e.id = l.domain_id AND l.property_code = %(property_code)s
            LEFT JOIN model.entity es ON l.range_id = es.id

            -- Get count
            LEFT JOIN model.link l2 ON e.id = l2.range_id AND l2.property_code IN ('P2', 'P89')
            LEFT JOIN model.link l3 ON e.id = l3.type_id

            WHERE e.system_class = %(system_class)s
            GROUP BY e.id, es.id
            ORDER BY e.name;"""
        g.cursor.execute(sql, {'system_class': system_class, 'property_code': property_})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_web_forms() -> List[Dict[str, Any]]:
        g.cursor.execute("SELECT id, name, extendable FROM web.form ORDER BY name ASC;")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_hierarchies() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT h.id, h.name, h.multiple, h.standard, h.directional, h.value_type, h.locked,
                (SELECT ARRAY(
                    SELECT f.id FROM web.form f JOIN web.hierarchy_form hf ON f.id = hf.form_id
                    AND hf.hierarchy_id = h.id)) AS form_ids
            FROM web.hierarchy h;""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_nodes_for_form(form_name: str) -> List[int]:
        sql = """
            SELECT h.id FROM web.hierarchy h
            JOIN web.hierarchy_form hf ON h.id = hf.hierarchy_id
            JOIN web.form f ON hf.form_id = f.id AND f.name = %(form_name)s
            ORDER BY h.name;"""
        g.cursor.execute(sql, {'form_name': form_name})
        return [row['id'] for row in g.cursor.fetchall()]

    @staticmethod
    def get_form_choices() -> List[Dict[str, Union[int, str]]]:
        g.cursor.execute(
            "SELECT f.id, f.name FROM web.form f WHERE f.extendable = True ORDER BY name ASC")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def insert_hierarchy(data: Dict[str, Any]) -> None:
        sql = """
            INSERT INTO web.hierarchy (id, name, multiple, value_type)
            VALUES (%(id)s, %(name)s, %(multiple)s, %(value_type)s);"""
        g.cursor.execute(sql, data)

    @staticmethod
    def update_hierarchy(data: Dict[str, Any]) -> None:
        sql = "UPDATE web.hierarchy SET name = %(name)s, multiple = %(multiple)s WHERE id = %(id)s;"
        g.cursor.execute(sql, data)

    @staticmethod
    def add_form_to_hierarchy(node_id: int, form_ids: List[int]) -> None:
        for form_id in form_ids:
            sql = """
                INSERT INTO web.hierarchy_form (hierarchy_id, form_id)
                VALUES (%(node_id)s, %(form_id)s);"""
            g.cursor.execute(sql, {'node_id': node_id, 'form_id': form_id})

    @staticmethod
    def move_link_type(data: Dict[str, int]) -> None:
        sql = """
            UPDATE model.link SET type_id = %(new_type_id)s
            WHERE type_id = %(old_type_id)s AND id IN %(entity_ids)s;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def move_entity_type(data: Dict[str, int]) -> None:
        sql = """
            UPDATE model.link SET range_id = %(new_type_id)s
            WHERE range_id = %(old_type_id)s AND domain_id IN %(entity_ids)s;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def remove_link_type(type_id: int, delete_ids: List[int]) -> None:
        sql = """
            UPDATE model.link SET type_id = NULL
            WHERE type_id = %(type_id)s AND id IN %(delete_ids)s;"""
        g.cursor.execute(sql, {'type_id': type_id, 'delete_ids': tuple(delete_ids)})

    @staticmethod
    def remove_entity_type(type_id: int, delete_ids: List[int]) -> None:
        sql = """
            DELETE FROM model.link
            WHERE range_id = %(type_id)s AND domain_id IN %(delete_ids)s;"""
        g.cursor.execute(sql, {'type_id': type_id, 'delete_ids': tuple(delete_ids)})

    @staticmethod
    def get_form_count(form_id: int, node_ids: List[int]) -> int:
        g.cursor.execute("SELECT name FROM web.form WHERE id = %(form_id)s;", {'form_id': form_id})
        form_name = g.cursor.fetchone()['name']
        sql = """
            SELECT COUNT(*) FROM model.link l
            JOIN model.entity e ON l.domain_id = e.id AND l.range_id IN %(node_ids)s
            WHERE l.property_code = 'P2' AND e.system_class = %(form_name)s;"""
        g.cursor.execute(sql, {'node_ids': tuple(node_ids), 'form_name': form_name})
        return g.cursor.fetchone()['count']

    @staticmethod
    def remove_form_from_hierarchy(form_id: int, hierarchy_id: int) -> None:
        sql = """
            DELETE FROM web.hierarchy_form
            WHERE hierarchy_id = %(hierarchy_id)s AND form_id = %(form_id)s;"""
        g.cursor.execute(sql, {'hierarchy_id': hierarchy_id, 'form_id': form_id})

    @staticmethod
    def remove_by_entity_and_node(entity_id: int, node_id: int) -> None:
        sql = """
            DELETE FROM model.link
            WHERE domain_id = %(entity_id)s AND range_id = %(node_id)s AND property_code = 'P2';"""
        g.cursor.execute(sql, {'entity_id': entity_id, 'node_id': node_id})

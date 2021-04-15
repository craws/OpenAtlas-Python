from typing import Any, Dict, List, Union

from flask import g


class ReferenceSystem:

    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT
                e.id, e.name, e.class_code, e.description, e.system_class, e.created, e.modified,
                rs.website_url, rs.resolver_url, rs.identifier_example, rs.system,
                rs.precision_default_id, COUNT(l.id) AS count,
                (SELECT ARRAY(
                    SELECT f.id FROM web.form f
                    JOIN web.reference_system_form rfs ON f.id = rfs.form_id
                        AND rfs.reference_system_id = rs.entity_id)) AS form_ids,
                array_to_json(
                    array_agg((t.range_id, t.description)) FILTER (WHERE t.range_id IS NOT NULL)
                ) AS nodes
            FROM model.entity e
            JOIN web.reference_system rs ON e.id = rs.entity_id
            LEFT JOIN model.link l ON e.id = l.domain_id AND l.property_code = 'P67'
            LEFT JOIN model.link t ON e.id = t.domain_id AND t.property_code = 'P2'
            GROUP BY
                e.id, e.name, e.class_code, e.description, e.system_class, e.created,
                e.modified, rs.website_url, rs.resolver_url, rs.identifier_example, rs.system,
                rs.precision_default_id, rs.entity_id;""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def add_forms(entity_id: int, form_ids: List[int]) -> None:
        for form_id in form_ids:
            sql = """
                INSERT INTO web.reference_system_form (reference_system_id, form_id)
                VALUES (%(entity_id)s, %(form_id)s);"""
            g.cursor.execute(sql, {'entity_id': entity_id, 'form_id': form_id})

    @staticmethod
    def remove_form(entity_id: int, form_id: int) -> None:
        sql = """
            DELETE FROM web.reference_system_form
            WHERE reference_system_id = %(reference_system_id)s AND form_id = %(form_id)s;"""
        g.cursor.execute(sql, {'reference_system_id': entity_id, 'form_id': form_id})

    @staticmethod
    def get_forms(form_id: int) -> List[Dict[str, Union[int, str]]]:
        sql = """
            SELECT f.id, f.name FROM web.form f
            JOIN web.reference_system_form rsf ON f.id = rsf.form_id
                AND rsf.reference_system_id = %(id)s;"""
        g.cursor.execute(sql, {'id': form_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def update_system(data: Dict[str, Any]) -> None:
        sql = '''
            UPDATE web.reference_system SET (name, website_url, resolver_url, identifier_example,
                precision_default_id)
            = (%(name)s, %(website_url)s, %(resolver_url)s, %(identifier_example)s,
                %(precision_default_id)s)
            WHERE entity_id = %(entity_id)s;'''
        g.cursor.execute(sql, data)

    @staticmethod
    def remove_link(system_id: int, entity_id: int) -> None:
        sql = """
            DELETE FROM model.link WHERE property_code = 'P67'
            AND domain_id = %(system_id)s AND range_id = %(entity_id)s;"""
        g.cursor.execute(sql, {'system_id': system_id, 'entity_id': entity_id})

    @staticmethod
    def get_form_choices(form_names: List[str]) -> List[Dict[str, Union[str, int]]]:
        sql = "SELECT f.id, f.name FROM web.form f WHERE f.name IN %(forms)s ORDER BY name ASC;"
        g.cursor.execute(sql, {'forms': tuple(form_names)})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def insert_system(data: Dict[str, Any]) -> None:
        sql = '''
            INSERT INTO web.reference_system (entity_id, name, website_url, resolver_url)
            VALUES (%(entity_id)s, %(name)s, %(website_url)s, %(resolver_url)s);'''
        g.cursor.execute(sql, data)

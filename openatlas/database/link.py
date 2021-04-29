from typing import Any, Dict, List, Union

from flask import g


class Link:

    @staticmethod
    def update(data: Dict[str, Any]) -> None:
        sql = """
            UPDATE model.link SET (property_code, domain_id, range_id, description, type_id,
                begin_from, begin_to, begin_comment, end_from, end_to, end_comment) =
                (%(property_code)s, %(domain_id)s, %(range_id)s, %(description)s, %(type_id)s,
                 %(begin_from)s, %(begin_to)s, %(begin_comment)s, %(end_from)s, %(end_to)s,
                 %(end_comment)s)
            WHERE id = %(id)s;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def insert(data: Dict[str, Any]) -> int:
        sql = """
            INSERT INTO model.link (property_code, domain_id, range_id, description, type_id)
            VALUES (%(property_code)s, %(domain_id)s, %(range_id)s, %(description)s, %(type_id)s)
            RETURNING id;"""
        g.cursor.execute(sql, data)
        return g.cursor.fetchone()['id']

    @staticmethod
    def get_linked_entities(id_: int, codes: List[str], inverse: bool) -> List[int]:
        sql = """
            SELECT range_id AS result_id FROM model.link
            WHERE domain_id = %(id_)s AND property_code IN %(codes)s;"""
        if inverse:
            sql = """
                SELECT domain_id AS result_id FROM model.link
                WHERE range_id = %(id_)s AND property_code IN %(codes)s;"""
        g.cursor.execute(sql, {'id_': id_, 'codes': tuple(codes)})
        return [row['result_id'] for row in g.cursor.fetchall()]

    @staticmethod
    def get_links(
            entity_id: int,
            codes: Union[str, List[str], None],
            inverse: bool = False) -> List[Dict[str, Any]]:
        sql = f"""
            SELECT l.id, l.property_code, l.domain_id, l.range_id, l.description, l.created,
                l.modified, e.name, l.type_id,
                COALESCE(to_char(l.begin_from, 'yyyy-mm-dd BC'), '') AS begin_from, l.begin_comment,
                COALESCE(to_char(l.begin_to, 'yyyy-mm-dd BC'), '') AS begin_to,
                COALESCE(to_char(l.end_from, 'yyyy-mm-dd BC'), '') AS end_from, l.end_comment,
                COALESCE(to_char(l.end_to, 'yyyy-mm-dd BC'), '') AS end_to
            FROM model.link l
            JOIN model.entity e ON l.{'domain' if inverse else 'range'}_id = e.id """
        if codes:
            codes = codes if isinstance(codes, list) else [codes]
            sql += ' AND l.property_code IN %(codes)s '
        sql += f"""
            WHERE l.{'range' if inverse else 'domain'}_id = %(entity_id)s
            GROUP BY l.id, e.name
            ORDER BY e.name;"""
        g.cursor.execute(sql, {'entity_id': entity_id, 'codes': tuple(codes) if codes else ''})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def delete_by_codes(entity_id: int, codes: List[str], inverse: bool = False) -> None:
        sql = f"""
            DELETE FROM model.link
            WHERE property_code IN %(codes)s
                AND {'range_id' if inverse else 'domain_id'} = %(id)s;"""
        g.cursor.execute(sql, {'id': entity_id, 'codes': tuple(codes)})

    @staticmethod
    def get_by_id(id_: int) -> Dict[str, Any]:
        sql = """
            SELECT l.id, l.property_code, l.domain_id, l.range_id, l.description, l.created,
                l.modified, l.type_id,
                COALESCE(to_char(l.begin_from, 'yyyy-mm-dd BC'), '') AS begin_from, l.begin_comment,
                COALESCE(to_char(l.begin_to, 'yyyy-mm-dd BC'), '') AS begin_to,
                COALESCE(to_char(l.end_from, 'yyyy-mm-dd BC'), '') AS end_from, l.end_comment,
                COALESCE(to_char(l.end_to, 'yyyy-mm-dd BC'), '') AS end_to
            FROM model.link l
            WHERE l.id = %(id)s;"""
        g.cursor.execute(sql, {'id': id_})
        return dict(g.cursor.fetchone())

    @staticmethod
    def get_entities_by_node(node_id: int) -> List[Dict[str, Any]]:
        sql = "SELECT id, domain_id, range_id from model.link WHERE type_id = %(node_id)s;"
        g.cursor.execute(sql, {'node_id': node_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def delete_(id_: int) -> None:
        g.cursor.execute("DELETE FROM model.link WHERE id = %(id)s;", {'id': id_})

    @staticmethod
    def get_cidoc_links() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT DISTINCT l.property_code, d.class_code AS domain_code, r.class_code AS range_code
            FROM model.link l
            JOIN model.entity d ON l.domain_id = d.id
            JOIN model.entity r ON l.range_id = r.id;""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_invalid_links(data: Dict[str, Any]) -> List[Dict[str, int]]:
        sql = """
            SELECT l.id, l.property_code, l.domain_id, l.range_id, l.description, 
                l.created, l.modified
            FROM model.link l
            JOIN model.entity d ON l.domain_id = d.id
            JOIN model.entity r ON l.range_id = r.id
            WHERE l.property_code = %(property_code)s
                AND d.class_code = %(domain_code)s
                AND r.class_code = %(range_code)s;"""
        g.cursor.execute(sql, data)
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def check_link_duplicates() -> List[Dict[str, int]]:
        g.cursor.execute("""
            SELECT COUNT(*) AS count, domain_id, range_id, property_code, description, type_id,
                begin_from, begin_to, begin_comment, end_from, end_to, end_comment
            FROM model.link GROUP BY
                domain_id, range_id, property_code, description, type_id,
                begin_from, begin_to, begin_comment, end_from, end_to, end_comment
            HAVING COUNT(*) > 1""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def delete_link_duplicates() -> int:
        g.cursor.execute("""
            DELETE FROM model.link l WHERE l.id NOT IN (
                SELECT id FROM (
                    SELECT DISTINCT ON (domain_id, range_id, property_code, description, type_id,
                        begin_from, begin_to, begin_comment, end_from, end_to, end_comment) *
                    FROM model.link) AS temp_table);""")
        return g.cursor.rowcount

    @staticmethod
    def check_single_type_duplicates(ids: List[int]) -> List[int]:
        sql = """
            SELECT domain_id FROM model.link
            WHERE property_code = 'P2' AND range_id IN %(ids)s
            GROUP BY domain_id HAVING COUNT(*) > 1;"""
        g.cursor.execute(sql, {'ids': tuple(ids)})
        return [row['domain_id'] for row in g.cursor.fetchall()]

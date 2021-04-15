from typing import Any, Dict, Iterable, List, Optional, Union

from flask import g


class Entity:

    @staticmethod
    def get_by_id(id_: int, nodes: bool = False, aliases: bool = False) -> Optional[Dict[str, Any]]:
        sql = Entity.build_sql(nodes, aliases) + ' WHERE e.id = %(id)s GROUP BY e.id;'
        g.cursor.execute(sql, {'id': id_})
        return dict(g.cursor.fetchone()) if g.cursor.rowcount else None

    @staticmethod
    def get_by_ids(
            ids: Iterable[int],
            nodes: bool = False,
            aliases: bool = False) -> List[Dict[str, Any]]:
        if not ids:
            return []
        sql = Entity.build_sql(
            nodes,
            aliases) + ' WHERE e.id IN %(ids)s GROUP BY e.id ORDER BY e.name'
        g.cursor.execute(sql, {'ids': tuple(ids)})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_by_project_id(project_id: int) -> List[Dict[str, Any]]:
        sql = """
            SELECT e.id, ie.origin_id, e.class_code, e.name, e.description, e.created, e.modified,
                e.system_class,
            array_to_json(
                array_agg((t.range_id, t.description)) FILTER (WHERE t.range_id IS NOT NULL)
            ) as nodes
            FROM model.entity e
            LEFT JOIN model.link t ON e.id = t.domain_id AND t.property_code IN ('P2', 'P89')
            JOIN import.entity ie ON e.id = ie.entity_id
            WHERE ie.project_id = %(id)s GROUP BY e.id, ie.origin_id;"""
        g.cursor.execute(sql, {'id': project_id})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_by_class(
            classes: Union[str, List[str]],
            nodes: bool = False,
            aliases: bool = False) -> List[Dict[str, Any]]:
        sql = Entity.build_sql(nodes, aliases) + ' WHERE e.system_class IN %(class)s GROUP BY e.id;'
        g.cursor.execute(sql, {'class': tuple(classes if isinstance(classes, list) else [classes])})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_by_cidoc_class(code: Union[str, List[str]]) -> List[Dict[str, Any]]:
        sql = Entity.build_sql() + 'WHERE class_code IN %(codes)s;'
        g.cursor.execute(sql, {'codes': tuple(code if isinstance(code, list) else [code])})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_overview_counts(classes: List[str]) -> Dict[str, int]:
        sql = """
            SELECT system_class, COUNT(system_class)
            FROM model.entity
            WHERE system_class IN %(classes)s
            GROUP BY system_class;"""
        g.cursor.execute(sql, {'classes': tuple(classes)})
        return {row['system_class']: row['count'] for row in g.cursor.fetchall()}

    @staticmethod
    def get_orphans() -> List[Dict[str, Any]]:
        g.cursor.execute("""
            SELECT e.id FROM model.entity e
            LEFT JOIN model.link l1 on e.id = l1.domain_id AND l1.range_id NOT IN
                (SELECT id FROM model.entity WHERE class_code = 'E55')
            LEFT JOIN model.link l2 on e.id = l2.range_id
            WHERE l1.domain_id IS NULL AND l2.range_id IS NULL AND e.class_code != 'E55'""")
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_latest(classes: List[str], limit: int) -> List[Dict[str, Any]]:
        sql = Entity.build_sql() + """
            WHERE e.system_class IN %(codes)s GROUP BY e.id
            ORDER BY e.created DESC LIMIT %(limit)s;"""
        g.cursor.execute(sql, {'codes': tuple(classes), 'limit': limit})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def get_circular() -> List[Dict[str, Any]]:
        g.cursor.execute('SELECT domain_id FROM model.link WHERE domain_id = range_id;')
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def insert(data: Dict[str, Any]) -> int:
        sql = """
            INSERT INTO model.entity (name, system_class, class_code, description)
            VALUES (%(name)s, %(system_class)s, %(code)s, %(description)s) RETURNING id;"""
        g.cursor.execute(sql, data)
        return g.cursor.fetchone()['id']

    @staticmethod
    def update(data: Dict[str, Any]) -> None:
        sql = """
            UPDATE model.entity SET (name, description, begin_from, begin_to, begin_comment, 
                end_from, end_to, end_comment)
            = (%(name)s, %(description)s, %(begin_from)s, %(begin_to)s, %(begin_comment)s,
                %(end_from)s, %(end_to)s, %(end_comment)s)
            WHERE id = %(id)s;"""
        g.cursor.execute(sql, data)

    @staticmethod
    def get_profile_image_id(id_: int) -> Optional[int]:
        sql = 'SELECT i.image_id FROM web.entity_profile_image i WHERE i.entity_id = %(id_)s;'
        g.cursor.execute(sql, {'id_': id_})
        return g.cursor.fetchone()['image_id'] if g.cursor.rowcount else None

    @staticmethod
    def set_profile_image(id_: int, origin_id: int) -> None:
        sql = """
            INSERT INTO web.entity_profile_image (entity_id, image_id)
            VALUES (%(entity_id)s, %(image_id)s)
            ON CONFLICT (entity_id) DO UPDATE SET image_id=%(image_id)s;"""
        g.cursor.execute(sql, {'entity_id': origin_id, 'image_id': id_})

    @staticmethod
    def remove_profile_image(id_: int) -> None:
        sql = 'DELETE FROM web.entity_profile_image WHERE entity_id = %(id)s;'
        g.cursor.execute(sql, {'id': id_})

    @staticmethod
    def delete(ids: List[int]) -> None:
        # Triggers psql function model.delete_entity_related() for deleting related entities."""
        g.cursor.execute('DELETE FROM model.entity WHERE id IN %(ids)s;', {'ids': tuple(ids)})

    @staticmethod
    def build_sql(nodes: bool = False, aliases: bool = False) -> str:
        sql = """
            SELECT
                e.id, e.class_code, e.name, e.description, e.created, e.modified, e.system_class,
                COALESCE(to_char(e.begin_from, 'yyyy-mm-dd BC'), '') AS begin_from, e.begin_comment,
                COALESCE(to_char(e.begin_to, 'yyyy-mm-dd BC'), '') AS begin_to,
                COALESCE(to_char(e.end_from, 'yyyy-mm-dd BC'), '') AS end_from, e.end_comment,
                COALESCE(to_char(e.end_to, 'yyyy-mm-dd BC'), '') AS end_to"""
        if nodes:
            sql += """
                ,array_to_json(
                    array_agg((t.range_id, t.description)) FILTER (WHERE t.range_id IS NOT NULL)
                ) AS nodes """
        if aliases:
            sql += """
                ,array_to_json(
                    array_agg((alias.id, alias.name)) FILTER (WHERE alias.name IS NOT NULL)
                ) AS aliases """
        sql += " FROM model.entity e "
        if nodes:
            sql += """ LEFT JOIN model.link t
                ON e.id = t.domain_id AND t.property_code IN ('P2', 'P89') """
        if aliases:
            sql += """
                LEFT JOIN model.link la
                    ON e.id = la.domain_id AND la.property_code IN ('P1', 'P131')
                LEFT JOIN model.entity alias ON la.range_id = alias.id """
        return sql

    @staticmethod
    def search(
            term: str,
            classes: List[str],
            desc: bool = False,
            own: bool = False,
            user_id: Optional[int] = None) -> List[Dict[str, Any]]:
        sql = Entity.build_sql() + """
            {user_clause}
            WHERE (UNACCENT(LOWER(e.name)) LIKE UNACCENT(LOWER(%(term)s))
            {description_clause})
            {user_clause2}
            AND e.system_class IN %(classes)s GROUP BY e.id ORDER BY e.name;""".format(
            user_clause="""
                LEFT JOIN web.user_log ul ON e.id = ul.entity_id """ if own else '',
            description_clause="""
                OR UNACCENT(lower(e.description)) LIKE UNACCENT(lower(%(term)s))
                OR UNACCENT(lower(e.begin_comment)) LIKE UNACCENT(lower(%(term)s))
                OR UNACCENT(lower(e.end_comment)) LIKE UNACCENT(lower(%(term)s))"""
            if desc else '',
            user_clause2=' AND ul.user_id = %(user_id)s ' if own else '')
        g.cursor.execute(sql, {
            'term': '%' + term + '%',
            'user_id': user_id,
            'classes': tuple(classes)})
        return [dict(row) for row in g.cursor.fetchall()]

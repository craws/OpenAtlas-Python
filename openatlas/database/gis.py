import ast
from typing import Any, Dict, List

from flask import g


class Gis:

    @staticmethod
    def add_example_geom(id_: int) -> None:
        sql = """INSERT INTO gis.point (entity_id, name, description, type, geom) VALUES (
        (%(location_id)s),
        '',
        '',
        'centerpoint',
        public.ST_SetSRID(public.ST_GeomFromGeoJSON('{"type":"Point","coordinates":[9,17]}'),4326));
        """
        g.cursor.execute(sql, {'location_id': id_})

    @staticmethod
    def get_by_id(id_: int) -> List[Dict[str, Any]]:
        geometries = []
        for shape in ['point', 'polygon', 'linestring']:
            sql = f"""
                SELECT
                    {shape}.id,
                    {shape}.name,
                    {shape}.description,
                    {shape}.type,
                    public.ST_AsGeoJSON({shape}.geom) AS geojson
                FROM model.entity place
                JOIN gis.{shape} {shape} ON place.id = {shape}.entity_id
                WHERE place.id = %(id_)s;"""
            g.cursor.execute(sql, {'id_': id_})
            for row in g.cursor.fetchall():
                geometry = ast.literal_eval(row['geojson'])
                geometry['title'] = row['name'].replace('"', '\"') if row['name'] else ''
                geometry['description'] = \
                    row['description'].replace('"', '\"') if row['description'] else ''
                geometries.append(geometry)
        return geometries

    @staticmethod
    def get_by_shape(shape: str, extra_ids: List[int]) -> List[Dict[str, Any]]:
        polygon_sql = '' if shape != 'polygon' else \
            'public.ST_AsGeoJSON(public.ST_PointOnSurface(polygon.geom)) AS polygon_point, '
        sql = f"""
            SELECT
                object.id AS object_id,
                {shape}.id,
                {shape}.name,
                {shape}.description,
                {shape}.type,
                public.ST_AsGeoJSON({shape}.geom) AS geojson, {polygon_sql}
                object.name AS object_name,
                object.description AS object_desc,
                string_agg(CAST(t.range_id AS text), ',') AS types
            FROM model.entity place
            JOIN model.link l ON place.id = l.range_id
            JOIN model.entity object ON l.domain_id = object.id
            JOIN gis.{shape} {shape} ON place.id = {shape}.entity_id
            LEFT JOIN model.link t ON object.id = t.domain_id AND t.property_code = 'P2'
            WHERE place.class_code = 'E53'
                AND l.property_code = 'P53'
                AND (object.system_class = 'place' OR object.id IN %(extra_ids)s)
            GROUP BY object.id, {shape}.id;"""
        g.cursor.execute(sql, {'extra_ids': tuple(extra_ids)})
        return [dict(row) for row in g.cursor.fetchall()]

    @staticmethod
    def test_geom(geometry: str) -> None:
        from openatlas.models.gis import InvalidGeomException
        sql = "SELECT st_isvalid(public.ST_SetSRID(public.ST_GeomFromGeoJSON(%(geojson)s),4326));"
        g.cursor.execute(sql, {'geojson': geometry})
        if not g.cursor.fetchone()['st_isvalid']:
            raise InvalidGeomException
        return

    @staticmethod
    def insert(data: Dict[str, Any], shape: str) -> None:
        sql = f"""
            INSERT INTO gis.{shape} (entity_id, name, description, type, geom) VALUES (
                %(entity_id)s,
                %(name)s,
                %(description)s,
                %(type)s,
                public.ST_SetSRID(public.ST_GeomFromGeoJSON(%(geojson)s),4326));"""
        g.cursor.execute(sql, data)

    @staticmethod
    def insert_import(data: Dict[str, Any]) -> None:
        sql = """
            INSERT INTO gis.point (entity_id, name, description, type, geom) VALUES (
                %(entity_id)s,
                '',
                %(description)s,
                'centerpoint',
                public.ST_SetSRID(public.ST_GeomFromGeoJSON(%(geojson)s),4326));"""
        g.cursor.execute(sql, data)

    @staticmethod
    def delete_by_entity_id(id_: int) -> None:
        g.cursor.execute('DELETE FROM gis.point WHERE entity_id = %(id)s;', {'id': id_})
        g.cursor.execute('DELETE FROM gis.linestring WHERE entity_id = %(id)s;', {'id': id_})
        g.cursor.execute('DELETE FROM gis.polygon WHERE entity_id = %(id)s;', {'id': id_})

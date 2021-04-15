import ast
from typing import Any, Dict, List, Optional

from flask import g, json
from flask_wtf import FlaskForm

from openatlas.database.gis import Gis as Db
from openatlas.models.entity import Entity
from openatlas.models.imports import Project
from openatlas.models.node import Node
from openatlas.util.display import sanitize


class InvalidGeomException(Exception):
    pass


class Gis:

    @staticmethod
    def add_example_geom(location: Entity) -> None:
        # Used for tests until model is decoupled from forms
        Db.add_example_geom(location.id)

    @staticmethod
    def get_by_id(id_: int) -> List[Dict[str, Any]]:
        return Db.get_by_id(id_)

    @staticmethod
    def get_all(objects: Optional[List[Entity]] = None,
                structure: Optional[Dict[str, Any]] = None) -> Dict[str, List[Any]]:

        if not objects:
            objects = []
        all_: Dict[str, List[Any]] = {'point': [], 'linestring': [], 'polygon': []}
        extra: Dict[str, List[Any]] = {'supers': [], 'subs': [], 'siblings': []}
        selected: Dict[str, List[Any]] = {
            'point': [],
            'linestring': [],
            'polygon': [],
            'polygon_point': []}

        # Include GIS of subunits which would be otherwise omitted
        subunit_ids = [subunit.id for subunit in structure['subunits']] if structure else []
        sibling_ids = [sibling.id for sibling in structure['siblings']] if structure else []
        extra_ids = [0]
        if structure:
            extra_ids = [objects[0].id if objects else 0] + [structure['super_id']] + subunit_ids \
                        + sibling_ids
        object_ids = [x.id for x in objects] if objects else []

        for shape in ['point', 'polygon', 'linestring']:
            place_root = Node.get_hierarchy('Place')
            for row in Db.get_by_shape(shape, extra_ids):
                description = row['description'].replace('"', '\"') if row['description'] else ''
                object_desc = row['object_desc'].replace('"', '\"') if row['object_desc'] else ''
                item = {
                    'type': 'Feature',
                    'geometry': json.loads(row['geojson']),
                    'properties': {
                        'objectId': row['object_id'],
                        'objectName': row['object_name'].replace('"', '\"'),
                        'objectDescription': object_desc,
                        'id': row['id'],
                        'name': row['name'].replace('"', '\"') if row['name'] else '',
                        'description': description,
                        'shapeType': row['type']}}
                if 'types' in row and row['types']:
                    nodes_list = ast.literal_eval('[' + row['types'] + ']')
                    for node_id in list(set(nodes_list)):
                        node = g.nodes[node_id]
                        if node.root and node.root[-1] == place_root.id:
                            item['properties']['objectType'] = node.name.replace('"', '\"')
                            break
                if structure and row['object_id'] == structure['super_id']:
                    extra['supers'].append(item)
                elif row['object_id'] in object_ids:
                    selected[shape].append(item)
                elif row['object_id'] in subunit_ids:  # pragma no cover
                    extra['subs'].append(item)
                elif row['object_id'] in sibling_ids:  # pragma no cover
                    extra['siblings'].append(item)
                else:
                    all_[shape].append(item)
                if 'polygon_point' in row:
                    polygon_point_item = dict(item)  # Make a copy to prevent overriding geometry
                    polygon_point_item['geometry'] = json.loads(row['polygon_point'])
                    if row['object_id'] in object_ids:
                        selected['polygon_point'].append(polygon_point_item)
                    elif row['object_id'] and structure and \
                            row['object_id'] == structure['super_id']:
                        extra['supers'].append(polygon_point_item)
                    elif row['object_id'] in subunit_ids:  # pragma no cover
                        extra['subs'].append(polygon_point_item)
                    elif row['object_id'] in sibling_ids:  # pragma no cover
                        extra['siblings'].append(polygon_point_item)
                    else:
                        all_['point'].append(polygon_point_item)
        return {
            'gisPointAll': json.dumps(all_['point']),
            'gisPointSelected': json.dumps(selected['point']),
            'gisPointSupers': json.dumps(extra['supers']),
            'gisPointSubs': json.dumps(extra['subs']),
            'gisPointSibling': json.dumps(extra['siblings']),
            'gisLineAll': json.dumps(all_['linestring']),
            'gisLineSelected': json.dumps(selected['linestring']),
            'gisPolygonAll': json.dumps(all_['polygon']),
            'gisPolygonSelected': json.dumps(selected['polygon']),
            'gisPolygonPointSelected': json.dumps(selected['polygon_point']),
            'gisAllSelected': json.dumps(selected['polygon'] + selected['linestring'] +
                                         selected['point'])}

    @staticmethod
    def insert(entity: Entity, form: FlaskForm) -> None:
        for shape in ['point', 'line', 'polygon']:
            data = getattr(form, 'gis_' + shape + 's').data
            if not data:
                continue  # pragma: no cover
            for item in json.loads(data):
                if not item['geometry']['coordinates'] or item['geometry']['coordinates'] == [[]]:
                    continue  # pragma: no cover
                if item['properties']['shapeType'] != 'centerpoint':
                    Db.test_geom(json.dumps(item['geometry']))
                Db.insert(
                    shape='linestring' if shape == 'line' else shape,
                    data={
                        'entity_id': entity.id,
                        'name': sanitize(item['properties']['name'], 'text'),
                        'description': sanitize(item['properties']['description'], 'text'),
                        'type': item['properties']['shapeType'],
                        'geojson': json.dumps(item['geometry'])})

    @staticmethod
    def insert_import(entity: Entity,
                      location: Entity,
                      project: Project,
                      easting: float,
                      northing: float) -> None:
        Db.insert_import({
            'entity_id': location.id,
            'description': 'Imported centerpoint of {name} from the {project} project'.format(
                name=sanitize(entity.name, 'text'),
                project=sanitize(project.name, 'text')),
            'geojson': '''{{"type":"Point", "coordinates": [{easting},{northing}]}}'''.format(
                easting=easting, northing=northing)})

    @staticmethod
    def delete_by_entity(entity: Entity) -> None:
        Db.delete_by_entity_id(entity.id)

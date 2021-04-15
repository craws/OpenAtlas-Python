from typing import Any, Dict, List, Optional, Union

from flask import g, url_for

from openatlas import app
from openatlas.api.v02.resources.error import EntityDoesNotExistError
from openatlas.models.entity import Entity
from openatlas.models.gis import Gis
from openatlas.models.link import Link
from openatlas.models.reference_system import ReferenceSystem
from openatlas.util.display import get_file_path


class GeoJsonEntity:

    @staticmethod
    def get_links(entity: Entity) -> Optional[List[Dict[str, str]]]:
        links = []
        for link in Link.get_links(entity.id, list(g.properties)):
            links.append({
                'label': link.range.name,
                'relationTo': url_for('entity', id_=link.range.id, _external=True),
                'relationType': 'crm:' + link.property.code + '_'
                                + link.property.i18n['en'].replace(' ', '_'),
                'relationSystemClass': link.range.class_.name,
                'type': link.type.name if link.type else None,
                'when': {'timespans': [GeoJsonEntity.get_time(link.range)]}})
        for link in Link.get_links(entity.id, list(g.properties), inverse=True):
            property_ = link.property.i18n['en'].replace(' ', '_')
            if link.property.i18n_inverse['en']:
                property_ = link.property.i18n_inverse['en'].replace(' ', '_')
            links.append({
                'label': link.domain.name,
                'relationTo': url_for('entity', id_=link.domain.id, _external=True),
                'relationType': 'crm:' + link.property.code + 'i_' + property_,
                'relationSystemClass': link.domain.class_.name,
                'type': link.type.name if link.type else None,
                'when': {'timespans': [GeoJsonEntity.get_time(link.domain)]}})
        return links if links else None

    @staticmethod
    def get_file(entity: Entity) -> Optional[List[Dict[str, str]]]:
        files = []
        for link in Link.get_links(entity.id, codes="P67", inverse=True):
            if link.domain.class_.name != 'file':
                continue
            path = get_file_path(link.domain.id)
            files.append({
                '@id': url_for('entity', id_=link.domain.id, _external=True),
                'title': link.domain.name,
                'license': GeoJsonEntity.get_license(link.domain),
                'url': url_for(
                    'display_file_api', filename=path.name, _external=True) if path else "N/A"})
        return files if files else None

    @staticmethod
    def get_license(entity: Entity) -> Optional[str]:
        file_license = None
        for node in entity.nodes:
            if g.nodes[node.root[-1]].name == 'License':
                file_license = node.name
        return file_license

    @staticmethod
    def get_node(entity: Entity) -> Optional[List[Dict[str, Any]]]:
        nodes = []
        for node in entity.nodes:
            nodes_dict = {
                'identifier': url_for('entity', id_=node.id, _external=True),
                'label': node.name}
            for link in Link.get_links(entity.id, 'P2'):
                if link.range.id == node.id and link.description:
                    nodes_dict['value'] = link.description
                    if link.range.id == node.id and node.description:
                        nodes_dict['unit'] = node.description
            hierarchy = [g.nodes[root].name for root in node.root]
            hierarchy.reverse()
            nodes_dict['hierarchy'] = ' > '.join(map(str, hierarchy))
            nodes.append(nodes_dict)
        return nodes if nodes else None

    @staticmethod
    def get_time(entity: Union[Entity, Link]) -> Optional[Dict[str, Any]]:
        return {
            'start': {
                'earliest': entity.begin_from,
                'latest': entity.begin_to,
                'comment': entity.begin_comment},
            'end': {
                'earliest': entity.end_from,
                'latest': entity.end_to,
                'comment': entity.end_comment}}

    @staticmethod
    def get_geoms_by_entity(entity: Entity) -> Union[str, Dict[str, Any]]:
        geoms = Gis.get_by_id(entity.id)
        if len(geoms) == 1:
            return geoms[0]
        return {'type': 'GeometryCollection', 'geometries': geoms}

    @staticmethod
    def get_reference_systems(entity: Entity) -> Optional[List[Dict[str, Any]]]:
        ref = []
        for link_ in Link.get_links(entity.id, codes="P67", inverse=True):
            if not isinstance(link_.domain, ReferenceSystem):
                continue
            system = g.reference_systems[link_.domain.id]
            ref.append({
                'identifier':
                    (system.resolver_url if system.resolver_url else '') + link_.description,
                'type': g.nodes[link_.type.id].name,
                'reference_system': system.name})
        return ref if ref else None

    @staticmethod
    def get_entity_by_id(id_: int) -> Entity:
        try:
            entity = Entity.get_by_id(id_, nodes=True, aliases=True)
        except Exception:
            raise EntityDoesNotExistError
        return entity

    @staticmethod
    def get_entity(entity: Entity, parser: Dict[str, Any]) -> Dict[str, Any]:
        type_ = 'FeatureCollection'
        class_code = ''.join(entity.cidoc_class.code + " " + entity.cidoc_class.i18n['en'])
        features = {
            '@id': url_for('entity_view', id_=entity.id, _external=True),
            'type': 'Feature',
            'crmClass': "crm:" + class_code,
            'system_class': entity.class_.name,
            'properties': {'title': entity.name}}
        if entity.description:
            features['description'] = [{'value': entity.description}]
        if entity.aliases and 'names' in parser['show']:
            features['names'] = []
            for key, value in entity.aliases.items():
                features['names'].append({"alias": value})
        features['relations'] = GeoJsonEntity.get_links(entity) if 'relations' in parser[
            'show'] else None
        features['types'] = GeoJsonEntity.get_node(entity) if 'types' in parser['show'] else None
        features['depictions'] = GeoJsonEntity.get_file(entity) if 'depictions' in parser[
            'show'] else None
        features['when'] = {'timespans': [GeoJsonEntity.get_time(entity)]} if 'when' in parser[
            'show'] else None
        features['links'] = GeoJsonEntity.get_reference_systems(entity) if 'links' in parser[
            'show'] else None
        if 'geometry' in parser['show']:
            if entity.class_.view == 'place' or entity.class_.name in ['find', 'artifact']:
                features['geometry'] = GeoJsonEntity.get_geoms_by_entity(
                    Link.get_linked_entity(entity.id, 'P53'))
            elif entity.class_.name == 'object_location':
                features['geometry'] = GeoJsonEntity.get_geoms_by_entity(entity)
        return {
            'type': type_,
            '@context': app.config['API_SCHEMA'],
            'features': [features]}

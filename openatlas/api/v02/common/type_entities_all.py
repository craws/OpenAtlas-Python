from typing import List, Tuple, Union

from flask import Response, g, jsonify
from flask_restful import Resource, marshal

from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import InvalidSubunitError
from openatlas.api.v02.resources.linked_places import LinkedPlaces
from openatlas.api.v02.resources.pagination import Pagination
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.linked_places import LinkedPlacesTemplate


class GetTypeEntitiesAll(Resource):  # type: ignore
    @staticmethod
    def get(id_: int) -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        entities = []
        for entity in GetTypeEntitiesAll.get_node_all(id_):
            entities.append(LinkedPlaces.get_entity_by_id(entity))
        if parser['count']:
            return jsonify(len(entities))
        output = Pagination.pagination(entities=entities, parser=parser)
        template = LinkedPlacesTemplate.pagination(parser['show'])
        if parser['download']:
            return Download.download(data=output, template=template, name=id_)
        return marshal(output, template), 200

    @staticmethod
    def get_node_all(id_: int) -> List[int]:
        if id_ not in g.nodes:
            raise InvalidSubunitError
        return GetTypeEntitiesAll.get_recursive_node_entities(id_, [])

    @staticmethod
    def get_recursive_node_entities(id_: int, data: List[int]) -> List[int]:
        for entity in g.nodes[id_].get_linked_entities(['P2', 'P89'], inverse=True):
            data.append(entity.id)
        for sub_id in g.nodes[id_].subs:
            GetTypeEntitiesAll.get_recursive_node_entities(sub_id, data)
        return data

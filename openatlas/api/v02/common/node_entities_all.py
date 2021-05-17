from typing import Any, Dict, List, Tuple, Union

from flask import Response, g, jsonify, url_for
from flask_restful import Resource, marshal

from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import InvalidSubunitError
from openatlas.api.v02.resources.parser import default_parser
from openatlas.api.v02.templates.nodes import NodeTemplate


class GetNodeEntitiesAll(Resource):  # type: ignore
    @staticmethod
    def get(id_: int) -> Union[Tuple[Resource, int], Response]:
        parser = default_parser.parse_args()
        node = {"nodes": GetNodeEntitiesAll.get_node_all(id_)}
        if parser['count']:
            return jsonify(len(node['nodes']))
        template = NodeTemplate.node_template()
        if parser['download']:
            return Download.download(data=node, template=template, name=id_)
        return marshal(node, template), 200

    @staticmethod
    def get_node_all(id_: int) -> List[Dict[str, Any]]:
        if id_ not in g.nodes:
            raise InvalidSubunitError
        return GetNodeEntitiesAll.get_recursive_node_entities(id_, [])

    @staticmethod
    def get_recursive_node_entities(id_: int, data: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        for entity in g.nodes[id_].get_linked_entities(['P2', 'P89'], inverse=True):
            data.append({
                'id': entity.id,
                'label': entity.name,
                'url': url_for('entity', id_=entity.id, _external=True)})
        for sub_id in g.nodes[id_].subs:
            GetNodeEntitiesAll.get_recursive_node_entities(sub_id, data)
        return data

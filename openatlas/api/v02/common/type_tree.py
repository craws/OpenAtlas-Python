from typing import Any, Dict, List, Tuple, Union

from flask import Response, jsonify
from flask_restful import Resource, marshal

from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.type_tree import TypeTreeTemplate
from openatlas.models.node import Node


class GetTypeTree(Resource):  # type: ignore
    @staticmethod
    def get() -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        type_tree = {'type_tree': GetTypeTree.get_type_tree()}
        if parser['count']:
            return jsonify(len(type_tree['type_tree']))
        template = TypeTreeTemplate.type_tree_template()
        if parser['download']:
            return Download.download(data=type_tree, template=template, name='type_tree')
        return marshal(type_tree, template), 200

    @staticmethod
    def get_type_tree() -> List[Dict[int, Dict[str, Any]]]:
        return [
            {id_: GetTypeTree.serialize_to_json(node)}
            for id_, node in Node.get_all_nodes().items()]

    @staticmethod
    def serialize_to_json(node: Node) -> Dict[str, Any]:
        return {
            'id': node.id,
            'name': node.name,
            'description': node.description,
            'origin_id': node.origin_id,
            'first': node.first,
            'last': node.last,
            'root': node.root,
            'subs': node.subs,
            'count': node.count,
            'count_subs': node.count_subs,
            'locked': node.locked,
            'standard': node.standard}

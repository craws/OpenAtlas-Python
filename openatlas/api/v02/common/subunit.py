from typing import Any, Dict, List, Tuple, Union

from flask import Response, jsonify, url_for
from flask_restful import Resource, marshal

from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import EntityDoesNotExistError, InvalidSubunitError
from openatlas.api.v02.resources.parser import default_parser
from openatlas.api.v02.templates.nodes import NodeTemplate
from openatlas.models.entity import Entity
from openatlas.models.place import get_structure


class GetSubunit(Resource):  # type: ignore
    @staticmethod
    def get(id_: int) -> Union[Tuple[Resource, int], Response]:
        parser = default_parser.parse_args()
        node = {"nodes": GetSubunit.get_subunits(id_)}
        if parser['count']:
            return jsonify(len(node['nodes']))
        template = NodeTemplate.node_template()
        if parser['download']:
            return Download.download(data=node, template=template, name=id_)
        return marshal(node, template), 200

    @staticmethod
    def get_subunits(id_: int) -> List[Dict[str, Any]]:
        try:
            entity = Entity.get_by_id(id_, nodes=True)
        except Exception:
            raise EntityDoesNotExistError
        structure = get_structure(entity)
        if not structure or not structure['subunits']:
            raise InvalidSubunitError
        subunits = []
        for subunit in structure['subunits']:
            subunits.append({
                'id': subunit.id,
                'label': subunit.name,
                'url': url_for('entity', id_=subunit.id, _external=True)})
        return subunits

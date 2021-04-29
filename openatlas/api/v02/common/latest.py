from typing import Any, Dict, List, Tuple, Union

from flask import Response, jsonify
from flask_restful import Resource, marshal

from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import InvalidLimitError
from openatlas.api.v02.resources.linked_places import LinkedPlacesEntity
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.linked_places import LinkedPlacesTemplate
from openatlas.models.entity import Entity


class GetLatest(Resource):  # type: ignore
    @staticmethod
    def get(latest: int) -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        entities = {"result": GetLatest.get_entities_get_latest(latest, parser)}
        if parser['count']:
            return jsonify(len(entities))
        template = LinkedPlacesTemplate.pagination(parser['show'])
        if parser['download']:
            return Download.download(data=entities, template=template, name=latest)
        return marshal(entities, template), 200

    @staticmethod
    def get_entities_get_latest(limit_: int, parser: Dict[str, Any]) -> List[Dict[str, Any]]:
        if not (0 < limit_ < 101):
            raise InvalidLimitError
        return [LinkedPlacesEntity.get_entity(e, parser) for e in Entity.get_latest(limit_)]

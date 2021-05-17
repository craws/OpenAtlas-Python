from typing import Any, Dict, List, Tuple, Union

from flask import Response, g, jsonify
from flask_restful import Resource, marshal

from openatlas.api.export.csv_export import ApiExportCSV
from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import InvalidCodeError
from openatlas.api.v02.resources.pagination import Pagination
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.linked_places import LinkedPlacesTemplate
from openatlas.database.api import Api as Db
from openatlas.models.entity import Entity


class GetBySystemClass(Resource):  # type: ignore
    @staticmethod
    def get(system_class: str) -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        if parser['export'] == 'csv':
            return ApiExportCSV.export_entities(
                GetBySystemClass.get_entities_by_system_class(
                    system_class=system_class,
                    parser=parser),
                system_class)
        system_class_ = Pagination.pagination(
            GetBySystemClass.get_entities_by_system_class(system_class=system_class, parser=parser),
            parser=parser)
        if parser['count']:
            return jsonify(system_class_['pagination']['entities'])
        template = LinkedPlacesTemplate.pagination(parser['show'])
        if parser['download']:
            return Download.download(data=system_class_, template=template, name=system_class)
        return marshal(system_class_, template), 200

    @staticmethod
    def get_entities_by_system_class(system_class: str, parser: Dict[str, Any]) -> List[Entity]:
        if system_class not in g.classes:
            raise InvalidCodeError
        return [Entity(row) for row in Db.get_by_system_class(system_class, parser)]

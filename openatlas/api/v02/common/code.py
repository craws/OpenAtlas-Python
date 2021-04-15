from typing import Any, Dict, List, Tuple, Union

from flask import Response, g, jsonify
from flask_restful import Resource, marshal

from openatlas.api.export.csv_export import ApiExportCSV
from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import InvalidCodeError
from openatlas.api.v02.resources.pagination import Pagination
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.geojson import GeoJson
from openatlas.database.api import Api as Db
from openatlas.models.entity import Entity
from openatlas.util.util import api_access


class GetByCode(Resource):  # type: ignore
    @api_access()  # type: ignore
    # @swag_from("../swagger/code.yml", endpoint="code")
    def get(self, code: str) -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        if parser['export'] == 'csv':
            return ApiExportCSV.export_entities(
                GetByCode.get_entities_by_view(code_=code, parser=parser), code)
        code_ = Pagination.pagination(
            GetByCode.get_entities_by_view(code_=code, parser=parser),
            parser=parser)
        if parser['count']:
            return jsonify(code_['pagination']['entities'])
        template = GeoJson.pagination(parser['show'])
        if parser['download']:
            return Download.download(data=code_, template=template, name=code)
        return marshal(code_, template), 200

    @staticmethod
    def get_entities_by_view(code_: str, parser: Dict[str, Any]) -> List[Entity]:
        if code_ not in g.view_class_mapping:
            raise InvalidCodeError
        return [Entity(row) for row in Db.get_by_system_class(g.view_class_mapping[code_], parser)]

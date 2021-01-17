from typing import Tuple, Union

from flasgger import swag_from
from flask import Response, jsonify
from flask_restful import Resource, marshal

from openatlas.api.v02.common.class_ import GetByClass
from openatlas.api.v02.common.code import GetByCode
from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.error import QueryEmptyError
from openatlas.api.v02.resources.geojson_entity import GeoJsonEntity
from openatlas.api.v02.resources.pagination import Pagination
from openatlas.api.v02.resources.parser import query_parser
from openatlas.api.v02.templates.geojson import GeoJson
from openatlas.util.util import api_access


class GetQuery(Resource):  # type: ignore
    @api_access()  # type: ignore
    @swag_from("../swagger/query.yml", endpoint="query")
    def get(self) -> Union[Tuple[Resource, int], Response]:
        entities = []
        parser = query_parser.parse_args()
        if not parser['entities'] and not parser['codes'] and not parser['classes']:
            raise QueryEmptyError
        template = GeoJson.pagination(parser['show'])
        if parser['entities']:
            for entity in parser['entities']:
                entities.append(GeoJsonEntity.get_entity_by_id(entity))
        if parser['codes']:
            for item in parser['codes']:
                entities.extend(GetByCode.get_entities_by_menu_item(code_=item, parser=parser))
        if parser['classes']:
            for class_ in parser['classes']:
                entities.extend(GetByClass.get_entities_by_class(class_code=class_, parser=parser))
        output = Pagination.pagination(entities=entities, parser=parser)
        if parser['count']:
            return jsonify(output['pagination'][0]['entities'])
        if parser['download']:
            return Download.download(data=output, template=template, name='query')
        return marshal(output, template), 200

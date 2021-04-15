from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.export.csv_export import ApiExportCSV
from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.geojson_entity import GeoJsonEntity
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.geojson import GeoJson
from openatlas.util.util import api_access


class GetEntity(Resource):  # type: ignore
    @api_access()  # type: ignore
    # @swag_from("../swagger/entity.yml", endpoint="entity")
    def get(self, id_: int) -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        if parser['export'] == 'csv':
            return ApiExportCSV.export_entity(GeoJsonEntity.get_entity_by_id(id_))
        entity = GeoJsonEntity.get_entity(GeoJsonEntity.get_entity_by_id(id_), parser)
        template = GeoJson.geojson_template(parser['show'])
        if parser['download']:
            return Download.download(data=entity, template=template, name=id_)
        return marshal(entity, template), 200

from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.export.csv_export import ApiExportCSV
from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.linked_places import LinkedPlacesEntity
from openatlas.api.v02.resources.parser import entity_parser
from openatlas.api.v02.templates.linked_places import LinkedPlacesTemplate


class GetEntity(Resource):  # type: ignore
    @staticmethod
    def get(id_: int) -> Union[Tuple[Resource, int], Response]:
        parser = entity_parser.parse_args()
        if parser['export'] == 'csv':
            return ApiExportCSV.export_entity(LinkedPlacesEntity.get_entity_by_id(id_))
        entity = LinkedPlacesEntity.get_entity(LinkedPlacesEntity.get_entity_by_id(id_), parser)
        template = LinkedPlacesTemplate.linked_places_template(parser['show'])
        if parser['download']:
            return Download.download(data=entity, template=template, name=id_)
        return marshal(entity, template), 200

from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.v02.templates.overview_count import CountTemplate
from openatlas.models.entity import Entity


class OverviewCount(Resource):  # type: ignore
    @staticmethod
    def get() -> Union[Tuple[Resource, int], Response]:
        return marshal(
            [{'systemClass': name, 'count': count} for name, count in
             Entity.get_overview_counts().items()], CountTemplate.overview_template()), 200
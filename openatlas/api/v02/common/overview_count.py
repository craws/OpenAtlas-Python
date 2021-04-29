from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.v02.templates.overview_count import OverviewCountTemplate
from openatlas.models.entity import Entity


class OverviewCount(Resource):  # type: ignore
    @staticmethod
    def get() -> Union[Tuple[Resource, int], Response]:
        overview = []
        for name, count in Entity.get_overview_counts().items():
            overview.append({'systemClass': name, 'count': count})
        return marshal(overview, OverviewCountTemplate.overview_template()), 200

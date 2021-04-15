from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.v02.templates.overview_count import OverviewCountTemplate
from openatlas.models.entity import Entity
from openatlas.util.util import api_access


class OverviewCount(Resource):  # type: ignore
    @api_access()  # type: ignore
    # @swag_from("../swagger/overview_count.yml", endpoint="overview_count")
    def get(self) -> Union[Tuple[Resource, int], Response]:
        overview = []
        for name, count in Entity.get_overview_counts().items():
            overview.append({'systemClass': name, 'count': count})
        return marshal(overview, OverviewCountTemplate.overview_template()), 200

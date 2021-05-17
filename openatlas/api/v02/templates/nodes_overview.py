from typing import Dict

from flask_restful import fields
from flask_restful.fields import List as RestList


class NodesOverviewTemplate:

    @staticmethod
    def node_overview_template() -> Dict[str, RestList]:
        categories = {
            'standard': fields.Raw,
            'places': fields.Raw,
            'custom': fields.Raw,
            'value': fields.Raw}
        return {"types": fields.List(fields.Nested(categories))}

from typing import Dict

from flask_restful import fields
from flask_restful.fields import List as RestList


class NodeTemplate:

    @staticmethod
    def node_template() -> Dict[str, RestList]:
        json = {
            'id': fields.Integer,
            'label': fields.String,
            'url': fields.String}
        return {"nodes": fields.List(fields.Nested(json))}

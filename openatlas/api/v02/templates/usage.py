from typing import Dict

from flask_restful import fields
from flask_restful.fields import List as RestList


class UsageTemplate:

    @staticmethod
    def usage_template() -> Dict[str, RestList]:
        examples = {
            'entity': fields.String,
            'code': fields.String,
            'class': fields.String,
            'system_class': fields.String,
            'query': fields.String,
            'latest': fields.String,
            'node_entities': fields.String,
            'node_entities_all': fields.String,
            'subunit': fields.String,
            'subunit_hierarchy': fields.String}

        return {
            'message': fields.String,
            'examples': fields.List(fields.Nested(examples))}

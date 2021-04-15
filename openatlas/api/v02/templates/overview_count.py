from typing import Dict, Type, Union

from flask_restful import fields
from flask_restful.fields import Integer, String


class OverviewCountTemplate:

    @staticmethod
    def overview_template() -> Dict[str, Type[Union[String, Integer]]]:
        return {'systemClass': fields.String, 'count': fields.Integer}

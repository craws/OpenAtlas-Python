from typing import Dict, Type

from flask_restful import fields
from flask_restful.fields import String


class ClassMappingTemplate:

    @staticmethod
    def class_mapping_template() -> Dict[str, Type[String]]:
        return {
            'systemClass': fields.String,
            'crmClass': fields.String,
            'view': fields.String,
            'icon': fields.String,
            'en': fields.String}

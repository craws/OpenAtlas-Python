from typing import Any, Dict

from flask_restful import fields


class TypeTreeTemplate:

    @staticmethod
    def type_tree_template() -> Dict[str, Any]:
        return {'type_tree': fields.Raw}

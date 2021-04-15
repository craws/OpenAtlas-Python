import json
from typing import Any, Dict, List, Union

from flask import Response
from flask_restful import marshal

from openatlas.models.entity import Entity


class Download:

    @staticmethod
    def download(
            data: Union[List[Dict[str, Any]], Dict[str, Any], List[Entity]],
            template: Dict[str, Any],
            name: Union[str, int]) -> Response:
        return Response(
            json.dumps(marshal(data, template)),
            mimetype='application/json',
            headers={'Content-Disposition': 'attachment;filename=' + str(name) + '.json'})

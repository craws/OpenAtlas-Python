from typing import Tuple, Union

from flask import Response, url_for
from flask_restful import Resource, marshal

from openatlas.api.v02.templates.usage import UsageTemplate
from openatlas.util.util import api_access


class ShowUsage(Resource):  # type: ignore
    @api_access()  # type: ignore
    # @swag_from("../swagger/usage.yml", endpoint="usage")
    def get(self) -> Union[Tuple[Resource, int], Response]:
        usage = {
            'message': 'The path you entered is not correct.',
            'examples': {
                'entity': url_for('entity', id_=23, _external=True),
                'code': url_for('code', code='actor', _external=True),
                'class': url_for('class', class_code='E18', _external=True),
                'system_class': url_for('system_class', system_class='person', _external=True),
                'query': url_for('query', classes='E18', view='actor', entities=23, _external=True),
                'latest': url_for('latest', latest='30', _external=True),
                'node_entities': url_for('node_entities', id_=23, _external=True),
                'node_entities_all': url_for('node_entities_all', id_=23, _external=True),
                'subunit': url_for('subunit', id_=23, _external=True),
                'subunit_hierarchy': url_for('subunit_hierarchy', id_=23, _external=True)}}
        return marshal(usage, UsageTemplate.usage_template()), 200

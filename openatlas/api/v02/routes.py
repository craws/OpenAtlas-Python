from flask_cors import CORS
from flask_restful import Api

from openatlas import app
from openatlas.api.v02.common.class_ import GetByClass
from openatlas.api.v02.common.class_mapping import ClassMapping
from openatlas.api.v02.common.code import GetByCode
from openatlas.api.v02.common.content import GetContent
from openatlas.api.v02.common.entity import GetEntity
from openatlas.api.v02.common.latest import GetLatest
from openatlas.api.v02.common.node_entities import GetNodeEntities
from openatlas.api.v02.common.node_entities_all import GetNodeEntitiesAll
from openatlas.api.v02.common.node_overview import GetNodeOverview
from openatlas.api.v02.common.overview_count import OverviewCount
from openatlas.api.v02.common.query import GetQuery
from openatlas.api.v02.common.resource_gone import ResourceGone
from openatlas.api.v02.common.subunit import GetSubunit
from openatlas.api.v02.common.subunit_hierarchy import GetSubunitHierarchy
from openatlas.api.v02.common.system_class import GetBySystemClass
from openatlas.api.v02.common.type_entities import GetTypeEntities
from openatlas.api.v02.common.type_entities_all import GetTypeEntitiesAll
from openatlas.api.v02.common.type_tree import GetTypeTree
from openatlas.api.v02.common.usage import ShowUsage
from openatlas.api.v02.resources.error import errors

app.config['SWAGGER'] = {'openapi': '3.0.2', 'uiversion': 3}

cors = CORS(app, resources={r"/api/*": {"origins": app.config['CORS_ALLOWANCE']}})
api = Api(app, catch_all_404s=False, errors=errors)
# swagger = Swagger(app, parse=False, template_file="api/v02/swagger.json")
# swagger = Swagger(app, parse=False, template=template)

api.add_resource(ClassMapping, '/api/0.2/classes/', endpoint='class_mapping')
api.add_resource(GetByCode, '/api/0.2/code/<string:code>', endpoint="code")
api.add_resource(GetEntity, '/api/0.2/entity/<int:id_>', endpoint='entity')
api.add_resource(GetLatest, '/api/0.2/latest/<int:latest>', endpoint="latest")
api.add_resource(GetQuery, '/api/0.2/query/', endpoint="query")
api.add_resource(GetBySystemClass, '/api/0.2/system_class/<string:system_class>',
                 endpoint="system_class")
api.add_resource(GetTypeEntities, '/api/0.2/type_entities/<int:id_>', endpoint="type_entities")
api.add_resource(GetTypeEntitiesAll, '/api/0.2/type_entities_all/<int:id_>',
                 endpoint="type_entities_all")

api.add_resource(GetNodeEntities, '/api/0.2/node_entities/<int:id_>', endpoint="node_entities")
api.add_resource(GetNodeEntitiesAll, '/api/0.2/node_entities_all/<int:id_>',
                 endpoint="node_entities_all")
api.add_resource(GetNodeOverview, '/api/0.2/node_overview/', endpoint="node_overview")
api.add_resource(GetSubunit, '/api/0.2/subunit/<int:id_>', endpoint="subunit")
api.add_resource(GetSubunitHierarchy, '/api/0.2/subunit_hierarchy/<int:id_>',
                 endpoint="subunit_hierarchy")
api.add_resource(GetTypeTree, '/api/0.2/type_tree/', endpoint="type_tree")

api.add_resource(GetByClass, '/api/0.2/class/<string:class_code>', endpoint="class")
api.add_resource(GetContent, '/api/0.2/content/', endpoint="content")
api.add_resource(OverviewCount, '/api/0.2/overview_count/', endpoint='overview_count')

api.add_resource(
    ShowUsage, '/api/0.2/', '/api/0.2/entity/', '/api/0.2/class/', '/api/0.2/code/',
    '/api/0.2/latest/', '/api/0.2/node_entities/', '/api/0.2/node_entities_all/',
    '/api/0.2/subunit/', '/api/0.2/subunit_hierarchy/', '/api/0.2/system_class/', endpoint='usage')

api.add_resource(
    ResourceGone, '/api/0.1/', '/api/0.1/entity/', '/api/0.1/class/', '/api/0.1/code/',
    '/api/0.1/latest/', '/api/0.1/node_entities/', '/api/0.1/node_entities_all/',
    '/api/0.1/subunit/', '/api/0.1/subunit_hierarchy/', '/api/0.1/system_class/',
    '/api/0.1/entity/<int:id_>', '/api/0.1/query/', '/api/0.1/class/<string:class_code>',
    '/api/0.1/code/<string:code>', '/api/0.1/content/', endpoint="gone")

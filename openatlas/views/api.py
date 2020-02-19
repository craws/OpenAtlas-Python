from flask import json, render_template, request, Response

from openatlas import app
from openatlas.models.api import Api
from openatlas.util.util import required_group


@app.route('/api/0.1/entity/<int:id_>')
@required_group('readonly')
def api_entity(id_: int) -> Response:
    return Response(json.dumps(Api.get_entity(id_=id_)), mimetype='application/ld+json')


@app.route('/api/0.1')
@required_group('readonly')
def api_get_multiple_entities():  # pragma: no cover
    entity = request.args.getlist('entity')
    return Response(json.dumps(Api.get_entities_by_id(ids=entity)), mimetype='application/ld+json')


@app.route('/api/0.1/code/<code>')
@required_group('readonly')
def api_get_by_code(code):
    return Response(json.dumps(Api.get_entities_by_code(code_=code)),
                    mimetype='application/ld+json')


@app.route('/api/0.1/class/<class_code>')
@required_group('readonly')
def api_get_by_class(class_code):
    return Response(json.dumps(Api.get_entities_by_class(class_code_=class_code)),
                    mimetype='application/ld+json')


@app.route('/api/0.1/latest/<limit>')
@required_group('readonly')
def api_get_latest(limit):
    return Response(json.dumps(Api.get_entities_get_latest(limit_=limit)),
                    mimetype='application/ld+json')


@app.route('/api')
@required_group('readonly')
def api_index() -> str:
    return render_template('api/index.html')

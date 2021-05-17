from flask import jsonify, request

from openatlas import app
from openatlas.models.user import User
from openatlas.util.util import required_group, uc_first


@app.route('/ajax/bookmark', methods=['POST'])
@required_group('readonly')
def ajax_bookmark() -> str:
    return jsonify(uc_first(User.toggle_bookmark(request.form['entity_id'])))

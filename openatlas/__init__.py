import locale
import os
import sys
import time
from typing import Any, Dict, Optional

import psycopg2.extras
from flask import Flask, Response, g, request, session
from flask_babel import Babel
from flask_wtf.csrf import CSRFProtect

app: Flask = Flask(__name__, instance_relative_config=True)
csrf = CSRFProtect(app)  # Make sure all forms are CSRF protected

# Use the test database if running tests
instance_name = 'production' if 'test_runner.py' not in sys.argv[0] else 'testing'

# Load config/default.py and instance/INSTANCE_NAME.py
app.config.from_object('config.default')  # type: ignore
app.config.from_pyfile(instance_name + '.py')  # type: ignore
app.config['WTF_CSRF_TIME_LIMIT'] = None  # Make CSRF token valid for the life of the session.

if os.name == "posix":  # For non Linux systems we would need adaptions here, e.g. Windows
    locale.setlocale(locale.LC_ALL, 'en_US.utf-8')
babel = Babel(app)
debug_model: Dict[str, float] = {}

from openatlas.models.logger import Logger

logger = Logger()

from openatlas.util import filters, processor
from openatlas.views import (admin, ajax, anthropology, entity, entity_index, entity_form, export,
                             file, hierarchy, index, involvement, imports, link, login, member,
                             model, note, overlay, profile, reference, relation, reference_system,
                             search, source, sql, types, user)

#  Restful API import
from openatlas.api import util  # contains routes for each version
from openatlas.api.v02 import routes  # New routes
from openatlas.api.v02.resources import parser


@babel.localeselector
def get_locale() -> str:
    if 'language' in session:
        return session['language']
    best_match = request.accept_languages.best_match(app.config['LANGUAGES'].keys())
    # Check if best_match is set (in tests it isn't)
    return best_match if best_match else session['settings']['default_language']


def connect() -> psycopg2.connect:
    try:
        connection_ = psycopg2.connect(
            database=app.config['DATABASE_NAME'],
            user=app.config['DATABASE_USER'],
            password=app.config['DATABASE_PASS'],
            port=app.config['DATABASE_PORT'],
            host=app.config['DATABASE_HOST'])
        connection_.autocommit = True
        return connection_
    except Exception as e:  # pragma: no cover
        print("Database connection error.")
        raise Exception(e)


def execute(query: str, vars_: Optional[Dict[str, Any]] = None) -> None:
    debug_model['sql'] += 1
    return g.cursor.execute(query, vars_)


@app.before_request
def before_request() -> None:
    from openatlas.models.model import CidocClass, CidocProperty
    from openatlas.models.node import Node
    from openatlas.models.settings import Settings
    from openatlas.models.reference_system import ReferenceSystem
    if request.path.startswith('/static'):  # pragma: no cover
        return  # Only needed if not running with Apache and static alias
    debug_model['sql'] = 0
    debug_model['current'] = time.time()
    g.db = connect()
    g.cursor = g.db.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    g.execute = execute  # Add wrapper for g.cursor.execute to count SQL statements per request
    session['settings'] = Settings.get_settings()
    session['language'] = get_locale()
    g.cidoc_classes = CidocClass.get_all()
    g.properties = CidocProperty.get_all()
    from openatlas.models.system import (get_system_classes, get_class_view_mapping,
                                         get_table_headers, view_class_mapping)
    g.table_headers = get_table_headers()
    g.classes = get_system_classes()
    g.view_class_mapping = view_class_mapping
    g.class_view_mapping = get_class_view_mapping()
    g.nodes = Node.get_all_nodes()
    g.reference_systems = ReferenceSystem.get_all()

    debug_model['model'] = time.time() - debug_model['current']
    debug_model['current'] = time.time()

    # Set max file upload in MB
    app.config['MAX_CONTENT_LENGTH'] = session['settings']['file_upload_max_size'] * 1024 * 1024


@app.after_request
def apply_caching(response: Response) -> Response:
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    return response


@app.teardown_request
def teardown_request(exception: Any) -> None:
    if hasattr(g, 'db'):
        g.db.close()


app.register_blueprint(filters.blueprint)
app.add_template_global(debug_model, 'debug_model')

if __name__ == "__main__":  # pragma: no cover
    app.run()

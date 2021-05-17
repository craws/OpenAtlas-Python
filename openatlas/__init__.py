import locale
import os
import sys
from typing import Any

from flask import Flask, Response, g, request, session
from flask_babel import Babel
from flask_login import current_user
from flask_wtf.csrf import CSRFProtect

from openatlas.api.v02.resources.error import AccessDeniedError
from openatlas.database.connect import close_connection, open_connection

app: Flask = Flask(__name__, instance_relative_config=True)
csrf = CSRFProtect(app)  # Make sure all forms are CSRF protected

# Use test database if running tests
instance_name = 'production' if 'test_runner.py' not in sys.argv[0] else 'testing'

app.config.from_object('config.default')  # type: ignore
app.config.from_pyfile(instance_name + '.py')  # type: ignore
app.config['WTF_CSRF_TIME_LIMIT'] = None  # Set CSRF token valid for the life of the session.

if os.name == "posix":
    locale.setlocale(locale.LC_ALL, 'en_US.utf-8')
babel = Babel(app)

from openatlas.models.logger import Logger
logger = Logger()

from openatlas.api import util  # contains routes for each version
from openatlas.api.v02 import routes  # New routes
from openatlas.util import processor
from openatlas.views import (
    admin, ajax, anthropology, entity, entity_index, entity_form, export, file, hierarchy, index, involvement,
    imports, link, login, member, model, note, overlay, profile, reference, relation,
    reference_system, search, source, sql, types, user)


@babel.localeselector
def get_locale() -> str:
    if 'language' in session:
        return session['language']
    best_match = request.accept_languages.best_match(app.config['LANGUAGES'].keys())
    return best_match if best_match else session['settings']['default_language']


@app.before_request
def before_request() -> None:
    from openatlas.models.model import CidocClass, CidocProperty
    from openatlas.models.node import Node
    from openatlas.models.settings import Settings
    from openatlas.models.reference_system import ReferenceSystem
    if request.path.startswith('/static'):  # pragma: no cover
        return  # Avoid overhead for static files, only needed if not using Apache with static alias
    open_connection(app.config)
    session['settings'] = Settings.get_settings()
    session['language'] = get_locale()
    g.cidoc_classes = CidocClass.get_all()
    g.properties = CidocProperty.get_all()

    from openatlas.models import system
    g.table_headers = system.get_table_headers()
    g.classes = system.get_system_classes()
    g.view_class_mapping = system.view_class_mapping
    g.class_view_mapping = system.get_class_view_mapping()
    g.nodes = Node.get_all_nodes()
    g.reference_systems = ReferenceSystem.get_all()

    # Set max file upload in MB
    app.config['MAX_CONTENT_LENGTH'] = session['settings']['file_upload_max_size'] * 1024 * 1024

    if request.path.startswith('/api/'):
        ip = request.environ.get('HTTP_X_REAL_IP', request.remote_addr)
        if not current_user.is_authenticated \
                and not session['settings']['api_public'] \
                and ip not in app.config['ALLOWED_IPS']:
            raise AccessDeniedError  # pragma: no cover


@app.after_request
def apply_caching(response: Response) -> Response:
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    return response


@app.teardown_request
def teardown_request(exception: Any) -> None:
    close_connection()


if __name__ == "__main__":  # pragma: no cover
    app.run()

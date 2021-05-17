from flask import flash, g, url_for
from flask_babel import lazy_gettext as _
from werkzeug.utils import redirect
from werkzeug.wrappers import Response

from openatlas import app, logger
from openatlas.util.util import required_group


@app.route('/reference_system/remove_form/<int:system_id>/<int:form_id>', methods=['POST', 'GET'])
@required_group('manager')
def reference_system_remove_form(system_id: int, form_id: int) -> Response:
    try:
        g.reference_systems[system_id].remove_form(form_id)
        flash(_('info update'), 'info')
    except Exception as e:  # pragma: no cover
        logger.log('error', 'database', 'remove form failed', e)
        flash(_('error database'), 'error')
    return redirect(url_for('entity_view', id_=system_id))

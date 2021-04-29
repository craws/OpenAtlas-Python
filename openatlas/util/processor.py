from typing import Dict, Union

from flask import session, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from wtforms import StringField

from openatlas import app
from openatlas.util.util import get_file_extension


class GlobalSearchForm(FlaskForm):  # type: ignore
    term = StringField('', render_kw={"placeholder": _('search term')})


@app.context_processor
def inject_template_functions() -> Dict[str, Union[str, GlobalSearchForm]]:
    # Defines variables and functions without arguments for templates.

    def get_logo() -> str:
        logo = '/static/images/layout/logo.png'
        if session['settings']['logo_file_id']:
            ext = get_file_extension(int(session['settings']['logo_file_id']))
            if ext != 'N/A':
                logo = url_for('display_logo', filename=session['settings']['logo_file_id'] + ext)
        return logo

    return dict(get_logo=get_logo(), search_form=GlobalSearchForm(prefix="global"))

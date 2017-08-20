# Copyright 2017 by Alexander Watzinger and others. Please see README.md for licensing information
from flask import render_template
from flask_babel import lazy_gettext as _
from flask_login import login_required, current_user
from flask_wtf import Form
from wtforms import SelectField

import openatlas
from openatlas import app
from openatlas.util.util import uc_first


class ProfileForm(Form):
    language = SelectField(uc_first(_('language')), choices=[])
    # theme = SelectField(uc_first(_('theme')), choices=[])
    layout = SelectField(uc_first(_('layout')), choices=[
        ('default', uc_first(_('default'))), ('advanced', uc_first(_('advanced')))])
    table_rows = SelectField(uc_first(_('table rows')), choices=[])


@app.route('/profile')
@login_required
def profile_index():
    data = {'info': [
        (_('username'), current_user.username),
        (_('name'), current_user.real_name),
        (_('email'), current_user.email),
        (_('show email'), current_user.get_setting('show_email')),
        (_('newsletter'), current_user.get_setting('newsletter'))]}
    form = ProfileForm()
    getattr(form, 'language').choices = openatlas.app.config['LANGUAGES'].items()
    getattr(form, 'table_rows').choices = openatlas.default_table_rows.items()
    form.language.data = current_user.get_setting('language')
    data['display'] = [
        (form.language.label, form.language),
        # (form.theme.label, form.theme),
        (form.layout.label, form.layout),
        (form.table_rows.label, form.table_rows)]
    return render_template('profile/index.html', data=data, form=form)


@app.route('/profile/update')
@login_required
def profile_update():
    return render_template('profile/update.html')


@app.route('/profile/password')
@login_required
def profile_password():
    return render_template('profile/password.html')

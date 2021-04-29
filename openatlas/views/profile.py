import importlib
from typing import Union

import bcrypt
from flask import flash, render_template, session, url_for
from flask_babel import lazy_gettext as _
from flask_login import current_user, login_required
from flask_wtf import FlaskForm
from werkzeug.exceptions import abort
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import BooleanField, PasswordField, SubmitField
from wtforms.validators import InputRequired

from openatlas import app, logger
from openatlas.database.connect import Transaction
from openatlas.forms.setting import DisplayForm, ModulesForm, ProfileForm
from openatlas.forms.util import get_form_settings, set_form_settings
from openatlas.util.util import is_authorized, uc_first


class PasswordForm(FlaskForm):  # type: ignore
    password_old = PasswordField(_('old password'), [InputRequired()])
    password = PasswordField(_('password'), [InputRequired()])
    password2 = PasswordField(_('repeat password'), [InputRequired()])
    show_passwords = BooleanField(_('show passwords'))
    save = SubmitField(_('save'))

    def validate(self) -> bool:
        valid = FlaskForm.validate(self)
        hash_ = bcrypt.hashpw(
            self.password_old.data.encode('utf-8'),
            current_user.password.encode('utf-8'))
        if hash_ != current_user.password.encode('utf-8'):
            self.password_old.errors.append(_('error wrong password'))
            valid = False
        if self.password.data != self.password2.data:
            self.password.errors.append(_('error passwords must match'))
            self.password2.errors.append(_('error passwords must match'))
            valid = False
        if self.password_old.data == self.password.data:
            self.password.errors.append(_('error new password like old password'))
            valid = False
        if len(self.password.data) < session['settings']['minimum_password_length']:
            self.password.errors.append(_('error password too short'))
            valid = False
        return valid


@app.route('/profile', methods=['POST', 'GET'])
@login_required
def profile_index() -> str:
    return render_template(
        'profile/index.html',
        info={
            'profile': get_form_settings(ProfileForm(), True),
            'modules': get_form_settings(ModulesForm(), True),
            'display': get_form_settings(DisplayForm(), True)},
        title=_('profile'),
        crumbs=[_('profile')])


@app.route('/profile/settings/<category>', methods=['POST', 'GET'])
@login_required
def profile_settings(category: str) -> Union[str, Response]:
    if category not in ['profile', 'display'] and not is_authorized('contributor'):
        abort(403)  # pragma: no cover
    form = getattr(
        importlib.import_module('openatlas.forms.setting'),
        uc_first(category) + 'Form')()
    if form.validate_on_submit():
        for field in form:
            if field.type in ['CSRFTokenField', 'HiddenField', 'SubmitField']:
                continue
            if field.name == 'name':
                current_user.real_name = field.data
            elif field.name == 'email':
                current_user.email = field.data
            else:
                current_user.settings[field.name] = field.data
        Transaction.begin()
        try:
            current_user.update()
            current_user.update_settings(form)
            Transaction.commit()
            session['language'] = current_user.settings['language']
            flash(_('info update'), 'info')
        except Exception as e:  # pragma: no cover
            Transaction.rollback()
            logger.log('error', 'database', 'transaction failed', e)
            flash(_('error transaction'), 'error')
        return redirect(url_for('profile_index') + '#tab-' + category)
    set_form_settings(form, True)
    return render_template(
        'display_form.html',
        form=form,
        manual_page='profile',
        title=_('profile'),
        crumbs=[[_('profile'), url_for('profile_index') + '#tab-' + category], _(category)])


@app.route('/profile/password', methods=['POST', 'GET'])
@login_required
def profile_password() -> Union[str, Response]:
    form = PasswordForm()
    if form.validate_on_submit():
        current_user.password = bcrypt.hashpw(
            form.password.data.encode('utf-8'),
            bcrypt.gensalt()).decode('utf-8')
        current_user.update()
        flash(_('info password updated'), 'info')
        return redirect(url_for('profile_index'))
    return render_template(
        'profile/password.html',
        form=form,
        title=_('profile'),
        crumbs=[[_('profile'), url_for('profile_index')], _('change password')])

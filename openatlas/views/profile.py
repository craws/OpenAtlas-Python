from typing import Union

import bcrypt
from flask import flash, g, render_template, session, url_for
from flask_babel import lazy_gettext as _
from flask_login import current_user, login_required
from flask_wtf import FlaskForm
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import BooleanField, IntegerField, PasswordField, SelectField, StringField, SubmitField
from wtforms.validators import Email, InputRequired

from openatlas import app, logger
from openatlas.util.util import uc_first


class PasswordForm(FlaskForm):  # type: ignore
    password_old = PasswordField(_('old password'), [InputRequired()])
    password = PasswordField(_('password'), [InputRequired()])
    password2 = PasswordField(_('repeat password'), [InputRequired()])
    show_passwords = BooleanField(_('show passwords'))
    save = SubmitField(_('save'))

    def validate(self) -> bool:
        valid = FlaskForm.validate(self)
        hash_ = bcrypt.hashpw(self.password_old.data.encode('utf-8'),
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


class ProfileForm(FlaskForm):  # type: ignore
    name = StringField(_('full name'), description=_('tooltip full name'))
    email = StringField(_('email'), [InputRequired(), Email()], description=_('tooltip email'))
    show_email = BooleanField(_('show email'), description=_('tooltip show email'))
    newsletter = BooleanField(_('newsletter'), description=_('tooltip newsletter'))
    language = SelectField(_('language'), choices=list(app.config['LANGUAGES'].items()))
    table_rows = SelectField(_('table rows'),
                             description=_('tooltip table rows'),
                             choices=list(app.config['DEFAULT_TABLE_ROWS'].items()),
                             coerce=int)
    table_show_aliases = BooleanField(_('show aliases in tables'))
    layout_choices = [('default', _('default')), ('advanced', _('advanced'))]
    layout = SelectField(_('layout'), description=_('tooltip layout'), choices=layout_choices)
    max_zoom = IntegerField(_('max map zoom'))
    default_zoom = IntegerField(_('default map zoom'))
    module_geonames = BooleanField('GeoNames', description=_('tooltip geonames'))
    module_map_overlay = BooleanField(_('map overlay'), description=_('tooltip map overlay'))
    module_notes = BooleanField(_('notes'), description=_('tooltip notes'))
    save = SubmitField(_('save'))


@app.route('/profile', methods=['POST', 'GET'])
@login_required
def profile_index() -> str:
    user = current_user
    data = {'general': [(_('username'), user.username),
                        (_('full name'), user.real_name),
                        (_('email'), user.email),
                        (_('show email'),
                         uc_first(_('on')) if user.settings['show_email'] else uc_first(_('off'))),
                        (_('newsletter'),
                         uc_first(_('on')) if user.settings['newsletter'] else uc_first(_('off')))],
            'display': [(_('language'), user.settings['language']),
                        (_('table rows'), user.settings['table_rows']),
                        (_('show aliases in tables'), user.settings['table_show_aliases']),
                        (_('layout'), user.settings['layout']),
                        (_('max map zoom'), user.settings['max_zoom']),
                        (_('default map zoom'), user.settings['default_zoom'])],
            'modules': [('GeoNames', user.settings['module_geonames']),
                        (_('map overlay'), user.settings['module_map_overlay']),
                        (_('notes'), user.settings['module_notes'])]}
    return render_template('profile/index.html', data=data)


@app.route('/profile/update', methods=['POST', 'GET'])
@login_required
def profile_update() -> Union[str, Response]:
    form = ProfileForm()
    user = current_user
    if form.validate_on_submit():
        for field in form:
            if field.type in ['CSRFTokenField', 'HiddenField', 'SubmitField']:
                continue
            if field.name == 'name':
                user.real_name = field.data
            elif field.name == 'email':
                user.email = field.data
            else:
                user.settings[field.name] = field.data
        g.cursor.execute('BEGIN')
        try:
            user.update()
            user.update_settings()
            g.cursor.execute('COMMIT')
            session['language'] = form.language.data
            flash(_('info update'), 'info')
        except Exception as e:  # pragma: no cover
            g.cursor.execute('ROLLBACK')
            logger.log('error', 'database', 'transaction failed', e)
            flash(_('error transaction'), 'error')
        return redirect(url_for('profile_index'))
    for field in form:
        if field.type in ['CSRFTokenField', 'HiddenField', 'SubmitField']:
            continue
        field.label.text = uc_first(field.label.text)
        if field.name == 'name':
            field.data = current_user.real_name
        elif field.name == 'email':
            field.data = current_user.email
        else:
            field.data = current_user.settings[field.name]
    form.save.label.text = uc_first(_('save'))
    return render_template('profile/update.html',
                           form=form,
                           form_fields={_('general'): [form.name,
                                                       form.email,
                                                       form.show_email,
                                                       form.newsletter],
                                        _('display'): [form.language,
                                                       form.table_rows,
                                                       form.table_show_aliases,
                                                       form.layout,
                                                       form.max_zoom,
                                                       form.default_zoom],
                                        _('modules'): [form.module_geonames,
                                                       form.module_map_overlay,
                                                       form.module_notes]})


@app.route('/profile/password', methods=['POST', 'GET'])
@login_required
def profile_password() -> Union[str, Response]:
    form = PasswordForm()
    if form.validate_on_submit():
        current_user.password = bcrypt.hashpw(form.password.data.encode('utf-8'),
                                              bcrypt.gensalt()).decode('utf-8')
        current_user.update()
        flash(_('info password updated'), 'info')
        return redirect(url_for('profile_index'))
    return render_template('profile/password.html', form=form)

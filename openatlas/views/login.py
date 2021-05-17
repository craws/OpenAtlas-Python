import datetime
from typing import Union

import bcrypt
from bcrypt import hashpw
from flask import abort, flash, render_template, request, session, url_for
from flask_babel import lazy_gettext as _
from flask_login import LoginManager, current_user, login_required, login_user, logout_user
from flask_wtf import FlaskForm
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import BooleanField, PasswordField, StringField, SubmitField
from wtforms.validators import Email, InputRequired

from openatlas import app, logger
from openatlas.models.user import User
from openatlas.util.util import send_mail, uc_first

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'


@login_manager.user_loader
def load_user(user_id: int) -> User:
    return User.get_by_id(user_id, True)


class LoginForm(FlaskForm):  # type: ignore
    username = StringField(_('username'), [InputRequired()], render_kw={'autofocus': True})
    password = PasswordField(_('password'), [InputRequired()])
    show_passwords = BooleanField(_('show password'))
    save = SubmitField(_('login'))


class PasswordResetForm(FlaskForm):  # type: ignore
    email = StringField(_('email'), [InputRequired(), Email()])
    save = SubmitField(_('submit'))


@app.route('/login', methods=["GET", "POST"])
def login() -> Union[str, Response]:
    if current_user.is_authenticated:
        return redirect('/')
    form = LoginForm()
    if form.validate_on_submit():
        user = User.get_by_username(request.form['username'])
        if user and user.username:
            if user.login_attempts_exceeded():
                logger.log('notice', 'auth', 'Login attempts exceeded: ' + user.username)
                flash(_('error login attempts exceeded'), 'error')
                return render_template('login/index.html', form=form)
            hash_ = hashpw(request.form['password'].encode('utf-8'), user.password.encode('utf-8'))
            if hash_ == user.password.encode('utf-8'):
                if user.active:
                    login_user(user)
                    session['login_previous_success'] = user.login_last_success
                    session['login_previous_failures'] = user.login_failed_count
                    if user.settings['language']:
                        session['language'] = user.settings['language']
                    user.login_last_success = datetime.datetime.now()
                    user.login_failed_count = 0
                    user.update()
                    logger.log('info', 'auth', 'Login of ' + user.username)
                    return redirect(request.args.get('next') or url_for('overview'))
                else:
                    logger.log('notice', 'auth', 'Inactive login try ' + user.username)
                    flash(_('error inactive'), 'error')
            else:
                logger.log('notice', 'auth', 'Wrong password: ' + user.username)
                user.login_failed_count += 1
                user.login_last_failure = datetime.datetime.now()
                user.update()
                flash(_('error wrong password'), 'error')
        else:
            logger.log('notice', 'auth', 'Wrong username: ' + request.form['username'])
            flash(_('error username'), 'error')
    return render_template('login/index.html', title=_('login'), crumbs=[_('login')], form=form)


@app.route('/password_reset', methods=["GET", "POST"])
def reset_password() -> Union[str, Response]:
    if current_user.is_authenticated:  # Prevent password reset if already logged in
        return redirect(url_for('overview'))
    form = PasswordResetForm()
    if form.validate_on_submit() and session['settings']['mail']:  # pragma: no cover
        user = User.get_by_email(form.email.data)
        if not user:
            logger.log('info', 'password', 'Password reset for non existing ' + form.email.data)
            flash(_('error non existing email'), 'error')
        else:
            code = User.generate_password()
            user.password_reset_code = code
            user.password_reset_date = datetime.datetime.now()
            user.update()
            link = request.scheme + '://' + request.headers['Host']
            link += url_for('reset_confirm', code=code)
            subject = _('Password reset request for %(site_name)s',
                        site_name=session['settings']['site_name'])
            body = _('We received a password reset request for %(username)s',
                     username=user.username)
            body += ' ' + _('at') + ' '
            body += request.headers['Host'] + '\n\n' + _('reset password link') + ':\n\n'
            body += link + '\n\n' + _('The link is valid for') + ' '
            body += str(session['settings']['reset_confirm_hours']) + ' ' + _('hours') + '.'
            email = form.email.data
            if send_mail(subject, body, form.email.data):
                flash(
                    _('A password reset confirmation mail was send to %(email)s.', email=email),
                    'info')
            else:
                flash(
                    _('Failed to send password reset confirmation mail to %(email)s.', email=email),
                    'error')
            return redirect(url_for('login'))
    return render_template(
        'login/reset_password.html',
        form=form,
        crumbs=[[_('login'), url_for('login')], _('Forgot your password?')])


@app.route('/reset_confirm/<code>')
def reset_confirm(code: str) -> Response:  # pragma: no cover
    user = User.get_by_reset_code(code)
    if not user or not user.username or not user.email:
        logger.log('info', 'auth', 'unknown reset code')
        flash(_('invalid password reset confirmation code'), 'error')
        abort(404)
    hours = session['settings']['reset_confirm_hours']
    if datetime.datetime.now() > user.password_reset_date + datetime.timedelta(hours=hours):
        logger.log('info', 'auth', 'reset code expired')
        flash(_('This reset confirmation code has expired.'), 'error')
        abort(404)
    password = User.generate_password()
    user.password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    user.password_reset_code = None
    user.password_reset_date = None
    user.login_failed_count = 0
    user.update()
    subject = _('New password for %(sitename)s', sitename=session['settings']['site_name'])
    body = _('New password for %(username)s', username=user.username) + ' '
    body += _('at') + ' ' + request.scheme + '://' + request.headers['Host'] + ':\n\n'
    body += uc_first(_('username')) + ': ' + user.username + '\n'
    body += uc_first(_('password')) + ': ' + password + '\n'
    if send_mail(subject, body, user.email, False):
        flash(_('Send new password mail to %(email)s.', email=user.email), 'info')
    else:
        flash(_('Failed to send password mail to %(email)s.', email=user.email), 'error')
    return redirect(url_for('login'))


@app.route('/logout')
@login_required
def logout() -> Response:
    logout_user()
    return redirect(url_for('login'))

from __future__ import annotations  # Needed for Python 4.0 type annotations

import smtplib
from datetime import datetime
from email.header import Header
from email.mime.text import MIMEText
from functools import wraps
from pathlib import Path
from typing import Any, Dict, List, TYPE_CHECKING, Union

from flask import abort, flash, request, session, url_for
from flask_babel import lazy_gettext as _
from flask_login import current_user
from flask_wtf import FlaskForm
from werkzeug.utils import redirect

import openatlas
from openatlas import app
from openatlas.api.v02.resources.error import AccessDeniedError

if TYPE_CHECKING:  # pragma: no cover - Type checking is disabled in tests
    from openatlas.models.entity import Entity


def send_mail(
        subject: str,
        text: str,
        recipients: Union[str, List[str]],
        log_body: bool = True) -> bool:  # pragma: no cover
    """Send one mail to every recipient, set log_body to False for sensitive data e.g. passwords"""
    recipients = recipients if isinstance(recipients, list) else [recipients]
    settings = session['settings']
    if not settings['mail'] or len(recipients) < 1:
        return False
    mail_user = settings['mail_transport_username']
    from_ = settings['mail_from_name'] + ' <' + settings['mail_from_email'] + '>'
    server = smtplib.SMTP(settings['mail_transport_host'], settings['mail_transport_port'])
    server.ehlo()
    server.starttls()
    try:
        if settings['mail_transport_username']:
            server.login(mail_user, app.config['MAIL_PASSWORD'])
        for recipient in recipients:
            msg = MIMEText(text, _charset='utf-8')
            msg['From'] = from_
            msg['To'] = recipient.strip()
            msg['Subject'] = Header(subject.encode('utf-8'), 'utf-8')
            server.sendmail(settings['mail_from_email'], recipient, msg.as_string())
        log_text = 'Mail from ' + from_ + ' to ' + ', '.join(recipients) + ' Subject: ' + subject
        log_text += ' Content: ' + text if log_body else ''
        openatlas.logger.log('info', 'mail', 'Mail send from ' + from_, log_text)
    except smtplib.SMTPAuthenticationError as e:
        openatlas.logger.log('error', 'mail', 'Error mail login for ' + mail_user, e)
        flash(_('error mail login'), 'error')
        return False
    except Exception as e:
        openatlas.logger.log('error', 'mail', 'Error send mail for ' + mail_user, e)
        flash(_('error mail send'), 'error')
        return False
    return True


def get_file_stats(path: Path = app.config['UPLOAD_DIR']) -> Dict[Union[int, str], Any]:
    """For performance: Build a dict with file ids and stats from files in given directory."""
    file_stats: Dict[Union[int, str], Any] = {}
    for file in path.iterdir():
        if file.stem.isdigit():
            file_stats[int(file.stem)] = {
                'ext': file.suffix,
                'size': file.stat().st_size,
                'date': file.stat().st_ctime}
    return file_stats


def required_group(group: str):  # type: ignore
    def wrapper(f):  # type: ignore
        @wraps(f)
        def wrapped(*args, **kwargs):  # type: ignore
            if not current_user.is_authenticated:
                return redirect(url_for('login', next=request.path))
            if not is_authorized(group):
                abort(403)
            return f(*args, **kwargs)

        return wrapped

    return wrapper


def api_access():  # type: ignore
    def wrapper(f):  # type: ignore
        @wraps(f)
        def wrapped(*args, **kwargs):  # type: ignore
            ip = request.environ.get('HTTP_X_REAL_IP', request.remote_addr)
            if not current_user.is_authenticated \
                    and not session['settings']['api_public'] \
                    and ip not in app.config['ALLOWED_IPS']:
                raise AccessDeniedError  # pragma: no cover
            return f(*args, **kwargs)

        return wrapped

    return wrapper


def is_authorized(group: str) -> bool:
    if not current_user.is_authenticated or not hasattr(current_user, 'group'):
        return False  # pragma: no cover - needed because AnonymousUserMixin has no group
    if current_user.group == 'admin' or (
            current_user.group == 'manager' and group in
            ['manager', 'editor', 'contributor', 'readonly']) or (
            current_user.group == 'editor' and group in ['editor', 'contributor', 'readonly']) or (
            current_user.group == 'contributor' and group in ['contributor', 'readonly']) or (
            current_user.group == 'readonly' and group == 'readonly'):
        return True
    return False


def was_modified(form: FlaskForm, entity: 'Entity') -> bool:  # pragma: no cover
    if not entity.modified or not form.opened.data:
        return False
    if entity.modified < datetime.fromtimestamp(float(form.opened.data)):
        return False
    openatlas.logger.log('info', 'multi user', 'Multi user overwrite prevented.')
    return True


def is_float(value: Union[int, float]) -> bool:
    try:
        float(value)
        return True
    except ValueError:
        return False

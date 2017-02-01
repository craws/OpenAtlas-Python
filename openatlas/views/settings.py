# Copyright 2017 by Alexander Watzinger and others. Please see the file README.md for licensing information
from collections import OrderedDict

import openatlas
from flask import flash, session, render_template
from flask_wtf import Form
from openatlas import app
from openatlas.models.settings import SettingsMapper
from openatlas.util import util
from werkzeug.utils import redirect
from wtforms import StringField, BooleanField

from openatlas.util.util import uc_first


class SettingsForm(Form):

    # General
    site_name = StringField('site_name')
    default_language = StringField('default_language')
    default_table_rows = StringField('default_table_rows')
    log_level = StringField('log_level')
    maintenance = BooleanField('maintenance')
    offline = BooleanField('offline')

    # Mail
    mail = BooleanField('mail')
    mail_transport_username = StringField('mail_transport_username')
    mail_transport_host = StringField('mail_transport_host')
    mail_transport_port = StringField('mail_transport_port')
    mail_transport_type = StringField('mail_transport_type')
    mail_transport_ssl = StringField('mail_transport_ssl')
    mail_transport_auth = StringField('mail_transport_auth')
    mail_from_email = StringField('mail_from_email')
    mail_from_name = StringField('mail_from_name')
    mail_recipients_login = StringField('mail_recipients_login')
    mail_recipients_feedback = StringField('mail_recipients_feedback')

    # Authentication
    random_password_length = StringField('random_password_length')
    reset_confirm_hours = StringField('reset_confirm_hours')
    failed_login_tries = StringField('failed_login_tries')
    failed_login_forget_minutes = StringField('failed_login_forget_minutes')


@app.route('/settings')
def settings_index():
    settings = SettingsMapper.get_settings()
    log_array = {
        '0': 'Emergency',
        '1': 'Alert',
        '2': 'Critical',
        '3': 'Error',
        '4': 'Warn',
        '5': 'Notice',
        '6': 'Info',
        '7': 'Debug'
    }
    groups = OrderedDict([
        ('general', OrderedDict([
            ('site_name', settings['site_name']),
            ('default_language', settings['default_language']),
            ('default_table_rows', settings['default_table_rows']),
            ('log_level', log_array[settings['log_level']]),
            ('maintenance', uc_first('on') if settings['maintenance'] else uc_first('off')),
            ('offline', uc_first('on') if settings['offline'] else uc_first('off')),
        ])),
        ('mail', OrderedDict([
            ('mail', uc_first('on') if settings['mail'] else uc_first('off')),
            ('mail_transport_username', settings['mail_transport_username']),
            ('mail_transport_host', settings['mail_transport_host']),
            ('mail_transport_port', settings['mail_transport_port']),
            ('mail_transport_type', settings['mail_transport_type']),
            ('mail_transport_ssl', settings['mail_transport_ssl']),
            ('mail_transport_auth', settings['mail_transport_auth']),
            ('mail_from_email', settings['mail_from_email']),
            ('mail_from_name', settings['mail_from_name']),
            ('mail_recipients_login', settings['mail_recipients_login']),
            ('mail_recipients_feedback', settings['mail_recipients_feedback']),
        ])),
        ('authentication', OrderedDict([
            ('random_password_length', settings['random_password_length']),
            ('reset_confirm_hours', settings['reset_confirm_hours']),
            ('failed_login_tries', settings['failed_login_tries']),
            ('failed_login_forget_minutes', settings['failed_login_forget_minutes'])
        ]))
    ])
    return render_template('settings/index.html', groups=groups, settings=settings)


@app.route('/settings/update', methods=["GET", "POST"])
def settings_update():
    form = SettingsForm()
    return render_template('settings/update.html', form=form, settings=SettingsMapper.get_settings())

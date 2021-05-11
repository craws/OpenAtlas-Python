from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from wtforms import BooleanField, IntegerField, SelectField, StringField, SubmitField
from wtforms.validators import Email, InputRequired

from openatlas import app


class ContentForm(FlaskForm):  # type: ignore
    pass


class ModulesForm(FlaskForm):  # type: ignore
    module_map_overlay = BooleanField(_('map overlay'))
    module_sub_units = BooleanField(_('sub units'))
    save = SubmitField(_('save'))


class GeneralForm(FlaskForm):  # type: ignore
    site_name = StringField(_('site name'), [InputRequired()])
    default_language = SelectField(
        _('default language'),
        choices=list(app.config['LANGUAGES'].items()))
    table_rows = SelectField(
        _('default table rows'),
        coerce=int,
        choices=list(app.config['TABLE_ROWS'].items()))
    log_level = SelectField(
        _('log level'),
        coerce=int,
        choices=list(app.config['LOG_LEVELS'].items()))
    random_password_length = IntegerField(_('random password length'))
    minimum_password_length = IntegerField(_('minimum password length'))
    reset_confirm_hours = IntegerField(_('reset confirm hours'))
    failed_login_tries = IntegerField(_('failed login tries'))
    failed_login_forget_minutes = IntegerField(_('failed login forget minutes'))
    minimum_jstree_search = IntegerField(_('minimum jstree search'))
    save = SubmitField(_('save'))


class TestMailForm(FlaskForm):  # type: ignore
    receiver = StringField(_('test mail receiver'), [InputRequired(), Email()])
    save = SubmitField(_('send test mail'))


class MailForm(FlaskForm):  # type: ignore
    mail = BooleanField(_('mail'))
    mail_transport_username = StringField(_('mail transport username'))
    mail_transport_host = StringField(_('mail transport host'))
    mail_transport_port = StringField(_('mail transport port'))
    mail_from_email = StringField(_('mail from email'), [Email()])
    mail_from_name = StringField(_('mail from name'))
    mail_recipients_feedback = StringField(_('mail recipients feedback'))
    save = SubmitField(_('save'))


class LogForm(FlaskForm):  # type: ignore
    limit = SelectField(_('limit'), choices=((0, _('all')), (100, 100), (500, 500)), default=100)
    priority = SelectField(
        _('priority'),
        choices=(list(app.config['LOG_LEVELS'].items())),
        default=6)
    user = SelectField(_('user'), choices=([(0, _('all'))]), default=0)
    save = SubmitField(_('apply'))


class MapForm(FlaskForm):  # type: ignore
    map_zoom_default = IntegerField(_('default map zoom'), [InputRequired()])
    map_zoom_max = IntegerField(_('max map zoom'), [InputRequired()])
    map_cluster_disable_at_zoom = IntegerField(_('disable clustering at zoom'))
    map_cluster_max_radius = IntegerField(_('max cluster radius'))
    geonames_username = StringField('GeoNames ' + _('username'))
    save = SubmitField(_('save'))


class ApiForm(FlaskForm):  # type: ignore
    api_public = BooleanField('public')
    save = SubmitField(_('save'))


class FilesForm(FlaskForm):  # type: ignore
    file_upload_max_size = IntegerField(_('maximum file size in MB'))
    profile_image_width = IntegerField(_('profile image width in pixel'))
    file_upload_allowed_extension = StringField(_('allowed file extensions'))
    save = SubmitField(_('save'))


class SimilarForm(FlaskForm):  # type: ignore
    classes = SelectField(_('class'), choices=[])
    ratio = IntegerField(default=100)
    save = SubmitField(_('search'))


class ProfileForm(FlaskForm):  # type: ignore
    name = StringField(_('full name'), description=_('tooltip full name'))
    email = StringField(_('email'), [InputRequired(), Email()], description=_('tooltip email'))
    show_email = BooleanField(_('show email'), description=_('tooltip show email'))
    newsletter = BooleanField(_('newsletter'), description=_('tooltip newsletter'))
    save = SubmitField(_('save'))


class DisplayForm(FlaskForm):  # type: ignore
    language = SelectField(_('language'), choices=list(app.config['LANGUAGES'].items()))
    table_rows = SelectField(
        _('table rows'),
        description=_('tooltip table rows'),
        choices=list(app.config['TABLE_ROWS'].items()),
        coerce=int)
    table_show_aliases = BooleanField(_('show aliases in tables'))
    entity_show_dates = BooleanField(_('show created and modified information'))
    entity_show_import = BooleanField(_('show import information'))
    entity_show_class = BooleanField(_('show CIDOC class'))
    entity_show_api = BooleanField(_('show API links'))
    map_zoom_default = IntegerField(_('default map zoom'), [InputRequired()])
    map_zoom_max = IntegerField(_('max map zoom'), [InputRequired()])
    save = SubmitField(_('save'))

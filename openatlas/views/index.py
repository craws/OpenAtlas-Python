from typing import Dict, Tuple, Union

from flask import flash, g, render_template, request, session, url_for
from flask_babel import format_number, lazy_gettext as _
from flask_login import current_user
from flask_wtf import FlaskForm
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import SelectField, SubmitField, TextAreaField
from wtforms.validators import InputRequired

from openatlas import app, logger
from openatlas.api.v02.resources.error import MethodNotAllowedError
from openatlas.models.content import Content
from openatlas.models.entity import Entity
from openatlas.models.user import User
from openatlas.util.changelog import Changelog
from openatlas.util.display import bookmark_toggle, format_date, link, uc_first
from openatlas.util.table import Table
from openatlas.util.util import required_group, send_mail


class FeedbackForm(FlaskForm):  # type: ignore
    subject = SelectField(
        _('subject'),
        render_kw={'autofocus': True},
        choices=(
            ('suggestion', _('suggestion')),
            ('question', _('question')),
            ('problem', _('problem'))))
    description = TextAreaField(_('description'), [InputRequired()])
    save = SubmitField(_('send'))


@app.route('/')
@app.route('/overview')
def overview() -> str:
    tables = {
        'overview': Table(paging=False, defs=[{'className': 'dt-body-right', 'targets': 1}]),
        'bookmarks': Table(['name', 'class', _('first'), _('last')]),
        'notes': Table(['date', _('visibility'), 'entity', 'class', _('note')]),
        'latest': Table(order=[[0, 'desc']])}
    if current_user.is_authenticated and hasattr(current_user, 'bookmarks'):
        for entity_id in current_user.bookmarks:
            entity = Entity.get_by_id(entity_id)
            tables['bookmarks'].rows.append([
                link(entity),
                entity.class_.label,
                entity.first,
                entity.last,
                bookmark_toggle(entity.id, True)])
        for note in User.get_notes_by_user_id(current_user.id):
            entity = Entity.get_by_id(note['entity_id'])
            tables['notes'].rows.append([
                format_date(note['created']),
                uc_first(_('public')) if note['public'] else uc_first(_('private')),
                link(entity),
                entity.class_.label,
                note['text'],
                '<a href="{url}">{label}</a>'.format(
                    url=url_for('note_view', id_=note['id']),
                    label=uc_first(_('view')))])
        for name, count in Entity.get_overview_counts().items():
            if count:
                url = url_for('index', view=g.class_view_mapping[name])
                if name == 'administrative_unit':
                    url = url_for('node_index') + '#menu-tab-places'
                elif name == 'type':
                    url = url_for('node_index')
                elif name == 'find':
                    url = url_for('index', view='artifact')
                elif name in ['feature', 'human_remains', 'stratigraphic_unit',
                              'source_translation']:
                    url = ''
                tables['overview'].rows.append([
                    link(g.classes[name].label, url) if url else g.classes[name].label,
                    format_number(count)])
        for entity in Entity.get_latest(8):
            tables['latest'].rows.append([
                format_date(entity.created),
                link(entity),
                entity.class_.label,
                entity.first,
                entity.last,
                link(logger.get_log_for_advanced_view(entity.id)['creator'])])
    return render_template(
        'index/index.html',
        intro=Content.get_translation('intro'),
        crumbs=['overview'],
        tables=tables)


@app.route('/index/setlocale/<language>')
def set_locale(language: str) -> Response:
    session['language'] = language
    if hasattr(current_user, 'id') and current_user.id:
        current_user.settings['language'] = language
        current_user.update_language()
    return redirect(request.referrer)


@app.route('/overview/feedback', methods=['POST', 'GET'])
@required_group('readonly')
def index_feedback() -> Union[str, Response]:
    form = FeedbackForm()
    if form.validate_on_submit() and session['settings']['mail']:  # pragma: no cover
        subject = uc_first(form.subject.data) + ' from ' + session['settings']['site_name']
        user = current_user
        body = form.subject.data + ' from ' + user.username + ' (' + str(user.id) + ') '
        body += user.email + ' at ' + request.headers['Host'] + "\n\n" + form.description.data
        if send_mail(subject, body, session['settings']['mail_recipients_feedback']):
            flash(_('info feedback thanks'), 'info')
        else:
            flash(_('error mail send'), 'error')
        return redirect(url_for('overview'))
    return render_template(
        'index/feedback.html',
        form=form,
        title=_('feedback'),
        crumbs=[_('feedback')])


@app.route('/overview/content/<item>')
def index_content(item: str) -> str:
    return render_template(
        'index/content.html',
        text=Content.get_translation(item),
        title=_(_(item)),
        crumbs=[_(item)])


@app.errorhandler(400)
def bad_request(e: Exception) -> Tuple[Union[Dict[str, str], str], int]:  # pragma: no cover
    return render_template('400.html', crumbs=['400 - Bad Request'], e=e), 400


@app.errorhandler(403)
def forbidden(e: Exception) -> Tuple[Union[Dict[str, str], str], int]:
    return render_template('403.html', crumbs=['403 - Forbidden'], e=e), 403


@app.errorhandler(404)
def page_not_found(e: Exception) -> Tuple[Union[Dict[str, str], str], int]:
    return render_template('404.html', crumbs=['404 - File not found'], e=e), 404


@app.errorhandler(405)  # pragma: no cover
def method_not_allowed(e: Exception) -> Tuple[Union[Dict[str, str], str], int]:
    raise MethodNotAllowedError


@app.errorhandler(418)
def invalid_id(e: Exception) -> Tuple[str, int]:
    return render_template('418.html', crumbs=["418 - I’m a teapot"], e=e), 418


@app.errorhandler(422)
def unprocessable_entity(e: Exception) -> Tuple[str, int]:  # pragma: no cover
    return render_template('422.html', crumbs=['422 - Unprocessable entity'], e=e), 422


@app.route('/changelog')
def index_changelog() -> str:
    return render_template(
        'index/changelog.html',
        title=_('changelog'),
        crumbs=[_('changelog')],
        versions=Changelog.versions)


@app.route('/unsubscribe/<code>')
def index_unsubscribe(code: str) -> str:
    user = User.get_by_unsubscribe_code(code)
    text = _('unsubscribe link not valid')
    if user:  # pragma: no cover
        user.settings['newsletter'] = ''
        user.unsubscribe_code = ''
        user.update()
        user.remove_newsletter()
        text = _('You have successfully unsubscribed. You can subscribe again in your Profile.')
    return render_template(
        'index/unsubscribe.html',
        text=text,
        crumbs=[_('unsubscribe newsletter')])

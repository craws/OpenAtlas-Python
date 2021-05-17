from typing import List, Union

from flask import flash, render_template, url_for
from flask_babel import lazy_gettext as _
from flask_login import current_user
from werkzeug.exceptions import abort
from werkzeug.utils import redirect
from werkzeug.wrappers import Response

from openatlas import app
from openatlas.forms.form import build_form
from openatlas.models.entity import Entity
from openatlas.models.user import User
from openatlas.util.tab import Tab
from openatlas.util.util import button, is_authorized, link, required_group, uc_first


@app.route('/note/view/<int:id_>')
def note_view(id_: int) -> str:
    note = User.get_note_by_id(id_)
    if not note['public'] and note['user_id'] != current_user.id:
        abort(403)  # pragma: no cover
    entity = Entity.get_by_id(note['entity_id'])
    buttons: List[str] = []
    if note['user_id'] == current_user.id:
        buttons = [
            button(_('edit'), url_for('note_update', id_=note['id'])),
            button(_('delete'), url_for('note_delete', id_=note['id']))]
    elif is_authorized('manager'):  # pragma: no cover
        buttons = [button(_('set private'), url_for('note_set_private', id_=note['id']))]
    return render_template(
        'user/note.html',
        entity=entity,
        note=note,
        tabs={'info': Tab('info')},
        buttons=buttons,
        crumbs=[
            [_(entity.class_.view), url_for('index', view=entity.class_.view)],
            link(entity),
            _('note')])


@app.route('/note/private/<int:id_>')
@required_group('contributor')
def note_set_private(id_: int) -> Union[str, Response]:
    if not is_authorized('manager'):
        abort(403)  # pragma: no cover
    note = User.get_note_by_id(id_)
    User.update_note(note['id'], note['text'], False)
    flash(_('note updated'), 'info')
    return redirect(url_for('entity_view', id_=note['entity_id']) + '#tab-note')


@app.route('/note/insert/<int:entity_id>', methods=['POST', 'GET'])
@required_group('contributor')
def note_insert(entity_id: int) -> Union[str, Response]:
    entity = Entity.get_by_id(entity_id)
    form = build_form('note')
    if form.validate_on_submit():
        User.insert_note(entity_id, form.description.data, form.public.data)
        flash(_('note added'), 'info')
        return redirect(url_for('entity_view', id_=entity.id) + '#tab-note')
    return render_template(
        'display_form.html',
        form=form,
        entity=entity,
        crumbs=[
            [_(entity.class_.view), url_for('index', view=entity.class_.view)],
            entity,
            '+ ' + uc_first(_('note'))])


@app.route('/note/update/<int:id_>', methods=['POST', 'GET'])
@required_group('contributor')
def note_update(id_: int) -> Union[str, Response]:
    note = User.get_note_by_id(id_)
    if not note['user_id'] == current_user.id:
        abort(403)  # pragma: no cover
    entity = Entity.get_by_id(note['entity_id'])
    form = build_form('note')
    if form.validate_on_submit():
        User.update_note(note['id'], form.description.data, form.public.data)
        flash(_('note updated'), 'info')
        return redirect(url_for('entity_view', id_=note['entity_id']) + '#tab-note')
    form.save.label.text = _('save')
    form.description.data = note['text']
    form.public.data = note['public']
    return render_template(
        'display_form.html',
        form=form,
        entity=entity,
        crumbs=[
            [_(entity.class_.view), url_for('index', view=entity.class_.view)],
            entity,
            _('edit note')])


@app.route('/note/delete/<int:id_>', methods=['POST', 'GET'])
@required_group('contributor')
def note_delete(id_: int) -> Response:
    note = User.get_note_by_id(id_)
    if not note['user_id'] == current_user.id:
        abort(403)  # pragma: no cover
    User.delete_note(note['id'])
    flash(_('note deleted'), 'info')
    return redirect(url_for('entity_view', id_=note['entity_id']) + '#tab-note')

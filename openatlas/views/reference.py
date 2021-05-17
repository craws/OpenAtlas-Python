from typing import Union

from flask import flash, render_template, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import StringField, SubmitField
from wtforms.validators import InputRequired

from openatlas import app
from openatlas.forms.field import TableField
from openatlas.forms.form import build_add_reference_form
from openatlas.models.entity import Entity
from openatlas.models.link import Link
from openatlas.util.util import required_group, uc_first


class AddReferenceForm(FlaskForm):  # type: ignore
    reference = TableField(_('reference'), [InputRequired()])
    page = StringField(_('page'))
    save = SubmitField(_('insert'))


@app.route('/reference/add/<int:id_>/<view>', methods=['POST', 'GET'])
@required_group('contributor')
def reference_add(id_: int, view: str) -> Union[str, Response]:
    reference = Entity.get_by_id(id_)
    form = build_add_reference_form(view)
    if form.validate_on_submit():
        entity = Entity.get_by_id(getattr(form, view).data)
        reference.link('P67', entity, form.page.data)
        return redirect(url_for('entity_view', id_=reference.id) + '#tab-' + view)
    if reference.class_.name == 'external_reference':
        form.page.label.text = uc_first(_('link text'))
    return render_template(
        'display_form.html',
        form=form,
        title=_('reference'),
        crumbs=[[_('reference'), url_for('index', view='reference')], reference, _('link')])


@app.route('/reference/link-update/<int:link_id>/<int:origin_id>', methods=['POST', 'GET'])
@required_group('contributor')
def reference_link_update(link_id: int, origin_id: int) -> Union[str, Response]:
    link_ = Link.get_by_id(link_id)
    origin = Entity.get_by_id(origin_id)
    form = AddReferenceForm()
    del form.reference
    if form.validate_on_submit():
        link_.description = form.page.data
        link_.update()
        flash(_('info update'), 'info')
        tab = '#tab-' + (
            link_.range.class_.view if origin.class_.view == 'reference' else 'reference')
        return redirect(url_for('entity_view', id_=origin.id) + tab)
    form.save.label.text = _('save')
    form.page.data = link_.description
    if link_.domain.class_.name == 'external_reference':
        form.page.label.text = uc_first(_('link text'))
    linked_object = link_.domain if link_.domain.id != origin.id else link_.range
    return render_template(
        'display_form.html',
        form=form,
        crumbs=[
            [_(origin.class_.view), url_for('index', view=origin.class_.view)],
            origin,
            linked_object,
            _('edit')])

import ast
from typing import Union

from flask import flash, g, render_template, url_for
from flask_babel import lazy_gettext as _
from werkzeug.utils import redirect
from werkzeug.wrappers import Response

from openatlas import app, logger
from openatlas.database.connect import Transaction
from openatlas.forms.form import build_form
from openatlas.forms.util import get_link_type
from openatlas.models.entity import Entity
from openatlas.models.link import Link
from openatlas.util.util import required_group


@app.route('/involvement/insert/<int:origin_id>', methods=['POST', 'GET'])
@required_group('contributor')
def involvement_insert(origin_id: int) -> Union[str, Response]:
    origin = Entity.get_by_id(origin_id)
    form = build_form('involvement', origin=origin)
    form.activity.choices = [('P11', g.properties['P11'].name_inverse)]
    if origin.class_.name in ['acquisition', 'activity']:
        form.activity.choices.append(('P14', g.properties['P14'].name_inverse))
        if origin.class_.name == 'acquisition':
            form.activity.choices.append(('P22', g.properties['P22'].name_inverse))
            form.activity.choices.append(('P23', g.properties['P23'].name_inverse))
    if form.validate_on_submit():
        Transaction.begin()
        try:
            if origin.class_.view == 'event':
                for actor in Entity.get_by_ids(ast.literal_eval(form.actor.data)):
                    link_ = Link.get_by_id(origin.link(
                        form.activity.data,
                        actor,
                        form.description.data)[0])
                    link_.set_dates(form)
                    link_.type = get_link_type(form)
                    link_.update()
            else:
                for event in Entity.get_by_ids(ast.literal_eval(form.event.data)):
                    link_ = Link.get_by_id(event.link(
                        form.activity.data,
                        origin,
                        form.description.data)[0])
                    link_.set_dates(form)
                    link_.type = get_link_type(form)
                    link_.update()
            Transaction.commit()
        except Exception as e:  # pragma: no cover
            Transaction.rollback()
            logger.log('error', 'database', 'transaction failed', e)
            flash(_('error transaction'), 'error')
        if hasattr(form, 'continue_') and form.continue_.data == 'yes':
            return redirect(url_for('involvement_insert', origin_id=origin_id))
        tab = 'actor' if origin.class_.view == 'event' else 'event'
        return redirect(url_for('entity_view', id_=origin.id) + '#tab-' + tab)
    return render_template(
        'display_form.html',
        form=form,
        crumbs=[[_(origin.class_.view), url_for('index', view=origin.class_.view)],
                origin,
                _('involvement')])


@app.route('/involvement/update/<int:id_>/<int:origin_id>', methods=['POST', 'GET'])
@required_group('contributor')
def involvement_update(id_: int, origin_id: int) -> Union[str, Response]:
    link_ = Link.get_by_id(id_)
    form = build_form('involvement', link_)
    form.activity.choices = [('P11', g.properties['P11'].name)]
    event = Entity.get_by_id(link_.domain.id)
    actor = Entity.get_by_id(link_.range.id)
    origin = event if origin_id == event.id else actor
    if event.class_.name in ['acquisition', 'activity']:
        form.activity.choices.append(('P14', g.properties['P14'].name))
        if event.class_.name == 'acquisition':
            form.activity.choices.append(('P22', g.properties['P22'].name))
            form.activity.choices.append(('P23', g.properties['P23'].name))
    if form.validate_on_submit():
        Transaction.begin()
        try:
            link_.delete()
            link_ = Link.get_by_id(event.link(form.activity.data, actor, form.description.data)[0])
            link_.set_dates(form)
            link_.type = get_link_type(form)
            link_.update()
            Transaction.commit()
        except Exception as e:  # pragma: no cover
            Transaction.rollback()
            logger.log('error', 'database', 'transaction failed', e)
            flash(_('error transaction'), 'error')
        tab = 'actor' if origin.class_.view == 'event' else 'event'
        return redirect(url_for('entity_view', id_=origin.id) + '#tab-' + tab)
    form.save.label.text = _('save')
    form.activity.data = link_.property.code
    form.description.data = link_.description
    return render_template(
        'display_form.html',
        origin=origin,
        form=form,
        crumbs=[[_(origin.class_.view), url_for('index', view=origin.class_.view)],
                origin,
                event if origin_id != event.id else actor,
                _('edit')])

import ast
from typing import Optional, Union

from flask import flash, render_template, url_for
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


@app.route('/member/insert/<int:origin_id>', methods=['POST', 'GET'])
@app.route('/member/insert/<int:origin_id>/<code>', methods=['POST', 'GET'])
@required_group('contributor')
def member_insert(origin_id: int, code: Optional[str] = 'member') -> Union[str, Response]:
    origin = Entity.get_by_id(origin_id)
    form = build_form('member', code=code)
    form.member_origin_id.data = origin.id
    if form.validate_on_submit():
        Transaction.begin()
        try:
            member_field = getattr(form, 'actor') if code == 'member' else getattr(form, 'group')
            for actor in Entity.get_by_ids(ast.literal_eval(member_field.data)):
                if code == 'membership':
                    link_ = Link.get_by_id(actor.link('P107', origin, form.description.data)[0])
                else:
                    link_ = Link.get_by_id(origin.link('P107', actor, form.description.data)[0])
                link_.set_dates(form)
                link_.type = get_link_type(form)
                link_.update()
            Transaction.commit()
            flash(_('entity created'), 'info')
        except Exception as e:  # pragma: no cover
            Transaction.rollback()
            logger.log('error', 'database', 'transaction failed', e)
            flash(_('error transaction'), 'error')
        if hasattr(form, 'continue_') and form.continue_.data == 'yes':
            return redirect(url_for('member_insert', origin_id=origin_id, code=code))
        tab = '#tab-member' if code == 'member' else '#tab-member-of'
        return redirect(url_for('entity_view', id_=origin.id) + tab)
    return render_template(
        'display_form.html',
        form=form,
        crumbs=[[_('actor'), url_for('index', view='actor')], origin, _('member')])


@app.route('/member/update/<int:id_>/<int:origin_id>', methods=['POST', 'GET'])
@required_group('contributor')
def member_update(id_: int, origin_id: int) -> Union[str, Response]:
    link_ = Link.get_by_id(id_)
    domain = Entity.get_by_id(link_.domain.id)
    range_ = Entity.get_by_id(link_.range.id)
    origin = range_ if origin_id == range_.id else domain
    form = build_form('member', link_)
    if form.validate_on_submit():
        Transaction.begin()
        try:
            link_.delete()
            link_ = Link.get_by_id(domain.link('P107', range_, form.description.data)[0])
            link_.set_dates(form)
            link_.type = get_link_type(form)
            link_.update()
            Transaction.commit()
        except Exception as e:  # pragma: no cover
            Transaction.rollback()
            logger.log('error', 'database', 'transaction failed', e)
            flash(_('error transaction'), 'error')
        tab = '#tab-member-of' if origin.id == range_.id else '#tab-member'
        return redirect(url_for('entity_view', id_=origin.id) + tab)
    form.save.label.text = _('save')
    related = range_ if origin_id == domain.id else domain
    return render_template(
        'display_form.html',
        form=form,
        crumbs=[[_('actor'), url_for('index', view='actor')], origin, related, _('edit')])

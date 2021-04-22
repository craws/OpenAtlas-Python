import datetime
from typing import List, Optional, Union

from flask import flash, g, render_template, url_for
from flask_babel import lazy_gettext as _
from werkzeug.exceptions import abort
from werkzeug.utils import redirect
from werkzeug.wrappers import Response

from openatlas import app, logger
from openatlas.models.entity import Entity
from openatlas.models.gis import Gis
from openatlas.models.reference_system import ReferenceSystem
from openatlas.util.display import (
    button, convert_size, external_url, format_date, get_base_table_data, get_file_path, link)
from openatlas.util.table import Table
from openatlas.util.util import get_file_stats, is_authorized, required_group


@app.route('/index/<view>')
@app.route('/index/<view>/<int:delete_id>')
@required_group('readonly')
def index(view: str, delete_id: Optional[int] = None) -> Union[str, Response]:
    if delete_id:  # To prevent additional redirects deletion is done before showing index
        url = delete_entity(delete_id)
        if url:  # e.g. an error occurred and entry is shown again
            return redirect(url)
    return render_template(
        'entity/index.html',
        class_=view,
        table=get_table(view),
        buttons=get_buttons(view),
        gis_data=Gis.get_all() if view == 'place' else None,
        title=_(view.replace('_', ' ')),
        crumbs=[[_('admin'), url_for('admin_index')], _('file')]
        if view == 'file' else [_(view).replace('_', ' ')])


def get_buttons(view: str) -> List[str]:
    buttons = []
    names = [view] if view in ['artifact', 'place'] else g.view_class_mapping[view]
    for name in names:
        if is_authorized(g.classes[name].write_access):
            buttons.append(button(g.classes[name].label, url_for('insert', class_=name)))
    return buttons


def get_table(view: str) -> Table:
    table = Table(g.table_headers[view])
    if view == 'file':
        table.header = ['date'] + table.header
        file_stats = get_file_stats()
        for entity in Entity.get_by_class('file', nodes=True):
            date = 'N/A'
            if entity.id in file_stats:
                date = format_date(
                    datetime.datetime.utcfromtimestamp(file_stats[entity.id]['date']))
            table.rows.append([
                date,
                link(entity),
                entity.print_standard_type(),
                convert_size(file_stats[entity.id]['size']) if entity.id in file_stats else 'N/A',
                file_stats[entity.id]['ext'] if entity.id in file_stats else 'N/A',
                entity.description])
    elif view == 'reference_system':
        for system in g.reference_systems.values():
            table.rows.append([
                link(system),
                system.count if system.count else '',
                external_url(system.website_url),
                external_url(system.resolver_url),
                system.placeholder,
                link(g.nodes[system.precision_default_id]) if system.precision_default_id else '',
                system.description])
    else:
        classes = ['place'] if view == 'place' else g.view_class_mapping[view]
        entities = Entity.get_by_class(classes, nodes=True, aliases=True)
        table.rows = [get_base_table_data(entity) for entity in entities]
    return table


def delete_entity(id_: int) -> Optional[str]:
    url = None
    entity = Entity.get_by_id(id_)
    if not is_authorized(entity.class_.write_access):
        abort(403)  # pragma: no cover
    if isinstance(entity, ReferenceSystem):
        if entity.system:
            abort(403)
        if entity.forms:
            flash(_('Deletion not possible if forms are attached'), 'error')
            return url_for('entity_view', id_=id_)
    if entity.class_.view in ['artifact', 'place']:
        if entity.get_linked_entities('P46'):
            flash(_('Deletion not possible if subunits exists'), 'error')
            return url_for('entity_view', id_=id_)
        parent = None if entity.class_.name == 'place' else entity.get_linked_entity('P46', True)
        entity.delete()
        logger.log_user(id_, 'delete')
        flash(_('entity deleted'), 'info')
        if parent:
            tab = '#tab-' + entity.class_.name.replace('_', '-')
            url = url_for('entity_view', id_=parent.id) + tab
    else:
        Entity.delete_(id_)
        logger.log_user(id_, 'delete')
        flash(_('entity deleted'), 'info')
        if entity.class_.name == 'file':
            try:
                path = get_file_path(id_)
                if path:  # Only delete file on disk if it exists to prevent a missing file error
                    path.unlink()
            except Exception as e:  # pragma: no cover
                logger.log('error', 'file', 'file deletion failed', e)
                flash(_('error file delete'), 'error')
    return url

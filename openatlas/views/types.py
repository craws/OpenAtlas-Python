from typing import Any, Dict, List, Union

from flask import abort, flash, g, render_template, url_for
from flask_babel import format_number, lazy_gettext as _
from werkzeug.utils import redirect
from werkzeug.wrappers import Response

from openatlas import app
from openatlas.database.connect import Transaction
from openatlas.forms.form import build_move_form
from openatlas.models.entity import Entity
from openatlas.models.node import Node
from openatlas.util.table import Table
from openatlas.util.util import link, required_group, sanitize


def walk_tree(nodes: List[int]) -> List[Dict[str, Any]]:
    items = []
    for id_ in nodes:
        item = g.nodes[id_]
        count_subs = f' ({format_number(item.count_subs)})' if item.count_subs else ''
        items.append({
            'id': item.id,
            'href': url_for('entity_view', id_=item.id),
            'a_attr': {'href': url_for('entity_view', id_=item.id)},
            'text': item.name.replace("'", "&apos;") + ' ' + format_number(item.count) + count_subs,
            'children': walk_tree(item.subs)})
    return items


@app.route('/types')
@required_group('readonly')
def node_index() -> str:
    nodes: Dict[str, Dict[Entity, str]] = {'standard': {}, 'custom': {}, 'places': {}, 'value': {}}
    for id_, node in g.nodes.items():
        if node.root:
            continue
        type_ = 'custom'
        if node.class_.name == 'administrative_unit':
            type_ = 'places'
        elif node.standard:
            type_ = 'standard'
        elif node.value_type:
            type_ = 'value'
        nodes[type_][node] = render_template(
            'forms/tree_select_item.html',
            name=sanitize(node.name),
            data=walk_tree(Node.get_nodes(node.name)))
    return render_template(
        'types/index.html',
        nodes=nodes,
        placeholder=_('type to search'),
        title=_('types'),
        crumbs=[_('types')])


@app.route('/types/delete/<int:id_>', methods=['POST', 'GET'])
@required_group('editor')
def node_delete(id_: int) -> Response:
    node = g.nodes[id_]
    root = g.nodes[node.root[-1]] if node.root else None
    if node.standard or node.subs or node.count or (root and root.locked):
        abort(403)
    node.delete()
    flash(_('entity deleted'), 'info')
    return redirect(url_for('entity_view', id_=root.id) if root else url_for('node_index'))


@app.route('/types/move/<int:id_>', methods=['POST', 'GET'])
@required_group('editor')
def node_move_entities(id_: int) -> Union[str, Response]:
    node = g.nodes[id_]
    root = g.nodes[node.root[-1]]
    if node.class_.name == 'administrative_unit':
        tab_hash = '#menu-tab-places_collapse-'
    elif root.standard:
        tab_hash = '#menu-tab-standard_collapse-'
    elif node.value_type:  # pragma: no cover
        tab_hash = '#menu-tab-value_collapse-'
    else:
        tab_hash = '#menu-tab-custom_collapse-'
    if root.value_type:  # pragma: no cover
        abort(403)
    form = build_move_form(node)
    if form.validate_on_submit():
        Transaction.begin()
        Node.move_entities(node, getattr(form, str(root.id)).data, form.checkbox_values.data)
        Transaction.commit()
        flash(_('Entities were updated'), 'success')
        return redirect(url_for('node_index') + tab_hash + str(root.id))
    getattr(form, str(root.id)).data = node.id
    return render_template(
        'types/move.html',
        node=node,
        root=root,
        form=form,
        title=_('types'),
        crumbs=[[_('types'), url_for('node_index')], root, node, _('move entities')])


@app.route('/types/untyped/<int:id_>')
@required_group('editor')
def show_untyped_entities(id_: int) -> str:
    hierarchy = g.nodes[id_]
    table = Table(['name', 'class', 'first', 'last', 'description'])
    for entity in Node.get_untyped(hierarchy.id):
        table.rows.append([
            link(entity),
            entity.class_.label,
            entity.first,
            entity.last,
            entity.description])
    return render_template(
        'table.html',
        entity=hierarchy,
        table=table,
        crumbs=[[_('types'), url_for('node_index')], link(hierarchy), _('untyped entities')])

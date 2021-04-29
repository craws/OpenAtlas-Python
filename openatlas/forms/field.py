from __future__ import annotations  # Needed for Python 4.0 type annotations

import ast
from typing import Any

from flask import g, render_template
from flask_login import current_user
from wtforms import FloatField, HiddenField
from wtforms.widgets import HiddenInput

from openatlas.models.entity import Entity
from openatlas.models.node import Node
from openatlas.util.table import Table
from openatlas.util.util import get_base_table_data


class TableMultiSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TableField, **kwargs: Any) -> TableMultiSelect:
        if field.data and isinstance(field.data, str):
            field.data = ast.literal_eval(field.data)
        class_ = field.id if field.id != 'given_place' else 'place'
        aliases = current_user.settings['table_show_aliases']
        if class_ in ['group', 'person', 'place']:
            entities = Entity.get_by_class(class_, nodes=True, aliases=aliases)
        else:
            entities = Entity.get_by_view(class_, nodes=True, aliases=aliases)
        table = Table(
            [''] + g.table_headers[class_],
            order=[[0, 'desc'], [1, 'asc']],
            defs=[{'orderDataType': 'dom-checkbox', 'targets': 0}])
        for entity in entities:
            data = get_base_table_data(entity, show_links=False)
            data.insert(0, render_template('forms/checkbox_table.html', entity=entity, field=field))
            table.rows.append(data)
        html = render_template(
            'forms/table_multi_select.html',
            field=field,
            selection=[e.name for e in entities if field.data and e.id in field.data],
            table=table)
        return super(TableMultiSelect, self).__call__(field, **kwargs) + html


class TableMultiField(HiddenField):  # type: ignore
    widget = TableMultiSelect()


class ValueFloatField(FloatField):  # type: ignore
    pass


class TableSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TableField, **kwargs: Any) -> TableSelect:
        aliases = current_user.settings['table_show_aliases']
        if field.id in ['residence', 'begins_in', 'ends_in', 'place_to', 'place_from']:
            class_ = 'place'
            entities = Entity.get_by_class('place', nodes=True, aliases=aliases)
        else:
            class_ = field.id
            entities = Entity.get_by_view(class_, nodes=True, aliases=aliases)
        table = Table(g.table_headers[class_])
        selection = ''
        for entity in entities:
            if field.data and entity.id == int(field.data):
                selection = entity.name
            data = get_base_table_data(entity, show_links=False)
            data[0] = self.format_name_and_aliases(entity, field.id)
            table.rows.append(data)
        html = render_template(
            'forms/table_select.html',
            field=field,
            table=table.display(field.id),
            selection=selection)
        return super(TableSelect, self).__call__(field, **kwargs) + html

    @staticmethod
    def format_name_and_aliases(entity: Entity, field_id: str) -> str:
        link = f"""
            <a href='#' onclick="selectFromTable(this, '{field_id}', {entity.id})">
                {entity.name}
            </a>"""
        if not len(entity.aliases):
            return link
        html = f'<p>{link}</p>'
        for i, alias in enumerate(entity.aliases.values()):
            html += alias if i else f'<p>{alias}</p>'
        return html


class TableField(HiddenField):  # type: ignore
    widget = TableSelect()


class TreeMultiSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TreeField, **kwargs: Any) -> TreeMultiSelect:
        data = []
        if field.data:
            data = ast.literal_eval(field.data) if isinstance(field.data, str) else field.data
        html = render_template(
            'forms/tree_multi_select.html',
            field=field,
            root=g.nodes[int(field.id)],
            selection=sorted([g.nodes[id_].name for id_ in data]) ,
            data=Node.get_tree_data(int(field.id), data))
        return super(TreeMultiSelect, self).__call__(field, **kwargs) + html


class TreeMultiField(HiddenField):  # type: ignore
    widget = TreeMultiSelect()


class TreeSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TreeField, **kwargs: Any) -> TreeSelect:
        from openatlas.models.node import Node
        selection = ''
        selected_ids = []
        if field.data:
            field.data = field.data[0] if isinstance(field.data, list) else field.data
            selection = g.nodes[int(field.data)].name
            selected_ids.append(g.nodes[int(field.data)].id)
        html = render_template(
            'forms/tree_select.html',
            field=field,
            selection=selection,
            data=Node.get_tree_data(int(field.id), selected_ids))
        return super(TreeSelect, self).__call__(field, **kwargs) + html


class TreeField(HiddenField):  # type: ignore
    widget = TreeSelect()

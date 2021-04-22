from __future__ import annotations  # Needed for Python 4.0 type annotations

import ast
import re
from typing import Any

from flask import g, render_template
from flask_login import current_user
from wtforms import FloatField, HiddenField
from wtforms.widgets import HiddenInput

from openatlas.models.entity import Entity
from openatlas.models.node import Node
from openatlas.util.display import get_base_table_data
from openatlas.util.table import Table


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
            data = get_base_table_data(entity)
            for i, item in enumerate(data):  # Remove links
                if isinstance(item, str):
                    data[i] = re.sub(re.compile('<a.*?>'), '', item)
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
        table = Table([''] + g.table_headers[class_])
        selection = ''
        for entity in entities:
            if field.data and entity.id == int(field.data):
                selection = entity.name
            data = get_base_table_data(entity)
            html = """
                <a href="#", onclick="selectFromTable(this, '{field_name}', {id_}, '{name_clean}')">
                    {name}
                </a>
                """.format(
                field_name=field.id,
                id_=entity.id,
                name=entity.name,
                name_clean=entity.name.replace("'", ''))

            # Workaround to show aliases
            data[0] = f'<p>{html}</p>' if len(entity.aliases) > 0 else html
            for i, (id_, alias) in enumerate(entity.aliases.items()):
                if i == len(entity.aliases) - 1:
                    data[0] = ''.join([data[0]] + [alias])
                else:
                    data[0] = ''.join([data[0]] + [f'<p>{alias}</p>'])

            data.insert(0, render_template('forms/select_button.html', entity=entity, field=field))
            table.rows.append(data)
        html = render_template(
            'forms/table_select.html',
            field=field,
            table=table.display(field.id),
            selection=selection)
        return super(TableSelect, self).__call__(field, **kwargs) + html


class TableField(HiddenField):  # type: ignore
    widget = TableSelect()


class TreeMultiSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TreeField, **kwargs: Any) -> TreeMultiSelect:
        selection = []
        selected_ids = []
        root = g.nodes[int(field.id)]
        if field.data:
            field.data = ast.literal_eval(field.data) if isinstance(field.data, str) else field.data
            for entity_id in field.data:
                selected_ids.append(entity_id)
                selection.append(g.nodes[entity_id].name)
        html = render_template(
            'forms/tree_multi_select.html',
            field=field,
            root=root,
            selection=selection,
            data=Node.get_tree_data(int(field.id), selected_ids))
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

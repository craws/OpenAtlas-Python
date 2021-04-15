from __future__ import annotations  # Needed for Python 4.0 type annotations

import ast
import re
from typing import Any

from flask import g, session
from flask_babel import lazy_gettext as _
from flask_login import current_user

from wtforms import FloatField, HiddenField
from wtforms.widgets import HiddenInput

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.node import Node
from openatlas.util.display import get_base_table_data, uc_first
from openatlas.util.table import Table


class TableMultiSelect(HiddenInput):  # type: ignore
    """ Table with checkboxes used in a popup for forms."""

    def __call__(self, field: TableField, **kwargs: Any) -> TableMultiSelect:
        if field.data and isinstance(field.data, str):
            field.data = ast.literal_eval(field.data)
        class_ = field.id if field.id != 'given_place' else 'place'

        # Make checkbox column sortable and show selected on top
        table = Table([''] + g.table_headers[class_], order=[[0, 'desc'], [1, 'asc']])

        # Table definitions (ordering and aligning)
        table.defs = [{'orderDataType': 'dom-checkbox', 'targets': 0}]
        if class_ == 'event':
            table.defs.append({'className': 'dt-body-right', 'targets': [4, 5]})
        elif class_ in ['actor', 'group', 'feature', 'place']:
            table.defs.append({'className': 'dt-body-right', 'targets': [3, 4]})

        if class_ in ['group', 'person', 'place']:
            entities = Entity.get_by_class(
                class_,
                nodes=True,
                aliases=current_user.settings['table_show_aliases'])
        else:
            entities = Entity.get_by_view(class_)

        for entity in entities:
            data = get_base_table_data(entity)
            data[0] = re.sub(re.compile('<a.*?>'), '', data[0])  # Remove links
            data.insert(0, """<input type="checkbox" id="{id}" {checked} value="{name}"
                class="multi-table-select">""".format(
                id=str(entity.id),
                name=entity.name,
                checked='checked = "checked"' if field.data and entity.id in field.data else ''))
            table.rows.append(data)
        selection = [entity.name for entity in entities if field.data and entity.id in field.data]
        html = """
            <span
                id="{name}-button"
                class="{button_class}"
                onclick="$('#{name}-modal').modal('show')">
                    {change_label}
            </span><br>
            <div id="{name}-selection" class="selection" style="text-align:left;">{selection}</div>
            <div
                id="{name}-modal"
                class="modal fade"
                tabindex="-1"
                role="dialog"
                aria-hidden="true">
                <div class="modal-dialog" role="document" style="max-width: 100%!important;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{title}</h5>
                            <button
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal"
                                aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">{table}</div>
                        <div class="modal-footer">
                            <button
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal"
                                onclick="selectFromTableMulti('{name}')">
                                    {close_label}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <script>
            </script>""".format(
            name=field.id,
            button_class=app.config['CSS']['button']['secondary'],
            change_label=uc_first(_('change')),
            close_label=uc_first(_('close')),
            title=uc_first(_(field.id.replace('_', ' '))),
            selection='<br>'.join(selection),
            table=table.display(field.id))
        return super(TableMultiSelect, self).__call__(field, **kwargs) + html


class TableMultiField(HiddenField):  # type: ignore
    widget = TableMultiSelect()


class ValueFloatField(FloatField):  # type: ignore
    pass


class TableSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TableField, **kwargs: Any) -> TableSelect:
        file_stats = None
        place_fields = ['residence', 'begins_in', 'ends_in', 'place_to', 'place_from']
        class_ = 'place' if field.id in place_fields else field.id
        if class_ == 'place':
            entities = Entity.get_by_class(
                'place',
                nodes=True,
                aliases=current_user.settings['table_show_aliases'])
        elif class_ == 'reference':
            entities = Entity.get_by_class('bibliography') + \
                       Entity.get_by_class('edition') + \
                       Entity.get_by_class('external_reference')
        elif class_ == 'file':
            entities = Entity.get_by_class('file')
        else:
            entities = Entity.get_by_view(class_)
        table = Table([''] + g.table_headers[class_])

        selection = ''
        for entity in entities:
            if field.data and entity.id == int(field.data):
                selection = entity.name
            data = get_base_table_data(entity, file_stats)
            if len(entity.aliases) > 0:
                data[0] = """
                    <p>
                        <a onclick="selectFromTable(this, '{name}', {entity_id},
                            '{entity_name_clean}')" href="#">{entity_name}</a>
                    </p>""".format(
                    name=field.id,
                    entity_id=entity.id,
                    entity_name=entity.name,
                    entity_name_clean=entity.name.replace("'", ''))
            else:
                data[0] = """
                    <a onclick="selectFromTable(this, '{name}', {entity_id},
                        '{entity_name_clean}')" href="#">{entity_name}</a>
                    """.format(
                    name=field.id,
                    entity_id=entity.id,
                    entity_name=entity.name,
                    entity_name_clean=entity.name.replace("'", ''))
            for i, (id_, alias) in enumerate(entity.aliases.items()):
                if i == len(entity.aliases) - 1:
                    data[0] = ''.join([data[0]] + [alias])
                else:
                    data[0] = ''.join([data[0]] + ['<p>' + alias + '</p>'])
            data.insert(0, """
                <div style="position: relative; top: 10px;">
                    <div
                        class="btn btn-outline-primary btn-xsm"
                        style="position: absolute; top: -22px;"
                        onclick="selectFromTable(this,'{name}', {entity_id}, '{entity_name_clean}')">
                            {label}
                    </div>
                </div>
                """.format(
                name=field.id,
                entity_id=entity.id,
                entity_name=entity.name,
                entity_name_clean=entity.name.replace("'", ''),
                label=uc_first(_('select'))))
            table.rows.append(data)
        html = """
            <input
                id="{name}-button"
                name="{name}-button"
                class="table-select {required}"
                type="text"
                placeholder="{change_label}"
                onfocus="this.blur()"
                readonly="readonly"
                value="{selection}"
                onclick="$('#{name}-modal').modal('show');">
            <a href="#"
                id="{name}-clear"
                class="{button_class}"
                {clear_style}
                onclick="clearSelect('{name}');">
                    {clear_label}
            </a>
            <div
                id="{name}-modal"
                class="modal fade"
                tabindex="-1"
                role="dialog"
                aria-hidden="true">
                <div class="modal-dialog" role="document" style="max-width: 100%!important;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{title}</h5>
                            <button
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal"
                                aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">{table}</div>
                        <div class="modal-footer">
                            <button
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal">
                                    {close_label}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            """.format(name=field.id,
                       title=uc_first(_(field.id.replace('_', ' '))),
                       button_class=app.config['CSS']['button']['secondary'],
                       change_label=uc_first(_('change')),
                       clear_label=uc_first(_('clear')),
                       close_label=uc_first(_('close')),
                       table=table.display(field.id),
                       selection=selection,
                       clear_style='' if selection else ' style="display: none;" ',
                       required=' required' if field.flags.required else '')
        return super(TableSelect, self).__call__(field, **kwargs) + html


class TableField(HiddenField):  # type: ignore
    widget = TableSelect()


class TreeMultiSelect(HiddenInput):  # type: ignore

    def __call__(self, field: TreeField, **kwargs: Any) -> TreeMultiSelect:
        selection = ''
        selected_ids = []
        root = g.nodes[int(field.id)]
        if field.data:
            field.data = ast.literal_eval(field.data) if isinstance(field.data, str) else field.data
            for entity_id in field.data:
                selected_ids.append(entity_id)
                selection += g.nodes[entity_id].name + '<br>'
        html = """
            <span
                id="{name}-button"
                class="{button_class}"
                onclick="$('#{name}-modal').modal('show')">
                {change_label}
            </span>
            <div
                id="{name}-selection"
                style="text-align:left;">
                {selection}
            </div>
            <div
                id="{name}-modal"
                class="modal fade"
                tabindex="-1"
                role="dialog"
                aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{title}</h5>
                            <button
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal"
                                aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <input
                                class="tree-filter"
                                id="{name}-tree-search"
                                placeholder="{filter}"
                                type="text">
                            <div id="{name}-tree" style="text-align: left!important;"></div>
                        </div>
                        <div class="modal-footer">
                            <button
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal"
                                onclick="selectFromTreeMulti({name})">
                                {close_label}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                $("#{name}-tree").jstree({{
                    "core" : {{ "check_callback": true, "data": {tree_data} }},
                    "search": {{"case_insensitive": true, 
                                "show_only_matches": true, 
                                "show_only_matches_children": true}},
                    "plugins": ["search", "checkbox"],
                    "checkbox": {{"three_state": false}}
                }});
                $("#{name}-tree-search").keyup(function(){{
                    if (this.value.length >= {min_chars}) {{
                        $("#{name}-tree").jstree("search", $(this).val());
                    }}
                    else if (this.value.length == 0) {{
                        $("#{name}-tree").jstree("search", $(this).val());
                        $("#{name}-tree").jstree(true).show_all();
                    }}
                }});
            </script>""".format(filter=uc_first(_('type to search')),
                                min_chars=session['settings']['minimum_jstree_search'],
                                name=field.id,
                                button_class=app.config['CSS']['button']['secondary'],
                                title=uc_first(root.name),
                                selection=selection,
                                change_label=uc_first(_('change')),
                                close_label=uc_first(_('close')),
                                tree_data=Node.get_tree_data(int(field.id), selected_ids))
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
        html = """
            <input
                id="{name}-button"
                name="{name}-button"
                type="text"
                class="table-select {required}"
                onfocus="this.blur()"
                onclick="$('#{name}-modal').modal('show')"
                readonly="readonly"
                value="{selection}"
                placeholder="{change_label}">
            <a 
                href="#" 
                id="{name}-clear" 
                {clear_style} 
                class="{button_class}"
                onclick="clearSelect('{name}');">
                {clear_label}
            </a>
            <div
                id="{name}-modal"
                class="modal fade"
                tabindex="-1"
                role="dialog"
                aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{title}</h5>
                            <button 
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal"
                                aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <input 
                                class="tree-filter"
                                id="{name}-tree-search"
                                placeholder="{filter}"
                                type="text">
                                <div id="{name}-tree" style="text-align: left!important;"></div>
                        </div>
                        <div class="modal-footer">
                            <button 
                                type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal">
                                {close_label}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                $(document).ready(function () {{
                    $("#{name}-tree").jstree({{
                        "core" : {{"check_callback": true, "data": {tree_data}}},
                        "search": {{"case_insensitive": true, 
                                    "show_only_matches": true, 
                                    "show_only_matches_children": true}},
                        "plugins" : ["search"],
                    }});
                    $("#{name}-tree").on("select_node.jstree", function (e, data) {{
                        selectFromTree("{name}", data.node.id, data.node.text);
                    }});
                    $("#{name}-tree-search").keyup(function() {{
                        if (this.value.length >= {min_chars}) {{
                            $("#{name}-tree").jstree("search", $(this).val());
                        }}
                        else if (this.value.length == 0) {{
                            $("#{name}-tree").jstree("search", $(this).val());
                            $("#{name}-tree").jstree(true).show_all();
                        }}
                    }});
                }});
            </script>""".format(filter=uc_first(_('type to search')),
                                min_chars=session['settings']['minimum_jstree_search'],
                                name=field.id,
                                button_class=app.config['CSS']['button']['secondary'],
                                title=uc_first(g.nodes[int(field.id)].name),
                                change_label=uc_first(_('change')),
                                clear_label=uc_first(_('clear')),
                                close_label=uc_first(_('close')),
                                selection=selection,
                                tree_data=Node.get_tree_data(int(field.id), selected_ids),
                                clear_style='' if selection else ' style="display: none;" ',
                                required=' required' if field.flags.required else '')
        return super(TreeSelect, self).__call__(field, **kwargs) + html


class TreeField(HiddenField):  # type: ignore
    widget = TreeSelect()

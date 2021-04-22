import pathlib
import re
from typing import Any, Dict, List, Optional, Union

import flask
from flask import g, request, session, url_for
from flask_babel import lazy_gettext as _
from jinja2 import escape
from markupsafe import Markup
from wtforms import Field, IntegerField
from wtforms.validators import Email

from openatlas import app
from openatlas.models.content import Content
from openatlas.models.entity import Entity
from openatlas.models.imports import Project
from openatlas.models.model import CidocClass, CidocProperty
from openatlas.models.node import Node
from openatlas.models.user import User
from openatlas.util import display, tab, util
from openatlas.util.table import Table

blueprint: flask.Blueprint = flask.Blueprint('filters', __name__)
paragraph_re = re.compile(r'(?:\r\n|\r|\n){2,}')


@app.template_filter()
def link(entity: Entity) -> str:
    return display.link(entity)


@app.template_filter()
def button(
        label: str,
        url: Optional[str] = '#',
        css: Optional[str] = 'primary',
        id_: Optional[str] = None,
        onclick: Optional[str] = '') -> str:
    return display.button(label, url, css, id_, onclick)


@app.template_filter()
def display_citation_example(code: str) -> str:
    text = Content.get_translation('citation_example')
    if not text or code != 'reference':
        return ''
    return Markup(f'<h1>{display.uc_first(_("citation_example"))}</h1>{text}')


@app.template_filter()
def siblings_pager(entity: Entity, structure: Optional[Dict[str, Any]]) -> str:
    if not structure or len(structure['siblings']) < 2:
        return ''
    structure['siblings'].sort(key=lambda x: x.id)
    prev_id = None
    next_id = None
    position = None
    for counter, sibling in enumerate(structure['siblings']):
        position = counter + 1
        prev_id = sibling.id if sibling.id < entity.id else prev_id
        if sibling.id > entity.id:
            next_id = sibling.id
            position = counter
            break
    return Markup(
        '{previous} {next} {position} {of_label} {count}'.format(
            previous=display.button('<', url_for('entity_view', id_=prev_id)) if prev_id else '',
            next=display.button('>', url_for('entity_view', id_=next_id)) if next_id else '',
            position=position,
            of_label=_('of'),
            count=len(structure['siblings'])))


@app.template_filter()
def breadcrumb(crumbs: List[Any]) -> str:
    items = []
    for item in crumbs:
        if not item:
            continue  # Item can be None e.g. if a dynamic generated URL has no origin parameter
        elif isinstance(item, Entity) or isinstance(item, Project) or isinstance(item, User):
            items.append(display.link(item))
        elif isinstance(item, list):
            items.append(f'<a href="{item[1]}">{display.uc_first(str(item[0]))}</a>')
        else:
            items.append(display.uc_first(item))
    return Markup('&nbsp;>&nbsp; '.join(items))


@app.template_filter()
def is_authorized(group: str) -> bool:
    return util.is_authorized(group)


@app.template_filter()
def tab_header(item: str, table: Optional[Table] = None, active: Optional[bool] = False) -> str:
    return Markup(tab.tab_header(item, table, active))


@app.template_filter()
def uc_first(string: str) -> str:
    return display.uc_first(string)


@app.template_filter()
def display_info(data: Dict[str, Union[str, List[str]]]) -> str:
    html = '<div class="data-table">'
    for label, value in data.items():
        if value or value == 0:
            if isinstance(value, list):
                value = '<br>'.join(value)
            html += f"""
                <div class="table-row">
                    <div>{display.uc_first(label)}</div>
                    <div class="table-cell">{value}</div>
                </div>"""
    return Markup(html + '</div>')


@app.template_filter()
def bookmark_toggle(entity_id: int) -> str:
    return Markup(display.bookmark_toggle(entity_id))


@app.template_filter()
def display_move_form(form: Any, root_name: str) -> str:
    from openatlas.forms.field import TreeField
    html = ''
    for field in form:
        if isinstance(field, TreeField):
            html += '<p>' + root_name + ' ' + str(field) + '</p>'
    table = Table(
        header=['#', display.uc_first(_('selection'))],
        rows=[[item, item.label.text] for item in form.selection])
    return html + f"""
        <div class="toolbar">
            {display.button(_('select all'), id_='select-all')}
            {display.button(_('deselect all'), id_='select-none')}
        </div>
        {table.display('move')}"""


@app.template_filter()
def table_select_model(name: str, selected: Union[CidocClass, CidocProperty, None] = None) -> str:
    if name in ['domain', 'range']:
        entities = g.cidoc_classes
    else:
        entities = g.properties
    table = Table(['code', 'name'], defs=[
        {'orderDataType': 'cidoc-model', 'targets': [0]},
        {'sType': 'numeric', 'targets': [0]}])

    for id_ in entities:
        table.rows.append([
            """
                <a onclick="selectFromTable(this, '{name}', '{entity_id}', '{value}')"
                    href="#">{label}</a>""".format(
                name=name,
                entity_id=id_,
                value=entities[id_].code + ' ' + entities[id_].name,
                label=entities[id_].code),
            """
                <a onclick="selectFromTable(this, '{name}', '{entity_id}', '{value}')"
                    href="#">{label}</a>""".format(
                name=name,
                entity_id=id_,
                value=entities[id_].code + ' ' + entities[id_].name,
                label=entities[id_].name)])
    value = selected.code + ' ' + selected.name if selected else ''
    html = """
        <input id="{name}-button" name="{name}-button" class="table-select" type="text"
            onfocus="this.blur()" readonly="readonly" value="{value}"
            onclick="$('#{name}-modal').modal('show')">
            <div id="{name}-modal" class="modal fade" tabindex="-1" role="dialog"
                aria-hidden="true">
                <div class="modal-dialog" role="document" style="max-width: 100%!important;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{name}</h5>
                            <button type="button" class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">{table}</div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-primary btn-sm"
                                data-dismiss="modal">{close_label}</button>
                        </div>
                    </div>
                </div>
            </div>""".format(
        name=name,
        value=value,
        close_label=display.uc_first(_('close')),
        table=table.display(name))
    return html


@app.template_filter()
def description(entity: Union[Entity, Project]) -> str:
    if not entity.description:
        return ''
    label = _('description')
    if isinstance(entity, Entity) and entity.class_.name == 'source':
        label = _('content')
    return Markup("""
        <h2>{label}</h2>
        <div class="description more">{description}</div>""".format(
        label=display.uc_first(label),
        description=entity.description.replace('\r\n', '<br>')))


@app.template_filter()
def download_button(entity: Entity) -> str:
    if entity.class_.view != 'file':
        return ''
    html = f'<span class="error">{display.uc_first(_("missing file"))}</span>'
    if entity.image_id:
        path = display.get_file_path(entity.image_id)
        html = display.button(_('download'), url_for('download_file', filename=path.name))
    return Markup(html)


@app.template_filter()
def display_profile_image(entity: Entity) -> str:
    if not entity.image_id:
        return ''
    path = display.get_file_path(entity.image_id)
    if not path:
        return ''  # pragma: no cover
    if entity.class_.view == 'file':
        if path.suffix.lower() in app.config['DISPLAY_FILE_EXTENSIONS']:
            html = """
                <a href="{url}" rel="noopener noreferrer" target="_blank">
                    <img style="max-width:{width}px;" alt="image" src="{url}">
                </a>""".format(
                url=url_for('display_file', filename=path.name),
                width=session['settings']['profile_image_width'])
        else:
            html = display.uc_first(_('no preview available'))  # pragma: no cover
    else:
        html = """
            <a href="{url}">
                <img style="max-width:{width}px;" alt="image" src="{src}">
            </a>""".format(
            url=url_for('entity_view', id_=entity.image_id),
            src=url_for('display_file', filename=path.name),
            width=session['settings']['profile_image_width'])
    return Markup(f'<div id="profile_image_div">{html}</div>')


@app.template_filter()
def display_content_translation(text: str) -> str:
    from openatlas.models.content import Content
    return Content.get_translation(text)


@app.template_filter()
def manual(site: str) -> str:  # Creates a link to a manual page
    parts = site.split('/')
    if len(parts) < 2:
        return ''
    first = parts[0]
    second = (parts[1] if parts[1] != 'node' else 'type') + '.html'
    path = pathlib.Path(app.root_path) / 'static' / 'manual' / first / second
    if not path.exists():
        # print('Missing manual link: ' + str(path))
        return ''
    return Markup(f"""
        <a
            class="manual"
            href="/static/manual/{site}.html"
            target="_blank"
            title="{display.uc_first('manual')}">
                <i class="fas fa-book"></i>
        </a>""")


def add_row(
        field: Field,
        label: Optional[str] = None,
        value: Optional[str] = None,
        form_id: Optional[str] = None,
        row_css_class: Optional[str] = '') -> str:
    field.label.text = display.uc_first(field.label.text)
    if field.flags.required and form_id != 'login-form' and field.label.text:
        field.label.text += ' *'

    # CSS
    css_class = 'required' if field.flags.required else ''
    css_class += ' integer' if isinstance(field, IntegerField) else ''
    for validator in field.validators:
        css_class += ' email' if isinstance(validator, Email) else ''
    errors = ' <span class="error">{errors}</span>'.format(
        errors=' '.join(display.uc_first(error) for error in field.errors)) if field.errors else ''
    return """
        <div class="table-row {css_row}">
            <div>{label} {tooltip}</div>
            <div class="table-cell">{value} {errors}</div>
        </div>""".format(
        label=label if isinstance(label, str) else field.label,
        tooltip=display.tooltip(field.description),
        value=value if value else field(class_=css_class).replace('> ', '>'),
        css_row=row_css_class,
        errors=errors)


@app.template_filter()
def display_form(
        form: Any,
        form_id: Optional[str] = None,
        for_persons: bool = False,
        manual_page: Optional[str] = None) -> str:
    from openatlas.forms.field import ValueFloatField

    def display_value_type_fields(node_: Node, root: Optional[Node] = None) -> str:
        root = root if root else node_
        html_ = ''
        for sub_id in node_.subs:
            sub = g.nodes[sub_id]
            field_ = getattr(form, str(sub_id))
            html_ += f"""
                <div class="table-row value-type-switch{root.id}">
                    <div>{sub.name}</div>
                    <div class="table-cell">{field_(class_='value-type')} {sub.description}</div>
                </div>
                {display_value_type_fields(sub, root)}"""
        return html_

    reference_systems_added = False
    html = ''
    for field in form:
        if isinstance(field, ValueFloatField) or field.id.startswith(
                ('insert_', 'reference_system_precision')):
            continue  # These fields will be added in combination with other fields
        if field.type in ['CSRFTokenField', 'HiddenField']:
            html += str(field)
            continue
        if field.id.split('_', 1)[0] in ('begin', 'end'):  # If it's a date field use a function
            if field.id == 'begin_year_from':
                html += display.add_dates_to_form(form, for_persons)
            continue

        if field.type in ['TreeField', 'TreeMultiField']:
            hierarchy_id = int(field.id)
            node = g.nodes[hierarchy_id]
            label = node.name
            if node.standard and node.class_.name == 'type':
                label = display.uc_first(_('type'))
            if field.label.text == 'super':
                label = display.uc_first(_('super'))
            if node.value_type and 'is_node_form' not in form:
                field.description = node.description
                onclick = f'switch_value_type({node.id})'
                html += add_row(
                    field,
                    label,
                    display.button(_('show'), onclick=onclick, css='secondary'))
                html += display_value_type_fields(node)
                continue
            tooltip = '' if 'is_node_form' in form else ' ' + display.tooltip(node.description)
            html += add_row(field, label + tooltip)
            continue

        if field.id == 'save':
            field.label.text = display.uc_first(field.label.text)
            class_ = app.config['CSS']['button']['primary']
            buttons = []
            if manual_page:
                buttons.append(escape(manual(manual_page)))
            buttons.append(field(class_=class_))
            if 'insert_and_continue' in form:
                buttons.append(form.insert_and_continue(class_=class_))
            if 'insert_continue_sub' in form:
                buttons.append(form.insert_continue_sub(class_=class_))
            if 'insert_continue_human_remains' in form:
                buttons.append(form.insert_continue_human_remains(class_=class_))
            html += add_row(field, '', f'<div class ="toolbar">{" ".join(buttons)}</div>')
            continue

        if field.id.startswith('reference_system_id_'):
            if not reference_systems_added:
                html += display.add_reference_systems_to_form(form)
                reference_systems_added = True
            continue
        html += add_row(field, form_id=form_id)

    return Markup("""
        <form method="post" {id} {multi}>
            <div class="data-table">{html}</div>
        </form>""".format(
        id=('id="' + form_id + '" ') if form_id else '',
        html=html,
        multi='enctype="multipart/form-data"' if hasattr(form, 'file') else ''))


@app.template_filter()
def test_file(file_name: str) -> Optional[str]:
    return file_name if (pathlib.Path(app.root_path) / file_name).is_file() else None


@app.template_filter()
def sanitize(string: str) -> str:
    return display.sanitize(string)


@app.template_filter()
def display_menu(entity: Optional[Entity], origin: Optional[Entity]) -> str:
    view_name = ''
    if entity:
        view_name = entity.class_.view
    if origin:
        view_name = origin.class_.view
    html = ''
    for item in ['source', 'event', 'actor', 'place', 'artifact', 'reference']:
        active = ''
        request_parts = request.path.split('/')
        if (view_name == item) or request.path.startswith('/index/' + item):
            active = 'active'
        elif len(request_parts) > 2 and request.path.startswith('/insert/'):
            name = request_parts[2]
            if name in g.class_view_mapping and g.class_view_mapping[name] == item:
                active = 'active'
        html += '<a href="/index/{item}" class="nav-item nav-link {active}">{label}</a>'.format(
            active=active,
            item=item,
            label=display.uc_first(_(item)))
    active = ''
    if request.path.startswith('/types') \
            or request.path.startswith('/insert/type') \
            or (entity and entity.class_.view == 'type'):
        active = 'active'
    html += '<a href="{url}" class="nav-item nav-link {active}">{label}</a>'.format(
        active=active,
        url=url_for('node_index'),
        label=display.uc_first(_('types')))
    return Markup(html)


@app.template_filter()
def display_external_references(entity: Entity) -> str:
    system_links = []
    for link_ in entity.reference_systems:
        system = g.reference_systems[link_.domain.id]
        name = link_.description
        if system.resolver_url:
            name = '<a href="{url}" target="_blank" rel="noopener noreferrer">{name}</a>'.format(
                url=system.resolver_url + name,
                name=name)
        system_links.append('''{name} ({match} {at} {system_name})'''.format(
            name=name,
            match=g.nodes[link_.type.id].name,
            at=_('at'),
            system_name=display.link(link_.domain)))
    html = '<br>'.join(system_links)
    if not html:
        return ''
    return Markup(f'<h2>{display.uc_first(_("external reference systems"))}</h2>{html}')

from __future__ import annotations  # Needed for Python 4.0 type annotations

import math
import os
import re
from collections import OrderedDict
from datetime import datetime, timedelta
from html.parser import HTMLParser
from pathlib import Path
from typing import Any, Dict, List, Optional, TYPE_CHECKING, Tuple, Union

import numpy
from flask import g, session, url_for
from flask_babel import LazyString, format_number, lazy_gettext as _
from flask_login import current_user
from markupsafe import Markup

import openatlas
from openatlas import app
from openatlas.models.date import Date
from openatlas.models.model import CidocClass, CidocProperty
from openatlas.util.util import is_authorized

if TYPE_CHECKING:  # pragma: no cover - Type checking is disabled in tests
    from openatlas.models.entity import Entity
    from openatlas.models.node import Node
    from openatlas.models.imports import Project
    from openatlas.models.link import Link
    from openatlas.models.user import User
    from openatlas.models.reference_system import ReferenceSystem


def external_url(url: Union[str, None]) -> str:
    return f'<a target="blank_" rel="noopener noreferrer" href="{url}">{url}</a>' if url else ''


def walk_tree(nodes: List[int]) -> List[Dict[str, Any]]:
    items = []
    for id_ in nodes:
        item = g.nodes[id_]
        count_subs = ' (' + format_number(item.count_subs) + ')' if item.count_subs else ''
        items.append({
            'id': item.id,
            'href': url_for('entity_view', id_=item.id),
            'a_attr': {'href': url_for('entity_view', id_=item.id)},
            'text': item.name.replace("'", "&apos;") + ' ' + format_number(item.count) + count_subs,
            'children': walk_tree(item.subs)})
    return items


def tree_select(name: str) -> str:
    from openatlas.models.node import Node
    return """
        <div id="{name}-tree"></div>
        <script>
            $(document).ready(function () {{
                $("#{name}-tree").jstree({{
                    "search": {{ "case_insensitive": true, "show_only_matches": true }},
                    "plugins" : ["core", "html_data", "search"],
                    "core": {{ "data": {tree_data} }}
                }});
                $("#{name}-tree").on("select_node.jstree", function (e, data) {{
                    document.location.href = data.node.original.href;
                }});
                $("#{name}-tree-search").keyup(function() {{
                    if (this.value.length >= {min_chars}) {{
                        $("#{name}-tree").jstree("search", $(this).val());
                    }}
                }});
            }});
        </script>""".format(
        min_chars=session['settings']['minimum_jstree_search'],
        name=sanitize(name),
        tree_data=walk_tree(Node.get_nodes(name)))


def link(object_: Union[str, 'Entity', CidocClass, CidocProperty, 'Project', 'User', None],
         url: Optional[str] = None,
         class_: Optional[str] = None,
         uc_first_: Optional[bool] = True,
         js: Optional[str] = None) -> str:
    if isinstance(object_, (str, LazyString)):
        return '<a href="{url}" {class_} {js}>{label}</a>'.format(
            url=url,
            class_='class="' + class_ + '"' if class_ else '',
            js='onclick="{js}"'.format(js=js) if js else '',
            label=(uc_first(str(object_))) if uc_first_ else object_)

    # Builds an HTML link to a detail view of an object
    from openatlas.models.entity import Entity
    from openatlas.models.imports import Project
    from openatlas.models.user import User
    if isinstance(object_, Project):
        return link(object_.name, url_for('import_project_view', id_=object_.id))
    if isinstance(object_, User):
        return link(
            object_.username,
            url_for('user_view', id_=object_.id),
            class_='' if object_.active else 'inactive',
            uc_first_=False)
    if isinstance(object_, CidocClass):
        return link(object_.code, url_for('class_view', code=object_.code))
    if isinstance(object_, CidocProperty):
        return link(object_.code, url_for('property_view', code=object_.code))
    if isinstance(object_, Entity):
        return link(object_.name, url_for('entity_view', id_=object_.id), uc_first_=False)
    return ''


def display_delete_link(entity: Entity) -> str:
    if entity.class_.name == 'source_translation':
        url = url_for('translation_delete', id_=entity.id)
    elif entity.id in g.nodes:
        url = url_for('node_delete', id_=entity.id)
    else:
        url = url_for('index', view=entity.class_.view, delete_id=entity.id)
    confirm = _('Delete %(name)s?', name=entity.name.replace('\'', ''))
    return button(_('delete'), url, onclick=f"return confirm('{confirm}')")


def add_remove_link(data: List[Any], name: str, link_: Link, origin: Entity, tab: str) -> List[Any]:
    if is_authorized('contributor'):
        data.append(link(
            _('remove'),
            url_for('link_delete', id_=link_.id, origin_id=origin.id) + '#tab-' + tab,
            js="return confirm('{x}')".format(x=_('Remove %(name)s?', name=name.replace("'", '')))))
    return data


def add_edit_link(data: List[Any], url: str) -> List[Any]:
    if is_authorized('contributor'):
        data.append(link(_('edit'), url))
    return data


def delete_link(name: str, url: str) -> str:
    return link(
        _('delete'),
        url=url,
        js="return confirm('{x}')".format(x=_('Delete %(name)s?', name=name.replace("'", ''))))


def uc_first(string: Optional[str] = '') -> str:
    return str(string)[0].upper() + str(string)[1:] if string else ''


def add_reference_systems_to_form(form: Any) -> str:
    from openatlas.util.filters import add_row
    fields = []
    for field in form:
        if field.id.startswith('reference_system_id_'):
            fields.append(field)
    html = ''
    switch_class = ''
    if len(fields) > 3:  # pragma: no cover
        switch_class = 'reference-systems-switch'
        html = f"""
            <div class="table-row">
                <div>
                    <label>{uc_first(_('reference systems'))}</label>
                </div>
                <div class="table-cell reference-systems-switcher">
                    <span
                        id="reference-systems-switcher"
                        class="{app.config['CSS']['button']['secondary']}">
                            {uc_first(_('show'))}
                    </span>
                </div>
            </div>"""
    for field in fields:
        precision_field = getattr(form, field.id.replace('id_', 'precision_'))
        class_ = field.label.text if field.label.text in ['GeoNames', 'Wikidata'] else ''
        html += add_row(
            field,
            field.label,
            ' '.join([
                str(field(class_=class_)),
                str(precision_field.label),
                str(precision_field)]),
            row_css_class='external-reference ' + switch_class)
    return html


def add_dates_to_form(form: Any, for_person: bool = False) -> str:
    errors = {}
    valid_dates = True
    for field_name in [
            'begin_year_from', 'begin_month_from', 'begin_day_from',
            'begin_year_to', 'begin_month_to', 'begin_day_to',
            'end_year_from', 'end_month_from', 'end_day_from',
            'end_year_to', 'end_month_to', 'end_day_to']:
        errors[field_name] = ''
        if getattr(form, field_name).errors:
            valid_dates = False
            errors[field_name] = '<label class="error">'
            for error in getattr(form, field_name).errors:
                errors[field_name] += uc_first(error)
            errors[field_name] += ' </label>'
    html = """
        <div class="table-row">
            <div>
                <label>{date}</label> {tooltip}
            </div>
            <div class="table-cell date-switcher">
                <span id="date-switcher" class="{button_class}">{show}</span>
            </div>
        </div>""".format(
        date=uc_first(_('date')),
        button_class=app.config['CSS']['button']['secondary'],
        tooltip=tooltip(_('tooltip date')),
        show=uc_first(
            _('hide') if form.begin_year_from.data or form.end_year_from.data else _('show')))

    style = '' if valid_dates else ' style="display:table-row" '
    html += '<div class="table-row date-switch" ' + style + '>'
    html += '<div>' + uc_first(_('birth') if for_person else _('begin')) + '</div>'
    html += '<div class="table-cell">'
    html += str(form.begin_year_from(class_='year')) + ' ' + errors['begin_year_from'] + ' '
    html += str(form.begin_month_from(class_='month')) + ' ' + errors['begin_month_from'] + ' '
    html += str(form.begin_day_from(class_='day')) + ' ' + errors['begin_day_from'] + ' '
    html += str(form.begin_comment)
    html += '</div></div>'
    html += '<div class="table-row date-switch" ' + style + '>'
    html += '<div></div><div class="table-cell">'
    html += str(form.begin_year_to(class_='year')) + ' ' + errors['begin_year_to'] + ' '
    html += str(form.begin_month_to(class_='month')) + ' ' + errors['begin_month_to'] + ' '
    html += str(form.begin_day_to(class_='day')) + ' ' + errors['begin_day_to'] + ' '
    html += '</div></div>'
    html += '<div class="table-row date-switch" ' + style + '>'
    html += '<div>' + uc_first(_('death') if for_person else _('end')) + '</div>'
    html += '<div class="table-cell">'
    html += str(form.end_year_from(class_='year')) + ' ' + errors['end_year_from'] + ' '
    html += str(form.end_month_from(class_='month')) + ' ' + errors['end_month_from'] + ' '
    html += str(form.end_day_from(class_='day')) + ' ' + errors['end_day_from'] + ' '
    html += str(form.end_comment)
    html += '</div></div>'
    html += '<div class="table-row date-switch"' + style + '>'
    html += '<div></div><div class="table-cell">'
    html += str(form.end_year_to(class_='year')) + ' ' + errors['end_year_to'] + ' '
    html += str(form.end_month_to(class_='month')) + ' ' + errors['end_month_to'] + ' '
    html += str(form.end_day_to(class_='day')) + ' ' + errors['end_day_to'] + ' '
    html += '</div></div>'
    return html


def add_system_data(entity: 'Entity', data: Dict[str, Any]) -> Dict[str, Any]:
    # Add additional information for entity views (if activated in profile)
    if not hasattr(current_user, 'settings'):
        return data  # pragma: no cover
    info = openatlas.logger.get_log_for_advanced_view(entity.id)
    if 'entity_show_class' in current_user.settings and current_user.settings['entity_show_class']:
        data[_('class')] = link(entity.cidoc_class)
    if 'entity_show_dates' in current_user.settings and current_user.settings['entity_show_dates']:
        data[_('created')] = format_date(entity.created) + ' ' + link(info['creator'])
        if info['modified']:
            html = format_date(info['modified']) + ' ' + link(info['modifier'])
            data[_('modified')] = html
    if 'entity_show_import' in current_user.settings:
        if current_user.settings['entity_show_import']:
            data[_('imported from')] = link(info['project'])
            data[_('imported by')] = link(info['importer'])
            data['origin ID'] = info['origin_id']
    if 'entity_show_api' in current_user.settings and current_user.settings['entity_show_api']:
        data_api = f'<a href="{url_for("entity", id_=entity.id)}" target="_blank">GeoJSON</a>'
        data_api += '''
            <a class="btn btn-outline-primary btn-sm" href="{url}" target="_blank" title="Download">
                <i class="fas fa-download"></i> {label}
            </a>'''.format(
            url=url_for('entity', id_=entity.id, download=True),
            label=uc_first('download'))
        data_api += '''
            <a class="btn btn-outline-primary btn-sm" href="{url}" target="_blank" title="CSV">
                <i class="fas fa-download"></i> {label}
            </a>'''.format(
            url=url_for('entity', id_=entity.id, export='csv'),
            label=uc_first('csv'))
        data['API'] = data_api
    return data


def add_type_data(entity: 'Entity', data: Dict[str, Any]) -> Dict[str, Any]:
    if entity.location:
        entity.nodes.update(entity.location.nodes)  # Add location types
    type_data: OrderedDict[str, Any] = OrderedDict()
    for node, node_value in entity.nodes.items():
        root = g.nodes[node.root[-1]]
        label = 'type' if root.standard and root.class_.name == 'type' else root.name
        if root.name not in type_data:
            type_data[label] = []
        text = ''
        if root.value_type:  # Text for value types
            text = ': {value} <span style="font-style:italic;">{description}</span>'.format(
                value=format_number(node_value), description=node.description)
        type_data[label].append('<span title="{path}">{link}</span>{text}'.format(
            link=link(node),
            path=' > '.join([g.nodes[id_].name for id_ in node.root]),
            text=text))

    # Sort types by name
    for root_type in type_data:
        type_data[root_type].sort()

    # Move the standard type to the top
    if 'type' in type_data:
        type_data.move_to_end('type', last=False)
    for root_name, nodes in type_data.items():
        data[root_name] = nodes
    return data


def bookmark_toggle(entity_id: int, for_table: bool = False) -> str:
    label = uc_first(_('bookmark remove') if entity_id in current_user.bookmarks else _('bookmark'))
    onclick = f"ajaxBookmark('{entity_id}');"
    if for_table:
        return f'<a href="#" id="bookmark{entity_id}" onclick="{onclick}">{label}</a>'
    return button(label, id_=f'bookmark{entity_id}', onclick=onclick)


def button(
        label: str,
        url: Optional[str] = None,
        css: Optional[str] = 'primary',
        id_: Optional[str] = None,
        onclick: Optional[str] = '') -> str:
    label = uc_first(label)
    if url and '/insert' in url and label != uc_first(_('link')):
        label = '+ ' + label
    html = '<{tag} class="{class_}" {url} {id} {onclick}>{label}</{tag}>'.format(
        tag='a' if url else 'span',
        class_=app.config['CSS']['button'][css],
        url='href="{url}"'.format(url=url) if url else '',
        label=label,
        id='id="' + id_ + '"' if id_ else '',
        onclick='onclick="{onclick}"'.format(onclick=onclick) if onclick else '')
    return Markup(html)


def tooltip(text: str) -> str:
    if not text:
        return ''
    return '<span><i class="fas fa-info-circle tooltipicon" title="{title}"></i></span>'.format(
        title=text.replace('"', "'"))


def get_entity_data(entity: 'Entity', event_links: Optional[List[Link]] = None) -> Dict[str, Any]:

    data: Dict[str, Union[str, List[str], None]] = {_('alias'): list(entity.aliases.values())}

    # Dates
    from_link = ''
    to_link = ''
    if entity.class_.name == 'move':  # Add places to dates if it's a move
        place_from = entity.get_linked_entity('P27')
        if place_from:
            from_link = link(place_from.get_linked_entity_safe('P53', True)) + ' '
        place_to = entity.get_linked_entity('P26')
        if place_to:
            to_link = link(place_to.get_linked_entity_safe('P53', True)) + ' '
    data[_('begin')] = (from_link if from_link else '') + format_entry_begin(entity)
    data[_('end')] = (to_link if to_link else '') + format_entry_end(entity)

    add_type_data(entity, data)

    # Class specific information
    from openatlas.models.node import Node
    from openatlas.models.reference_system import ReferenceSystem
    if isinstance(entity, Node):
        data[_('super')] = link(g.nodes[entity.root[0]])
        if g.nodes[entity.root[0]].value_type:
            data[_('unit')] = entity.description
        data[_('ID for imports')] = entity.id
    elif isinstance(entity, ReferenceSystem):
        data[_('website URL')] = external_url(entity.website_url)
        data[_('resolver URL')] = external_url(entity.resolver_url)
        data[_('example ID')] = entity.placeholder
    elif entity.class_.view == 'actor':
        begin_place = entity.get_linked_entity('OA8')
        begin_object = None
        if begin_place:
            begin_object = begin_place.get_linked_entity_safe('P53', True)
            entity.linked_places.append(begin_object)
        end_place = entity.get_linked_entity('OA9')
        end_object = None
        if end_place:
            end_object = end_place.get_linked_entity_safe('P53', True)
            entity.linked_places.append(end_object)
        residence_place = entity.get_linked_entity('P74')
        residence_object = None
        if residence_place:
            residence_object = residence_place.get_linked_entity_safe('P53', True)
            entity.linked_places.append(residence_object)
        data[_('alias')] = list(entity.aliases.values())
        data[_('born') if entity.class_.name == 'person' else _('begin')] = format_entry_begin(
            entity,
            begin_object)
        data[_('died') if entity.class_.name == 'person' else _('end')] = format_entry_end(
            entity,
            end_object)
        if event_links:
            appears_first, appears_last = get_appearance(event_links)
            data[_('appears first')] = appears_first
            data[_('appears last')] = appears_last
        data[_('residence')] = link(residence_object) if residence_object else ''
    elif entity.class_.view == 'artifact':
        data[_('source')] = [link(source) for source in entity.get_linked_entities(['P128'])]
    elif entity.class_.view == 'event':
        super_event = entity.get_linked_entity('P117')
        if super_event:
            data[_('sub event of')] = link(super_event)
        if entity.class_.name == 'move':
            person_data = []
            artifact_data = []
            for linked_entity in entity.get_linked_entities(['P25']):
                if linked_entity.class_.name == 'person':
                    person_data.append(linked_entity)
                elif linked_entity.class_.view == 'artifact':
                    artifact_data.append(linked_entity)
            data[_('person')] = [link(item) for item in person_data]
            data[_('artifact')] = [link(item) for item in artifact_data]
        else:
            place = entity.get_linked_entity('P7')
            if place:
                data[_('location')] = link(place.get_linked_entity_safe('P53', True))

        if entity.class_.name == 'acquisition':
            data[_('recipient')] = [
                link(recipient) for recipient in entity.get_linked_entities(['P22'])]
            data[_('donor')] = [link(donor) for donor in entity.get_linked_entities(['P23'])]
            data[_('given place')] = [link(place) for place in entity.get_linked_entities(['P24'])]
    elif entity.class_.view == 'file':
        data[_('size')] = print_file_size(entity)
        data[_('extension')] = get_file_extension(entity)
    elif entity.class_.view == 'source':
        data[_('artifact')] = [
            link(artifact) for artifact in entity.get_linked_entities(['P128'], inverse=True)]
    return add_system_data(entity, data)


def get_profile_image_table_link(
        file: 'Entity',
        entity: 'Entity',
        extension: str,
        profile_image_id: Optional[int] = None) -> str:
    if file.id == profile_image_id:
        return link(_('unset'), url_for('file_remove_profile_image', entity_id=entity.id))
    elif extension in app.config['DISPLAY_FILE_EXTENSIONS']:
        return link(_('set'), url_for('set_profile_image', id_=file.id, origin_id=entity.id))
    return ''  # pragma: no cover - only happens for non image files


def get_base_table_data(
        entity: 'Entity',
        file_stats: Optional[Dict[Union[int, str], Any]] = None) -> List[Any]:
    data = [link(entity)]
    if current_user.settings['table_show_aliases'] and len(entity.aliases) > 0:
        data = [f'<p>{link(entity)}</p>']
        for i, (id_, alias) in enumerate(entity.aliases.items()):
            if i == len(entity.aliases) - 1:
                data[0] = ''.join([data[0]] + [alias])
            else:
                data[0] = ''.join([data[0]] + [f'<p>{alias}</p>'])
    if entity.class_.view in ['actor', 'artifact', 'event', 'reference'] or \
            entity.class_.name == 'find':
        data.append(entity.class_.label)
    if entity.class_.view in ['artifact', 'event', 'file', 'place', 'reference', 'source']:
        data.append(entity.print_standard_type())
    if entity.class_.name == 'file':
        if file_stats:
            data.append(convert_size(
                file_stats[entity.id]['size']) if entity.id in file_stats else 'N/A')
            data.append(
                file_stats[entity.id]['ext'] if entity.id in file_stats else 'N/A')
        else:
            data.append(print_file_size(entity))
            data.append(get_file_extension(entity))
    if entity.class_.view in ['actor', 'artifact', 'event', 'find', 'place']:
        data.append(entity.first)
        data.append(entity.last)
    data.append(entity.description)
    return data


def format_entry_begin(entry: Union['Entity', 'Link'], object_: Optional['Entity'] = None) -> str:
    html = link(object_) if object_ else ''
    if entry.begin_from:
        html += ', ' if html else ''
        if entry.begin_to:
            html += _(
                'between %(begin)s and %(end)s',
                begin=format_date(entry.begin_from),
                end=format_date(entry.begin_to))
        else:
            html += format_date(entry.begin_from)
    html += (' (' + entry.begin_comment + ')') if entry.begin_comment else ''
    return html


def format_entry_end(entry: 'Entity', object_: Optional['Entity'] = None) -> str:
    html = link(object_) if object_ else ''
    if entry.end_from:
        html += ', ' if html else ''
        if entry.end_to:
            html += _(
                'between %(begin)s and %(end)s',
                begin=format_date(entry.end_from),
                end=format_date(entry.end_to))
        else:
            html += format_date(entry.end_from)
    html += (' (' + entry.end_comment + ')') if entry.end_comment else ''
    return html


def get_appearance(event_links: List['Link']) -> Tuple[str, str]:
    # Get first/last appearance from events for actors without begin/end
    first_year = None
    last_year = None
    first_string = ''
    last_string = ''
    for link_ in event_links:
        event = link_.domain
        actor = link_.range
        event_link = link(_('event'), url_for('entity_view', id_=event.id))
        if not actor.first:
            if link_.first and (not first_year or int(link_.first) < int(first_year)):
                first_year = link_.first
                first_string = format_entry_begin(link_) + ' ' + _('at an') + ' ' + event_link
                first_string += (' ' + _('in') + ' ' + link(link_.object_)) if link_.object_ else ''
            elif event.first and (not first_year or int(event.first) < int(first_year)):
                first_year = event.first
                first_string = format_entry_begin(event) + ' ' + _('at an') + ' ' + event_link
                first_string += (' ' + _('in') + ' ' + link(link_.object_)) if link_.object_ else ''
        if not actor.last:
            if link_.last and (not last_year or int(link_.last) > int(last_year)):
                last_year = link_.last
                last_string = format_entry_end(event) + ' ' + _('at an') + ' ' + event_link
                last_string += (' ' + _('in') + ' ' + link(link_.object_)) if link_.object_ else ''
            elif event.last and (not last_year or int(event.last) > int(last_year)):
                last_year = event.last
                last_string = format_entry_end(event) + ' ' + _('at an') + ' ' + event_link
                last_string += (' ' + _('in') + ' ' + link(link_.object_)) if link_.object_ else ''
    return first_string, last_string


class MLStripper(HTMLParser):

    def error(self: MLStripper, message: str) -> None:  # pragma: no cover
        pass

    def __init__(self) -> None:
        super().__init__()
        self.reset()
        self.strict = False
        self.convert_charrefs = True
        self.fed: List[str] = []

    def handle_data(self, d: Any) -> None:
        self.fed.append(d)

    def get_data(self) -> str:
        return ''.join(self.fed)


def sanitize(string: Optional[str], mode: Optional[str] = None) -> str:
    if not string:
        return ''
    if mode == 'node':  # Only keep letters, numbers and spaces
        return re.sub(r'([^\s\w()]|_)+', '', string).strip()
    if mode == 'text':  # Remove HTML tags, keep linebreaks
        s = MLStripper()
        s.feed(string)
        return s.get_data().strip()
    return re.sub('[^A-Za-z0-9]+', '', string)  # Only keep ASCII letters and numbers


def format_datetime(value: Any) -> str:
    return value.replace(microsecond=0).isoformat() if value else ''


def format_date(value: Union[datetime, numpy.datetime64]) -> str:
    if not value:
        return ''
    if isinstance(value, numpy.datetime64):
        date_ = Date.datetime64_to_timestamp(value)
        return date_.lstrip('0') if date_ else ''
    return value.date().isoformat()


def get_backup_file_data() -> Dict[str, Any]:
    path = app.config['EXPORT_DIR'] / 'sql'
    latest_file = None
    latest_file_date = None
    for file in [f for f in path.iterdir() if (path / f).is_file()]:
        if file.name == '.gitignore':
            continue
        file_date = datetime.utcfromtimestamp((path / file).stat().st_ctime)
        if not latest_file_date or file_date > latest_file_date:
            latest_file = file
            latest_file_date = file_date
    file_data: Dict[str, Any] = {'backup_too_old': True}
    if latest_file and latest_file_date:
        yesterday = datetime.today() - timedelta(days=1)
        file_data['file'] = latest_file.name
        file_data['backup_too_old'] = True if yesterday > latest_file_date else False
        file_data['size'] = convert_size(latest_file.stat().st_size)
        file_data['date'] = format_date(latest_file_date)
    return file_data


def convert_size(size_bytes: int) -> str:
    if size_bytes == 0:
        return "0B"  # pragma: no cover
    size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
    i = int(math.floor(math.log(size_bytes, 1024)))
    return "%s %s" % (int(size_bytes / math.pow(1024, i)), size_name[i])


def print_file_size(entity: 'Entity') -> str:
    path = get_file_path(entity.id)
    return convert_size(path.stat().st_size) if path else 'N/A'


def get_disk_space_info() -> Optional[Dict[str, Any]]:
    if os.name != "posix":  # pragma: no cover - e.g. Windows has no statvfs
        return None
    statvfs = os.statvfs(app.config['UPLOAD_DIR'])
    disk_space = statvfs.f_frsize * statvfs.f_blocks
    free_space = statvfs.f_frsize * statvfs.f_bavail  # Available space without reserved blocks
    return {
        'total': convert_size(statvfs.f_frsize * statvfs.f_blocks),
        'free': convert_size(statvfs.f_frsize * statvfs.f_bavail),
        'percent': 100 - math.ceil(free_space / (disk_space / 100))}


def get_file_extension(entity: Union[int, 'Entity']) -> str:
    path = get_file_path(entity if isinstance(entity, int) else entity.id)
    return path.suffix if path else 'N/A'


def get_file_path(entity: Union[int, 'Entity']) -> Optional[Path]:
    entity_id = entity if isinstance(entity, int) else entity.id
    path = next(app.config['UPLOAD_DIR'].glob(str(entity_id) + '.*'), None)
    return path if path else None

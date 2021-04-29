from __future__ import annotations  # Needed for Python 4.0 type annotations

import math
import os
import pathlib
import re
import smtplib
from collections import OrderedDict
from datetime import datetime, timedelta
from email.header import Header
from email.mime.text import MIMEText
from functools import wraps
from html.parser import HTMLParser
from pathlib import Path
from typing import Any, Dict, List, Optional, OrderedDict as OrderedD, TYPE_CHECKING, Tuple, Union

import numpy
from flask import flash, g, render_template, request, session, url_for
from flask_babel import LazyString, format_number, lazy_gettext as _
from flask_login import current_user
from flask_wtf import FlaskForm
from markupsafe import Markup, escape
from werkzeug.exceptions import abort
from werkzeug.utils import redirect
from wtforms import Field, IntegerField
from wtforms.validators import Email

from openatlas import app, logger
from openatlas.models.content import Content
from openatlas.models.date import Date
from openatlas.models.imports import Project
from openatlas.models.link import Link
from openatlas.models.model import CidocClass, CidocProperty
from openatlas.util.table import Table

if TYPE_CHECKING:  # pragma: no cover - Type checking is disabled in tests
    from openatlas.models.entity import Entity
    from openatlas.models.node import Node


@app.template_filter()
def bookmark_toggle(entity_id: int, for_table: bool = False) -> str:
    label = uc_first(_('bookmark remove') if entity_id in current_user.bookmarks else _('bookmark'))
    onclick = f"ajaxBookmark('{entity_id}');"
    if for_table:
        return f'<a href="#" id="bookmark{entity_id}" onclick="{onclick}">{label}</a>'
    return button(label, id_=f'bookmark{entity_id}', onclick=onclick)


@app.template_filter()
def display_external_references(entity: Entity) -> str:
    return Markup(render_template('util/external_references.html', entity=entity))


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
        url = url_for('index', view=item)
        html += f'<a href="{url}" class="nav-item nav-link {active}">{uc_first(_(item))}</a>'
    active = ''
    if request.path.startswith('/types') \
            or request.path.startswith('/insert/type') \
            or (entity and entity.class_.view == 'type'):
        active = 'active'
    url = url_for('node_index')
    html += f'<a href="{url}" class="nav-item nav-link {active}"> {uc_first(_("types"))}</a>'
    return Markup(html)


@app.template_filter()
def is_authorized(group: str) -> bool:
    if not current_user.is_authenticated or not hasattr(current_user, 'group'):
        return False  # pragma: no cover - needed because AnonymousUserMixin has no group
    if current_user.group == 'admin' \
            or current_user.group == group \
            or (current_user.group == 'manager'
                and group in ['editor', 'contributor', 'readonly']) \
            or (current_user.group == 'editor' and group in ['contributor', 'readonly']) \
            or (current_user.group == 'contributor' and group in ['readonly']):
        return True
    return False


@app.template_filter()
def sanitize(string: str, mode: Optional[str] = None) -> str:
    if not string:
        return ''
    if mode == 'node':  # Only keep letters, numbers, minus, brackets and spaces
        return re.sub(r'([^\s\w()-]|_)+', '', string).strip()
    if mode == 'text':  # Remove HTML tags, keep linebreaks
        s = MLStripper()
        s.feed(string)
        return s.get_data().strip()
    return re.sub('[^A-Za-z0-9]+', '', string)  # Only keep ASCII letters and numbers


@app.template_filter()
def test_file(file_name: str) -> Optional[str]:
    return file_name if (pathlib.Path(app.root_path) / file_name).is_file() else None


def format_entity_date(
        entity: Union['Entity', 'Link'],
        type_: str,  # begin or end
        object_: Optional['Entity'] = None) -> str:
    html = link(object_) if object_ else ''
    if getattr(entity, f'{type_}_from'):
        html += ', ' if html else ''
        if getattr(entity, f'{type_}_to'):
            html += _(
                'between %(begin)s and %(end)s',
                begin=format_date(getattr(entity, f'{type_}_from')),
                end=format_date(getattr(entity, f'{type_}_to')))
        else:
            html += format_date(entity.begin_from)
    comment = getattr(entity, f'{type_}_comment')
    return html + (f" ({comment})" if comment else '')


def format_name_and_aliases(entity: 'Entity', show_links: bool) -> str:
    name = link(entity) if show_links else entity.name
    if not len(entity.aliases) or not current_user.settings['table_show_aliases']:
        return name
    return f'<p>{name}</p>{"".join(f"<p>{alias}</p>" for alias in entity.aliases.values())}'


def get_backup_file_data() -> Dict[str, Any]:
    path = app.config['EXPORT_DIR'] / 'sql'
    latest_file = None
    latest_file_date = None
    for file in [f for f in path.iterdir() if (path / f).is_file() and f.name != '.gitignore']:
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


def get_base_table_data(
        entity: 'Entity',
        file_stats: Optional[Dict[Union[int, str], Any]] = None,
        show_links: Optional[bool] = True) -> List[Any]:
    data = [format_name_and_aliases(entity, show_links)]
    if entity.class_.view in ['actor', 'artifact', 'event', 'reference'] or \
            entity.class_.name == 'find':
        data.append(entity.class_.label)
    if entity.class_.view in ['artifact', 'event', 'file', 'place', 'reference', 'source']:
        data.append(entity.print_standard_type(show_links=False))
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


def get_disk_space_info() -> Optional[Dict[str, Any]]:
    if os.name != "posix":  # pragma: no cover
        return None
    statvfs = os.statvfs(app.config['UPLOAD_DIR'])
    disk_space = statvfs.f_frsize * statvfs.f_blocks
    free_space = statvfs.f_frsize * statvfs.f_bavail  # Available space without reserved blocks
    return {
        'total': convert_size(statvfs.f_frsize * statvfs.f_blocks),
        'free': convert_size(statvfs.f_frsize * statvfs.f_bavail),
        'percent': 100 - math.ceil(free_space / (disk_space / 100))}


def get_file_stats(path: Path = app.config['UPLOAD_DIR']) -> Dict[Union[int, str], Any]:
    stats: Dict[int, Dict[str, Any]] = {}
    for f in filter(lambda x: x.stem.isdigit(), path.iterdir()):
        stats[int(f.stem)] = {'ext': f.suffix, 'size': f.stat().st_size, 'date': f.stat().st_ctime}
    return stats


def get_entity_data(entity: 'Entity', event_links: Optional[List[Link]] = None) -> Dict[str, Any]:
    data: OrderedD[str, Any] = OrderedDict({_('alias'): list(entity.aliases.values())})

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
    data[_('begin')] = (from_link if from_link else '') + format_entity_date(entity, 'begin')
    data[_('end')] = (to_link if to_link else '') + format_entity_date(entity, 'end')

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
        data[_('begin')] = format_entity_date(entity, 'begin', begin_object)
        data[_('end')] = format_entity_date(entity, 'end', end_object)
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


def required_group(group: str):  # type: ignore
    def wrapper(f):  # type: ignore
        @wraps(f)
        def wrapped(*args, **kwargs):  # type: ignore
            if not current_user.is_authenticated:
                return redirect(url_for('login', next=request.path))
            if not is_authorized(group):
                abort(403)
            return f(*args, **kwargs)

        return wrapped

    return wrapper


def send_mail(
        subject: str,
        text: str,
        recipients: Union[str, List[str]],
        log_body: bool = True) -> bool:  # pragma: no cover
    """Send one mail to every recipient, set log_body to False for sensitive data e.g. passwords"""
    recipients = recipients if isinstance(recipients, list) else [recipients]
    settings = session['settings']
    if not settings['mail'] or len(recipients) < 1:
        return False
    mail_user = settings['mail_transport_username']
    from_ = f"{settings['mail_from_name']} <{settings['mail_from_email']}>"
    server = smtplib.SMTP(settings['mail_transport_host'], settings['mail_transport_port'])
    server.ehlo()
    server.starttls()
    try:
        if settings['mail_transport_username']:
            server.login(mail_user, app.config['MAIL_PASSWORD'])
        for recipient in recipients:
            msg = MIMEText(text, _charset='utf-8')
            msg['From'] = from_
            msg['To'] = recipient.strip()
            msg['Subject'] = Header(subject.encode('utf-8'), 'utf-8')
            server.sendmail(settings['mail_from_email'], recipient, msg.as_string())
        log_text = f'Mail from {from_} to {", ".join(recipients)} Subject: {subject}'
        log_text += f' Content: {text}' if log_body else ''
        logger.log('info', 'mail', f'Mail send from {from_}', log_text)
    except smtplib.SMTPAuthenticationError as e:
        logger.log('error', 'mail', f'Error mail login for {mail_user}', e)
        flash(_('error mail login'), 'error')
        return False
    except Exception as e:
        logger.log('error', 'mail', f'Error send mail for {mail_user}', e)
        flash(_('error mail send'), 'error')
        return False
    return True


def tooltip(text: str) -> str:
    if not text:
        return ''
    return '<span><i class="fas fa-info-circle tooltipicon" title="{title}"></i></span>'.format(
        title=text.replace('"', "'"))


def was_modified(form: FlaskForm, entity: 'Entity') -> bool:  # pragma: no cover
    if not entity.modified or not form.opened.data:
        return False
    if entity.modified < datetime.fromtimestamp(float(form.opened.data)):
        return False
    logger.log('info', 'multi user', 'Multi user overwrite prevented.')
    return True


# Todo: fix first appearance date comparison, continue with rest of util
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
                first_string = f"{format_entity_date(link_, 'begin', link_.object_)} {_('*at an')} {event_link}"
            elif event.first and (not first_year or int(event.first) < int(first_year)):
                first_year = event.first
                first_string = f"{format_entity_date(event, 'begin', link_.object_)} {_('at an')} {event_link}"
        if not actor.last:
            if link_.last and (not last_year or int(link_.last) > int(last_year)):
                last_year = link_.last
                last_string = f"{format_entity_date(event, 'end', link_.object_)} {_('at an')} {event_link}"
            elif event.last and (not last_year or int(event.last) > int(last_year)):
                last_year = event.last
                last_string = f"{format_entity_date(event, 'end', link_.object_)} {_('at an')} {event_link}"
    return first_string, last_string


def format_datetime(value: Any) -> str:
    return value.replace(microsecond=0).isoformat() if value else ''


def get_file_extension(entity: Union[int, 'Entity']) -> str:
    path = get_file_path(entity if isinstance(entity, int) else entity.id)
    return path.suffix if path else 'N/A'


def get_file_path(entity: Union[int, 'Entity']) -> Optional[Path]:
    entity_id = entity if isinstance(entity, int) else entity.id
    path = next(app.config['UPLOAD_DIR'].glob(str(entity_id) + '.*'), None)
    return path if path else None


def add_reference_systems_to_form(form: Any) -> str:
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


def print_file_size(entity: 'Entity') -> str:
    path = get_file_path(entity.id)
    return convert_size(path.stat().st_size) if path else 'N/A'


def format_date(value: Union[datetime, numpy.datetime64]) -> str:
    if not value:
        return ''
    if isinstance(value, numpy.datetime64):
        date_ = Date.datetime64_to_timestamp(value)
        return date_.lstrip('0') if date_ else ''
    return value.date().isoformat()


def external_url(url: Union[str, None]) -> str:
    return f'<a target="blank_" rel="noopener noreferrer" href="{url}">{url}</a>' if url else ''


def add_system_data(entity: Entity, data: Dict[str, Any]) -> Dict[str, Any]:
    from openatlas import logger
    # Add additional information for entity views (if activated in profile)
    if not hasattr(current_user, 'settings'):
        return data  # pragma: no cover
    info = logger.get_log_for_advanced_view(entity.id)
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
            <a class="{css}" href="{url}" target="_blank" title="Download">
                <i class="fas fa-download"></i> {label}
            </a>'''.format(
            css=app.config['CSS']['button']['primary'],
            url=url_for('entity', id_=entity.id, download=True),
            label=uc_first('download'))
        data_api += '''
            <a class="{css}" href="{url}" target="_blank" title="CSV">
                <i class="fas fa-download"></i> {label}
            </a>'''.format(
            css=app.config['CSS']['button']['primary'],
            url=url_for('entity', id_=entity.id, export='csv'),
            label=uc_first('csv'))
        data['API'] = data_api
    return data


def add_type_data(entity: 'Entity', data: OrderedDict[str, Any]) -> Dict[str, Any]:
    if entity.location:
        entity.nodes.update(entity.location.nodes)  # Add location types
    type_data: OrderedD[str, Any] = OrderedDict()
    sorted_nodes = sorted(entity.nodes.items(), key=lambda x: x[0].name)
    for node, node_value in sorted_nodes:
        root = g.nodes[node.root[-1]]
        label = _('type') if root.standard and root.class_.name == 'type' else root.name
        if root.name not in type_data:
            type_data[label] = []
        text = ''
        if root.value_type:  # Text for value types
            text = ': {value} <span style="font-style:italic;">{description}</span>'.format(
                value=format_number(node_value), description=description)
        type_data[label].append('<span title="{path}">{link}</span>{text}'.format(
            link=link(node),
            path=' > '.join([g.nodes[id_].name for id_ in node.root]),
            text=text))

    # Sort root types and move standard type to top
    type_data = OrderedDict(sorted(type_data.items()))
    for item in type_data.keys():
        if item == _('type'):
            type_data.move_to_end(item, last=False)
            break

    for root_name, nodes in type_data.items():
        data[root_name] = nodes

    return data


def convert_size(size_bytes: int) -> str:
    if size_bytes == 0:
        return "0B"  # pragma: no cover
    size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
    i = int(math.floor(math.log(size_bytes, 1024)))
    return "%s %s" % (int(size_bytes / math.pow(1024, i)), size_name[i])


def delete_link(name: str, url: str) -> str:
    return link(
        _('delete'),
        url=url,
        js="return confirm('{x}')".format(x=_('Delete %(name)s?', name=name.replace("'", ''))))


def add_edit_link(data: List[Any], url: str) -> List[Any]:
    if is_authorized('contributor'):
        data.append(link(_('edit'), url))
    return data


def display_delete_link(entity: Entity) -> str:
    if entity.class_.name == 'source_translation':
        url = url_for('translation_delete', id_=entity.id)
    elif entity.id in g.nodes:
        url = url_for('node_delete', id_=entity.id)
    else:
        url = url_for('index', view=entity.class_.view, delete_id=entity.id)
    confirm = _('Delete %(name)s?', name=entity.name.replace('\'', ''))
    return button(_('delete'), url, onclick=f"return confirm('{confirm}')")


def add_remove_link(
        data: List[Any],
        name: str,
        link_: Link,
        origin: Entity,
        tab_: str) -> List[Any]:
    if is_authorized('contributor'):
        data.append(link(
            _('remove'),
            url_for('link_delete', id_=link_.id, origin_id=origin.id) + '#tab-' + tab_,
            js="return confirm('{x}')".format(x=_('Remove %(name)s?', name=name.replace("'", '')))))
    return data


paragraph_re = re.compile(r'(?:\r\n|\r|\n){2,}')


@app.template_filter()
def link(object_: Any,
         url: Optional[str] = None,
         class_: Optional[str] = '',
         uc_first_: Optional[bool] = True,
         js: Optional[str] = None) -> str:
    if isinstance(object_, (str, LazyString)):
        return '<a href="{url}" class="{class_}" {js}>{label}</a>'.format(
            url=url,
            class_=class_,
            js=f'onclick="{js}"' if js else '',
            label=(uc_first(str(object_))) if uc_first_ else object_)

    # Builds an HTML link to a detail view of an object
    from openatlas.models.entity import Entity
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


@app.template_filter()
def button(
        label: str,
        url: Optional[str] = '#',
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


@app.template_filter()
def display_citation_example(code: str) -> str:
    text = Content.get_translation('citation_example')
    if not text or code != 'reference':
        return ''
    return Markup(f'<h1>{uc_first(_("citation_example"))}</h1>{text}')


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
            previous=button('<', url_for('entity_view', id_=prev_id)) if prev_id else '',
            next=button('>', url_for('entity_view', id_=next_id)) if next_id else '',
            position=position,
            of_label=_('of'),
            count=len(structure['siblings'])))


@app.template_filter()
def breadcrumb(crumbs: List[Any]) -> str:
    from openatlas.models.entity import Entity
    from openatlas.models.user import User
    items = []
    for item in crumbs:
        if not item:
            continue  # Item can be None e.g. if a dynamic generated URL has no origin parameter
        elif isinstance(item, Entity) or isinstance(item, Project) or isinstance(item, User):
            items.append(link(item))
        elif isinstance(item, list):
            items.append(f'<a href="{item[1]}">{uc_first(str(item[0]))}</a>')
        else:
            items.append(uc_first(item))
    return Markup('&nbsp;>&nbsp; '.join(items))


@app.template_filter()
def tab_header(item: str, table: Optional[Table] = None, active: Optional[bool] = False) -> str:
    from openatlas.util import tab
    return Markup(tab.tab_header(item, table, active))


@app.template_filter()
def uc_first(string: str) -> str:
    return str(string)[0].upper() + str(string)[1:] if string else ''


@app.template_filter()
def display_info(data: Dict[str, Union[str, List[str]]]) -> str:
    html = '<div class="data-table">'
    for label, value in data.items():
        if value or value == 0:
            if isinstance(value, list):
                value = '<br>'.join(value)
            html += f"""
                <div class="table-row">
                    <div>{uc_first(label)}</div>
                    <div class="table-cell">{value}</div>
                </div>"""
    return Markup(html + '</div>')


@app.template_filter()
def display_move_form(form: Any, root_name: str) -> str:
    from openatlas.forms.field import TreeField
    html = ''
    for field in form:
        if isinstance(field, TreeField):
            html += '<p>' + root_name + ' ' + str(field) + '</p>'
    table = Table(
        header=['#', uc_first(_('selection'))],
        rows=[[item, item.label.text] for item in form.selection])
    return html + f"""
        <div class="toolbar">
            {button(_('select all'), id_='select-all')}
            {button(_('deselect all'), id_='select-none')}
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
                            <button type="button" class="{css}"
                                data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">{table}</div>
                        <div class="modal-footer">
                            <button type="button" class="{css}" data-dismiss="modal">
                                {close_label}
                            </button>
                        </div>
                    </div>
                </div>
            </div>""".format(
        css=app.config['CSS']['button']['primary'],
        name=name,
        value=value,
        close_label=uc_first(_('close')),
        table=table.display(name))
    return html


@app.template_filter()
def description(entity: Union[Entity, Project]) -> str:
    from openatlas.models.entity import Entity
    if not entity.description:
        return ''
    label = _('description')
    if isinstance(entity, Entity) and entity.class_.name == 'source':
        label = _('content')
    return Markup(f"""
        <h2>{uc_first(label)}</h2>
        <div class="description more">{'<br>'.join(entity.description.splitlines())}</div>""")


@app.template_filter()
def download_button(entity: Entity) -> str:
    if entity.class_.view != 'file':
        return ''
    html = f'<span class="error">{uc_first(_("missing file"))}</span>'
    if entity.image_id:
        path = get_file_path(entity.image_id)
        html = button(_('download'), url_for('download_file', filename=path.name))
    return Markup(html)


@app.template_filter()
def display_profile_image(entity: Entity) -> str:
    if not entity.image_id:
        return ''
    path = get_file_path(entity.image_id)
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
            html = uc_first(_('no preview available'))  # pragma: no cover
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
        <a class="manual"
            href="/static/manual/{site}.html"
            target="_blank"
            title="{uc_first('manual')}">
                <i class="fas fa-book"></i>
        </a>""")


def add_row(
        field: Field,
        label: Optional[str] = None,
        value: Optional[str] = None,
        form_id: Optional[str] = None,
        row_css_class: Optional[str] = '') -> str:
    field.label.text = uc_first(field.label.text)
    if field.flags.required and form_id != 'login-form' and field.label.text:
        field.label.text += ' *'

    # CSS
    css_class = 'required' if field.flags.required else ''
    css_class += ' integer' if isinstance(field, IntegerField) else ''
    for validator in field.validators:
        css_class += ' email' if isinstance(validator, Email) else ''
    errors = ' <span class="error">{errors}</span>'.format(
        errors=' '.join(uc_first(error) for error in field.errors)) if field.errors else ''
    return """
        <div class="table-row {css_row}">
            <div>{label} {tooltip}</div>
            <div class="table-cell">{value} {errors}</div>
        </div>""".format(
        label=label if isinstance(label, str) else field.label,
        tooltip=tooltip(field.description),
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

    def display_value_type_fields(node_: 'Node', root: Optional['Node'] = None) -> str:
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
                html += add_dates_to_form(form, for_persons)
            continue

        if field.type in ['TreeField', 'TreeMultiField']:
            hierarchy_id = int(field.id)
            node = g.nodes[hierarchy_id]
            label = node.name
            if node.standard and node.class_.name == 'type':
                label = uc_first(_('type'))
            if field.label.text == 'super':
                label = uc_first(_('super'))
            if node.value_type and 'is_node_form' not in form:
                field.description = node.description
                onclick = f'switch_value_type({node.id})'
                html += add_row(field, label, button(_('show'), onclick=onclick, css='secondary'))
                html += display_value_type_fields(node)
                continue
            tooltip_ = '' if 'is_node_form' in form else ' ' + tooltip(node.description)
            html += add_row(field, label + tooltip_)
            continue

        if field.id == 'save':
            field.label.text = uc_first(field.label.text)
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
                html += add_reference_systems_to_form(form)
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

from typing import Any, Dict, List, Optional, Union

from flask import flash, g, render_template, request, url_for
from flask_babel import format_number, lazy_gettext as _
from flask_login import current_user
from werkzeug.exceptions import abort
from werkzeug.utils import redirect
from werkzeug.wrappers import Response

from openatlas import app
from openatlas.forms.form import build_table_form
from openatlas.models.entity import Entity
from openatlas.models.gis import Gis
from openatlas.models.link import Link
from openatlas.models.node import Node
from openatlas.models.overlay import Overlay
from openatlas.models.place import get_structure
from openatlas.models.reference_system import ReferenceSystem
from openatlas.models.user import User
from openatlas.util.display import (add_edit_link, add_remove_link, button, display_delete_link,
                                    format_date, get_base_table_data, get_entity_data,
                                    get_file_path,  get_profile_image_table_link, link, uc_first)
from openatlas.util.tab import Tab
from openatlas.util.table import Table
from openatlas.util.util import is_authorized, required_group
from openatlas.views.reference import AddReferenceForm


@app.route('/entity/<int:id_>')
@required_group('readonly')
def entity_view(id_: int) -> Union[str, Response]:
    if id_ in g.nodes:  # Nodes have their own view
        entity = g.nodes[id_]
        if not entity.root:
            if entity.class_.name == 'administrative_unit':
                tab_hash = '#menu-tab-places_collapse-'
            elif entity.standard:
                tab_hash = '#menu-tab-standard_collapse-'
            elif entity.value_type:
                tab_hash = '#menu-tab-value_collapse-'
            else:
                tab_hash = '#menu-tab-custom_collapse-'
            return redirect(url_for('node_index') + tab_hash + str(id_))
    elif id_ in g.reference_systems:
        entity = g.reference_systems[id_]
    else:
        entity = Entity.get_by_id(id_, nodes=True, aliases=True)
        if not entity.class_.view:
            flash(_("This entity can't be viewed directly."), 'error')
            abort(400)

    event_links = None  # Needed for actor
    overlays = None  # Needed for place
    tabs = {'info': Tab('info')}
    if isinstance(entity, Node):
        tabs['subs'] = Tab('subs', entity)
        tabs['entities'] = Tab('entities', entity)
        root = g.nodes[entity.root[-1]] if entity.root else None
        if root and root.value_type:  # pragma: no cover
            tabs['entities'].table.header = [_('name'), _('value'), _('class'), _('info')]
        for item in entity.get_linked_entities(['P2', 'P89'], inverse=True, nodes=True):
            if item.class_.name in ['location', 'reference_system']:
                continue  # pragma: no cover
            if item.class_.name == 'object_location':  # pragma: no cover
                item = item.get_linked_entity_safe('P53', inverse=True)
            data = [link(item)]
            if root and root.value_type:  # pragma: no cover
                data.append(format_number(item.nodes[entity]))
            data.append(item.class_.label)
            data.append(item.description)
            tabs['entities'].table.rows.append(data)
        for sub_id in entity.subs:
            sub = g.nodes[sub_id]
            tabs['subs'].table.rows.append([link(sub), sub.count, sub.description])
        if not tabs['entities'].table.rows:  # If no entities available get links with this type_id
            tabs['entities'].table.header = [_('domain'), _('range')]
            for row in Link.get_entities_by_node(entity):
                tabs['entities'].table.rows.append([
                    link(Entity.get_by_id(row['domain_id'])),
                    link(Entity.get_by_id(row['range_id']))])
    elif isinstance(entity, ReferenceSystem):
        for form_id, form in entity.get_forms().items():
            tabs[form['name']] = Tab(form['name'], origin=entity)
            tabs[form['name']].table = Table([_('entity'), 'id', _('precision')])
        for link_ in entity.get_links('P67'):
            name = link_.description
            if entity.resolver_url:
                name = \
                    '<a href="{url}" target="_blank" rel="noopener noreferrer">{name}</a>'.format(
                        url=entity.resolver_url + name, name=name)
            tab_name = link_.range.class_.name
            tabs[tab_name].table.rows.append([link(link_.range), name, link_.type.name])
        for form_id, form in entity.get_forms().items():
            if not tabs[form['name']].table.rows and is_authorized('manager'):
                tabs[form['name']].buttons = [
                    button(_('remove'),
                           url_for('reference_system_remove_form',
                                   system_id=entity.id,
                                   form_id=form_id))]
    elif entity.class_.view == 'actor':
        for name in ['source', 'event', 'relation', 'member_of', 'member']:
            tabs[name] = Tab(name, entity)
        event_links = entity.get_links(['P11', 'P14', 'P22', 'P23', 'P25'], True)
        for link_ in event_links:
            event = link_.domain
            places = event.get_linked_entities(['P7', 'P26', 'P27'])
            link_.object_ = None
            for place in places:
                object_ = place.get_linked_entity_safe('P53', True)
                entity.linked_places.append(object_)
                link_.object_ = object_  # Needed later for first/last appearance info
            first = link_.first
            if not link_.first and event.first:
                first = '<span class="inactive">' + event.first + '</span>'
            last = link_.last
            if not link_.last and event.last:
                last = '<span class="inactive">' + event.last + '</span>'
            data = [
                link(event),
                event.class_.label,
                link(link_.type),
                first,
                last,
                link_.description]
            data = add_edit_link(
                data,
                url_for('involvement_update', id_=link_.id, origin_id=entity.id))
            data = add_remove_link(data, link_.domain.name, link_, entity, 'event')
            tabs['event'].table.rows.append(data)
        for link_ in entity.get_links('OA7') + entity.get_links('OA7', True):
            type_ = ''
            if entity.id == link_.domain.id:
                related = link_.range
                if link_.type:
                    type_ = link(
                        link_.type.get_name_directed(),
                        url_for('entity_view', id_=link_.type.id))
            else:
                related = link_.domain
                if link_.type:
                    type_ = link(
                        link_.type.get_name_directed(True),
                        url_for('entity_view', id_=link_.type.id))
            data = [type_, link(related), link_.first, link_.last, link_.description]
            data = add_edit_link(
                data,
                url_for('relation_update', id_=link_.id, origin_id=entity.id))
            data = add_remove_link(data, related.name, link_, entity, 'relation')
            tabs['relation'].table.rows.append(data)
        for link_ in entity.get_links('P107', True):
            data = [
                link(link_.domain),
                link(link_.type),
                link_.first,
                link_.last,
                link_.description]
            data = add_edit_link(data, url_for('member_update', id_=link_.id, origin_id=entity.id))
            data = add_remove_link(data, link_.domain.name, link_, entity, 'member-of')
            tabs['member_of'].table.rows.append(data)
        if entity.class_.name != 'group':
            del tabs['member']
        else:
            for link_ in entity.get_links('P107'):
                data = [
                    link(link_.range),
                    link(link_.type),
                    link_.first,
                    link_.last,
                    link_.description]
                data = add_edit_link(
                    data,
                    url_for('member_update', id_=link_.id, origin_id=entity.id))
                data = add_remove_link(data, link_.range.name, link_, entity, 'member')
                tabs['member'].table.rows.append(data)
    elif entity.class_.view == 'artifact':
        tabs['source'] = Tab('source', entity)
    elif entity.class_.view == 'event':
        for name in ['subs', 'source', 'actor']:
            tabs[name] = Tab(name, entity)
        for sub_event in entity.get_linked_entities('P117', inverse=True, nodes=True):
            tabs['subs'].table.rows.append(get_base_table_data(sub_event))
        tabs['actor'].table.header.insert(5, _('activity'))  # Add a table column for activity
        for link_ in entity.get_links(['P11', 'P14', 'P22', 'P23']):
            first = link_.first
            if not link_.first and entity.first:
                first = '<span class="inactive">' + entity.first + '</span>'
            last = link_.last
            if not link_.last and entity.last:
                last = '<span class="inactive">' + entity.last + '</span>'
            data = [
                link(link_.range),
                link_.range.class_.label,
                link_.type.name if link_.type else '',
                first,
                last,
                g.properties[link_.property.code].name_inverse,
                link_.description]
            data = add_edit_link(
                data,
                url_for('involvement_update', id_=link_.id, origin_id=entity.id))
            data = add_remove_link(data, link_.range.name, link_, entity, 'actor')
            tabs['actor'].table.rows.append(data)
        entity.linked_places = [
            location.get_linked_entity_safe('P53', True) for location
            in entity.get_linked_entities(['P7', 'P26', 'P27'])]
    elif entity.class_.view == 'file':
        for name in ['source', 'event', 'actor', 'place', 'feature', 'stratigraphic_unit',
                     'artifact', 'human_remains', 'reference', 'type']:
            tabs[name] = Tab(name, entity)
        entity.image_id = entity.id if get_file_path(entity.id) else None
        for link_ in entity.get_links('P67'):
            range_ = link_.range
            data = get_base_table_data(range_)
            data = add_remove_link(data, range_.name, link_, entity, range_.class_.name)
            tabs[range_.class_.view].table.rows.append(data)
        for link_ in entity.get_links('P67', True):
            data = get_base_table_data(link_.domain)
            data.append(link_.description)
            data = add_edit_link(
                data,
                url_for('reference_link_update', link_id=link_.id, origin_id=entity.id))
            data = add_remove_link(data, link_.domain.name, link_, entity, 'reference')
            tabs['reference'].table.rows.append(data)
    elif entity.class_.view == 'place':
        tabs['source'] = Tab('source', entity)
        tabs['event'] = Tab('event', entity)
        tabs['reference'] = Tab('reference', entity)
        if entity.class_.name == 'place':
            tabs['actor'] = Tab('actor', entity)
            tabs['feature'] = Tab('feature', origin=entity)
        elif entity.class_.name == 'feature':
            tabs['stratigraphic_unit'] = Tab('stratigraphic_unit', origin=entity)
        elif entity.class_.name == 'stratigraphic_unit':
            tabs['find'] = Tab('find', origin=entity)
            tabs['human_remains'] = Tab('human_remains', origin=entity)
        entity.location = entity.get_linked_entity_safe('P53', nodes=True)
        event_ids = []  # Keep track of already inserted events to prevent doubles
        for event in entity.location.get_linked_entities(['P7', 'P26', 'P27'], inverse=True):
            tabs['event'].table.rows.append(get_base_table_data(event))
            event_ids.append(event.id)
        for event in entity.get_linked_entities('P24', inverse=True):
            if event.id not in event_ids:  # Don't add again if already in table
                tabs['event'].table.rows.append(get_base_table_data(event))
        if 'actor' in tabs:
            for link_ in entity.location.get_links(['P74', 'OA8', 'OA9'], inverse=True):
                actor = Entity.get_by_id(link_.domain.id)
                tabs['actor'].table.rows.append([
                    link(actor),
                    g.properties[link_.property.code].name,
                    actor.class_.name,
                    actor.first,
                    actor.last,
                    actor.description])
    elif entity.class_.view == 'reference':
        for name in ['source', 'event', 'actor', 'place', 'feature', 'stratigraphic_unit',
                     'human_remains', 'artifact', 'file']:
            tabs[name] = Tab(name, entity)
        for link_ in entity.get_links('P67'):
            range_ = link_.range
            data = get_base_table_data(range_)
            data.append(link_.description)
            data = add_edit_link(
                data,
                url_for('reference_link_update', link_id=link_.id, origin_id=entity.id))
            data = add_remove_link(data, range_.name, link_, entity, range_.class_.name)
            tabs[range_.class_.view].table.rows.append(data)
    elif entity.class_.view == 'source':
        for name in ['actor', 'artifact', 'feature', 'event', 'human_remains', 'place',
                     'stratigraphic_unit', 'text']:
            tabs[name] = Tab(name, entity)
        for text in entity.get_linked_entities('P73', nodes=True):
            tabs['text'].table.rows.append([
                link(text),
                next(iter(text.nodes)).name if text.nodes else '',
                text.description])
        for link_ in entity.get_links('P67'):
            range_ = link_.range
            data = get_base_table_data(range_)
            data = add_remove_link(data, range_.name, link_, entity, range_.class_.name)
            tabs[range_.class_.view].table.rows.append(data)

    if entity.class_.view in ['actor', 'artifact', 'event', 'place', 'source', 'type']:
        if entity.class_.view != 'reference' and not isinstance(entity, Node):
            tabs['reference'] = Tab('reference', entity)
        if entity.class_.view == 'artifact':
            tabs['event'] = Tab('event', entity)
            for link_ in entity.get_links('P25', True):
                data = get_base_table_data(link_.domain)
                tabs['event'].table.rows.append(data)
        tabs['file'] = Tab('file', entity)
        entity.image_id = entity.get_profile_image_id()
        tabs['file'].table.header.append(uc_first(_('overlay')))
        for link_ in entity.get_links('P67', inverse=True):
            domain = link_.domain
            data = get_base_table_data(domain)
            if domain.class_.view == 'file':  # pragma: no cover
                extension = data[3]
                data.append(
                    get_profile_image_table_link(domain, entity, extension, entity.image_id))
                if not entity.image_id and extension in app.config['DISPLAY_FILE_EXTENSIONS']:
                    entity.image_id = domain.id
                if entity.class_.view == 'place' and is_authorized('editor') and \
                        current_user.settings['module_map_overlay']:
                    overlays = Overlay.get_by_object(entity)
                    if extension in app.config['DISPLAY_FILE_EXTENSIONS']:
                        if domain.id in overlays:
                            data = add_edit_link(
                                data,
                                url_for('overlay_update', id_=overlays[domain.id].id))
                        else:
                            data.append(
                                link(_('link'),
                                     url_for(
                                         'overlay_insert',
                                         image_id=domain.id,
                                         place_id=entity.id,
                                         link_id=link_.id)))
                    else:  # pragma: no cover
                        data.append('')
            if domain.class_.view not in ['source', 'file']:
                data.append(link_.description)
                data = add_edit_link(
                    data,
                    url_for('reference_link_update', link_id=link_.id, origin_id=entity.id))
                if domain.class_.view == 'reference_system':
                    entity.reference_systems.append(link_)
                    continue
            data = add_remove_link(data, domain.name, link_, entity, domain.class_.view)
            tabs[domain.class_.view].table.rows.append(data)

    structure = None  # Needed for place
    gis_data = None  # Needed for place
    if entity.class_.view in ['artifact', 'place']:
        structure = get_structure(entity)
        if structure:
            for item in structure['subunits']:
                tabs[item.class_.name].table.rows.append(get_base_table_data(item))
        gis_data = Gis.get_all([entity], structure)
        if gis_data['gisPointSelected'] == '[]' \
                and gis_data['gisPolygonSelected'] == '[]' \
                and gis_data['gisLineSelected'] == '[]' \
                and (not structure or not structure['super_id']):
            gis_data = {}

    if not gis_data:
        gis_data = Gis.get_all(entity.linked_places) if entity.linked_places else None
    entity.info_data = get_entity_data(entity, event_links=event_links)
    tabs['note'] = Tab('note', entity)
    for note in current_user.get_notes_by_entity_id(entity.id):
        data = [
            format_date(note['created']),
            uc_first(_('public')) if note['public'] else uc_first(_('private')),
            link(User.get_by_id(note['user_id'])),
            note['text'],
            '<a href="{url}">{label}</a>'.format(
                url=url_for('note_view', id_=note['id']),
                label=uc_first(_('view')))]
        tabs['note'].table.rows.append(data)
    return render_template(
        'entity/view.html',
        entity=entity,
        tabs=tabs,
        buttons=add_buttons(entity),
        structure=structure,  # Needed for place views
        overlays=overlays,  # Needed for place views
        gis_data=gis_data,
        title=entity.name,
        crumbs=add_crumbs(entity, structure))


def add_crumbs(entity: Union[Entity, Node], structure: Optional[Dict[str, Any]]) -> List[str]:
    crumbs = [
        [_(entity.class_.view.replace('_', ' ')), url_for('index', view=entity.class_.view)],
        entity.name]
    if structure:
        first_item = [g.classes['place'].label, url_for('index', view='place')]
        if entity.class_.name == 'artifact':
            first_item = [g.classes['artifact'].label, url_for('index', view='artifact')]
        crumbs = [
            first_item,
            structure['place'],
            structure['feature'],
            structure['stratigraphic_unit'],
            entity.name]
    elif isinstance(entity, Node):
        crumbs = [[_('types'), url_for('node_index')]]
        if entity.root:
            crumbs += [g.nodes[node_id] for node_id in reversed(entity.root)]
        crumbs += [entity.name]
    elif entity.class_.view == 'source_translation':
        crumbs = [
            [_('source'), url_for('index', view='source')],
            entity.get_linked_entity('P73', True),
            entity.name]
    return crumbs


def add_buttons(entity: Entity) -> List[str]:
    if not is_authorized(entity.class_.write_access):
        return []  # pragma: no cover
    buttons = []
    if isinstance(entity, Node):
        if entity.root and not g.nodes[entity.root[0]].locked:
            buttons.append(button(_('edit'), url_for('update', id_=entity.id)))
            if not entity.locked and entity.count < 1 and not entity.subs:
                buttons.append(display_delete_link(entity))
    elif isinstance(entity, ReferenceSystem):
        buttons.append(button(_('edit'), url_for('update', id_=entity.id)))
        if not entity.forms and not entity.system:
            buttons.append(display_delete_link(entity))
    elif entity.class_.name == 'source_translation':
        buttons.append(button(_('edit'), url_for('translation_update', id_=entity.id)))
        buttons.append(display_delete_link(entity))
    else:
        buttons.append(button(_('edit'), url_for('update', id_=entity.id)))
        if entity.class_.view != 'place' or not entity.get_linked_entities('P46'):
            buttons.append(display_delete_link(entity))
    return buttons


@app.route('/entity/add/file/<int:id_>', methods=['GET', 'POST'])
@required_group('contributor')
def entity_add_file(id_: int) -> Union[str, Response]:
    entity = Entity.get_by_id(id_)
    if request.method == 'POST':
        if request.form['checkbox_values']:
            entity.link_string('P67', request.form['checkbox_values'], inverse=True)
        return redirect(url_for('entity_view', id_=id_) + '#tab-file')
    form = build_table_form('file', entity.get_linked_entities('P67', inverse=True))
    return render_template(
        'form.html',
        entity=entity,
        form=form,
        title=entity.name,
        crumbs=[
            [_(entity.class_.view), url_for('index', view=entity.class_.view)],
            entity,
            _('link') + ' ' + _('file')])


@app.route('/entity/add/source/<int:id_>', methods=['POST', 'GET'])
@required_group('contributor')
def entity_add_source(id_: int) -> Union[str, Response]:
    entity = Entity.get_by_id(id_)
    if request.method == 'POST':
        if request.form['checkbox_values']:
            entity.link_string('P67', request.form['checkbox_values'], inverse=True)
        return redirect(url_for('entity_view', id_=id_) + '#tab-source')
    form = build_table_form('source', entity.get_linked_entities('P67', inverse=True))
    return render_template(
        'form.html',
        form=form,
        title=entity.name,
        crumbs=[
            [_(entity.class_.view), url_for('index', view=entity.class_.view)],
            entity,
            _('link') + ' ' + _('source')])


@app.route('/entity/add/reference/<int:id_>', methods=['POST', 'GET'])
@app.route('/entity/add/reference/<int:id_>/<subunit>', methods=['POST', 'GET'])
@required_group('contributor')
def entity_add_reference(id_: int, subunit: bool = False) -> Union[str, Response]:
    entity = Entity.get_by_id(id_)
    form = AddReferenceForm() if subunit else AddReferenceForm()
    if form.validate_on_submit():
        entity.link_string('P67', form.reference.data, description=form.page.data, inverse=True)
        return redirect(url_for('entity_view', id_=id_) + '#tab-reference')
    form.page.label.text = uc_first(_('page / link text'))
    return render_template(
        'display_form.html',
        entity=entity,
        form=form,
        crumbs=[
            [_(entity.class_.view), url_for('index', view=entity.class_.view)],
            entity,
            _('link') + ' ' + _('reference')])

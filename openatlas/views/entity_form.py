import os
from typing import Any, Dict, List, Optional, TYPE_CHECKING, Union

from flask import flash, g, render_template, request, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from werkzeug.exceptions import abort
from werkzeug.utils import redirect, secure_filename
from werkzeug.wrappers import Response

from openatlas import app, logger
from openatlas.database.connect import Transaction
from openatlas.forms.form import build_form
from openatlas.models.entity import Entity
from openatlas.models.gis import Gis, InvalidGeomException
from openatlas.models.link import Link
from openatlas.models.node import Node
from openatlas.models.overlay import Overlay
from openatlas.models.place import get_structure
from openatlas.models.reference_system import ReferenceSystem
from openatlas.util.display import get_base_table_data, link
from openatlas.util.util import is_authorized, required_group, was_modified

if TYPE_CHECKING:  # pragma: no cover
    from openatlas.models.entity import Entity


@app.route('/insert/<class_>', methods=['POST', 'GET'])
@app.route('/insert/<class_>/<int:origin_id>', methods=['POST', 'GET'])
@required_group('contributor')
def insert(class_: str, origin_id: Optional[int] = None) -> Union[str, Response]:
    if class_ not in g.classes or not g.classes[class_].view \
            or not is_authorized(g.classes[class_].write_access):
        abort(403)  # pragma: no cover
    origin = Entity.get_by_id(origin_id) if origin_id else None
    form = build_form(class_, origin=origin)
    if form.validate_on_submit():
        return redirect(save(form, class_=class_, origin=origin))
    if hasattr(form, 'alias'):
        form.alias.append_entry('')
    view_name = g.classes[class_].view
    geonames_module = False
    if origin:
        populate_insert_form(form, view_name, class_, origin)
    else:
        geonames_module = True if ReferenceSystem.get_by_name('GeoNames').forms else False

    # Archaeological sub units
    structure = None
    gis_data = None
    overlays = None
    if view_name in ['artifact', 'place']:
        structure = get_structure(super_=origin)
        gis_data = Gis.get_all([origin] if origin else None, structure)
        overlays = Overlay.get_by_object(origin) \
            if origin and origin.class_.view == 'place' else None
    return render_template(
        'entity/insert.html',
        form=form,
        class_=class_,
        origin=origin,
        view_name=view_name,
        structure=structure,
        gis_data=gis_data,
        geonames_module=geonames_module,
        writeable=True if os.access(app.config['UPLOAD_DIR'], os.W_OK) else False,  # For files
        overlays=overlays,
        title=_(view_name),
        crumbs=add_crumbs(view_name, class_, origin, structure, insert_=True))


def add_crumbs(view_name: str,
               class_: str,
               origin: Union[Entity, None],
               structure: Optional[Dict[str, Any]],
               insert_: Optional[bool] = False) -> List[Any]:
    label = origin.class_.name if origin else view_name
    if label in g.class_view_mapping:
        label = g.class_view_mapping[label]
    label = _(label.replace('_', ' '))
    crumbs = [
        [label, url_for('index', view=origin.class_.view if origin else view_name)],
        link(origin)]
    if structure and (not origin or not origin.class_.name == 'artifact'):
        crumbs = [
            [_('place'), url_for('index', view='place')],
            structure['place'] if origin and origin.class_.name != 'place' else '',
            structure['feature'],
            structure['stratigraphic_unit'],
            link(origin)]
    if view_name == 'type':
        crumbs = [[_('types'), url_for('node_index')]]
        if isinstance(origin, Node) and origin.root:
            for node_id in reversed(origin.root):
                crumbs += [link(g.nodes[node_id])]
        crumbs += [origin]
    return crumbs + (['+ ' + g.classes[class_].label] if insert_ else [_('edit')])


@app.route('/update/<int:id_>', methods=['POST', 'GET'])
@required_group('contributor')
def update(id_: int) -> Union[str, Response]:
    entity = Entity.get_by_id(id_, nodes=True, aliases=True)
    if not entity.class_.view:
        abort(422)  # pragma: no cover
    elif not is_authorized(entity.class_.write_access):
        abort(403)  # pragma: no cover
    elif isinstance(entity, Node):
        root = g.nodes[entity.root[-1]] if entity.root else None
        if not root and (entity.standard or entity.locked):
            abort(403)  # pragma: no cover

    # Archaeological sub units
    geonames_module = False
    if entity.class_.name == 'place' and ReferenceSystem.get_by_name('GeoNames').forms:
        geonames_module = True
    structure = None
    gis_data = None
    overlays = None
    location = None

    if entity.class_.view in ['artifact', 'place']:
        structure = get_structure(entity)
        location = entity.get_linked_entity_safe('P53', nodes=True)
        gis_data = Gis.get_all([entity], structure)
        overlays = Overlay.get_by_object(entity)
        entity.image_id = entity.get_profile_image_id()
        if not entity.image_id:
            for link_ in entity.get_links('P67', inverse=True):
                domain = link_.domain
                if domain.class_.view == 'file':  # pragma: no cover
                    data = get_base_table_data(domain)
                    if data[3] in app.config['DISPLAY_FILE_EXTENSIONS']:
                        entity.image_id = domain.id
                        break
    form = build_form(entity.class_.name, entity, location=location)
    if entity.class_.view == 'event':
        form.event_id.data = entity.id
    elif isinstance(entity, ReferenceSystem) and entity.system:
        form.name.render_kw['readonly'] = 'readonly'
    if form.validate_on_submit():
        if isinstance(entity, Node):
            valid = True
            root = g.nodes[entity.root[-1]]
            new_super_id = getattr(form, str(root.id)).data
            new_super = g.nodes[int(new_super_id)] if new_super_id else None
            if new_super:
                if new_super.id == entity.id:
                    flash(_('error node self as super'), 'error')
                    valid = False
                if new_super.root and entity.id in new_super.root:
                    flash(_('error node sub as super'), 'error')
                    valid = False
            if not valid:
                return redirect(url_for('entity_view', id_=entity.id))
        if was_modified(form, entity):  # pragma: no cover
            del form.save
            flash(_('error modified'), 'error')
            return render_template(
                'entity/update.html',
                form=form,
                entity=entity,
                structure=structure,
                modifier=link(logger.get_log_for_advanced_view(entity.id)['modifier']))
        return redirect(save(form, entity))
    populate_update_form(form, entity)
    return render_template(
        'entity/update.html',
        form=form,
        entity=entity,
        structure=structure,
        gis_data=gis_data,
        overlays=overlays,
        geonames_module=geonames_module,
        title=entity.name,
        crumbs=add_crumbs(
            view_name=entity.class_.view,
            class_=entity.class_.name,
            origin=entity,
            structure=structure))


def populate_insert_form(form: FlaskForm,
                         view_name: str,
                         class_: str,
                         origin: Union[Entity, Node]) -> None:
    if view_name == 'source':
        if origin and origin.class_.name == 'artifact':
            form.artifact.data = [origin.id]
    elif view_name == 'actor':
        if origin.class_.name == 'place':
            form.residence.data = origin.id
    elif view_name == 'type':
        root_id = origin.root[-1] if origin.root else origin.id
        getattr(form, str(root_id)).data = origin.id if origin.id != root_id else None
    elif view_name == 'event':
        if origin.class_.view == 'artifact':
            form.artifact.data = [origin.id]
        elif origin.class_.view in ['artifact', 'place']:
            if class_ == 'move':
                form.place_from.data = origin.id
            else:
                form.place.data = origin.id


def populate_update_form(form: FlaskForm, entity: Union[Entity, Node]) -> None:
    if hasattr(form, 'alias'):
        for alias in entity.aliases.values():
            form.alias.append_entry(alias)
        form.alias.append_entry('')
    if entity.class_.view == 'actor':
        residence = entity.get_linked_entity('P74')
        form.residence.data = residence.get_linked_entity_safe('P53', True).id if residence else ''
        first = entity.get_linked_entity('OA8')
        form.begins_in.data = first.get_linked_entity_safe('P53', True).id if first else ''
        last = entity.get_linked_entity('OA9')
        form.ends_in.data = last.get_linked_entity_safe('P53', True).id if last else ''
    elif entity.class_.view == 'event':
        super_event = entity.get_linked_entity('P117')
        form.event.data = super_event.id if super_event else ''
        if entity.class_.name == 'move':
            place_from = entity.get_linked_entity('P27')
            form.place_from.data = place_from.get_linked_entity_safe(
                'P53', True).id if place_from else ''
            place_to = entity.get_linked_entity('P26')
            form.place_to.data = place_to.get_linked_entity_safe('P53', True).id if place_to else ''
            person_data = []
            object_data = []
            for entity in entity.get_linked_entities('P25'):
                if entity.class_.name == 'person':
                    person_data.append(entity.id)
                elif entity.class_.view == 'artifact':
                    object_data.append(entity.id)
            form.person.data = person_data
            form.artifact.data = object_data
        else:
            place = entity.get_linked_entity('P7')
            form.place.data = place.get_linked_entity_safe('P53', True).id if place else ''
        if entity.class_.name == 'acquisition':
            form.given_place.data = [entity.id for entity in entity.get_linked_entities('P24')]
    elif isinstance(entity, Node):
        if hasattr(form, 'name_inverse'):  # a directional node, e.g. actor actor relation
            name_parts = entity.name.split(' (')
            form.name.data = name_parts[0]
            if len(name_parts) > 1:
                form.name_inverse.data = name_parts[1][:-1]  # remove the ")" from 2nd part
        root = g.nodes[entity.root[-1]] if entity.root else entity
        if root:  # Set super if exists and is not same as root
            super_ = g.nodes[entity.root[0]]
            getattr(form, str(root.id)).data = super_.id if super_.id != root.id else None
    elif entity.class_.view == 'source':
        form.artifact.data = [item.id for item in entity.get_linked_entities('P128', inverse=True)]


def save(form: FlaskForm,
         entity: Optional[Entity] = None,
         class_: Optional[str] = None,
         origin: Optional[Entity] = None) -> Union[str, Response]:
    Transaction.begin()
    action = 'update'
    try:
        if not entity:
            action = 'insert'
            entity = insert_entity(form, class_, origin)
        if isinstance(entity, ReferenceSystem):
            entity.name = entity.name if hasattr(entity, 'system') and entity.system \
                else form.name.data
            entity.description = form.description.data
            entity.website_url = form.website_url.data if form.website_url.data else None
            entity.resolver_url = form.resolver_url.data if form.resolver_url.data else None
            entity.placeholder = form.placeholder.data if form.placeholder.data else None
            entity.update_system(form)
            if hasattr(form, 'forms'):
                entity.add_forms(form)
        else:
            entity.update(form)
            class_ = entity.class_.name
        update_links(entity, form, action, origin)
        url = link_and_get_redirect_url(form, entity, class_, origin)
        logger.log_user(entity.id, action)
        Transaction.commit()
        flash(_('entity created') if action == 'insert' else _('info update'), 'info')
    except InvalidGeomException as e:  # pragma: no cover
        Transaction.rollback()
        logger.log('error', 'database', 'transaction failed because of invalid geom', e)
        flash(_('Invalid geom entered'), 'error')
        if action == 'update' and entity:
            url = url_for('update', id_=entity.id, origin_id=origin.id if origin else None)
        else:
            url = url_for('index', view=g.classes[class_].view)
    except Exception as e:  # pragma: no cover
        Transaction.rollback()
        logger.log('error', 'database', 'transaction failed', e)
        flash(_('error transaction'), 'error')
        if action == 'update' and entity:
            url = url_for('update', id_=entity.id, origin_id=origin.id if origin else None)
        else:
            url = url_for('index', view=g.classes[class_].view)
            if class_ in ['administrative_unit', 'type']:
                url = url_for('node_index')
    return url


def insert_entity(form: FlaskForm,
                  class_: str,
                  origin: Optional[Union[Entity, Node]] = None
                  ) -> Union[Entity, Node, ReferenceSystem]:
    if class_ == 'artifact':
        entity = Entity.insert(class_, form.name.data)
        location = Entity.insert('object_location', 'Location of ' + form.name.data)
        entity.link('P53', location)
    elif class_ in ['place', 'human_remains', 'stratigraphic_unit', 'feature', 'find', 'artifact']:
        if class_ == 'human_remains':
            entity = Entity.insert(class_, form.name.data)
        elif origin and origin.class_.name == 'stratigraphic_unit':
            entity = Entity.insert('find', form.name.data)
        else:
            system_class = 'place'
            if origin and origin.class_.name == 'place':
                system_class = 'feature'
            elif origin and origin.class_.name == 'feature':
                system_class = 'stratigraphic_unit'
            entity = Entity.insert(system_class, form.name.data)
        entity.link('P53', Entity.insert('object_location', 'Location of ' + form.name.data))
    elif class_ == 'reference_system':
        entity = ReferenceSystem.insert_system(form)
    else:
        entity = Entity.insert(class_, form.name.data)
    if entity.class_.name == 'file':
        file_ = request.files['file']
        # Add an 'a' to prevent emtpy filename, this won't affect stored information
        filename = secure_filename('a' + file_.filename)  # type: ignore
        new_name = '{id}.{ext}'.format(id=entity.id, ext=filename.rsplit('.', 1)[1].lower())
        file_.save(str(app.config['UPLOAD_DIR'] / new_name))
    return entity


def update_links(entity: Entity, form: FlaskForm, action: str, origin: Optional[Entity]) -> None:
    if entity.class_.view in ['actor', 'event', 'place', 'artifact', 'type']:
        ReferenceSystem.update_links(form, entity)
    if entity.class_.view == 'actor':
        if action == 'update':
            entity.delete_links(['P74', 'OA8', 'OA9'])
        if form.residence.data:
            object_ = Entity.get_by_id(form.residence.data)
            entity.link('P74', object_.get_linked_entity_safe('P53'))
        if form.begins_in.data:
            object_ = Entity.get_by_id(form.begins_in.data)
            entity.link('OA8', object_.get_linked_entity_safe('P53'))
        if form.ends_in.data:
            object_ = Entity.get_by_id(form.ends_in.data)
            entity.link('OA9', object_.get_linked_entity_safe('P53'))
    if entity.class_.view == 'event':
        if action == 'update':
            entity.delete_links(['P7', 'P24', 'P25', 'P26', 'P27', 'P117'])
        if form.event.data:
            entity.link_string('P117', form.event.data)
        if hasattr(form, 'place') and form.place.data:
            entity.link('P7', Link.get_linked_entity_safe(int(form.place.data), 'P53'))
        if entity.class_.name == 'acquisition' and form.given_place.data:
            entity.link_string('P24', form.given_place.data)
        if entity.class_.name == 'move':
            if form.artifact.data:  # Moved objects
                entity.link_string('P25', form.artifact.data)
            if form.person.data:  # Moved persons
                entity.link_string('P25', form.person.data)
            if form.place_from.data:  # Link place for move from
                linked_place = Link.get_linked_entity_safe(int(form.place_from.data), 'P53')
                entity.link('P27', linked_place)
            if form.place_to.data:  # Link place for move to
                entity.link('P26', Link.get_linked_entity_safe(int(form.place_to.data), 'P53'))
    elif entity.class_.view in ['artifact', 'place']:
        location = entity.get_linked_entity_safe('P53')
        if action == 'update':
            Gis.delete_by_entity(location)
        location.update(form)
        Gis.insert(location, form)
    elif entity.class_.view == 'source' and not origin:
        if action == 'update':
            entity.delete_links(['P128'], inverse=True)
        if form.artifact.data:
            entity.link_string('P128', form.artifact.data, inverse=True)
    elif entity.class_.view == 'type':
        node = origin if isinstance(origin, Node) else entity
        root = g.nodes[node.root[-1]] if node.root else node
        super_id = g.nodes[node.root[0]] if node.root else node
        new_super_id = getattr(form, str(root.id)).data
        new_super = g.nodes[int(new_super_id)] if new_super_id else root
        if super_id != new_super.id:
            property_code = 'P127' if entity.class_.name == 'type' else 'P89'
            entity.delete_links([property_code])
            entity.link(property_code, new_super)


def link_and_get_redirect_url(form: FlaskForm,
                              entity: Entity,
                              class_: str,
                              origin: Union[Entity, None] = None) -> str:
    url = url_for('entity_view', id_=entity.id)
    if origin and class_ not in ('administrative_unit', 'type'):  # Can't be tested with isinstance
        url = url_for('entity_view', id_=origin.id) + '#tab-' + entity.class_.view
        if origin.class_.view == 'reference':
            link_id = origin.link('P67', entity)[0]
            url = url_for('reference_link_update', link_id=link_id, origin_id=origin.id)
        elif entity.class_.name == 'file':
            entity.link('P67', origin)
            url = url_for('entity_view', id_=origin.id) + '#tab-file'
        elif entity.class_.view == 'reference':
            link_id = entity.link('P67', origin)[0]
            url = url_for('reference_link_update', link_id=link_id, origin_id=origin.id)
        elif origin.class_.view in ['place', 'feature', 'stratigraphic_unit']:
            if entity.class_.view == 'place' or entity.class_.name == 'find':
                origin.link('P46', entity)
                url = url_for('entity_view', id_=entity.id)
        elif origin.class_.view in ['source', 'file']:
            origin.link('P67', entity)
        elif entity.class_.view == 'source':
            entity.link('P67', origin)
        elif origin.class_.view == 'event':  # Involvement, coming from actor
            link_id = origin.link('P11', entity)[0]
            url = url_for('involvement_update', id_=link_id, origin_id=origin.id)
        elif origin.class_.view == 'actor' and entity.class_.view == 'event':
            link_id = entity.link('P11', origin)[0]  # Involvement, coming from event
            url = url_for('involvement_update', id_=link_id, origin_id=origin.id)
        elif origin.class_.view == 'actor' and entity.class_.view == 'actor':
            link_id = origin.link('OA7', entity)[0]  # Actor with actor relation
            url = url_for('relation_update', id_=link_id, origin_id=origin.id)

    if hasattr(form, 'continue_') and form.continue_.data == 'yes':
        url = url_for('insert', class_=class_, origin_id=origin.id if origin else None)
        if class_ in ('administrative_unit', 'type'):  # Can't be tested with isinstance
            root_id = origin.root[-1] if isinstance(origin, Node) and origin.root else origin.id
            super_id = getattr(form, str(root_id)).data
            url = url_for('insert', class_=class_, origin_id=str(super_id) if super_id else root_id)
    elif hasattr(form, 'continue_') and form.continue_.data in ['sub', 'human_remains']:
        class_ = form.continue_.data
        if class_ == 'sub':
            if entity.class_.name == 'place':
                class_ = 'feature'
            elif entity.class_.name == 'feature':
                class_ = 'stratigraphic_unit'
            elif entity.class_.name == 'stratigraphic_unit':
                class_ = 'find'
        url = url_for('insert', class_=class_, origin_id=entity.id)
    return url

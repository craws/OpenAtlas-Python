from __future__ import annotations  # Needed for Python 4.0 type annotations

import time
from collections import OrderedDict
from typing import Any, Dict, List, Optional, Union

from flask import g, render_template, request
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm, widgets
from wtforms import (
    BooleanField, FieldList, FileField, HiddenField, SelectField, SelectMultipleField,
    StringField, SubmitField, TextAreaField, widgets)
from wtforms.validators import InputRequired, Optional as OptionalValidator, URL

from openatlas import app
from openatlas.forms import date
from openatlas.forms.field import (
    TableField, TableMultiField, TreeField, TreeMultiField, ValueFloatField)
from openatlas.forms.validation import validate
from openatlas.models.entity import Entity
from openatlas.models.link import Link
from openatlas.models.node import Node
from openatlas.models.reference_system import ReferenceSystem
from openatlas.util.display import get_base_table_data, uc_first
from openatlas.util.table import Table
from openatlas.util.util import get_file_stats

forms = {
    'acquisition': ['name', 'date', 'description', 'continue'],
    'activity': ['name', 'date', 'description', 'continue'],
    'actor_actor_relation': ['date', 'description', 'continue'],
    'administrative_unit': ['name', 'description', 'continue'],
    'artifact': ['name', 'date', 'description', 'continue', 'map'],
    'bibliography': ['name', 'description', 'continue'],
    'edition': ['name', 'description', 'continue'],
    'external_reference': ['name', 'description', 'continue'],
    'feature': ['name', 'date', 'description', 'continue', 'map'],
    'file': ['name', 'description'],
    'find': ['name', 'date', 'description', 'continue', 'map'],
    'group': ['name', 'alias', 'date', 'description', 'continue'],
    'hierarchy': ['name', 'description'],
    'human_remains': ['name', 'date', 'description', 'continue', 'map'],
    'involvement': ['date', 'description', 'continue'],
    'member': ['date', 'description', 'continue'],
    'move': ['name', 'date', 'description', 'continue'],
    'note': ['description'],
    'person': ['name', 'alias', 'date', 'description', 'continue'],
    'place': ['name', 'alias', 'date', 'description', 'continue', 'map'],
    'reference_system': ['name', 'description'],
    'source': ['name', 'description', 'continue'],
    'source_translation': ['name', 'description', 'continue'],
    'stratigraphic_unit': ['name', 'date', 'description', 'continue', 'map'],
    'type': ['name', 'date', 'description', 'continue']}


def build_form(
        class_: str,
        item: Optional[Union[Entity, Link, Node]] = None,
        code: Optional[str] = None,
        origin: Union[Entity, Node, None] = None,
        location: Optional[Entity] = None) -> FlaskForm:
    # Builds a dynamic form regarding types, module settings and class specific fields
    class Form(FlaskForm):  # type: ignore
        opened = HiddenField()
        validate = validate

    if class_ == 'note':
        setattr(Form, 'public', BooleanField(_('public'), default=False))
    if 'name' in forms[class_]:  # Set label and validators for name field
        label = _('URL') if class_ == 'external_reference' else _('name')
        validators = [InputRequired(), URL()] if class_ == 'external_reference' else [
            InputRequired()]
        setattr(
            Form,
            'name',
            StringField(label, validators=validators, render_kw={'autofocus': True}))

    if 'alias' in forms[class_]:
        setattr(Form, 'alias', FieldList(StringField(''), description=_('tooltip alias')))
    add_types(Form, class_)
    add_fields(Form, class_, code, item, origin)
    add_reference_systems(Form, class_)
    if 'date' in forms[class_]:
        date.add_date_fields(Form)
    if 'description' in forms[class_]:
        label = _('content') if class_ == 'source' else _('description')
        setattr(Form, 'description', TextAreaField(label))
        if class_ == 'type':  # Change description field if value type
            node = item if item else origin
            root = g.nodes[node.root[-1]] if node.root else node
            if root.value_type:
                del Form.description
                setattr(Form, 'description', StringField(_('unit')))
    if 'map' in forms[class_]:
        setattr(Form, 'gis_points', HiddenField(default='[]'))
        setattr(Form, 'gis_polygons', HiddenField(default='[]'))
        setattr(Form, 'gis_lines', HiddenField(default='[]'))
    add_buttons(Form, class_, item, origin)
    if not item or (request and request.method != 'GET'):
        form = Form()
    else:
        form = populate_form(Form(obj=item), item, location)
    customize_labels(class_, form, item, origin)
    return form


def populate_form(
        form: FlaskForm,
        item: Union[Entity, Link],
        location: Union[Entity, None]) -> FlaskForm:
    # Dates
    if hasattr(form, 'begin_year_from'):
        date.populate_dates(form, item)

    # Nodes
    nodes: Dict[Node, str] = item.nodes
    if location:  # Needed for administrative unit and historical place nodes
        nodes.update(location.nodes)
    form.opened.data = time.time()
    node_data: Dict[int, List[int]] = {}
    for node, node_value in nodes.items():
        root = g.nodes[node.root[-1]] if node.root else node
        if root.id not in node_data:
            node_data[root.id] = []
        node_data[root.id].append(node.id)
        if root.value_type:
            getattr(form, str(node.id)).data = node_value
    for root_id, nodes_ in node_data.items():
        if hasattr(form, str(root_id)):
            getattr(form, str(root_id)).data = nodes_
    if isinstance(item, Entity):
        populate_reference_systems(form, item)
    return form


def populate_reference_systems(form: FlaskForm, item: Entity) -> None:
    system_links = {
        link_.domain.id: link_ for link_ in item.get_links('P67', True)
        if link_.domain.class_.name == 'reference_system'}  # Can't use isinstance here
    for field in form:
        if field.id.startswith('reference_system_id_'):
            system_id = int(field.id.replace('reference_system_id_', ''))
            if system_id in system_links:
                field.data = system_links[system_id].description
                precision_field = getattr(form, f'reference_system_precision_{system_id}')
                precision_field.data = str(system_links[system_id].type.id)


def customize_labels(
        name: str,
        form: FlaskForm,
        item: Optional[Union[Entity, Link]] = None,
        origin: Union[Entity, Node, None] = None, ) -> None:
    if name == 'source_translation':
        form.description.label.text = _('content')
    if name in ('administrative_unit', 'type'):
        node = item if item else origin
        root = g.nodes[node.root[-1]] if node.root else node
        getattr(form, str(root.id)).label.text = 'super'


def add_buttons(
        form: Any,
        name: str,
        entity: Union[Entity, None],
        origin: Optional[Entity] = None) -> FlaskForm:
    setattr(form, 'save', SubmitField(_('save') if entity else _('insert')))
    if entity:
        return form
    if 'continue' in forms[name] \
            and (name in ['involvement', 'find', 'human_remains', 'type'] or not origin):
        setattr(form, 'insert_and_continue', SubmitField(uc_first(_('insert and continue'))))
        setattr(form, 'continue_', HiddenField())
    insert_and_add = uc_first(_('insert and add')) + ' '
    if name == 'place':
        setattr(form, 'insert_and_continue', SubmitField(uc_first(_('insert and continue'))))
        setattr(form, 'continue_', HiddenField())
        setattr(form, 'insert_continue_sub', SubmitField(insert_and_add + _('feature')))
    elif name == 'feature' and origin and origin.class_.name == 'place':
        setattr(form, 'insert_and_continue', SubmitField(uc_first(_('insert and continue'))))
        setattr(form, 'continue_', HiddenField())
        setattr(form, 'insert_continue_sub', SubmitField(insert_and_add + _('stratigraphic unit')))
    elif name == 'stratigraphic_unit':
        setattr(form, 'insert_and_continue', SubmitField(uc_first(_('insert and continue'))))
        setattr(form, 'continue_', HiddenField())
        setattr(form, 'insert_continue_sub', SubmitField(insert_and_add + _('find')))
        setattr(
            form,
            'insert_continue_human_remains',
            SubmitField(insert_and_add + _('human remains')))
    return form


def add_reference_systems(form: Any, form_name: str) -> None:
    precision_nodes = Node.get_hierarchy('External reference match').subs
    precisions = [('', '')] + [(str(g.nodes[id_].id), g.nodes[id_].name) for id_ in precision_nodes]
    systems = list(g.reference_systems.values())
    systems.sort(key=lambda x: x.name.casefold())
    for system in systems:
        if form_name not in [form_['name'] for form_ in system.get_forms().values()]:
            continue
        setattr(
            form,
            f'reference_system_id_{system.id}',
            StringField(
                uc_first(system.name),
                validators=[OptionalValidator()],
                description=system.description,
                render_kw={'autocomplete': 'off', 'placeholder': system.placeholder}))
        setattr(
            form,
            f'reference_system_precision_{system.id}',
            SelectField(_('precision'), choices=precisions, default=system.precision_default_id))


def add_value_type_fields(form: Any, subs: List[int]) -> None:
    for sub_id in subs:
        sub = g.nodes[sub_id]
        setattr(form, str(sub.id), ValueFloatField(sub.name, [OptionalValidator()]))
        add_value_type_fields(form, sub.subs)


def add_types(form: Any, class_: str) -> None:
    types = OrderedDict(Node.get_nodes_for_form(class_))
    for node in types.values():  # Move standard type to top
        if node.standard and node.class_.name == 'type':
            types.move_to_end(node.id, last=False)
            break

    for node in types.values():
        if node.multiple:
            setattr(form, str(node.id), TreeMultiField(str(node.id)))
        else:
            setattr(form, str(node.id), TreeField(str(node.id)))
        if node.value_type:
            add_value_type_fields(form, node.subs)


def add_fields(
        form: Any,
        class_: str,
        code: Union[str, None],
        item: Union[Entity, Node, Link, None],
        origin: Union[Entity, Node, None]) -> None:
    if class_ == 'actor_actor_relation':
        setattr(form, 'inverse', BooleanField(_('inverse')))
        if not item:
            setattr(form, 'actor', TableMultiField(_('actor'), [InputRequired()]))
            setattr(form, 'relation_origin_id', HiddenField())
    elif class_ in ['activity', 'acquisition', 'move']:
        setattr(form, 'event_id', HiddenField())
        setattr(form, 'event', TableField(_('sub event of')))
        if class_ == 'activity':
            setattr(form, 'place', TableField(_('location')))
        if class_ == 'acquisition':
            setattr(form, 'place', TableField(_('location')))
            setattr(form, 'given_place', TableMultiField(_('given place')))
        elif class_ == 'move':
            setattr(form, 'place_from', TableField(_('from')))
            setattr(form, 'place_to', TableField(_('to')))
            setattr(form, 'artifact', TableMultiField())
            setattr(form, 'person', TableMultiField())
    elif class_ == 'file' and not item:
        setattr(form, 'file', FileField(_('file'), [InputRequired()]))
    elif class_ == 'group':
        setattr(form, 'residence', TableField(_('residence')))
        setattr(form, 'begins_in', TableField(_('begins in')))
        setattr(form, 'ends_in', TableField(_('ends in')))
    elif class_ == 'hierarchy':
        if code == 'custom' or (item and not item.value_type):
            setattr(form, 'multiple', BooleanField(
                _('multiple'),
                description=_('tooltip hierarchy multiple')))
        setattr(form, 'forms', SelectMultipleField(
            _('classes'),
            render_kw={'disabled': True},
            description=_('tooltip hierarchy forms'),
            choices=[],
            option_widget=widgets.CheckboxInput(),
            widget=widgets.ListWidget(prefix_label=False),
            coerce=int))
    elif class_ == 'involvement':
        if not item and origin:
            involved_with = 'actor' if origin.class_.view == 'event' else 'event'
            setattr(form, involved_with, TableMultiField(_(involved_with), [InputRequired()]))
        setattr(form, 'activity', SelectField(_('activity')))
    elif class_ == 'member' and not item:
        setattr(form, 'member_origin_id', HiddenField())
        setattr(
            form,
            'actor' if code == 'member' else 'group',
            TableMultiField(_('actor'), [InputRequired()]))
    elif class_ in g.classes and g.classes[class_].view == 'type':
        setattr(form, 'is_node_form', HiddenField())
        node = item if item else origin
        root = g.nodes[node.root[-1]] if node.root else node
        setattr(form, str(root.id), TreeField(str(root.id)))
        if root.directional:
            setattr(form, 'name_inverse', StringField(_('inverse')))
    elif class_ == 'person':
        setattr(form, 'residence', TableField(_('residence')))
        setattr(form, 'begins_in', TableField(_('born in')))
        setattr(form, 'ends_in', TableField(_('died in')))
    elif class_ == 'reference_system':
        setattr(
            form,
            'website_url',
            StringField(_('website URL'), validators=[OptionalValidator(), URL()]))
        setattr(
            form,
            'resolver_url',
            StringField(_('resolver URL'), validators=[OptionalValidator(), URL()]))
        setattr(form, 'placeholder', StringField(_('example ID')))
        precision_node_id = str(Node.get_hierarchy('External reference match').id)
        setattr(form, precision_node_id, TreeField(precision_node_id))
        choices = ReferenceSystem.get_form_choices(item)
        if choices:
            setattr(form, 'forms', SelectMultipleField(
                _('classes'),
                render_kw={'disabled': True},
                choices=choices,
                option_widget=widgets.CheckboxInput(),
                widget=widgets.ListWidget(prefix_label=False),
                coerce=int))
    elif class_ == 'source':
        setattr(form, 'artifact', TableMultiField())


def build_add_reference_form(class_: str) -> FlaskForm:
    class Form(FlaskForm):  # type: ignore
        pass

    setattr(Form, class_, TableField(_(class_), [InputRequired()]))
    setattr(Form, 'page', StringField(_('page')))
    setattr(Form, 'save', SubmitField(uc_first(_('insert'))))
    return Form()


def build_table_form(class_: str, linked_entities: List[Entity]) -> str:
    """Returns a form with a list of entities with checkboxes."""
    if class_ == 'place':
        entities = Entity.get_by_class('place', nodes=True, aliases=True)
    else:
        entities = Entity.get_by_view(class_, nodes=True, aliases=True)

    linked_ids = [entity.id for entity in linked_entities]
    table = Table([''] + g.table_headers[class_], order=[[1, 'asc']])
    file_stats = get_file_stats() if class_ == 'file' else None
    for entity in entities:
        if entity.id in linked_ids:
            continue  # Don't show already linked entries
        input_ = f"""
            <input id="selection-{entity.id}" name="values" type="checkbox" value="{entity.id}">"""
        table.rows.append([input_] + get_base_table_data(entity, file_stats))
    if not table.rows:
        return uc_first(_('no entries'))
    return render_template('forms/form_table.html', table=table.display(class_))


def build_move_form(node: Node) -> FlaskForm:
    class Form(FlaskForm):  # type: ignore
        is_node_form = HiddenField()
        checkbox_values = HiddenField()
        selection = SelectMultipleField(
            '',
            [InputRequired()],
            coerce=int,
            option_widget=widgets.CheckboxInput(),
            widget=widgets.ListWidget(prefix_label=False))
        save = SubmitField(uc_first(_('move entities')))

    root = g.nodes[node.root[-1]]
    setattr(Form, str(root.id), TreeField(str(root.id)))
    form = Form(obj=node)
    choices = []
    if root.class_.name == 'administrative_unit':
        for entity in node.get_linked_entities('P89', True):
            place = entity.get_linked_entity('P53', True)
            if place:
                choices.append((entity.id, place.name))
    elif root.name in app.config['PROPERTY_TYPES']:
        for row in Link.get_entities_by_node(node):
            domain = Entity.get_by_id(row['domain_id'])
            range_ = Entity.get_by_id(row['range_id'])
            choices.append((row['id'], domain.name + ' - ' + range_.name))
    else:
        for entity in node.get_linked_entities('P2', True):
            choices.append((entity.id, entity.name))
    form.selection.choices = choices
    return form

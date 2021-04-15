from __future__ import annotations  # Needed for Python 4.0 type annotations

import ast
from typing import Any, Dict, Iterable, List, Optional, Set, TYPE_CHECKING, Type, Union

from flask import g, request
from flask_wtf import FlaskForm
from fuzzywuzzy import fuzz
from werkzeug.exceptions import abort

from openatlas import app
from openatlas.database.entity import Entity as Db
from openatlas.forms.date import format_date
from openatlas.models.date import Date
from openatlas.models.link import Link
from openatlas.util.display import get_file_extension, link

if TYPE_CHECKING:  # pragma: no cover - Type checking is disabled in tests
    from openatlas.models.node import Node
    from openatlas.models.reference_system import ReferenceSystem


class Entity:

    def __init__(self, data: Dict[str, Any]) -> None:

        self.id = data['id']
        self.nodes: Dict['Node', str] = {}

        if 'nodes' in data and data['nodes']:
            for node in data['nodes']:
                self.nodes[g.nodes[node['f1']]] = node['f2']  # f1 = node id, f2 = value
        self.aliases: Dict[int, str] = {}
        if 'aliases' in data and data['aliases']:
            for alias in data['aliases']:
                self.aliases[alias['f1']] = alias['f2']  # f1 = alias id, f2 = alias name
            self.aliases = {k: v for k, v in sorted(self.aliases.items(), key=lambda item: item[1])}
        self.name = data['name']
        self.description = data['description']
        self.created = data['created']
        self.modified = data['modified']
        self.cidoc_class = g.cidoc_classes[data['class_code']]
        self.class_ = g.classes[data['system_class']]
        self.reference_systems: List[Link] = []  # Links to external reference systems
        self.origin_id: Optional[int] = None  # For navigation when coming from another entity
        self.image_id: Optional[int] = None  # Profile image
        self.linked_places: List[Entity] = []  # Related places for map
        self.location: Optional[Entity] = None  # Respective location if entity is a place
        self.info_data: Dict[str, Union[str, List[str], None]]  # Used for detail views

        # Dates
        self.begin_from = None
        self.begin_to = None
        self.begin_comment = None
        self.end_from = None
        self.end_to = None
        self.end_comment = None
        self.first = None
        self.last = None
        if 'begin_from' in data:
            self.begin_from = Date.timestamp_to_datetime64(data['begin_from'])
            self.begin_to = Date.timestamp_to_datetime64(data['begin_to'])
            self.begin_comment = data['begin_comment']
            self.end_from = Date.timestamp_to_datetime64(data['end_from'])
            self.end_to = Date.timestamp_to_datetime64(data['end_to'])
            self.end_comment = data['end_comment']
            self.first = format_date(self.begin_from, 'year') if self.begin_from else None
            self.last = format_date(self.end_from, 'year') if self.end_from else None
            self.last = format_date(self.end_to, 'year') if self.end_to else self.last

    def get_linked_entity(
            self,
            code: str,
            inverse: bool = False,
            nodes: bool = False) -> Optional[Entity]:
        return Link.get_linked_entity(self.id, code, inverse=inverse, nodes=nodes)

    def get_linked_entity_safe(
            self,
            code: str,
            inverse: bool = False,
            nodes: bool = False) -> Entity:
        return Link.get_linked_entity_safe(self.id, code, inverse, nodes)

    def get_linked_entities(
            self,
            code: Union[str, List[str]],
            inverse: bool = False,
            nodes: bool = False) -> List[Entity]:
        return Link.get_linked_entities(self.id, code, inverse=inverse, nodes=nodes)

    def link(self,
             code: str,
             range_: Union[Entity, List[Entity]],
             description: Optional[str] = None,
             inverse: bool = False,
             type_id: Optional[int] = None) -> List[int]:
        return Link.insert(self, code, range_, description, inverse, type_id)

    def link_string(
            self,
            code: str,
            range_: str,
            description: Optional[str] = None,
            inverse: bool = False) -> List[int]:
        # range_ = string value from a form, can be empty, an int or an int list presentation
        # e.g. '', '1', '[]', '[1, 2]'
        ids = ast.literal_eval(range_)
        ids = [int(id_) for id_ in ids] if isinstance(ids, list) else [int(ids)]
        return Link.insert(self, code, Entity.get_by_ids(ids), description, inverse)

    def get_links(self, codes: Union[str, List[str]], inverse: bool = False) -> List[Link]:
        return Link.get_links(self.id, codes, inverse)

    def delete(self) -> None:
        Entity.delete_(self.id)

    def delete_links(self, codes: List[str], inverse: bool = False) -> None:
        Link.delete_by_codes(self, codes, inverse)

    def update(self, form: Optional[FlaskForm] = None) -> None:
        from openatlas.util.display import sanitize
        if form:  # e.g. imports have no forms
            self.save_nodes(form)
            if self.class_.name != 'object_location':
                self.set_dates(form)
                self.update_aliases(form)
            for field in ['name', 'description']:
                if hasattr(form, field):
                    setattr(self, field, getattr(form, field).data)
            if hasattr(form, 'name_inverse'):  # A directional node, e.g. actor actor relation
                self.name = form.name.data.replace('(', '').replace(')', '').strip()
                if form.name_inverse.data.strip():
                    inverse = form.name_inverse.data.replace('(', '').replace(')', '').strip()
                    self.name += ' (' + inverse + ')'
        if self.class_.name == 'type':
            self.name = sanitize(self.name, 'node')
        elif self.class_.name == 'object_location':
            self.name = 'Location of ' + self.name
            self.description = None
        Db.update({
            'id': self.id,
            'name': str(self.name).strip(),
            'begin_from': Date.datetime64_to_timestamp(self.begin_from),
            'begin_to': Date.datetime64_to_timestamp(self.begin_to),
            'end_from': Date.datetime64_to_timestamp(self.end_from),
            'end_to': Date.datetime64_to_timestamp(self.end_to),
            'begin_comment': str(self.begin_comment).strip() if self.begin_comment else None,
            'end_comment': str(self.end_comment).strip() if self.end_comment else None,
            'description': sanitize(self.description, 'text')})

    def update_aliases(self, form: FlaskForm) -> None:
        if not hasattr(form, 'alias'):
            return
        old_aliases = self.aliases
        new_aliases = form.alias.data
        delete_ids = []
        for id_, alias in old_aliases.items():  # Compare old aliases with form values
            if alias in new_aliases:
                new_aliases.remove(alias)
            else:
                delete_ids.append(id_)
        Entity.delete_(delete_ids)  # Delete obsolete aliases
        for alias in new_aliases:  # Insert new aliases if not empty
            if alias.strip():
                if self.class_.view == 'actor':
                    self.link('P131', Entity.insert('actor_appellation', alias))
                else:
                    self.link('P1', Entity.insert('appellation', alias))

    def save_nodes(self, form: FlaskForm) -> None:
        from openatlas.models.node import Node
        Node.save_entity_nodes(self, form)

    def set_dates(self, form: FlaskForm) -> None:
        if not hasattr(form, 'begin_year_from'):
            return
        self.begin_from = None
        self.begin_to = None
        self.begin_comment = None
        self.end_from = None
        self.end_to = None
        self.end_comment = None
        if form.begin_year_from.data:  # Only if begin year is set create a begin date or time span
            self.begin_comment = form.begin_comment.data
            self.begin_from = Date.form_to_datetime64(
                form.begin_year_from.data,
                form.begin_month_from.data,
                form.begin_day_from.data)
            self.begin_to = Date.form_to_datetime64(
                form.begin_year_to.data,
                form.begin_month_to.data,
                form.begin_day_to.data,
                to_date=True)

        if form.end_year_from.data:  # Only if end year is set create a year date or time span
            self.end_comment = form.end_comment.data
            self.end_from = Date.form_to_datetime64(
                form.end_year_from.data,
                form.end_month_from.data,
                form.end_day_from.data)
            self.end_to = Date.form_to_datetime64(
                form.end_year_to.data,
                form.end_month_to.data,
                form.end_day_to.data,
                to_date=True)

    def get_profile_image_id(self) -> Optional[int]:
        return Db.get_profile_image_id(self.id)

    def remove_profile_image(self) -> None:
        Db.remove_profile_image(self.id)

    def print_standard_type(self) -> str:
        from openatlas.models.node import Node
        if not self.class_.standard_type:
            return ''
        root_id = Node.get_hierarchy(self.class_.standard_type).id
        for node in self.nodes:
            if node.root and node.root[-1] == root_id:
                return link(node)
        return ''

    def get_name_directed(self, inverse: bool = False) -> str:
        """ Returns name part of a directed type e.g. actor actor relation: parent of (child of)"""
        from openatlas.util.display import sanitize
        name_parts = self.name.split(' (')
        if inverse and len(name_parts) > 1:  # pragma: no cover
            return sanitize(name_parts[1], 'node')
        return name_parts[0]

    @staticmethod
    def delete_(id_: Union[int, List[int]]) -> None:
        if not id_:
            return
        Db.delete(id_ if isinstance(id_, list) else [id_])

    @staticmethod
    def get_by_class(
            classes: Union[str, List[str]],
            nodes: bool = False,
            aliases: bool = False) -> List[Entity]:
        return [Entity(row) for row in Db.get_by_class(classes, nodes, aliases)]

    @staticmethod
    def get_by_view(view: str, nodes: bool = False, aliases: bool = False) -> List[Entity]:
        return Entity.get_by_class(g.view_class_mapping[view], nodes, aliases)

    @staticmethod
    def get_display_files() -> List[Entity]:
        entities = []
        for row in Db.get_by_class('file', nodes=True):
            if get_file_extension(row['id']) in app.config['DISPLAY_FILE_EXTENSIONS']:
                entities.append(Entity(row))
        return entities

    @staticmethod
    def insert(class_name: str, name: str, description: Optional[str] = None) -> Entity:
        from openatlas.util.display import sanitize
        if not name:  # pragma: no cover
            from openatlas import logger
            logger.log('error', 'model', 'Insert entity without name')
            abort(422)
        id_ = Db.insert({
            'name': str(name).strip(),
            'code': g.classes[class_name].cidoc_class.code,
            'system_class': class_name,
            'description': sanitize(description, 'text') if description else None})
        return Entity.get_by_id(id_)

    @staticmethod
    def get_by_id(
            id_: int,
            nodes: bool = False,
            aliases: bool = False) -> Union[Entity, Node, 'ReferenceSystem']:
        if id_ in g.nodes:
            return g.nodes[id_]
        if id_ in g.reference_systems:
            return g.reference_systems[id_]
        data = Db.get_by_id(id_, nodes, aliases)
        if not data:
            if 'activity' in request.path:
                raise AttributeError  # pragma: no cover, re-raise if user activity view
            abort(418)
        return Entity(data)

    @staticmethod
    def get_by_ids(
            ids: Iterable[int],
            nodes: bool = False,
            aliases: bool = False) -> List[Entity, Type, ReferenceSystem]:
        entities = []
        for row in Db.get_by_ids(ids, nodes, aliases):
            if row['id'] in g.nodes:
                entities.append(g.nodes[row['id']])
            elif row['id'] in g.reference_systems:
                entities.append(g.reference_systems[row['id']])
            else:
                entities.append(Entity(row))
        return entities

    @staticmethod
    def get_by_project_id(project_id: int) -> List[Entity]:
        entities = []
        for row in Db.get_by_project_id(project_id):
            entity = Entity(row)
            entity.origin_id = ['origin_id']
            entities.append(entity)
        return entities

    @staticmethod
    def get_by_cidoc_class(code: Union[str, List[str]]) -> List[Entity]:
        return [Entity(row) for row in Db.get_by_cidoc_class(code)]

    @staticmethod
    def get_similar_named(form: FlaskForm) -> Dict[int, Any]:
        similar: Dict[int, Any] = {}
        already_added: Set[int] = set()
        entities = Entity.get_by_class(form.classes.data)
        for sample in entities:
            if sample.id in already_added:
                continue
            similar[sample.id] = {'entity': sample, 'entities': []}
            for entity in entities:
                if sample.id == entity.id:
                    continue
                if fuzz.ratio(sample.name, entity.name) >= form.ratio.data:
                    already_added.add(sample.id)
                    already_added.add(entity.id)
                    similar[sample.id]['entities'].append(entity)
        return {similar: data for similar, data in similar.items() if data['entities']}

    @staticmethod
    def get_overview_counts() -> Dict[str, int]:
        return Db.get_overview_counts(g.class_view_mapping.keys())

    @staticmethod
    def get_orphans() -> List[Entity]:
        return [Entity.get_by_id(row['id']) for row in Db.get_orphans()]

    @staticmethod
    def get_latest(limit: int) -> List[Entity]:
        return [Entity(row) for row in Db.get_latest(g.class_view_mapping.keys(), limit)]

    @staticmethod
    def set_profile_image(id_: int, origin_id: int) -> None:
        Db.set_profile_image(id_, origin_id)

    @staticmethod
    def get_circular() -> List[Entity]:  # Get entities that are linked to itself.
        return [Entity.get_by_id(row['domain_id']) for row in Db.get_circular()]

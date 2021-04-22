from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import Any, Dict, List, Optional, TYPE_CHECKING, Union

from flask import abort, flash, g, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm

from openatlas import logger
from openatlas.database.link import Link as Db
from openatlas.models.date import Date
from openatlas.util.display import link, uc_first

if TYPE_CHECKING:  # pragma: no cover - Type checking is disabled in tests
    from openatlas.models.entity import Entity


class Link:
    object_: Optional['Entity']

    def __init__(
            self,
            row: Dict[str, Any],
            domain: Optional['Entity'] = None,
            range_: Optional['Entity'] = None) -> None:
        from openatlas.models.entity import Entity
        from openatlas.forms.date import format_date
        self.id = row['id']
        self.description = row['description']
        self.property = g.properties[row['property_code']]
        self.domain = domain if domain else Entity.get_by_id(row['domain_id'])
        self.range = range_ if range_ else Entity.get_by_id(row['range_id'])
        self.type = g.nodes[row['type_id']] if row['type_id'] else None
        self.nodes: Dict['Entity', None] = {}
        if 'type_id' in row and row['type_id']:
            self.nodes[g.nodes[row['type_id']]] = None
        if 'begin_from' in row:
            self.begin_from = Date.timestamp_to_datetime64(row['begin_from'])
            self.begin_to = Date.timestamp_to_datetime64(row['begin_to'])
            self.begin_comment = row['begin_comment']
            self.end_from = Date.timestamp_to_datetime64(row['end_from'])
            self.end_to = Date.timestamp_to_datetime64(row['end_to'])
            self.end_comment = row['end_comment']
            self.first = format_date(self.begin_from, 'year') if self.begin_from else None
            self.last = format_date(self.end_from, 'year') if self.end_from else None
            self.last = format_date(self.end_to, 'year') if self.end_to else self.last

    def update(self) -> None:
        Db.update({
            'id': self.id,
            'property_code': self.property.code,
            'domain_id': self.domain.id,
            'range_id': self.range.id,
            'type_id': self.type.id if self.type else None,
            'description': self.description,
            'begin_from': Date.datetime64_to_timestamp(self.begin_from),
            'begin_to': Date.datetime64_to_timestamp(self.begin_to),
            'begin_comment': self.begin_comment,
            'end_from': Date.datetime64_to_timestamp(self.end_from),
            'end_to': Date.datetime64_to_timestamp(self.end_to),
            'end_comment': self.end_comment})

    def delete(self) -> None:
        Link.delete_(self.id)

    def set_dates(self, form: FlaskForm) -> None:
        self.begin_from = None
        self.begin_to = None
        self.begin_comment = None
        self.end_from = None
        self.end_to = None
        self.end_comment = None
        if form.begin_year_from.data:  # Only if begin year is set create a begin date or time span
            self.begin_from = Date.form_to_datetime64(
                form.begin_year_from.data, form.begin_month_from.data, form.begin_day_from.data)
            self.begin_to = Date.form_to_datetime64(
                form.begin_year_to.data, form.begin_month_to.data, form.begin_day_to.data, True)
            self.begin_comment = form.begin_comment.data
        if form.end_year_from.data:  # Only if end year is set create a year date or time span
            self.end_from = Date.form_to_datetime64(
                form.end_year_from.data, form.end_month_from.data, form.end_day_from.data)
            self.end_to = Date.form_to_datetime64(
                form.end_year_to.data, form.end_month_to.data, form.end_day_to.data, True)
            self.end_comment = form.end_comment.data

    @staticmethod
    def insert(
            entity: 'Entity',
            property_code: str,
            range_: Union['Entity', List['Entity']],
            description: Optional[str] = None,
            inverse: bool = False,
            type_id: Optional[int] = None) -> List[int]:
        property_ = g.properties[property_code]
        entities = range_ if isinstance(range_, list) else [range_]
        new_link_ids = []
        for linked_entity in entities:
            domain = linked_entity if inverse else entity
            range_ = entity if inverse else linked_entity
            domain_error = True
            range_error = True
            if property_.find_object('domain_class_code', domain.class_.cidoc_class.code):
                domain_error = False
            if property_.find_object('range_class_code', range_.class_.cidoc_class.code):
                range_error = False
            if domain_error or range_error:
                text = _('error link') + ': ' + domain.class_.cidoc_class.code + ' > '
                text += property_code + ' > ' + range_.class_.cidoc_class.code
                logger.log('error', 'model', text)
                flash(text, 'error')
                continue
            id_ = Db.insert({
                'property_code': property_code,
                'domain_id': domain.id,
                'range_id': range_.id,
                'description': description,
                'type_id': type_id})
            new_link_ids.append(id_)
        return new_link_ids

    @staticmethod
    def get_linked_entity(
            id_: int,
            code: str,
            inverse: bool = False,
            nodes: bool = False) -> 'Entity':
        result = Link.get_linked_entities(id_, [code], inverse=inverse, nodes=nodes)
        if len(result) > 1:  # pragma: no cover
            logger.log('error', 'model', 'Multiple linked entities found for ' + code)
            flash(_('error multiple linked entities found'), 'error')
            abort(400)
        return result[0] if result else None

    @staticmethod
    def get_linked_entities(
            id_: int,
            codes: Union[str, List[str]],
            inverse: bool = False,
            nodes: bool = False) -> List['Entity']:
        from openatlas.models.entity import Entity
        codes = codes if isinstance(codes, list) else [codes]
        return Entity.get_by_ids(
            Db.get_linked_entities(id_, codes, inverse),
            nodes=nodes)

    @staticmethod
    def get_linked_entity_safe(
            id_: int, code: str,
            inverse: bool = False,
            nodes: bool = False) -> 'Entity':
        entity = Link.get_linked_entity(id_, code, inverse, nodes)
        if not entity:  # pragma: no cover - should return an entity so abort if not
            flash('Missing linked ' + code + ' for ' + str(id_), 'error')
            logger.log('error', 'model', 'missing linked', 'id: ' + str(id_) + 'code: ' + code)
            abort(418)
        return entity

    @staticmethod
    def get_links(
            entity_id: int,
            codes: Union[str, List[str], None] = None,
            inverse: bool = False) -> List[Link]:
        from openatlas.models.entity import Entity
        entity_ids = set()
        result = Db.get_links(entity_id, codes if isinstance(codes, list) else [codes], inverse)
        for row in result:
            entity_ids.add(row['domain_id'])
            entity_ids.add(row['range_id'])
        entities = {entity.id: entity for entity in Entity.get_by_ids(entity_ids, nodes=True)}
        links = []
        for row in result:
            links.append(Link(
                row,
                domain=entities[row['domain_id']],
                range_=entities[row['range_id']]))
        return links

    @staticmethod
    def delete_by_codes(entity: 'Entity', codes: List[str], inverse: bool = False) -> None:
        Db.delete_by_codes(entity.id, codes, inverse)

    @staticmethod
    def get_by_id(id_: int) -> Link:
        return Link(Db.get_by_id(id_))

    @staticmethod
    def get_entities_by_node(node: 'Entity') -> List[Dict[str, Any]]:
        return Db.get_entities_by_node(node.id)

    @staticmethod
    def delete_(id_: int) -> None:
        Db.delete_(id_)

    @staticmethod
    def check_links() -> List[Dict[str, str]]:
        """Check links for CIDOC CRM validity and return the invalid ones."""
        from openatlas.util.display import link
        from openatlas.models.entity import Entity
        invalid_links = []
        for row in Db.get_cidoc_links():
            property_ = g.properties[row['property']]
            domain_is_valid = property_.find_object('domain_class_code', row['domain'])
            range_is_valid = property_.find_object('range_class_code', row['range'])
            invalid_linking = []
            if not domain_is_valid or not range_is_valid:
                invalid_linking.append(row)
            for item in invalid_linking:
                for row2 in Db.get_invalid_links(item):
                    domain = Entity.get_by_id(row2['domain_id'])
                    range_ = Entity.get_by_id(row2['range_id'])
                    invalid_links.append({
                        'domain': link(domain) + ' (' + domain.cidoc_class.code + ')',
                        'property': link(g.properties[row2['property_code']]),
                        'range': link(range_) + ' (' + range_.cidoc_class.code + ')'})
        return invalid_links

    @staticmethod
    def check_link_duplicates() -> List[Dict[str, Any]]:
        return Db.check_link_duplicates()

    @staticmethod
    def delete_link_duplicates() -> int:
        return Db.delete_link_duplicates()

    @staticmethod
    def check_single_type_duplicates() -> List[List[str]]:
        from openatlas.models.node import Node
        from openatlas.models.entity import Entity
        data = []
        for node in g.nodes.values():
            if node.root or node.multiple or node.value_type:
                continue  # pragma: no cover
            node_ids = Node.get_all_sub_ids(node)
            if not node_ids:
                continue  # pragma: no cover
            for id_ in Db.check_single_type_duplicates(node_ids):
                offending_nodes = []
                entity = Entity.get_by_id(id_, nodes=True)
                for entity_node in entity.nodes:
                    if g.nodes[entity_node.root[-1]].id != node.id:
                        continue  # pragma: no cover
                    url = url_for(
                        'admin_delete_single_type_duplicate',
                        entity_id=entity.id,
                        node_id=entity_node.id)
                    offending_nodes.append(
                        f'<a href="{url}">{uc_first(_("remove"))}</a> {entity_node.name}')
                data.append([
                    link(entity),
                    entity.class_.name,
                    link(g.nodes[node.id]),
                    '<br><br><br><br><br>'.join(offending_nodes)])
        return data

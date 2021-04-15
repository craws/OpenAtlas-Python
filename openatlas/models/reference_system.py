from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import Any, Dict, List, Tuple, Union

from flask import g
from flask_wtf import FlaskForm

from openatlas.database.reference_system import ReferenceSystem as Db
from openatlas.models.entity import Entity


class ReferenceSystem(Entity):

    EXTERNAL_REFERENCES_FORMS = [
        'acquisition', 'activity', 'artifact', 'feature', 'find', 'group', 'human_remains', 'move',
        'person', 'place', 'type']

    website_url = None
    resolver_url = None
    placeholder = None
    system = False

    def __init__(self, row: Dict[str, Any]) -> None:

        super().__init__(row)
        self.website_url = row['website_url']
        self.resolver_url = row['resolver_url']
        self.forms = row['form_ids']
        self.placeholder = row['identifier_example']
        self.precision_default_id = row['precision_default_id']
        self.count = row['count']
        self.system = row['system']

    @staticmethod
    def get_all() -> Dict[int, ReferenceSystem]:
        return {row['id']: ReferenceSystem(row) for row in Db.get_all()}

    @staticmethod
    def get_by_name(name: str) -> ReferenceSystem:
        for system in g.reference_systems.values():
            if system.name == name:
                return system

    def add_forms(self, form: FlaskForm) -> None:
        Db.add_forms(self.id, form.forms.data)

    def remove_form(self, form_id: int) -> None:
        forms = self.get_forms()
        for link_ in self.get_links('P67'):
            if link_.range.class_.name == forms[form_id]['name']:  # pragma: no cover
                return  # Abort if there are linked entities
        Db.remove_form(self.id, form_id)

    def get_forms(self) -> Dict[int, Dict[str, Any]]:
        return {row['id']: {'name': row['name']} for row in Db.get_forms(self.id)}

    def update_system(self, form: FlaskForm) -> None:
        self.update(form)
        precision_default_id = None
        entity_with_updated_nodes = Entity.get_by_id(self.id, nodes=True)
        if entity_with_updated_nodes.nodes:  # Get default precision id if it was set
            precision_default_id = list(entity_with_updated_nodes.nodes.keys())[0].id
        Db.update_system({
            'entity_id': self.id,
            'name': self.name,
            'website_url': self.website_url,
            'resolver_url': self.resolver_url,
            'identifier_example': self.placeholder,
            'precision_default_id': precision_default_id})

    @staticmethod
    def update_links(form: FlaskForm, entity: Entity) -> None:
        for field in form:
            if field.id.startswith('reference_system_id_'):  # Delete and recreate link
                system = Entity.get_by_id(int(field.id.replace('reference_system_id_', '')))
                precision_field = getattr(form, field.id.replace('id_', 'precision_'))
                Db.remove_link(system.id, entity.id)
                if field.data:
                    system.link('P67', entity, field.data, type_id=precision_field.data)

    @staticmethod
    def get_form_choices(entity: Union[ReferenceSystem, None]) -> List[Tuple[int, str]]:
        choices = []
        for row in Db.get_form_choices(ReferenceSystem.EXTERNAL_REFERENCES_FORMS):
            if not entity or row['id'] not in entity.forms:
                if entity and entity.name == 'GeoNames' and row['name'] != 'Place':
                    continue
                choices.append((row['id'], row['name']))
        return choices

    @staticmethod
    def insert_system(form: FlaskForm) -> Entity:
        entity = Entity.insert('reference_system', form.name.data, form.description.data)
        Db.insert_system({
            'entity_id': entity.id,
            'name': entity.name,
            'website_url': form.website_url.data if form.website_url.data else None,
            'resolver_url': form.resolver_url.data if form.resolver_url.data else None})
        return ReferenceSystem.get_all()[entity.id]

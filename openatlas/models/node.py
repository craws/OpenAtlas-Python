from __future__ import annotations  # Needed for Python 4.0 type annotations

import ast
from typing import Any, Dict, List, Optional, Tuple

from flask import g
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.util.display import uc_first
from openatlas.database.node import Node as Db


class Node(Entity):
    count = 0
    count_subs = 0
    locked = False
    multiple = False
    standard = False
    value_type = False
    directional = False

    def __init__(self, row: Dict[str, Any]) -> None:
        super().__init__(row)
        self.root: List[int] = []
        self.subs: List[int] = []
        self.forms: Dict[int, Any] = {}

    @staticmethod
    def get_all_nodes() -> Dict[int, Node]:
        nodes = {}
        for row in Db.get_nodes('type', 'P127') + Db.get_nodes('administrative_unit', 'P89'):
            node = Node(row)
            nodes[node.id] = node
            node.count = row['count'] if row['count'] else row['count_property']
            node.count_subs = 0
            node.subs = []
            node.locked = False
            node.root = [row['super_id']] if row['super_id'] else []
        Node.populate_subs(nodes)
        return nodes

    @staticmethod
    def populate_subs(nodes: Dict[int, Node]) -> None:
        forms = {}
        for row in Db.get_web_forms():
            forms[row['id']] = {
                'id': row['id'],
                'name': row['name'],
                'label': g.classes[row['name']].label if row['name'] in g.classes
                else uc_first(_(row['name'].replace('_', ''))),
                'extendable': row['extendable']}
        hierarchies = {row['id']: row for row in Db.get_hierarchies()}
        for node in nodes.values():
            if node.root:
                super_ = nodes[node.root[0]]
                super_.subs.append(node.id)
                node.root = Node.get_root_path(nodes, node, node.root[0], node.root)
                node.standard = False
                node.locked = nodes[node.root[0]].locked
            else:
                hierarchy = hierarchies[node.id]
                node.value_type = hierarchy['value_type']
                node.directional = hierarchy['directional']
                node.multiple = hierarchy['multiple']
                node.standard = hierarchy['standard']
                node.locked = hierarchy['locked']
                node.forms = {form_id: forms[form_id] for form_id in hierarchy['form_ids']}

    @staticmethod
    def get_root_path(
            nodes: Dict[int, Node],
            node: Node,
            super_id: int,
            root: List[int]) -> List[int]:
        super_ = nodes[super_id]
        super_.count_subs += node.count
        if not super_.root:
            return root
        node.root.append(super_.root[0])
        return Node.get_root_path(nodes, node, super_.root[0], root)

    @staticmethod
    def get_nodes(name: str) -> List[int]:
        for node in g.nodes.values():
            if node.name == name and not node.root:
                return node.subs
        return []  # pragma: no cover

    @staticmethod
    def check_hierarchy_exists(name: str) -> List[Node]:
        hierarchies = [root for root in g.nodes.values() if root.name == name and not root.root]
        return hierarchies

    @staticmethod
    def get_hierarchy(name: str) -> Node:
        return [root for root in g.nodes.values() if root.name == name and not root.root][0]

    @staticmethod
    def get_tree_data(node_id: int, selected_ids: List[int]) -> List[Dict[str, Any]]:
        return Node.walk_tree(g.nodes[node_id].subs, selected_ids)

    @staticmethod
    def walk_tree(nodes: List[Node], selected_ids: List[int]) -> List[Dict[str, Any]]:
        items = []
        for id_ in nodes:
            item = g.nodes[id_]
            items.append({
                'id': item.id,
                'text': item.name.replace("'", "&apos;"),
                'state': {'selected': 'true'} if item.id in selected_ids else '',
                'children': Node.walk_tree(item.subs, selected_ids)})
        return items

    @staticmethod
    def get_nodes_for_form(form_name: str) -> Dict[int, Node]:
        return {id_: g.nodes[id_] for id_ in Db.get_nodes_for_form(form_name)}

    @staticmethod
    def get_form_choices(root: Optional[Node] = None) -> List[Tuple[int, str]]:
        choices = []
        for row in Db.get_form_choices():
            if g.classes[row['name']].view != 'type' and (not root or row['id'] not in root.forms):
                choices.append((row['id'], g.classes[row['name']].label))
        return choices

    @staticmethod
    def save_entity_nodes(entity: Entity, form: Any) -> None:
        from openatlas.forms.field import TreeField
        from openatlas.forms.field import TreeMultiField
        from openatlas.forms.field import ValueFloatField
        if hasattr(entity, 'nodes'):
            entity.delete_links(['P2', 'P89'])
        for field in form:
            if isinstance(field, ValueFloatField):
                if entity.class_.name == 'object_location' or isinstance(entity, Node):
                    continue  # pragma: no cover
                if field.data is not None:  # Allow 0 (zero)
                    entity.link('P2', g.nodes[int(field.name)], field.data)
            elif isinstance(field, (TreeField, TreeMultiField)) and field.data:
                try:
                    range_ = [g.nodes[int(field.data)]]
                except ValueError:  # Form value was a list string e.g. '[97,2798]'
                    range_ = [g.nodes[int(range_id)] for range_id in ast.literal_eval(field.data)]
                if g.nodes[int(field.id)].class_.name == 'administrative_unit':
                    if entity.class_.name == 'object_location':
                        entity.link('P89', range_)
                elif entity.class_.name != 'object_location' and not isinstance(entity, Node):
                    entity.link('P2', range_)

    @staticmethod
    def insert_hierarchy(node: Node, form: FlaskForm, value_type: bool) -> None:
        multiple = False
        if value_type or (hasattr(form, 'multiple') and form.multiple and form.multiple.data):
            multiple = True
        Db.insert_hierarchy({
            'id': node.id,
            'name': node.name,
            'multiple': multiple,
            'value_type': value_type})
        Node.add_forms_to_hierarchy(node, form)

    @staticmethod
    def update_hierarchy(node: Node, form: FlaskForm) -> None:
        multiple = False
        if node.multiple or (hasattr(form, 'multiple') and form.multiple and form.multiple.data):
            multiple = True
        Db.update_hierarchy({'id': node.id, 'name': form.name.data, 'multiple': multiple})
        Node.add_forms_to_hierarchy(node, form)

    @staticmethod
    def add_forms_to_hierarchy(node: Node, form: FlaskForm) -> None:
        Db.add_form_to_hierarchy(node.id, form.forms.data)

    @staticmethod
    def get_node_orphans() -> List[Node]:
        return [n for key, n in g.nodes.items() if n.root and n.count < 1 and not n.subs]

    @staticmethod
    def move_entities(old_node: Node, new_type_id: int, checkbox_values: str) -> None:
        root = g.nodes[old_node.root[-1]]
        entity_ids = ast.literal_eval(checkbox_values)
        delete_ids = []
        if new_type_id:  # A new type was selected
            if root.multiple:
                cleaned_entity_ids = []
                for entity in Entity.get_by_ids(entity_ids, nodes=True):
                    if any(node.id == int(new_type_id) for node in entity.nodes):
                        delete_ids.append(entity.id)  # If already linked add to delete ids
                    else:
                        cleaned_entity_ids.append(entity.id)
                entity_ids = cleaned_entity_ids
            if entity_ids:
                data = {
                    'old_type_id': old_node.id,
                    'new_type_id': new_type_id,
                    'entity_ids': tuple(entity_ids)}
                if root.name in app.config['PROPERTY_TYPES']:
                    Db.move_link_type(data)
                else:
                    Db.move_entity_type(data)
        else:
            delete_ids = entity_ids  # No new type was selected so delete all links

        if delete_ids:
            if root.name in app.config['PROPERTY_TYPES']:
                Db.remove_link_type(old_node.id, delete_ids)
            else:
                Db.remove_entity_type(old_node.id, delete_ids)

    @staticmethod
    def get_all_sub_ids(node: Node, subs: Optional[List[int]] = None) -> List[int]:
        # Recursive function to return a list with all sub node ids
        subs = subs if subs else []
        subs += node.subs
        for sub_id in node.subs:
            Node.get_all_sub_ids(g.nodes[sub_id], subs)
        return subs

    @staticmethod
    def get_form_count(root_node: Node, form_id: int) -> Optional[int]:
        # Check if nodes are linked to entities before offering to remove a node from form
        node_ids = Node.get_all_sub_ids(root_node)
        if not node_ids:
            return
        return Db.get_form_count(form_id, node_ids)

    @staticmethod
    def remove_form_from_hierarchy(form_id: int, hierarchy_id: int) -> None:
        Db.remove_form_from_hierarchy(form_id, hierarchy_id)

    @staticmethod
    def remove_by_entity_and_node(entity_id: int, node_id: int) -> None:
        Db.remove_by_entity_and_node(entity_id, node_id)

    @staticmethod
    def get_untyped(hierarchy_id: int) -> List[Entity]:
        hierarchy = g.nodes[hierarchy_id]
        classes = [class_['name'] for class_ in g.nodes[hierarchy_id].forms.values()]
        if hierarchy.name in ('Administrative unit', 'Historical place'):
            classes = 'object_location'  # pragma: no cover
        untyped = []
        for entity in Entity.get_by_class(classes, nodes=True):
            linked = False
            for node in entity.nodes:
                if node.root[-1] == hierarchy_id:
                    linked = True
                    break
            if not linked:
                if classes == 'object_location':  # pragma: no cover
                    entity = entity.get_linked_entity('P53', True)
                    if entity:
                        untyped.append(entity)
                else:
                    untyped.append(entity)
        return untyped

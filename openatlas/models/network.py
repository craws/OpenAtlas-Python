from typing import Optional, Set

from flask import g
from flask_wtf import FlaskForm

from openatlas.database.network import Network as Db


class Network:

    @staticmethod
    def get_network_json(form: FlaskForm, dimensions: Optional[int]) -> Optional[str]:
        mapping = Db.get_object_mapping()
        classes = [class_.name for class_ in g.classes.values() if class_.color]
        properties = ['P7', 'P11', 'P14', 'P22', 'P23', 'P24', 'P25', 'P67', 'P74', 'P107', 'OA7',
                      'OA8', 'OA9']
        entities: Set[int] = set()
        nodes = []
        for row in Db.get_entities(classes):
            if row['id'] in mapping or row['id'] in entities:  # pragma: no cover
                continue  # Locations will be mapped to objects
            nodes.append({
                'id': row['id'],
                'label' if dimensions else 'name': Network.truncate(row['name'].replace("'", "")),
                'color': form[row['system_class']].data})
            entities.add(row['id'])
        linked_entity_ids = set()
        edges = []
        edge_entity_ids = set()
        for row in Db.get_edges(classes, properties):
            domain_id = mapping[row['domain_id']] if row['domain_id'] in mapping \
                else row['domain_id']
            range_id = mapping[row['range_id']] if row['range_id'] in mapping else row['range_id']
            linked_entity_ids.add(domain_id)
            linked_entity_ids.add(range_id)
            edges.append({'id': int(row['id']), 'source': domain_id, 'target': range_id})
            edge_entity_ids.add(domain_id)
            edge_entity_ids.add(range_id)
        if not form.orphans.data:
            nodes[:] = [d for d in nodes if int(d['id']) in edge_entity_ids]
        return str({'nodes': nodes, 'edges' if dimensions else 'links': edges}) if nodes else None

    @staticmethod
    def truncate(string: Optional[str] = '', length: int = 40) -> str:
        return string if len(string) < length + 1 else string[:length] + '..'

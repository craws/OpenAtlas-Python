from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import Any, Dict, List, Optional

from flask import g
from flask_login import current_user

from openatlas.util.display import sanitize
from openatlas.util.util import is_float
from openatlas.database.imports import Import as Db


class Project:

    def __init__(self, row: Dict[str, Any]) -> None:
        self.id = row['id']
        self.name = row['name']
        self.count = row['count']
        self.description = row['description'] if row['description'] else ''
        self.created = row['created']
        self.modified = row['modified']


class Import:

    @staticmethod
    def insert_project(name: str, description: Optional[str] = None) -> int:
        return Db.insert_project(name, description.strip() if description else None)

    @staticmethod
    def get_all_projects() -> List[Project]:
        return [Project(row) for row in Db.get_all_projects()]

    @staticmethod
    def get_project_by_id(id_: int) -> Project:
        return Project(Db.get_project_by_id(id_))

    @staticmethod
    def get_project_by_name(name: str) -> Optional[Project]:
        row = Db.get_project_by_name(name)
        return Project(row) if row else None

    @staticmethod
    def delete_project(id_: int) -> None:
        Db.delete_project(id_)

    @staticmethod
    def get_origin_ids(project: Project, origin_ids: List[str]) -> List[str]:
        return Db.check_origin_ids(project.id, origin_ids)

    @staticmethod
    def check_duplicates(class_: str, names: List[str]) -> List[str]:
        return Db.check_duplicates(class_, names)

    @staticmethod
    def update_project(project: Project) -> None:
        Db.update_project(project.id, project.name, sanitize(project.description, 'text'))

    @staticmethod
    def check_type_id(type_id: str, class_: str) -> bool:  # pragma: no cover
        if not type_id.isdigit():
            return False
        elif int(type_id) not in g.nodes:
            return False
        else:
            # Check if type is allowed (for corresponding form)
            valid_type = False
            root = g.nodes[g.nodes[int(type_id)].root[0]]
            for form_id, form_object in root.forms.items():
                if form_object['name'] == class_:
                    valid_type = True
            if not valid_type:
                return False
        return True

    @staticmethod
    def import_data(project: 'Project', class_: str, data: List[Any]) -> None:
        from openatlas.models.entity import Entity
        from openatlas.models.gis import Gis
        for row in data:
            entity = Entity.insert(
                class_,
                row['name'],
                row['description'] if 'description' in row else None)
            Db.import_data(
                project.id,
                entity.id,
                current_user.id,
                origin_id=row['id'] if 'id' in row and row['id'] else None)

            # Dates
            if 'begin_from' in row and row['begin_from']:
                entity.begin_from = row['begin_from']
                if 'begin_to' in row and row['begin_to']:
                    entity.begin_to = row['begin_to']
                if 'begin_comment' in row and row['begin_comment']:
                    entity.begin_comment = row['begin_comment']
            if 'end_from' in row and row['end_from']:
                entity.end_from = row['end_from']
                if 'end_to' in row and row['end_to']:
                    entity.end_to = row['end_to']
                if 'end_comment' in row and row['end_comment']:
                    entity.end_comment = row['end_comment']
            entity.update()

            # Types
            if 'type_ids' in row and row['type_ids']:  # pragma: no cover
                for type_id in row['type_ids'].split():
                    if not Import.check_type_id(type_id, class_):
                        continue
                    entity.link('P2', g.nodes[int(type_id)])

            # GIS
            if class_ == 'place':
                location = Entity.insert('object_location', 'Location of ' + row['name'])
                entity.link('P53', location)
                if 'easting' in row and is_float(row['easting']):
                    if 'northing' in row and is_float(row['northing']):
                        Gis.insert_import(entity=entity,
                                          location=location,
                                          project=project,
                                          easting=row['easting'],
                                          northing=row['northing'])

from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import Any, Dict

from flask_login import current_user
from flask_wtf import FlaskForm

from openatlas import app
from openatlas.database.overlay import Overlay as Db
from openatlas.models.entity import Entity
from openatlas.util.util import get_file_path


class Overlay:

    def __init__(self, row: Dict[str, Any]) -> None:
        self.id = row['id']
        self.name = row['name'] if 'name' in row else ''
        self.image_id = row['image_id']
        self.place_id = row['place_id']
        self.bounding_box = row['bounding_box']
        path = get_file_path(row['image_id'])
        self.image_name = path.name if path else False

    @staticmethod
    def insert(form: FlaskForm, image_id: int, place_id: int, link_id: int) -> None:
        Db.insert({
            'image_id': image_id,
            'place_id': place_id,
            'link_id': link_id,
            'bounding_box': f'''[
                [{form.top_left_northing.data}, {form.top_left_easting.data}],
                [{form.bottom_right_northing.data}, {form.bottom_right_easting.data}]]'''})

    @staticmethod
    def update(form: FlaskForm, image_id: int, place_id: int) -> None:
        Db.update({
            'image_id': image_id,
            'place_id': place_id,
            'bounding_box': f'''[
                [{form.top_left_northing.data}, {form.top_left_easting.data}],
                [{form.bottom_right_northing.data}, {form.bottom_right_easting.data}]]'''})

    @staticmethod
    def get_by_object(object_: Entity) -> Dict[int, Overlay]:
        if not app.config['IS_UNIT_TEST'] and not current_user.settings['module_map_overlay']:
            return {}  # pragma: no cover - tests have no direct access to user settings

        ids = [object_.id]
        # Get overlays of parents
        if object_.class_.name == 'find':
            stratigraphic_unit = object_.get_linked_entity_safe('P46', True)
            ids.append(stratigraphic_unit.id)
            feature = stratigraphic_unit.get_linked_entity_safe('P46', True)
            ids.append(feature.id)
            ids.append(feature.get_linked_entity_safe('P46', True).id)
        elif object_.class_.name == 'stratigraphic_unit':
            feature = object_.get_linked_entity_safe('P46', True)
            ids.append(feature.id)
            ids.append(feature.get_linked_entity_safe('P46', True).id)
        elif object_.class_.name == 'feature':
            ids.append(object_.get_linked_entity_safe('P46', True).id)
        return {row['image_id']: Overlay(row) for row in Db.get_by_object(ids)}

    @staticmethod
    def get_by_id(id_: int) -> Overlay:
        return Overlay(Db.get_by_id(id_))

    @staticmethod
    def remove(id_: int) -> None:
        Db.remove(id_)

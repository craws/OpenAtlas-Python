from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import Any, Dict, List, Optional

from openatlas.models.entity import Entity


def get_structure(object_: Optional[Entity] = None,
                  super_: Optional[Entity] = None) -> Optional[Dict[str, Any]]:
    super_id = None
    place = None
    feature = None
    stratigraphic_unit = None
    siblings: List[Entity] = []
    subunits: List[Entity] = []

    if super_:
        super_id = super_.id
        if super_.class_.name == 'stratigraphic_unit':
            feature = super_.get_linked_entity_safe('P46', inverse=True)
            place = feature.get_linked_entity_safe('P46', inverse=True)
        elif super_.class_.name == 'feature':
            place = super_.get_linked_entity_safe('P46', inverse=True)
        elif super_.class_.name == 'place':
            place = super_
            siblings = super_.get_linked_entities('P46')
    elif not object_:
        return None
    else:
        if object_.class_.name not in ['find', 'human_remains']:
            subunits = object_.get_linked_entities('P46', nodes=True)
        if object_.class_.name in ['find', 'human_remains']:
            stratigraphic_unit = object_.get_linked_entity_safe('P46', inverse=True)
            super_id = stratigraphic_unit.id
            feature = stratigraphic_unit.get_linked_entity_safe('P46', inverse=True)
            place = feature.get_linked_entity_safe('P46', inverse=True)
            siblings = stratigraphic_unit.get_linked_entities('P46')
        elif object_.class_.name == 'stratigraphic_unit':
            feature = object_.get_linked_entity_safe('P46', inverse=True)
            super_id = feature.id
            place = feature.get_linked_entity_safe('P46', inverse=True)
            siblings = feature.get_linked_entities('P46')
        elif object_.class_.name == 'feature':
            place = object_.get_linked_entity_safe('P46', inverse=True)
            super_id = place.id
            siblings = place.get_linked_entities('P46')
    return {
        'place': place,
        'feature': feature,
        'stratigraphic_unit': stratigraphic_unit,
        'super_id': super_id,
        'subunits': subunits,
        'siblings': siblings}

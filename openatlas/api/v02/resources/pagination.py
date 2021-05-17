import itertools
from typing import Any, Dict, List

from openatlas.api.v02.resources.error import EntityDoesNotExistError, NoEntityAvailable
from openatlas.api.v02.resources.linked_places import LinkedPlacesEntity
from openatlas.models.entity import Entity


class Pagination:

    @staticmethod
    def get_shown_entities(total: List[int], parser: Dict[str, Any]) -> List[Any]:
        if parser['last'] and int(parser['last']) in total:
            return list(itertools.islice(total, total.index(int(parser['last'])) + 1, None))
        if parser['first'] and int(parser['first']) in total:
            return list(itertools.islice(total, total.index(int(parser['first'])), None))
        raise EntityDoesNotExistError

    @staticmethod
    def pagination(entities: List[Entity], parser: Dict[str, Any]) -> Dict[str, Any]:
        if not entities:
            raise NoEntityAvailable
        index = []
        total = [e.id for e in entities]
        for num, i in enumerate(list(itertools.islice(total, 0, None, int(parser['limit'])))):
            index.append(({'page': num + 1, 'start_id': i}))
        if parser['last'] or parser['first']:
            total = Pagination.get_shown_entities(total, parser)
        h = [i for i, x in enumerate(entities) if x.id == total[0]]
        entity_limit = [e for idx, e in enumerate(entities[h[0]:])]
        entities_result = [LinkedPlacesEntity.get_entity(r, parser)
                           for r in entity_limit[:int(parser['limit'])]]
        result = {
            "result": entities_result,
            "pagination": {
                'entity_per_page': int(parser['limit']),
                'entities': len(total),
                'index': index, 'total_pages': len(index)}}
        return result

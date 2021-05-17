import datetime
from typing import Any, Dict, List

from openatlas.api.v02.resources.error import FilterColumnError, FilterLogicalOperatorError, \
    FilterOperatorError, InvalidSearchDateError, InvalidSearchNumberError, NoSearchStringError


class Validation:
    logical_operators: Dict[str, Any] = {
        'and': 'AND',
        'or': 'OR',
        'onot': 'OR NOT',
        'anot': 'AND NOT'}
    valid_columns: Dict[str, str] = {
        'id': 'e.id', 'class_code': 'e.class_code', 'name': 'e.name',
        'description': 'e.description', 'system_class': 'e.system_class',
        'begin_from': 'e.begin_from', 'begin_to': 'e.begin_to', 'created': 'e.created',
        'modified': 'e.modified', 'end_to': 'e.end_to', 'end_from': 'e.end_from'}
    compare_operators: Dict[str, Any] = {
        'eq': '=', 'ne': '!=', 'lt': '<', 'le': '<=', 'gt': '>', 'ge': '>=', 'like': 'LIKE'}

    @staticmethod
    def get_filter_from_url_parameter(filters: List[str]) -> List[List[str]]:
        checked_filter = []
        for item in filters:
            Validation.check_filter_input(item.split('|'))
            checked_filter.append([word for word in item.split('|')])
        return checked_filter

    @staticmethod
    def check_filter_input(values: List[str]) -> None:
        if values[0] not in Validation.logical_operators.keys():
            raise FilterLogicalOperatorError
        if values[1] not in Validation.valid_columns:
            raise FilterColumnError
        if values[2] not in Validation.compare_operators.keys():
            raise FilterOperatorError
        if len(values) < 4 or values[3] == '':
            raise NoSearchStringError

    @staticmethod
    def test_date(term: str) -> None:
        try:
            datetime.datetime.strptime(term, "%Y-%m-%d")
        except InvalidSearchDateError:
            raise InvalidSearchDateError

    @staticmethod
    def test_id(term: str) -> None:
        try:
            int(term)
        except InvalidSearchNumberError:
            raise InvalidSearchNumberError

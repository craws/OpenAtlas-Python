import re
from typing import Any, Dict, Iterable, List, Union


class Validation:
    default = {'filter': '',
               'limit': '20',
               'sort': 'ASC',
               'column': 'name',
               'last': None,
               'first': None,
               'show': ['when', 'types', 'relations', 'names', 'links', 'geometry', 'depictions'],
               'subtype': False}
    column = ['id', 'class_code', 'name', 'description', 'created', 'modified', 'system_type',
              'begin_from', 'begin_to', 'end_from', 'end_to']
    operators = ['eq', 'ne', 'lt', 'le', 'gt', 'ge', 'and', 'or', 'not', 'contains', 'startsWith',
                 'in', 'match']
    operators_dict = {'eq': '=', 'ne': '!=', 'lt': '<', 'le': '<=', 'gt': '>', 'ge': '>=',
                      'and': 'AND', 'or': 'OR', 'onot': 'OR NOT', 'anot': 'AND NOT', 'like': 'LIKE',
                      'in': 'IN'}

    @staticmethod
    def validate_url_query(query: Any) -> Dict[str, Any]:
        query = {'filter': Validation.validate_filter(query.getlist('filter')),
                 'limit': Validation.validate_limit(query.getlist('limit')),
                 'sort': Validation.validate_sort(query.getlist('sort')),
                 'column': Validation.validate_column(query.getlist('column')),
                 'last': Validation.validate_last(query.getlist('last')),
                 'first': Validation.validate_first(query.getlist('first')),
                 'show': Validation.validate_show(query.getlist('show')),
                 'subtype': Validation.validate_subtype(query.get('subtype'))}
        return query

    @staticmethod
    def validate_filter(filter_: Iterable[str]) -> str:
        filter_ = re.findall(r'(\w+)\((.*?)\)', ''.join(filter_))
        filter_query = ''
        for item in filter_:
            operator = item[0].lower()
            if operator in Validation.operators_dict:
                filter_query += Validation.operators_dict[operator]
                item = re.split('[,]', item[1])
                if item[0] in Validation.operators_dict and item[1] in Validation.column:
                    if item[0] == 'like':
                        item[2] = '\'' + item[2] + '%%\''
                        item[1] = item[1] + '::text'
                    elif item[0] == 'in':
                        item[2] = item[2].replace('[', '')
                        item[2] = item[2].replace(']', '')
                        if len(list(map(str, item[2].split(':')))) == 1:
                            tmp = list(map(str, item[2].split(':')))
                            item[2] = '(\'' + tmp[0] + '\')'
                        else:
                            item[2] = str(tuple(map(str, item[2].split(':'))))
                    else:
                        item[2] = '\'' + item[2] + '\''
                    filter_query += ' ' + item[1] + ' ' \
                                    + Validation.operators_dict[item[0]] + ' ' + item[2] + ' '
        return filter_query

    @staticmethod
    def validate_limit(limit: List[Any]) -> Union[str, int]:
        limit_ = [Validation.default['limit']]
        if limit:
            for item in limit:
                if item.isdigit():
                    limit_ = [item]
        return limit_[0]

    @staticmethod
    def validate_sort(sort: List[Any]) -> Union[bool, List[str], str, None]:
        sort_ = []
        if sort:
            for item in reversed(sort):
                if isinstance(item, str) and item.lower() in ['asc', 'desc']:
                    sort_.append(item)
            return sort_[0]
        else:
            return Validation.default['sort']

    @staticmethod
    def validate_column(column: List[Any]) -> Union[List[str], str, None]:
        column_ = []
        if column:
            for item in column:
                if isinstance(item, str) and item.lower() in Validation.column:
                    column_.append(item)

        else:
            column_.append(str(Validation.default['column']))
        return column_

    @staticmethod
    def validate_last(last: List[Any]) -> Union[str, int]:
        last_ = []
        if last:
            for item in last:
                if item.isdigit():
                    last_.append(item)
        else:
            last_.append(Validation.default['last'])
        return last_[0]

    @staticmethod
    def validate_first(first: List[Any]) -> Union[str, int]:
        first_ = []
        if first:
            for item in first:
                if item.isdigit():
                    first_.append(item)
        else:
            first_.append(Validation.default['first'])
        return first_[0]

    @staticmethod
    def validate_show(show: List[str]) -> List[str]:
        show_ = []
        valid = ['when', 'types', 'relations', 'names', 'links', 'geometry', 'depictions']
        for pattern in valid:
            if re.search(pattern, str(show)):
                show_.append(pattern)
        if not show_:
            show_.extend(valid)
        if 'none' in show:
            show_.clear()
        return show_

    @staticmethod
    def validate_subtype(subtype: str) -> bool:
        subtype_ = True if subtype == 'show' else False
        return subtype_

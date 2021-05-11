from typing import Any, Dict, List, Optional, Union

from flask import json, render_template
from flask_babel import lazy_gettext as _
from flask_login import current_user
from markupsafe import Markup

from openatlas.util.util import uc_first


class Table:

    def __init__(
            self,
            header: Optional[List[str]] = None,  # A list of column header labels
            rows: Optional[List[List[Any]]] = None,  # Rows containing the data
            order: Optional[List[List[Union[int, str]]]] = None,  # Column order option
            defs: Optional[List[Dict[str, Any]]] = None,  # Definitions
            paging: bool = True) -> None:  # Whether to show pager
        self.header = header if header else []
        self.rows = rows if rows else []
        self.paging = paging
        self.order = order if order else ''
        self.defs = defs if defs else []
        self.defs.append({
            'className': 'dt-body-right',
            'targets': [i for i, j in enumerate(self.header) if j in ['begin', 'end', 'size']]})

    def display(self, name: Optional[str] = 'default') -> str:
        if not self.rows:
            return Markup(f"<p>{uc_first(_('no entries'))}</p>")
        data_table = {
            'data': self.rows,
            'stateSave': 'true',
            'columns':
                [{'title': uc_first(_(item)) if item else ''} for item in self.header] +
                [{'title': ''} for i in range(len(self.rows[0]) - len(self.header))],  # Add empty
            'paging': self.paging,
            'pageLength': current_user.settings['table_rows'],
            'autoWidth': 'false'}
        if self.order:
            data_table['order'] = self.order
        if self.defs:
            data_table['columnDefs'] = self.defs
        return Markup(render_template(
            'util/table.html',
            table=self,
            name=name,
            data=json.dumps(data_table)))

from typing import Any, Dict, List, Optional, Union

from flask import json
from flask_babel import lazy_gettext as _
from flask_login import current_user
from markupsafe import Markup


class Table:

    def __init__(self,
                 header: Optional[List[str]] = None,  # A list of column header labels
                 rows: Optional[List[List[Any]]] = None,  # Rows containing the data
                 order: Optional[List[List[Union[int, str]]]] = None,  # Column order option
                 defs: Optional[List[Any]] = None,  # Definitions
                 paging: bool = True) -> None:  # Whether to show pager
        self.header = header if header else []
        self.rows = rows if rows else []
        self.paging = paging
        self.order = order if order else ''
        self.defs = defs if defs else ''
        if not self.defs:
            right_align = ['begin', 'end', 'size']
            targets = [index for index, item in enumerate(self.header) if item in right_align]
            self.defs = [{'className': 'dt-body-right', 'targets': targets}] if targets else ''

    def display(self, name: Optional[str] = 'default') -> str:
        from openatlas.util.display import uc_first
        if not self.rows:
            return Markup('<p>' + uc_first(_('no entries')) + '</p>')
        columns: List[Dict[str, str]] = [
            {'title': _(item).capitalize() if item else ''} for item in self.header]
        columns += [{'title': ''} for i in range(len(self.rows[0]) - len(self.header))]  # Add empty
        data_table = {
            'data': self.rows,
            'stateSave': 'true',
            'columns': columns,
            'paging': self.paging,
            'pageLength': current_user.settings['table_rows'],
            'autoWidth': 'false'}
        if self.order:
            data_table['order'] = self.order
        if self.defs:
            data_table['columnDefs'] = self.defs
        html = """
            <table id="{name}_table" class="table table-striped hover" style="width:100%"></table>
            <script>
                $(document).ready(function() {{ 
                    $('#{name}_table').DataTable({data_table});
                    overflow();
                    $('#{name}_table').on( 'page.dt', () => overflow());
                    $('#{name}_table').on( 'search.dt', () => overflow());
                }});                
            </script>""".format(name=name, data_table=json.dumps(data_table))

        # Toggle header and footer HTML
        css_header = '#{name}_table_wrapper .row:first-of-type {{ display:none; }}'.format(
            name=name)
        css_toolbar = '#{name}_table_wrapper .row:last-of-type {{ display:none; }}'.format(
            name=name)
        html += '<style type="text/css">{header} {toolbar}</style>'.format(
            header=css_header if not self.header else '',
            toolbar=css_toolbar if len(self.rows) <= current_user.settings['table_rows'] else '')
        return Markup(html)

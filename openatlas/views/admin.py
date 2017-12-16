# Copyright 2017 by Alexander Watzinger and others. Please see README.md for licensing information
from flask import render_template, flash, url_for
from flask_babel import lazy_gettext as _
from werkzeug.utils import redirect

import openatlas
from openatlas import app, EntityMapper, NodeMapper
from openatlas.util.util import required_group, link, truncate_string


@app.route('/admin')
@required_group('manager')
def admin_index():
    return render_template('admin/index.html')


@app.route('/admin/orphans')
@app.route('/admin/orphans/<delete>')
@required_group('admin')
def admin_orphans(delete=None):
    if delete:
        count = EntityMapper.delete_orphans(delete)
        flash(_('info orphans deleted:') + ' ' + str(count), 'info')
        return redirect(url_for('admin_orphans'))
    header = ['name', 'class', 'type', 'system type', 'created', 'updated', 'description']
    tables = {
        'orphans': {'name': 'orphans', 'header': header, 'data': []},
        'unlinked': {'name': 'unlinked', 'header': header, 'data': []},
        'nodes': {'name': 'nodes', 'header': ['name', 'root'], 'data': []}}
    for entity in EntityMapper.get_orphans():
        name = 'unlinked' if entity.class_.code in app.config['CODE_CLASS'].keys() else 'orphans'
        tables[name]['data'].append([
            link(entity),
            link(entity.class_),
            entity.print_base_type(),
            entity.system_type,
            entity.created,
            entity.modified,
            truncate_string(entity.description)])
    for node in NodeMapper.get_orphans():
        tables['nodes']['data'].append([link(node), link(openatlas.nodes[node.root[-1]])])
    return render_template('admin/orphans.html', tables=tables)

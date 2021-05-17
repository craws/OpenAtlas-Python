import collections
from typing import Dict, List, Optional, Union

import numpy
import pandas as pd
from flask import flash, g, render_template, request, url_for
from flask_babel import format_number, lazy_gettext as _
from flask_wtf import FlaskForm
from werkzeug.utils import redirect, secure_filename
from werkzeug.wrappers import Response
from wtforms import BooleanField, FileField, StringField, SubmitField, TextAreaField
from wtforms.validators import InputRequired

from openatlas import app, logger
from openatlas.database.connect import Transaction
from openatlas.models.date import Date
from openatlas.models.entity import Entity
from openatlas.models.imports import Import, is_float
from openatlas.util.table import Table
from openatlas.util.util import format_date, get_backup_file_data, link, required_group, uc_first


class ProjectForm(FlaskForm):  # type: ignore
    project_id: Optional[int] = None
    name = StringField(_('name'), [InputRequired()], render_kw={'autofocus': True})
    description = TextAreaField(_('description'))
    save = SubmitField(_('insert'))

    def validate(self) -> bool:
        valid = FlaskForm.validate(self)
        name = Import.get_project_by_id(self.project_id).name if self.project_id else ''
        if name != self.name.data and Import.get_project_by_name(self.name.data):
            self.name.errors.append(_('error name exists'))
            valid = False
        return valid


@app.route('/import/index')
@required_group('contributor')
def import_index() -> str:
    table = Table([_('project'), _('entities'), _('description')])
    for project in Import.get_all_projects():
        table.rows.append([link(project), format_number(project.count), project.description])
    return render_template(
        'import/index.html',
        table=table,
        title=_('import'),
        crumbs=[[_('admin'), url_for('admin_index') + '#tab-data'], _('import')])


@app.route('/import/project/insert', methods=['POST', 'GET'])
@required_group('manager')
def import_project_insert() -> Union[str, Response]:
    form = ProjectForm()
    if form.validate_on_submit():
        id_ = Import.insert_project(form.name.data, form.description.data)
        flash(_('project inserted'), 'info')
        return redirect(url_for('import_project_view', id_=id_))
    return render_template(
        'display_form.html',
        form=form,
        manual_page='admin/import',
        title=_('import'),
        crumbs=[
            [_('admin'), url_for('admin_index') + '#tab-data'],
            [_('import'), url_for('import_index')],
            '+ ' + uc_first(_('project'))])


@app.route('/import/project/view/<int:id_>')
@required_group('contributor')
def import_project_view(id_: int) -> str:
    table = Table([_('name'), _('class'), _('description'), 'origin ID', _('date')])
    for entity in Entity.get_by_project_id(id_):
        table.rows.append([
            link(entity),
            entity.class_.label,
            entity.description,
            entity.origin_id,
            format_date(entity.created)])
    project = Import.get_project_by_id(id_)
    return render_template(
        'import/project_view.html',
        project=project,
        table=table,
        title=_('import'),
        crumbs=[
            [_('admin'), url_for('admin_index') + '#tab-data'],
            [_('import'), url_for('import_index')],
            project.name])


@app.route('/import/project/update/<int:id_>', methods=['POST', 'GET'])
@required_group('manager')
def import_project_update(id_: int) -> Union[str, Response]:
    project = Import.get_project_by_id(id_)
    form = ProjectForm(obj=project)
    form.project_id = id_
    if form.validate_on_submit():
        project.name = form.name.data
        project.description = form.description.data
        Import.update_project(project)
        flash(_('project updated'), 'info')
        return redirect(url_for('import_project_view', id_=project.id))
    return render_template(
        'display_form.html',
        form=form,
        manual_page='admin/import',
        title=_('import'),
        crumbs=[
            [_('admin'), url_for('admin_index') + '#tab-data'],
            [_('import'), url_for('import_index')],
            project,
            _('edit')])


@app.route('/import/project/delete/<int:id_>')
@required_group('manager')
def import_project_delete(id_: int) -> Response:
    Import.delete_project(id_)
    flash(_('project deleted'), 'info')
    return redirect(url_for('import_index'))


class ImportForm(FlaskForm):  # type: ignore
    file = FileField(_('file'), [InputRequired()])
    preview = BooleanField(_('preview only'), default=True)
    duplicate = BooleanField(_('check for duplicates'), default=True)
    save = SubmitField(_('import'))

    def validate(self) -> bool:
        valid = FlaskForm.validate(self)
        file_ = request.files['file']
        if not file_:  # pragma: no cover
            self.file.errors.append(_('no file to upload'))
            valid = False
        elif not ('.' in file_.filename and file_.filename.rsplit('.', 1)[1].lower() == 'csv'):
            self.file.errors.append(_('file type not allowed'))
            valid = False
        return valid


@app.route('/import/data/<int:project_id>/<class_>', methods=['POST', 'GET'])
@required_group('manager')
def import_data(project_id: int, class_: str) -> str:
    project = Import.get_project_by_id(project_id)
    form = ImportForm()
    table = None
    imported = False
    messages: Dict[str, List[str]] = {'error': [], 'warn': []}
    file_data = get_backup_file_data()
    class_label = g.classes[class_].label
    if form.validate_on_submit():
        file_ = request.files['file']
        file_path = app.config['TMP_DIR'] / secure_filename(file_.filename)  # type: ignore
        columns: Dict[str, List[str]] = {
            'allowed': ['name', 'id', 'description', 'begin_from', 'begin_to', 'begin_comment',
                        'end_from', 'end_to', 'end_comment', 'type_ids'],
            'valid': [],
            'invalid': []}
        if class_ == 'place':
            columns['allowed'] += ['easting', 'northing']
        try:
            file_.save(str(file_path))
            df = pd.read_csv(file_path, keep_default_na=False)
            headers = list(df.columns.values)
            if 'name' not in headers:  # pragma: no cover
                messages['error'].append(_('missing name column'))
                raise Exception()
            for item in headers:  # pragma: no cover
                if item not in columns['allowed']:
                    columns['invalid'].append(item)
                    del df[item]
            if columns['invalid']:  # pragma: no cover
                messages['warn'].append(_('invalid columns') + ': ' + ','.join(columns['invalid']))
            headers = list(df.columns.values)  # Read cleaned headers again
            table_data = []
            checked_data = []
            origin_ids = []
            names = []
            missing_name_count = 0
            invalid_type_ids = False
            invalid_geoms = False
            for index, row in df.iterrows():
                if not row['name']:  # pragma: no cover
                    missing_name_count += 1
                    continue
                table_row = []
                checked_row = {}
                for item in headers:
                    value = row[item]
                    if item == 'type_ids':  # pragma: no cover
                        type_ids = []
                        for type_id in value.split():
                            if Import.check_type_id(type_id, class_):
                                type_ids.append(type_id)
                            else:
                                type_ids.append('<span class="error">' + type_id + '</span>')
                                invalid_type_ids = True
                        value = ' '.join(type_ids)
                    if item in ['northing', 'easting'] and row[item] and not is_float(row[item]):
                        value = '<span class="error">' + value + '</span>'  # pragma: no cover
                        invalid_geoms = True  # pragma: no cover
                    if item in ['begin_from', 'begin_to', 'end_from', 'end_to']:
                        if not value:
                            value = ''
                        else:
                            try:
                                value = Date.datetime64_to_timestamp(numpy.datetime64(value))
                                row[item] = value
                            except ValueError:  # pragma: no cover
                                row[item] = ''
                                if str(value) == 'NaT':
                                    value = ''
                                else:
                                    value = '<span class="error">' + str(value) + '</span>'
                    table_row.append(str(value))
                    checked_row[item] = row[item]
                    if item == 'name' and form.duplicate.data:
                        names.append(row['name'].lower())
                    if item == 'id' and row[item]:
                        origin_ids.append(str(row['id']))
                table_data.append(table_row)
                checked_data.append(checked_row)
            if invalid_type_ids:  # pragma: no cover
                messages['warn'].append(_('invalid type ids'))
            if invalid_geoms:  # pragma: no cover
                messages['warn'].append(_('invalid coordinates'))
            table = Table(headers, rows=table_data)
            # Checking for data inconsistency
            if missing_name_count:  # pragma: no cover
                messages['warn'].append(_('empty names') + ': ' + str(missing_name_count))
            doubles = [item for item, count in collections.Counter(origin_ids).items() if count > 1]
            if doubles:  # pragma: no cover
                messages['error'].append(_('double IDs in import') + ': ' + ', '.join(doubles))
            existing = Import.get_origin_ids(project, origin_ids) if origin_ids else None
            if existing:
                messages['error'].append(_('IDs already in database') + ': ' + ', '.join(existing))
            if form.duplicate.data:  # Check for possible duplicates
                duplicates = Import.check_duplicates(class_, names)
                if duplicates:  # pragma: no cover
                    messages['warn'].append(_('possible duplicates') + ': ' + ', '.join(duplicates))
            if messages['error']:
                raise Exception()
        except Exception:  # pragma: no cover
            flash(_('error at import'), 'error')
            return render_template(
                'import/import_data.html',
                form=form,
                messages=messages,
                file_data=file_data,
                title=_('import'),
                crumbs=[
                    [_('admin'), url_for('admin_index') + '#tab-data'],
                    [_('import'), url_for('import_index')],
                    project,
                    class_label])

        if not form.preview.data and checked_data:
            if not file_data['backup_too_old'] or app.config['IS_UNIT_TEST']:
                Transaction.begin()
                try:
                    Import.import_data(project, class_, checked_data)
                    Transaction.commit()
                    logger.log('info', 'import', 'import: ' + str(len(checked_data)))
                    flash(_('import of') + ': ' + str(len(checked_data)), 'info')
                    imported = True
                except Exception as e:  # pragma: no cover
                    Transaction.rollback()
                    logger.log('error', 'import', 'import failed', e)
                    flash(_('error transaction'), 'error')
    return render_template(
        'import/import_data.html',
        project=project,
        form=form,
        file_data=file_data,
        class_=class_,
        class_label=class_label,
        table=table,
        imported=imported,
        messages=messages)

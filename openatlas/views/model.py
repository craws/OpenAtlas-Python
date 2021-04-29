from typing import Any, Dict, Optional

from flask import g, render_template, url_for
from flask_babel import format_number, lazy_gettext as _
from flask_wtf import FlaskForm
from wtforms import (
    BooleanField, HiddenField, IntegerField, SelectMultipleField, StringField, SubmitField, widgets)
from wtforms.validators import InputRequired

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.network import Network
from openatlas.util.table import Table
from openatlas.util.util import link, required_group, uc_first


class LinkCheckForm(FlaskForm):  # type: ignore
    domain = HiddenField()
    property = HiddenField()
    range = HiddenField()
    test = SubmitField(uc_first(_('test')))


@app.route('/overview/model', methods=["GET", "POST"])
@required_group('readonly')
def model_index() -> str:
    form = LinkCheckForm()
    form_classes = {}
    for code, class_ in g.cidoc_classes.items():
        form_classes[code] = code + ' ' + class_.name
    form.domain.choices = form_classes.items()
    form.range.choices = form_classes.items()
    form_properties = {}
    for code, property_ in g.properties.items():
        form_properties[code] = code + ' ' + property_.name
    form.property.choices = form_properties.items()
    test_result = None
    if form.validate_on_submit():
        domain = g.cidoc_classes[form.domain.data]
        range_ = g.cidoc_classes[form.range.data]
        property_ = g.properties[form.property.data]
        domain_is_valid = property_.find_object('domain_class_code', domain.code)
        range_is_valid = property_.find_object('range_class_code', range_.code)
        test_result = {
            'domain': domain,
            'property': property_,
            'range': range_,
            'domain_error': False if domain_is_valid else True,
            'range_error': False if range_is_valid else True}
    else:
        domain = g.cidoc_classes['E1']
        property_ = g.properties['P1']
        range_ = domain
        form.domain.data = domain.code
        form.property.data = property_.code
        form.range.data = range_.code
    return render_template(
        'model/index.html',
        form=form,
        test_result=test_result,
        domain=domain,
        property=property_,
        range=range_,
        title=_('model'),
        crumbs=[_('model')])


@app.route('/overview/model/class/<code>')
@required_group('readonly')
def class_entities(code: str) -> str:
    table = Table(['name'], rows=[[link(entity)] for entity in Entity.get_by_cidoc_class(code)])
    return render_template(
        'table.html',
        table=table,
        title=_('model'),
        crumbs=[
            [_('model'), url_for('model_index')],
            [_('classes'), url_for('class_index')],
            link(g.cidoc_classes[code]),
            _('entities')])


@app.route('/overview/model/class')
@required_group('readonly')
def class_index() -> str:
    table = Table(
        ['code', 'name', 'count'],
        defs=[
            {'className': 'dt-body-right', 'targets': 2},
            {'orderDataType': 'cidoc-model', 'targets': [0]},
            {'sType': 'numeric', 'targets': [0]}])
    for class_id, class_ in g.cidoc_classes.items():
        count = ''
        if class_.count:
            count = format_number(class_.count)
            if class_.code not in ['E53', 'E41', 'E82']:
                count = link(
                    format_number(class_.count),
                    url_for('class_entities', code=class_.code))
        table.rows.append([link(class_), class_.name, count])
    return render_template(
        'table.html',
        table=table,
        title=_('model'),
        crumbs=[[_('model'), url_for('model_index')], _('classes')])


@app.route('/overview/model/property')
@required_group('readonly')
def property_index() -> str:
    classes = g.cidoc_classes
    properties = g.properties
    table = Table(
        ['code', 'name', 'inverse', 'domain', 'domain name', 'range', 'range name', 'count'],
        defs=[
            {'className': 'dt-body-right', 'targets': 7},
            {'orderDataType': 'cidoc-model', 'targets': [0, 3, 5]},
            {'sType': 'numeric', 'targets': [0]}])
    for property_id, property_ in properties.items():
        table.rows.append([
            link(property_),
            property_.name,
            property_.name_inverse,
            link(classes[property_.domain_class_code]),
            classes[property_.domain_class_code].name,
            link(classes[property_.range_class_code]),
            classes[property_.range_class_code].name,
            format_number(property_.count) if property_.count else ''])
    return render_template(
        'table.html',
        table=table,
        title=_('model'),
        crumbs=[[_('model'), url_for('model_index')], _('properties')])


@app.route('/overview/model/class_view/<code>')
@required_group('readonly')
def class_view(code: str) -> str:
    class_ = g.cidoc_classes[code]
    tables = {}
    for table in ['super', 'sub']:
        tables[table] = Table(paging=False, defs=[
            {'orderDataType': 'cidoc-model', 'targets': [0]},
            {'sType': 'numeric', 'targets': [0]}])
        for code_ in getattr(class_, table):
            tables[table].rows.append([link(g.cidoc_classes[code_]), g.cidoc_classes[code_].name])
    tables['domains'] = Table(paging=False, defs=[
        {'orderDataType': 'cidoc-model', 'targets': [0]},
        {'sType': 'numeric', 'targets': [0]}])
    tables['ranges'] = Table(paging=False, defs=[
        {'orderDataType': 'cidoc-model', 'targets': [0]},
        {'sType': 'numeric', 'targets': [0]}])
    for key, property_ in g.properties.items():
        if class_.code == property_.domain_class_code:
            tables['domains'].rows.append([link(property_), property_.name])
        elif class_.code == property_.range_class_code:
            tables['ranges'].rows.append([link(property_), property_.name])
    return render_template(
        'model/class_view.html',
        class_=class_,
        tables=tables,
        info={'code': class_.code, 'name': class_.name},
        title=_('model'),
        crumbs=[
            [_('model'),
             url_for('model_index')],
            [_('classes'), url_for('class_index')],
            class_.code])


@app.route('/overview/model/property_view/<code>')
@required_group('readonly')
def property_view(code: str) -> str:
    property_ = g.properties[code]
    domain = g.cidoc_classes[property_.domain_class_code]
    range_ = g.cidoc_classes[property_.range_class_code]
    info = {
        'code': property_.code,
        'name': property_.name,
        'inverse': property_.name_inverse,
        'domain': link(domain) + ' ' + domain.name,
        'range': link(range_) + ' ' + range_.name}
    tables = {}
    for table in ['super', 'sub']:
        tables[table] = Table(paging=False, defs=[
            {'orderDataType': 'cidoc-model', 'targets': [0]},
            {'sType': 'numeric', 'targets': [0]}])
        for code in getattr(property_, table):
            tables[table].rows.append([link(g.properties[code]), g.properties[code].name])
    return render_template(
        'model/property_view.html',
        tables=tables,
        property_=property_,
        info=info,
        title=_('model'),
        crumbs=[
            [_('model'), url_for('model_index')],
            [_('properties'), url_for('property_index')],
            property_.code])


class NetworkForm(FlaskForm):  # type: ignore
    width = IntegerField(default=1200, validators=[InputRequired()])
    height = IntegerField(default=600, validators=[InputRequired()])
    charge = StringField(default=-80, validators=[InputRequired()])
    distance = IntegerField(default=80, validators=[InputRequired()])
    orphans = BooleanField(default=False)
    classes = SelectMultipleField(_('classes'), widget=widgets.ListWidget(prefix_label=False))


@app.route('/overview/network/', methods=["GET", "POST"])
@app.route('/overview/network/<int:dimensions>', methods=["GET", "POST"])
@required_group('readonly')
def model_network(dimensions: Optional[int] = None) -> str:
    network_classes = [class_ for class_ in g.classes.values() if class_.color]
    for class_ in network_classes:
        setattr(NetworkForm, class_.name, StringField(
            default=class_.color,
            render_kw={'data-huebee': True, 'class': 'data-huebee'}))
    setattr(NetworkForm, 'save', SubmitField(_('apply')))
    form = NetworkForm()
    form.classes.choices = []
    params: Dict[str, Any] = {
        'classes': {},
        'options': {
            'orphans': form.orphans.data,
            'width': form.width.data,
            'height': form.height.data,
            'charge': form.charge.data,
            'distance': form.distance.data}}
    for class_ in network_classes:
        if class_.name == 'object_location':
            continue
        form.classes.choices.append((class_.name, class_.label))
    return render_template(
        'model/network2.html' if dimensions else 'model/network.html',
        form=form,
        dimensions=dimensions,
        network_params=params,
        json_data=Network.get_network_json(form, dimensions),
        title=_('model'),
        crumbs=[_('network visualization')])

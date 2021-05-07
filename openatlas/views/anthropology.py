from typing import Union

from flask import g, render_template, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import SelectField, SubmitField

from openatlas import app
from openatlas.models.anthropology import SexEstimation
from openatlas.models.entity import Entity
from openatlas.models.node import Node
from openatlas.util.util import required_group, uc_first


@app.route('/anthropology/index/<int:id_>')
@required_group('readonly')
def anthropology_index(id_: int) -> Union[str, Response]:
    entity = Entity.get_by_id(id_)
    return render_template(
        'anthropology/index.html',
        entity=entity,
        crumbs=[entity, _('anthropological analyzes')])


@app.route('/anthropology/sex/<int:id_>')
@required_group('readonly')
def anthropology_sex(id_: int) -> Union[str, Response]:
    entity = Entity.get_by_id(id_, nodes=True)
    return render_template(
        'anthropology/sex.html',
        entity=entity,
        crumbs=[
            entity,
            [_('anthropological analyzes'), url_for('anthropology_index', id_=entity.id)],
            _('sex estimation')])


@app.route('/anthropology/sex/update/<int:id_>', methods=['POST', 'GET'])
@required_group('contributor')
def anthropology_sex_update(id_: int) -> Union[str, Response]:

    # Build the form with selects for features
    class Form(FlaskForm):  # type: ignore
        pass

    choices = [(option, option) for option in SexEstimation.options.keys()]
    for features in SexEstimation.features.values():
        for feature, values in features.items():
            label = uc_first(feature.replace('_', ' '))
            description = ''
            if values['female'] or values['male']:
                description = f"Female: {values['female']}, male: {values['male']}"
            setattr(Form,
                    feature,
                    SelectField(
                        label,
                        choices=choices,
                        default='Not preserved',
                        description=description))
    setattr(Form, 'save', SubmitField(_('save')))
    form = Form()

    #  Add type information to features
    sex_node_subs = Node.get_nodes('Features for sexing')
    for group_id in sex_node_subs:
        group = g.nodes[group_id]
        for node_id in group.subs:
            node = g.nodes[node_id]
            SexEstimation.features[group.name][node.name]['type_id'] = node.id

    entity = Entity.get_by_id(id_)
    if form.validate_on_submit():
        data = form.data
        data.pop('save')
        data.pop('csrf_token')
        SexEstimation.save(entity, data)
        return redirect(url_for('anthropology_sex', id_=entity.id))

    return render_template(
        'anthropology/sex_update.html',
        entity=entity,
        form=form,
        crumbs=[
            entity,
            [_('anthropological analyzes'), url_for('anthropology_index', id_=entity.id)],
            [_('sex estimation'), url_for('anthropology_sex', id_=entity.id)],
            _('edit')])

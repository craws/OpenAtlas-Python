from typing import Union

from flask import render_template, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from werkzeug.wrappers import Response
from wtforms import SelectField, SubmitField

from openatlas import app
from openatlas.models.anthropology import SexEstimation
from openatlas.models.entity import Entity
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
    entity = Entity.get_by_id(id_)
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

    class Form(FlaskForm):  # type: ignore
        pass
    choices = [(option, option) for option in SexEstimation.options.keys()]
    for features in SexEstimation.features.values():
        for feature in features.keys():
            label = uc_first(feature.replace('_', ' '))
            setattr(Form, feature, SelectField(label, choices=choices))

    setattr(Form, 'save', SubmitField(_('save')))
    form = Form()

    entity = Entity.get_by_id(id_)
    if form.validate_on_submit():
        data = form.data
        data.pop('save')
        data.pop('csrf_token')
        SexEstimation.save(entity, data)

    return render_template(
        'anthropology/sex_update.html',
        entity=entity,
        form=form,
        crumbs=[
            entity,
            [_('anthropological analyzes'), url_for('anthropology_index', id_=entity.id)],
            [_('sex estimation'), url_for('anthropology_sex', id_=entity.id)],
            _('edit')])

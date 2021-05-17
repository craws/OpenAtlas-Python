import ast
from typing import Union

from flask import flash, render_template, url_for
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from werkzeug.utils import redirect
from werkzeug.wrappers import Response
from wtforms import FloatField, SubmitField
from wtforms.validators import InputRequired

from openatlas import app
from openatlas.models.entity import Entity
from openatlas.models.overlay import Overlay
from openatlas.util.util import required_group


class OverlayForm(FlaskForm):  # type: ignore
    top_left_easting = FloatField('', [InputRequired()], render_kw={'autofocus': True})
    top_left_northing = FloatField('', [InputRequired()])
    bottom_right_easting = FloatField('', [InputRequired()])
    bottom_right_northing = FloatField('', [InputRequired()])
    save = SubmitField()


@app.route('/overlay/insert/<int:image_id>/<int:place_id>/<int:link_id>', methods=['POST', 'GET'])
@required_group('editor')
def overlay_insert(image_id: int, place_id: int, link_id: int) -> Union[str, Response]:
    form = OverlayForm()
    if form.validate_on_submit():
        Overlay.insert(form=form, image_id=image_id, place_id=place_id, link_id=link_id)
        return redirect(url_for('entity_view', id_=place_id) + '#tab-file')
    return render_template(
        'overlay/insert.html',
        form=form,
        crumbs=[
            [_('place'), url_for('index', view='place')],
            Entity.get_by_id(place_id),
            Entity.get_by_id(image_id),
            _('overlay')])


@app.route('/overlay/update/<int:id_>', methods=['POST', 'GET'])
@required_group('editor')
def overlay_update(id_: int) -> Union[str, Response]:
    overlay = Overlay.get_by_id(id_)
    form = OverlayForm()
    if form.validate_on_submit():
        Overlay.update(form=form, image_id=overlay.image_id, place_id=overlay.place_id)
        flash(_('info update'), 'info')
        return redirect(url_for('entity_view', id_=overlay.place_id) + '#tab-file')
    bounding = ast.literal_eval(overlay.bounding_box)
    form.top_left_easting.data = bounding[0][1]
    form.top_left_northing.data = bounding[0][0]
    form.bottom_right_easting.data = bounding[1][1]
    form.bottom_right_northing.data = bounding[1][0]
    entity = Entity.get_by_id(overlay.place_id)
    return render_template(
        'overlay/update.html',
        form=form,
        overlay=overlay,
        entity=entity,
        crumbs=[
            [_('place'), url_for('index', view='place')],
            entity,
            Entity.get_by_id(overlay.image_id),
            _('update overlay')])


@app.route('/overlay/remove/<int:id_>/<int:place_id>')
@required_group('editor')
def overlay_remove(id_: int, place_id: int) -> Response:
    Overlay.remove(id_)
    return redirect(url_for('entity_view', id_=place_id) + '#tab-file')

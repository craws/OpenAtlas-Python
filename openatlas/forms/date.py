from typing import Any, TYPE_CHECKING, Union

import numpy
from flask_babel import lazy_gettext as _
from flask_wtf import FlaskForm
from wtforms import IntegerField, StringField
from wtforms.validators import NoneOf, NumberRange, Optional

from openatlas.models.link import Link

if TYPE_CHECKING:  # pragma: no cover - Type checking is disabled in tests
    from openatlas.models.entity import Entity


def add_date_fields(form: Any) -> None:
    validator_day = [Optional(), NumberRange(min=1, max=31)]
    validator_month = [Optional(), NumberRange(min=1, max=12)]
    validator_year = [Optional(), NumberRange(min=-4713, max=9999), NoneOf([0])]

    setattr(form, 'begin_year_from',
            IntegerField(render_kw={'placeholder': _('YYYY')}, validators=validator_year))
    setattr(form, 'begin_month_from',
            IntegerField(render_kw={'placeholder': _('MM')}, validators=validator_month))
    setattr(form, 'begin_day_from',
            IntegerField(render_kw={'placeholder': _('DD')}, validators=validator_day))
    setattr(form, 'begin_year_to',
            IntegerField(render_kw={'placeholder': _('YYYY')}, validators=validator_year))
    setattr(form, 'begin_month_to',
            IntegerField(render_kw={'placeholder': _('MM')}, validators=validator_month))
    setattr(form, 'begin_day_to',
            IntegerField(render_kw={'placeholder': _('DD')}, validators=validator_day))
    setattr(form, 'begin_comment',
            StringField(render_kw={'placeholder': _('comment')}))
    setattr(form, 'end_year_from',
            IntegerField(render_kw={'placeholder': _('YYYY')}, validators=validator_year))
    setattr(form, 'end_month_from',
            IntegerField(render_kw={'placeholder': _('MM')}, validators=validator_month))
    setattr(form, 'end_day_from',
            IntegerField(render_kw={'placeholder': _('DD')}, validators=validator_day))
    setattr(form, 'end_year_to',
            IntegerField(render_kw={'placeholder': _('YYYY')}, validators=validator_year))
    setattr(form, 'end_month_to',
            IntegerField(render_kw={'placeholder': _('MM')}, validators=validator_month))
    setattr(form, 'end_day_to',
            IntegerField(render_kw={'placeholder': _('DD')}, validators=validator_day))
    setattr(form, 'end_comment',
            StringField(render_kw={'placeholder': _('comment')}))


def populate_dates(form: FlaskForm, item: Union['Entity', Link]) -> None:
    if item.begin_from:
        form.begin_year_from.data = format_date(item.begin_from, 'year')
        form.begin_month_from.data = format_date(item.begin_from, 'month')
        form.begin_day_from.data = format_date(item.begin_from, 'day')
        form.begin_comment.data = item.begin_comment
        if item.begin_to:
            form.begin_year_to.data = format_date(item.begin_to, 'year')
            form.begin_month_to.data = format_date(item.begin_to, 'month')
            form.begin_day_to.data = format_date(item.begin_to, 'day')
    if item.end_from:
        form.end_year_from.data = format_date(item.end_from, 'year')
        form.end_month_from.data = format_date(item.end_from, 'month')
        form.end_day_from.data = format_date(item.end_from, 'day')
        form.end_comment.data = item.end_comment
        if item.end_to:
            form.end_year_to.data = format_date(item.end_to, 'year')
            form.end_month_to.data = format_date(item.end_to, 'month')
            form.end_day_to.data = format_date(item.end_to, 'day')


def format_date(date: numpy.datetime64, part: str) -> str:
    string = str(date).split(' ')[0]
    bc = False
    if string.startswith('-') or string.startswith('0000'):
        bc = True
        string = string[1:]
    parts = string.split('-')
    if part == 'year':  # If it's a negative year, add one year
        return '-' + str(int(parts[0]) + 1) if bc else str(int(parts[0]))
    if part == 'month':
        return parts[1]
    return parts[2]

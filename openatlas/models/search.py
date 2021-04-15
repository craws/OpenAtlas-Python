from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import ValuesView

from flask_login import current_user
from flask_wtf import FlaskForm

from openatlas.database.entity import Entity as Db
from openatlas.models.date import Date
from openatlas.models.entity import Entity
from openatlas.models.link import Link


def search(form: FlaskForm) -> ValuesView[Entity]:
    if not form.term.data:
        return {}.values()
    classes = form.classes.data
    if 'person' in classes:
        classes.append('actor_appellation')
    if 'place' in classes:
        classes.append('appellation')

    # Repopulate date fields with autocompleted values
    from_date = Date.form_to_datetime64(
        form.begin_year.data,
        form.begin_month.data,
        form.begin_day.data)
    to_date = Date.form_to_datetime64(
        form.end_year.data,
        form.end_month.data,
        form.end_day.data,
        to_date=True)
    if from_date:
        string = str(from_date)
        if string.startswith('-') or string.startswith('0000'):
            string = string[1:]
        parts = string.split('-')
        form.begin_month.raw_data = None
        form.begin_day.raw_data = None
        form.begin_month.data = int(parts[1])
        form.begin_day.data = int(parts[2])
    if to_date:
        string = str(to_date)
        if string.startswith('-') or string.startswith('0000'):
            string = string[1:]  # pragma: no cover
        parts = string.split('-')
        form.end_month.raw_data = None
        form.end_day.raw_data = None
        form.end_month.data = int(parts[1])
        form.end_day.data = int(parts[2])

    # Get search results
    entities = []
    for row in Db.search(
            form.term.data,
            form.classes.data,
            form.desc.data,
            form.own.data,
            current_user.id):
        if row['system_class'] == 'actor_appellation':  # If found in actor alias
            entity = Link.get_linked_entity(row['id'], 'P131', True)
        elif row['system_class'] == 'appellation':  # If found in place alias
            entity = Link.get_linked_entity(row['id'], 'P1', True)
        else:
            entity = Entity(row)

        if not entity:  # pragma: no cover
            continue

        if not from_date and not to_date:
            entities.append(entity)
            continue

        # Date criteria present but entity has no dates
        if not entity.begin_from and not entity.begin_to and not entity.end_from \
                and not entity.end_to:
            if form.include_dateless.data:  # Include dateless entities
                entities.append(entity)
            continue

        # Check date criteria
        dates = [entity.begin_from, entity.begin_to, entity.end_from, entity.end_to]
        begin_check_ok = False
        if not from_date:
            begin_check_ok = True  # pragma: no cover
        else:
            for date in dates:
                if date and date >= from_date:
                    begin_check_ok = True

        end_check_ok = False
        if not to_date:
            end_check_ok = True  # pragma: no cover
        else:
            for date in dates:
                if date and date <= to_date:
                    end_check_ok = True

        if begin_check_ok and end_check_ok:
            entities.append(entity)
    return {d.id: d for d in entities}.values()  # Remove duplicates before returning

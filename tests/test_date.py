from flask import url_for

from openatlas import app
from tests.base import TestBaseCase


class DateTest(TestBaseCase):

    def test_date(self) -> None:
        with app.app_context():  # type: ignore
            # Dates insert (don't change year values - they test leap years too)
            data = {
                'name': 'Date place',
                'begin_year_from': -1949, 'begin_month_from': 2, 'begin_day_from': 8,
                'begin_year_to': -1948, 'end_year_from': 1996, 'end_year_to': 1996,
                self.precision_geonames: '',
                self.precision_wikidata: ''}
            rv = self.app.post(url_for('insert', class_='place'), data=data, follow_redirects=True)
            assert b'Date place' in rv.data

            # Invalid dates
            data['begin_day_from'] = 31
            rv = self.app.post(url_for('insert', class_='place'), data=data, follow_redirects=True)
            assert b'Not a valid date' in rv.data

            # Invalid time span (first after second date)
            data['begin_day_from'] = 5
            data['begin_year_from'] = 20
            rv = self.app.post(url_for('insert', class_='place'), data=data, follow_redirects=True)
            assert b'First date cannot be after second' in rv.data

            # Invalid begin dates which are after end dates
            data['begin_year_from'] = -1949
            data['end_year_from'] = -2000
            rv = self.app.post(url_for('insert', class_='place'), data=data, follow_redirects=True)
            assert b'Begin dates cannot start after end dates' in rv.data
            data['end_year_to'] = ''
            rv = self.app.post(url_for('insert', class_='place'), data=data, follow_redirects=True)
            assert b'Begin dates cannot start after end dates' in rv.data

            # Missing form fields
            data['begin_year_from'] = ''
            rv = self.app.post(url_for('insert', class_='place'), data=data, follow_redirects=True)
            assert b'Required for time span' in rv.data

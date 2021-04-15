from flask import g, url_for
from nose.tools import raises

from openatlas import app
from openatlas.api.v02.resources.error import EntityDoesNotExistError, FilterOperatorError, \
    InvalidCidocClassCode, InvalidCodeError, InvalidLimitError, InvalidSearchDateError, \
    InvalidSearchNumberError, InvalidSubunitError, NoSearchStringError, QueryEmptyError
from openatlas.models.entity import Entity
from openatlas.models.gis import Gis
from openatlas.models.node import Node
from openatlas.models.reference_system import ReferenceSystem
from tests.base import TestBaseCase, insert_entity


class ApiTests(TestBaseCase):

    def test_api(self) -> None:
        with app.app_context():  # type: ignore
            with app.test_request_context():
                app.preprocess_request()  # type: ignore
                place = insert_entity('Nostromos', 'place', description='That is the Nostromos')
                if not place:  # Needed for Mypy
                    return  # pragma: no cover

                # Adding Dates to place
                place.begin_from = '2018-01-31'
                place.begin_to = '2018-03-01'
                place.begin_comment = 'Begin of the Nostromos'
                place.end_from = '2019-01-31'
                place.end_to = '2019-03-01'
                place.end_comment = 'Destruction of the Nostromos'
                place.update()

                location = place.get_linked_entity_safe('P53')
                Gis.add_example_geom(location)

                # Adding Type Settlement
                place.link('P2', Node.get_hierarchy('Place'))

                # Adding Alias
                alias = insert_entity('Cargo hauler', 'appellation')
                place.link('P1', alias)

                # Adding External Reference
                external_reference = insert_entity('https://openatlas.eu', 'external_reference')
                external_reference.link('P67', place, description='OpenAtlas Website')

                # Adding feature to place
                feature = insert_entity('Feature', 'feature', place)

                # Adding stratigraphic to place
                insert_entity('Strato', 'stratigraphic_unit', feature)

                # Adding Administrative Unit Node
                unit_node = Node.get_hierarchy('Administrative unit')

                # Adding File to place
                file = insert_entity('Datei', 'file')
                file.link('P67', place)
                file.link('P2', g.nodes[Node.get_hierarchy('License').subs[0]])

                # Adding Value Type
                value_type = Node.get_hierarchy('Dimensions')
                place.link('P2', Entity.get_by_id(value_type.subs[0]), '23.0')

                # Adding Geonames
                geonames = Entity.get_by_id(ReferenceSystem.get_by_name('GeoNames').id)
                precision_id = Node.get_hierarchy('External reference match').subs[0]
                geonames.link('P67', place, description='2761369', type_id=precision_id)

                # Testing directly against model
                # parser = {'download': False, 'count': False, 'sort': 'asc', 'column': ['name'],
                #           'filter': None, 'limit': 20, 'first': None, 'last': None,
                #           'show': ['when', 'types', 'relations', 'names', 'links', 'geometry',
                #                    'depictions', 'geonames'], 'export': None}
                # data = GeoJsonEntity.get_entity(place, parser)
                # test_data = {
                #     'type': 'FeatureCollection',
                #     'start': {
                #         'earliest': '2018-01-31'
                #     },
                # }
                # print(data['features'][0]['when']['timespans'][0]['start'])
                # for key, value in test_data.items():
                #     assert data[key] == value

            # Test GeoJson output
            rv = self.app.get(url_for('entity', id_=place.id))
            assert b'"@id": "http://local.host/entity/' in rv.data
            assert b'"crmClass": "crm:E18 Physical Thing"' in rv.data
            assert b'"title": "Nostromos"' in rv.data
            assert b'"value": "That is the Nostromos"' in rv.data
            # types
            assert b'"identifier": "http://local.host/api/0.2/entity/102"' in rv.data
            assert b'"label": "Height"' in rv.data
            assert b'"hierarchy": "Dimensions"' in rv.data
            assert b'"value": 23.0' in rv.data
            # relations
            assert b'"label": "Cargo hauler"' in rv.data
            assert b'"relationTo": "http://local.host/api/0.2/entity/106"' in rv.data
            assert b'"relationType": "crm:P1_is_identified_by"' in rv.data
            assert b'"relationSystemClass": "appellation"' in rv.data
            assert b'"relationSystemClass": "feature"' in rv.data
            assert b'"relationSystemClass": "type"' in rv.data
            assert b'"relationSystemClass": "object_location"' in rv.data
            assert b'"relationSystemClass": "file"' in rv.data
            assert b'"relationSystemClass": "reference_system"' in rv.data
            assert b'"type": "close match"' in rv.data
            # alias
            assert b'"alias": "Cargo hauler"' in rv.data
            # geometry
            assert b'"type": "Point"' in rv.data
            assert b'"coordinates": [' in rv.data
            # depictions
            assert b'"title": "Datei"' in rv.data
            assert b'"license": "Open license"' in rv.data
            # links
            assert b'"identifier": "https://www.geonames.org/' in rv.data

            # Path Tests
            rv = self.app.get(url_for('usage'))
            assert b'message' in rv.data
            rv = self.app.get(url_for('latest', latest=10))
            assert b'Datei' in rv.data
            rv = self.app.get(url_for('latest', count=True, latest=1))
            assert b'1' in rv.data

            rv = self.app.get(url_for('code', code='reference'))
            assert b'openatlas' in rv.data
            rv = self.app.get(url_for('system_class', system_class='appellation'))
            assert b'Cargo hauler' in rv.data
            rv = self.app.get(url_for('class', class_code='E31'))
            assert b'https://openatlas.eu' in rv.data
            rv = self.app.get(url_for('node_entities', id_=unit_node.id))
            assert b'Austria' in rv.data
            rv = self.app.get(url_for('node_entities_all', id_=unit_node.id))
            assert b'Austria' in rv.data
            rv = self.app.get(url_for('type_entities', id_=unit_node.id))
            assert b'Austria' in rv.data
            rv = self.app.get(url_for('type_entities_all', id_=unit_node.id))
            assert b'Austria' in rv.data
            rv = self.app.get(
                url_for('query', entities=place.id, classes='E18', items='place'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('content', lang='de'))
            assert b'intro' in rv.data
            rv = self.app.get(url_for('overview_count'))
            assert b'systemClass' in rv.data
            rv = self.app.get(url_for('class_mapping'))
            assert b'systemClass' in rv.data
            rv = self.app.get(url_for('node_overview'))
            assert b'Actor' in rv.data
            rv = self.app.get(url_for('type_tree'))
            assert b'type_tree' in rv.data

            # Path test with download
            rv = self.app.get(url_for('entity', id_=place.id, download=True))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('latest', latest=1, download=True))
            assert b'Datei' in rv.data
            rv = self.app.get(url_for('code', code='reference', download=True))
            assert b'https://openatlas.eu' in rv.data
            rv = self.app.get(url_for('system_class', system_class='appellation', download=True))
            assert b'Cargo hauler' in rv.data
            rv = self.app.get(url_for('class', class_code='E31', download=True))
            assert b'https://openatlas.eu' in rv.data
            rv = self.app.get(url_for('node_entities', id_=unit_node.id, download=True))
            assert b'Austria' in rv.data
            rv = self.app.get(url_for('node_entities_all', id_=unit_node.id, download=True))
            assert b'Austria' in rv.data
            rv = self.app.get(url_for('query', classes='E31', download=True))
            assert b'https://openatlas.eu' in rv.data
            rv = self.app.get(url_for('content', lang='de', download=True))
            assert b'intro' in rv.data
            rv = self.app.get(url_for('overview_count', download=True))
            assert b'systemClass' in rv.data
            rv = self.app.get(url_for('class_mapping', download=True))
            assert b'systemClass' in rv.data
            rv = self.app.get(url_for('node_overview', download=True))
            assert b'Actor' in rv.data

            # Path with export
            rv = self.app.get(url_for('entity', id_=place.id, export='csv'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('class', class_code='E18', export='csv'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('system_class', system_class='place', export='csv'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('code', code='reference', export='csv'))
            assert b'https://openatlas.eu' in rv.data

            # Testing Subunit
            rv = self.app.get(url_for('subunit', id_=place.id))
            assert b'Feature' in rv.data and b'Strato' not in rv.data
            rv = self.app.get(url_for('subunit', id_=place.id, download=True))
            assert b'Feature' in rv.data and b'Strato' not in rv.data
            rv = self.app.get(url_for('subunit', id_=place.id, count=True))
            assert b'1' in rv.data
            rv = self.app.get(url_for('subunit_hierarchy', id_=place.id))
            assert b'Strato' in rv.data
            rv = self.app.get(url_for('subunit_hierarchy', id_=place.id, download=True))
            assert b'Strato' in rv.data
            rv = self.app.get(url_for('subunit_hierarchy', id_=place.id, count=True))
            assert b'2' in rv.data

            # Parameter: filter
            rv = self.app.get(url_for('code', code='place', limit=10, sort='desc', column='name',
                                      filter='or|name|like|Nostromos'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('code', code='reference'))
            assert b'openatlas' in rv.data
            rv = self.app.get(url_for('class', class_code='E18', filter='or|name|like|Nostr'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('code', code='place', filter='or|id|eq|' + str(place.id)))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('code', code='place', filter='or|begin_from|ge|2018-1-1'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('code', code='place', filter='or|begin_from|ge|2018-1-1'))
            assert b'Nostromos' in rv.data

            # Parameter: last
            rv = self.app.get(url_for('class', class_code='E18', last=place.id))
            assert b'entities' in rv.data
            # Parameter: first
            rv = self.app.get(url_for('class', class_code='E18', first=place.id))
            assert b'entities' in rv.data

            # Parameter: show
            rv = self.app.get(url_for('class', class_code='E31', show='types'))
            assert b'https://openatlas.eu' in rv.data
            rv = self.app.get(url_for('class', class_code='E18', show='when'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(url_for('class', class_code='E31', show='none'))
            assert b'https://openatlas.eu' in rv.data

            # Parameter: count
            rv = self.app.get(url_for('class', class_code='E31', count=True))
            assert b'2' in rv.data
            rv = self.app.get(url_for('code', code='place', count=True))
            assert b'3' in rv.data
            rv = self.app.get(url_for('system_class', system_class='appellation', count=True))
            assert b'1' in rv.data

            rv = self.app.get(
                url_for('query', entities=place.id, classes='E18', codes='place'))
            assert b'Nostromos' in rv.data
            rv = self.app.get(
                url_for('query', entities=place.id, classes='E18', codes='place', count=True))
            assert b'7' in rv.data
            rv = self.app.get(url_for('node_entities', id_=unit_node.id, count=True))
            assert b'6' in rv.data
            rv = self.app.get(url_for('node_entities_all', id_=unit_node.id, count=True))
            assert b'8' in rv.data

    @raises(EntityDoesNotExistError)
    def error_class_entity(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('class', class_code='E18', last=1231223121321))

    @raises(QueryEmptyError)
    def error_query_query(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('query'))

    @raises(InvalidSubunitError)
    def error_node_invalid(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('node_entities', id_=1234))

    @raises(InvalidSubunitError)
    def error_node_all_invalid(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('node_entities_all', id_=1234))

    @raises(InvalidCidocClassCode)
    def error_class_invalid(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('class', class_code='e99999999'))

    @raises(InvalidCodeError)
    def error_code_invalid(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='Invalid'))

    @raises(InvalidLimitError)
    def error_latest_invalid(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('latest', latest='99999999'))

    @raises(EntityDoesNotExistError)
    def error_subunit_entity(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('subunit', id_='99999999'))

    @raises(FilterOperatorError)
    def error_filter_operator_1(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='place', filter='Wrong|name|like|Nostromos'))

    @raises(FilterOperatorError)
    def error_filter_operator_2(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='place', filter='or|Wrong|like|Nostromos'))

    @raises(FilterOperatorError)
    def error_filter_operator_3(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='place', filter='or|name|Wrong|Nostromos'))

    @raises(NoSearchStringError)
    def error_filter_search(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='place', filter='or|name|Wrong|'))

    @raises(InvalidSearchDateError)
    def error_filter_date(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='place', filter='or|begin_from|like|WRONG'))

    @raises(InvalidSearchNumberError)
    def error_filter_date2(self) -> None:  # pragma: nocover
        with app.app_context():  # type: ignore
            self.app.get(url_for('code', code='place', filter='or|id|eq|WRONG'))

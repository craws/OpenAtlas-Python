from __future__ import annotations  # Needed for Python 4.0 type annotations

from typing import Any, Dict, List

from flask import g, session

import openatlas
from openatlas import app
from openatlas.database.model import Model as Db


class CidocClass:

    def __init__(self, data: Dict[str, Any]) -> None:
        self._name = data['name']
        self.code = data['code']
        self.id = data['id']
        self.comment = data['comment']
        self.count = data['count']
        self.i18n: Dict[str, str] = {}
        self.sub: List[CidocClass] = []
        self.super: List[CidocClass] = []

    @property
    def name(self) -> str:
        return self.get_i18n()

    def get_i18n(self) -> str:
        locale_session = openatlas.get_locale()
        if locale_session in self.i18n:
            return self.i18n[locale_session]
        locale_default = session['settings']['default_language']
        if locale_default in self.i18n:
            return self.i18n[locale_default]
        return getattr(self, '_name')  # pragma: no cover

    @staticmethod
    def get_all() -> Dict[str, CidocClass]:
        classes = {row['code']: CidocClass(row) for row in Db.get_classes()}
        for row in Db.get_class_hierarchy():
            classes[row['super_code']].sub.append(row['sub_code'])
            classes[row['sub_code']].super.append(row['super_code'])
        for row in Db.get_class_translations(app.config['LANGUAGES'].keys()):
            classes[row['class_code']].i18n[row['language_code']] = row['text']
        return classes


class CidocProperty:

    def __init__(self, data: Dict[str, Any]) -> None:
        self.id = data['id']
        self._name = data['name']
        self._name_inverse = data['name_inverse']
        self.code = data['code']
        self.comment = data['comment'],
        self.domain_class_code = data['domain_class_code']
        self.range_class_code = data['range_class_code']
        self.count = data['count']
        self.sub: List[int] = []
        self.super: List[int] = []
        self.i18n: Dict[str, str] = {}
        self.i18n_inverse: Dict[str, str] = {}

    @property
    def name(self) -> str:
        locale_session = openatlas.get_locale()
        if locale_session in self.i18n:
            return self.i18n[locale_session]
        locale_default = session['settings']['default_language']
        if locale_default in self.i18n:
            return self.i18n[locale_default]
        return getattr(self, '_name')  # pragma: no cover

    @property
    def name_inverse(self) -> str:
        locale_session = openatlas.get_locale()
        if locale_session in self.i18n_inverse:
            return self.i18n_inverse[locale_session]
        locale_default = session['settings']['default_language']
        if locale_default in self.i18n_inverse:
            return self.i18n_inverse[locale_default]
        return getattr(self, '_name_inverse')  # pragma: no cover

    def find_object(self, attr: str, class_id: int) -> bool:  # Check if links are CIDOC CRM valid
        valid_domain_id = getattr(self, attr)
        if valid_domain_id == class_id:
            return True
        return self.find_subs(attr, class_id, g.cidoc_classes[valid_domain_id].sub)

    def find_subs(self, attr: str, class_id: int, valid_subs: List[int]) -> bool:
        for sub_id in valid_subs:
            if sub_id == class_id:
                return True
            elif self.find_subs(attr, class_id, g.cidoc_classes[sub_id].sub):
                return True
        return False

    @staticmethod
    def get_all() -> Dict[str, CidocProperty]:
        properties = {row['code']: CidocProperty(row) for row in Db.get_properties()}
        for row in Db.get_property_hierarchy():
            properties[row['super_code']].sub.append(row['sub_code'])
            properties[row['sub_code']].super.append(row['super_code'])
        for row in Db.get_property_translations(app.config['LANGUAGES'].keys()):
            properties[row['property_code']].i18n[row['language_code']] = row['text']
            properties[row['property_code']].i18n_inverse[
                row['language_code']] = row['text_inverse']
        return properties

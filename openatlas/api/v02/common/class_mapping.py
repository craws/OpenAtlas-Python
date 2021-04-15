from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.v02.templates.class_mapping import ClassMappingTemplate
from openatlas.util.util import api_access


class ClassMapping(Resource):  # type: ignore
    @api_access()  # type: ignore
    # @swag_from("../swagger/class_mapping.yml", endpoint="class_mapping")
    def get(self) -> Union[Tuple[Resource, int], Response]:
        return marshal(ClassMapping.mapping, ClassMappingTemplate.class_mapping_template()), 200

    mapping = [
        {
            "systemClass": "acquisition",
            "crmClass": "E8",
            "view": "event",
            "icon": "mdi-calendar",
            "en": "Acquisition"},
        {
            "systemClass": "activity",
            "crmClass": "E7",
            "view": "event",
            "icon": "mdi-calendar",
            "en": "Activity"},
        {
            "systemClass": "actor_appellation",
            "crmClass": "E82",
            "view": None,
            "icon": None,
            "en": "Actor Appellation"},
        {
            "systemClass": "administrative_unit",
            "crmClass": "E53",
            "view": "type",
            "icon": "mdi-map-marker",
            "en": "Place"},
        {
            "systemClass": "appellation",
            "crmClass": "E41",
            "view": None,
            "icon": None,
            "en": "Appellation"},
        {
            "systemClass": "artifact",
            "crmClass": "E22",
            "view": "artifact",
            "icon": "mdi-shapes",
            "en": "Man-Made Object"},
        {
            "systemClass": "bibliography",
            "crmClass": "E31",
            "view": "reference",
            "icon": "mdi-text-box",
            "en": "Document"},
        {
            "systemClass": "edition",
            "crmClass": "E31",
            "view": "reference",
            "icon": "mdi-text-box",
            "en": "Document"},
        {
            "systemClass": "external_reference",
            "crmClass": "E31",
            "view": "reference",
            "icon": "mdi-text-box",
            "en": "Document"},
        {
            "systemClass": "feature",
            "crmClass": "E18",
            "view": "place",
            "icon": "mdi-map-marker",
            "en": "Physical Thing"},
        {
            "systemClass": "file",
            "crmClass": "E31",
            "view": "file",
            "icon": "mdi-text-box",
            "en": "Document"},
        {
            "systemClass": "find",
            "crmClass": "E22",
            "view": "place",
            "icon": "mdi-map-marker",
            "en": "Man-Made Object"},
        {
            "systemClass": "group",
            "crmClass": "E74",
            "view": "actor",
            "icon": "mdi-account",
            "en": "Group"},
        {
            "systemClass": "human_remains",
            "crmClass": "E20",
            "view": "place",
            "icon": "mdi-map-marker",
            "en": "Biological Object"},
        {
            "systemClass": "move",
            "crmClass": "E9",
            "view": "event",
            "icon": "mdi-calendar",
            "en": "Move"},
        {
            "systemClass": "object_location",
            "crmClass": "E53",
            "view": None,
            "icon": None,
            "en": "Place"},
        {
            "systemClass": "person",
            "crmClass": "E21",
            "view": "actor",
            "icon": "mdi-account",
            "en": "Person"},
        {
            "systemClass": "place",
            "crmClass": "E18",
            "view": "place",
            "icon": "mdi-map-marker",
            "en": "Physical Thing"},
        {
            "systemClass": "reference_system",
            "crmClass": "E32",
            "view": None,
            "icon": None,
            "en": "Authority Document"},
        {
            "systemClass": "source",
            "crmClass": "E33",
            "view": "source",
            "icon": "mdi-text-box",
            "en": "Linguistic Object"},
        {
            "systemClass": "stratigraphic_unit",
            "crmClass": "E18",
            "view": "place",
            "icon": "mdi-map-marker",
            "en": "Physical Thing"},
        {
            "systemClass": "source_translation",
            "crmClass": "E33",
            "view": "source_translation",
            "icon": "mdi-text-box",
            "en": "Linguistic Object"},
        {
            "systemClass": "type",
            "crmClass": "E55",
            "view": "type",
            "icon": None,
            "en": "Type"}]

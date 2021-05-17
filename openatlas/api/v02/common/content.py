from typing import Tuple, Union

from flask import Response
from flask_restful import Resource, marshal

from openatlas.api.v02.resources.download import Download
from openatlas.api.v02.resources.parser import language_parser
from openatlas.api.v02.templates.content import ContentTemplate
from openatlas.models.content import Content


class GetContent(Resource):  # type: ignore
    @staticmethod
    def get() -> Union[Tuple[Resource, int], Response]:
        parser = language_parser.parse_args()
        content = {
            'intro': Content.get_translation('intro_for_frontend', parser['lang']),
            'contact': Content.get_translation('contact_for_frontend', parser['lang']),
            'legal-notice': Content.get_translation('legal_notice_for_frontend', parser['lang']),
            'site-name': Content.get_translation('site_name_for_frontend', parser['lang'])}
        template = ContentTemplate.content_template()
        if parser['download']:
            return Download.download(data=content, template=template, name='content')
        return marshal(content, template), 200

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from typing import List

version = '6.2.0'
release = '6.2.0'
templates_path = ['_templates']
source_suffix = '.rst'
master_doc = 'index'
project = 'OpenAtlas'
author = 'Alexander Watzinger and the OpenAtlas team'
language = 'en'
pygments_style = 'sphinx'
extensions: List[str] = []

html_logo = 'logo.png'
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_domain_indices = False
html_use_index = False
html_copy_source = False  # prevent including source html files
html_show_copyright = False

html_theme_options = {
    'display_version': True,
    'style_external_links': True,
    'navigation_depth': 2}

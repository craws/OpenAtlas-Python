from setuptools import setup

package_json = {
    "dependencies": {
        "jquery": "^3.4.1",
        "d3": "^5.12.0",
        "@fortawesome/fontawesome-free": "^5.11.2",
        "huebee": "^2.0.0",
        "jquery-ui-dist": "^1.12.1",
        "jquery-validation": "^1.19.1",
        "jstree": "^3.3.8",
        "datatables.net": "^1.10.20",
        "datatables.net-dt": "^1.10.20",
        "datatables.net-buttons": "^1.6.1",
        "datatables.net-buttons-dt": "^1.6.1",
        "datatables.net-bs4": "^1.10.20",
        "leaflet": "^1.5.1",
        "save-svg-as-png": "^1.4.14",
        "tinymce": "^5.1.1",
        "bootstrap": "^4.3.1",
        "popper.js": "^1.16.0",
        "bootstrap-autocomplete": "2.3.7"
    }
}

setup(
    name='openatlas',
    setup_requires=[
        'calmjs',
    ],
    package_json=package_json
)

/* Variables for a selected geometry */
var name;
var description;
var shapeType; // centerpoint, polyline, shape or area
var objectName; // Name of the entry at update of an existing entry

var captureCoordinates = false; // Boolean if clicks on map should be captured as coordinates
var marker = false; // Temporary marker for point coordinate
var newMarker = false; // Temporary marker for point update coordinate
var layer = false;
var newLayer = false; // Temporary marker to update a point coordinate
var editLayer = false;
var editedLayer = false;
var drawLayer = false;
var drawnPolygon = L.featureGroup();
var geoJsonArray = []; // Polygon/Polyline coordinates storage

/* Controls with EasyButton */
L.Control.EasyButtons = L.Control.extend({
    onAdd: function () {
        var container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
        this.link = L.DomUtil.create('a', 'leaflet-bar-part', container);
        this._addImage()
        this.link.href = '#';
        L.DomEvent.on(this.link, 'click', this._click, this);
        this.link.title = this.options.title;
        return container;
    },
    _click: function (e) {
        L.DomEvent.stopPropagation(e);
        L.DomEvent.preventDefault(e);
        this.intendedFunction();
    },
    _addImage: function () {
        L.DomUtil.create('i', this.options.intentedIcon, this.link);
    }
});

pointButton = new L.Control.EasyButtons({
    position: 'topright',
    intentedIcon: 'fa-map-marker-alt fa',
    title: translate['map_info_centerpoint']
})
pointButton.intendedFunction = function () {
    drawGeometry('centerpoint');
}
map.addControl(pointButton);

polylineButton = new L.Control.EasyButtons({
    position: 'topright',
    intentedIcon: 'fa-project-diagram fa',
    title: translate['map_info_linestring']
})
polylineButton.intendedFunction = function () {
    drawGeometry('polyline');
}
map.addControl(polylineButton);

polygonButton = new L.Control.EasyButtons({
    position: 'topright',
    intentedIcon: 'fa-vector-square fa',
    title: translate['map_info_shape']
})
polygonButton.intendedFunction = function () {
    drawGeometry('shape');
}
map.addControl(polygonButton);

areaButton = new L.Control.EasyButtons({
    position: 'topright',
    intentedIcon: 'fa-draw-polygon fa',
    title: translate['map_info_area']
})
areaButton.intendedFunction = function () {
    drawGeometry('area');
}
map.addControl(areaButton);

inputForm = L.control();
inputForm.onAdd = function (map) {
    div = L.DomUtil.create('div', 'mapFormDiv');
    div.innerHTML = `
        <form id="geometryForm" onmouseover="interactionOff()" onmouseout="interactionOn()">
            <span id="closeButton" title="` + translate["map_info_close"] + `" onclick="closeForm()" class="fad">X</span>
            <span id="inputFormTitle"></span>
            <p id="inputFormInfo"></p>
            <input type="text" id="nameField" placeholder="Enter a name if desired">
            <textarea rows="3" cols="70" id="descriptionField" placeholder="` + translate["map_info_description"] + `"/></textarea>
            <div id="coordinatesDiv">
                <div style="display:block;clear:both;">
                    <label for='easting'>Easting</label>
                    <input type="text" style="margin-top:0.5em;" oninput="check_coordinates_input()" id="easting" placeholder="decimal degrees">
                </div>
                <div style="display:block;clear:both;">
                    <label for='northing'>Northing</label>
                    <input type="text" style="margin-top:0.5em;" oninput="check_coordinates_input()" id="northing" placeholder="decimal degrees">
                </div>
            </div>
            <div style="clear:both;"></div>
            <input type="button" id="saveButton" disabled value="` + translate["save"] + `" onclick="saveForm('` + shapeType + `')">
        </form>`;
    return div;
};

map.on('click', function (e) {
    if (captureCoordinates && shapeType == 'centerpoint') {
        $('#saveButton').prop('disabled', false);
        if (marker) {  // Marker already exists so move it
            marker.setLatLng(e.latlng);
            marker.on('dragend', function (event) {
                var marker = event.target;
                position = marker.getLatLng();
                $('#northing').val(position.lat);
                $('#easting').val(position.lng);
            });
        } else {  // No marker exists so create it
            marker = new L.marker(e.latlng, {draggable: true, icon: newIcon});
            marker.addTo(map);
            wgs84 = (marker.getLatLng());
            $('#northing').val(wgs84.lat);
            $('#easting').val(wgs84.lng);
        }
        wgs84 = marker.getLatLng();
        marker.on('dragend', function (event) {
            var marker = event.target;
            position = marker.getLatLng();
            $('#northing').val(position.lat);
            $('#easting').val(position.lng);
        });
        $('#northing').val(wgs84.lat);
        $('#easting').val(wgs84.lng);
    } else if (captureCoordinates && shapeType == 'polyline') {
        $('#saveButton').prop('disabled', false);
    } else if (captureCoordinates) {
        $('#saveButton').prop('disabled', false);
    }
});

map.on('draw:created', function (e) {
    drawnPolygon.addLayer(e.layer);
    layer = e.layer;
    geoJsonArray = [];
    if (Array.isArray(layer.getLatLngs()[0])) coordinates = layer.getLatLngs()[0];
    else coordinates = layer.getLatLngs();
    for (i = 0; i < coordinates.length; i++) {
        geoJsonArray.push('[' + coordinates[i].lng + ',' + coordinates[i].lat + ']');
    }
    // Add first xy again as last xy to close polygon
    if (Array.isArray(layer.getLatLngs()[0])) geoJsonArray.push('[' + coordinates[0].lng + ',' + coordinates[0].lat + ']');
    $('#saveButton').prop('disabled', false);
});

function check_coordinates_input() {
    if ($('#easting').val() && $('#northing').val()) {
        $('#saveButton').prop('disabled', false);
    } else {
        $('#saveButton').prop('disabled', true);
    }
}

function closeForm(withoutSave = true) {
    inputForm.remove(map);
    $('.leaflet-right .leaflet-bar').show();
    interactionOn();
    $('#map').css('cursor', '');
    if (withoutSave) {
        if (shapeType == 'centerpoint') {
            if (editLayer) {
                map.removeLayer(editLayer);
                layer.addTo(map);
            } else if (marker) {
                map.removeLayer(marker);
                marker = false;
            }
        } else {
            drawnPolygon.removeLayer(layer);
            if (drawLayer) {
                drawLayer.disable();
            }
            if (newLayer) {
                map.removeLayer(newLayer);
                newLayer = false;
                map.addLayer(layer);
            }
            if (editLayer) {
                map.removeLayer(editLayer);
                editLayer = false;
                map.addLayer(layer);
            }
        }
    } else {
        if (shapeType == 'centerpoint') {
            if (editLayer) {
                map.removeLayer(editLayer);
            }
            if (newLayer) {
                map.removeLayer(newLayer);
                newLayer = false;
                if (marker) {
                    marker.addTo(map);
                }
            }
        } else {
            if (editLayer) {
                map.removeLayer(editLayer);
                editLayer = false;
            }
            if (newLayer) {
                map.removeLayer(newLayer);
                newLayer = false;
                if (editedLayer) {
                    map.addLayer(editedLayer);
                }
            }
            if (editedLayer) {
                editedLayer = false;
            }
        }
    }
    captureCoordinates = false; // Important that this is the last statement
}

function drawGeometry(selectedType) {
    shapeType = selectedType;
    map.addControl(inputForm);
    $('#inputFormTitle').text(selectedType.substr(0, 1).toUpperCase() + selectedType.substr(1));
    $('#inputFormInfo').text(translate['map_info_' + selectedType]);
    if (selectedType == 'polyline') {
        $('#inputFormInfo').text(translate['map_info_linestring']);
    }
    $('.leaflet-right .leaflet-bar').hide();
    if (selectedType == 'centerpoint') {
        $('#coordinatesDiv').show();
    } else if (selectedType == 'polyline') {
        $('#coordinatesDiv').hide();
        captureCoordinates = false;
        drawLayer = new L.Draw.Polyline(map);
        map.addLayer(drawnPolygon);
        drawLayer.enable();
        drawnPolygon.setStyle({fillColor: '#DA9DC8', color: '#E861C0'});
    } else {
        $('#coordinatesDiv').hide();
        captureCoordinates = false;
        drawLayer = new L.Draw.Polygon(map, {allowIntersection: false});
        map.addLayer(drawnPolygon);
        drawLayer.enable();
        drawnPolygon.setStyle({fillColor: '#DA9DC8', color: '#E861C0'});
    }
}


function saveForm(shapeType) {
    name = $('#nameField').val().replace(/\"/g, '\\"');
    description = $('#descriptionField').val().replace(/\"/g, '\\"');
    if (editLayer || editedLayer) {
        saveEditedGeometry(shapeType);
    } else {
        saveNewGeometry(shapeType);
    }
    closeForm(false);
}

function saveEditedGeometry(shapeType) {
    if (feature.properties.shapeType == 'centerpoint') {
        // Remove former point
        points = JSON.parse($('#gis_points').val());
        $.each(points, function (key, value) {
            if (value.properties.id == feature.properties.id) {
                points.splice(key, 1);
                return false;
            }
        });
        // Add new point
        point =
            `{"type": "Feature", "geometry":` +
            `{"type": "Point", "coordinates": [` + $('#easting').val() + `,` + $('#northing').val() + `]},` +
            `"properties":{"name": "` + name + `", "description": "` + description + `", "shapeType": "centerpoint"}}`;
        points.push(JSON.parse(point));
        $('#gis_points').val(JSON.stringify(points));
        editedLayer = L.marker(editLayer.getLatLng(), {icon: editedIcon}).addTo(map);
        editedLayer.bindPopup(buildPopup(JSON.parse(point), 'edited'));
    } else if (feature.properties.shapeType == 'polyline') {
        // Remove former polyline
        lines = JSON.parse($('#gis_lines').val());
        $.each(lines, function (key, value) {
            if (value.properties.id == feature.properties.id) {
                removed = lines.splice(key, 1)[0];
                return false;
            }
        });
        // Insert new polyline
        // if geometry edited
        if (geoJsonArray.length > 0) {
            coordinates = '[' + geoJsonArray.join(',') + ']'
            line =
                `{"type": "Feature", "geometry":` +
                `{"type": "LineString", "coordinates": ` + coordinates + `},` +
                `"properties":{"name": "` + name + `", "description": "` + description + `", "shapeType": "` + shapeType + `"}}`;
            lines.push(JSON.parse(line));
        }
        // if geometry unchanged just change labels
        else if (geoJsonArray.length === 0) {
            removed.properties.name = name;
            removed.properties.description = description;
            lines.push(removed);
        }
        $('#gis_lines').val(JSON.stringify(lines));
        editedLayer = L.polyline(editLayer.getLatLngs()).addTo(map);
        editedLayer.setStyle({fillColor: '#686868', color: '#686868'});
    } else if (feature.properties.shapeType == 'area' || feature.properties.shapeType == 'shape') {
        // Remove former polygon
        polygons = JSON.parse($('#gis_polygons').val());
        $.each(polygons, function (key, value) {
            if (value.properties.id == feature.properties.id) {
                removed = polygons.splice(key, 1)[0];
                return false;
            }
        });
        // Insert new polygon
        // if geometry edited
        if (geoJsonArray.length > 0) {
            coordinates = '[[' + geoJsonArray.join(',') + ']]'
            polygon =
                `{"type": "Feature", "geometry":` +
                `{"type": "Polygon", "coordinates": ` + coordinates + `},` +
                `"properties":{"name": "` + name + `", "description": "` + description + `", "shapeType": "` + shapeType + `"}}`;
            polygons.push(JSON.parse(polygon));
        }
        // if geometry unchanged just change labels
        else if (geoJsonArray.length === 0) {
            removed.properties.name = name;
            removed.properties.description = description;
            polygons.push(removed);
        }
        $('#gis_polygons').val(JSON.stringify(polygons));
        editedLayer = L.polygon(editLayer.getLatLngs()).addTo(map);
        editedLayer.setStyle({fillColor: '#686868', color: '#686868'});
    }
    geoJsonArray = [];
}

function importNewPoint(geo, popup) {
    popup._close();
    point =
        `{"type": "Feature", "geometry":
         {"type": "Point", "coordinates": [${geo.lng},${geo.lat}]},
         "properties":{"name": "${geo.name}", "description": "${geo.name} (${geo.geonameId}), imported from GeoNames", "shapeType": "centerpoint"}}`;
    points = JSON.parse($('#gis_points').val());
    points.push(JSON.parse(point));
    $('#gis_points').val(JSON.stringify(points));
    var newMarker = L.marker(([geo.lat, geo.lng]), {icon: editedIcon}).addTo(map);
    newMarker.bindPopup(buildPopup(JSON.parse(point), 'edited'));
    marker = false;  // unset the marker
}

function importGeonamesID(geo, popup) {
    $('.GeoNames').val(geo.geonameId);
    popup._close();
}

function importAll(geo, popup) {
    $('.GeoNames').val(geo.geonameId);
    popup._close();
    point =
        `{"type": "Feature", "geometry":
         {"type": "Point", "coordinates": [${geo.lng},${geo.lat}]},
         "properties":{"name": "${geo.name}", "description": "${geo.name} (${geo.geonameId}), imported from GeoNames", "shapeType": "centerpoint"}}`;
    points = JSON.parse($('#gis_points').val());
    points.push(JSON.parse(point));
    $('#gis_points').val(JSON.stringify(points));
    var newMarker = L.marker(([geo.lat, geo.lng]), {icon: editedIcon}).addTo(map);
    newMarker.bindPopup(buildPopup(JSON.parse(point), 'edited'));
    marker = false;  // unset the marker
}

function saveNewGeometry(shapeType) {
    if (shapeType == 'centerpoint') {
        point =
            `{"type": "Feature", "geometry":` +
            `{"type": "Point", "coordinates": [` + $('#easting').val() + `,` + $('#northing').val() + `]},` +
            `"properties":{"name": "` + name + `", "description": "` + description + `", "shapeType": "centerpoint"}}`;
        points = JSON.parse($('#gis_points').val());
        points.push(JSON.parse(point));
        $('#gis_points').val(JSON.stringify(points));
        newMarker = L.marker(([$('#northing').val(), $('#easting').val()]), {icon: editedIcon}).addTo(map);
        newMarker.bindPopup(buildPopup(JSON.parse(point), 'edited'));
        marker = false;  // unset the marker
    } else if (shapeType == 'polyline') {
        linestring =
            `{"type": "Feature", "geometry":` +
            `{"type": "LineString", "coordinates":[` + geoJsonArray.join(',') + `]},
            "properties":{"name": "` + name + `", "description": "` + description + `", "shapeType": "` + shapeType + `"}}`;
        linestrings = JSON.parse($('#gis_lines').val());
        linestrings.push(JSON.parse(linestring));
        $('#gis_lines').val(JSON.stringify(linestrings));
        layer.bindPopup(buildPopup(JSON.parse(linestring), 'edited'));
        layer.addTo(map);
        layer.setStyle({fillColor: '#DA9DC8', color: '#E861C0'});
    } else {
        polygon =
            `{"type": "Feature", "geometry":` +
            `{"type": "Polygon", "coordinates":[[` + geoJsonArray.join(',') + `]]},
            "properties":{"name": "` + name + `", "description": "` + description + `", "shapeType": "` + shapeType + `"}}`;
        polygons = JSON.parse($('#gis_polygons').val());
        polygons.push(JSON.parse(polygon));
        $('#gis_polygons').val(JSON.stringify(polygons));
        layer.bindPopup(buildPopup(JSON.parse(polygon), 'edited'));
        layer.addTo(map);
        layer.setStyle({fillColor: '#DA9DC8', color: '#E861C0'});
    }
}

function deleteGeometry() {
    // Remove layer of geometry, remove geometry from form field value
    if (typeof (editLayer) == 'object') {
        map.removeLayer(editLayer);
    }
    if (typeof (editMarker) == 'object') {
        map.removeLayer(editMarker);
    }
    if (feature.properties.shapeType == 'centerpoint') {
        points = JSON.parse($('#gis_points').val());
        $.each(points, function (key, value) {
            if (value.properties.id == feature.properties.id) {
                points.splice(key, 1);
                return false;
            }
        });
        $('#gis_points').val(JSON.stringify(points));
    } else if (feature.properties.shapeType == 'polyline') {
        polygons = JSON.parse($('#gis_lines').val());
        $.each(polygons, function (key, value) {
            if (value.properties.id == feature.properties.id) {
                polygons.splice(key, 1);
                return false;
            }
        });
        $('#gis_lines').val(JSON.stringify(polygons)); // Write array back to form field
    } else {
        polygons = JSON.parse($('#gis_polygons').val());
        $.each(polygons, function (key, value) {
            if (value.properties.id == feature.properties.id) {
                polygons.splice(key, 1);
                return false;
            }
        });
        $('#gis_polygons').val(JSON.stringify(polygons)); // Write array back to form field
    }
}

function editGeometry() {
    shapeType = feature.properties.shapeType;
    map.closePopup();
    map.addControl(inputForm);
    $('#saveButton').prop('disabled', false);
    $('#inputFormTitle').text(shapeType.substr(0, 1).toUpperCase() + shapeType.substr(1));
    $('#inputFormInfo').text(translate['map_info_' + shapeType]);
    $('#nameField').val(feature.properties.name);
    $('#descriptionField').val(feature.properties.description);
    $('.leaflet-right .leaflet-bar').hide();
    if (feature.properties.shapeType == 'centerpoint') {
        editLayer = L.marker(editLayer.getLatLng(), {draggable: true, icon: editIcon}).addTo(map);
        wgs84 = editLayer.getLatLng();
        $('#northing').val(wgs84.lat);
        $('#easting').val(wgs84.lng);
        editLayer.bindPopup(feature, 'edit');
        editLayer.on('dragend', function (event) {
            newMarker = event.target;
            position = newMarker.getLatLng();
            $('#northing').val(position.lat);
            $('#easting').val(position.lng);
        });
        layer.remove();
    } else if (feature.properties.shapeType == 'polyline') {
        console.log("editing line", geoJsonArray);
        $('#coordinatesDiv').hide();
        editLayer = L.polyline(editLayer.getLatLngs()).addTo(map);
        // Workaround for Leaflet draw bug: https://github.com/Leaflet/Leaflet.draw/issues/804
        editLayer.options.editing || (editLayer.options.editing = {});
        editLayer.editing.enable();
        editLayer.bindPopup(feature, 'edit');
        editLayer.on('edit', function () {
            geoJsonArray = [];
            coordinates = editLayer.getLatLngs();
            for (i = 0; i < coordinates.length; i++) {
                geoJsonArray.push('[' + coordinates[i].lng + ',' + coordinates[i].lat + ']');
            }
            layer.remove(feature);
        });
    } else {
        console.log("editing shape", geoJsonArray);
        $('#coordinatesDiv').hide();
        editLayer = L.polygon(editLayer.getLatLngs()).addTo(map);
        // Workaround for Leaflet draw bug: https://github.com/Leaflet/Leaflet.draw/issues/804
        editLayer.options.editing || (editLayer.options.editing = {});
        editLayer.editing.enable();
        editLayer.bindPopup(feature, 'edit');
        editLayer.on('edit', function () {
            geoJsonArray = [];
            coordinates = editLayer.getLatLngs()[0];
            for (i = 0; i < coordinates.length; i++) {
                geoJsonArray.push('[' + coordinates[i].lng + ',' + coordinates[i].lat + ']');
            }
            // Add first xy again as last xy to close polygon
            geoJsonArray.push('[' + coordinates[0].lng + ',' + coordinates[0].lat + ']');
            layer.remove(feature);
        });
    }
}

function interactionOn() {
    // Enable interaction with map e.g. if cursor leaves form
    captureCoordinates = true;
    map.dragging.enable();
    map.touchZoom.enable();
    map.doubleClickZoom.enable();
    map.scrollWheelZoom.enable();
    map.boxZoom.enable();
    map.keyboard.enable();
    if (map.tap) {
        map.tap.enable();
    }
    $('#map').css('cursor', 'crosshair');
}

function interactionOff() {
    // Disable interaction with map e.g. if cursor is over a form
    captureCoordinates = false;
    map.dragging.disable();
    map.touchZoom.disable();
    map.doubleClickZoom.disable();
    map.scrollWheelZoom.disable();
    map.boxZoom.disable();
    map.keyboard.disable();
    if (map.tap) {
        map.tap.disable();
    }
}

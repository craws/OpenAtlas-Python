// Init map
map = L.map('map', {maxZoom: mapMaxZoom, fullscreenControl: true});
L.control.scale().addTo(map);

// Icons
newIcon = L.icon({
    iconUrl: '/static/images/map/marker-icon_new.png',
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});
editIcon = L.icon({
    iconUrl: "/static/images/map/marker-icon_edit.png",
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});
editedIcon = L.icon({
    iconUrl: "/static/images/map/marker-icon_edited.png",
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});
grayMarker = L.icon({
    iconUrl: '/static/images/map/marker-icon-gray.png',
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});
superMarker = L.icon({
    iconUrl: '/static/images/map/marker-icon-orange.png',
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});
subsMarker = L.icon({
    iconUrl: '/static/images/map/marker-icon-green.png',
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});
siblingsMarker = L.icon({
    iconUrl: '/static/images/map/marker-icon-gray.png',
    iconAnchor: [12, 41],
    popupAnchor: [0, -34]
});

siblingStyle = {
    "color": "rgb(111,111,111)",
    "weight": 1.5,
    "fillOpacity": 0.5,
    "radius": 10
    //"opacity": 0.4
};

superStyle = {
    "color": "rgb(255,231,191)",
    "weight": 1.5,
    "fillOpacity": 0.5,
    "radius": 10
    //"opacity": 0.4
};

subStyle = {
    "color": "rgb(39,207,59)",
    "weight": 1.5,
    "fillOpacity": 0.5,
    "radius": 10
    //"opacity": 0.4
};

// Define base layers
OpenStreetMap_HOT = L.tileLayer('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
    maxZoom: 25,
    maxNativeZoom: 20,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Tiles style by <a href="https://www.hotosm.org/" target="_blank">Humanitarian OpenStreetMap Team</a> hosted by <a href="https://openstreetmap.fr/" target="_blank">OpenStreetMap France</a>'
});

OpenStreetMap = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 25,
    maxNativeZoom: 19,
});

Esri_WorldImagery = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
    attribution: '&copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community',
    maxZoom: 25,
    maxNativeZoom: 19
});

baseMaps = {
    Landscape: OpenStreetMap_HOT,
    Streetmap: OpenStreetMap,
    Satellite: Esri_WorldImagery
};

cluster = L.markerClusterGroup({
    showCoverageOnHover: false,
    maxClusterRadius: maxClusterRadius,
    disableClusteringAtZoom: disableClusteringAtZoom
});

controls = {};
UnitControls = {};
markerControls = {};

if (gisPointAll) {
    pointLayer = new L.GeoJSON(gisPointAll, {
        onEachFeature: setPopup,
        pointToLayer: function (feature, latlng) {
            if (window.location.pathname == '/place') {
                return L.marker(latlng);
            }
            return L.marker(latlng, {icon: grayMarker});
        }
    });
}


cluster.addLayer(pointLayer);
map.addLayer(cluster);
markerControls.Cluster = cluster;
//map.addLayer(pointLayer);
markerControls.Markers = pointLayer;


if (gisPolygonAll) {
    polygonLayer = new L.GeoJSON(gisPolygonAll, {
        onEachFeature: setPopup,
        style: {color: '#9A9A9A'}
    });
    controls.Polygons = polygonLayer;
}

if (gisLineAll) {
    linestringLayer = new L.GeoJSON(gisLineAll, {
        onEachFeature: setPopup,
        style: {color: '#9A9A9A'}
    });
    controls.Linestrings = linestringLayer;
}

setGeometries(gisPointSupers, 'super');
setGeometries(gisPointSibling, 'sibling');

if (gisPointSelected != '') {
    gisPoints = L.geoJson(gisPointSelected, {onEachFeature: setPopup}).addTo(map);
    gisPoints.on('click', setObjectId);
}

if (gisPolygonSelected != '') {
    gisPolygons = L.geoJson(gisPolygonSelected, {onEachFeature: setPopup}).addTo(map);
    gisPolygons.on('click', setObjectId);
}

if (gisLineSelected != '') {
    gisLines = L.geoJson(gisLineSelected, {onEachFeature: setPopup}).addTo(map);
    gisLines.on('click', setObjectId);
}

setGeometries(gisPointSubs, 'subs')

function setGeometries(data, level) {

    switch (level) {
        case 'super':
            var iconLevel = superMarker;
            var styleLevel = superStyle;
            break;
        case 'sibling':
            var iconLevel = siblingsMarker;
            var styleLevel = siblingStyle;
            break;
        default:
            var iconLevel = subsMarker;
            var styleLevel = subStyle;
            break;
    }

    if (data && data.length > 0) {
        //get points from GeoJSON
        var pointLayer = new L.GeoJSON(data, {
            filter: pointFilter,
            onEachFeature: setPopup,
            pointToLayer: function (feature, latlng) {
                return L.marker(latlng, {icon: iconLevel});
            },
        });

        //get polygons from GeoJSON
        var polyLayer = new L.GeoJSON(data, {
            filter: polygonFilter,
            style: styleLevel,
            onEachFeature: setPopup,
        });

        //get linestrings from GeoJSON
        var lineLayer = new L.GeoJSON(data, {
            filter: lineFilter,
            style: styleLevel,
            onEachFeature: setPopup,
        });

        switch (level) {
            case 'super':
                if (pointLayer.getLayers().length > 0) {
                    pointSupersLayer = pointLayer;
                    UnitControls.SuperPoints = pointSupersLayer;
                }
                if (polyLayer.getLayers().length > 0) {
                    polySupersLayer = polyLayer;
                    UnitControls.SuperPolys = polySupersLayer;
                    map.addLayer(polySupersLayer);
                }
                if (lineLayer.getLayers().length > 0) {
                    lineSupersLayer = lineLayer;
                    UnitControls.SuperLines = lineSupersLayer;
                    map.addLayer(polySupersLayer);
                }
                break;
            case 'sibling':
                if (pointLayer.getLayers().length > 0) {
                    pointSiblingsLayer = pointLayer;
                    UnitControls.SiblingPoints = pointSiblingsLayer;
                }
                if (polyLayer.getLayers().length > 0) {
                    polySiblingsLayer = polyLayer;
                    UnitControls.SiblingPolys = polySiblingsLayer;
                    map.addLayer(polySiblingsLayer);
                }
                if (lineLayer.getLayers().length > 0) {
                    lineSiblingsLayer = lineLayer;
                    UnitControls.SiblingLines = lineSiblingsLayer;
                    map.addLayer(lineSiblingsLayer);
                }
                break;
            default:
                if (pointLayer.getLayers().length > 0) {
                    pointSubsLayer = pointLayer;
                    UnitControls.SubsPoints = pointSubsLayer;
                }
                if (polyLayer.getLayers().length > 0) {
                    polySubsLayer = polyLayer;
                    UnitControls.SubsPolys = polySubsLayer;
                    map.addLayer(polySubsLayer);
                }
                if (lineLayer.getLayers().length > 0) {
                    lineSubsLayer = lineLayer;
                    UnitControls.SubsLines = lineSubsLayer;
                    map.addLayer(polySubsLayer);
                }
                break;
        }
    }
}

// Overlay maps
for (i = 0; i < overlays.length; i++) {
    overlay = L.imageOverlay('/display/' + overlays[i].image, overlays[i].boundingBox)
    UnitControls[overlays[i].name] = overlay;
    overlay.addTo(map)
}

if (window.location.href.indexOf('update') >= 0) {
    $('#gis_points').val(JSON.stringify(gisPointSelected));
    $('#gis_polygons').val(JSON.stringify(gisPolygonSelected));
    $('#gis_lines').val(JSON.stringify(gisLineSelected));
}

// Set zoom level depending on getBounds of selected points/polygons
let allSelected = [];
if (gisLineSelected != '') allSelected.push(gisLines);
if (gisPolygonSelected != '') allSelected.push(gisPolygons);
if (gisPointSelected != '') allSelected.push(gisPoints);
if (gisPointSupers != '' && typeof pointSupersLayer != "undefined") allSelected.push(pointSupersLayer);
if (gisPointSubs != '' && typeof pointSubsLayer != "undefined") allSelected.push(pointSubsLayer);
if (gisPointSibling != '' && typeof pointSiblingsLayer != "undefined") allSelected.push(pointSiblingsLayer);

if (allSelected.length > 0) map.fitBounds(L.featureGroup(allSelected).getBounds(), {maxZoom: mapDefaultZoom});
else if (gisPointAll.length > 0) map.fitBounds(pointLayer.getBounds(), {maxZoom: mapDefaultZoom});
else map.setView([30, 0], 2);

groupedOverlays = {
    "Places": markerControls,
    "General": controls,
    "Subunits": UnitControls
};

var GroupOptions = {
    exclusiveGroups: ["Places"],
    groupCheckboxes: true
};

L.control.groupedLayers(baseMaps, groupedOverlays, GroupOptions).addTo(map);
//L.control.layers(baseMaps, controls).addTo(map);

baseMaps.Landscape.addTo(map);

var geoSearchControl = L.control.geonames({
    // position: 'topcenter', // In addition to standard 4 corner Leaflet control layout, this will position and size from top center.
    position: 'topleft',
    geonamesSearch: 'https://secure.geonames.org/searchJSON', // Override this if using a proxy to get connection to geonames.
    geonamesPostalCodesSearch: 'https://secure.geonames.org/postalCodeSearchJSON', // Override this if using a proxy to get connection to geonames.
    username: geoNamesUsername, // Geonames account username.  Must be provided.
    maxresults: 8, // Maximum number of results to display per search.
    zoomLevel: 12, // Max zoom level to zoom to for location. If null, will use the map's max zoom level.
    className: 'leaflet-geonames-icon', // Class for icon.
    workingClass: 'leaflet-geonames-icon-working', // Class for search underway.
    featureClasses: ['A', 'H', 'L', 'P', 'R', 'T', 'U', 'V', 'S'], // Feature classes to search against.  See: http://www.geonames.org/export/codes.html.
    baseQuery: 'isNameRequired=true', // The core query sent to GeoNames, later combined with other parameters above.
    showMarker: false, // Show a marker at the location the selected location.
    showPopup: true, // Show a tooltip at the selected location.
    adminCodes: {}, // Filter results by the specified admin codes mentioned in `ADMIN_CODES`. Each code can be a string or a function returning a string. `country` can be a comma-separated list of countries.
    bbox: {}, // An object in form of {east:..., west:..., north:..., south:...}, specifying the bounding box to limit the results to.
    lang: 'en', // Locale of results.
    alwaysOpen: false, // If true, search field is always visible.
    enablePostalCodes: true, // If true, use postalCodesRegex to test user provided string for a postal code.  If matches, then search against postal codes API instead.
    postalCodesRegex: POSTALCODE_REGEX_US, // Regex used for testing user provided string for a postal code.  If this test fails, the default geonames API is used instead.
    title: translate['map_geonames_title'], // Search input title value.
    placeholder: translate['map_geonames_placeholder'] // Search input placeholder text.
});

geoSearchControl.on('select', function (e) {
    if (geoNamesModule) {
        var popup = `<div>
                  <a href='https://www.geonames.org/${e.geoname.geonameId}' target='_blank'>${e.geoname.name}</a><br>
                  <div id="buttonBar" style="white-space:nowrap;">
                    <p>
                        <button id="ImportGeonamesID">Import ID</button>
                        <button id="ImportCoordinates">Import Coordinates</button><br><br>
                        <button id="ImportAll">Import ID and Coordinates</button>
                    </p>
                </div>
            </div>`;
        e.target._map.on('opengeopopup', p => {
            p.popup.setContent(popup);
            p.popup.update();
            $('#ImportCoordinates').click(() => importNewPoint(e.geoname, p.popup));
            $('#ImportGeonamesID').click(() => importGeonamesID(e.geoname, p.popup));
            $('#ImportAll').click(() => importAll(e.geoname, p.popup));
        });
    }
});

map.addControl(geoSearchControl);


function setObjectId(e) {
    layer = e.layer;
    editLayer = e.layer;
    feature = layer.feature;
    editMarker = e.marker;
}

function buildPopup(feature, action = 'view', selected = false) {
    popupHtml = '<div id="popup">'
    if (feature.properties.objectName) {
        popupHtml += '<strong>' + feature.properties.objectName + '</strong><br>';
        if (feature.properties.objectType) {
            popupHtml += feature.properties.objectType + '<br>'
        }
    }
    popupHtml += `
        <strong>` + feature.properties.name + `</strong>
        <div style="max-height:140px;overflow-y:auto">` + feature.properties.description + `</div>`
    if (action == 'edited') {
        popupHtml += '<p>' + translate['map_info_reedit'] + '</p>';
    } else if (!selected || window.location.href.indexOf('update') < 1) {
        popupHtml += '<p><a href="/entity/' + feature.properties.objectId + '">' + translate['details'] + '</a></p>';
    } else if (window.location.href.indexOf('update') >= 0) {
        popupHtml += `
            <div id="buttonBar" style="white-space:nowrap;">
                <p>
                    <button id="editButton" onclick="editGeometry()">` + translate['edit'] + `</button>
                    <button id="deleteButton" onclick="deleteGeometry()">` + translate['delete'] + `</button>
                </p>
            </div>`;
    }
    return popupHtml + '</div>';
}

function setPopup(feature, layer, mode) {
    selected = false;
    // Check if this feature is selected
    if (gisPointSelected) {
        for (pointSelected in gisPointSelected) {
            if (gisPointSelected[pointSelected].properties.objectId == feature.properties.objectId) {
                selected = true;
            }
        }
    }
    if (gisPolygonSelected) {
        for (polygonSelected in gisPolygonSelected) {
            if (gisPolygonSelected[polygonSelected].properties.objectId == feature.properties.objectId) {
                selected = true;
            }
        }
    }
    if (gisLineSelected) {
        for (lineSelected in gisLineSelected) {
            if (gisLineSelected[lineSelected].properties.objectId == feature.properties.objectId) {
                selected = true;
            }
        }
    }
    layer.bindPopup(buildPopup(feature, 'view', selected));
}

//filter to get polygons from the geojson
function polygonFilter(feature) {
    if (feature.geometry.type === "Polygon")
        return true
}

//filter to get points from the geojson
function pointFilter(feature) {
    if (feature.geometry.type === "Point")
        return true
}

//filter to get linestrings from the geojson
function lineFilter(feature) {
    if (feature.geometry.type === "Linestring")
        return true
}

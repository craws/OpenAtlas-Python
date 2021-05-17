# Leaflet.Geonames

A [GeoNames](http://www.geonames.org/) powered geocoding search control for Leaflet.

It allows you to enter a placename, display a list of search results using GeoNames,
and select a placename to zoom to.

Location markers remain on the map until the search field is cleared.
Click on icon to open / close unless `alwaysOpen` is set to true (in which case clicking on the icon does nothing).

\*Tested with Leaflet 1.1.0

## Install

From NPM:

```
npm install leaflet-geonames
```

## Usage

Include the CSS:

```
<link rel="stylesheet" href="L.Control.Geonames.css" />
```

This control uses [Google Material Icons](https://design.google.com/icons) by default.

Include the JavaScript:

```
<script src="L.Control.Geonames.min.js"></script>
```

Example usage:

```
var control = L.control.geonames({
    //position: 'topcenter', // In addition to standard 4 corner Leaflet control layout, this will position and size from top center.
    position: 'topleft',
    geonamesSearch: 'https://secure.geonames.org/searchJSON', // Override this if using a proxy to get connection to geonames.
    geonamesPostalCodesSearch: 'https://secure.geonames.org/postalCodeSearchJSON', // Override this if using a proxy to get connection to geonames.
    username: '', // Geonames account username.  Must be provided.
    maxresults: 5, // Maximum number of results to display per search.
    zoomLevel: null, // Max zoom level to zoom to for location. If null, will use the map's max zoom level.
    className: 'leaflet-geonames-icon', // Class for icon.
    workingClass: 'leaflet-geonames-icon-working', // Class for search underway.
    featureClasses: ['A', 'H', 'L', 'P', 'R', 'T', 'U', 'V'], // Feature classes to search against.  See: http://www.geonames.org/export/codes.html.
    baseQuery: 'isNameRequired=true', // The core query sent to GeoNames, later combined with other parameters above.
    showMarker: true, // Show a marker at the location the selected location.
    showPopup: true, // Show a tooltip at the selected location.
    adminCodes: {}, // Filter results by the specified admin codes mentioned in `ADMIN_CODES`. Each code can be a string or a function returning a string. `country` can be a comma-separated list of countries.
    bbox: {}, // An object in form of {east:..., west:..., north:..., south:...}, specifying the bounding box to limit the results to.
    lang: 'en', // Locale of results.
    alwaysOpen: false, // If true, search field is always visible.
    enablePostalCodes: true, // If true, use postalCodesRegex to test user provided string for a postal code.  If matches, then search against postal codes API instead.
    postalCodesRegex: POSTALCODE_REGEX_US, // Regex used for testing user provided string for a postal code.  If this test fails, the default geonames API is used instead.
    title: 'Search by location name or postcode', // Search input title value.
    placeholder: 'Enter a location name' // Search input placeholder text.
});
map.addControl(control);
```

For mobile responsive view, use `position: 'topcenter'` and `alwaysOpen: true` options.
See [mobile example](http://consbio.github.io/Leaflet.Geonames/examples/mobileview.html)
using a mobile device or emulator.

## Events

### Search Event

This control fires a `search` event with the value of search parameters:

`control.on('search', function(e){console.log(e.params)});`

results in
`{q: "oregon", lang: "en"}`

### Select Event

This control fires a `select` event when an option was selected from list,
with the full response JSON from geonames:

`control.on('select', function(e){console.log(e.geoname)});`

results in
`{adminCode1: "OR", lng: "-120.50139", geonameId: 5744337, ...}`

## Demos:

-   [Basic](examples/basic.html)
-   [Admin Codes](examples/adminCodes.html)
-   [Bounding Box](examples/bbox.html)
-   [Locale](examples/locale.html)
-   [Events](examples/events.html)
-   [Mobile View](examples/mobileview.html)
-   [Postal Codes](examples/postCodes.html)

## Changes

See [changelog](CHANGES.md)

## Credits:

Developed with support from the [South Atlantic Landscape Conservation Cooperative](http://www.southatlanticlcc.org/), and maintained with support from [Peninsular Florida LCC](http://peninsularfloridalcc.org/).

Some ideas derived from [L.GeoSearch](https://github.com/smeijer/L.GeoSearch).

## Contributors:

-   [Brendan Ward](https://github.com/brendan-ward)
-   [Kaveh Karimi-Asli](https://github.com/ka7eh)
-   [Nik Molnar](https://github.com/nikmolnar)
-   [Mike Moran](https://github.com/mikemoraned)
-   [Natasha Anisimova](https://github.com/anisimon)
-   [Adam Mertel](https://github.com/adammertel)

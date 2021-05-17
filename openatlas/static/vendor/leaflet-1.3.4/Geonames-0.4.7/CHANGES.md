## Version 0.4.1 (6/2/2017)
* increased max-width of input for larger viewports

## Version 0.4.0 (5/31/2017)
* converted input field to a search field type
* added examples/mobileview.html example for mobile ready version
* added option `alwaysOpen` to keep search field always visible
* exposed `show()`, `hide()`, `hideResults()` `removeMarker()`, `removePopup()` functions
* updated event handling to prevent click events from propagating to map
* changed default icon from directions type icon to magnifying glass icon
* added `topcenter` as a position for the control with autosizing to mobile viewports
* clicking on the icon no longer clears out the marker; clearing the search field does so instead
* added ability to override Geonames URL
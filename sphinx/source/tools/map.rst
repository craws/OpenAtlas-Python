Map
===

.. toctree::

The interactive map is a tool to present and enter the location of places.

Navigation
----------
* You can zoom in/out with the mousewheel or the **+**/**-** buttons in the upper left corner.
* You can drag the content with the mouse (left click and hold)
* Change the basemap at the layer button in the upper right corner.
* Switch to full screen with the rectangle in the upper left.

Search
------
With the magnifying glass icon in the upper left you can search for (current) places at
`GeoNames <https://www.geonames.org/>`_.

Adding new geometries
---------------------
When in insert or update mode of a place you have following options available (can be combined):

* Set a marker/point at the position where the physical thing is located.
* Draw a line connected to a physical objects spatial characteristics, e.g. the course of a road.
* Draw the shape of a physical thing if the precise extend is known.
* Draw the area in which the physical thing is located. E.g. if its precise shape is not known but known to be within a certain area.

GeoNames
--------
The *GeoNames ID* field can either be manually entered or imported from a map search result.

The checkbox **exact match** can be used if there is a high
degree of confidence that the concepts can be used interchangeably. By default it is a
**close match**, which means that the concepts are sufficiently similar that they can be used
interchangeably in some information retrieval applications. Please refer to
`SKOS <https://www.w3.org/TR/skos-reference/>`_ for further information.

Map Overlay
-----------
If you have the module map overlay activated in your :doc:`profile`, added overlays for places will
be visible on the map by default and can be toggled at map layer button at the upper right corner.

To insert new overlays (only available for editors and admins) go to the view of a specific place.
After adding an image file in the file tab you can click **add** in the overlay column to enter
coordinates for the left upper and bottom right corner to position the image on the map.

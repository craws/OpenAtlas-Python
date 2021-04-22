Reference System
================

.. toctree::

Reference systems can be used to link entities to external sources, e.g. to
`Wikidata <https://www.wikidata.org/>`_  or `GeoNames <https://www.geonames.org/>`_
which are already included in the default application. You can see a list of available systems by
clicking the **Reference system** button on the start page. Links consists of an identifier (ID)
and a precision.

ID
--
The identifier of the entity in the external reference system. For GeoNames and Wikidata it will be
checked for a valid format.

Precision
---------
When linking to an external reference a precision is required. Available options are the
`SKOS <https://www.w3.org/TR/skos-primer/>`_ based definitions of the confidence degree that
concepts can be used interchangeable.

* **Close match**: Concepts are sufficiently similar that they can be used interchangeably in some
  information retrieval applications
* **Exact match**: High degree of confidence that the concepts can be used interchangeably

E.g. if a historical project links the city of Vienna to Wikidata, a **close match** would be more
suitable, because the Wikidata entry is more about the current city and not the historical one.

Configuration
-------------
Admins and manager can add, updated and delete external reference systems.

* **Name** - e.g. Wikipedia; can not be changed for Wikidata or GeoNames
* **Website URL** - an URL to the project site of the reference system
* **Resolver URL** - an URL that can be linked to in combination with an ID,
  e.g. the resolver URL **https://www.wikidata.org/wiki/** would create together with a **Q123**
  identifier the external link: https://www.wikidata.org/wiki/Q123
* **Example ID** - an example id to show the desired format e.g. Q123 for Wikidata
* **External reference match** - default precision selected in forms
* **Description** - a short description, shown in forms when mouse over the **i** icon
* **Classes** - a checkbox list of available classes, for GeoNames only place is available

Classes can be removed from a system by clicking on the tab with the corresponding class name and
clicking the **Remove** button. This button is only available if there are no entities of this class
linked to the reference system.

Reference systems can be deleted only if no classes are attached to it. Wikidata and GeoNames are
integrated and cannot be deleted but if desired they can be disabled by removing the classes.

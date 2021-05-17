Type
====

.. toctree::

Types are used to add information or group entities. They are hierarchical and can be accessed and
edited via the **Types** menu item. With this feature the model and user interface can be
adapted for specific research interests.

* You can checked **untyped entities** at the type overview with clicking the **show** link
* Type descriptions are shown in forms as a mouse over text at the **i** icon

Standard types
--------------
Standard types are already present in the default installation with a few examples.

* Cannot be deleted or renamed (but subtypes of them can)
* Are single select only
* In forms they appear with a **Type** label
* Are displayed in entity tables

Custom types
------------
Custom types can be created, deleted and renamed. The default installation comes with one example
custom type **Sex** which is used for actor.

* Can be set to allow single or multiple choices (once multiple can't be revert to single later)
* Can be used for multiple classes,  e.g. a hierarchy "importance" for places, actors and groups

Value types
-----------
Value types can be created, deleted and renamed. The default installation comes with an example
value type **Dimensions** with the sub types **Height** and **Weight** which are used in the form
for finds.

* Can be used for multiple classes
* Values can be entered as decimals in forms

Form fields
-----------
* :doc:`/form/name`
* :doc:`/form/description`
* :doc:`reference_system`
* :doc:`/form/date`
* A super (type) if it is a sub type of another type

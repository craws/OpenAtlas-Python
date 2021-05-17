Data integrity checks
=====================

.. toctree::

The quality of data is very important to us. Although ultimately the data responsibility
lies with editors and project managers we take great care to avoid entering of inconsistent
data on a technical level, e.g. with the user interface it is not possible to enter begin dates
which are later than end dates.

Nevertheless mistakes can happen, not only on the application level but also e.g. when importing
data from other projects or deleting files outside of the application. Because data integrity is
important for the quality of research we implemented functions to check possible inconsistencies
which are described in detail below.

Orphans
-------

Orphans
*******
In this tab entries like dates which are not linked are shown. They could be artifacts from imports
or bugs and can be deleted. If they seem to appear regularly again (without imports or known bugs)
please report that issue.

Entities without links
**********************
Entries shown have no relation to other entities. That could be ok but maybe they are artifacts or
were forgotten to link.

Type
****
These types were created but have no sub types or associated data. Maybe they originate from the
first install or were never used.

Missing files
*************
Here are listed file entities which have no corresponding file, most likely because the file itself
doesn't exist anymore.

Orphaned files
**************
Files that have no corresponding entity are listed here.

Circular dependencies
*********************
A check if an entity is linked to itself. This could happen e.g. if a person is married to herself
or a type has itself as super. It shouldn't be possible to create circular dependencies within the
application. Nevertheless it's a useful check for e.g. if data is imported from other systems.

Check dates
-----------
In this tab invalid date combinations are shown, e.g. begin dates which are later than end dates.
These entries should be cleared up otherwise they cannot be updated because the user interface
won't allow saving entries with invalid date combinations.

Check links
-----------
With this function every link will be checked for CIDOC CRM validity. Depending on the amount of
data this could take some time. Data entered with the OpenAtlas user interface should always be
CIDOC CRM valid but in case of e.g. imported data this check should be used afterwards. If invalid
links are found they should be dealt with outside the application.

Check link duplicates
---------------------
There are actually two checks:

The first one checks for duplicate links which are identically and can be safely deleted when
clicking the *Delete link duplicates* button.

In case the first test found no duplicate links it will be checked for entities connected multiple
times two a type which is defined for single use. E.g. a place has the type castle and city. In
this case you would only see one in the user interface and the other one would get deleted in case
anybody updates the entry. Here you have the option to look at these and remove the wrong ones
clicking on the **Remove** link beside the entries in the last column.

Both checks shouldn't find anything wrong with data entered with the application but nevertheless it
could happen because of imports or unknown bugs.

Check similar names
-------------------
Here you can search for similar names. Depending on selection and data volume this might take some
time.

* **Classes** - select the class which you want to search for similar names
* **Ratio** - select how similar the names should be. 100 is the default and means absolute identical. The lower you set the number the more names which are similar will be found but it will also get more time consuming, so you should begin with a higher numbers.

To find similar names the Python `fuzzywuzzy <https://pypi.org/project/fuzzywuzzy/>`_ package is used
which in turn uses the `Levenshtein Distance <https://en.wikipedia.org/wiki/Levenshtein_distance>`_.

Search
======

.. toctree::

The global search finds entities containing the search term in their name or aliases. It is:

* Not case sensitive, e.g. **aDa lovelacE** will find **Ada Lovelace**
* Full text, e.g. **da Love** will find **Ada Lovelace**
* Unaccented, e.g. **Lovē** will find **Love** and vice-versa
* You can use *%* as a placeholder, e.g. **Ada L%ce** will find **Ada Lovelace**

After clicking on the search button in the top right you will be redirected to a result page where
more options are available:

* **Only entities edited by me** - show only entities which you have created or edited.
* **Also search in description** - searches in description and date comments
* **Classes** - search only in selected classes, e.g. Place

* **Dates**

  * This filter is only active if at least the **from** or **to** year is filled out.
  * If only a year is provide the **from** date will be **YYYY-01-01**, the **to** date will be **YYYY-12-31**
  * If only a year and a month is provided it will be the last of this month.
  * If the option **Include dateless entities** is checked, entities without dates will be found too.

Because entities can have up to 4 date values (time span for begin and time span for end) they will
be added to the result if at least one date meets the criteria. E.g. a person that lived from **1540
to 1560** will be found when the **from year** value is **1550**.

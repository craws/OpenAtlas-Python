Network visualization
=====================

.. toctree::

With the integration of `D3.js <https://d3js.org/>`_ data can be visualized as a network graph
available at one of the **Network visualization** buttons at the :doc:`/overview`.

.. figure:: network_classic.png
   :align: left

   Classic
.. figure:: network_2d.png
   :align: left

   2D
.. figure:: network_3d.png
   :align: left

   3D

Navigation
----------
* Zoom with mouse wheel
* Drag and drop one node with the left mouse button to move the node
* Drag and drop the background with the left mouse button to move around

2D
**
* Select a node with the left mouse button to only show its direct connections

3D
**
* Select a node with the left mouse button to only show its direct connections
* Drag and drop the background with the left mouse button to rotate
* Drag and drop the background with the right mouse button to pan

Options
-------
* **Classes** - you can change the node color of classes
* **Show orphans** - if selected nodes without any connections are shown too
* **Width** - the width of the resulting image in pixel
* **Height** - the height of the resulting image in pixel
* **Charge** - a parameter for the distance between entries which are not connected
* **Distance** - a parameter for the distance between connected entries

In case of performance issues
-----------------------------
* Check if your browser has hardware acceleration enabled
* Try different browsers, some are faster than others when dealing with large data sets

Download
--------
If an image is available (classic mode only) you can download it as PNG. Be aware that the resulting image is exactly what you see in this moment so you may want to change width and height in the options before. Also you may want to choose a zoom level where labels are readable.

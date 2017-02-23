# TSC Labeling App User documentation

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Contents**

- [Running the app](#running-the-app)
- [Main menu](#main-menu)
- [Region selection](#region-selection)
    - [Available region types](#available-region-types)
        - [Rectangle](#rectangle)
        - [Ellipse](#ellipse)
        - [Polygon](#polygon)
        - [Freehand](#freehand)
    - [Config buttons](#config-buttons)
        - [Maximize/Restore](#maximizerestore)
        - [Hide/Show labels](#hideshow-labels)
        - [1:1 Ratio](#11-ratio)
        - [Save](#save)
        - [Load](#load)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<a name="running-the-app"></a>
## Running the app

The app is run my calling `main_menu` on MATLAB's command line.

<a name="main-menu"></a>
## Main menu

The app's main menu looks like this:

![Main Menu](screenshots/main_menu.svg)

The **Browse** button lets the user choose an image file. The supported
extensions and formats are:

- JPG, JPEG - Joint Photographic Experts Group
- PNG - Portable Network Graphics
- BMP - Windows Bitmap
- CUR - Windows Cursor resources
- GIF - Graphics Interchange Format
- HDF - Hierarchical Data Format
- ICO - Windows Icon resources
- PBM - Portable Bitmap
- PCX - Windows Paintbrush
- PGM - Portable Graymap
- PNM - Portable Any Map
- PPM - Portable Pixmap
- RAS - Sun Raster
- XWD - X Window Dump
- JP2 - JPEG 2000 (Part 1)
- JPF, JPX - JPEG 2000 (Part 2)
- J2C, J2K - JPEG 2000 (raw codestream)
- TIF, TIFF - Tagged Image File Format
- FTS, FITS - Flexible Image Transport System

The image file to be labeled can also be selected by writing its path in the
text box.

When the **Open image** button is clicked, the main menu is closed and the
region selection window opens.

<a name="region-selection"></a>
## Region selection

The buttons at the right of the window are used to choose the kind of region to
be selected. The buttons at the left control some configuration aspects of the
app.

![region-selection](screenshots/region_selection.svg)

The app displays a text below each region, showing the selected label.

<a name="available-region-types"></a>
### Available region types

At the time of writing, the labeling app supports four region types:
**Rectangles**, **Ellipses**, **Polygons** and **Freehand** regions.

<a name="rectangle"></a>
#### Rectangle

Freehand regions cannot be modified once they are closed.

Rectangular regions are selected by dragging the mouse pointer. They can be
resized by dragging any of its sides or corners.

Its aspect ratio can be locked by right-clicking the rectangle and selecting the
**Fix aspect ratio** option. When the aspect ratio is locked, a rectangle can
only be resized by dragging its corners.

![region-selection](screenshots/rect_fix_aspect_ratio.png)

<a name="ellipse"></a>
#### Ellipse

Elliptical regions are selected by dragging the mouse pointer. They can be
resized by dragging any of its sides or corners.

Its aspect ratio can be locked by right-clicking the ellipse and selecting the
**Fix aspect ratio** option. When the aspect ratio is locked, an ellipse can
only be resized by dragging its corners.

![region-selection](screenshots/ellipse_fix_aspect_ratio.png)

<a name="polygon"></a>
#### Polygon

Polygonal regions are selected by repeatedly clicking on the image. Each click
inserts a new vertex to the polygon at the location of the mouse pointer.

![region-selection](screenshots/polygon_points.png)

Regions are closed by either right-clicking the image (this directly closes the
polygon) or by double-clicking the image (this adds a last vertex and closes the
polygon).

Polygons can have additional points added. To do so, the 'a' key must be pressed
and then click on the desired point.

Polygon points can be moved around, by placing the mouse pointer on top the
desired point. The pointer will turn into a circle. Then, the point can be
dragged around.

<a name="freehand"></a>
#### Freehand

Freehand regions are selected by clicking and dragging the mouse pointer along
the image until the left button of the mouse is released. The region is then set
as the path traveled by the pointer.

Freehand regions cannot be modified once they are closed.

![region-selection](screenshots/freehand_region.png)

<a name="config-buttons"></a>
### Config buttons

<img align="left" alt=config_buttons src="screenshots/config_buttons.svg">
<!--<div style="float: left">
    ![config_buttons](screenshots/config_buttons.svg "Config buttons")
</div>-->

<a name="maximizerestore"></a>
#### Maximize/Restore

At the top left corner of the window there is a check box, labeled 'Maximize'.
This check box allows the user to maximize the app's window. The box restores
the window to its original size if it is clicked when the app is maximized.

<a name="hideshow-labels"></a>
#### Hide/Show labels

Below the 'Maximize' check box, there is a toggle button labeled 'Hide Labels'.
This toggle button hides/shows the labels shown below each region.

<a name="11-ratio"></a>
#### 1:1 Ratio

This button only works with rectangular and elliptical regions. This button sets
the region's aspect ratio as 1:1 i.e. square or circle.

<a name="save"></a>
#### Save

This button saves the currently selected regions and their labels to a JSON file.

The JSON file is named like the image on which the labels were selected.

<a name="load"></a>
#### Load

This button loads previously saved labels from a JSON file named like the image
on which the labels are to be loaded.

<!-- <a name="label-selection"></a>
## Label selection -->

<!--## Template stuff

To use this project as your user/group website, you will need one additional
step: just rename your project to `namespace.gitlab.io`, where `namespace` is
your `username` or `groupname`. This can be done by navigating to your
project's **Settings**.

Read more about [user/group Pages][userpages] and [project Pages][projpages].

## Did you fork this project?

If you forked this project for your own use, please go to your project's
**Settings** and remove the forking relationship, which won't be necessary
unless you want to contribute back to the upstream project.

## Troubleshooting

1. CSS is missing! That means two things:

    Either that you have wrongly set up the CSS URL in your templates, or
    your static generator has a configuration option that needs to be explicitly
    set in order to serve static assets under a relative URL.

----

Forked from @VeraKolotyuk

[ci]: https://about.gitlab.com/gitlab-ci/
[harp]: http://harpjs.com/
[install]: http://harpjs.com/docs/quick-start
[documentation]: http://harpjs.com/docs/
[userpages]: http://doc.gitlab.com/ee/pages/README.html#user-or-group-pages
[projpages]: http://doc.gitlab.com/ee/pages/README.html#project-pages
-->

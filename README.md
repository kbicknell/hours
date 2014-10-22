Hours
=====

This is a simple category-based time tracking program written in Java for the Mac.

Ingredients from elsewhere
--------------------------

* Four of the svg icons are resized versions of those created by Avi Alkalay, which used to be available in `blogicons-20070518.zip` from `http://avi.alkalay.net/software/blogicons/`. See also `https://avi.alkalay.net/2007/05/blog-icons.html`. The other two svg icons, I created myself.
* This repository includes the jgoodies-looks and jgoodies-common Java libraries, available at `http://www.jgoodies.com`, which are provided under the BSD open source license.

Installation
------------

* The only prerequisite to build this on a Mac should be Inkscape, the open source vector graphics editor, which can be downloaded from `www.inkscape.org` or installed via `macports`. Install that first.
* Next, make sure the paths to the Java SDK and the inkscape binary at the top of `Makefile` are correct for your system.
* Run `make`.
* Finally, copy the application bundle `Hours.app` to the directory of your choice.

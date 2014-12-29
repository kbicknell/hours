Hours
=====

A simple category-based time tracking program written in Java for the Mac.


Installation
------------

* To install, the only tools you'll need are `make` and `javac`. Macs should have the latter by default, but for the former, you'll need to install the Xcode command line tools.
* First, clone or download the repository.
* From the `hours` directory, run the command `make` in terminal.
* Now, copy the application bundle `Hours.app` (inside the `hours` directory) to the location of your choice (e.g., `Applications`).

Build dependencies
------------------

This repository contains binaries of the graphics and a copy of `rt.jar` bundled with Mac OS Java. If you want to regenerate these, you'll need:
* Inkscape, the open source vector graphics editor, which can be downloaded from [www.inkscape.org](www.inkscape.org) or installed via [macports](https://www.macports.org/).
* to ensure that the paths to the Java SDK and the Inkscape binary at the top of `Makefile` are correct for your system.


Credits
--------------------------

* Four of the svg icons are resized versions of those created by Avi Alkalay, which used to be available in `blogicons-20070518.zip` from [http://avi.alkalay.net/software/blogicons/](http://avi.alkalay.net/software/blogicons/). See also [https://avi.alkalay.net/2007/05/blog-icons.html](https://avi.alkalay.net/2007/05/blog-icons.html). The other two svg icons, I created myself.
* This repository includes the jgoodies-looks and jgoodies-common Java libraries, available at [http://www.jgoodies.com](http://www.jgoodies.com), which are provided under the BSD open source license.

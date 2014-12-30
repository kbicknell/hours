Hours
=====

A simple category-based time tracking program written in Java for the Mac.


Installation
------------

* First, clone or download the repository.
* From the `hours` directory, run the command `./finalize.sh` in terminal.
* Now, copy the contents of the `hours/dist` directory (i.e., the application bundle `Hours.app` and the file `hours.data`) to the location of your choice (probably not the Applications folder: see below).
* With a text editor, edit the categories in `hours.data` as you see fit.
* Now you can run the app. Note that it will generate its datafiles in the folder it lives in. Thus, you probably don't want to put it in your Applications folder.


Build dependencies
------------------

This repository contains binaries of the graphics and a copy of `rt.jar` bundled with Mac OS Java. If you want to regenerate these, you'll need:
* Inkscape, the open source vector graphics editor, which can be downloaded from [www.inkscape.org](www.inkscape.org) or installed via [macports](https://www.macports.org/).
* to ensure that the paths to the Java SDK and the Inkscape binary at the top of `Makefile` are correct for your system.


Credits
--------------------------

* Four of the svg icons are resized versions of those created by Avi Alkalay, which used to be available in `blogicons-20070518.zip` from [http://avi.alkalay.net/software/blogicons/](http://avi.alkalay.net/software/blogicons/). See also [https://avi.alkalay.net/2007/05/blog-icons.html](https://avi.alkalay.net/2007/05/blog-icons.html). The other two svg icons, I created myself.

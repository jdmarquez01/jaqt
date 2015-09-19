JAQT - Just Another Qt-CMake Template
====================================
JAQT is an open-source cross-platform Project Template for Qt. 
It features for a mid-sized projects with several libraries
exploiting cmake features for Build tests and documentation
across them.

JAQT runs on Linux, OS X and Windows,
other operating systems are currently not supported.


Get JAQT
--------
You can download JAQT using Git:

    $ git clone git://github.com/jdmarquez01/jaqt.git


Acknowledgements
------------

The following projects are taken by reference to generate these templates:

 * Tano (https://github.com/ntadej/tano)
 * CommonTK (https://github.com/commontk/CTK)
 * VTK (https://github.com/Kitware/VTK)
 * Charm (https://github.com/KDAB/Charm)
 * Tango icon shceme

Compilation
-----------
    $ mkdir build
    $ cd build
    $ cmake .. -DCMAKE_INSTALL_PREFIX=prefix
    $ make

Installation
------------
    $ make install


Copyright info
--------------
Copyright (C) 2015 jadm

JAQT is free (libre) software. This means that the application
source code is available to public, anyone is welcome to research
how the application works, participate in its development, freely
distribute the application and spread the word!

This project may be used under the terms of the
GNU General Public License version 3.0 as published by the
Free Software Foundation and appearing in the file LICENSE.GPL.

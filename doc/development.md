
YaST Development Documentation
==============================

Documentation Links
-------------------

- [YaST development documentation](http://yast.github.io/documentation.html)
- [Contribution Guidelines](http://yast.github.io/guidelines.html)
- [YaST architecture](architecture.md)


Development Environment
-----------------------

Before starting to work on YaST, you need to setup a development environment.
The steps are different depending on whether you want to do new development or
to fix already released packages.

### New Development ###

New YaST development generally needs to be done on
[Factory](https://en.opensuse.org/Portal:Factory) as this is the system where
the next YaST version will eventually run. If Factory is too unstable for you,
you can also use [Tumbleweed](https://en.opensuse.org/Portal:Tumbleweed)
or the latest openSUSE release — differences in the environment
usually aren not big enough to cause trouble.

To prepare the development environment in Factory, install the yast2-devtools package:

    sudo zypper in yast2-devtools

To prepare the development environment in openSUSE, build and install the
`yast2-devtools` package yourself from the current source code (the
version present in the last openSUSE release migth be too old):

    sudo zypper in git-core ruby gcc-c++ docbook-xsl-stylesheets 
    sudo gem install yast-rake
    git clone https://github.com/yast/yast-devtools.git
    cd yast-devtools
    make -f Makefile.cvs
    make
    sudo make install

### Maintenance ###

If you need to fix bugs or do some other maintenance work in already released
versions of YaST, create a virtual machine with the same openSUSE or SLE
release you are targetting and install the `devel_yast` pattern there:

    sudo zypper in -t pattern devel_yast


### Extra Development Tools ###

For running the automated tests you might need to install some more packages:

    $ sudo zypper install yast2-testsuite rubygem-rspec rubygem-simplecov


Autotools Based YaST Packages
=============================

This is a generic documenation for YaST packages which use autotools (autoconf/automake)
for building the package. These packages have usually `Makefile.cvs` file in the base
directory.

Building and Installaing
--------------------------

To build the module run these commands:

    $ make -f Makefile.cvs
    $ make

If you want to rebuild the module later simply run `make` again.

To install it run:

    $ sudo make install

Note: This will overwrite the existing module in the system, be carefull when installing
a shared component (library) as it migth break some other modules.


Starting the Module
-------------------

Run the module as root

    # yast2 <module>

or start the YaST control panel from the desktop menu and then run the appropriate module.


Running the Automated Tests
---------------------------

To run the testsuite, use the `check` target:

    $ make check


Building the Package
--------------------

To build a package for submitting into [Open Build
Service](https://build.opensuse.org/) (OBS) you need to run

    $ make package-local

in the top level directory.


Rake Based YaST Packages
========================

This is a generic documenation for YaST packages which use `rake` for building
the package. Such packages do not have the `Makefile.cvs` file in the base
directory, but have `Rakefile` file.

Building and Installaing
------------------------

So far the rake based modules do not need to be built, they are ready to be used just
after the Git clone.

To install module run:

    $ sudo rake install

Note: This will overwrite the existing module in the system, be carefull when installing
a shared component (library) as it migth break some other modules.

Starting the Module
-------------------

You can start the installed module (as described above) or you can run it
directly from the Git checkout without need to install it first

To run the module directly from the source code, use the `run` Rake task:

    $ rake run


Running the Automated Tests
---------------------------

To run the testsuite, use the `test:unit` Rake task:

    $ rake test:unit

To run the tests with code coverage reporting run

    $ COVERAGE=1 rake test:unit


For a complete list of tasks, run `rake -T`.


Building the Package
--------------------

To build a package for submitting into [Open Build
Service](https://build.opensuse.org/) (OBS) you need to run

    $ rake tarball

Continuous Integration
======================

Travis CI
---------

YaST uses [Travis CI](https://travis-ci.org) for building and running tests for
commits and pull requests. You can find more details in the [Travis CI
Integration](travis-integration.md) documentation.

Jenkins CI
----------

For builing on native (open)SUSE distibution we use [Jenkins CI openSUSE
server](https://ci.opensuse.org/view/Yast/). It also
[submits](#automatic-submission) the built packages to OBS.


Submitting the Package
======================

Automatic Submission
--------------------

The changes in `master` branch are automatically built and submitted to
[YaST:HEAD](https://build.opensuse.org/project/show/YaST:Head) OBS project by
[Jenkins CI](https://ci.opensuse.org/view/Yast/) after successful build. If the
package version is changed then a submit request to
[openSUSE:Factory](https://build.opensuse.org/project/show/openSUSE:Factory) is
created automatically.

Manual Submission
-----------------

First build the package as described above. Then copy the content of `package/`
directory to the OBS project (replace the old files).

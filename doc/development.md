
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
the next YaST version will eventually run. But Factory is too unstable,
we recommend to use [Tumbleweed](https://en.opensuse.org/Portal:Tumbleweed)
or the latest openSUSE release — differences in the environment
usually are not big enough to cause trouble.

To prepare the development environment in Factory or Tumbleweed, install the
`devel_yast` pattern:

    sudo zypper install -t pattern devel_yast

To prepare the development environment in openSUSE, build and install the
`yast2-devtools` package yourself from the current source code (the
version present in the last openSUSE release might be too old).
You may need to install the [development dependencies](Development-Dependencies) first.

Then, to compile _yast devtools_ from source code, execute these commands:

    sudo zypper in git-core ruby gcc-c++ docbook-xsl-stylesheets 
    sudo gem install yast-rake
    git clone https://github.com/yast/yast-devtools.git
    cd yast-devtools
    make -f Makefile.cvs
    make
    sudo make install

#### Development Dependencies

Some YaST packages require additional development packages (libraries,
tools...). To get the list of development packages run `rake build_dependencies:list`
command or `rake build_dependencies:install` to install them.

### Shared YaST Infrastructure ###

While creating a new YaST project and you wanted to use the YaST team
infrastructure, you might consider taking care of these steps or ask YaST
developers to help you with them. Internal infrastructure is usually not
available from outside.

* Creating new repository under the [yast](https://github.com/yast/) path
  at GitHub
* Adjusting [RuboCop rules](http://lslezak.blogspot.cz/2014/11/using-rubocop.html)
* Creating the package in OBS at [YaST:Head](https://build.opensuse.org/project/show/YaST:Head)
  project and in IBS at [Devel:YaST:Head](https://build.suse.de/project/show/Devel:YaST:Head)
  project (if you plan to have it in SLE)
* Adding the project to [external](https://ci.opensuse.org/view/Yast/)
  and [internal](http://river.suse.de/view/YaST/) (if you plan to have it in SLE)
  [Jenkins](https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project)
  instance for continuous testing, building and package automatic submission
  (see below)
* Adding the project to [Travis](https://travis-ci.org/) for continuous testing

### Maintenance ###

If you need to fix bugs or do some other maintenance work in an already released
versions of YaST, create a virtual machine with the same openSUSE or SLE
release you are targeting and install the `devel_yast` pattern there:

    sudo zypper in -t pattern devel_yast


### Extra Development Tools ###

For running the automated tests you might need to install some more packages:

    $ sudo zypper install yast2-testsuite rubygem-rspec rubygem-simplecov


Autotools Based YaST Packages
=============================

This is a generic documentation for YaST packages which use autotools (autoconf/automake)
for building the package. These packages have usually a `Makefile.cvs` file in the base
directory.

Building and Installing
--------------------------

To build the module run these commands:

    $ make -f Makefile.cvs
    $ make

If you want to rebuild the module later simply run `make` again.

To install it run:

    $ sudo make install

Note: This will overwrite the existing module in the system, be careful when installing
a shared component (library) as it might break some other modules.


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

This is a generic documentation for YaST packages which use `rake` for building
the package. Such packages do not have the `Makefile.cvs` file in the base
directory, but have a `Rakefile` file.


Starting the Module
-------------------

You can start the module directly from the Git checkout without need to install it first.

To run the module directly from the source code, use the `run` Rake task:

    $ rake run

Or you can install it into the system and run it as the usual system modules.


Building and Installing
-----------------------

So far the rake based modules do not need to be built, they are ready to be used just
after the Git clone.

To install the module run:

    $ sudo rake install

Note: This will overwrite the existing module in the system, be careful when installing
a shared component (library) as it might break some other modules.


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

YaST uses [Travis CI](https://travis-ci.org) for building and running tests for
commits and pull requests. You can find more details in the [Travis CI
Integration](travis-integration.md) documentation.

For building on native (open)SUSE distribution we use [Jenkins CI openSUSE
server](https://ci.opensuse.org/view/Yast/). It also
[submits](#automatic-submission) the built packages to OBS.


Submitting the Package
======================

Automatic Submission
--------------------

The changes in `master` branch are automatically built and submitted to
the [YaST:HEAD](https://build.opensuse.org/project/show/YaST:Head) OBS project by
[Jenkins CI](https://ci.opensuse.org/view/Yast/) after successful build. If the
package version is changed then a submit request to
[openSUSE:Factory](https://build.opensuse.org/project/show/openSUSE:Factory) is
created automatically.

For more details, see [automatic YaST package submission](auto-pkg-submission.md).


Manual Submission
-----------------

### Maintenance Branches

In maintenance branches the automatic submissions are disabled by default and a manual request is needed.
It can be done by simply running `rake osc:sr` in the respective maintenance branch.

### Custom Build Service Repository

There are two ways. The first one is useful if it needs more often submissions.
In such case configure it in Rakefile as documented in [yast-rake](https://github.com/yast/yast-rake#customizing).
The second one is good for one time try. In such case use osc commands and to get sources
run `rake package` and use result of package directory as sources for package build.

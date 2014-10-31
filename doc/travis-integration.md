# Travis CI Integration


## Introduction

[Travis CI](https://travis-ci.org/) provides free hosted continuous integration
(CI) server. It has a nice integration with GitHub so it is very easy to
use and you can see the build results directly at GitHub, no need to check separate
page, emails etc...


### Advantages

- Build and tests are run automatically whenever a new change is pushed to GitHub
  repository or when a pull requested is created.

- The major advantage is that the tests are executed *before* a pull request
  is merged, the test failures can be found out very early. (Jenkins runs the tests
  *after* a pull request is merged to master, sometimes it required a fix up to
  a failed test.)

- Another advantage is that for example code coverage using
  [Coveralls](https://coveralls.io/) can be easily added to Travis build.

### Disadvantages

- The build runs at Ubuntu 12.04 LTS workers, that means the build environment
  is little bit different when compared to openSUSE or SUSE Linux Enterprise (SLE)
  target distributions.

- It may happen that build can fail in Ubuntu but it is OK in SUSE or vice versa.

- RPM packages cannot be built

That is why Jenkins builds still make sense - they run in the native environment.

## Notes

### Restarting a Build

It may happen that a Travis build fails because e.g. OBS is down and DEB packages cannot be
downloaded or Ruby gems from rubygems.org cannot be installed, etc...

In that case it is possible to manually re-trigger the failed build. Display the failed
build at Travis, there is a circled arrow icon in the top right corner for restarting the build.
(Make sure you are logged using your GitHub account, it is not displayed if you not have
permissions for the respective GitHub repository.)


## Implementation

Because Travis nodes runs on Ubuntu we need to be somehow able to compile/build YaST packages there.


### Open Build Service

Luckily OBS beside building usual RPMS also supports building packages for Debian and Ubuntu.

OBS project [YaST:Head:Travis](https://build.opensuse.org/project/monitor/YaST:Head:Travis)
builds packages for Ubuntu 12.04 which can be used at Travis.

To ensure that the YaST packages are up to date they link to the main packages at
[YaST:Head](https://build.opensuse.org/project/monitor/YaST:Head). The only difference
is that the YaST:Head:Travis packages contain `debian.*` source files which contain
metadata for building the Debian packages.

There are also some more packages which are needed for YaST, some provide a new version
for already present packages (newer GCC, Ruby, Swig, Boost) some are not available
for Ubuntu at all (ldapcpplib, libstorage, snapper).


### Adding a New Dependent Package

If you need to add a new YaST package to YaST:Head:Travis simply branch the package
from YaST:Head and add Debian packaging files. You can reuse the files from some
existing package as a starting point.

If you need some updated package (in a newer version than in Ubuntu 12.04) you should check
the newer Ubuntu version, maybe the package will just work or it will need only small
tweaking. See http://packages.ubuntu.com/ for Ubuntu package search.

Alternatively you can check https://launchpad.net/, it is a community platform for providing
Ubuntu packages, similar to OBS for openSUSE.


### Links

Here are some useful links if you are interested in details or you need to do
some specific Debian/Ubuntu packaging tweaks:

- http://docs.travis-ci.com/user/installing-dependencies/
- http://en.opensuse.org/openSUSE:Build_Service_Debian_builds
- https://wiki.debian.org/HowToPackageForDebian
- https://www.debian.org/doc/manuals/maint-guide/dreq.en.html
- https://help.ubuntu.com/community/CompilingEasyHowTo



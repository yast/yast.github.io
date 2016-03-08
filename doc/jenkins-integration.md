# Jenkins Integration

## Description

Currently we use both [Travis](https://travis-ci.org/) and
[Jenkins](http://jenkins-ci.org/() for CI.Travis builds the pushed
commits and Pull Requests at GitHub, Jenkins builds `master` packages and
submits them to YaST:Head OBS project (and optionally creates SR to Factory).

The idea is to use only Jenkins for both, the main reasons for switch are

- Travis runs on Ubuntu 12.04 which is very old (it's very difficult to find
  or backport recent GCC, Ruby, tools (automake), libraries (boost, Qt5), ...
  It is possible to 14.04 but that would not help much...

- Travis needs the packages in `dpkg` format, that means extra packaging work
  (vast majority of YaST developers are not familiar with Debian packaging).

- Some tests needs extra tweaks to pass in Ubuntu (different system defaults)
  or have to be disabled (missing or old packages).

- Passing build in Travis (based on Ubuntu) does not guarantee that it will pass
  in Jenkins or OBS which is based on (open)SUSE. Also the RPM packages cannot
  be built that means there still might be RPM packaging errors.

There are also some minor issues, but with switch to Jenkins can we solve them:

- Jenkins starts the build very quickly (a free worker is available most of the
  time) and if needed we can add more workers very easily and increase the build
  power.

- You cannot easily debug the build problems at Travis and for local debugging
  you would need an Ubuntu 12.04 VM and even this might not help (the Travis
  changes against the vanilla Ubuntu installation are not documented).

## The Basic Idea

Instead of running specific Travis scripts we should simply build a package
using `osc`. Building a package by `osc` in a chroot ensures we use the same
tooling (GCC, Ruby, etc...) as in the target OBS project.

But for CI we need to run some more tests which are not executed during normal
package build (they would not make sense or they would require a lot of dependencies
or would slow down the package builds significantly).

These tests include running [RuboCop](https://github.com/bbatsov/rubocop),
reporting test code coverage (using [Coveralls](https://coveralls.io/)), spell
checking and more.


## Rake CI Task

These extra tests should be shared in a single package so we do not have to update
every YaST module when we want to add or fix something.

The checks are located in the [rake-ci](https://github.com/yast/yast-rake-ci/)
Ruby gem. The checks in task are triggered by automatically by file presence, see the
[README](https://github.com/yast/yast-rake-ci/blob/master/README.md) for more
details.


## Running the Checks

- You can run the checks locally to ensure your commit will not fail at Jenkins
  later. Simply run `rake check:ci`.

- If you want to run the checks locally during RPM build then use the
  `--with yast_run_ci_tests` RPM build option. When using the standard YaST
  Rake tasks then use `rake 'osc:build[--with yast_run_ci_tests]'` command.

# How to Use Jenkins in YaST Modules

## Spec File Modification

To support the extra checks in Jenkins simply add this block to the spec file:

```
# Unfortunately we cannot move this to macros.yast,
# bcond within macros are ignored by osc/OBS.
%bcond_with yast_run_ci_tests
%if %{with yast_run_ci_tests}
BuildRequires: rubygem(yast-rake-ci)
%endif
```

The rest should be handled automatically by the RPM macros and the rake-ci gem.

## Adding a New Jenkins Job

The easies way is to base the new job on any existing `yast-*-github-push` job.
Just update the repository URL and the repository name in the job configuration.

*Note: see [this internal wiki
page](https://wiki.microfocus.net/index.php/YaST/jenkins#openSUSE_.28external.29)
for the Jenkins credentials.*

## Restarting a Build

If a Jenkins build fails for some temporary reason (e.g. OBS down, network
issues, ...) you can restart it by clicking "Retry" button the details of the
failed build.

## SLE12-SP1 Support

We cannot use the same solution for SLE12-SP1 as for *master* because that would
require updating the RPM macros in the devtools package and releasing them as a
maintenance update. That would be too much intrusive. 

The solution is to use a simpler approach - do not run the extra checks via
`rake check:ci` but only build the package as usually via `rake osc:build`.

The idea is that SLE12-SP1 is in maintenance mode and we do not expect much work
there. And a fix which is really important it will be included in `master` as well and
it will be checked there more thoroughly.


# Implementation Details

## YaST RPM Macros

The main part is shared in the [YaST RPM
macros](https://github.com/yast/yast-devtools/blob/master/build-tools/rpm/macros.yast#L73-L83).

The macros detect the build tool use (either autotools or rake) and run the
appropriate command to run the tests.

## Rake Tasks

The core part of the [rake
check:ci](https://github.com/yast/yast-rake/blob/master/lib/yast/rake.rb#L46)
part sets the dependent tests.

The required tool are installed by [gem
dependencies](https://github.com/yast/yast-rake-ci/blob/master/yast-rake-ci.gemspec#L44)
which are transferred to RPM dependencies. The additional package dependencies
are defined via
[gem2rpm.yml](https://github.com/yast/yast-rake-ci/blob/master/package/gem2rpm.yml#L59-L60)
file.

The `check:ci` task is [optionally 
loaded](https://github.com/yast/yast-rake/blob/master/lib/yast/rake.rb#L46)
by the base `yast-rake` task, if it is missing the load error is ignored.


## Jenkins

The Travis replacement is possible thanks to the *GitHub* and *GitHub pull
request builder* plug-ins. Both are installed at https://ci.opensuse.org, but not
configured completely (yet).

There is are `yast-*-github-push` Jenkins jobs which build pushed commits in
**all** branches. (In contrast to the other `yast-*-master` jobs which build
only the `master` branch.) That allows to run the tests in other branches
*before* merging to `master`.

## OBS Setup

By default the packages from the
[YaST:HEAD](https://build.opensuse.org/project/show/YaST:Head) OBS repository
are used. (As configured in the `Rakefile` in Git repositories.)

For building SLE12-SP1 code
[YaST:SLE-12:SP1](https://build.opensuse.org/project/show/YaST:SLE-12:SP1)
project is used.

These repositories contain the extra packages needed for the specific Jenkins
checks. Because we use a different project for SLE12-SP1 we can also use
different tools for building (e.g. newer RuboCop for `master`, but older for
SLE12-SP1).


# Missing Parts

- Coveralls integration (it's quite tricky to send the coverage report from a
  running osc build....)
- Build pull requests as well


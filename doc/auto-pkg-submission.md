# Automatic YaST Package Submission

When a commit is checked in to one of the YaST Git repositories on GitHub
(usually via a pull request on GitHub), in most cases a package is
automatically submitted to the openSUSE Build Service (OBS):

- Devel:YaST:Head for the IBS (the internal OBS instance, build.suse.de)

- YaST:Head for the OBS (the external OBS instance, build.opensuse.org)

This is done via the Jenkins workers (internal ci.suse.de) or GitHub Action.

The Jenkins is configured to poll the GitHub repositories, the GitHub Action is
triggered on a push to the `master` branch.

When a new Git checkin is detected, both Jenkins and the GitHub Action execute

    rake osc:sr

(in the typical configuration; different YaST packages might have slightly
different commands) which is a "rake" target from the
[packaging_rake_tasks package](https://github.com/openSUSE/packaging_rake_tasks).

_osc_ is the underlying openSUSE build service command line tool, _sr_ is short
for "submit request".




## Trickling Down the Build Dependency Chain

    rake osc:sr

depends on

    rake osc:commit

which depends on

    rake osc:build

which depends on

    rake package

which depends on

    rake tarball


This is the starting point for most YaST packages. The default "tarball" target
from
[tarball.rake](https://github.com/openSUSE/packaging_rake_tasks/blob/master/lib/tasks/tarball.rake)
simply collects all the files from the source directory tree and creates a
.tar.bz2 file from them. This is mostly useful for Ruby packages.

Compiled (i.e. C/C++) YaST packages typically override the "tarball" target in
their toplevel Rakefile (yes, they use "rake" in addition to their usual
Autotools or CMake build system).


## Compiled Packages

Snapper for example does this in its toplevel Rakefile:

```ruby
desc 'Build a tarball for OBS'
task :tarball do
  sh "make -f Makefile.ci package"
end
```

This in turn calls the

    obs-package-from-git

script which fetches the old version of that package from OBS (strictly, only
the .spec file is relevant here) and initializes an "osc build" environment in
a chroot jail based on the build requirements of that .spec file. It also
patches the .spec file to fail right after the build environment is set up,
then cleans away the old tarball it just fetched from OBS and unpacks the new
one built from the last Git checkin (which triggered the whole scenario).

That version is now built with the RPM build command.

So, to reiterate, this is basically an interrupted "osc build" that just
replaced the sources (the tarball) from the last OBS version with the latest
one just generated from the latest Git checkin. The last OBS version was just
used to install the correct BuildRequires RPMs.



## Going Back Up the Build Dependency Chain

When building the package succeeded, the test suite ran successfully, and other
checks (change log sanity check etc.) were also successful and the package
version number was increased, the created RPMs are simply deleted (the purpose
was just to check if building and tests were successful), and the tarball,
.spec file etc. generated from the last Git checkin are checked in to OBS.

## The GitHub Action

The GitHub Action which submits the package to OBS is defined in the
[submit](https://github.com/yast/actions/tree/master/submit) directory in the
[actions](https://github.com/yast/actions) GitHub repository.

The action is reused in all relevant YaST repositories which are submitted to
Factory.

The OBS credentials are defined in the `yast` organization and shared in
selected repositories. If a new repository is added then it must be explicitly
added to the allowed list. See the
[actions](https://github.com/organizations/yast/settings/secrets/actions) GitHub
page (requires administration permissions).

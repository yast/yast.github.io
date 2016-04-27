# Automatic YaST Package Submission

When a commit is checked in to one of the YaST Git repositories on GitHub
(usually via a pull request on GitHub), in most cases a package is
automatically submitted to the openSUSE Build Service (OBS):

- Devel:YaST:Head for the IBS (the internal OBS instance, build.suse.de)

- YaST:Head for the OBS (the external OBS instance, build.opensuse.org)

This is done via one of the Jenkins workers (external: ci.opensuse.org;
internal: ci.suse.de) that are configured to poll the GitHub repositories.
When a new Git checkin is detected, Jenkins executes

    rake osc:sr

(in the typical configuration; different YaST packages might have slightly
different commands) which is a "rake" target from the
[packaging_rake_tasks package](https://github.com/openSUSE/packaging_rake_tasks)

"osc" is the underlying openSUSE build service command line tool, "sr" is short
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
AutoTools or CMake build system).


## Compiled Packages

Snapper for example does this in its toplevel Rakefile:

    desc 'Build a tarball for OBS'
    task :tarball do
      sh "make -f Makefile.ci package"
    end

This in turn calls the

    obs-package-from-git

script which fetches the old version of that package from OBS (strictly, only
the .spec file is relevant here) and initializes an "osc build" environment in
a chroot jail based on the build requirements of that .spec file. It also
patches the .spec file to fail right after the build environment is set up,
then cleans away the old tarball it just fetched from OBS and unpacks the new
one built from the last Git checkin (which triggered the whole scenario).

That version is now built with the RPM build command.

So, to reiterate, this is basically an interrrupted "osc build" that just
replaced the sources (the tarball) from the last OBS version with the latest
one just generated from the latest Git checkin. The last OBS version was just
used to install the correct BuildRequires RPMs.



## Going Back Up the Build Dependency Chain

When building the package succeded, the test suite ran successfully, and other
checks (change log sanity check etc.) were also successful and the package
version number was increased, the created RPMs are simply deleted (the purpose
was just to check if building and tests were successful), and the tarball,
.spec file etc. generated from the last Git checkin are checked in to OBS.


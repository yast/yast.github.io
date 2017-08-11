Versioning YaST
===============

Version numbers are related to SUSE versions
--------------------------------------------

Starting on August 2017, the YaST team adopted a new versioning schema.
Now, version numbers are related to the SUSE version. Let's see an example:

* Major number is related to the major SUSE version (4 for SLE 15, 5 for
  SLE 16, and so on).
* Minor number is related to the SUSE Service Pack number (0, 1, 2...).
* Patch number enumerates versions for a given major/minor version.

For instance, `4.2.3` is meant to be the third version of a package for
`SLE 15 SP2`.

NOTE: it is perfectly fine if, let's say SLE 15 SP2, contains a package which
version is `4.1.1`.  It means that the package has not been changed since SLE
15 SP1 times.

When to bump each number
------------------------

Basically, these are the rules when it comes to increase version numbers:

* Every fix/change that goes as a *maintenance update* should increment the
  *patch* number (`4.0.1`, `4.0.2`, etc.).
* The first commit that introduces a divergence between the latest SP
  branch (for instance `SLE-15-SP2`) and `master` should increment the *minor*
  version.
* The first commit that introduces a divergence which is meant to be only
  available in the next major SUSE release should increment the *major*
  version.

Example
-------

The best way to understand how versioning works is through an example. Let's
say SLE 15 (SP0) was already released and let's say there is a package
`yast2-example` which version is `4.0.0`. Moreover, there is a `SLE-15` branch
in the repository.

* A regular fix increases the version to `4.0.1`. Of course, that change
  is merged into `master` but keeping the same number as far as the package
  has not diverged.
* Then a new change which is meant for SLE 15 SP1 is added to the `master`
  branch. So the package has diverged and the *minor* version should be
  increased (`4.1.0`).
* Another fix for the already released version appears. `SLE-15` version is now
  `4.0.2` and `master` is `4.1.1`.
* Fast forward: SLE 15 SP1 is about to be released and a new `SLE-15-SP1` branch
  is created (keeping version `4.1.1`).
* A fix for `SP1` increases version to `4.1.2`. The change is merged into master.
* A fix for `master` increases version to `4.2.0`.

Finally, the scenario should be like this:

* `SLE-15`: 4.0.2.
* `SLE-15-SP1`: 4.1.2
* `master`: 4.2.0

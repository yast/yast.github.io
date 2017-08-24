# Versioning YaST

Starting on August 2017, the YaST team adopted a new versioning schema to be
followed by packages included in SUSE Linux Enterprise (SLE) 15 and openSUSE
Leap 15, beyond.

If you are interested in the old schema, which is still used for SLE 12 and
openSUSE Leap 42.x, have a look at the *Old schema* section of this document.

## New schema: version numbers are related to SUSE versions

From now on, version numbers will be related to the SUSE version. Let's see an
example:

* Major number is related to the major SUSE version (4 for SLE 15, 5 for
  SLE 16, and so on).
* Minor number is related to the SUSE Service Pack number (0, 1, 2...).
* Patch number enumerates versions for a given major/minor version.

For instance, `4.2.3` is meant to be the fourth version which is specific to SLE
15 SP2.

Note that it is perfectly fine if, let's say SLE 15 SP2, contains a package
which version is `4.1.1`.  It means that the package has not been changed since
SLE 15 SP1 times.

### When to bump each number

Basically, these are the rules when it comes to increase version numbers:

* Every fix/change that goes as a *maintenance update* should increment the
  *patch* number (`4.0.1`, `4.0.2`, etc.).
* The first commit that introduces a divergence between the `master` and the
  latest SP branch (for instance `SLE-15-SP2`) should increment the *minor*
  version.
* The first commit that introduces a divergence which is meant to be only
  available in the next major SUSE release should increment the *major*
  version.

### Example

The best way to understand how versioning works is through an example. Let's
say SLE 15 (SP0) was already released and let's say there is a package
`yast2-example` which version is `4.0.0`. Moreover, there is a `SLE-15` branch
in the repository.

1. A regular fix increases the version to `4.0.1`. Of course, that change is
   merged into `master` but keeping the same number as far as the package has
   not diverged.
2. Then a new change which is meant for SLE 15 SP1, but not desired for SLE 15
   (SP0), is added to the `master` branch. So the package has diverged and the
   *minor* version should be increased (`4.1.0`).
3. Another fix for the already released version appears. `SLE-15` version is now
   `4.0.2` and `master` is `4.1.1`.
4. Fast forward: SLE 15 SP1 is about to be released and a new `SLE-15-SP1`
   branch is created (keeping version `4.1.1`).
5. A fix for `SP1` increases version to `4.1.2`. The change is merged into
   master.
6. A fix for `master` (diverging from `SLE-12-SP1` version) increases version to
   `4.2.0`.

The resulting scenario should be:

* `SLE-15`: 4.0.2.
* `SLE-15-SP1`: 4.1.2
* `master`: 4.2.0

Fast forward again: SLE 15 SP4 is under development. But `yast2-example` has not
changed since SP2 times, so its current version is still `4.2.0`.

7. Then a fix for `master` comes in. As this fix is intended for SP4 and
   introduces a divergence with SP2, we should bump minor and patch numbers to
   `4.4.0`. Note the correspondence between minor number and the SP number.

Of course, when SUSE Linux Enterprise 16 arrives, the first change that
introduces a divergence with last SLE 15 version should increase version
number to `5.0.0`.

Let's summarize the current situation:

* `SLE-15`: 4.0.2.
* `SLE-15-SP1`: 4.1.2
* `SLE-15-SP2`: 4.2.0
* `SLE-15-SP3`: 4.2.0
* `SLE-15-SP4`: 4.4.0
* `master` (already targeting SLE 16): 5.0.0

Finally, what happens if a bug is fixed for `SLE-15-SP3` (and newer versions)?
The change introduces a divergence between `SLE-15-SP2` and `SLE-15-SP3`, so
minor number should be increased:

* `SLE-15`: 4.0.2.
* `SLE-15-SP1`: 4.1.2
* `SLE-15-SP2`: 4.2.0
* `SLE-15-SP3`: *4.3.0*
* `SLE-15-SP4`: *4.4.1*
* `master` (already targeting SLE 16): *5.0.1*

## Old schema

### Increase the patch number

The old schema is still valid for SLE 12 and openSUSE Leap 42.x. The general
rule is to bump only the patch number and, if needed, add a fourth one to avoid
conflicts.

Major and minor versions are only incremented under team agreement. For
instance, the minor number was changed when CaaSP development started and,
again, after branching `SLE-12-SP3` (which was about to be released in that
time).

About the major version, it was reserved for big changes in YaST world, like
migrating from YCP to Ruby.

### Avoiding conflicts

Following this schema we can face a tricky situation. Consider this scenario:
our `yast2-example` repository contains these branches:

* `SLE-15`: 3.3.1
* `SLE-15-SP1`: 3.3.2 (this branch contains a new feature)

If we want to release a fix for `SLE-15`, we cannot just bump the patch number,
because 3.3.2 already exist and contains different code. The solution is to add
a fourth number to the `SLE-15`. In this case, it would be 3.3.1.1.

This new digit will be incremented with every new version on that branch
(3.3.1.2, 3.3.1.3, etc.) avoiding any possible conflict in the future.

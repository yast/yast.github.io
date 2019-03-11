# Versioning YaST

Starting on August 2017, the YaST team adopted a new versioning schema to be
followed by packages included in SUSE Linux Enterprise (SLE) 15 and openSUSE
Leap 15, beyond.

If you are interested in the old schema, which is still used for SLE 12 and
openSUSE Leap 42.x, have a look at the *Old schema* section of this document.

## New schema: version numbers are related to SUSE versions

From now on, version numbers will be tied to the SUSE versions:

* Major number is related to the major SUSE version (4 for SLE 15, 5 for
  SLE 16, and so on).
* Minor number is related to the SUSE Service Pack number (0, 1, 2...).
* Patch number enumerates versions for a given major/minor version.

For instance, `4.2.3` would be the fourth version of the package for SLE 15 SP2
(the first one would be 4.2.0).

### When to bump each number

Basically, these are the rules for increasing version numbers:

* The first commit that introduces a divergence which is meant to be only
  available in the next major SUSE release should increment the *major*
  version (e.g., from `4.3.45` to `5.0.0`).
* The first commit that introduces a divergence which is meant to be only
  available in the next Service Pack release should increment the *minor*
  version (e.g., from `4.3.45` to `4.4.0`).
* Every fix/change that goes as a *maintenance update* should increment the
  *patch* number (`4.0.1`, `4.0.2`, etc.).

Note that during the development phase of the next product (either a Service Pack or a major release),
only the *patch* number is bumped meanwhile there is no code divergence regarding the previous product.
The *major* and *minor* numbers are properly bumped before the product release in case no divergence has
been introduced during the development phase.

### Example

Let's try an example for a better understading about how the new YaST versioning policy works.

Scenario: last realesed product was SLE 15 (SP0) and SLE 15 SP1 is currently on its development
phase. Moreover, there is a package `yast2-example` which version is `4.0.9` and there is a
`SLE-15-GA` branch in the repository.

### Fix a bug for the latest released Service Pack: SLE 15 SP0

1. The fix is implemented into the `SLE-15-GA` branch and the *patch* number is increased from
   `4.0.9` to `4.0.10`.
2. Then the fix is merged into master (to also include it as part of SP1). If there is no
   code divergence yet with master branch, then the version is kept as `4.0.10` in master too.
   But if some changes were included into master previously (e.g., for the implementation
   of a new feature for SP1, see next example), the version number in master would be bumped from
   something like `4.1.3` to `4.1.4`.

### Add new a change for the next Service Pack: SLE 15 SP1

1. The feature/fix is implemented into the master branch.
2. If this is the first divergence with the `SLE-15-GA` branch, the *minor* number is increased
   from `4.0.9` to `4.1.0`. Otherwise, only the *patch* number is increased, e.g., from
   `4.1.3` to `4.1.4`.

### Add a new change for the next SLE major version: SLE 16 SP0

1. The feature/fix is implemented into the master branch.
2. If this is the first divergence with the previous product, the *major* number is increased
   from `4.0.9` to `5.0.0`. Otherwise, only the *patch* number is increased, e.g., from
   `5.0.3` to `5.0.4`.


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

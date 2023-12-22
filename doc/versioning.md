# Versioning YaST

Starting on August 2017, the YaST team adopted a new versioning schema to be
followed by packages included in SUSE Linux Enterprise (SLE) 15 and openSUSE
Leap 15, beyond.

If you are interested in the old schema, which is still used for SLE 12 and
openSUSE Leap 42.x, have a look at the *Old schema* section of this document.

## New schema: version numbers are related to SUSE versions

From now on, version numbers will be tied to the SUSE versions:

* Major number is related to the major SUSE version (*4* for *SLE 15*, *5* for
  *SLE 16*, and so on).
* Minor number is related to the SUSE Service Pack number (*0* for *SP0*, *1* for *SP1*, etc).
* Patch number enumerates versions for a given major/minor version.

For instance, *4.2.3* would be the fourth version of the package for *SLE 15 SP2*
(the first one would be *4.2.0*).

### When to bump each number

YaST repositories keep a git branch for every (open)SUSE product. For example, a
*SLE-15-SP1* branch is used for the development of *SLE 15 SP1* and *openSUSE Leap 15.1* products,
*SLE-15-SP2* for *SLE 15 SP2* and *openSUSE Leap 15.2*, etc. The *master* branch is used for
*Factory* and consequently for *openSUSE Tumbleweed*.

As described above, each YaST version corresponds to a specific product. So, when a change is
introduced in a branch, the next version would be defined by the product that branch is tracking.
For example, the first change in the *SLE-15-SP2* branch would have the version *4.2.0*.

### Examples

Let's try some examples to illustrate how the new YaST versioning policy works.

Scenario: there is a repository for a package named *yast2-package* which has three branches. The
*SLE-15-GA* branch for tracking the code of *SLE 15 GA* and *openSUSE Leap 15* products, the
*SLE-15-SP1* branch for *SLE-15-SP1* and *openSUSE Leap 15.1*, and finally the *master* branch for
tracking the development of *openSUSE Tumbleweed*.

The current versions are *4.0.58* for *SLE-15-GA*, *4.1.9* for *SLE-15-SP1* and version *5.0.32* for
master.

### Example1: fix a bug for GA

1. The fix is implemented into the *SLE-15-GA* branch and the *patch* number is increased from
   *4.0.58* to *4.0.59*.
2. The fix is merged into *SLE-15-SP1* and the version is bumped from *4.1.9* to *4.1.10*.
2. And then the fix is merged into *master* too in order to submit to *Factory*. The patch number is
bumped in *master* to *5.0.33*.

### Example 2: fix a bug for SP1

1. The fix is implemented into the *SLE-15-SP1* branch and the *patch* number is increased from
   *4.1.9* to *4.1.10*.
2. The fix is merged into *master* and the version is bumped from *5.0.32* to *5.0.33*.

### Example 3: add a new change for Tumbleweed

1. The feature/fix is implemented into the *master* branch and the patch version is increased to
*5.0.33*.

### Example 4: add a new service pack

1. A new branch *SLE-15-SP2* is created from *SLE-15-SP1*.
2. The first version in this new branch will be *4.2.0*.

### Example 5: a new major version (e.g., SLE 16)

1. A new branch *SLE-16-GA* is created from *master*. This new branch will continue with versions
*5.0.X*. Its first change will have version *5.0.33*.
2. Major version is bumped in *master* from *5.0.32* to *6.0.0*.

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

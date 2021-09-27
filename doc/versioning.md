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
* Minor number is related to the SUSE Service Pack number (0 for SP0, 1 for SP1, etc).
* Patch number enumerates versions for a given major/minor version.

For instance, *4.2.3* would be the fourth version of the package for SLE 15 SP2
(the first one would be 4.2.0).

### When to bump each number

YaST repositories keep a git branch for every released (open)SUSE product. For example, a
*SLE-15-SP1* branch is used for the development of *SLE 15 SP1* and *openSUSE Leap 15.1* products,
*SLE-15-SP2* for *SLE 15 SP2* and *openSUSE Leap 15.2*, etc. The *master* branch is used for
*Factory* and also for the service pack (or major release) that is currently in development phase.
As described above, each YaST version corresponds to a specific product. So, when a change is
introduced in a branch, the next version would be defined by the product that branch is tracking.
For example, the first change in the *SLE-15-SP2* branch would have the version *4.2.0*.

Basically, these are the rules for increasing version numbers:

* The first commit to a branch will use the version for the tracked product, with *patch* number *0*
  (e.g., *4.3.0* for *SLE-15-SP3*, *5.0.0* for *SLE-16-GA*, etc).
* Next changes in a branch will increment the *patch* number (*4.3.1*, *4.3.2*, etc.).

### Example

Let's try an example for a better understanding about how the new YaST versioning policy works.

Scenario: last released product was *SLE 15 SP0* (a.k.a. *SLE 15 GA*) and *SLE 15 SP1* is starting
its development phase. Moreover, there is a package *yast2-example* which version is *4.0.9*.
A *SLE-15-GA* branch was created after releasing *SLE 15 SP0*.

### Fix a bug for the latest released Service Pack: *SLE 15 SP0*

1. The fix is implemented into the *SLE-15-GA* branch and the *patch* number is increased from
   *4.0.9* to *4.0.10*.
2. Then the fix is merged into master in order to also include it as part of SP1. In this case, the
   version for *master* would be *4.1.X* because *master* is now tracking the development of
   *SLE 15 SP1* (and *Factory*). Note that the *patch* number will be *0* or the next corresponding
   number if *master* already contains a *4.1.X* version.

### Add new a change for the next Service Pack: *SLE 15 SP1*

1. The feature/fix is implemented into the *master* branch.
2. Again, the version would be *4.1.X* because *master* is tracking the development of *SLE 15 SP1*
   (and *Factory*).

### Add a new change for the next SLE major version: *SLE 16 SP0*

1. The feature/fix is implemented into the *master* branch.
2. And the version in this case would be *5.0.X* (the *major* number for *SLE 16* is *5* and the
  *minor* number for *SP0* is *0*).


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

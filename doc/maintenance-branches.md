Maintenance Branches
====================

The goal of this document is to describe and explain work-flow for maintenance
branches. It does not affect development in master except of merging of fixes from
maintenance branch. It is not goal of this document to discuss which way is better
for pull requests or how to use the git in exact situations.

Why Maintenance Branches?
-------------------------

YaST uses maintenance branches because it is easier to track patches for already
released products in git then in Build Service. It gives ability to easy review
of fixes and also to merge fixes in master branch, to avoid forgotten ones.

Maintenance Work-Flow
---------------------

The default maintenance workflow is to fix it in the oldest applicable branch and
then merge to the newer ones.

The following rules apply to working with maintenance branches:

* no `cherry-pick` as part of common work-flow. In a nutshell, cherry-picking
  changes the SHA because the commit will get a new parent commit. And with
  different SHAs, it is difficult to find out if all desired commits from the
  branch are now also in master. For deeper explanation see these articles
  [1](http://dan.bravender.net/2011/10/20/Why_cherry-picking_should_not_be_part_of_a_normal_git_workflow.html), [2](http://www.draconianoverlord.com/2013/09/07/no-cherry-picking.html) or [reddit](https://www.reddit.com/r/git/comments/3ubuel/merge_vs_rebase_why_not_cherrypick/))
* merge new maintenance branches to master regularly
* create fix for the oldest applicable branch first

### Why

The first and main reason is that it allows easy tracking whether a fix in a commit is
also in newer branches and master. The second reason is that it produces a nicer
git tree structure which allows to see which code stream is affected by which
fix. The easiest way to see if some commits are missing is to use the GitHub UI
and compare branches.

It can be done also on the command line:

Example how to check what fixes are not merged:
```
git pull
git log origin/master..origin/SLE-12-GA # if nothing appears then all are merged
```

Examples how to see the git tree:
```
gitk --all # to get a GUI
git log --graph --pretty=oneline --abbrev-commit --decorate --all
```

### Example Work-Flow

Let's say we have *SLE-12-GA*, *SLE-12-SP1* and *master* branches:

```
git checkout SLE-12-GA
git pull
git checkout -b my_fix_SLE12 # branch based on SLE-12-GA
..hacking...
git commit
git push
# wait for review and merge

# Merge SLE-12-GA into SLE-12-SP1
git checkout SLE-12-SP1
git pull
git checkout -b my_fix_sp1 # branch based on SLE-12-SP1
git merge origin/SLE-12-GA # to ensure that we use recent branch on remote
# fix possible conflicts and git commit if needed...
git push

# And now merge SLE-12-SP1 into master
git checkout master
git pull
git checkout -b my_fix_master # branch based on master
git merge origin/SLE-12-SP1 # to ensure that we use recent branch on remote
# fix possible conflicts and git commit if needed...
git push
```

### Branch Specific Commits

A maintenance branch usually contains commits that switch e.g. CI and Docker file
to its own target. If a merge contains this commit, simply use
`git revert <commit>`. This will revert it even for future.

### YCP Branch

When backporting a fix from Ruby to YCP it is recommended to
write it from scratch as there is no ruby2ycp converter.

For the other way around, when first a fix is in YCP and then needed in Ruby,
the `ycp2ruby`
converter *can* be used, but the recommended way is to write it also from scratch
because the result will be a much nicer Ruby code.

### Merge Has More Commits

While merging, sometimes we see more commits than expected. This can happen if someone
forgot to merge earlier. In this case you should be the hero and also merge it to the
newer branches. If there are conflicts, you should follow these strategies in order to
fix them (in that order):

* Resolve conflicts manually.
* Merge using `git merge -s ours`.

The option `-s ours` should be applied as a last resort. That option would join the branch
histories but apply no code from the older branch. This would be necessary in special repos
in which there is a big divergence between products (e.g., from *SLE-12* to *SLE-15*).

### Backporting Fix

When a maintenance fix was not requested and made only in master and then
requested to backport to a maintenance branch, it is still needed to `merge` back
the `cherry-pick` used for backporting the fix so we are still sure that nothing is missing.

Example how to backport a fix and then merge the branch back
```
git checkout SLE-12-GA
git pull
git checkout -b my_fix_SLE12
git cherry-pick <fix from master>
...possible conflict resolution
git commit
git push
# wait for review and merge
git checkout master
git pull
git merge origin/SLE-12-GA
...fix possible conflicts and git commit if needed...
git push
# wait until a review passes, then merge to master
```

How to Submit a Maintenance Request
-----------------------------------

For *master* it is handled by Jenkins and no work is needed.

For branches that contain a `Rakefile`,
ensure that the version has been increased and call `rake osc:sr`.

For branches without a `Rakefile`, create the source tarball and follow the
[openSUSE guide](https://en.opensuse.org/openSUSE:Package_maintenance).

How to Create a Maintenance Branch
----------------------------------
When a maintenance branch needs to be created, there is a
[helper tool](https://github.com/yast/yast-devtools/blob/master/ytools/yast2/create_maintenance_branch)
available in devtools. Execute it without arguments to see usage instructions.

Maintenance Branch Naming
-------------------------
Already known names for branches:

- `SLE-10`: SLE 10 GA
- `SLE-10-SP*`: SLE 10 Service packs
- `Code-11`: SLE 11 GA
- `Code-11-SP*`: SLE 11 Service packs
- `SLE-*-GA`: SLE 12 and later GAs
- `SLE-*-SP*`: SLE 12 and later Service packs
- `openSUSE-1*`: respective openSUSE release
- `openSUSE-4*`: openSUSE leap releases (see below)

Maintenance branches for Leap only make sense for a few repositories.
For most YaST packages, openSUSE Leap and SLE share the same code and
maintenance updates and, thus, only the corresponding `SLE-*` maintenance
branch is used. Leap maintenance branches will be created manually in a case by
case basis, only when needed and only for repositories that affect openSUSE but
not SLE.

Working with SLE 10 and SLE 11
------------------------------

These older code streams do not use the familiar Rake tasks, and the system libraries they
may expect is probably significantly different from your workstation.

[Maintenance-made-easy](https://github.com/mvidner/maintenance-made-easy)
is a tool that uses OBS chroots to help you make and submit packages for SLE 10 and SLE 11.

How to find if maintenance branch is still actively maintained
--------------------------------------------------------------
NOTE: It uses SUSE internal tools, as it contain non public data about long term support.

### Web Way

Go to [https://maintenance.suse.de/maintained/](https://maintenance.suse.de/maintained/).


### CLI Way

Connect to DE network and run `/work/src/bin/is_maintained <pkg_name>`. If it failed, then to show
why osc failed, use `-r` which can indicate e.g. missing .oscrc file with credentials.

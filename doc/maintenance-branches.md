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

There is difference between older maintenance branches and new ones starting
from SLE-12-GA.

For older branches fix is created in separated commits. Command git cherry-pick
can be used, but to apply fix from ycp to ruby code is recommended to write it
from scratch. Also when backporting fix from ruby to ycp it is recommended to
write it from scratch as there is no ruby2ycp converter.

Example work-flow for older branch (can vary depending on scenario):
```
git checkout Code-11-SP4
git pull
git checkout -b my_fix
...hacking...
git commit
git push
git checkout SLE-12-GA
git pull
git checkout -b my_fix_SLE12
..hacking or git cherry-pick...
git commit
git push
```

For new branches fix have to be done in the oldest affected branch and then
merged to newer branches and master with git merge. There are two reasons for
such change.
The first and main reason is that it allows easy tracking if fix in commit is
also in newer branches and master. The second reason is that it produces nicer
git tree structure which allows to see which code stream is affected by which
fix.

Example work-flow for newer branch:
```
git checkout SLE-12-GA
git pull
git checkout -b my_fix_SLE12 # branch based on SLE-12-GA
..hacking...
git commit
git push
# wait for review and merge
git checkout master
git pull
git checkout -b my_fix_master # branch based on master
git merge origin/SLE-12-GA # to ensure that we use recent branch on remote
# fix possible conflicts and git commit if needed...
# if maintenance branch contain its specific commit,
# then use git revert <commit number> and next time it won't appear
git push
```

When maintenance fix was not requested and made only in master and then mind
changed, it is still needed to merge back cherry pick used for backporting fix.
It is valid only for new branches.

Example how to backport fix and then merge branch back
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

Example how to check what fixes are not merged:
```
git pull
git log origin/master..origin/SLE-12-GA # if nothing appear, then all merged
```

Examples how to see git tree:
```
gitk # to get graphical one
git log --graph --pretty=oneline --abbrev-commit --decorate --all
```

Maintenance Fixes Rules
-----------------------

To get all benefits described above, there are few easy rules.
* no cherry-pick for new maintenance branches
* merge new maintenance branches to master regularly
* create fix for the oldest applicable branch first

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
available in devtools. It receives two arguments - the first one is the name of
the new branch to create and the second is the target used by
[yast-rake](https://github.com/yast/yast-rake) for that branch (see the
yast-rake README for more information about targets).

An optional third argument can be passed to the script when
the maintenance branch needs to be created from a specific commit or branch. By
default it creates the branch from the latest master.

Maintenance Branch Naming
-------------------------
Already known names for branches:

- `SLE-10`: SLE 10 GA
- `SLE-10-SP*`: SLE 10 Service packs
- `Code-11`: SLE 11 GA
- `Code-11-SP*`: SLE 11 Service packs
- `SLE-12-GA`: SLE 12 GA
- `SLE-12-SP*`: SLE 12 Service packs
- `openSUSE-1*`: respective openSUSE release
- `openSUSE-4*`: openSUSE leap releases (see below)

Maintenance branches for Leap only make sense for a few repositories.
For most YaST packages, openSUSE Leap and SLE share the same code and
maintenance updates and, thus, only the corresponding `SLE-*` maintenance
branch is used. Leap maintenance branches will be created manually in a case by
case basis, only when needed and only for repositories that affect openSUSE but
not SLE.

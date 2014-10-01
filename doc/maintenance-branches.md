Maintenance Branches
====================
The goal of this document is to describe and explain work-flow for maintenance
branches. It does not affect development in master except of merging of fixes from
maintenance branch.

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
from scratch.

Example work-flow for older branch:
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
git checkout -b my_fix_SLE12
..hacking...
git commit
git push
# wait for review and merge
git checkout master
git pull
git checkout -b my_fix_master
git merge SLE-12-GA
...fix possible conflicts and git commit if needed...
git push
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

---
layout: post
date: 2019-08-14 12:16:08.000000000 +00:00
title: Highlights of YaST Development Sprint 82
description: July and August are very sunny months in Europe… and chameleons
  like sun.
category: SCRUM
tags:
- Distribution
- Documentation
- Factory
- Programming
- Systems Management
- YaST
---

July and August are very sunny months in Europe… and chameleons like
sun. That’s why most YaST developers run away from their keyboards
during this period to enjoy vacations. Of course, that has an impact in
the development speed of YaST and, as a consequence, in the length of
the YaST Team blog posts.

But don’t worry much, we still have enough information to keep you
entertained for a few minutes if you want to dive with us into our
summer activities that includes:

* Enhancing the development documentation
* Extending AutoYaST capabilities regarding Bcache
* Lots of small fixes and improvements

### AutoYaST and Bcache – Broader Powers

Bcache technology made its debut in YaST several sprints ago. You can
use the Expert Partitioner to create your Bcache devices and improve the
performance of your slow disks. We even published a [dedicated blog
post][1] with all details about it.

Apart of the Expert Partitioner, [AutoYaST was also extended][2] to
support Bcache devices. And this time, we are pleased to announce that …
we have fixed our [first Bcache bug][3]

Actually, there were two different bugs in the AutoYaST side. First, the
auto-installation failed when you tried to create a Bcache device
without a caching set. On the other hand, it was not possible to create
a Bcache with an LVM Logical Volume as backing device. Both bugs are
gone, and now AutoYaST supports those scenarios perfectly.

{% include blog_img.md alt="Configuring Bcache and LVM with AutoYaST"
src="autoyast-bcache-300x147.png" full_img="autoyast-bcache.png" %}

But Bcache is a quite young technology and it is not free of bugs. In
fact, it fails when the backing device is an LVM Logical Volume and you
try to set the cache mode. We have already [reported a bug][4] to the
Bcache crew and (as you can see in the bug report) a patch is already
been tested.

### Enhancing Our Development Documentation

This sprint we also touched our [development documentation][5],
specifically we documented our process for creating the maintenance
branches for the released products. The [new branching documentation][6]
describes not only how to actually create the branches but also how to
adapt all the infrastructure around (like Jenkins or Travis) which
requires special knowledge.

We will see how much the documentation is helpful next time when
somebody has to do the branching process for the next release. :wink:

### Working for a better ~~world~~ YaST

We do our best to write code free of bugs… but some bugs are smarter
than us and they manage to survive and reproduce. Fortunately we used
this sprint to do some hunting.

* We made the recently added `select_product` control file option work
  as it’s really expected. That is, selecting the given product in
  addition to displaying its license. See the [pull request containing
  the fix][7] for (a lot of) additional information.
* We fixed the [previously improved product selection for
  multi-repository medias][8], which was raising some `undefined method`
  errors. See [yast/yast-packager#462][9].
* The Expert Partitioner [was failing][10] in some cases when trying to
  remove devices from a Btrfs file system. Now it works as expected.
* During the installation, the partitioning proposal [was raising an
  unexpected exception][11] under certain scenarios involving BIOS
  RAIDs. This error was also fixed.

Those are only some examples of the kind of bugs we have fought during
this sprint. But checking bug reports has also made us think in the
future…

### LibYUI in 21st Century

We fixed [a bug][12] related to how the focus was managed in text mode
after changing any setting via the hyperlinks available in the
installation summary.

{% include blog_img.md alt="Installation summary in text mode"
src="efi-warning-ncurses-300x224.png" full_img="efi-warning-ncurses.png" %}

The implemented solution is actually not perfect, it’s just the better
we can do with our set of widgets. And that was yet another example of
such problem – LibYUI is an awesome library that allows us to create
interfaces that work in both graphic and text modes, but it has
basically not evolved for more than a decade… and it’s time to fix that!

So we have been discussing how to organize our time in the close future
to leave some room for innovation and renovation regarding LibYUI and
the YaST UI in general. Stay tuned for more news.

### August is still not over

The YaST Team will keep working during the rest of the summer sharpening
our Linux Swiss army knife. But half of the team is still on vacation or
starting their vacation now. So most likely our next report will be here
in two weeks and it will also be a light read.

Meanwhile, don’t forget to have a lot of fun!



[1]: {{ site.baseurl }}{% post_url 2019-02-27-recapping-the-bcache-support-in-the-yast-partitioner %}
[2]: {{ site.baseurl }}{% post_url 2019-03-14-highlights-of-yast-development-sprint-73 %}
[3]: https://bugzilla.suse.com/show_bug.cgi?id=1139783
[4]: https://bugzilla.suse.com/show_bug.cgi?id=1139948
[5]: https://yastgithubio.readthedocs.io/en/latest/README/
[6]: https://yastgithubio.readthedocs.io/en/latest/branching-how-to/
[7]: https://github.com/yast/yast-yast2/pull/954
[8]: https://github.com/yast/yast-packager/pull/459
[9]: https://github.com/yast/yast-packager/pull/462
[10]: https://bugzilla.suse.com/show_bug.cgi?id=1142669
[11]: https://bugzilla.suse.com/show_bug.cgi?id=1139808
[12]: https://bugzilla.suse.com/show_bug.cgi?id=1142353

---
layout: post
date: 2020-01-24 15:35:49.000000000 +00:00
title: Highlights of YaST Development Sprint 92
description: This print we were focused mainly on the storage and package
  related improvements and fixes.
category: SCRUM
permalink: blog/2020-01-24/sprint-92
tags:
- Systems Management
- Uncategorized
- YaST
- faster
- installation
- nfs
- partitioner
- progress
- retracted
- table
---

### The Contents

* [Partitioner: An Actionable Overview
  Screen](#an-actionable-partitioner-overview-screen)
* [Not only Partitioner: Numeric Sorting in
  Tables](#numeric-sorting-in-tables)
* [Improving the NFS Module](#improving-the-nfs-module)
* Package Installation:
  * [Installation Progress
    Improvements](#installation-progress-improvements)
  * [Doomsday Preparations: Retracted
    Packages](#doomsday-preparations-retracted-packages)
  * [Qt Package Selection Gets
    Faster](#qt-package-selection-gets-faster)

### An Actionable Partitioner Overview Screen   {#an-actionable-partitioner-overview-screen}

Until now, the Partitioner landing screen has been useful to have a big
picture of the devices in your system and as a shortcut to jump directly
to the device page just with a double click over it. But, do you know
what? From yast-storage-ng 4.2.74 on you can work directly with devices
from that screen similar as you already do in the more specific pages,
through the contextual actions added below the devices list. That means,
for example, no more jumps to Hard Disks just to add a new partition nor
resize an existing one. Enjoy :wink:


{% include blog_img.md alt=""
  src="s92-01-part-300x225.png" full_img="s92-01-part.png" %}

More details: [PR 1024][1]

### Numeric Sorting in Tables   {#numeric-sorting-in-tables}

We have improved the sorting for tables in [libyui][2], the UI library
of YaST. So far columns were sorted directly by the text displayed,
e.g. the device name or the size in the expert partitioner. For some
use-cases this resulted in unexpected ordering, e.g. partitions of a
disk were ordered “/dev/sda1”, “/dev/sda10”, “/dev/sda2”, and sizes were
ordered “1 GiB”, “2 TiB” and “4 GiB”.

Now it is possible to [provide a sort-key for every table entry][3]
which is then used instead of the displayed text. This allows the
expected ordering and is already implemented for the tables in the
expert partitioner as the two pictures below show.

{% include blog_img.md alt=""
  src="s92-02-num1-300x228.png" full_img="s92-02-num1.png" %}

{% include blog_img.md alt=""
  src="s92-03-num2-300x240.png" full_img="s92-03-num2.png" %}

### Improving the NFS Module   {#improving-the-nfs-module}

YaST offers a specific module to configure your [NFS][4] shares. Similar
to every YaST module, you can run it by executing `yast2 nfs` in your
terminal, or by launching it from the YaST Control Center. But there is
another cool way to use the YaST NFS module: opening the Expert
Partitioner!

{% include blog_img.md alt=""
  src="s92-04-nfs-300x201.png" full_img="s92-04-nfs.png" %}

The Expert Partitioner offers a NFS section on the left menu tree where
you can do everything that the NFS module provides. Thanks to that, you
can configure your NFS shares at the same time you format your
partitions!

But that integration needed some improvements after we migrated YaST to
the new Storage Stack (a.k.a. storage-ng). Moreover, some bugs were
detected when using the NFS module for mounting and unmounting shares,
see for example [bsc#1006815][5] and [bsc#1151426][6].

All those bugs were fixed, ww the NFS module behaves as expected in both
cases, when running in standalone mode and inside the Expert
Partitioner. Note that now the current status of the existing shares is
preserved. That is, an unmounted share will continue unmounted after
editing it. Unmounted entries are indicated with an asterisk in the list
of shares, similar to what the Expert Partitioner does for the rest of
unmounted devices. All these improvements will be available for SUSE
Linux Enterprise SP1, openSUSE Leap 15.1 and openSUSE Tumbleweed.

{% include blog_img.md alt=""
  src="s92-05-nfs2-300x210.png" full_img="s92-05-nfs2.png" %}

### Installation Progress Improvements   {#installation-progress-improvements}

We got some bug reports about how installation progress reporting works
and while we were touching it, we also added a few smaller improvements
to the code.

The first change is that nowadays installing from multiple discs almost
never happens but still there was always a “**Medium 1**” column which
did not make much sense. So we removed the column and if there is a
multi-media source, it will be appended to the name if needed.

The second visible change is a new Unicode character ⌛ (**hourglass**)
during the initial phase of RPM installation until the remaining time
can be estimated.

The third change is that now the maximum time is always capped at 2
hours, so even if there are multiple sources and some of them took more
then two hours, it always show just “**&gt;2:00:00**” and even in total
it is capped, so it can no longer show something like “&gt;6:00:00”.

The fourth one is that now you can read the **release notes** without
disturbances. Previously you would get switched to the package log tab
after each package finished its installation. Now it will redraw only
when you go back from the release notes screen.

The fifth one is a fix for showing the **remaining packages**, where it
is shown only for the active source and not for all. So now it shows
remaining packages for all repositories.

And last but not least we do a bunch of refactoring, code quality
improvements and also adding automatic unit tests to reduce regressions
in the future.

Tumbleweed before and now:

{% include blog_img.md alt=""
  src="s92-06-inst1-300x225.png" full_img="s92-06-inst1.png" %}

{% include blog_img.md alt=""
  src="s92-07-inst2-300x225.png" full_img="s92-07-inst2.png" %}

SLE before and now:

{% include blog_img.md alt=""
  src="s92-08-inst3-300x225.png" full_img="s92-08-inst3.png" %}

{% include blog_img.md alt=""
  src="s92-09-inst4-300x225.png" full_img="s92-09-inst4.png" %}

and new ncurses:
{% include blog_img.md alt=""
  src="s92-10-inst5-300x225.png" full_img="s92-10-inst5.png" %}

### Doomsday Preparations: Retracted Packages   {#doomsday-preparations-retracted-packages}

If a maintenance update is released for any of our supported products,
it may happen that after its release we realize that it introduces new
problems, so we have to unpublish (retract) it.

So far, our maintenance team always managed to find other solutions, but
sooner or later it will happen that it takes too long to realize that an
update was broken, so users will install it.

For that purpose we introduced a new status *retracted* for patches and
packages. We hope that we will never need it, but if we do, we need it
in a hurry — until a better, fixed version of those packages is
released.

We added new filters “Retracted Packages” and “Retracted Installed
Packages” to the package selection, and the affected versions are
colored in red and get a **\[RETRACTED\]** marker in the “Versions” tab:

{% include blog_img.md alt=""
  src="s92-11-retr-300x171.png" full_img="s92-11-retr.png" %}

Those lists should always be empty. Also, retracted versions will never
automatically be installed. If package versions are retracted, but are
already installed, the “Retracted Installed Packages” view will be
opened automatically when starting the package selection to make you
aware of them. Then you can choose to manually downgrade to a previous
version or to wait until a fixed version is available.

In general, don’t worry: We never needed this so far, and we hope that
we will never need it. Still, we take precautions for the worst case.

More details: [PR 82][7]

### Qt Package Selection Gets Faster   {#qt-package-selection-gets-faster}

This came as a byproduct of the previous item: While working on the new
filter views for retracted packages, we found that it could take a long
time (10-20 seconds) when switching away from the “All Packages” view,
so we started digging deeper to find out why.

We found it strange that *clearing* the package list on the right side
of that dialog was so slow; considerably slower than *filling* it with
all packages. After some investigations, we found that in the course of
all those changes for all those Qt versions (since Qt 3.x in mid-2006)
some internal housekeeping for those list items was now no longer
necessary because later Qt versions took over more and more of those
responsibilities, and our own housekeeping now got in the way of that
and was considerably slowing it down.

Once we found the cause, the fix was easy: We threw out our own
housekeeping code and are now relying on what the Qt widget does, and
hey presto, clearing that list now happens instantly instead of taking
10-20 seconds.

More details: [PR 82 (“Other Fixes”)][7]

[1]: https://github.com/yast/yast-storage-ng/pull/1024
[2]: https://github.com/libyui
[3]: https://github.com/yast/yast-ycp-ui-bindings/blob/master/examples/Table-sort-key.rb
[4]: https://en.wikipedia.org/wiki/Network_File_System
[5]: https://bugzilla.suse.com/show_bug.cgi?id=1006815
[6]: https://bugzilla.suse.com/show_bug.cgi?id=1151426
[7]: https://github.com/libyui/libyui-qt-pkg/pull/82

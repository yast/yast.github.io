---
layout: post
date: 2017-06-16 14:50:43.000000000 +02:00
title: Highlights of YaST development sprint 36
description: We are still digesting all the great content and conversations from
  openSUSE Conference 2017, but the development machine never stops, so here we are
  with the report of our post-conference sprint.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

### Storage reimplementation: expert partitioner

You have been reading for months about the new stack for managing
storage devices and the new features and improvements it will bring to
the installation. But so far there was no way to view and fine-tune the
details of those devices. During this sprint we have implemented a first
prototype of the new version of the YaST2 Expert Partitioner, that
awesome tool you can invoke with `yast2 storage`.

To make the transition easier and to be able to submit it to Tumbleweed
as soon as possible (hopefully in a couple of months, together with the
rest of the new stack) we decided to postpone any UI redesign. So this
first incarnation of the new expert partitioner looks and behaves
exactly like the one available in current versions of (open)SUSE.

To try it out (on a scratch machine!), add a repository and remove the
current storage library, as described in [yast-storage-ng: Trying on
Running System][2] and then run `zypper install yast2-partitioner`. As
you may have noticed, we split the partitioner in a separate package,
unlike the current version that was part of the basic `yast2-storage`.

The new expert partitioner will only give you a read-only view of things
similar to the following screenshots, not being able to modify anything
yet.

{% include blog_img.md alt="New expert partitioner - hard disks list"
src="expert1-300x215.png" full_img="expert1.png" %}

As you can see in your own system or in the screenshots, the following
items are already functional

* Hard disks and their partitions
* Volume Groups, Logical Volumes, and Physical Volumes of the Logical
  Volume Manager (LVM)

The other kinds of devices that you can see in the navigation tree are
so far only stubs.

{% include blog_img.md alt="New Expert Partitioner - logical volume overview"
src="expert2-300x233.png" full_img="expert2.png" %}

You may feel a bit underwhelmed by this, and that’s OK, because most of
the effort that we spent on this is actually hidden in a set of nice UI
classes which we use to reconstruct the legacy procedural UI code. So
the new expert partitioner not only relies on the revamped storage
stack, but also on a powerful and reusable set of shiny UI components.
If you ever need to code a user interface for YaST, the next section is
for you.

{% include blog_img.md alt="New Expert Partitioner - list of physical volumes"
src="expert3-300x232.png" full_img="expert3.png" %}

### New CWM Widgets

This section may be a little bit too developer-oriented, so feel free to
skip it if you don’t care about the YaST implementation details. If, to
the contrary, you want to have a glance at the new YaST widgets, go
ahead.

Before diving into the new widgets, let us introduce what [CWM][3] is.
It stands for Common Widget Manipulation and it is an old procedural
YaST module which puts together a widget, its help and its callbacks.
These callbacks are used to initialize, validate and store the content
of the widget. This organization allows easier re-usability of widgets,
which are then put together into a dialog. We also made an
object-oriented version of CWM, which uses the old one under the hood,
but is based on classes. So the contents and callbacks all live in their
own class which is then used in dialogs. It is already used e.g. in the
[bootloader module][4].

As part of the Expert Partitioner rewrite, we created new types of
reusable widgets, like [`Table`][5] or [`Tree`][6], that are now
available for its usage in any YaST module.

We also realized that it would be cool to be able to construct full
dialogs out of smaller “bricks”, because the partitioner dialogs usually
have rather complex structures in which some parts are shared by several
dialogs. For this purpose we added new kinds of widgets – a [`Page`][7]
which represents a part of a dialog that contains other widgets, and a
[`Pager`][8] which allows switching of pages. So far there are two
different pagers. The first one is [`Tabs`][9] which shows a set of tabs
and allows switching among them and the second one is [`TreePager`][10]
which allows switching pages according the item selected in a tree.

As you can see in the screenshots from the Expert Partitioner, there is
a tree on the left side, which decides which page is shown on the right
side. That right side sometimes contains a set of tabs, which decides
what is displayed for every single tab.

Building blocks for the win!

### Added support for allocation of memory high into YaST Kdump Command-line

A new option to allocate memory high during enable of Kdump was already
implemented in YaST interface but unavailable through command-line. From
the next Service Pack (i.e. SLES 12 SP3, Leap 42.3, and Tumbleweed), the
user will be able also to use this option in command-line and scripts.
In order to do that you can just use the command `yast2 kdump enable
alloc_mem=low,high`, where `low` sets Kdump Low Memory and `high` sets
Kdump High Memory.

For current users of Kdump command line, the old command to enable kdump
`yast2 kdump enable alloc_mem=$mem` will still work as before, keeping
its compatibility.

### Handle optional filesystem packages correctly

During installation, when YaST detects in the system a particular
filesystem or technology for which the installer would need additional
packages to deal with, it alerts the user and tries to install those
packages. A very visible case are the `ntfs-3g` and `ntfsprogs`
packages, installed when a MS Windows partition is found in the system.

But, what happens if those packages are simply not available for
installation? That’s the case of SLE12-SP3, which doesn’t include
`ntfs-3g`. Should the installer block the installation of SLE12-SP3
alongside an existing MS Windows just because of that?

Fortunately we have solved that problem for the upcoming SLE12-SP3… and
also created the code infrastructure to avoid similar problems in the
future. Now we have a separate list for packages that would be nice to
have installed in order to deal with a particular technology but that
are not 100% mandatory to the point of blocking the installation process
if they are not available. So we don’t bother the user about things that
cannot be solved anyway.

### Issues solved in YaST Remote command-line

But apart from looking into the future, we keep taking care of the
existing YaST modules and its supported scenarios. During this sprint,
we also addressed some issues related to YaST Remote, when using the
command line.

The command `yast2 remote list` was installing required packages for
YaST Remote and also restarting the display manager. However, as this
command is expected to be a read-only operation, it shouldn’t change
anything in the system. Such a problem was solved and now this command
just lists the status of remote options.

Another issue was in the command `yast2 remote allow=yes`, which was
opening a pop-up interface to alert the user about the changes in the
system. Such a pop-up was impeding the use of this command in scripts.
Therefore, we removed it when executing YaST Remote in command-line and,
instead, we now just show a warning message on the console.

Both fixes were submitted as a maintenance update to all the supported
versions of SLE and openSUSE and will reach our user as soon as they
pass all the extra security checks performed by the respective
maintenance teams. Of course, both fixes will also be included in future
releases.

### Storage reimplementation: simplified actions summary

The Expert Partitioner was not the only thing we did related to the new
storage stack during this sprint. We also tried to improve how the
information is presented to the user everywhere.

Having a huge amount of information at a glance might be useful in
certain cases… as long as that amount can be handled by a human brain!
Since we don’t expect all our users to be androids, we decided to
improve our storage actions summary. Now is much easier to understand
what is going to happen in the disks after pressing the confirmation
button.

They say a picture is worth a thousand words. So let’s compare the
ultra-detailed list offered before this sprint…

{% include blog_img.md alt="Summarized actions: before"
src="compound1-300x225.png" full_img="compound1.png" %}

…with the new digested one.

{% include blog_img.md alt="Summarized actions: after"
src="compound2-300x225.png" full_img="compound2.png" %}

As you can see, the new summary carries the essential information in a
clear and legible way. Delete actions are highlighted in bold and,
moreover, the set of actions related to btrfs subvolumes are grouped in
a collapsible list.

{% include blog_img.md alt="Summarized actions: extended view"
src="compound3-300x225.png" full_img="compound3.png" %}

Integration of AutoYaST with the new storage has also received our
attention during this sprint. Now, the summary dialog in AutoYaST shows
the list of storage actions in the new compact way. Currently it is not
possible to edit partitions from this AutoYaST dialog, but stay tuned
for more information in upcoming sprints.

{% include blog_img.md alt="Summarized actions: AutoYaST"
src="compound4-300x225.png" full_img="compound4.png" %}

### AutoYaST: warn the user when creating smaller partitions

You already know how powerful can AutoYaST be in terms of automating
complex installations based on flexible profiles, even trying its best
if the profile contains parts that are challenging to implement in the
target system.

One of those adjustments that AutoYaST can perform is reducing the size
of some of the partitions specified in the provided profile if the
target disk is not big enough, to make sure the installation doesn’t get
blocked just by some missing space.

The mechanism works very well but that kind of automatic adjustments can
be unexpected and can produce undesired results. That’s why we have
added the following warning message.

{% include blog_img.md alt="AutoYaST: alert user about adjusted partititions"
src="autoyast-warning-300x188.jpeg" full_img="autoyast-warning.jpeg" %}

Of course, this new warning uses the usual AutoYaST reporting
mechanisms, so even if the users are not in front of the screen
(something very common when performing an unattended installation) they
will be notified about the special circumstance.

### Docker, Docker everywhere!

And now, another dose of technical content for those of you that love to
lurk into the kitchen.

In the [report of the sprint 30][11] we already described how we adopted
Docker to power up our continuous integration process in the master
branch of our repositories (the one in which we develop Tumbleweed and
upcoming products). As [also reported][12], we adopted the same solution
for Libyui in the next sprint. And now it was the turn the branches of
YaST that we use to maintain already released version of our products.
Not a trivial task taking into account the many repositories YaST is
divided in and the many products we provide maintenance for.

If you want to refresh your memory about the whole topic of using Docker
for the continuous integration infrastructure, here you can watch the
talk Ladislav offered about the topic a few days ago in the openSUSE
Conference 2017.

<iframe width="500" height="281"
src="https://www.youtube.com/embed/U1hwQJ4F8gM?feature=oembed"
frameborder="0" allowfullscreen=""></iframe>

### Storage reimplementation: full support for DASD devices

If you don’t have a S/390 mainframe laying around, maybe you are not
familiar with the concept of [DASD][13] (direct-access storage devices).
DASDs are used in mainframe basically as regular disks… just that they
are not.

DASDs are special disks in various aspects – they have a different
partition table type allowing only three partitions with a restricted
set of partition ids, they must be managed by a different set of
partitioning tools, they have their own specific alignment logic and
requirements…

But thanks to YaST and libstorage, in (open)SUSE you don’t have to care
about most of those details. The expert partitioner and the installer
allow you to treat DASDs almost as regular disks.

During this sprint we adjusted the new `libstorage`, i.e. the library
C++ based layer of the stack, to be able to deal with DASD. As usual
with new features implemented in the library, the only “screenshot” we
have to show is one of the graphs generated by the library. Enjoy.

{% include blog_img.md alt="DASD support: the example graph"
src="dasd-225x300.png" full_img="dasd.png" %}

### More to come… very soon

We want to have a shorter and more agile feedback loop regarding our
development efforts. To achieve that, we have decided to shorten our
Scrum sprints from the current three weeks to just two. So you will have
more news from us in half a month.

But a feedback loop works in both ways, so we also expect to have more
news from you. :smiley: See you soon!



[1]: https://events.opensuse.org/conference/oSC17
[2]: https://github.com/yast/yast-storage-ng#trying-on-running-system
[3]: http://www.rubydoc.info/github/yast/yast-yast2/file/library/cwm/doc/CWM.md
[4]: https://github.com/yast/yast-bootloader/blob/master/src/lib/bootloader/grub2_widgets.rb
[5]: http://www.rubydoc.info/github/yast/yast-yast2/CWM/Table
[6]: http://www.rubydoc.info/github/yast/yast-yast2/CWM/Tree
[7]: http://www.rubydoc.info/github/yast/yast-yast2/CWM/Page
[8]: http://www.rubydoc.info/github/yast/yast-yast2/CWM/Pager
[9]: http://www.rubydoc.info/github/yast/yast-yast2/CWM/Tabs
[10]: http://www.rubydoc.info/github/yast/yast-yast2/CWM/TreePager
[11]: {{ site.baseurl }}{% post_url 2017-02-03-highlights-of-yast-development-sprint-30 %}
[12]: {{ site.baseurl }}{% post_url 2017-02-20-highlights-of-yast-development-sprint-31 %}
[13]: https://en.wikipedia.org/wiki/Direct-access_storage_device

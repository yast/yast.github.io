---
layout: post
date: 2017-07-03 11:31:39.000000000 +00:00
title: Highlights of YaST development sprint 37
description: Since we announced in the latest report, we decided to shorten our development
  sprints from three to only two weeks. As a natural consequence, this is the first
  report of a series of shorter ones. But shorter doesn&#8217;t have to mean less
  juicy! Keep reading and enjoy.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

### Displaying very long changelog

We got a [bug report][1] about YaST not responding when a very long
package changelog was displaying in the package manager. It turned out
that some packages have a huge change log history with several thousands
entries (almost 5000 for the `kernel-default` package). That produces a
very long table which takes long time to parse and display in the UI.

The solution is to limit the maximum number of displayed items in the
UI. You cannot easily read that very long text anyway, for such a long
text you would need some search functionality which the YaST UI does not
provide.

Finding the limit, that magic number, was not easy as we want to be
backward compatible and display as much as possible but still avoid that
pathological cases with a huge list.

In the end we decided to go for a limit of 512 change entries. The vast
majority of packages have way fewer entries, so you should not notice
this clipping functionality. When the limit is reached a command to
display the full log is displayed at the end so you can easily see the
missing part when needed. (Hint: the widget supports the usual
copy&amp;paste functionality, you can copy (with `Ctrl`+`C`) the
displayed command and paste it into a terminal window directly.)

{% include blog_img.md alt="Clipping the kernel changelog"
src="changelog.png" %}

### Storage reimplementation: MD RAID support in the rewritten partitioner

In the previous report we told you we are rewriting the YaST partitioner
to use the new storage stack and modern reusable CWM widgets under the
hood while retaining exactly the same behavior and look&amp;feel on the
surface. We are reimplementing one feature at a time, and this sprint it
was the MD RAID’s turn.

Now the partitioner displays current RAIDs, with details about them and
the devices used to construct each RAID. If a picture is worth a
thousand words, here you have 3,000 words:

{% include blog_img.md alt="RAID list in the rewritten partitioner"
src="raid2-300x234.png" full_img="raid2.png" %}

{% include blog_img.md alt="Devices in a given RAID in the rewritten partitioner"
src="raid1-300x233.png" full_img="raid1.png" %}

{% include blog_img.md alt="RAID details in the rewritten partitioner"
src="raid3-300x233.png" full_img="raid3.png" %}

### No, you can’t have a separate partition for /var/lib/docker for CaaSP – so here you have it

Our brand new containers-oriented solutions, SUSE CaaSP and its openSUSE
counterpart Kubic, need to have `/var/lib/docker` as a separate
partition for several reasons. It was a separate Btrfs subvolume
already, but that wasn\'t quite separate enough. :smiley:

The problem was just that the automated storage proposal in the old YaST
storage subsystem is not prepared for anything like this; it can deal
with root, swap and optionally a separate home partition (or volume if
using LVM). That\'s it. Extending the current syntax of the
`control.xml` file to be able to specify arbitrary partitions and
adapting the code of the old proposal to understand and handle this new
specification was unfortunately almost impossible. Sadly, we have to
admit the old code is hardly maintainable these days and not flexible
enough to accommodate this kind of changes in a safe way.

This is one (out of many) reasons why we are currently in the process of
rewriting that entire YaST storage subsystem, as you already know from
many previous posts in this blog. But, as you also know, the new system
will debut in SLES15 and openSUSE Leap 15.0, too late for the current
SUSE CaaSP and openSUSE Kubic.

We decided we\'d introduce a hack based in the old proposal, well
knowing that hacks accumulated in code can develop their own life just
like [Dust Puppy][2]. But we plan to kill that hack immediately once
StorageNG arrives.

So the hack was to simply use the logic for the separate home partition
and repurpose it, keeping all the respective parameters in `control.xml`
and introducing yet another one called `home_path` where the actual
mount point for that partition can be specified — in this case
`/var/lib/docker`. The tradeoff is that there can be no separate `/home`
anymore in parallel to that.

That \"feature\" should not be used outside of that very specific use
case in CaaSP and we even considered the possibility of not documenting
it too publicly to avoid misuse. But we are living the open source
spirit and whatever we do, we do in public. Even if it\'s the (quite
embarrassing) fact that we consider changes to certain parts of our own
code too risky. But again, that\'s why we are pushing the storage layer
reimplementation (Storage-NG) so hard: we want to regain control over
that part.

### Storage reimplementation: custom partitioning with AutoYaST

And talking about the new storage layer and our previous posts, you
already know we are working hard to integrate it with AutoYaST. For the
time being, custom partitioning layouts are supported, but only using
plain partitions and LVM. Other features, like RAID or Btrfs subvolumes
support, are still missing.

A nice thing about the new code is that it relies as much as possible on
the new storage layer. On older versions, AutoYaST implemented some
logic on its own and that caused some unexpected troubles. Fortunately,
that is not the case anymore, and the new code looks way easier to
extend and maintain.

{% include blog_img.md alt="AutoYaST custom partitioning"
src="autoyast-300x225.png" full_img="autoyast.png" %}

### YaST does not write directly in `/etc/vconsole.conf` anymore

When configuring the system keyboard, YaST used to write the keyboard
map configuration directly in the `/etc/vconsole.conf` file. However,
this approach is no longer appropriated since it may cause undesired
effects to other tools. Now YaST uses the Systemd tool `localectl` to
set the keyboard map in `/etc/vconsole.conf`, instead of writing in it
directly. Another step to make YaST a good citizen of the Systemd world.

### Storage reimplementation: named RAID arrays

If you use MD RAID arrays you probably know there are two ways of
identifying them – by number or assigning a meaningful name to them.
Named arrays use device names like `/dev/md/<name>` instead of
`/dev/md<number>`.

During this sprint, we taught the new libstorage how to create and
manage named RAID array, in addition to the already supported numbered
ones. If the user decides so, the MD RAID name is used in fstab instead
of the UUID (which was the only option with the old libstorage). We also
made sure to improve the behavior in several scenarios, so we consider
some bugs of the old storage to be fixed (or obsoleted, if you prefer)
with storage-ng.

Linux also supports names of the form `/dev/md_<name>`. The new library
is also able to handle this format, but the feature is intentionally
disabled and documented to be unsupported because other parts of the
system could not be 100% verified to work in that scenario. And we take
quality assurance very seriously before labeling a feature as
“supported”.

If you are not happy enough with the screenshots showing the RAID
support in the partitioner, here you have more pictures. But, as usual
with stuff implemented in the library, here “pictures” doesn’t mean
screenshots, but fancy automatically generated graphs.

{% include blog_img.md alt="Named MD RAID"
src="named-md-300x289.png" full_img="named-md.png" %}

### Stay tuned

Of course there are a lot of other things we did during the last two
weeks, although some of them were considered not interesting enough for
this report or were not finished on time. We are already working in
finishing the unfinished stuff and implementing new exciting
improvements. And the bright side is that you only have to wait two
weeks to know more… so stay tuned.



[1]: https://bugzilla.suse.com/show_bug.cgi?id=1044777
[2]: http://www.userfriendly.org/cartoons/dustpuppy/

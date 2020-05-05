---
layout: post
date: 2020-05-05 12:00:00 +00:00
title: Highlights of YaST Development Sprint 98
description: It's time for another report from the YaST trenches. This time with links
  to other interesting reads and with several calls to action.
category: SCRUM
permalink: blog/2020-05-05/sprint-98
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It's time for another report from the YaST trenches. This time, apart from this
blog post, we have several other reads for you in case you are interested on
YaST development or on Linux technical details in general.

Today topics include:

  * Some considerations about the usage of YaST
  * A sneak peek at the future of AutoYaST, including a separate full blog post
  * Some kind of UI design contest for the YaST Partitioner
  * Better compatibility with LVM cache
  * Interesting researchs about combining disks and about Unicode support for
    VFAT in Linux
  * An impressive speedup of the partitioning proposal for SUSE Manager
  * A summary of the enhancements for YaST and related projects in Leap 15.2

And what is even better, many of those topics include a call to action for our
loyal users and contributors.

## Looking towards the future {#branching}

Let's start with a technical but rather significant detail. During our latest
sprint we created a new `SLE-15-SP2` branch in the YaST Git repositories,
meaning that now the `master` branch is open again for more innovative
features.

{% include blog_img.md alt="Git branching"
src="branching-300x75.png" full_img="branching.png" %}

This is an important milestone from the development point of view, since it
marks the point in which the team acknowledges 15.2 to be basically done and
manifests the intention to focus in the mid and long term future. All the
previous blog posts have been focused on describing features and fixes that will
be present in the upcoming SUSE Enterprise Linux 15 SP2 and openSUSE Leap 15.2.
From now on, you will read more about changes that go into openSUSE Tumbleweed
and Leap 15.3 (also SLE-15-SP3, of course).

## Getting some insights about the usage of YaST {#usage}

In order to take decisions for the future, we would like to know how often the
YaST modules are used and which ones are the most important for the users. But
that is not easy because YaST does not collect any data, the only feedback we
get are bug reports and feature requests.

During this sprint we tried to gather some data by collecting the bug and
feature numbers from the change logs. We have not yet analyzed that data but it
seems the more features we implement the more bug reports we get. :smiley:
See [this
gist](https://gist.github.com/lslezak/ed9d54b91dc3cdec865ce289d01ac0c2) for the
details and feel free to suggest any other system we could use to analyze the
relevance of the different YaST modules and components.

## Modernizing AutoYaST {#autoyast}

Something we know for sure is that AutoYaST is critical for many users of
SUSE Linux Enterprise and openSUSE. And, to be honest, our venerable unattended
installer is showing its age. That's why AutoYaST has a priority place in the
mid-term goals of the YaST Team. The plan is to have an improved AutoYaST for
SLE 15 SP3 and openSUSE Leap 15.3, although some fixes could be backported to
SP2 and 15.2 if they are important enough.

During this sprint, we started gathering some feedback from our users and
colleagues at SUSE. Additionally, we did some research about the current status
of AutoYaST in order to identify those areas that are in need of more love.
We have put all the conclusions together as a [separate blog
post]({{site.baseurl}}/blog/2020-04-30/modernizing-autoyast). Check it if you
are interested in what the future will bring for AutoYaST.

Now that we have started a new development sprint, there is an ongoing
discussion that might be interesting for you about AutoYaST tooling. Please,
check [yast-devel](https://lists.opensuse.org/yast-devel/2020-04/msg00060.html),
[opensuse-autoinstall](https://lists.opensuse.org/opensuse-autoinstall/2020-04/msg00001.html),
or the
[opensuse-factory](https://lists.opensuse.org/opensuse-factory/2020-04/msg00402.html)
mailing lists and do not hesitate to participate. We would love to hear from
you.

## Expert Partioner: Leap 15.3 and Beyond {#partitioner}

If you are not an AutoYaST user, don't worry. There is still other area in which
your input will be greatly appreciated by the YaST team. The interface of the
YaST Partitioner has reached a point in which is really hard to deal with it and
we need to find a way to move forward.

{% include blog_img.md alt="The YaST Partitioner"
src="partitioner-300x177.png" full_img="partitioner.png" %}

As a first step, we have created [this
document](https://github.com/yast/yast-storage-ng/blob/master/doc/partitioner_ui.md)
that explains the problem and we hope it can be used as a base to discuss the
future of the Partitioner interface.

This is a very important topic for the future of YaST. All ideas are
welcome. Feel free to join [the mail
thread](https://lists.opensuse.org/yast-devel/2020-04/msg00062.html), to create
pull requests for the document, to discuss the topic at the `#yast` IRC channel
at Freenode... whatever works for you.

## Recognizing LVM Cache {#lvm-cache}

We also decided this was the right time to introduce some relatively big changes
in libstorage-ng (the library used by YaST to manage storage devices) aimed to
improve the compatibility of YaST with some advanced LVM features.

For more than a year YaST has supported to setup and use bcache to speed up
rotating disks by using a SSD as a cache. But that is not the only technology
that can be used for that purpose. Some users prefer to use LVM cache instead of
bcache since it has been around for a longer period of time and it offers some
different features.

YaST cannot be used to setup an LVM cache system and we don't plan to make that
possible. Moreover, booting from LVM cache does not work in SLE or openSUSE as
of this writing. But giving the user the freedom of choice has always been
important for (open)SUSE and YaST.

To help customers using LVM cache, YaST can now recognize such setup and display
it properly in the Expert Partitioner and many other parts of YaST. The
following warning will not be longer displayed for LVM cache volumes in
openSUSE Tumbleweed.

{% include blog_img.md alt="Old pop-up for LVM cache"
src="old-lvm-cache-popup-300x248.png" full_img="old-lvm-cache-popup.png" %}

Instead, it will be possible to use those logical volumes normally for
operations like mounting, formatting, etc. The ability to modify them will
still be very restricted and it will not be possible to create new LVM cache
volumes.

We plan to offer a similar limited level of support for other kind of advanced
LVM volumes. Stay tuned for more news on this.

## VFAT filesystem and Unicode {#vfat}

And talking about storage technologies, we also introduced a small change in the
management of VFAT file systems for future releases of SLE and Leap (after
15.2). For some time we have wanted to stop using `iocharset=utf8` in favor of
`utf8` when mounting a VFAT filesystem, as this is the recommendation in the
[kernel documentation](https://www.kernel.org/doc/Documentation/filesystems/vfat.txt).

There was also [this bug](https://bugzilla.suse.com/show_bug.cgi?id=1080731)
that led to avoiding `iocharset=utf8` for EFI system partitions (because
`iocharset=utf8`implies that filenames are case-sensitive).

We took the opportunity to do some experiments and even look at the source code
of the Linux kernel to find out what's really going on. Why is utf8 so special
and what can go wrong?

If you ever wondered what these VFAT charset related options mean and whether
VFAT filenames are really case-insensitive in Linux as they are in Windows, have
a look at [this
document](https://github.com/yast/yast-storage-ng/blob/master/doc/vfat-notes.md)
we have created.

Although SLE-15-SP2 and openSUSE Leap 15.2 will still use the traditional mount
options, the new approach (`utf8` for all VFAT file systems) will land in
Tumbleweed in a matter of days, as usual.

And, since we were already in research mode regarding storage technologies, why to
stop there?

## Mixing block sizes in multi-device devices {#block-sizes}

As a result of a recent bug in libstorage-ng which was tracked down to a RAID
device block size issue the YaST team spent some time researching the topic in
general.

If you've ever wondered what happens when you combine disks with different block
sizes into a RAID, LVM, BCACHE, or BTRFS, have a look at our
[document](https://github.com/openSUSE/libstorage-ng/blob/master/doc/blocksizes.md).

In most cases, YaST (and libstorage-ng) already manages the situation well
enough. But we found that in some cases we will need special handling of some
situations, specially to guide our users so they don't slip through the
pitfalls. But that's another story... for upcoming development sprints.

## Fastest Partitioning Proposal for SUSE Manager {#suma}

But not all changes and improvements done during this sprint are targeting the
mid and long term. We also had time to introduce some improvements in the
upcoming SLE 15 SP2. To be precise, in the corresponding version of
[SUSE Manager](https://www.suse.com/products/suse-manager/), the SUSE’s
purpose-specific distribution to manage software-defined infrastructures.

Quite some time ago, we wrote [this separate blog
post]({{site.baseurl}}/blog/2019/07/16/suse-manager-and-the-partitioning-guided-setup/)
to introduce some special features of the partitioning Guided Setup we have
developed to allow SUSE Manager (and other products) to offer the users an
experience tailored to their needs.

{% include blog_img.md alt="SUSE Manager Guided Setup"
src="suma-300x215.png" full_img="suma.png" %}

But we knew some of those features in our partitioning proposal had serious
performance problems that affected the initial proposal, that is, the one the
installer creates before the user has had any chance of to influence the result
or to select the disks to use.

The SUSE Manager version for SLE 15 SP2 will finally introduce two system roles
that use the new proposal (both indentified by the "multiple disk" label), so it
was finally time to address those performance problems.

And we really improved the situation! If you want to know more, [this pull
request](https://github.com/yast/yast-storage-ng/pull/1083) contains many
details and the result of some benchmarks. Let's simply say here that in some
worst-case scenarios we managed to reduced the time needed to calculate the
initial proposal... from several hours to half a second!

## Summarizing what Leap 15.2 will bring {#marketing}

As our usual readers have had many opportunities to attest, the life of a
YaST developer goes much further than simply coding. And with every openSUSE
Leap release it's time for us to take a look back to several months of work
and, with our salesman hat on, summarize all the cool additions to YaST and its
related projects.

In that regard, we have been helping the openSUSE marketing team to shape the
release announcement for openSUSE Leap 15.2. You will have to wait to read such
document in all its glory, but meanwhile you can check what we have added to the
"Snapper", "YaST" and "AutoYaST" sections of the [Leap 15.2 Features
Page](https://en.opensuse.org/Features_15.2). It's a wiki, so feel free to add
any important point we could have missed.

## To Infinity and Beyond {#conclusion}

A lot of interesting topics open up in front of the YaST Team. So it's time for
us to go back to the daily work. Meanwhile, enjoy all the reads and don't
hesitate to get involved taking part in the converstions, improving the wiki
pages or in any other way.

Have a lot of fun!

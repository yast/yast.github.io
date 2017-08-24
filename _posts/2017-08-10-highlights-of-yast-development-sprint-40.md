---
layout: post
date: 2017-08-10 16:04:34.000000000 +02:00
title: Highlights of YaST development sprint 40
description: Doubtlessly, these are pretty exciting times for the YaST team. The merge
  of the new storage layer into the main codebase is around the corner and we are
  working on other features that will debut on the next open(SUSE) major release.
  So let&#8217;s summarize what happened during the last sprint.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- Usability
- YaST
---

### New storage layer is coming

As you may already know, the YaST team has invested a lot of time and
effort preparing our storage layer for the future and we have started to
merge the new layer into the main code base during the current sprint.
But that’s something for our next report, right? By now, we will just
focus on the stuff that got added and fixed during the last two weeks.

### Storage reimplementation: BIOS RAID support

`libstorage-ng`, the low level library in which our new storage layer
relies on, got support for BIOS RAID (handled in Linux via MD devices).
Now, YaST could take advantage of such a feature to allow the
installation of open(SUSE) systems on this kind of devices, including
the bootloader.

{% include blog_img.md alt="BIOS RAID support"
src="libstorage-ng-md-support-300x290.png" full_img=".png" %}

[![](../../../../images/2017-08-10/.png)](../../../../images/2017-08-10/libstorage-ng-md-support.png)

### Storage reimplementation: managing BtrFS subvolumes in new Expert Partitioner

The new Expert Partitioner is getting a lot of attention these days and,
during sprint 40, it got initial support for Btrfs subvolumes
management.

{% include blog_img.md alt="Btrfs subvolumes list"
src="expert-partitioner-btrfs-subvolumes-list-300x225.png"
full_img="expert-partitioner-btrfs-subvolumes-list.png" %}


Now, when you select the BtrFS section in the general menu placed on the
left, all BtrFS filesystems are presented allowing you to edit its
subvolumes through a dialog which contains the list of subvolumes that
belongs to the filesystem. Apart from the usual stuff, like adding and
deleting subvolumes, it is also possible to set the noCoW property when
you are creating a new one.

{% include blog_img.md alt="Adding/Removing Btrfs subvolumes"
src="expert-partitioner-adding-btrfs-subvolumes-300x225.png"
full_img="expert-partitioner-adding-btrfs-subvolumes.png" %}

However, some features are still missing. For instance the partitioner
will not prevent you to create a subvolume which is shadowed by an
already existing mount point. Consider the current implementation as the
first step towards a really cool Btrfs subvolume handling.

### Dropping SUSE tags support

During installation, YaST uses a mechanism known as *SUSE tags* as
source of information for media handling. For instance, a `/content`
file contains information about the product, languages, etc.
Additionally, information like release notes or the slide-show texts are
stored in the installation media.

Some time ago, SUSE decided to drop SUSE tags and use [RPM metadata][1]
and packages to store all that information. To make it possible, the
installation media would use REPOMD repositories.

Obviously, YaST needs some adaptation. As a first step, support for the
`/content` has been dropped, cleaning up some old and even unused code.

In the upcoming sprints, YaST will be adapted to retrieve licensing,
release notes, etc. from RPM repositories and packages, which is also an
opportunity to do some refactoring and to improve test coverage.

### AutoYaST support for add-on products on same installation media

Nowadays YaST supports having add-on products on the same media than the
base product. The problem is that the EULA for those products is
displayed too early, even before AutoYaST had been initialized at all.

To solve this issue, now the EULA acceptance of included add-ons is
performed at the same time than other add-ons which are not included in
the installation media. As a side effect, now the user needs to define
those add-ons on the AutoYaST profile in order to handle the EULA
acceptance.

### Bug squashing and 80×24 terminals

As developers, we enjoy working on new features and, of course, we are
committed to fix critical bugs as fast as possible. But there are many
small (and annoying) bugs out there that deserve our attention.
Additionally, there are several bug reports that are no longer valid
(the bug was fixed, it is not reproducible, it is a duplicate, the
affected product is not supported anymore, etc.). In order to reduce the
list of open issues, the team decided some sprints ago to reserve one
day to do some bug squashing.

Among the bugs we closed during this sprint, we would like to highlight
a usability problem in YaST services manager. Bear in mind that, along
with the graphical interface, YaST ships a text based one which is
supposed to fit in good old-fashioned 80×24 terminals. That’s an
interesting constraint when you are designing interfaces for YaST.

Needlessly to say that, from time to time, we get a bug report about
some element that just do not fit. In this case, YaST services manager
had a problem when the service name was too long as you can see in the
screenshot below.

{% include blog_img.md alt="Too long service name"
src="yast-services-manager-out-of-space-300x170.png"
full_img="yast-services-manager-out-of-space.png" %}

Now, if there is not enough space, the name will be truncated and the
rest of the information will be shown in an proper way.

{% include blog_img.md alt="Truncating a too long service name"
src="yast-services-manager-properly-truncated-300x171.png"
full_img="yast-services-manager-properly-truncated.png" %}


### Do not miss the next report!

As you may have noticed, a lot of interesting things are currently
happening in the YaST world and more cool stuff is about to come. So you
should not miss our next sprint report.

By now, enjoy openSUSE 42.3 (you already upgraded your system, right?)
and see you in two weeks.



[1]: https://en.opensuse.org/openSUSE:Standards_Rpm_Metadata

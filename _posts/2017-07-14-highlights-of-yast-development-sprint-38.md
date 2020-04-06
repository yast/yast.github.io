---
layout: post
date: 2017-07-14 12:13:17.000000000 +02:00
title: Highlights of YaST development sprint 38
description: 'Here we go again with a new report from the YaST trenches. This time
  with the storage reimplementation as the clear star of the show.'
category: SCRUM
tags:
- Desktop
- Distribution
- Factory
- Packaging
- Programming
- Software Management
- Systems Management
- YaST
---

### Storage reimplementation: the proposal adapts, you succeed

As we have announced in our previous sprints and as you probably already
know, the YaST team is working hard to rewrite the whole storage stack
on time for SLE15 and openSUSE Leap 15. As part of this reimplementation
we have designed a brand new storage proposal that automagically offers
the user the best combination of partitions and LVM volumes based on the
current configuration of the system and the user preferences.

{% include blog_img.md alt="The storage proposal in action"
src="proposal-300x225.png" full_img="proposal.png" %}

When we are working with very small disks or with special technologies
like DASD (which doesn’t accept more than three partitions by device),
the storage proposal might not be able to generate a valid initial
proposal honoring the initial requirements of the product (e.g. creating
a separate home partition and enabling btrfs snapshots for the root
partition in the openSUSE Leap case). Now the proposal is not limited to
fail when it is not possible to satisfy the default product
requirements. Before giving up, the new system looks for alternatives,
like discarding the separate home partition or disabling snapshots.
Moreover, now the proposal is able to automatically adjust the size
requirements not only for root, but also for swap and home. And, of
course, the guided setup continues there for fine tuning the proposal
settings.

### Desktop selection improvements

As our usual readers also know, we recently introduced a more fair
desktop selection screen for openSUSE, both Leap 42.3 and Tumbleweed. We
used part of the latest sprint to implement some feedback we gathered
about the wording and behavior of that dialog.

{% include blog_img.md alt="Revamped desktop selection screen"
src="desktop-selection-300x225.png" full_img="desktop-selection.png" %}

That feedback gathering included some discussions on how to make user
experience nicer after selecting one of the user interfaces available
through the “custom” option. As a result, the awesome openSUSE crew
created a new mechanism for selecting the default window manager on each
graphical login, so YaST can delegate the details to the maintainers of
those alternative interfaces.

How everything works now? Glad you asked. :smiley:

If the user select KDE or GNOME in the YaST dialog,
`/etc/sysconfig/windowmanager` is configured to point to that desktop by
default. If the “custom” option is selected, then YaST does not enforce
any interface in that file and the new mechanism comes into play. It
relies in the `default.desktop` file, which defines the default window
manager and can be managed by the common `update-alternatives` workflow.
Meaning it can be easily tweaked by the package maintainers and by the
users, specially since YaST includes a nice module for managing
alternatives.

### Storage reimplementation: improvements in the expert partitioner

Although, as explained above, we keep improving the storage automatic
proposal to support more and more situations, we cannot ignore that
flexibility and adaptability have always been two of the flagships of
(open)SUSE. And one of the most prominent examples is the YaST Expert
Partitioner.

As detailed in [our report of the sprint 36][1], we have been rewriting
that powerful Swiss Army knife using the new storage stack but keeping
the same user interface and functionality. So far, the new
implementation was only able to display information about the existing
partitions, LVM systems and MD RAIDs. But now we added many options to
create, edit and delete partitions.

{% include blog_img.md alt="Using the expert partitioner during installation"
src="expert-partitioner-inst-300x225.png" full_img="expert-partitioner-inst.png" %}

It is still a work in progress because the number of possibilities
offered by the YaST Partitioner is sometimes overwhelming and
implementing them all takes time, but it’s progressing nicely.

Beside the improvements in the Partitioner itself, we also worked on its
integration in the installation workflow. Now the Expert Partitioner can
be used to refine the schema automatically proposed by the installer. As
a bonus, the behavior of the “abort” and “finish” buttons has been
improved in relation to the Expert Partitioner currently available in
(open)SUSE, which historically shows a usability inconsistency there
compared to the rest of the installation process.

<video preload="metadata" controls="controls">
  <source type="video/webm" src="/assets/images/blog/{{ page.date | date: "%Y-%m-%d" }}/expert_partitioner_next.webm">
</video>

### Fixed Automatic Patch Installation

In both SLE and openSUSE Leap, the online updates can be installed
either manually or automatically at some regular intervals. For the
automatic installation we provide the
`yast2-online-update-configuration` package which provides a cron job
script and an YaST module for configuring it (hint: it is not installed
by default, you might give it a try, maybe it is something “new” for
you).

{% include blog_img.md alt="Configuring online updates via YaST"
src="yast-online-update-300x242.png" full_img="yast-online-update.png" %}

You can configure how often the patches should be installed or filter
the patch categories in the YaST module, but we got a bug report saying
that when multiple patch categories are selected only one is actually
used.

It turned out to be a trivial mistake in the cron job and we fixed it
for SLE12-SP2 and Leap 42.2, as well as for the upcoming SLE12-SP3 and
Leap 42.3. So if you use this module and want to use the category filter
then it’s recommended to upgrade the package.

### Storage reimplementation: many steps forward in the AutoYaST integration

And going back to our new storage stack, we keep working to integrate it
better with other parts of YaST, specially AutoYaST. During this sprint
we polished some rough edges and we added support for MD RAID. With all
that, now is possible to automatically setup a system based on an
AutoYaST profile containing any combination of partitions, LVM systems
and MD arrays, including encryption at any of the levels.

{% include blog_img.md alt="AutoYaST summary of actions on partitions, MD RAID
and LVM" src="autoyast-raid-lvm-300x216.png" full_img="autoyast-raid-lvm.png" %}

But the relation of AutoYaST with the system works in both directions.
Apart from being able to install a system based on an AutoYaST profile,
it also offers the interface to export the current system configuration,
including the storage layout, to a profile in order to reproduce the
system later. During this sprint we also ported that logic to rely on
the new storage layer.

It was harder than it sounds, due to the need of keeping the
backwards-compatibility with several behaviors that have been introduced
along the AutoYaST history to adapt to several specific situations. On
the bright side, the new code is easier to follow, includes
behavior-driven automated tests (RSpec) and contains information about
the rationale of each decision… which in some cases required some
archaeology.

### Storage reimplementation: fixed bootloader proposal in S/390 and PowerPC

Another part of YaST we are constantly working to integrate better with
the new storage stack is `yast2-bootloader`. Although the new storage
system was already able to correctly setup a valid disk layout for most
situations and architectures (each one with it’s own requirements for
booting), our bootloader module is still not fully compatible with the
new system in all those scenarios.

During this sprint, we adapted it to ensure all the combinations
suggested by the new storage stack (partitions, LVM, encryption and so
on) are correctly covered by YaST2-Bootloader. As a result, we can
already say that our testing ISO images are fully installable in any
x86\_64, PowerPC and S/390 system by just clicking “next” a few times.
And we have automated integration tests (a separate openQA instance) to
ensure the resulting system boots just fine.

### UDEV device id on PowerPC

We know some of our readers enjoy our more technical posts and like to
lurk into the kitchen to see how we deal with all kind of surprises
maintaining a complex tool like YaST. Today’s chapter in that regard
started with a bug report about the bootloader being installed in the
wrong device name (`/dev/vda` instead of `/dev/vdb`) in an emulated
PowerPC machine in openQA.

After a lot of investigation and with help from our PowerPC expert, we
found the culprit, that turned out to be an emulator quirk. The next
couple of paragraphs may be interesting or daunting, depending how much
virtualization and PowerPC jargon you know. Be warned.

On POWER, the PReP partition containing the bootloader has no unique
identifier other than the serial number of the disk on which it created.
QEMU virtualization does not provide any disk serial number when the
user does not explicitly specify one. This means that the PReP partition
in QEMU installation does not have any unique identification and the
partition name may change when a disk is added or removed from the
virtual machine or the storage configuration otherwise changes. This may
lead to system errors related to bootloader installation and updates.

It is recommended to assign a unique serial number to each disk in a
QEMU virtual machine on POWER when it is expected the storage
configuration of the virtual machine may change. Otherwise, there is
nothing YaST or any other tool running within the virtual machine can do
to avoid the problems. So this time we only did the investigation part,
with the fix coming from the openQA side, which was improved to
explicitly set serial numbers when needed.

### Storage reimplementation: better support for advanced scenarios

As exposed above, our StorageNG testing image already works in all the
supported architectures and in scenarios combining plain partitions,
LVM, RAID and encryption in any way. But there are even more situations
and technologies currently supported by YaST that we need to incorporate
into the new stack.

First of all, we used this sprint to add [Multipath I/O][2] support to
the new libstorage. Now it can also be combined with all the other
mentioned technologies (like having an LVM system on top of an encrypted
multipath device), although the storage proposal still needs to be
adapted to play nicely with preexisting multipath setups.

As usual with the library stuff, the best “screenshot” we have to offer
is one of its geeky autogenerated graphs.

{% include blog_img.md alt="A multipath layout in libstorage-ng"
src="multipath-300x140.png" full_img="multipath.png" %}

Another scenario that goes beyond the most regular use cases is
installing the system into a network storage device, instead of a local
hard disk. Now, the new storage system can report whether a root
filesystem via a network is used. When that happens, YaST sets the
network interfaces with the start mode `nfsroot`, which is used to avoid
interface shutdown and, therefore, the unavailability of the system.

### That’s all, folks!

Once again, we omitted the boring parts about bugfixing (with
`yast2-ntp-client` being the star in that regard) and similar stuff. We
hope you enjoyed the report and we hope to reach you again in two weeks.
Meanwhile…

Have a lot of fun testing the Leap 42.3 pre-releases and reporting bugs!



[1]: {{ site.baseurl }}{% post_url 2017-06-16-highlights-of-yast-development-sprint-36 %}
[2]: https://en.wikipedia.org/wiki/Multipath_I/O

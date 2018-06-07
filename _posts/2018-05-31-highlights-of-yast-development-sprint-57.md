---
layout: post
date: 2018-05-31 13:02:21.000000000 +00:00
title: Highlights of YaST Development Sprint 57
description: Three weeks from our last update on this blog. Time flies when you are
  busy! As you know, openSUSE Leap 15.0 was released in the meantime, which also means
  the active development of SLE15 is coming to an end&#8230; so time to look a little
  bit further into the future.
category: SCRUM
tags:
- Distribution
- Events
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

That’s why we had a face-to-face workshop with the whole YaST Team at
the beautiful city of Prague during several days right before joining
the [openSUSE Conference 2018][1].

But we have done much more in three weeks than attending workshops and
conferences. Apart from last-minute fixes, here you have a list of some
interesting changes we have done in YaST in this period. Take into
account that some of these changes didn’t make it into Leap 15.0,
although all will be available in SLES15 and are probably already
integrated into openSUSE Tumbleweed.

### Fine tuning installer behavior in small disks

As you may know, the default installation of SLE and both openSUSE
distribution enables Btrfs snapshots in the root partition alongside
separate partitions for `/home` and swap. That means a default
installation needs quite some space. In SLE12 and openSUSE Leap 42.X, if
such disk space was not there the installer silently tries to disable
the separate `/home` and even the snapshots in order to be able to
create an initial proposal.

That behavior has become configurable for each product and role with
Storage-ng and during the last sprint there was some controversy about
what the configuration should be, both for openSUSE and the SLE family.
It may look like a minor problem, but it becomes very relevant in
virtualization environment (where virtual disks smaller than 10 GiB are
not uncommon) or certain architectures with special storage devices like
s390 and ARM.

The final decision was to never disable snapshots automatically in the
case of openSUSE, so the user will be forced to manually go through the
Guided Setup and explicitly disable snapshots to install in a small
disk. In the SLE case, it was decided to keep the traditional behavior
(automatically disabling snapshots if really needed) but making the
situation more visible by adding a previous sentence to explain how the
initial proposal was calculated.

So the installation in a normal disk would look like this.

{% include blog_img.md alt="Default initial partitioning proposal"
src="default-300x197.png" full_img="default.png" %}

While the installation in a very small disk displays some information
similar to the following screen (the wording was slightly improved after
taking the screenshots).

{% include blog_img.md alt="Adjusted initial partitioning proposal"
src="minimal-300x192.png" full_img="minimal.png" %}

The explanatory text preceding the list of actions will be available in
all products based on SLE15, but will not be there for Leap 15.0, since
the modification to the installer was not ready on time for the deadline
and, moreover, would have been impossible to get the translations on
time.

By the way, if you are interested in a more in-depth explanation on how
the partitioning proposal adapts to all kind of situations like small
disks and other scenarios, don’t hesitate to check Iván’s presentation
at openSUSE Conference 2018 detailing its internals.

<iframe width="500" height="281"
src="https://www.youtube.com/embed/_0VKUjFAIwo?feature=oembed"
frameborder="0" allow="autoplay; encrypted-media"
allowfullscreen=""></iframe>

### More parameter passing for s390

And talking about uncommon scenarios and the s390 architecture, you may
remember that in the latest sprint we improved the handling of the
persistent network device names kernel parameter for such systems.
Shortly after, we found out a similar improvement was needed also for
the FIPS parameter.

FIPS is a military encryption standard in USA. If the installation is
started using the corresponding parameter, YaST will enforce strong
encryption and will install an specific FIPS pattern. Moreover, after
the recent fix, a system installed in hardened mode s390 will continue
operating in this mode after the installation.

### Fun with MD RAIDs

As SLE15 comes closer, future users start testing the system with more
exotic and complex hardware setups. Same applies to openSUSE Leap 15.0
right after the official release. As a result of all that testing, we
found several scenarios in which Storage-ng got confused about MD RAIDs
defined by some specific hardware or manually by the user before
starting the installation.

By default, the old storage didn’t handle partitions within software
RAIDs and it didn’t handle software RAIDs directly on top of full disks
(with no partitions in the physical disks). For the first version of
Storage-ng present in Leap 15.0 and SLE15, we tried to implement the
same behavior with the intention to rethink the whole thing and open new
possibilities in the close future. Check more about the present and
future of Storage-ng in Ancor’s talk at openSUSE Conference 2018.

<iframe width="500" height="281"
src="https://www.youtube.com/embed/etsT3xP52Zs?feature=oembed"
frameborder="0" allow="autoplay; encrypted-media"
allowfullscreen=""></iframe>

Unfortunately, while trying to replicate the old storage behavior with
software-defined MD RAIDs, we overlooked some heuristic that was hidden
in the old implementation to recognize some special setups in which a
given RAID device currently detected as regular software-defined RAIDs
should be treated like hardware RAIDs. That’s the case of Software RAID
Virtual Disks defined on a S130/S140 controller on DellEMC PowerEdge
Servers through the BIOS Interface. We also found that some users used
to produce a similar situation by manually creating software MD RAIDs
and creating partitions within them before starting the installation.

With the preparation of SLE15 already in the final stages and with
openSUSE Leap 15 already out, it was too late to introduce drastic
changes in how MD RAIDs are detected and used. To mitigate the problem
while limiting the potential breakage, we reintroduced an ancient
installer parameter. Now, when we run the installer using
`LIBSTORAGE_MDPART=1`, all existing software-defined RAIDs will be
considered as BIOS RAIDs.

{% include blog_img.md alt="Using LIBSTORAGE\_MDPART"
src="raid-300x225.png" full_img="raid.png" %}

The new parameter is not available in Leap 15.0 (we added it too late)
and will hopefully not be necessary anymore in future versions of SLE
and openSUSE, since the short term plan is to redesign everything about
how MD RAIDs are handled during installation.

### And even more fun with MD RAIDs

Another example of RAID that looks like defined by software but is
indeed assembled by BIOS is the Intel RSTe technology. In this case, the
usage of `LIBSTORAGE_MDPART` is not needed, but still we found the
bootloader installation to be broken because YaST was once again getting
confused by the mixed RAID setup.

Fortunately it was possible to fix the issue and verify the solution in
only two days, despite the YaST Team not having direct access to the
hardware, thanks to the outstanding help of the user reporting the bug.
Connecting users and developers directly always produces great results…
and that’s one of the reasons open source rocks so much!

### Improved error reporting for wrong bootloader in AutoYaST

That was not the only improvement in the bootloader handling done during
this sprint. We also invested some time improving the user experience in
AutoYAST, since the error message displayed when using an EFI variant
not supported in the system architecture was far from being useful or
even informative.

So alongside a more clear message, AutoYaST will now list all the
possible values supported on the given architecture to better guide the
user.

{% include blog_img.md alt="More precise bootloader error in AutoYaST"
src="bootloader-300x227.png" full_img="bootloader.png" %}

### Setting the default subvolume name in AutoYaST

AutoYaST also received improvements in other areas, like making use of
the new possibilities offered by Storage-ng. The new storage layer
allows the user to set different default subvolumes (or none at all) for
every Btrfs file system. As shown in the example below, a prefix name
can be specified for each partition using the `subvolumes_prefix`.

```xml
<partition>
  <mount>/</mount>
  <filesystem config:type="symbol">btrfs</filesystem>
  <size>max</size>
  <subvolumes_prefix>@</subvolumes_prefix>
</partition>
```

To omit the subvolume prefix, set the `subvolumes_prefix` tag:

```xml    
<partition>
  <mount>/</mount>
  <filesystem config:type="symbol">btrfs</filesystem>
  <size>max</size>
  <subvolumes_prefix><![CDATA[]]></subvolumes_prefix>
</partition>
```

As a consequence of the new behaviour, the old
`btrfs_set_default_subvolume_name` tag is not needed and, therefore, it
is not supported in Leap 15.0 and SLE15.

### Skipping Btrfs subvolume creation

And more changes in AutoYaST that arrived just in time for SLE15 and
openSUSE Leap 15.0. Recently, we have introduced a new flag in AutoYaST
partition sections to skip the creation of Btrfs subvolumes because, due
to a known limitation of our XML parser, it is not possible to specify
an empty list.

So from now on, setting `create_subvolumes` to `false` will prevent
AutoYaST from creating any Btrfs subvolumes in a given partition.

```xml    
<partition>
  <mount>/</mount>
  <filesystem config:type="symbol">btrfs</filesystem>
  <size>max</size>
  <create_subvolumes config:type="boolean">false</create_subvolumes>
</partition>
```

### Keep it rolling!

As usual, the content of this post is just a small part of everything we
did during the sprint. There were also many other fixes and
improvements, from auto-repairing wrong partition tables (with different
sizes than the underlying disk) during installation to better
interaction with other components like udisk or mdadm auto-assembling
and many other things in between.

But it’s time to go back to work and start implementing all the new
ideas that emerged from the YaST Team Workshop and the openSUSE
Conference. See you in the next report!



[1]: https://events.opensuse.org/conference/oSC18

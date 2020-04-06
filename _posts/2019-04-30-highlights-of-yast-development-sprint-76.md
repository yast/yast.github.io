---
layout: post
date: 2019-04-30 09:00:20.000000000 +00:00
title: Highlights of YaST Development Sprint 76
description: 'While the openSUSE Conference 2019 is approaching, the YaST team is
  still busy not only fixing small bugs for the upcoming (open)SUSE releases but working
  on features and changes for later versions.'
category: SCRUM
tags:
- Uncategorized
---

While the [openSUSE Conference 2019][1] is approaching, the YaST team is
still busy not only fixing small bugs for the upcoming (open)SUSE
releases but working on features and changes for later versions.

Although there is much more work behind this sprint, we will have a look
at these changes in this report:

* The first bits of the YaST Network refactoring have been submitted to
  factory.
* AutoYaST gets support for specifying NFS shares in a sane way.
* The Partitioner’s tree behaviour has been improved.
* Libyui has been updated to support Qt 5.13 (do not miss the
  screenshots in this report).
* The installer does not offer enabling autologin for text-only system
  roles.

But that’s not all. We have some pretty exciting news regarding the
*LibYUI Testing Framework* which, hopefully, will reduce the hassle of
maintaining YaST openQA tests in the future. If you are interested, we
published a [separate post a few days
ago](//lizards.opensuse.org/2019/04/26/announcing-libyui-testing-framework/)
with all the details about this topic.

### Submitting First Bits of the YaST Network Refactoring to Factory   {#first-bits-of-yast-network-refactoring-submitted-into-factory}

yast2-network 4.2.2 is the first version which includes some code from
the ongoing refactoring effort. As we announced in our last report, we
have just started and there is a long road ahead of us, but you can see
some results already in the routes management area.

Additionally to cleaning up and improving the codebase quality, we are
fixing some bugs and introducing some minor enhancements along the
process. For instance, version 4.2.2 permits to have multiple default
routes and does not drop extra options for them.

{% include blog_img.md alt="New network routing dialog"
src="RoutingStandalone-300x236.png" full_img="RoutingStandalone.png" %}

If you want to know more details about the process, you might be
interested in the [kickstart meeting notes][2] that we added to our
repository a few days ago.

### Auto-installation onto NFS Shares: the Sane Way   {#auto-installation-onto-nfs-shares-the-sane-way}

During the previous sprint, AutoYaST was powered again with the
capability of installing onto an NFS share. That feature was available
in SUSE Linux Enterprise 12 (and openSUSE 42.x) but, for several
reasons, we did overlook it when the new storage stack was
re-implemented for (open)SUSE 15.

The problem with this feature in older versions, apart of not being
documented at all, is that it requires to use some hacks and a
non-validating AutoYaST profile. For that reason, we have redesigned how
NFS drives are described in the AutoYaST profile. With the new format,
we have a drive section per each NFS share, for example,

```xml
<partitioning config:type="list">
  <drive>
    <device>192.168.1.1:/exports/root_fs</device>
    <type config:type="symbol">CT_NFS</type>
    <use>all</use>
    <partitions config:type="list">
      <partition>
        <mount>/</mount>
        <fstopt>nolock</fstopt>
      </partition>
    </partitions>
  </drive>
</partitioning>
```

Although the old format is still supported to keep backward
compatibility, we encourage you to use the new one for now on. And of
course, this feature will be appropriately documented in the official
(open)SUSE 15 documentation.

### No Longer Offering Autologin for Text-Only System Roles

Autologin is a feature that most modern display managers (KDM, GDM,
SDDM, LightDM) offer as a convenience function for home users. Users
reported that YaST also provided this for the “Server (text only)”
system role where that does not make sense, so we fixed that.

### Yet Another Qt Version   {#yet-another-qt-version}

This is not actually a big deal; there is another version of the Qt libs
which we use for the graphical version of YaST. Now it’s Qt 5.13, and we
needed to adapt some functions that have become obsolete in the
meantime. Fortunately, Qt always provides drop-in replacements for
things they obsolete, so this was mostly a pretty mechanical task to go
through the warnings about functions or classes that are now obsolete
and replace them with the new counterpart.

But how long have we been doing that? Quite a while, actually; it all
started with Qt 2.x in late 1999 for SuSE Linux 6.3. That was the first
YaST2. It already came in both a Qt version with a graphical user
interface and in a text-only (NCurses) version.

{% include blog_img.md alt="SuSE Linux 6.3 Installer"
src="suse-linux-6.3-300x225.png" full_img="suse-linux-6.3.png" %}

Back then we were more advanced than the KDE of that time: KDE 1.x was
still using Qt 1.x, and the first version of YaST2 already used Qt 2.x.
We kept upgrading throughout all the Qt 2.x versions and in SuSE Linux
9.0 we jumped to Qt3, which looked like this.

{% include blog_img.md alt="SuSE Linux Professional 9.0"
src="suse-linux-professional-9.0-300x225.png" full_img="suse-linux-professional-9.0.png" %}

And as you know, that’s not the end of the story. We have kept updating
through all the Qt 3.x, Qt 4.x and now Qt 5.x versions, as you can see
in the following screenshot of the upcoming openSUSE Leap 15.1. It’s
been a while: almost 20 years of happy Qt usage, always up-to-date.

{% include blog_img.md alt="openSUSE Leap 15.1"
src="opensuse-leap-15.1-300x193.png" full_img="opensuse-leap-15.1.png" %}

### Improving the Partitioner UX   {#improving-the-partitioner-ux}

When it comes to UX, the tree of our new and shiny partitioner needed
some love. We fixed an annoying issue which caused all the branches to
be expanded after every change on any device. Besides that, we also
changed the initial view. See the screenshot below in which sections
-levels with icons like “Hard Disks” or “RAID”- are initially expanded
and items representing devices are collapsed, not displaying, for
example, the full list of partitions until the user decides to expand
those.

{% include blog_img.md alt="YaST Partitioner Screenshot"
src="partitioner-tree-300x214.png" full_img="partitioner-tree.png" %}

However, the bad news is that these changes will not be available in
(open)SUSE 15.1, although you can give it a try as soon as they land in
Tumbleweed.

### Let’s Talk about Multi-device Btrfs   {#lets-talk-about-multi-device-btrfs}

The improved behavior of the navigation tree is not the only enhancement
in the Partitioner we are preparing for the future (where “future” means
Tumbleweed and the 15.2 releases of both SLE and openSUSE Leap). We also
want to make possible to use the YaST Partitioner to define Btrfs
file-systems that spread over several disks and partitions. That’s a
pretty unique feature of Btrfs that combines at file-system level
certain characteristics usually offered by software RAID and LVM.

But that also implies a quite different way of organizing the storage
devices, which is a challenge to represent in the already complex user
interface of the Expert Partitioner. So, first of all, we have put
together [this document][3] describing all the struggles of representing
advanced Btrfs features in the Partitioner, together with some possible
solutions for the short and mid terms.

Please, feel free to provide feedback about the proposed solutions and
to offer new ones. Help us to shape the future of the YaST interface!

### Conclusions   {#conclusions}

As we mentioned at the beginning of this report, we owe you a blog post
about the *Libyui Testing Framework* status. But as you wait for it, you
might want to register for the openSUSE Conference or check the
[schedule][4].



[1]: https://events.opensuse.org/conferences/oSC19
[2]: https://github.com/yast/yast-network/blob/bb90e6c4fdf39713c69f8b46adb8b045cc7ae4c3/doc/network-ng-kickstart.md
[3]: https://github.com/yast/yast-storage-ng/blob/master/doc/btrfs_in_partitioner.md
[4]: https://events.opensuse.org/conferences/oSC19/schedule

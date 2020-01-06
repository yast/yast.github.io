---
layout: post
date: 2019-10-09 13:43:53.000000000 +00:00
title: Highlights of YaST Development Sprint 86
description: Now that you had a chance to look at our post about Advanced Encryption
  Options (especially if you are an s390 user), it is time to check what happened
  during the last YaST development sprint...
category: SCRUM
tags:
- etc
- storage
---

## Introduction

Now that you had a chance to look at [our post about Advanced Encryption
Options][1] (especially if you are an s390 user), it is time to check
what happened during the last YaST development sprint, which finished
last Monday.

As usual, we have been working in a wide range of topics which include:

* Improving support for multi-device file systems in the expert
  partitioner.
* Fixing networking, secure boot and kdump problems in AutoYaST.
* Stop waiting for `chrony` during initial boot when it does not make
  sense.
* Preparing to support the split of configuration files between
  `/usr/etc` and `/etc`.
* Using `/etc/sysctl.d` to write YaST related settings instead of the
  `/etc/sysctl.conf` main file.

### Expert Partitioner and Multi-Device File Systems

So far, the Expert Partitioner was assuming that Btrfs was the only file
system built on top multiple devices. But that is not completely true
because some file systems are able to use an external journal to
accomplish a better performance. For example, *Ext3/4* and *XFS* can be
configured to use separate devices for data and the journaling stuff.

We received a [bug report][2] caused by this misunderstanding about
multi-device file systems. The Expert Partitioner was labeling as “Part
of Btrfs” a device used as an external journal of an *Ext4* file system.
So we have improved this during the last sprint, and now external
journal devices are correctly indicated in the *Type* column of the
Expert Partitioner, as shown in the screenshot below.

{% include blog_img.md alt="External Journal Type"
src="yast2-storage-ng-type-for-external-journal-devices-300x225.png" full_img="yast2-storage-ng-type-for-external-journal-devices.png" %}

Moreover, the file system information now indicates which device is
being used for the external journal.

{% include blog_img.md alt="External Journal Device Details"
src="yast2-storage-ng-external-journal-device-details-300x225.png" full_img="yast2-storage-ng-external-journal-device-details.png" %}

And finally, we have also limited the usage of such devices belonging to
a multi-device Btrfs. Now, you will get an error message if you try to
edit one of those devices. In the future, we will extend this feature to
make possible to modify file systems using an external journal from the
Expert Partitioner.

### AutoYaST Getting Some Love

During this sprint, we have given AutoYaST some attention in different
areas: networking, bootloader and kdump.

About the networking area, we have finished s390 support in the new
network layer, fixing some old limitations in devices activation and
udev handling. Apart from that, we have fixed several bugs and improved
the documentation a lot, as we found it to be rather incomplete.

Another important change was adding support to disable secure boot for
UEFI through AutoYaST. Of course, we updated the documentation too and,
during the process, we added some elements that were missing and removed
others that are not needed anymore.

Finally, we fixed a tricky problem when trying to get kdump to work on a
minimal system. After some debugging, we found out that AutoYaST adds
too late `kdump` to the list of packages to install. This issue has been
fixed and now it should work like a charm.

As you may have seen, apart from writing code, we try to contribute to
the documentation so our users have a good source of information. If you
are curious, apart from the documents for released [SUSE][3] and
[openSUSE][4] versions, you can check the [latest builds][5] (including
the [AutoYaST handbook][6]). Kudos to our documentation team for such an
awesome work!

### Avoiding `chrony-wait` time out

Recently, some openSUSE users reported a really annoying issue in
Tumbleweed. When time synchronization is enabled through YaST, the
system might get stuck during the booting process if no network
connection is available.

The problem is that, apart from the `chrony` service, YaST was enabling
the `chrony-wait` service too. This service is used to ensure that the
time is properly set before continuing with other services that can be
affected by a time shift. But without a network connection,
`chrony-wait` will wait for around 10 minutes. Unacceptable.

The discussion about the proper fix for this bug is still open, but for
the time being, we have applied a workaround in YaST to enable
`chrony-wait` only for those products that require precise time, like
openSUSE Kubic. In the rest of cases, systems will boot faster even
without network, although some service might be affected by a time
shift.

### Splitting Configuration Files between `/etc` and `/usr/etc`

As Linux users, we are all used to check for system-wide settings under
`/etc`, which contains a mix of vendor and host-specific configuration
values. This approach has worked rather well in the past, not without
some hiccups, but when things like [transactional updates][7] come into
play, the situation gets messy.

In order to solve those problems, the plan is to split configuration
files between `/etc` and `/usr/etc`. The former would contain vendor
settings while the latter would define host-specific values. Of course,
such a move have a lot of implications.

So during this sprint we tried to identify potential problems for YaST
and to propose solutions to tackle them in the future. If you are
interested in the technical details, you can read [our conclusions][8].

### Writing Sysctl Changes to `/etc/sysctl.d`

In order to be able to cope with the `/etc` and `/usr/etc` split, YaST
needs to stop writing to files like `/etc/sysctl.conf` and use an
specific file under `.d` directories (like `/etc/sysctl.d`).

So as part of the aforementioned research, we adapted several modules
(`yast2-network`, `yast2-tune`, `yast2-security` and `yast2-vpn`) to
behave this way regarding `/etc/sysctl.conf`. From now on, YaST specific
settings will be written to `/etc/sysctl.d/30-yast.conf` instead of
`/etc/sysctl.conf`. Moreover, if YaST founds any of those settings in
the general `.conf` file, it will move them to the new place.

### What’s next?

Sprint 87 is already running. Apart from fixing some bugs that were
introduced during the network refactoring, we plan to work on other
storage-related stuff like resizing support for LUKS2 or some small
snapper problems. We will give your more details in our next sprint
report.

Stay tunned!



[1]: {{ site.baseurl }}{% post_url 2019-10-09-advanced-encryption-options-land-in-the-yast-partitioner %}
[2]: https://bugzilla.suse.com/show_bug.cgi?id=1145841
[3]: https://suse.com/documentation
[4]: https://doc.opensuse.org/
[5]: https://susedoc.github.io/
[6]: https://susedoc.github.io/doc-sle/master/SLES-autoyast/html
[7]: https://en.opensuse.org/openSUSE:Packaging_for_transactional-updates
[8]: https://github.com/yast/yast-yast2/blob/2975c70ab17f1bc790c0ca3e77ff7a0d14a08266/doc/etc-and-usr-etc.md

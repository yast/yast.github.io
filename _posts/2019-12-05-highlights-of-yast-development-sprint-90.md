---
layout: post
date: 2019-12-05 14:21:25.000000000 +00:00
title: Highlights of YaST Development Sprint 90
description: As usual, during this sprint we have been working on a wide range of
  topics. The release of the next (open)SUSE versions is approaching and we need to
  pay attention to important changes.
category: SCRUM
tags:
- Base System
- Distribution
- Factory
- Systems Management
- YaST
---

## The Introduction

As usual, during this sprint we have been working on a wide range of
topics. The release of the next (open)SUSE versions is approaching and
we need to pay attention to important changes like the new installation
media or the /usr/etc and /etc split.

Although we have been working on more stuff, we would like to highlight
these topics:

* Support for the new SLE installation media.
* Proper handling of shadow suite settings.
* Mount points handling improvements.
* Help others to keep the Live Installation working.
* Proper configuration of console fonts.
* Better calculation of minimum and maximum sizes while resizing
  ext2/3/4 filesystems.
* Small fixes in the network module.

### The New Online and Full SLE Installation Media

The upcoming Service Pack 2 of SUSE Linux Enterprise products will be
released on two media types: *Online* and *Full*.

On the one hand, the *Online* medium does not contain any repository at
all. They will be added from a registration server (SCC/SMT/RMT) after
registering the selected base product. The *Online* medium is very small
and contains only the files needed for booting the system and running
the installer. On the other hand, the *Full* medium includes several
repositories containing base products and several add-ons, which can
help to save some bandwidth.

Obviously, as the installer is the same for both media types, we need to
adapt it to make it work properly in all scenarios. This is an
interesting challenge because the code is located in many YaST packages
and at different places. Keep also in mind that the same installer needs
to also work with the openSUSE Leap 15.2 product. That makes another set
of scenarios which we need to support (or at least not to break).

The basic support is already there and we are now fine-tuning the
details and corner cases, improving the user experience and so on.

### Proper Handling of Shadow Suite Settings

A few weeks ago, we anticipated that (open)SUSE would split system’s
configuration between [/usr/etc and /etc directories][1]. The former
will contain vendor settings and the latter will define host-specific
settings.

One of the first packages to be changed was `shadow`, which stores now
its default configuration in `/usr/etc/login.defs`. The problem is that
YaST was not adapted in time and it was still trying to read settings
only from `/etc/login.defs`

During this sprint, we took the opportunity to fix this behavior and,
what is more, to define a strategy to adapt the handling of other files
in the future. In this case, YaST will take into account the settings
from `/usr/etc` directory and it will write its changes to a dedicated
`/etc/login.defs.d/70-yast.conf` file.

### Missing Console Font Settings

The YaST team got a nice present this year (long before Christmas)
thanks to [Joaquín][2], who made an awesome [contribution][3] to the
YaST project by refactoring the keyboard management module. Thanks a
lot, Joaquín!

We owe all of you a blog entry explaining the details but, for the time
being, let’s say that now the module plays nicely with systemd.

After merging those changes, our QA team detected that the console font
settings were not being applied correctly. Did you ever think about the
importance of having the right font in the console? The problem was that
the [SCR agent][4] responsible for writing the [configuration file for
the virtual consoles][5] was removed. Fortunately, bringing back the
deleted agent was enough to fix the problem, so your console will work
fine again.

### Helping the Live Installation to Survive

Years ago, the YaST Team stopped supporting installation from the
openSUSE live versions due to maintainability reasons. That has not
stopped others from trying to keep the possibility open. Instead of
fixing the old `LiveInstallation` mode of the installer, they have been
adapting the live versions of openSUSE to include the regular installer
and to be able to work with it.

Sometimes that reveals hidden bugs in the installer that nobody had
noticed because they do not really affect the supported standard
installation procedures. In this case, YaST was not always marking for
installation in the target system all the packages needed by the storage
stack. For example, the user could have decided to use Btrfs and still
the installer would not automatically select to install the
corresponding `btrfsprogs` package.

It happened because YaST was checking which packages were already
installed and skipping them. That check makes sense when YaST is running
in an already installed system and is harmless when performed in the
standard installation media. But it was tricky in the live media. Now
the check is skipped where it does not make sense and the live
installation works reasonably well again.

### A More Robust YaST Bootloader

In order to perform any operation, the bootloader module of YaST first
needs to inspect the disk layout of the system to determine which
devices allocate the more relevant mount points like `/boot` or the root
filesystem. The usage of Btrfs, with all its exclusive features like
subvolumes and snapshots, has expanded the possibilities about how a
Linux system can look in that regard. Sometimes, that meant YaST
Bootloader was not able to clearly identify the root file system and it
just crashed.

{% include blog_img.md alt="&quot;Missing \'/\' mount point&quot; error"
src="missing-root-mount-point-error-300x222.png" full_img="missing-root-mount-point-error.png" %}

Fortunately, those scenarios are reduced now to the very minimum thanks
to all the adaptations and fixes introduced during this sprint regarding
[mount points detection](#improving-detection-of-mount-points). But
there is still a possibility in extreme cases like unfinished rollback
procedures or very unusual subvolumes organization.

So, in addition to the mentioned improvements in `yast2-storage-ng`, we
have also instructed `yast2-bootloader` to better deal with those
unusual Btrfs scenarios, so it will find its way to the root file
system, even if it’s tricky. That means the “missing ‘/’ mount point”
errors should be gone for good.

But in case we overlooked something and there is still an open door to
reach the same situation again in the future, we also have improved YaST
to display an explanation and quit instead of crashing. Although we have
done our best to ensure this blog entry will be the only chance for our
users to see this new error pop-up.

{% include blog_img.md alt="YaST2 Bootloader: root file sytem not found"
src="bootloader-root-file-system-not-found-300x223.png" full_img="bootloader-root-file-system-not-found.png" %}

### Improving the Detection of Mount Points

As mentioned above, improving the detection of mount points helped to
prevent some problems that were affecting `yast2-bootloader`. However,
that is not the only module that benefits from such changes.

When you run some clients like the *Expert Partitioner*, they
automatically use the *libstorage-ng* library to discover all your
storage devices. During that phase, *libstorage-ng* tries to find the
mount points for all the file systems by inspecting `/etc/fstab` and
`/proc/mounts` files. Normally, a file system is mounted only once,
either at boot time or manually by the user. For the first case, both
files `/etc/fstab` and `/proc/mounts` would contain an entry for the
file system, for example:

```
$ cat /etc/fstab
/dev/sda1  /  ext4  defaults  0  0

$ cat /proc/mounts
/dev/sda1 / ext4 rw,relatime 0 0
```

In the example above, *libstorage-ng* associates the `/` mount point to
the file system which is placed on the partition `/dev/sda1`. But, what
happens when the user bind-mounts a directory? In such a situation,
`/proc/mounts` would contain two entries for the same device:


```
$ mound /tmp/foo /mnt -o bind
$ cat /proc/mounts
/dev/sda1 / ext4 rw,relatime 0 0
/dev/sda1 /mnt ext4 rw,relatime 0 0
```

In the *Expert Partitioner*, that file system will appear as mounted at
`/mnt` instead of `/`. So it will look like if your system did not have
the root file system after all!

This issue was solved by improving the heuristic for associating mount
points to the devices. Now, the `/etc/fstab` mount point is assigned to
the device if that mount point also appears in the `/proc/mounts` file.
That means, if a device is included in the `/etc/fstab` and the device
is still mounted at that location, the `/etc/fstab` mount point takes
precedence.

As a bonus, and also related to mount points handling, now the *Expert
Partitioner* is able to detect the situation where, after performing a
snapshot-based rollback, the system has not been rebooted. As a result,
it will display a nice and informative message to the user.

{% include blog_img.md alt="System not rebooted after snapshot rollback"
src="not-rebooted-after-rollback-300x225.png" full_img="not-rebooted-after-rollback.png" %}

### Improved Calculation of Minimum and Maximum Sizes for ext2/3/4

If you want to resize a filesystem using YaST, it needs to find out the
minimum and maximum sizes for the given filesystem. Until now, the
estimation for ext2/3/4 was based on the `statvfs` system call and it
[did not work well at all][6].

Recently, we have improved YaST to use the value reported by `resize2fs`
as the minimum size which is more precise. Additionally, YaST checks now
the block size and whether the 64bit feature is on to calculate the
maximum size.

### Polishing the Network Module

As part of our recent network module refactorization, we have improved
the workflow of wireless devices configuration, among other UI changes.
Usually, these changes are controversial and, as a consequence, we
received a few bug reports about some missing steps that are actually
not needed anymore. However, checking those bugs allowed us to find some
small UI glitches, like a problem with the *Authentication Mode* widget.

Moreover, we have used this sprint to drop the support for some
deprecated device types, like Token Ring or FDDI. Below you can see how
bad the device type selection looks now. But fear not! We are aware and
we will give it some love during the next sprint.

{% include blog_img.md alt="Network Device Type Selection"
src="network-device-type-selection-300x173.png" full_img="network-device-type-selection.png" %}

### Conclusions

The last sprint of the year is already in progress. This time, we are
still polishing our storage and network stacks, improving the migration
procedure, and fixing several miscelaneous issues. We will give you all
the details in two weeks through our next sprint report. Until then,
have a lot of fun!



[1]: {{ site.baseurl }}{% post_url 2019-10-09-highlights-of-yast-development-sprint-86 %}#splitting-configuration-files-between-etc-and-usretc
[2]: https://github.com/jyeray
[3]: https://github.com/yast/yast-country/pulls?q=is%3Apr+is%3Aclosed+author%3Ajyeray
[4]: https://github.com/yast/yast.github.io/blob/master/doc/architecture.md#system-configuration-repository-scr
[5]: https://www.freedesktop.org/software/systemd/man/vconsole.conf.html
[6]: https://bugzilla.suse.com/show_bug.cgi?id=1149148

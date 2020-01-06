---
layout: post
date: 2019-12-18 10:35:55.000000000 +00:00
title: Highlights of YaST Development Sprint 91
description: The last two weeks of the year, and also the first one of the new year,
  are vacation season in many parts of the world and YaSTland is not an exception.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

## The Introduction

The last two weeks of the year, and also the first one of the new year,
are vacation season in many parts of the world and YaSTland is not an
exception. But before we enter hibernation mode, let’s take a look to
the most important features and bugfixes we implemented in the last
sprint of 2019. That includes:

* bringing back to life some sections of the Software Manager,
* implementing system upgrade with the new SLE media types,
* making the installation in Raspberry Pi and IBM Z System even better,
* improving usability of encryption,
* reducing the footprint of the Snapper plugin for ZYpp,
* as always, many other small improvements and fixes.

### Restored Some Package Views: Recommended, Suggested, etc.

Let’s start with a redemption story. Some time ago we implemented
feature [fate#326485][1] which requested dropping the “Package Groups”
view from the package manager UI. That was quite an easy task.

However, a few weeks later we got a bug report that the lists of
recommended, suggested, etc… packages couldn’t be displayed anymore. It
turned out that, in the Qt package manager front-end, the removed
“Package Groups” view not only used to display the static group data
from the packages but it also contained some special computed package
lists like orphaned, suggested or recommended packages. So these lists
were lost as a collateral damage of removing the “Package Groups” view.

The ncurses package manager was not affected by the same problem
because, in that front-end, those views are grouped in a separate
“Package Classification” section. So the task for this sprint was to
somehow revive the lists in Qt and make them again available to the
users.

We partly reverted the Package Groups removal and restored displaying
those special package groups. To make it consistent we also use the
“Package Classification” name for the view, like in the ncurses package
manager.

{% include blog_img.md alt="The new Package Classification view in Qt"
src="packages-qt-300x188.png" full_img="packages-qt.png" %}

On the other hand, the ncurses front-end was missing some lists like the
“Multiversion Packages” and “All Packages”. To take consistency another
step further, we added these missing lists and did some small cleanup
and fixes so now both the Qt and the ncurses package managers should
offer the same functionality and should look similar.

{% include blog_img.md alt="The revamped Package Classification view in ncurses"
src="packages-ncurses-300x197.png" full_img="packages-ncurses.png" %}

### User-friendly Encryption Device Names

And talking about bug reports that trigger some usability revamp, some
users had pointed that, when the system is booting and prompts for the
password of an encrypted device, it’s not always that easy to identify
which exact device it is referring to:

{% include blog_img.md alt="Booting password prompt before the
change" src="prompt-udev-1.png" %}

The root of the problem is that when YaST creates an encryption device
(during the installation by means of the storage proposal, or manually
with the Expert Partitioner), the device mapper name for the new
encrypted device is generated from the udev id of the underlying device
(e.g., *cr\_ccw-0XAF5E-part2*).

We decided to improve the encryption naming generation in YaST for
Tumbleweed and future releases of Leap and SLE. From now on, the name
will be based on the mount point of the device. For example, if an
encrypted device is going to be mounted at root, its device mapper name
would be *cr\_root*. In general, when the encrypted device is mounted,
the device mapper name would be *cr\_mount\_point* (e.g.,
*cr\_home\_linux* for an encrypted device mounted at */home/linux*).

{% include blog_img.md alt="Booting password prompt after the
change" src="prompt-mountpoint-1.png" %}

Note that udev-based names might still be used for some scenarios. For
example, when the device is not mounted or for an indirectly used
encrypted device (e.g., an encrypted LVM Physical Volume).

And related to the identification of encryption devices, we have also
added more information about the device when the encryption devices are
activated during the installation process. Providing the password for
the correct device was very difficult because the user needed to know
the UUID of the encryption device. Now on, the activation popup also
informs about the kernel name of the underlying device, making much
easier to identify it.

{% include blog_img.md alt="New password prompt during installation"
src="luks-activation-300x225.png" full_img="luks-activation.png" %}

Because names matter… which leads us to the next topic.

### How does it Feel to Run a Mainframe?

As you may know, (open)SUSE runs in a vast range of hardware, including
powerful mainframes like the [IBM Z family][2]. One of the strengths of
our beloved distributions is that, despite the differences in hardware
and scope, the installation and usage experience is very similar in all
the supported systems.

Consistency and ease of use are good, but when you drive a luxury car
you want to see the brand’s badge on top of the hood. So in future
versions of the installer, the model of the machine will be displayed
when installing in an IBM Z system. See the right-top corner of the
following screenshot.

{% include blog_img.md alt="IBM Z Model in the installer"
src="s390-qt-300x187.png" full_img="s390-qt.png" %}

The text-based installer also has been modified to include the same
banner in a similar place.

{% include blog_img.md alt="IBM Z Model in the text-mode installer"
src="s390-curses-300x61.png" full_img="s390-curses.png" %}

But in the same way that (open)SUSE enables you to install and use Linux
in a mainframe “just like in any other computer”, we also target to do
the same in the other extreme of the hardware spectrum.

### Better Support for Raspberry Pi in the Partitioning Proposal

One year ago [we announced][3] that openSUSE Leap 15.1 and SLE-15-SP1
would be the first Linux distributions that could be installed in
Raspberry Pi devices following the standard installation procedure,
instead of deploying a Raspberry-specific pre-built image. The only
prerequisite was the existence in the target SD card (or disk) of a
partition containing the Raspberry Pi boot code.

But we are now able to go one step further for SLE-15-SP2 (and Leap
15.2). Thanks to the technologies included in those upcoming releases,
(open)SUSE will not longer need a separate partition with the boot code
in all cases. Now the installer can make a reasonable installation
proposal in all situations, even if the target storage device doesn’t
contain a booting partition in advance. See, for example, what the
installer suggests by default for installing a fully standard SLE-15-SP2
Beta1 in a 32 GiB SD card that contained initially a GPT partition table
(tip: GPT partition tables cannot be used to boot in a Raspberry Pi
device… and the installer knows it).

{% include blog_img.md alt="Installer proposal for a Raspberry Pi"
src="proposal-32gb-300x203.png" full_img="proposal-32gb.png" %}

With that, the installation of the standard SLE-15-SP2 Beta1 (the
aarch64 version, of course) in a Raspberry Pi 3 or 4 is as easy as
“next”, “next”, “next”… with the only exception of a couple of packages
that must be manually selected for installation (`raspberrypi-*` and
`u-boot-rpi3`). Hopefully, future beta images of both SLE and openSUSE
Leap 15.2 will select those packages automatically when installing in a
Pi, which will make the (open)SUSE experience in those devices basically
identical to any other computer.

### SLE Upgrade with the New Media Types

And talking about the standard installation images of the upcoming
SLE-15-SP2, we explained in [our previous blog post][4] that those
versions of SUSE Linux Enterprise (SLE) and all its associated products
will be distributed in two new kinds of media – Full and Online. The
Full Media contains many repositories and the system can be installed
without network connectivity. The Online Media is similar to the
openSUSE’s net installer, it contains no repository and it must download
everything from the network. The big difference with openSUSE is that
SLE systems need to be registered in order to have access to remote
repositories.

But apart from installation, those two new media types can also be used
to upgrade an existing system… at least after all the improvements
implemented during the latest sprint.

In the case of the Online Media, if the system is registered the upgrade
process will switch all repositories to point to their corresponding
versions at the SUSE Customer Center (SCC) and will get the new software
from there. If the system is not registered, the upgrade process is
cancelled and the user is advised to either register the system or use
the Full Media.

The Full Media can be used to upgrade any system, registered or not, but
the process is different in each case. For a non-registered system, the
repositories will be switched to the ones included in the media and the
system will be upgraded from there. For registered systems the process
is the same that with the Online Media, so the software will be fetched
from the remote repositories at the SUSE Customer Center.

Last but not least, we also made sure the process with both medias works
with an AutoYaST upgrade (yes, you can also use AutoYaST to perform an
unattended upgrade, in addition to the better known unattended
installation). For a registered system, we simplified the procedure as
much as possible and it only needs access to SCC and an empty AutoYaST
profile. For non-registered systems it is a little bit more complex
because the profile must specify which repositories from the media
should be used for the upgrade. But other than that, the process works
quite smooth.

And, of course, we used the opportunity to improve the unit test
coverage of the code and to improve the documentation, including the
profiles we used for testing.

### The Snapper Plugin for ZYpp Becomes More Compact and Future-proof

[Snapper][5] lets you make filesystem snapshots. It has a companion,
`snapper-zypp-plugin`, a plugin for [ZYpp][6] that makes snapshots
automatically during commits. See the “zypp” descriptions in this
listing:

```
# snapper list

  # | Type   |Pre # | Date                     | User | Used Space | Cleanup  | Description  | Userdata     
----+--------+------+--------------------------+------+------------+----------+--------------+-------------
  0 | single |      |                          | root |            |          | current      |              
[...]
824 | pre    |      | Tue Dec 17 10:00:27 2019 | root |  16.00 KiB | number   | zypp(zypper) | important=no
826 | post   |  824 | Tue Dec 17 10:02:19 2019 | root |  16.00 KiB | number   |              | important=no
827 | single |      | Tue Dec 17 11:00:01 2019 | root |  16.00 KiB | timeline | timeline     |             
828 | single |      | Tue Dec 17 11:00:01 2019 | root |  16.00 KiB | timeline | timeline     |             
```

To make our enterprise products supportable for a looong time, we have
rewritten this plugin to C++, starting with snapper-0.8.7. (The original
Python implementation is not dead, it is resting in old Git commits.)

As a result, [Python regular expressions][7] are no longer supported in
the `/etc/snapper/zypp.conf` file. [POSIX extended regular
expressions][8] work instead, which should work sufficiently well for
the purpose of package name matching. [Shell patterns][9]{:
rel="nofollow"} continue working unchanged.

### Happy New Year!

During the following three weeks, the YaST team will interrupt the usual
sprint-based development pace. That also means, almost for sure, that we
will not publish any blog post about the development of YaST until mid
January of 2020. So we want to take this opportunity to wish you a happy
new year full of joy and Free Software.

See you soon and make sure to start the year with a lot of fun!



[1]: https://fate.suse.com/326485
[2]: https://en.wikipedia.org/wiki/IBM_Z
[3]: {{ site.baseurl }}{% post_url 2018-12-04-highlights-of-yast-development-sprint-68 %}
[4]: {{ site.baseurl }}{% post_url 2019-12-05-highlights-of-yast-development-sprint-90 %}
[5]: http://snapper.io/
[6]: https://en.opensuse.org/Portal:Libzypp
[7]: https://www.regular-expressions.info/python.html
[8]: https://www.regular-expressions.info/posix.html
[9]: http://man7.org/linux/man-pages/man7/glob.7.html

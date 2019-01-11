---
layout: post
date: 2018-11-20 16:16:47.000000000 +00:00
title: Highlights of YaST Development Sprint 67
description: 'Time flies and another development sprint has finished for the YaST
  team.'
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Software Management
- Systems Management
- YaST
---

Time flies and another development sprint has finished for the YaST
team. During it we have focused on improving the installation process,
refining it and adding new features to unleash new possibilities. That
includes:

* More options to configure Kubic during installation.
* Several improvements in the storage proposal.
* Easing the network configuration and the usage of online repositories
  in openSUSE.
* Improving installation in text mode for CJK and other languages.
* Configuring SSH access during installation and in a running system.
* And many other small fixes here and there!
Many of these features will be already available in openSUSE Tumbleweed
during November (the sprint just finished November 16th and the
integration process usually takes some days), others will be visible for
the first time in the next SLE-15-SP1 and Leap 15.1 Alpha versions.

### New Dialogs in the openSUSE Kubic Installation

The [SUSE CaaSP][1] and the [openSUSE Kubic][2] products got a new
installation workflow some time ago. Originally they used a specific
installation workflow (a single all-in-one configuration dialog), but
the problem was that many openSUSE/SLE installation features were
missing because the installer code was completely different.

That has been changed some time ago to use the usual installation as in
standard SLE or openSUSE products. You can read the details about the
new installation workflow at the [Kubic wiki page][3].

However, the CaaSP or Kubic products required some more specific
settings depending on the selected role. During this sprint we have
added the corresponding steps to the installation.

{% include blog_img.md alt="New installation steps for openSUSE
Kubic" src="kubic.gif" %}

Currently the extra dialog only asks for the NTP server address, but
some more options can be added later.

### Improve Textmode Support for CJK and Other Languages

YaST is able to cope with many languages even when running in textmode.
When a user wants to run the installer in textmode using some specific
languages -like Chinese, Japanese or Korean-, YaST will use a special
terminal emulator called `fbiterm` which is able to display the
characters which are needed in those languages.

Now, instead of keeping two different approaches depending on the
language, YaST will try to use this special terminal emulator whenever
is possible for all text based installations. Unfortunately, there is a
small set of languages that are not properly handled by fbiterm. In
those cases, YaST will inform the user about the problem and it will
fall back to English.

{% include blog_img.md alt="YaST installing SLE-15-SP1 in Japanese"
src="japanese-300x225.png" full_img="japanese.png" %}

As a side effect of this unification, the font used during the textmode
installation has changed for all the languages that didn’t used
`fbiterm` in the past. So your SUSE or openSUSE installation may now
look slightly different.

### Storage proposal: playing nicely with Intel Rapid Start Technology

[Intel Rapid Start Technology][4] (shorted as IRST) enables systems to
quickly resume from deep sleep (e.g. if your battery runs out). It’s a
firmware-driven technology that relies on the existence of a special
partition located on a SSD (solid state device).

But our partitioning proposal (the so-called Guided Setup) was not aware
of the important role of such partition, so it sometimes proposed to
delete it in order to use the freed space for installing (open)SUSE on
top.

We have improved that and now the IRST partition will only be deleted as
a last resort, if deleting all other allowed partitions in the disk is
still not enough to make the new system fit. Moreover, an IRST partition
located in the same disk than a Windows system will only be deleted if
the user explicitly allows the storage proposal to delete that Windows
installation.

### Running the storage proposal on top of software RAIDs and USB devices

But that’s not the only improvement done in the area of the partitioning
guided setup. We have also broadened its usefulness by allowing it to be
used on top of new kinds of devices.

First of all, it’s now possible to execute the guided setup on top of a
software MD RAID. For that, the candidate RAIDs has to fulfill one of
two conditions: to contain a partition table or to be completely empty
(which includes not being formatted, encrypted or used for any other
purpose). That is not only another step to take advantage of the
relatively recent capability of YaST to partition software RAIDs (thanks
to `libstorage-ng`) but also a very natural way to support the usage of
Dell EMC PowerEdge RAID controllers S130 and S140, which offer an hybrid
solution based on software RAIDs but backed up by a firmware-driven
configuration.

{% include blog_img.md alt="Partitioning proposal on top of a software MD RAID"
src="md_raid-300x208.png" full_img="md_raid.png" %}

Almost for the same price, we decided that it was time to offer the
available USB devices as candidates for the guided setup, even when
there are also non-USB candidates. Excluding, of course, the
installation media (except when performing a network-based installation,
in that case the USB device can be reused to install the system).

As usual, these features will be soon available in openSUSE Tumbleweed,
as well as in the next stable versions of openSUSE Leap (15.1) and SUSE
Linux Enterprise (SLE-15-SP1).

### Fine-tuning the initial storage proposal

All the described changes open new possibilities for the users to decide
where to execute the storage proposal. But as our users already know,
when the installer reaches the storage proposal step for first time
(before the user has had the chance to run the Guided Setup or the
Expert Partitioner), an initial proposal is automatically calculated and
displayed. This proposal is performed without user intervention, and all
necessary information is taken from the control file of the current
product. For example, whether to create a separate home, or whether to
enable snapshots for root, etc.

[During the previous sprint][5], this initial proposal
was already improved to make an attempt over each individual disk
instead of considering all disks together. Now we have improved this
behavior to not discard the first disk so early, even if that means
getting a smaller (open)SUSE system.

For example, let’s image we have a system with a first small SSD disk of
40 GiB and a second big Hard Disk of 1 TiB, which is a relatively common
configuration for laptops. Since the first disk is too small to allocate
a system with the optimal partition sizes and a separate `/home`
partition, the installer used to switch to the second disk, in which it
could propose a root partition of the recommended size to use Btrfs
snapshots (50 GiB) and a partition for `/home` bigger than the 40GiB
specified as minimum for it in the product description.

{% include blog_img.md alt="Initial storage proposal before the latest change"
src="initial-old-300x228.png" full_img="initial-old.png" %}

Now, more attempts will be performed in the first disk before giving up
and moving to the next one. So, when the proposal is not possible with
the desired sizes and with all the optional devices enabled, it will try
to disable some optional settings and to relax the size requirements
(using the minimum sizes instead of the recommended ones). In the
following screenshot you can see the result of this adjusted initial
proposal.

{% include blog_img.md alt="Initial storage proposal after the latest change"
src="initial-new-300x222.png" full_img="initial-new.png" %}

### Tumbleweed: Add Online Repositories during Installation

We added a step in the installation workflow to enable online
repositories. This means you can now get the latest packages installed
immediately during installation instead of installing older versions
from the installation media first and later updating them to the latest
versions from the openSUSE servers.

Also, because of disk space limitations, the installation media don’t
contain all the packages that openSUSE provides and thus not all *system
roles*; some of the less frequently used desktops, for example, had not
been available in the *role selection* (formerly *desktop selection*)
dialog. With online repositories, they are now available immediately
during installation.

For details, see the corresponding [pull request][6].

### Choosing the network backend

And more changes to the installer you will be able to enjoy very soon in
openSUSE Tumbleweed and also in the upcoming openSUSE Leap 15.1. Now
it’s possible to choose the network backend, *wicked* or NetworkManager,
to be used in the final installed system from the Network proposal.

As easy as a click on a hyperlink, as you can see in the images below.

{% include blog_img.md alt="New shortcut to change the network backend"
src="using-wicked-300x169.png" full_img="using-wicked.png" %}

### Managing SSH public keys

When you want to access to a system via SSH, it is a good practice to
use public key based authentication instead of the common password-based
approach. For that reason, we have added support to handle authorized
SSH public keys in the *user and group management module*, also known as
the *users module*.

{% include blog_img.md alt="Configuring SSH in yast2-users"
src="ssh-keys.gif" %}

Additionally, you will be able to set up a public key for the root user
at installation time, something that can be especially handy for
products like the SUSE CaaS Platform.

### And it keeps moving!

The YaST crew keeps working hard on fixing bugs and, specially, on
building new features for everybody to enjoy in the upcoming versions of
all the products of the SLE and openSUSE families. So, as much as we
would like to keep talking to you all about all the improvements… it’s
time to go back to coding! See you again in two weeks with a new report.



[1]: https://www.suse.com/products/caas-platform/
[2]: https://kubic.opensuse.org/
[3]: https://en.opensuse.org/Kubic:CaaSPInstallationComparision#Combined_Workflow
[4]: https://software.intel.com/en-us/articles/what-is-intel-rapid-start-technology
[5]: {{ site.baseurl }}{% post_url 2018-11-07-highlights-of-yast-development-sprint-66 %}#partitioning-proposel-uses-a-single-disk
[6]: https://github.com/yast/yast-packager/pull/385

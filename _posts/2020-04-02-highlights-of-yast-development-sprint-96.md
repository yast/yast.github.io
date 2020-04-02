---
layout: post
date: 2020-04-02 16:00:00 +00:00
title: Highlights of YaST Development Sprint 96
description: While many activities around the world slow down, we are proud to say the YaST
  development keeps going at full speed.
category: SCRUM
permalink: blog/2020-04-02/sprint-96
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

## Contents

While many activities around the world slow down due to the COVID-19 crisis, we are proud to say the
YaST development keeps going at full speed. To prove that, we bring you another report about what
the YaST Team has been working on during the last couple of weeks.

The releases of openSUSE Leap 15.2 and SUSE Linux Enterprise 15 SP2 are approaching. That implies we
invest quite some time fixing bugs found by the testers. Many of them are not specially exciting
but we still have enough interesting topics to report about:

  * More news about the new Online Search module
  * Improvements in the user interface to configure NTP
  * Progress in the support of Secure Boot for s390 mainframes
  * Better reporting in AutoYaST
  * Some bugfixes related to the handling of storage devices
  * And a bonus: our new tool for mass review of GitHub pull requests

So let's start!

## The Online Search Keeps Improving {#online-search}

This is not the first time our loyal readers learn about the YaST feature to search online for
packages within SLE modules and extensions. We initially presented it [three reports
ago]({{site.baseurl}}blog/2020-02-07/yast-sprint-93#the-online-search-feature-comes-to-yast),
followed by [a review]({{site.baseurl}}blog/2020-03-06/yast-sprint-94#online-search) of
several usability improvements we had decided to implement on top of that
initial version.

But, as usual, SUSE's QA department did a pretty good job forcing us to go one step further and
provided us with useful information about how to improve the functionality. Apart from some minor
bugs, they reported that there were important performance problems and that the UX could be
improved.

The performance issues were annoying when working with big result sets. In one of our testing
machines, it took several seconds to display the found packages after having received the list from
the SUSE Customer Center. Moreover, scrolling through the results was rather slow too. Hopefully,
those problems are gone now: most of the time is spent in network communication and scrolling works
smoothly.

{% include blog_img.md alt="Graphical Online Search module"
src="online-search-300x225.png" full_img="online-search.png" %}

Regarding the UX, we introduced a few changes:

  * Now there is a button to make clear how to select/unselect a package for installation. In the
  text-based interface, it was rather easy to infer that pressing `Enter` was enough. However, in
  the graphical alternative, things were not that easy.
  * We have added some information about how many packages were found.
  * The help texts were extended and improved.

{% include blog_img.md alt="Online Search module (text mode)"
src="online-search-ncurses-300x220.png" full_img="online-search-ncurses.png" %}

## Polishing the Interface to Configure NTP Server {#ntp-server}

But the Online Search module is not the only interface we received some love. ...

[Trello
card](https://trello.com/c/rSD8mt9D/)

## Secure Boot in zSeries Mainframes - Second Round {#secure-boot}

[Previous blog
entry](https://lizards.opensuse.org/2020/03/06/yast-sprint-94/#secure-boot)

[Pull request](https://github.com/yast/yast-bootloader/pull/594)

[Technical summary](https://bugzilla.suse.com/show_bug.cgi?id=1166736#c9)

But, as you already know, this is not the only part of YaST we are improving step by step, one
sprint after the other.

## More Sanity Checks in AutoYaST {#autoyast}

As part of our continuous effort to improve AutoYaST error handling and reporting capabilities
(see this [section of the previous
report]({{site.baseurl}}blog/2020-03-19/sprint-95#autoyast-conflicting-attrs)), we
have added a new check for multi-devices technologies. Thus in case you are setting up an LVM
volume group, a RAID, a Bcache or a multi-device Btrfs filesystem, AutoYaST makes sure that their
components are also properly defined in the AutoYaST profile.

For instance, let's say you want to set up a multi-device Btrfs file system but you forget to define
which disks or partitions are part of this file system. In such a case, the new version of AutoYaST
informs about the missing definitions and stops the installation.

In the image below, you can see how the error reporting mechanism looks. In this example, it reports
the AutoYaST the profile contains a new LVM volume group but does not specify which devices should
act as physical volumes for it.

{% include blog_img.md alt="AutoYaST reporting missing LVM PVs"
src="autoyast-no-pvs-300x225.png" full_img="autoyast-no-pvs.png" %}

## It's all About Blocks {#storage-blocks}

As mentioned in the previous section and as all our users know, YaST and AutoYaST can be used to
define a software RAID in which several disks or devices are combined for extra performance, extra
reliability or a combination of both.

The usual scenario is to combine similar disks. But the RAID technology in Linux is so advanced that
it allows to combine disks with different block sizes into the same array. Thanks to a recent bug
report, we realized YaST was not handling that situation in the best way. That leaded to a wrong
estimation about the final size of the RAID device which, in turn, leaded to possible errors while
creating partitions in it.

We have fixed the libstorage-ng code and [its
documentation](https://github.com/openSUSE/libstorage-ng/blob/master/doc/md-raid.md#combining-disks-with-different-block-sizes),
that now offers an accurate description on how the situation is handled in Linux and in our storage
library.

Apart from the creation of the RAID itself, the YaST Partitioner also offers some related
functionality that is very handy in setups with many disks. For example, the button "Clone
Partitions to Other Device" that can be used to replicate the same initial layout in all the disks
that are going to be subsequently combined using the RAID technology.

When using such button, the Partitioner tries to only offer destination devices that make sense.
That means they have to be as least as big as the source device, they have to have the same
topology, etc. But guess what! We found out it didn't check for the block sizes. That is also fixed
now and future versions of the Partitioner will not allow to clone a partition table into another
disk with a different block size, something that will lead to failures in most cases.

## More Accurate Detection of zFCP devices {#zfcp}

And talking about storage devices, recently we got a bug report about AutoYaST not being able to
install SUSE on an s390 mainframe.  After checking the logs and all the information provided, we
found out that the profile was basically wrong as it contained the following definition for a zFCP
device:

```xml
<listentry>
  <controller_id/>
  <fcp_lun>0x0000000000000000</fcp_lun>
  <wwpn>0x0000000000000000</wwpn>
</listentry>
```

Apart from the `controller_id` being missing, `fcp_lun` and `wwpn` look wrong too. So the profile is
invalid, and there is nothing that AutoYaST can do about it. Done! Well, not that fast: the problem
is that the profile was generated by AutoYaST itself.

We discovered that AutoYaST was wrongly identifying an iSCSI device as a zFCP one. So the profile
excerpt above corresponds to an iSCSI device which, obviously, does not have any of those
attributes.

A simple fix solved the issue and zFCP devices are now properly detected in openSUSE Tumbleweed and
in the AutoYaST version that will be shipped with openSUSE Leap 15.2 and SLES-15-SP2.

## Beyond YaST: GitHub Review from Command Line {#ghreview}

We have reserved some development time also for learning and innovation. This part about reporting
result of such a work.

Sometimes we need to do a simple change but in many Git repositories. Sometimes we need to touch
_all_ repositories, like when we need to change the `CONTRIBUTION.md` or some similar file.

Approving several dozens of pull requests in the GitHub web user interface is not easy or convenient
so we have created a simple script which can approve the pull requests from the Linux command line.
The tool is interactive, for each pull request is displays some details, the diff, the Travis
status, etc...  and then it asks for approval.

If you approve the request then it will approve it at GitHub with the usual "LGTM" (Looks Good To
Me) message. If the request is not approved then you need to manually comment at the GitHub web UI
why. Unfortunately there is no easy way for commenting a diff from command line...

For more details see [this GitHub repository](https://github.com/lslezak/ghreview).

## Conclusion {#conclusion}

To be written.


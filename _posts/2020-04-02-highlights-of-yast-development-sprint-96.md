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

While many activities around the world slow down due to the COVID-19 crisis, we are proud to say the
YaST development keeps going at full speed. To prove that, we bring you another report about what
the YaST Team has been working on during the last couple of weeks.

The releases of openSUSE Leap 15.2 and SUSE Linux Enterprise 15 SP2 are approaching. That implies we
invest quite some time fixing bugs found by the testers. Many of them are not specially exciting
but we still have enough interesting topics to report about:

  * More news about the new Online Search functionality
  * Improvements in the user interface to configure NTP
  * Progress in the support of Secure Boot for s390 mainframes
  * Better reporting in AutoYaST
  * Some bugfixes related to the handling of storage devices
  * And a bonus: our new tool for mass review of GitHub pull requests

So let's start!

## The Online Search Keeps Improving {#online-search}

This is not the first time our loyal readers learn about the YaST feature to search online for
packages within SLE modules and extensions. We initially presented it [three reports
ago]({{site.baseurl}}/blog/2020-02-07/sprint-93#the-online-search-feature-comes-to-yast),
followed by [a review]({{site.baseurl}}/blog/2020-03-06/sprint-94#online-search) of
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

{% include blog_img.md alt="Graphical Online Search screen"
src="online-search-300x225.png" full_img="online-search.png" %}

Regarding the UX, we introduced a few changes:

  * Now there is a button to make clear how to select/unselect a package for installation. In the
  text-based interface, it was rather easy to infer that pressing `Enter` was enough. However, in
  the graphical alternative, things were not that easy.
  * We have added some information about how many packages were found.
  * The help texts were extended and improved.

{% include blog_img.md alt="Online Search screen (text mode)"
src="online-search-ncurses-300x220.png" full_img="online-search-ncurses.png" %}

But the Online Search UI is not the only interface that received some love...

## The Strange Case of the Multiple NTP Servers {#ntp-servers}

YaST NTP allows to configure a list of NTP servers to use for synchronizing the date and time of the
system. But one of our beloved users reported that a certain sequence of steps in the YaST Timezone
module could ruin that list, reducing it to only its first entry. That was caused by a lack of
consistency between both YaST modules.

YaST Timezone was designed a long time ago to, unlike YaST NTP, display and configure exactly one
server. You may be asking, why can NTP be configured from YaST Timezone if there is an specific and
more advanced YaST module for that purpose? The answer is that the YaST Timezone dialog is the only
one available during installation, where it makes sense to offer the timezone and NTP configuration
all together and with simplified options.

{% include blog_img.md alt="Timezone dialog during installation"
src="timezone-installation-300x224.png" full_img="timezone-installation.png" %}

That simplicity also makes sense in an installed system for users with a basic configuration. But in
systems with an advanced setup, we adapted that dialog to display the list of servers and to not
offer any shortcut to adjust that configuration. Instead, the YaST Timezone dialog offers only a
"Configure" button that opens the YaST NTP dialog, where the user can fine-tune the NTP
configuration at will.

{% include blog_img.md alt="Timezone dialog in a running system"
src="ntp-running-multi-300x224.png" full_img="ntp-running-multi.png" %}

## Secure Boot in zSeries Mainframes - Second Round {#secure-boot}

A couple of reports ago, we presented the [initial support for zSeries Secure
boot]({{site.baseurl}}/blog/2020-03-06/sprint-94#secure-boot). We have continued
improving that feature based on the feedback received from early testers and mainframe specialists.

Now, YaST behavior is better adapted to the characteristics of the system in which it's been
executed. We could go into details about each zSeries model and how YaST behaves based on its
hardware configuration. But since an image is worth a thousand words, let's just illustrate it with
this new warning about z15+ requirement displayed when secure boot support is turned on.

{% include blog_img.md alt="Secure Boot warning" src="z15-warning-300x80.png"
full_img="z15-warning.png" %}

The help texts and the information displayed in the installer proposal have also been adapted to
better explain the consequences of the possible settings in YaST. Once again, let's see it with an
example image.

{% include blog_img.md alt="Secure Boot help" src="secure-boot-help-300x200.png"
full_img="secure-boot-help.png" %}

But, as you already know, this is not the only part of YaST we are improving step by step, one
sprint after the other...

## More Sanity Checks in AutoYaST {#autoyast}

As part of our continuous effort to improve AutoYaST error handling and reporting capabilities
(see this [section of the previous
report]({{site.baseurl}}/blog/2020-03-19/sprint-95#autoyast-conflicting-attrs)), we
have added a new check for multi-devices technologies. Thus in case you are setting up an LVM
volume group, a RAID, a Bcache or a multi-device Btrfs filesystem, AutoYaST makes sure that their
components are also properly defined in the AutoYaST profile.

For instance, let's say you want to set up a new LVM volume group but you forget to define which
devices are going to act as physical volumes for it. In such a case, the new version of AutoYaST
informs about the missing definitions and stops the installation.

In the image below you can see how the error reporting mechanism looks. In this example, it reports
the AutoYaST profile contains a new multi-device Btrfs file system, but it does not specify which
disks or partitions should be part of that file system.

{% include blog_img.md alt="AutoYaST reporting missing devices for Btrfs"
src="autoyast-no-components-300x225.png" full_img="autoyast-no-components.png" %}

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
disk with a different block size, something that would lead to failures in most cases.

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
_all_ repositories, like when we need to change the `CONTRIBUTING.md` or some similar file.

Approving several dozens of pull requests in the GitHub web user interface is not easy or convenient
so we have created a simple script which can approve the pull requests from the Linux command line.
The tool is interactive, for each pull request is displays some details, the diff, the Travis
status, etc...  and then it asks for approval.

If you approve the request then it will approve it at GitHub with the usual "LGTM" (Looks Good To
Me) message. If the request is not approved then you need to manually comment at the GitHub web UI
why. Unfortunately there is no easy way for commenting a diff from command line...

For more details see [this GitHub repository](https://github.com/lslezak/ghreview).

## Last words... for now {#conclusion}

As you can see, the bodies of the YaST Team members may be confined at home, but our minds are still
out there, creating, fine-tuning and delivering software for you. And you can help us by testing the
beta versions of openSUSE Leap 15.2 and SUSE Enterprise Linux 15 SP2 or just keeping your openSUSE
Tumbleweed up to date and reporting any anomalous situation you find in YaST.

We will be back with more news in approximately two weeks. Meanwhile, have a lot of fun and take
care of you and yours.

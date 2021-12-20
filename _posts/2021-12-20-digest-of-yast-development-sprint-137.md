---
layout: post
date: 2021-12-20 06:00:00 +00:00
title: Digest of YaST Development Sprint 137
description: The last report of the YaST Team for 2021 is here!
permalink: blog/2021-12-20/sprint-137
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Year 2021 comes to an end, but not before the YaST Team publishes another development report
covering areas as diverse as:

- Improvements in the installer self-update mechanism
- Better error reporting in storage analysis
- More consistent management of UEFI
- Better handling of the installer boot arguments
- More intuitive representation of thin logical volumes

Let's check every one in detail.

## Fast Self-Update for All {#self-update}

As you may know, YaST has the ability to update itself at the very beginning of the installation
of the operating system. That makes possible to correct the installation process in case errors are
detected after publishing a given release of SUSE Linux Enterprise.

Recently we found there was room for improving the speed and also to simplify how the mechanism
works in some scenarios. It's hard to explain exactly what we did in only a few words... so we will
not try. ;-) But if you don't mind reading quite some words and watching a couple of animations,
go and check the [description of this pull request](https://github.com/yast/yast-registration/pull/552).

Apart from the already mentioned improvements, we also extended the YaST self-update to support
relative URLs. Check the details in this [separate pull
request](https://github.com/yast/yast-installation/pull/1008).

## Better Error Reporting Regarding Storage Devices {#libstorage-errors}

One of the most important phases of the execution of YaST, both during installation and when
running some of the available configuration modules, is the analysis of the storage setup of the
system. That includes checking the available disks and how they are organized into partitions,
RAIDs, LVM volume groups and many other storage technologies recognized by YaST. If something goes
wrong during that process, YaST stops and asks the user whether it should abort the current process.

That's fine for most cases. But what happens if a system presents a problematic setup... replicated
in more than 60 disks? Those kinds of setups are not unusual in enterprise environments and having
to click "continue" 60 times is not exactly fun. So we decided to improve how YaST reports those
errors, adding also the possibility of easily reviewing them all at any later point in time from the
Partitioner. Check [this description](https://github.com/yast/yast-storage-ng/pull/1248) of the
feature, containing dozens of screenshots!

This new mechanism will be used in future releases of Leap and SLE and is already available in
openSUSE Tumbleweed.

## More Consistent Management of UEFI {#uefi}

A lot of modern systems use UEFI firmware for booting. But correctly checking if a given system uses
that technology or which UEFI features are available may not always be that straightforward. During
this sprint we did some internal reorganization of the YaST code which deals with UEFI to make it
more robust. Why an internal reorganization may be relevant for our blog readers? Because we took
the opportunity to [document](https://github.com/yast/yast-storage-ng/blob/master/doc/efi.md) how
the detection works and how it can be overridden for YaST to setup UEFI from a system booting in legacy
x86 mode and vice versa.

## Better Handling of the Installer Boot Arguments {#linuxrc}

What do self-update, error reporting and UEFI detection have in common in YaST? Of course, that all of
them have been mentioned on this blog post. But also that their behavior can be influenced passing
some boot parameter to the installer. That's a powerful tool for advanced users that provides great
flexibility but that had a tiny drawback... until it was [fixed during this
sprint](https://github.com/openSUSE/installation-images/pull/546).

## Intuitive Visualization of LVM Thin Volumes {#thin}

The last change we want to highlight in this report is something that may be considered cosmetic and
that affects only those using such an expert tool as LVM thin logical volumes. But it represents the
kind of details we really enjoy improving when we have some spare development cycles. The small UI
adjustment you can see in [this pull request](https://github.com/yast/yast-storage-ng/pull/1267) is
already available at openSUSE Tumbleweed and will be also there in future releases of SLE and
openSUSE Leap.

## That's all for this year {#closing}

As we always point, this is only a small sample of everything we have done during the sprint. But we
don't want to keep you busy reading about bug-fixes and small code reorganizations. After all, year 
2022 is around the corner and it's already vacation season in many areas around the globe. So go and
enjoy the celebrations. The YaST Team will be here next year with more news to share. Take care!

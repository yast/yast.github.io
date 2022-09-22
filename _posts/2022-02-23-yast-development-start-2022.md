---
layout: post
date: 2022-02-23 06:00:00 +00:00
title: How YaST Development is Going at 2022
description: Two months after our latest regular report, the YaST team has some interesting bits
  to share both about YaST and the D-Installer project.
permalink: blog/2022-02-23/start-2022
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

We realized that, apart from the [blog post presenting our D-Installer
project]({{site.baseurl}}/blog/2022-01-18/announcing-the-d-installer-project), we have not
reported any YaST activity during 2022 here in our blog. Since we are in the Beta phase of the
development of SUSE Linux Enterprise 15-SP4 (which will also be the base for openSUSE Leap 15.4)
we are quite focused on helping to diagnose and fix the problems found by the intensive and
extensive tests done by SUSE QA department, partners and customers. We know that's not the part of
our job our audience wants to read about... and to be honest is not the part we enjoy writing about
either.

Fortunately, two months after our latest regular report, we have some interesting more bits to share.

## New YaST Features {#yast}

While debugging and fixing issues we also found time to implement quite some interesting changes and
new features in YaST. Let's quickly go through a summary.

- Improvements in the way [YaST handles the activation](https://github.com/yast/yast-storage-ng/pull/1271)
  of encrypted devices.
- Better integration of [NFS management in the
  Partitioner](https://github.com/yast/yast-storage-ng/pull/1283).
- Usability and speed [enhancements for DASD formatting](https://github.com/yast/yast-s390/pull/93)
  on S/390 systems.
- Support for GRUB2 password protection in AutoYaST (check the [recently
  extended](https://github.com/SUSE/doc-sle/pull/1057/files) documentation for more information).
- Better [handling of the errors](https://github.com/yast/yast-storage-ng/pull/1265) found analyzing
  storage devices.
- Adapted the [keyboard layouts](https://github.com/yast/yast-country/pull/288) used by YaST.
- Support for selecting during installation the [desired Linux Security
  Module](https://github.com/yast/yast-security/pull/115) (note the screenshots on that pull request
  are not fully up-to-date and do not exactly reflect the current user interface).
- Improvements in how the `_netdev` mount option is handled for remote file-systems. Including
  [changes in the general handling](https://github.com/yast/yast-storage-ng/pull/1254) and the new
  [warning in the Partitioner](https://github.com/yast/yast-storage-ng/pull/1272).
- Adapted YaST to be compliant with the inclusive naming initiative. This implies changes in different
  parts of YaST, like [this](https://github.com/yast/yast-network/pull/1277),
  [this](https://github.com/yast/yast-network/pull/1280),
  [this](https://github.com/yast/yast-dns-server/pull/95) or
  [this](https://github.com/yast/yast-nis-server/pull/29).
- Definition of specific per-product schemas to validate the AutoYaST profiles.
- Integration of the [package `yast2-firstboot-wsl` into
  `yast2-firstboot`](https://github.com/yast/yast-firstboot/pull/131).
- Adjusted [creation of snapshots in YaST](https://github.com/yast/yast-installation/pull/1020) for
  transactional systems like MicroOS.
- New capability for roles and products to [specify a default
  timeout](https://github.com/yast/yast-bootloader/pull/665) for the boot loader configuration.
- Support for [switching themes](https://github.com/libyui/libyui/pull/65).
- Adapted [handling of network configuration](https://github.com/yast/yast-network/pull/1282) if
  iBFT (iSCSI Boot Firmware Table) is used during installation.

We also found time to implement some internal changes that, even though they don't have a direct
impact on final users, may be interesting for the more technical audience like people who usually
debug or develop YaST:

- Better ways to [manually test `yast2-storage`](https://github.com/yast/yast-storage-ng/pull/1274)
 and debug storage-related issues.
- Usage of RSpec verifying doubles and better YaST module mocking. See [this
  announcement](https://lists.opensuse.org/archives/list/yast-devel@lists.opensuse.org/thread/YE6KWTAGKRNP2OZ2KEGQ5EKBO3J4RJPT/)
  in the yast-devel mailing list.

## Progress on D-Installer {#dinstaller}

As you all know from our previous blog post mentioned above, we are also working on a side project
codenamed D-Installer, as our main YaST duties permit. We want to turn our initial proof of concept
into something that you can actually try, so the team is working on a few topics at the same time.

On the one hand, we are redefining our D-Bus API thinking about how it should look like in the
future. As a side effect, Martin is improving the [ruby-dbus](https://github.com/mvidner/ruby-dbus)
library to support a few features that we need, like better support for D-Bus properties.

On the other hand, we are redesigning the user interface. Although we have not implemented the new
design, you can see the approach we would like to follow in our mock-ups. :-)

{% include blog_img.md alt="Initial mock-ups for D-Installer"
  src="dinstaller-mini.png" full_img="dinstaller.png" %}

## More to Come {#closing}

As you can see, we have been quite busy lately and we plan to remain so. The bright side is that
both YaST and D-Installer will keep evolving at a good pace. The not-so-bright one is that we are not
sure when we will be able to blog again. But we promise we will try to recover the biweekly cadence.
Meanwhile do as we do and have a lot of fun!

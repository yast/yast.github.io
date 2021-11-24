---
layout: post
date: 2021-11-24 06:00:00 +00:00
title: Digest of YaST Development Sprints 135 & 136
description: The YaST Team breaks almost a month of radio silence to report new features and
  interesting fixes
permalink: blog/2021-11-24/sprints-135-136
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

After almost a month of radio silence, the YaST Team is back with another development report. The
two latest sprints has brought:

- New features like:
  - More general LUKS2 support in the Partitioner
  - Mechanisms to detect if the system boots using EFI both in AutoYast rules and ERB templates
  - Enhanced handling of NTLM authentication in linuxrc
- Usability improvements in several areas of YaST
- Dropping some legacy features to have a more sane code-base
- More internal refactoring in the area of software management
- Many fixes here and there

So let's dive into the details.

## New Features {#features}

As already explained in this same blog [quite some time
ago](https://yast.opensuse.org/blog/2019/10/09/advanced-encryption-options-land-in-the-yast-partitioner/)
the YaST Partitioner can be used to setup several kinds of encryption, but "Regular LUKS2" was not
one of those. That was intentional because using LUKS2 comes with many challenges, as summarized in
[this Bugzilla comment](https://bugzilla.suse.com/show_bug.cgi?id=1185291#c1). But now the time has
come to start introducing experimental support for general LUKS2 encryption.  Initially it will be
available in openSUSE Tumbleweed and pre-releases of SLE-15-SP4 but only if the environment variable
`YAST_LUKS2_AVAILABLE` is set. Check the [description of this pull
request](https://github.com/yast/yast-storage-ng/pull/1245) for screenshots and more information. 

Support for LUKS2 in AutoYaST will have to wait a bit, until we have received some feedback from
interactive installations and ironed out all the details. But AutoYaST users can meanwhile test and
enjoy another new feature available also in Tumbleweed and 15.4 pre-releases - support for
identifying EFI systems in dynamic profiles, which includes both rules and ERB templates. Learn more
and see some examples in the [description of the corresponding pull
request](https://github.com/yast/yast-autoinstallation/pull/808).

The last feature for Tumbleweed and the upcoming 15.4 that we want to highlight in this report is
the brand new support for NTLM authentication in linuxrc. The authentication process is actually delegated to
`curl`. Passing credentials to `curl` through the linuxrc parameters is as easy as you can see in
the following examples:

```
  install=https://user:password@example.com/the_repo
  proxy=https://user:password@example.com
```

## Usability Improvements {#usability}

Sometimes, you don't need to introduce a whole new shiny functionality to enhance the life of the
final users. Small improvements can also have a big impact... although "small" doesn't always mean
"easy to implement".  In that regard we would like to highlight that:

 - We have improved filtering and sorting in the list of DASD devices in s390 mainframes
 - The installation on that architecture will run in graphical mode if executed in QEMU and a Virtio GPU is detected
 - Configuring the custom boot partition in YaST2 Bootloader is now more [robust and
   intuitive](https://github.com/yast/yast-bootloader/pull/654)

## Less Code, Fewer Problems {#dropping}

Going even further, enhancing the software is sometimes not even a matter of adding or polishing
functionality but a matter of cleaning up features that are not longer useful, removing code and
infrastructure in the process. Simpler usually means more robust and maintainable.

In that regard, you can check [this pull request](https://github.com/yast/yast-users/pull/353) about
management of group passwords or [this other](https://github.com/yast/yast-storage-ng/pull/1239)
about the obsolete format to configure the partitioning proposal.

## Internal Changes and Fixes {#fixes}

If you are interested in technical details and having a look to the YaST internals, we also have a
couple of pull request that could be interesting, like [this
fix](https://github.com/yast/yast-storage-ng/pull/1247) for the detection of duplicated LVM
structures and [this improvement](https://github.com/yast/yast-yast2/pull/1204) in the way YaST
manages the initialization of its user interface.

Talking about internals, we have mentioned several times our ongoing effort to restructure how
software management works in YaST. You can see some more technical details in [this
gist](https://gist.github.com/imobachgs/30942b4b89f4b33125ca9d1f6b1476b1) if you have an interest in
the design of computer programs and APIs.

## Winter is coming {#closing}

It's less than one month to the official start of winter in the Northern Hemisphere. We keep working
hard and we hope to give you at least another update of the YaST status before that date. Meanwhile
we can only remember you, no matter in which part of the world you are, to have a lot of fun!

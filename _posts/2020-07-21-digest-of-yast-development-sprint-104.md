---
layout: post
date: 2020-07-21 08:00:00 +00:00
title: Digest of YaST Development Sprint 104
description: This summary includes our usual overview of two weeks of work and also the results of
  the survey about our blog.
category: SCRUM
permalink: blog/2020-07-21/sprint-104
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

As the YaST team keeps implementing new features and bug fixes we also keep delivering our small
activity reports. As you may remember, we ran a small survey to collect our readers' opinion
about the recent changes introduced in these reports. We will today take a look to the results of
the survey. But first things first, let's go over the most relevant pull requests in the YaSTphere
from the latest two weeks.

## Summary of the (Auto)YaST Changes

- Research about the differences in the look&feel of the installer and YaST Firstboot, including
  several fixes and [a whole new
  document](https://github.com/yast/yast-firstboot/blob/master/doc/installer_and_firstboot.md)
  summarizing the current inconsistencies and how we plan to address them.
- Several fixes related to the usage of the `firstboot_hostname` client, including
  [a fixed crash](https://github.com/yast/yast-firstboot/pull/100) and [improved hostname
  validation](https://github.com/yast/yast-network/pull/1087).
- [More accurate detection of the installation medium
  type](https://github.com/yast/yast-packager/pull/526) when SMT (SUSE Subscription Management Tool)
  is used to mirror the repositories from SCC (SUSE Customer Center) during installation.
- Better support in the Partitioner for the different types of LVM logical volumes (RAID, cache,
  snapshots, etc.). That includes [better visualization and informative
  warnings](https://github.com/yast/yast-storage-ng/pull/1105), as well as [automatic removal of
  dependant snapshots](https://github.com/yast/yast-storage-ng/pull/1106).
- AutoYaST now [exports the SUSE registration
  settings](https://github.com/yast/yast-registration/pull/502).
- [Improved support for the so-called Repository
  Variables](https://github.com/yast/yast-yast2/pull/1071) (like `${releasever}`) in the URL of
  the repositories during system upgrade.
- Extend the support of Repository Variables to also [cover the name of the
  repositories](https://github.com/yast/yast-packager/pull/528), in addition to the already
  mentioned support in URLs.
- Adapted YaST to handle the new location of the `krb5` files, both in
  [yast2-auth-server](https://github.com/yast/yast-auth-server/pull/65) and
  [yast2-users](https://github.com/yast/yast-users/pull/233).
- Many internal improvements regarding AutoYaST.

## Our readers have spoken

But the previous list of improvements is not the only news we have for you. We got 31 answers to our
survey about how our readers use the YaST blog post and we want to share the results with you.

The detailed report with all the numbers can be read [in this
mail](https://lists.opensuse.org/yast-devel/2020-07/msg00013.html), but the most important
conclusions we have taken are:

- Most participants are loyal readers (71% of them read the blog regularly).
- Most readers define themselves as just (open)SUSE users (74%).
- Both formats we have tried for the posts (long stories vs digests of links) are valued by our
  readers in a similar way.

Since the current digest format is way easier to put together, we will keep it for the time being.
Thanks a lot for all the input, it was really helpfull!

See you in the next sprint report!

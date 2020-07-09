---
layout: post
date: 2020-07-09 08:00:00 +00:00
title: Digest of YaST Development Sprint 103
description: Apart from the ongoing effort to modernize AutoYaST, the YaST team has been doing some
  research in the storage area and closed a few bugs in the installer.
category: SCRUM
permalink: blog/2020-07-08/sprint-103
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Before introducing the recent changes in the YaST land, the team would like to congratulate the
openSUSE community for the release of Leap 15.2. It looks like a pretty solid release, and we are
proud of being part of this project.

Having said that, let's focus on what the team has achieved during the past sprint.

## Summary of the (Auto)YaST Changes

- Fix an embarrassing installer crash
  ([boo#1172898](https://bugzilla.opensuse.org/show_bug.cgi?id=1172898)). We suspect that it might
  be [a Ruby problem](https://bugzilla.suse.com/show_bug.cgi?id=1172898#c20), but we [implemented a
  solution in the installer](https://github.com/openSUSE/installation-images/pull/387).
- [Add a mechanism to ask AutoYaST to export a reduced
  profile](https://github.com/yast/yast-autoinstallation/pull/631). At this point in time, only the
  [yast2-users](https://github.com/yast/yast-users/pull/232) module supports such a mechanism.
- Publish [our conclusions](https://lists.opensuse.org/yast-devel/2020-07/msg00001.html) about the
  usage of wizards in the Expert Partitioner.
- Study the impact of adding support for new types of LVM logical volumes in our storage layer. We
  will use the outcome of such research to plan future work in this area. If you are curious, you
  can start by having a look at [LVM features and YaST
  document](https://github.com/yast/yast-storage-ng/blob/master/doc/lvm.md).
- [Use the REMOVE libstorage-ng view when deleting
  devices](https://github.com/yast/yast-storage-ng/pull/1106). You can check
  [libstorage-ng#740](https://github.com/openSUSE/libstorage-ng/pull/740) if you
  are interested in the mentioned view.
- [Remove the obsolete repository
  initialization](https://github.com/yast/skelcd-control-leanos/pull/55), which made installation
  using an unsigned/self-signed repository impossible.
- [Do not solve dependencies while checking the connection to
  libzypp](https://github.com/yast/yast-yast2/pull/1070).
- [Add support to collect memory usage data during
  installation](https://github.com/yast/yast-installation/pull/864). If you are interested, check
  the [follow-up document](https://gist.github.com/mvidner/9d959eb91190bce35e0d190324a80fb8), which
  contains some nice ideas for the near future.
- [Backport to SLE 12 SP4 some fixes related to Ruby gems
  loading](https://github.com/yast/yast-ruby-bindings/pull/244) in order to solve a problem some
  appliances were having after a Ruby security update.
- [Do not remove /etc/hosts entries during
  autoinstallation](https://github.com/yast/yast-network/pull/1084).

## The YaST Blog Poll Is Still Running

A few weeks ago, [we announced]({{site.baseurl}}/blog/2020-05-29/sprint-99-100#future) that we were
changing our sprint reports' format to reduce the amount of work that it takes us to write them.
Thus, instead of using a consistent and self-contained nice story, we decided to go for a
digest-like approach.


After having published two reports using the new approach, we decided to open [a
poll]({{site.baseurl}}/blog/2020-06-23/sprint-102#yast-blog-poll) to know your opinion of such a
change. We have already received quite some feedback, but the poll is still open and we would love
to hear from you.


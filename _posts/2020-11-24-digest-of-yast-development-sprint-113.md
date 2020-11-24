---
layout: post
date: 2020-11-24 01:00:00 +00:00
title: Digest of YaST Development Sprint 113
description: Time for another report of the YaST (+Cockpit) Team, with news on several fronts
permalink: blog/2020-11-24/sprint-113
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Time flies and it has been already two weeks since our previous development report. On these special
days, we keep being the YaST + Cockpit Team and we have news in both fronts. So let's do a quick
recap.

### Cockpit Modules

Our [Cockpit module to manage `wicked`](https://github.com/openSUSE/cockpit-wicked) keeps improving.
Apart from several small enhancements, the module has now better error reporting and correctly
manages those asynchronous operations that `wicked` takes some time to perform. In addition, we have
improved the integration with a default Cockpit installation, ensuring the new module replaces the
default network one (which relies in Network Manager) if both are installed. In the following days
we will release RPM packages and a separate blog post to definitely present Cockpit Wicked to the
world.

On the other hand, we also have news about our [Cockpit module to manage transactional
updates](https://github.com/lslezak/cockpit-transactional-update). We are creating some early
functional prototypes of the user interface to be used as a base for future development and
discussions. You can check the details and several screenshots at the following pull requests:
[request#3](https://github.com/lslezak/cockpit-transactional-update/pull/3),
[request#5](https://github.com/lslezak/cockpit-transactional-update/pull/5).

### Btrfs Subvolumes in the Partitioner

Regarding YaST and as already mentioned in our [previous blog
post]({{site.baseurl}}/blog/2020-11-10/sprint-112), we are working to ensure Btrfs subvolumes get
the attention they deserve in the user interface of the YaST Partitioner, becoming first class
citizens (like partitions or LVM logical volumes) instead of an obscure feature hidden in the screen
for editing a file system.

As part of such effort, we have improved the existing mechanism to suggest a given list of
subvolumes, based on the selected product and system role. See more details and screenshots at
[the corresponding pull request](https://github.com/yast/yast-storage-ng/pull/1164).

We have also added some support for Btrfs quotas, a mechanism that can be used to improve space 
accounting and to ensure a given subvolume (eg. `/var` or `/tmp`) does not grow too much and ends
up filling up all the space in the root file system. [This pull
request](https://github.com/yast/yast-storage-ng/pull/1165) explains the new feature with several
screenshots, including the new quite informative help texts.

All the mentioned changes related to subvolumes management will be submitted to openSUSE Tumbleweed
in the following days.

### More YaST enhancements

Talking about the YaST Partitioner, you may know that we recently added a menu bar to its interface.
During this sprint we have improved the YaST UI toolkit to ensure the keyboard shortcuts for such
menu bar stay as stable as possible. Check the details at [this pull
request](https://github.com/libyui/libyui/pull/175).

We have also been working in making the installer more flexible by adding support to define, per
product and per system role, [whether YaST should
propose](https://github.com/yast/yast-yast2/pull/1115) to configure the system for hibernation. In
the case of SUSE Linux Enterprise, we have adapted the control file to propose hibernation in
[the SLED case](https://github.com/yast/skelcd-control-SLED/pull/101), but not for [other
members of the SLE family](https://github.com/yast/skelcd-control-leanos/pull/69).

### See you soon

Of course, we have done much more during the latest two weeks. But we assume you don't want to read
about small changes and boring bug-fixes... and we are looking forward to jump into the next sprint.
So let's go back to work and see you in two weeks!

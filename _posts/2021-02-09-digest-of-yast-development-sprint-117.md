---
layout: post
date: 2021-02-09 10:00:00 +00:00
title: Digest of YaST Development Sprint 117
description: The YaST Team keeps working on adding new features and improving some of the recently
  added ones
permalink: blog/2021-02-09/sprint-117
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It's time for more development news from the YaST Team. In this occasion, most of the work has gone
into improving features already implemented in previous sprints and, thus, presented in former blog
posts. That includes:

  - Improvements when writing wireless security settings for NetworkManager
  - Fixes in the new management of hibernation
  - Possibility to tweak the I/O device autoconfiguration in the installed system
  - Usability improvements regarding nested items in the table widget
  - Better LibYUI packaging including a revamped CMake build system
  - Enhancements in the YaST Autoinstallation module regarding partitioning
  - Many other improvements and fixes here and there

As you surely remember, in the [previous sprint]({{site.baseurl}}/blog/2021-01-25/sprint-116) we added
support for writing basic NetworkManager configuration during installation. But it was quite limited
regarding wireless, so it only was capable to translate WPA-PSAK and open wireless configuration.
During this sprint, we [enhanced the NetworkManager config writers](https://github.com/yast/yast-network/pull/1156)
to support the same wireless setups that are currently supported by wicked (WEP, WPA-EAP...). In
addition, some UI problems were [found and fixed](https://github.com/yast/yast-network/pull/1162).

In the previous sprint we also improved the hibernation support by tuning the scenarios in which
YaST adds the `resume=` parameter to the bootloader configuration. While testing that improved
behavior, some problems were detected both by ourselves and by the awesome QA team at SUSE.
Now all those inconvenients are fixed: the bootloader proposal is [properly
recalculated](https://github.com/yast/yast-bootloader/pull/630) when needed, the `resume` parameter
is [not longer added](https://github.com/yast/yast-bootloader/pull/631) for small swap devices and
we improved the [detection of virtual setups](https://github.com/yast/yast-yast2/pull/1134) in which
traditional hibernation is not wanted.

But not all the features we polished during this sprint are so recent. For several months, we have
been describing the different steps in the implementation of support in YaST for I/O devices
auto-configuration on s390 mainframes. The latest reference was on [our blog post of sprint
105]({{site.baseurl}}/blog/2020-08-06/sprint-105) (time flies!). But we still had one more thing in
our TO-DO list and, since we recently had to modify the YaST2 Tune module to remove some obsolete
settings, we decided to take the opportunity and also add the I/O device autoconfig checkbox to that
module. See details and screenshots at [this pull request](https://github.com/yast/yast-tune/pull/46).

We also improved the usability of our most recent LibYUI feature. In the YaST partitioner, which is
so far the only application using the new feature to have nested rows in a table, the `[Space]` key
did not only open or close tree branches in the ncurses text-mode interface. It also sent an
"Activated" event (the counterpart of double-clicking an item in the Qt graphical user interface),
resulting in a quite confusing behavior. See [the fix](https://github.com/libyui/libyui-ncurses/pull/112)
for more detailed information.

And talking about LibYUI, we also decided it was time to tackle one big problem that we have been
dragging for too long. The structure of our development repositories and our over-complicated CMake
build environment was making too hard to add new features to LibYUI without risking breakage in the
distributions. Every change implied a lot of extra synchronization work, which also was an obstacle
for external contributions and maintaners of additional plugins and backends. After several weeks of
work, we have now walked the first step out of that mess with [the new CMake build system for
LibYUI](https://gist.github.com/shundhammer/2d2b9bcf4b62df5b139daeceec8283ab)

And there is no YaST Team sprint without some news about AutoYaST. This time we have improved the
part of the YaST Autoinstallation module that can be used to create and tweak the `<partitioning>`
section of the AutoYaST profile. Apart from several small fixes (like [improved
visualization](https://github.com/yast/yast-storage-ng/pull/1203) or [fixes in the `fstopt`
field](https://github.com/yast/yast-autoinstallation/pull/728)), it's now possible to manage
`<drive>` sections to describe [NFS and
tmpfs](https://github.com/yast/yast-autoinstallation/pull/727) file systems.

As usual, there would be much more to report like [usability
improvements](https://github.com/yast/yast-network/pull/1151) and
[speedups](https://github.com/yast/yast-network/pull/1159) in YaST Network, [fixes in
hwinfo](https://github.com/openSUSE/hwinfo/pull/92) or important [updates in the
documentation](https://github.com/yast/yast-storage-ng/pull/1205)... but we need to go back to
coding at some point!

So see you again in a couple of weeks with more news about YaST and, if everything works as
expected, some reflections about the long-term future. Stay safe and have a lot of fun!

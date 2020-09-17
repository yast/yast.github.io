---
layout: post
date: 2020-09-17 01:00:00 +00:00
title: Digest of YaST Development Sprint 108
description: The YaST Team keeps working in mid-term goals in several areas, specially AutoYaST and
  storage management. Let's take a look to the progress.
category: SCRUM
permalink: blog/2020-09-17/sprint-108
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

In our [previous post]({{site.baseurl}}/blog/2020-09-07/sprint-107) we reported we were working in
some mid-term goals in the areas of AutoYaST and storage management. This time we have more news to
share about both, together with some other small YaST improvements.

- Several enhancements in the new MenuBar widget, including better
  [handling](https://github.com/libyui/libyui/pull/170) and
  [rendering](https://github.com/libyui/libyui-ncurses/pull/104) of the hotkey shortcuts and
  improved [keyboard navigation](https://github.com/libyui/libyui-ncurses/pull/102) in text mode.
- More steps to add a menu bar to the Partitioner. Check this [mail
  thread](https://lists.opensuse.org/yast-devel/2020-09/msg00004.html) to know more about the status
  and the whole decision making process.
- New helpers to improve the experience of using Embedded Ruby in an AutoYaST profile (introduced
  in the [previous post]({{site.baseurl}}/blog/2020-09-07/sprint-107)). Check the [documentation of
  the new helpers](https://github.com/yast/yast-autoinstallation/pull/674/files) for details.
- Huge speed up of the AutoYaST step for "Configuring Software Selections" by [moving some
  filtering operations](https://github.com/yast/yast-pkg-bindings/pull/136) from Ruby to libzypp.
  Now the process is almost instant even when using the OSS repository that contains more than
  60.000 packages!
- A [new log of the packages upgraded](https://github.com/yast/yast-installation/pull/885) via the
  self-update feature of the installer.

The next SLE and Leap releases are starting to shape and we are already working in new features for
them (that you could of course preview in Tumbleweed, as usual). So stay tuned for more news in two
weeks!

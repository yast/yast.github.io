---
layout: post
date: 2020-08-17 08:00:00 +00:00
title: Digest of YaST Development Sprint 106
description: Although the YaST team is focusing on bugfixing in this summer season, we still have three
  interesting features to share with our fellow chameleons.
category: SCRUM
permalink: blog/2020-08-17/sprint-106
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

In August the YaST Team is focusing on bugfixing, which is a nice way to use the time while many
colleagues are on summer vacation. The downside is that blog posts consisting on a list of solved
bugs look pretty boring. Fortunatelly, we also found time to implement three nice new features.

- New [menu bar widget](https://github.com/libyui/libyui/pull/169) in libYUI. Check the screenshots
  below.
- Configuration of the firewall in AutoYaST moved to the first stage if possible. Check the
  [documentation update](https://github.com/SUSE/doc-sle/pull/629) for details.
- [Preliminary support](https://github.com/yast/yast-installation/pull/878) to mark the packages
  affected by [BootHole](https://www.suse.com/c/suse-addresses-grub2-secure-boot-issue/) and show a
  warning message if such old packages are going to be installed (text of the message is still
  under development).

Everybody loves screenshots, so let's see how the new libYUI menu bar looks. First in graphical
mode.

{% include blog_img.md alt="New Menu Widget, Qt"
src="menu-qt-300x307.png" full_img="menu-qt.png" %}

And then in text-based interfaces.

{% include blog_img.md alt="New Menu Widget, NCurses"
src="menu-ncurses-300x269.png" full_img="menu-ncurses.png" %}

We have plans to use the new widget to improve the usability of the YaST Partitioner. Stay tuned for
more news. If nothing goes wrong, we will have plenty of them to share with you here in two weeks.

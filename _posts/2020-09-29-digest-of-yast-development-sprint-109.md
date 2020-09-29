---
layout: post
date: 2020-09-29 01:00:00 +00:00
title: Digest of YaST Development Sprint 109
description: The YaST Team continues focusing on improving both AutoYaST and the
  management of storage devices. Let's take a quick glance at some of the results.
category: SCRUM
permalink: blog/2020-09-29/sprint-109
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

For third sprint in a row, the YaST Team has been focusing on enhancing both AutoYaST and the
management of storage devices, together with some improvements in our development infrastructure.
Let's take a quick glance at some of the results.

- New [YaST test client](https://github.com/yast/yast-autoinstallation/pull/696) to check AutoYaST
  dynamic profiles, including support for pre-scripts that modify the profile, ERB, rules and classes.
- Improved detection of which YaST package is needed to process each section of the profile,
  [relying on RPM's supplement information](https://github.com/yast/yast-autoinstallation/pull/665)
  instead of the old method based on desktop files.
- First steps to annotate the documentation of AutoYaST with information about when each profile
  element was introduced or deprecated.
- Final design of the new Partitioner user interface. The adopted solution is described in the [corresponding
  section](https://github.com/yast/yast-storage-ng/blob/master/doc/partitioner_ui.md#agreed-plan-so-far)
  of our design document and already implemented to a large extent, so we are confident to release a
  revamped Partitioner during next sprint.
- Improved automatic submission of translations to openSUSE Leap and SUSE Linux Enterprise, since
  only the Tumbleweed process was fully automated so far.

{% include blog_img.md alt="New Interface of the Partitioner"
src="partitioner-300x183.png" full_img="partitioner.png" %}

As we usually remind our readers, these blog posts only show a very small part of all the work,
improvements and bug fixes we put into YaST on every sprint. So don't forget to keep your systems
updated and to stay tuned to this blog and all other openSUSE channels for more information!

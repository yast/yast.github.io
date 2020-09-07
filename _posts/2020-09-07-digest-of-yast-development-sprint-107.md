---
layout: post
date: 2020-09-07 01:00:00 +00:00
title: Digest of YaST Development Sprint 107
description: With some delay from the actual end of the sprint, let's take a look to what the YaST
  team was doing at the end of August.
category: SCRUM
permalink: blog/2020-09-07/sprint-107
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The last two weeks of August the YaST team has kept the same _modus operandi_ than the rest of the
month, focusing on fixing bugs and polishing several internal aspects. But we also found some time
to start working on some mid-term goals in the area of AutoYaST and storage management. Find below a
summary of the most interesting stuff addressed during the sprint finished a week ago (sorry for the
delay).

- Making the AutoYaST profiles more flexible [by means of Erb
  templates](https://github.com/yast/yast-autoinstallation/pull/667). That's still a work in
  progress and we will publish a separate blog post with more details and examples soon.
- When reporting errors in a certain element of an AutoYaST profile to the user, do it with the
  [same syntax](https://github.com/yast/yast-storage-ng/pull/1121) that is used when specifying
  ask-lists.
- Preliminary version of a [menu bar for the
  Partitioner](https://github.com/yast/yast-storage-ng/pull/1122). Again, this is still in progress,
  so stay tuned for more news.
- Better [handling of corrupted](https://github.com/yast/yast-autoinstallation/pull/668) or
  completely incorrect AutoYaST profiles.

Although it doesn't look like too much, the bright side is that we are already deep into the next
sprint. So you will not have to wait much to have more news from us. Meanwhile, stay safe and
fun!

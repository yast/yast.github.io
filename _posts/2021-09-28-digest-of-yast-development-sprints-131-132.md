---
layout: post
date: 2021-09-28 06:00:00 +00:00
title: Digest of YaST Development Sprints 131 & 132
description: Another two sprints of polishing YaST internals and learning about the release tools
permalink: blog/2021-09-28/sprints-131-132
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

This is our third blog post since summer started in Europe and also the third time in a row we write
a combined blog post for two development sprints. And it's also the third consecutive report focused
on improvements to the existing codebase rather than on new shiny features. That covers:

- Rethinking some aspects of the management of software, keyboard layouts and NTP configuration
- Heavy work in the internals of yast2-users
- Improvements in the way YaST handles libYUI plugins
- Visual fixes in the packages manager
- More progress in the release tools

## Diving into our own history {#internals}

After 22 years of constant development of the same codebase, it's not surprising that some parts of
YaST2 are a bit intricate. As you know, we are lately investing time in an attempt to shred some
light on some of those internals. During these latest sprints it was time for checking the
configuration of the NTP client, the behavior of the keyboard layouts, the way we manage software
and the administration of users and groups in already installed systems.

We don't have much finished stuff to present yet, but we expect important changes in those four
areas in the future. Regarding the management of users, we hope to report big improvements in the
next blog post. Changes in the other three areas are more targeted to the mid-term, but we will
keep steadily working on it.

## Graceful Handling of Missing libYUI Components {#libyui}

And talking about YaST history and software that is still evolving after more than twenty years, we
cannot forget about libYUI - the cornerstone that allows YaST to run in both graphical and text
modes. LibYUI is a modular library that offers several backends (like Qt or ncurses) and also a
plugins system to implement advanced widgets. So the user can install only one of the given
backends or just a subset of all the available widgets. But such flexibility can be a double-edged
sword.

During this sprint, we improved how YaST handles the situation in which a missing combination of
plugin and backend is needed to perform the action requested by the user. The description of
[this pull request](https://github.com/yast/yast-yast2/pull/1194) offers a detailed overview of the
situation and the implemented solution, including screenshots.

## Where is my header? {#header}

Did we mention flexibility comes with a price? :wink: Just multiply the different ways in which YaST
can be used by all the architectures and environments supported by the (open)SUSE distributions and
you'll get a glimpse of all the things that can go wrong.

Recently we got a report about YaST not displaying the names of the categories in the list that
shows the patches that can be installed in the system. It took us weeks to reproduce the error
because it worked just fine in all the systems we tried, including virtual machines and bare metal.
But turns out there was indeed in problem... visible only when executing YaST in a KVM virtual
machine with a Plasma desktop.

But we finally caught the bug and you can see a screenshot and the corresponding fix in the
description of [this pull request](https://github.com/libyui/libyui/pull/48).

## Release Tools: Polishing {#osrt}

As our readers already know, the YaST Team is also trying to help with the maintenance and evolution
of the (open)SUSE release tools. And nothing makes the source code more maintainable than getting rid
of it. So after some months of discussions, we managed to [identify and
drop](https://github.com/openSUSE/openSUSE-release-tools/pull/2613) eight obsolete tools.

We also keep improving the documentation, not only for the tools in the repository but also updating
and extending the information available in the openSUSE wiki about the openSUSE development process.
Last but not least, we improved the automated tests for the tools, hopefully making them more
understandable for newcomers in the process.

## More news to come {#closing}

Hopefully the next report will contain more details about finished work and actually released
features. Meanwhile, we promise to keep working if you all promise to keep having fun!

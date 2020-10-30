---
layout: post
date: 2020-10-30 01:00:00 +00:00
title: Digest of YaST Development Sprint 111
description: The YaST Team continues improving the installer... but also ventures into new territories.
category: SCRUM
permalink: blog/2020-10-30/sprint-111
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Another development sprint ended for the YaST Team this week. This time we have fewer news than
usual about new features in YaST... and the reason for that may surprise you. Turns out a
significant part of the YaST Team has been studying the internals of
[Cockpit](https://cockpit-project.org/) in an attempt to use our systems management knowledge to
help to improve the Cockpit support for (open)SUSE.

But that doesn't mean we have fully stopped the development of YaST and other parts of the
installation process. Apart from working in several not yet finished improvements that will be
presented in our next blog post, we have:

- Started to [add unit tests](https://github.com/openSUSE/installation-images/pull/434) to the
  ancient Perl libraries that generate the system image used to run the installer.
- Added a new [emergency mechanism](https://github.com/yast/yast-storage-ng/pull/1153) to ignore
  errors found while analyzing storage devices.
- Extended linuxrc with the ability of [sending DHCP requests in RFC2132
  format](https://github.com/openSUSE/linuxrc/pull/230).

While doing all that and fixing several bugs, we also found time to prepare and deliver our
presentation in the [openSUSE + LibreOffice Virtual
Conference](https://events.opensuse.org/conferences/oSLO/), with the self-explanatory title of
"Top 25 New Features in (Auto)YaST". We are not fully sure whether a recording of the talk will be
uploaded by the organizers at some point, but we will keep you informed if that happens.

That's all folks! See you again in (hopefully less than) two weeks.

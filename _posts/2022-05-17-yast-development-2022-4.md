---
layout: post
date: 2022-05-17 06:00:00 +00:00
title: YaST Development Report - Chapter 4 of 2022
description: It's time for more news about D-Installer, containers and of course YaST!
permalink: blog/2022-05-17/yast-report-2022-4
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

As our usual readers know, the YaST team is lately involved in many projects not limited to YaST
itself. So let's take a look to some of the more interesting things that happened in those projects
in the latest couple of weeks.

## Improvements in YaST {#yast}

As you can imagine, a significant part of our daily work is invested in polishing the versions of
YaST that will be soon published as part of SUSE Linux Enterprise 15-SP4 and openSUSE Leap 15.4,
whose first Release Candidate version is [already
available](https://lists.opensuse.org/archives/list/factory@lists.opensuse.org/thread/APWGH6QWOBEQW4RF2JOOAGVMGB5RJIHX/).

That includes, among many other things, [improving the behavior of
yast2-kdump](https://github.com/yast/yast-kdump/pull/126) in systems with Firmware-Assisted Dump
(`fadump`) or [adding a bit of extra information](https://github.com/yast/yast-yast2/pull/1253) to
the installation progress screen that we recently simplified.

## YaST in a Box {#container}

So the present of YaST is in good hands... but we also want to make sure YaST keeps being useful in
the future. And the future of Linux seems to be containerized applications and workloads. So we
decided to investigate a bit whether it would be possible to configure a system using YaST... but
with YaST running into a container instead of directly on the system being configured.

And turns out it's possible and we actually managed to run several YaST modules with different
levels of success. Take a look to [this repository at
Github](https://github.com/lslezak/yast-container) including not only useful scripts and Docker
configurations, but also a nice report explaining what we have achieved so far and what steps could
we take in the future if we want to go further into making YaST a containerizable tool.

## Evolution of D-Installer {#dinstaller}

Running into containers may be the future for YaST as a configuration tool (or not!). But we are
also curious about what the future will bring for YaST as an installer. In that regard, you know we
have been toying with the idea of using the existing YaST components as back-end for a new installer
based on D-Bus temporarily nicknamed D-Installer. And, as you would expect, we also have news to
share about D-Installer.

On the one hand, we used the recently implemented infrastructure for bi-directional communication
(which allows the back-end of the installer to ask questions to the user when some input is needed)
to [handle some situations](https://github.com/yast/d-installer/pull/150) that could happen while
analyzing the existing storage setup of the system. On the other hand, we added the possibility of
[modifying the D-Installer configuration](https://github.com/yast/d-installer/pull/158) via boot
arguments, with the option to get some parts of that configuration from a given URL.

{% include blog_img.md alt="D-Installer asking for a LUKS passphrase"
src="luks-mini.png" full_img="luks.png" %}

## See you Soon! {#closing}

If you want to get more first-hand information about recent (Auto)YaST changes, about D-Installer
development or any other of the topics we usually cover in this blog, bear in mind [openSUSE
Conference 2022](https://events.opensuse.org/conferences/oSC22) is just around the corner and a big
part of the YaST Team will be there presenting these and other topics. We hope to see as many of you
there in person. But don't worry much if you cannot attend, we will keep blogging and will stay
reachable at all the usual channels. So stay tuned for more news... and more fun!

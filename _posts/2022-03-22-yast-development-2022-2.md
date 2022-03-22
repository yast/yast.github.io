---
layout: post
date: 2022-03-22 06:00:00 +00:00
title: YaST Development Report - Chapter 2 of 2022
description: Time for another regular status update from the YaST team, with news about YaST itself
  and D-Installer
permalink: blog/2022-03-22/yast-report-2022-2
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

In the YaST Team we have changed a bit the way we organize the work and we are not longer numbering
the development sprints. But that will not stop us from reporting as often as possible what's new in
the YaST world. So, let's go with our second regular development report of 2022.

## New YaST Features {#yast}

We are still in the beta phase of the development of SUSE Linux Enterprise 15-SP4 and openSUSE
Leap 15.4, which means a significant part of our time is invested in debugging and fixing issues
found by our testers. But we also keep introducing other changes and new features. Let's go over
some of them.

In the [previous blog post]({{site.baseurl}}/blog/2022-02-23/start-2022) we mentioned the new
support for switching themes in the installer. As a cherry on top, we recently [improved and partially
automated](https://github.com/yast/yast-theme/pull/160) the process to generate the corresponding
SLE themes.

In the network area, we [extended YaST support](https://github.com/yast/yast-network/pull/1287) to
configure Network Manager in S/390 mainframes and improved the way YaST [handles automatic network
configuration](https://github.com/yast/yast-network/pull/1285) (DHCP) in interfaces associated to
devices configured via iBFT (iSCSI Boot Firmware Table).

Regarding usability, we [improved the behavior](https://github.com/libyui/libyui/pull/69) of the
installer when the Release Notes contain external links.

We also tried to improve the visibility of a feature that has been available in AutoYaST for quite
some time (initially announced at [this blog
post]({{site.baseurl}}/blog/2020-12-24/modernizing-autoyast-result) from 2020) but that we fear may
have been overlooked by some of its potential users - the possibility to use ERB (Embedded Ruby)
within the AutoYaST profiles. In that regard, we contributed quite some [documentation and
examples](https://github.com/SUSE/doc-sle/pull/1122) to the official AutoYaST documentation
maintained by the awesome Documentation Team at SUSE.

On a more technical note, we introduced an [automated
check](https://github.com/yast/helper_scripts/pull/36) to detect if the YaST code contains method
invocations that may be problematic in any of the different versions of Ruby supported by YaST. It
may serve as inspiration for other Ruby developers needing to support different runtime environments.

## D-Installer Keeps Evolving {#dinstaller}

As our main obligations permit, we continue progressing in our
[D-Installer](https://github.com/yast/d-installer) side project that is already able to install an
openSUSE system, configuring some basic aspects like the language or the partitioning layout.

{% include blog_img.md alt="D-Installer Finish Screen"
  src="d-finished-mini.png" full_img="d-finished.png" %}

We are actively working to publish a couple of interesting bits in the upcoming weeks. On the one
hand, a blog post detailing the current status, the involved technologies and the opportunities
D-Installer may bring for the future. On the other hand, a live openSUSE image containing the new
tool so everyone can give it a try by installing openSUSE Tumbleweed in any virtual or real machine.

## Stay tuned {#closing}

This blog is a nice communication channel to keep you all informed about recent news and future
plans, but we don't want it to be the only way. We hope to see as many of you as possible in the
upcoming [openSUSE Conference 2022](https://events.opensuse.org/conferences/oSC22) in June. We plan to
present quite some content in several talks (and maybe even some workshop) and we would like to
encourage everyone to do the same. Beware the call for papers close in three weeks and time flies!

While waiting for the event to happen, we promise to keep blogging regularly as long as you promise
to keep trying to have a lot of fun!

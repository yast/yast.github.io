---
layout: post
date: 2022-09-22 06:00:00 +00:00
title: YaST Development Report - Chapter 9 of 2022
description: The YaST Team keeps containerizing and improving all kind of system management tools
permalink: blog/2022-09-22/yast-report-2022-9
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The YaST Team keeps working on the already known three fronts: improving the installation experience
in the traditional (open)SUSE systems, polishing and extending the containerized version of YaST and
smoothing Cockpit as the main 1:1 system management tool for the upcoming ALP (Adaptable Linux
Platform).

So let's see the news on each one of those areas.

## New Possibilities with Containerized YaST {#yast}

Quite some things were improved regarding the containerized version of YaST and we made sure to
reflect all that in the corresponding [reference
documentation](https://en.opensuse.org/openSUSE:ALP/Workgroups/SysMngmnt/ContainerizedYaST#Usage).
Although that document is maintained in the scope of ALP, the content applies almost literally
to any recent (open)SUSE distribution. Of course, that includes openSUSE Tumbleweed and, as a
consequence, we [dropped](https://build.opensuse.org/request/show/1003322) from that distribution
the package `yast-in-container` since it's not longer needed to enjoy the benefits of the
containerized variant of YaST.

But you may be wondering what those recent improvements are. First of all, now the respective YaST
modules for configuring both Kdump and the boot-loader can handle transactional systems like ALP or
MicroOS. On the other hand, the graphical Qt container was fixed to allow remote execution via SSH
X11 forwarding. Again, that is useful in the context of ALP but not only there. That simple fix
actually opens the door to full graphical administration of systems in which there is no graphical
environment installed. Only the `xauth` package is needed, as explained in the mentioned
documentation.

Last but not least, we added two new YaST containers based on the existing graphical and text-mode
ones but adding the LibYUI REST API on top. Those containers will be used by openQA and potentially
by other automated testing tools.

## Better Cockpit Compatibility with ALP {#cockpit}

All the improvements mentioned above contribute to make YaST more useful in the context of ALP.
But Cockpit remains (and will remain in the foreseeable future) as the default tool for graphical
and convenient direct administration of individual ALP systems. As such, we keep working to make
sure the experience is as smooth as possible.

We integrated some changes to make `cockpit-kdump` work better in (open)SUSE systems and improved
the `cockpit-storaged` package to ensure LVM compatibility. We are also working on a better
integration of Cockpit with the ALP firewall, but that is still in progress because it's a complex
topic with several facets and implications.

But the biggest news regarding Cockpit and ALP is the availability of the Cockpit Web Server
(`cockpit-ws`) as a [containerized
workload](https://build.opensuse.org/project/show/SUSE:ALP:Workloads), which makes it possible to
enjoy Cockpit on the standard ALP image without installing any additional package.

Of course we also improved the &quot;[Cockpit at
ALP](https://en.opensuse.org/openSUSE:ALP/Workgroups/SysMngmnt/Cockpit#Cockpit_at_ALP)&quot; 
documentation to reflect all the recent changes and additions.

## Improvements in the YaST Installer {#installer}

As much as we look into the future with ALP, we keep taking care of our traditional distributions
like Leap, Tumbleweed or SUSE Linux Enterprise. As part of that continuous effort, we tweaked and
improved the installer in a couple of areas.

First of all we adjusted the font scaling in HiDPI scenarios. In general the installer adapts
properly to all screens, but sometimes the fonts turned out to be too large or too small. Now it
should work much better. The road to the fix was full of bumps which made it a quite interesting
journey. You can check the technical details (and some screenshots) in this [pull
request](https://github.com/yast/yast-installation/pull/1057).

We also keep improving the feature about security policies we presented in [one of our previous
posts]({{site.baseurl}}/blog/2022-08-23/yast-report-2022-7). Check the following [pull
request](https://github.com/yast/yast-security/pull/128) to get an status update and to see a
recent screenshot.

## Back to Work {#conclusion}

ALP is getting to an state in which it can be considered usable for initial testing. We plan to
keep helping to make that happen without forgetting our sacred duties of maintaining and evolving
our beloved YaST. All that demands us to stop blogging and go back to more mundane tasks. But we do
it with the promise of being back in some weeks.

See you soon!

---
layout: post
date: 2021-06-01 06:00:00 +00:00
title: Digest of YaST Development Sprint 124
description: The YaST Team keeps working on setting the foundations for some mid-term goals
permalink: blog/2021-06-01/sprint-124
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The YaST Team at SUSE keeps working with an eye in the future. During the latest sprint we invested
quite some time thinking about the long term and how YaST (and Linux installers in general) fit into
a landscape of containers, cloud computing and related technologies. But we also found time to work
on setting the foundations for some mid-term goals. That includes: 

  - Progress in the rewrite of yast2-users, including AutoYaST
  - Better tools to track memory consumption during installation
  - A new YaST module to assist those working in the YaST look & feel
  - Improved logging of products information

As you know from previous sprint reports, we are rewriting big parts of the users management in
YaST. During this sprint we integrated support for authorized keys and improved several aspects of
the interactive installation and password management. We also took big steps forward in the rewrite
of users handling in AutoYaST. The new implementation is steadily approaching to its debut in
openSUSE Tumbleweed, but we still need one or two sprints more to ensure it's solid enough and
ready to provide a seamless transition.

But users management is not the only area that has been problematic lately. As more software gets
added to the openSUSE distributions and more products and variants get added to SUSE Linux
Enterprise, we see the memory consumption of the installation process grow... too much for our
taste. Finding areas were we can cut down the memory usage is not trivial, so we just added
[optional in-process memory profiling](https://github.com/yast/yast-installation/pull/935) to the
installer. Hopefully this new tool will be the first step to a slimmer installer for the future.

We do not only want to have a more efficient installer, we also want it to be prettier. But for that
the YaST Team has to rely on the skills of more talented designers, who create and tweak the Qt style
sheets used to define the final look of YaST. To ease their work, we created a new special YaST
module called [YaST Widget Demo](https://github.com/yast/yast-widget-demo). Apart from the new
module itself, that new repository includes all the information needed to start playing with YaST
theming, and even [a collection of
screenshots](https://github.com/yast/yast-widget-demo/issues/2) of the current state in both
openSUSE and SLE.

As mentioned before, one of the reasons for the growth of the SUSE Linux Enterprise installation is
the wide offering of products and extensions. Since each product, module, extension and role can
influence the installation process, that variety also increases the complexity and makes harder to
diagnose possible problems during the installation or upgrade process. To tackle that, in future
releases YaST will create a [separate and detailed
log](https://github.com/yast/yast-yast2/pull/1135) with all the associated information. That will
allow us to better help openSUSE and SLE users facing related issues.

openSUSE Leap 15.3 will be officially released tomorrow and SLE-15-SP3 is also around the corner.
Time to enjoy them... and to think about what's next! While the YaST Team continues with the
development of new features and tools to keep improving our beloved distributions, you can take your
part by responding to the [call for feature
requests](https://news.opensuse.org/2021/05/31/release-manager-provides-update-on-early-feature-requests-for-leap/)
for openSUSE Leap 15.4. Let's keep having a lot of fun!

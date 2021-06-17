---
layout: post
date: 2021-06-17 06:00:00 +00:00
title: Digest of YaST Development Sprint 125
description: Latest two weeks of YaST development bring improvements in the installation process
  and in the user interface, among many other things
permalink: blog/2021-06-17/sprint-125
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Time flies and another two weeks of YaST development has passed. As in the [previous
report]({{site.baseurl}}/blog/2021-06-01/sprint-124), we have to mention we invested quite some
time learning and experimenting with technologies that will shape the role of YaST in particular and
Linux installers in general in the future. But we also had time to fix quite some bugs and to make
progress in several features, like:

- Simplified support for hibernation
- Make network forwarding configurable in the installer
- Improved tabs in graphical mode
- Progress in the rewrite of yast2-users, including AutoYaST

Fun enough, the first aspect we want to report about is not a feature we developed, but one we
reverted. Back in November [we reported]({{site.baseurl}}/blog/2020-11-24/sprint-113) a new
feature in the installer to propose hibernation only in real hardware (ie. not in virtual machines)
and only if the product's configuration specifies hibernation is desired. Time has proved that the
usage of hibernation in real world scenarios goes further than expected back then. For example,
hibernation is used in virtual servers deployed on some cloud-based providers, as part of a
technique to save power and money. The existence of that kind of creative scenarios makes very hard
to predict when hibernation is wanted or not. So YaST will go back to its previous behavior of
proposing hibernation always if the technical conditions are met, no matter which product is being
installed or in which environment. The change will be available as an installer self-update for
SLE-15-SP3.

But we don't give up in our attempts to make smart selections in the installer. As you may know,
YaST allows to tweak the network configuration during installation. Among many other things, it
allows to configure the status of IP forwarding. But we want YaST to propose a correct default value
for those settings without requiring user intervention. In the cases of openSUSE MicroOS and SLE
Micro that means enabling forwarding by default, since is needed for such systems to work properly.
So we [made that configurable per product](https://github.com/yast/yast-network/pull/1229) and
adjusted the corresponding configuration for those container-based solutions.

Beyond the installer, we also invested some time in something we really wanted to put our hands on -
improving the look&feel of the YaST tabs in graphical mode. The description of [this pull
request](https://github.com/libyui/libyui/pull/31) includes a good description of the problems (with
a link to the original issue in which they were discussed), a technical explanation of the solution
and, of course, many screenshots!

Last but not least, we continue our small project to rewrite big parts of the users management in
YaST. We implemented support for some aspects that were still based on ancient Perl code and we are
getting rid of all the legacy parts involved in (auto)installation. If everything goes as expected,
next sprint will see the new user management land in the installation process of openSUSE
Tumbleweed.

We hope you are already enjoying openSUSE Leap 15.3 and ready for the [openSUSE Virtual Conference
2021](https://events.opensuse.org/conferences/oSVC21). Meanwhile, we keep working to make YaST a
little bit better every day thanks to your feedback. See you around and have a lot of fun!

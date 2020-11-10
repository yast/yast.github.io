---
layout: post
date: 2020-11-10 01:00:00 +00:00
title: Digest of YaST Development Sprint 112
description: It's time for the YaST team to pay its debts... with Cockpit news, YaST improvements and
  conference videos
category: SCRUM
permalink: blog/2020-11-10/sprint-112
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Our [previous sprint report]({{site.baseurl}}/blog/2020-10-30/sprint-111) was full of promises. We
stated we were working to improve the [Cockpit](https://cockpit-project.org) support for (open)SUSE
and finishing some other interesting stuff. We also mentioned we had delivered a YaST presentation
in the [openSUSE + LibreOffice Virtual Conference](https://events.opensuse.org/conferences/oSLO/).
Time has come to pay our debts. The current report offers more news about all that.

### Make Cockpit Great... for (open)SUSE

In the Cockpit area, we found out the official module for network configuration is completely
coupled to Network Manager. Its (lack of) internal architecture makes very hard to adapt it to work
with [wicked](https://github.com/openSUSE/wicked), the framework used by (open)SUSE to configure the
network, specially on servers. So we are writing a [new Cockpit
module](https://github.com/dgdavid/cockpit-wicked) to configure the system network through wicked.
It's pretty functional already, including:

  - Configuration of both [IPv4](https://github.com/dgdavid/cockpit-wicked/pull/31) and
  [IPv6](https://github.com/dgdavid/cockpit-wicked/pull/42)
  - Basic support for [wireless configuration](https://github.com/dgdavid/cockpit-wicked/pull/44)
  - Management of [VLANs](https://github.com/dgdavid/cockpit-wicked/pull/30)
  - Definition of [routes](https://github.com/dgdavid/cockpit-wicked/pull/41)
  - Virtual interfaces like [bonds](https://github.com/dgdavid/cockpit-wicked/pull/12) and
    [bridges](https://github.com/dgdavid/cockpit-wicked/pull/9)

We don't have a clear release date for this new module yet, since we have to coordinate with the
team that will take care of packaging Cockpit for (open)SUSE and we still want to improve validation
and error handling. That includes deciding how to inform the user if something goes wrong, since
there is no unified way to do that across the different Cockpit modules. And we also want to
improve the DNS settings and to extend the support for wireless technologies. Meanwhile, if you are
hungry for screenshots you can check the links to the pull requests in the list of features above.

We have also being working in a Cockpit module to manage transactional updates. But that one is still
in research phase and we have very little to show at this point.

### Storage improvements

Of course, YaST keeps being our main target and lately we have concentrated a rather significant amount
of development firepower into the area of storage management. First of all, we have finally submitted
to openSUSE Tumbleweed the long anticipated overhaul of the Partitioner user interface. Check the
description of [this pull request](https://github.com/yast/yast-storage-ng/pull/1157) for a visual
summary of everything that have changed.

On top of that new interface, we have started make Btrfs subvolumes more prominent, adding more
possibilities to handle them. Check [the corresponding pull
request](https://github.com/yast/yast-storage-ng/pull/1160) for more details and screenshots.

And last but not least (regarding storage management), we have [improved the installer
proposal](https://github.com/yast/yast-storage-ng/pull/1159) for creating a `/boot/efi` partition when
needed. That change was also submitted to openSUSE Tumbleweed and will be available as well in the
upcoming Leap 15.3 and SLE-15-SP3.

### Informing more and better

We also put some effort during this sprint in improving YaST's user friendliness. On one hand by
[explaining better](https://github.com/yast/yast-bootloader/pull/623) the bootloader configuration in
some corner cases and allowing to easily tweak that configuration. On the other hand, offering a
[much more informative](https://github.com/yast/yast-ruby-bindings/pull/253) message when there is
an error parsing some configuration file.

### Look Ma! That's me on TV!

We also found out the recording of our talk presenting the "Top 25 New Features in (Auto)YaST" at
the openSUSE + LibreOffice Virtual Conference is finally available at the openSUSE TV channel.

<iframe width="560" height="315" src="https://www.youtube.com/embed/AIsJJRyGMFY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Enjoy and spread the word!

### That's all folks

Since we had very diverse things to share with you, this post has turned out to be a bit longer
than expected. But don't worry, we plan to come back to more concise reports in the upcoming blog
entry. That will be in two weeks from now. Meanwhile, watch the video, check the links and have a lot
of fun!

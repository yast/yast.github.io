---
layout: post
date: 2021-04-20 06:00:00 +00:00
title: Digest of YaST Development Sprints 119, 120 & 121
description: After Hack Week and some irregular sprints, the YaST Team is back to restore the
  traditional cadence of one report every two weeks
permalink: blog/2021-04-20/sprints-119-120-121
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

YaST development never stops. But we have to admit we have not kept our readers as informed as usual
about the activities of the YaST team, other than our [blog post about Hack
Week]({{site.baseurl}}/blog/2021-03-30/hack-week-20). We had to adapt the length and focus of some
sprints before and after Hack Week. That, together with Easter season in Europe and some extra
vacations, affected our good publishing habits. On the bright side, we have tons of topics for you,
let's do a quick recap.

- Reduction of the memory consumption during installation.
- New option to enable installation in systems with small RAM.
- Improvements in the NetworkManager support.
- Polishing of the upcoming releases, especially AutoYaST and hardware enablement.
- A new `extend` parameter in `linuxrc` to help openQA.
- More consistent and polished LibYUI development.
- Research and open discussion about the current state and future of:
  - YaST Firstboot,
  - YaST Users,
  - the installation workflow.

So let's go by parts. As you may know, libzypp was recently updated in all SLE and openSUSE
distributions to bring some cool new features.  Unfortunately that came with a small increase in
memory consumption. That was enough to exceed the current installation requirements, so we had to
find some way to save memory in the installer. We adjusted several things, especially the installer
self-update mechanism. See [this pull request](https://github.com/yast/yast-installation/pull/926)
to know how we managed to fit again into the requirements. As a nice side effect, we improved the
handling of the `memsample` script we use to track memory usage during installation.

Talking about the memory consumption of the installation process, we also added a cool feature to
`linuxrc` and YaST that makes possible to install (open)SUSE in systems with an small amount of
memory. Check the new [zram parameters](https://en.opensuse.org/SDB:Linuxrc#p_zram) in the `linuxrc`
documentation and see the description of [this pull
request](https://github.com/openSUSE/linuxrc/pull/246) if you are interested in the details.

Another area that received quite some love is the support for configuring NetworkManager during
the installation process. For SLE-15-SP3 and Leap 15.3 that includes [better DNS
settings](https://github.com/yast/yast-network/pull/1194), [support for bridge and bonding
configuration](https://github.com/yast/yast-network/pull/1186) and [improved AutoYaST
integration](https://github.com/yast/yast-network/pull/1187). For Tumbleweed it also includes
[displaying the corresponding details](https://github.com/yast/yast-network/pull/1198) in the
installer's summary screen.

We also invested quite some time polishing the upcoming releases of openSUSE Leap 15.3 and
SLES-15-SP3. Especially improving the handling of AutoYaST profiles, extending the support for some
storage technologies like NVMe and adjusting the boot loader configuration for a wide range of
hardware.

On the more technical side of things, we also added a [new `extend`
parameter](https://en.opensuse.org/SDB:Linuxrc#p_extend) to `linuxrc` (which now allows a smooth
integration of the `libyui-rest-api` plugin in openQA) and we unified the [repositories of LibYUI](https://github.com/libyui/libyui) (which simplifies maintenance and future contributions).

While doing all that, we also found time to think about the future of YaST. We did some extensive
research on the current state of three areas we would like to improve in the mid term:

- YaST Firstboot. Check this [Github issue](https://github.com/yast/yast-firstboot/issues/115) (and
  all the related issues linked from it) describing several aspects of the current state and also ideas
  about improving its look&feel and making it a more useful tool.

- The current installation process. Again, we are using Github issues to discuss how to make it
  shorter and more understandable. As a starting point, check [this
  issue](https://github.com/yast/yast-installation/issues/903) that contains an interesting
  conversation and also links to several other related issues.

- YaST Users. We are considering to refactor this module to improve the management of local users
  and to reduce the risk introduced by its current complexity. As a first step, we created a new
  repository that, so far, contains [several
  documents](https://github.com/yast/yast-users/tree/master/doc) describing the _status quo_.

As you can see, we may have been a bit absent but definitely we have not been idle. And the best
news is that we are back to our usual biweely schedule, so we will have more to share soon.
Meanwhile stay safe and fun!

---
layout: post
date: 2021-03-02 06:00:00 +00:00
title: Digest of YaST Development Sprint 118
description: The YaST Team is back, one week later than expected but with as many exciting
  news as usually
permalink: blog/2021-03-02/sprint-118
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It has been three weeks since the previous development report from the YaST Team. That's one week
more than our usual cadence, since most of the team was booked during four days in an internal SUSE
workshop. But fear no more, we are back and loaded with news as usual. This time we bring:

  - Support to enable and configure SELinux during installation
  - A revamped interface for configuring wireless network devices
  - Usability improvements in several areas
  - A new "hidden level" in the installer with advanced tools ;-)

You may know that both the SUSE and openSUSE families of operating systems include
some container-oriented members, known as MicroOS. In order to make them even more awesome, we got
the request to make possible to propose and configure the usage of [Security-Enhanced
Linux](https://en.wikipedia.org/wiki/Security-Enhanced_Linux), more widely known as SELinux, during the
(auto)installation. This is a complex change affecting several parts of YaST and various versions
of (open)SUSE, but you can get a good overview in the description of [this pull
request](https://github.com/yast/yast-installation/pull/906) which includes some screenshots that
may be worth a thousand words. Right now, the feature may look different on each one of the
distributions due to the different state of SELinux on them. While in SLE MicroOS the new setting is
visible during installation and activated at its more restrictive level, in others it may look more
permisive or even not be presented at all. We expect things to consolidate during the upcoming
weeks.

And talking about things that take their time, for a long time we had wanted to improve the
usability of the configuration of wireless network adapters. Finally we found the time to reorganize
the corresponding tab in the YaST Network module, improving the mechanism to select a wireless
network and automatically pre-filling as much information as possible. You can see the result in the
following animation and in the [detailed pull request](https://github.com/yast/yast-network/pull/1164)
with the usual before-and-after screenshots.

{% include blog_img.md alt="The new wireless configuration in action"
src="wireless.gif" full_img="wireless.gif" %}

That's not the only usability improvements we implemented during this sprint. Now the Partitioner
offers more useful information about file-systems that need to be [unmounted in
advance](https://github.com/yast/yast-storage-ng/pull/1204) and presents a more sensible [initial
state](https://github.com/yast/yast-storage-ng/pull/1207) for the collapsable branches in its
tables. YaST Network permits to [tweak the virt bridge
interface](https://github.com/yast/yast-network/pull/1137) during manual installation and reports
AutoYaST errors [more nicely](https://github.com/yast/yast-network/pull/1166). Last but not least in
the usability field, we improved how long texts are [managed and
presented](https://github.com/yast/yast-yast2/pull/1122) in most YaST pop-up dialogs.

If you are still not impressed with all the new things this sprint brought, we can give you a
sneak peak on something we have been preparing lately to give power-users more... er... power. ;-)
As you all know, YaST is already a pretty advanced installer offering many options. And it's very
configurable so it can be tweaked to behave differently depending on the distribution, the product
or the system role selected by the user. But believe it or not, we still face situations in which we
would like to configure the installer even more during its execution to overcome some obstacle found
in a very special scenario or just for debugging purposes. How do we plan to do it? Meet the new
YaST installation console, available through the even newer [installer configuration
screen](https://github.com/yast/yast-installation/pull/905)!

While we dive into the beta phase of openSUSE Leap 15.3 and SLE-15-SP3, the YaST Team will focus
during the next weeks in fixing the bugs found by the testers of those upcoming distributions, which
implies we cannot give you a fixed date for the next development report, but it will be for sure
during March. Meanwhile, stay tuned and do not hesitate to report any significant bug you can find
in YaST or in openSUSE in general. See you soon(ish)!

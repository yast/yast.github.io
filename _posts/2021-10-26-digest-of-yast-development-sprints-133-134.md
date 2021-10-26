---
layout: post
date: 2021-10-26 06:00:00 +00:00
title: Digest of YaST Development Sprints 133 & 134
description: An update including features and bug fixes, as well as news about internal refactoring
permalink: blog/2021-10-26/sprints-133-134
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

October is being a busy month for the YaST Team. We have fixed quite some bugs and implemented
several features. As usual, we want to offer our beloved readers a summary with the most interesting
stuff from the lastest couple of development sprints, including:

- Improved handling of users on already installed systems
- Progress in the refactoring of software management
- Better selection of the disk in which to install the operating system
- More robust handling of LUKS encrypted devices
- Fixes for libYUI in some rare cases
- Improvements in time zone management (affecting mainly China)

## Improved Handling of Users {#users}

Let us start by quoting our [latest report]({{site.baseurl}}/blog/2021-09-28/sprints-131-132):
"_regarding the management of users, we hope to report big improvements in the next blog post_".
Time has indeed come and we can now announce we brought the revamped users management described in
[this monographic blog post](https://yast.opensuse.org/blog/2021-06-28/sprint-126) to the last parts
of YaST that were still not taking advantage of the new approach. The changes are receiving an extra
round of testing with the help of the Quality Assurance team at SUSE before we submit them to
openSUSE Tumbleweed. When that happens, both the interactive YaST module to manage users and groups
and its corresponding command line interface (not to be confused with the ncurses-powered text mode)
will start using `useradd` and friends to manage users, groups and the related configurations.

There should not be big changes in the behavior apart from the improvements already mentioned in the
original blog post presenting the overall idea. But a couple of fields were removed from the UI to
reflect the current status:

  - The password for groups, which is an archaic and discouraged mechanism that nobody should be
    using in the era of `sudo` and other modern solutions.
  - The fields "Secondary Groups" and "Skeleton Directory" from the tab "Default for New Users",
    since those settings are either gone or not directly configurable in recent versions of
    `useradd`.

There is still a lot of room for improvements in YaST Users, but we will postpone those to focus on
other areas of YaST that need a similar revamping to the one done in users management.

## Refactoring Software Management {#software}

One of those areas that need a bit of love and would benefit from some internal restructuring is the
management of software, which goes much further than just installing and removing packages. We have
just started with such a refactoring and we don't know yet how far we will get on this round, but
you can already read about some of the things we are doing in the description of [this pull
request](https://github.com/yast/yast-packager/pull/580), although it only shows a very small
fraction of the full picture.

## New Features in the Storage Area {#storage}

We also improved the way YaST handles some storage technologies. First of all, we instructed YaST
about the existence of BOSS (Boot Optimized Storage Solution) drives in some Dell systems. From now
on, such devices will be automatically chosen as the first option to install the operating system,
as described in this [pull request with
screenshots](https://github.com/yast/yast-storage-ng/pull/1238). As a bonus for that same set of
changes, YaST will be more sensible regarding SD Cards.

On the other hand, we adapted the way YaST (or libstorage-ng to be fully precise) references LUKS
devices in the `fstab` file to make it easier for systemd to handle some situations. Check the
details in this other [pull request](https://github.com/openSUSE/libstorage-ng/pull/838) (sorry, no
screenshots this time).

## Fixes for libYUI {#libyui}

As usually revealed by our posts, YaST is full of relatively unknown features that were developed to
cover quite exceptional use-cases. Those characteristics remain there, used by a few users... and
waiting for a chance to attack us! During the recent sprints we fixed the behavior of libYUI (the
toolkit powering the YaST user interface) in a couple of rare scenarios. Check the descriptions of
[this pull request](https://github.com/libyui/libyui/pull/51) and [this other
one](https://github.com/libyui/libyui/pull/55) for more details.

## Fun with Flags... err Time Zones {#timezones}

For reasons everybody knows, being able to work from home and to coordinate information with people
from different geographical locations has become critical lately. That scenario has increased the
relevance of properly configured time zones in the operating system. And that made us realize the
time zones handled by YaST for China weren't fully aligned with international standards. This [pull
request](https://github.com/yast/yast-country/pull/284) explains what was the problem and how we
fixed it, so applications like MS Teams can work on top of (open)SUSE distributions just fine...
everywhere in the globe.

## That's All... Until we Meet Again {#closing}

As you know, YaST development never stops. And, although we only report the most interesting bits in
our blog posts, we keep working in many areas... from very visible features and bug fixes to more
internal refactoring. In any case, we promise to keep working and to keep you updated in future
blog posts. So stay tuned and have a lot of fun!

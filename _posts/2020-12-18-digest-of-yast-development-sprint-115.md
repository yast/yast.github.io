---
layout: post
date: 2020-12-18 10:00:00 +00:00
title: Digest of YaST Development Sprint 115
description: 2020 comes to an end, let's celebrate that with the last development report of the year
permalink: blog/2020-12-18/sprint-115
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The YaST Team has just finished the last sprint before the Christmas break of this convulted 2020.
So let's start the festivities by celebrating what we have achieved in the latest two weeks. That
includes:

- Several additions to AutoYaST
- Better management of required packages
- Usability improvements in the registration process
- Drop of the SysVinit support
- Translation infrastructure for the `wicked` Cockpit module

Let's go into the details.

You may remember that we recently introduced support in the YaST Partitioner for `tmpfs` mount
points and for Btrfs subvolume quotas. Now those technologies have been incorporated to AutoYaST.
See [this pull request](https://github.com/yast/yast-storage-ng/pull/1187) for some overview of
the `tmpfs` support or [this other one](https://github.com/SUSE/doc-sle/pull/726) if you want to
check the full documentation. If you are more curious about Btrfs subvolume quotas, check [this pull
request](https://github.com/yast/yast-storage-ng/pull/1186) for some general description with
screenshots or [the documentation one](https://github.com/SUSE/doc-sle/pull/724) for more
comprehensive information.

We also [improved how YaST manages the packages](https://github.com/yast/yast-storage-ng/pull/1188)
to install in order to support the different storage technologies and file systems. During
installation, YaST now makes a difference between optional and mandatory packages, which implies it
will not longer force you to install `ntfsprogs` just because there is a leftover NTFS partition
somewhere in the system. Moreover, in an installed system YaST only forces installation of those
packages strictly needed to perform the Partitioner actions, reducing to a minimum the number of
repository refresh operations triggered by the Partitioner.

Regarding the registration process during the installation of SLE (SUSE Linux Enterprise), we have
been working in a couple of fronts:

- More informative and up-to-date information about the [implications of skipping
  registration](https://github.com/yast/yast-registration/pull/525) when performing a so-called
  online installation.
- Some experiments ([still under discussion](https://github.com/yast/yast-registration/pull/519))
  regarding the layout of the registration screen.

In a more general scope, we removed some bits of code in YaST that were still trying to modify
the obsolete `/etc/inittab`. file. See [the
announcement](https://lists.opensuse.org/archives/list/yast-devel@lists.opensuse.org/thread/Z7UEPCVAIKI6XCDWKCT3QX675UIUQZ7L/)
in the yast-devel mailing list about the definitve drop of support for SysVinit.

Going beyond YaST itself, we added internationalization support to our Cockpit module for `wicked`.
The [corresponding project](https://l10n.opensuse.org/projects/cockpit-wicked/) is now available in
the openSUSE Weblate instance and all the automation is in place to ensure all the translations
contributed by our awesome volunteers are incorporated into future releases of the module.

As mentioned at the beginning of the post, this was the last development sprint of 2020, which also
means this will be the last blog entry from the YaST Team this year. We will restart the usual
development (and reporting) pace after the Christmas and new year season. So there is only one more
thing left to say - see you in 2021!

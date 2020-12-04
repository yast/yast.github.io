---
layout: post
date: 2020-12-04 14:00:00 +00:00
title: Digest of YaST Development Sprint 114
description: Polishing the Cockpit Wicked module, better support for tmpfs...
permalink: blog/2020-12-04/sprint-114
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Fortunately, Christmas is around the corner and the year 2020 is coming to an end. But the YaST team
is not thinking about going on holidays yet. Quite the contrary, we have been working on a broad
range of topics as usual. So let's have a look at some of them.

### Polishing the Cockpit Wicked Module

At the end of the sprint, we released [a new
version](https://github.com/openSUSE/cockpit-wicked/releases/tag/2) of our [Cockpit Wicked
module](https://github.com/openSUSE/cockpit-wicked). This release does not include big changes but a
set of bug fixes and small improvements. Actually, at this point, we have decided to shift our focus
from adding features to polishing the module as much as possible.

{% include blog_img.md alt="Interfaces List" src="cockpit-wicked-unmanaged-interfaces-mini.png"
full_img="cockpit-wicked-unmanaged-interfaces.png" %}

As part of this new focus, we have asked our usability experts how to build a better user
experience. Additionally, we have started the process to make the module available for translation
in our [Weblate instance](https://l10n.opensuse.org/) to get it properly localized.

On the other hand, the initial research for the [Cockpit Transactional Update
module](https://github.com/lslezak/cockpit-transactional-update) is over. We are now working on
documenting our requirements to resume the development work soon.

### Better Support for tmpfs in the Partitioner

While introducing the new storage stack in SLE 15, we decided to drop support for creating *tmpfs*
entries in the `/etc/fstab` using AutoYaST. After all, *systemd* is already taking care of [handling
such file
systems](https://askubuntu.com/questions/1061265/tmp-in-tmpfs-how-do-this-only-with-systemd).
However, our users want this behavior back and we are now introducing proper handling in YaST for
*tmpfs* file systems.

As a first step, we added support in the partitioner to manage those entries. Please, beware that
YaST will only take care the devices listed in `/etc/fstab`. Any *tmpfs* file system created by
*systemd* or any other mechanism is out of our scope.

By the way, we already started to work on AutoYaST support, so stay tuned if you are one of those
users missing this feature.

### Open Discussion: Easy Way to Change Installer Settings

For quite some time, there has been a feature request to allow changing the installer settings at
runtime. However, we are still unsure how it should look and which use cases we should cover.

The discussion is still ongoing, but we have opened [a GitHub
issue](https://github.com/yast/yast-installation/issues/898) to discuss it further. So, if you feel
you can help, feel free to join the conversation.

### But That's Not All

As usual, we have been working on many more things. So let's select a few of them that you might find interesting:

* Fix detection of para-virtualized guests in Kdump
  ([yast-kdump#118](https://github.com/yast/yast-kdump/pull/118).
* Fix the product selection when using the full media
  ([yast-installation#895](https://github.com/yast/yast-installation/pull/895)).
* Move from Travis to [GitHub Actions](https://github.com/features/actions). It is still a work in
  progress, but the most relevant repositories have already been adapted. Check the [yast2
  repository](https://github.com/yast/yast-yast2/commit/54fb57cb742a01267ed00c91f25fdf9b618d7ec7) if
  you want to see an example.
* Better detection of Btrfs subvolumes prefix
  ([yast-storage-ng#1168](https://github.com/yast/yast-storage-ng/pull/1168)).

### What's next?

We have just started the last sprint of 2020. We will slow down our work around our Cockpit modules
because we feel that it is time to listen to others to decide what's next. But we plan to work on
many different things, like the storage layer, LibYUI, the installer reconfiguration feature... So
if you are curious about what we can achieve during this sprint, let's meet here in around two
weeks.

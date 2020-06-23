---
layout: post
date: 2020-06-23 08:00:00 +00:00
title: Digest of YaST Development Sprint 102
description: It's time for another development digest from The YaST team. As usual, the range
  of topics is quite broad.
category: SCRUM
permalink: blog/2020-06-23/sprint-102
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It's time for another development digest from The YaST team. As you can see in the following list
of highlights, the range of topics is as broad as usual. 

- [Validation of the AutoYaST profile at the beginning of the
  installation](https://github.com/yast/yast-autoinstallation/pull/624) (see
  screnshot below).
- [More robust and complete support for AutoYaST's user
  scripts](https://github.com/yast/yast-autoinstallation/pull/612).
- Improvements in AutoYaST error handling and reporting. See the [documentation pull
  request](https://github.com/yast/yast-autoinstallation/pull/625) for details.
- [Improved handling of systemd services in some corner
  cases](https://github.com/yast/yast-yast2/pull/1059).
- [Better detection](https://github.com/yast/yast-yast2/pull/1062) and [more accurate boot
  check](https://github.com/yast/yast-storage-ng/pull/1102) for XEN guests.
- [More explanatory labels in repositories management during
  upgrade](https://github.com/yast/yast-installation/pull/863).
- [Compatibility of Snapper rollbacks with transactional
  servers](https://github.com/openSUSE/snapper/pull/540).
- [Better management of automatic text wrapping in
  LibYUI](https://github.com/libyui/libyui/pull/165).

{% include blog_img.md alt="AutoYaST profile validation"
src="autoyast-validation-300x225.png" full_img="autoyast-validation.png" %}

As you can see, we have invested quite some effort improving some areas of AutoYaST. In the process,
we found ourselves over and over typing complicated URLs in the boot parameters of the installer to
access some manually crafted AutoYaST profile. To avoid the same pain in the future to other testers
or to anyone interested in taking a quick look to AutoYaST, we are working in an easy-to-type
repository of generic AutoYaST profiles. See more details in [this
announcement](https://lists.opensuse.org/yast-devel/2020-06/msg00027.html) in the yast-devel mailing
list.

The next development sprint has already started, so we hope to see you again in approximately two
weeks with more news about (Auto)YaST... unless you are too busy celebrating the release of openSUSE
Leap 15.2, expected for July 2nd!

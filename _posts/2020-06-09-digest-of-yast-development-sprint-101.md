---
layout: post
date: 2020-06-09 08:00:00 +00:00
title: Digest of YaST Development Sprint 101
description: As explained in our previous blog post, this YaST development
  report is presented as a collection of links to Github's pull requests
category: SCRUM
permalink: blog/2020-06-09/sprint-101
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

As explained in [our previous blog
post]({{site.baseurl}}/blog/2020-05-29/sprint-99-100), this YaST development
report is presented as a collection of links to rather descriptive Github's
pull requests. With that, our readers can deep into the particular topics they
find interesting.

- [Added F8 shortcut to switch installation to
  Chinese](https://github.com/openSUSE/gfxboot/pull/46)
- [Linuxrc support for `$releasever` in repository
  URLs](https://github.com/openSUSE/linuxrc/pull/224) (see more details at the
  [corresponding section](https://en.opensuse.org/SDB:Linuxrc#Parameter_Reference)
  of the Linuxrc reference)
- [Fixed some problems when the user rejects the license of some SLE
  addon](https://github.com/yast/yast-registration/pull/494)
- [Improvements in the AutoYaST command
  line](https://github.com/yast/yast-autoinstallation/pull/622)
- [Fixed `xmllint` messages for invalid AutoYaST
  profiles](https://github.com/yast/yast-schema/pull/77)
- [Do not propose insecure signature settings in
  AutoYaST](https://github.com/yast/yast-autoinstallation/pull/618)
- [In case of online medium, perform AutoYaST network configuration
  earlier](https://github.com/yast/yast-autoinstallation/pull/617)

Of course, that's not a full list of all the pull requests merged into the YaST
repositories during the sprint, just a selection of the most interesting ones.

Additionally, the YaST Team also invested quite some time researching all
the new concepts introduced by systemd regarding filesystem management and
investigating several aspects of the current implementation of AutoYaST. We
have no concrete links for the results of such researchs, but you will see the
outcome soon in form of upcoming changes in (Auto)YaST.

Enjoy the links and see you again in two weeks!

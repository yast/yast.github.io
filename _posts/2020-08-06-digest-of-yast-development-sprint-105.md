---
layout: post
date: 2020-08-06 08:00:00 +00:00
title: Digest of YaST Development Sprint 105
description: During the latest two weeks the YaST Team has fixed quite some bugs in (Auto)YaST, but
  we also has done more interesting stuff. Check what's new.
category: SCRUM
permalink: blog/2020-08-06/sprint-105
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Although a significant part of the YaST Team is enjoying their well deserved summer vacations, the
development wheel keeps turning. During the latest two weeks we have fixed quite some bugs in several
parts of (Auto)YaST. But listing fixed bugs it's quite boring, so let's focus on more interesting
stuff we have also achieved.

- Fetching the AutoYaST profile during installation can be a complex process, as a first step to
  simplify that, we have [documented the current
  handling](https://github.com/yast/yast-autoinstallation/pull/661) of the profile.
- Talking about simplicity, we [removed an undocumented AutoYaST
  feature](https://github.com/yast/yast-autoinstallation/pull/660/files) for creating images.
- We implemented a couple of improvements regarding I/O devices auto-configuration on s390: now
  [Linuxrc persists the setting to the installed system](https://github.com/openSUSE/linuxrc/pull/225)
  and the [installation proposal allows to tune it](https://github.com/yast/yast-installation/pull/873).
- AutoYaST cloning was also improved and the firewall section can now be exported in compact format.
  That is, including [only the modified zones](https://github.com/yast/yast-firewall/pull/134).
- We achieved a [small reduction](https://github.com/openSUSE/installation-images/pull/399) in the size
  of the system images used to run the installer.
- As a side result, the documentation of `mk_image` received a [significant
  update](https://github.com/openSUSE/installation-images/pull/398).
- We fixed several aspects of the Service Manager section of the AutoYaST UI. See the pull requests:
  [[1]](https://github.com/yast/yast-services-manager/pull/202),
  [[2]](https://github.com/yast/yast-services-manager/pull/203),
  [[3]](https://github.com/yast/yast-services-manager/pull/204).
- We also made sure YaST can [deal with the dual location](https://github.com/yast/yast-pam/pull/20) of
  `/usr/etc/nsswitch.conf` and `/etc/nsswitch.conf`.
- Last but not least, we unified the layout for the installer and YaST Firstboot, making both more
  configurable in the process. See the [related
  documentation](https://github.com/yast/yast-installation/blob/master/doc/control-file.md#look--feel)
  and some screenshots.

YaST Firstboot with the layout `steps` and active banner (the SUSE logo).
{% include blog_img.md alt="Firstboot with steps and banner"
src="firstboot_step_banner_360x300.png" full_img="firstboot_step_banner.png" %}

YaST Firstboot with the layout `title-on-top` and also active banner.
{% include blog_img.md alt="Firstboot with title on top and banner"
src="firstboot_banner_360x300.png" full_img="firstboot_banner.png" %}

YaST Firstboot with the layout `title-on-left` and without banner.
{% include blog_img.md alt="Firstboot with title on top and banner"
src="firstboot_side_title_360x300.png" full_img="firstboot_side_title.png" %}

As you can imagine, more combinations are possible.

As summer continues in Europe, we hope to bring you more refreshing news in two weeks. Meanwhile,
try the new features and have a lot of fun!

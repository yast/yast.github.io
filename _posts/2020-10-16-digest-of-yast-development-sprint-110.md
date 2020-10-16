---
layout: post
date: 2020-10-16 05:00:00 +00:00
title: Digest of YaST Development Sprint 110
description: The team has worked on a wide range of topics, including important
  improvements to LibYUI, new installer features and addressing several bugs.
category: SCRUM
permalink: blog/2020-10-16/sprint-110
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

In this sprint, the YaST Team has been working on a wide range of topics. You can find more details
in this list that we have prepared for you:

- Support for [nested items](https://github.com/libyui/libyui/pull/171) in LibYUI tables. If you are
  interested in the gory details of the `ncurses` based implementation, you might find the
  [libyui-ncurses: The Scary
  Widgets](https://github.com/shundhammer/libyui-ncurses/blob/huha-tree-table-01/doc/nctable-and-nctree.md)
  rather interesting and informative.
- [Document and improve the detection of unsupported
  scenarios](https://github.com/yast/yast-sudo/pull/26) in `yast2-sudo`. We have also been
  discussing the future of the module: some of its features could be integrated into other modules
  (like `yast2-users`), instead of keeping a dedicated one.
- Allow vendor change when migrating from openSUSE Leap to SUSE Linux Enterprise (and vice versa) or
  from Leap to Jump. This feature required the team to adapt several packages:
  [yast2-update](https://github.com/yast/yast-update/pull/156),
  [yast2-pkg-bindings](https://github.com/yast/yast-pkg-bindings/pull/138),
  [yast2-installation-control](https://github.com/yast/yast-installation-control/pull/102) and
  [skelcd-control-openSUSE](https://github.com/yast/skelcd-control-openSUSE/pull/218).
- Preliminary work on supporting subvolumes quotas, including the [design of the
  API](https://github.com/yast/yast-storage-ng/pull/1150).
- Prevent the user to [accidentally disable the SSH
  access](https://github.com/yast/yast-firewall/pull/137) when SSH key-based authentication is
  configured.
- [Better handling of the hostname](https://github.com/yast/yast-network/pull/1114) when it is set
  via DHCP.
- [Do not try to install the `xorg-x11` package](https://github.com/yast/yast-packager/pull/538)
  anymore, as it is an empty package. It fixes a problem when trying to install the system using
  VNC.

{% include blog_img.md alt="Nested Items in Tables"
src="libyui-nested-items-300x208.png" full_img="libyui-nested-items.png" %}

As usual, we are already working on the following sprint. We will publish another report, including
some interesting details in roughly two weeks. Until now, stay tuned and have a lot of fun!

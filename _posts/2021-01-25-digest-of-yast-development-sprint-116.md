---
layout: post
date: 2021-01-25 10:00:00 +00:00
title: Digest of YaST Development Sprint 116
description: The new year comes with more news from the YaST development team, check them out!
permalink: blog/2021-01-25/sprint-116
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

2021 is here and it doesn't look like it's going to be a boring year... at least in the YaST side!
The YaST team just restarted the work a couple of weeks ago and we already have some development
news to share with you, including some improvements our users requested through the openSUSE's
[End of the Year Community
Survey](https://news.opensuse.org/2021/01/07/opensuse-community-publishes-end-of-year-survey-results/).

- Writing NetworkManager configuration during system installation
- Refining the mechanism to reuse existing EFI partitions
- Using more stable and consistent names to reference devices in the bootloader
- Improving AutoYaST behavior when no product has been specified
- Updating the roles offered by yast2-vm
- Many more small improvements here and there

Let's start with an installer improvement quite some people was waiting for. Both openSUSE and SUSE
Linux Enterprise can use either `wicked` or NetworkManager to handle the system's network
configuration. Only the former can be fully configured with YaST (which is generally not a problem
because there are plenty of tools to configure NetworkManager). Moreover, during the standard
installation process, `wicked` is always used to setup the network of the installer itself.  If the
user decides to rely on `wicked` also in the final system, then the configuration of the installer
is carried over to it. But, so far, if the user opted to use NetworkManager then the installer
configuration was lost and the network of the final system had to be be configured again using
NetworkManager this time. [Not anymore](https://github.com/yast/yast-network/pull/1149)!

That's not the only installer behavior we have refined based on feedback from our users. In some
scenarios, the logic used to decide whether an existing EFI System Partition (ESP) could be reused
was getting in the way of those aiming for a fine-grained control of their partitions. That should
now be fixed by the changes described in [this pull
request](https://github.com/yast/yast-network/pull/1149), that have been already submitted to
Tumbleweed and will be part of the upcoming releases (15.3) of both openSUSE Leap and SLE.

We also fine-tuned how hibernation is configured during installation. To be precise, we improved the
corresponding `resume=` parameter passed to the kernel by the bootloader. From now on, that
parameter will use a device name that will be [fully
consistent](https://github.com/yast/yast-bootloader/pull/628) with the names used in other parts of
the installer and that will be often [based on the swap
UUID](https://github.com/yast/yast-storage-ng/pull/1192).

As usual, AutoYaST also got its quota of love during this sprint. This time on form of an usability
improvement. As you may know, SUSE Linux Enterprise offers a whole set of products for different
needs. When using AutoYaST to upgrade a system using a multiproduct repository, it's necessary to
specify the concrete product in the AutoYaST profile. When that was not correctly done, the system
failed in a not-exactly-elegant way. In upcoming versions of products of the SLE family, that will
be handled [in a much nicer way](https://github.com/yast/yast-autoinstallation/pull/724).

{% include blog_img.md alt="AutoYaST error for missing product"
src="autoyast-no-product-mini.png" full_img="autoyast-no-product.png" %}

And apart from the installation and auto-installation process, we also introduced several small
fixes and improvements in other parts of YaST. Like bringing up-to-date the [options offered by
yast2-vm](https://github.com/yast/yast-vm/pull/50), speeding up the process of reading the [network
devices in s390 mainframes](https://github.com/yast/yast-network/pull/1150), improving the usability
when [the hostname needs to be adapted](https://github.com/yast/yast-network/pull/1134)... and many
other things you can check in Github or the Open Build Service if you want to know more.

As you can see, the new year has not diluted our enthusiasm to keep improving YaST bit by bit.
So now it's time to go back to work, hoping to meet you again in a couple of weeks with more news.
Have a lot of fun!

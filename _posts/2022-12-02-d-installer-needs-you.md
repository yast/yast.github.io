---
layout: post
date: 2022-12-02 06:00:00 +00:00
title: D-Installer needs your help
description: D-Installer development moves forward... but some things could be better
permalink: blog/2022-12-02/d-installer-needs-you
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Now that the headline got your attention, let's start with the good news - D-Installer development
is progressing just fine. What's the matter then? To answer that question is important to make a
difference between D-Installer itself and the live ISO image we provide for everyone to test it.
So let's break this post into sections.

## New Prototype of D-Installer Available for Testing {#dinstaller}

As you all know, [D-Installer](https://github.com/yast/d-installer) is a new application being
developed by the YaST Team that will allow to install any (open)SUSE operating system into any
virtual or physical machine. It can be controlled via a D-Bus API, a command-line interface or a
modern web front-end. It can run directly on top of any Linux system and can also be executed as a
container. So you can run D-Installer using the live ISO we provide for testing or you could use it
from your currently installed Tumbleweed (eg. to install Leap Micro in another disk) or even as a
container on top of [Iguana](https://github.com/aaannz/iguana).

{% include blog_img.md alt="D-Installer" src="general-mini.png" full_img="general.png" %}

Today we published a new prototype of D-Installer fixing several bugs reported by early testers
and improving the usage experience in some areas like the configuration of passwords and users.
But beyond those improvements, there are a couple of new features that deserve some attention.

The most visible change is the new screen to configure the storage setup. It's the first step
towards the vision [we
documented](https://github.com/yast/d-installer/blob/master/doc/storage_ui.md) a couple of months
ago. Functionality-wise it brings the ability to install the system using LVM ([Logical Volume
Manager](https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux))) and/or full-disk
encryption. The exact type of encryption depends on the operating system being installed. For the
prototype of ALP ContainerHost, D-Installer will use LUKS2 adjusting some settings to ensure
everything works with the provided version of GRUB. The usage of LUKS2 opens the door for future
possibilities, like unlocking the encrypted devices on boot using the system's TPM ([Trusted Platform
Module](https://en.wikipedia.org/wiki/Trusted_Platform_Module)) instead of entering a passphrase.

{% include blog_img.md alt="LVM and encryption" src="lvm-enc-mini.png" full_img="lvm-enc.png" %}

Beware the new screen comes also with some other changes. When making space for the new operating
system into the selected disk, previous versions of D-Installer mimicked some default behaviors of
YaST like trying to keep alive as many partitions as possible or reusing existing LVM
structures. That's not the case anymore. We plan to implement a user interface to decide exactly
what to delete, keep or resize. But in the meantime **D-Installer will go full throttle and delete
all previous content in the chosen disk**. You have been warned. :wink:

Another relevant improvement is the ability to properly configure the boot loader on AArch64
systems. Previous prototypes messed up the selection of GRUB-related packages on non-x86 systems,
but now D-Installer is more capable of handling different hardware architectures. At the YaST Team
we don't have that many different Aarch64 systems at hand, so we would really appreciate any help
testing whether this works consistently. You can do it by grabbing the `aarch64` version of the
testing live ISO... which leads us to our next topic.

## The D-Installer Testing ISO Image {#image}

As you already know, the most convenient way of testing the prototypes of D-Installer is using the
already mentioned [live ISO images](https://github.com/yast/d-installer#live-iso-image) we
constantly build with the latest development version of D-Installer. But, to be honest, we don't
have that much time (or knowledge) to invest on those images and there is a lot of room for
improvement.

First of all, almost 1 GiB is clearly too much for an image that doesn't even include the
packages of the operating systems to be installed (everything is fetched from online repositories).
Beyond the size of the ISO, running X11 and Firefox may not be the most memory-efficient way to
connect to a local web interface. There is already an [open
issue](https://github.com/yast/d-installer/issues/341) suggesting alternative components and
approaches, but it's something that can hardly be addressed by the YaST Team in the short term.

Talking about the graphical environment and the web browser. There is actually no need to run them
unconditionally when the system boots, like our current live image does. Adding some modularity to
the boot process of the image could result in a much smaller memory footprint in scenarios in which
the installation process is driven from another device or from the command-line interface.

Moreover, since our live ISO is just an slightly customized version of openSUSE Tumbleweed we are
suffering the consequences of some performance problems present in the latest versions. We reported
the problem as [bug#1205938](https://bugzilla.suse.com/show_bug.cgi?id=1205938) and we really need
some way to fix it or to work around it. The slowdown described at that bug report can completely
ruin the overall experience of using the D-Installer live ISO image.

## Join the Fun {#conclusion}

The future looks pretty bright for D-Installer now that the general infrastructure is set and we can
keep adding all the currently missing features reusing the power of YaST. So please join us in the
adventure.

Of course, the easiest way to contribute is by testing the new release and giving us your valuable
constructive feedback, so we can keep evolving the current prototype. Additionally, it would be great
if you could help to improve the current testing live ISO image or to fix the mentioned performance
issue at Tumbleweed. We would also welcome any kind of support in the area of containerization and
Iguana.

In all cases, and for any other matter, you know [where to find
us](https://github.com/yast/d-installer/blob/master/CONTRIBUTING.md)!

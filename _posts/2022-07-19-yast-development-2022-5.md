---
layout: post
date: 2022-07-19 06:00:00 +00:00
title: YaST Development Report - Chapter 5 of 2022
description: People do not live by YaST alone
permalink: blog/2022-07-19/yast-report-2022-5
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

We have been a bit silent lately in this blog, but there are good reasons for it. As you know, the
YaST Team is currently involved in many projects and that implies we had to constantly adapt the way
we work. That left us little time for blogging. But now we have reached enough stability and we hope
to recover a more predictable and regular cadence of publications.

So let's start with this post including:

- Some notes about the new scope of the blog
- The announcement of D-Installer 0.4
- A brief introduction to Iguana, a container-capable boot image
- Progress on containerized YaST
- Some Cockpit news

## Adjusting the Scope {#reorganization}

As you know, SUSE is developing the next generation of the SUSE Linux family under the code-name ALP
(Adaptable Linux Platform). If you are following the activity in that front, you also know several
so-called [work groups](https://en.opensuse.org/openSUSE:ALP/Workgroups) has been constituted to
work on different areas.

The YaST Team is deeply involved on two of those work groups, the ones named "1:1 System
Management" and "Installation / Deployment". You can read more details about the mission of each
group and the technologies we are developing in the wiki page linked at the previous paragraph.

Since this blog is a well-established communication channel with the (open)SUSE users, we
decided we will use it to report the progress on all the projects related to those work groups. That
goes beyond the scope of YaST itself and even beyond the scope of the YaST Team, since the mentioned
work groups also include other SUSE and openSUSE colleages. But we are sure our readers will equally
enjoy the content.

## D-Installer Reaches Version 0.4 {#dinstaller}

Let's start with an old acquaintance of this blog. In several previous posts we have already
described D-Installer, our effort to expose the power of YaST through a more reusable and modern set
of interfaces. We recently reached an important milestone in its development with the
first version including a multi-process architecture. In previous versions, the user interface
could not respond to user interaction if any of the D-Installer components was busy (reading
the repositories metadata, installing packages, etc.). The new D-Installer v0.4 includes the first
steps to definitely solve that problem and also other interesting features you can check at this
[release announcement](https://github.com/yast/d-installer/pull/223). There are even a couple of
videos to see it in action without risking your systems!

As you can see in the first of those videos, we improved the product selection screen and now
D-Installer can download and install Tumbleweed, Leap 15.4 or Leap Micro 5.2.

But a new YaST-related piece of software cannot be really considered as fully released until it is
submitted to openSUSE Tumbleweed. We plan to do that in the upcoming days, to ensure future
development of D-Installer remains fully integrated with our beloved rolling distribution.

## A New Reptile in the Family {#iguana}

Of course, D-Installer needs to run on top of a working Linux system. That could be the openSUSE
LiveCD (as we do to test the prototypes) or some kind of minimal installation media. What if that
minimal system is just a container completely tailored to execute D-Installer? It could work as
long as you have a certain `initrd` (ie. boot image) with the capability of grabbing and executing
containers. Say hello to
[Iguana](https://en.opensuse.org/openSUSE:ALP/Workgroups/Installation/Iguana).

Iguana is at an early stage of development and we cannot guarantee it will keep its current form or
name, but it's already able to boot on a virtual machine (and likely on real hardware) and execute a
predefined container. We tried to run a containerized version of D-Installer and it certanly works!
We plan to evolve the concept and make Iguana able to orchestrate several containers, which will
give us a very flexible tool for installing or fixing a system in all kind of situations.

## Progress on Containerized YaST {#yast}

Just as we are looking into D-Installer as a way to reuse the YaST capabilities for system
installation, you know we are also looking into containerization as a way to expand the YaST scope
regarding system configuration. And we also have some news in that front.

First of all, we adapted more YaST modules to make them work from a container. As a result, you can
now access all this functionality:

- Configuration of timezone, keyboard layout and language
- Management of software and repositories
- Firewall setup
- Configuration of iSCSI devices (iSCSI LIO target)
- Management of system services
- Inspection of the systemd journal
- Management of users and groups
- Printers configuration
- Administration of DNS server

We are working on adapting more YaST modules as we write this. We hope to soon add boot-loader or
Kdump configuration to the portfolio. Maybe even the YaST Partitioner if everything goes fine.

On the other hand, we restructured the container images to rely on [SLE
BCI](https://www.suse.com/products/base-container-images/), which results on smaller and better
supported images. But that was just a first step, we are now actively working on reducing the size
of the current images even further. Stay tuned for more news and some numbers.

## Cockpit with a Green Touch {#cockpit}

Although using a containerized version of YaST will always be an option. Is expected that the main
tool for performing interactive administration of an individual ALP host will be Cockpit. So we
are also investing on improving the Cockpit experience on (open)SUSE systems. And nothing gives a
better experience that a properly green user interface!

We improved the theming support for Cockpit (in an unofficial way, not adopted by upstream) and used
that new support to make it look better thanks to the new
[`cockpit-suse-theme` package](https://build.opensuse.org/package/show/openSUSE:Factory/cockpit-suse-theme).

{% include blog_img.md alt="A nicely green Cockpit"
src="cockpit-mini.png" full_img="cockpit.png" %}

We took the opportunity to update the version of all Cockpit packages available at openSUSE
Tumbleweed. So if you are a Tumbleweed user, it's maybe a good time to give a first try to Cockpit!

## I'll Be Back! {#closing}

As mentioned at the beginning of this post, we want to get back to the good habit of posting regular
status updates, although they will not longer be so focused around (Auto)YaST. In exchange you will
get news about Cockpit, D-Installer, Iguana and containers. So stay tuned for more fun!

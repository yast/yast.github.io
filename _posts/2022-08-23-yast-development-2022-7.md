---
layout: post
date: 2022-08-23 06:00:00 +00:00
title: YaST Development Report - Chapter 7 of 2022
description: The YaST Team offers some preview of features that will soon land in the installer and
  also a look on the progress of some ALP-related topics.
permalink: blog/2022-08-23/yast-report-2022-7
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Lately in this blog we have been covering mostly developments in the area of ALP (Adaptable Linux
Platform), although we never stopped improving how YaST works on our currently maintained systems.
In this report we will start by taking a look to an installer feature we plan to release soon for
openSUSE Tumbleweed and also as a maintenance update for the current versions of Leap and SUSE Linux
Enterprise. Of course, that will not stop us from offering you a sneak peek about the mid-term
future. The whole menu includes:

- Presenting the new mechanism to validate security policies during installation
- An announcement of the official YaST container images
- Some reports about the current state on ALP of both Cockpit and YaST
- An update on the development of Iguana and D-Installer

## Security Policies in the Installer {#policies}

We all know there is a series of good practices that must be observed when installing and
administering any computer system in order to minimize the security hazards. In some cases, those
good practices are formalized into a so-called security policy that defines the guidelines that must
be observed in order for a given system to be accepted in a secure environment. In that regard, the
[DISA](https://www.disa.mil/) (Defense Information Systems Agency) and SUSE have authored a STIG
(Secure Technical Implementation Guide) that describes how to harden a SUSE Linux Enterprise system.

The STIG is a long list of rules, each containing description, detection of problems and how to
remediate problems on a per rule basis. There are even some tools to automate the detection and
remediation of many of the problems in an already installed systems. But some aspects are very hard
to correct if they are not properly set during the installation process of the operating system,
like the need of encrypting all the relevant filesystems or honoring certain restrictions in how
the devices are formatted and the mount points are defined.

So we are actively working on adding the concept of security policies to both the [interactive
installation](https://github.com/yast/yast-security/pull/128) and
[AutoYaST](https://github.com/yast/yast-autoinstallation/pull/845). It is still a work in progress and
we will offer a more detailed review of the feature when it's ready to hit the repositories.

{% include blog_img.md alt="The installer checking the DISA STIG"
src="policy-mini.png" full_img="policy.png" %}

## Official YaST Container Images {#containers}

On other news, you know we have been working on making possible to execute YaST as a container. So far,
it was necessary to execute a script in order to use the containerized version of YaST. It was even
available as a package on openSUSE Tumbleweed. But now, with the recent advances on ALP and its
concept of so-called workloads, we found a better way to distribute the YaST containers.

We have now three "official" containers for YaST. available at the repository
[SUSE:ALP:Workloads](https://build.opensuse.org/project/show/SUSE:ALP:Workloads). Although the
repository, as the name suggests, is supposed to provide containerized workloads to be executed on
top of ALP, we have decided it will be the official source for containerized YaST no matter if you
execute it on top of ALP, the latest SLE, the latest Leap or openSUSE Tumbleweed. It should work the
same in all cases.

So from now on, you can execute a containerized YaST anywhere by doing:

```
podman container runlabel run 
registry.opensuse.org/suse/alp/workloads/tumbleweed_containerfiles/suse/alp/workloads/yast-mgmt-ncurses:latest
```

Replace "ncurses" by "qt" or "web" to enjoy the alternative versions.

The route is a bit redundant and maybe it will change in the future, but that's out of the control of
the YaST Team. In any case, we will always use the official repository for ALP workloads.

For more details, see the [full
announcement](https://lists.opensuse.org/archives/list/yast-devel@lists.opensuse.org/thread/WO5VKF57SCUBTQIYZKI34TJXUOUQBAZ7/)
at the archive of the `yast-devel` mailing list.

Additionally, we are also proud of remarking that those container images include the YaST Kdump and
YaST Bootloader modules. We recently adapted them to work containerized, which we consider an
important milestone because it implies libstorage-ng is now able to perform a system analysis of the
running host system from a container.

## YaST on ALP {#yast}

As you know, the main motivation to containerize YaST was making it available to ALP users. But
ALP is a new concept in Linux distributions with an innovative approach to some areas of system
management. So we didn't expect YaST, containerized or not, to just work smooth out-of-the-box on
top of ALP. Thus, we are doing a continuous evaluation of the situation in the early previews of ALP
to detect the areas of YaST (or even ALP itself) that need fixing and to decide where to put the
focus on every given moment.

The good news is that most things seems to work in the non-transactional variant of ALP. We only
detected small problems that we are now tracking and will fix step by step as time permits.

But on transactional ALP systems, which likely will be the default version in most scenarios, we
have a very visible problem with software installation. YaST does not use static RPM dependencies
to enforce beforehand the installation of the tools it relies on. Instead, YaST installs any needed
software on demand during its execution. That's a problem in a transactional system, as defined by
ALP or [openSUSE MicroOS](https://microos.opensuse.org/). On the bright side, we checked that
working-around the software installation problem, most of the other functionality works just fine
also in a transactional ALP system with the only exception of the previously mentioned YaST Kdump
and YaST Bootloader. Although those two modules work fine containerized in any non-transactional
system, we still need to find a way for them in situations in which `/boot` is not directly
writeable.

In short, things look relatively promising for YaST on ALP, but we still need to do a lot of
adjustments here and there. We will keep you informed of the progress.

## What About Cockpit? {#cockpit}

As already mentioned, ALP is an innovative system and that not only affects YaST. Cockpit, the
default platform for 1:1 system administration on ALP, also struggles with some of the
particularities of the first prototypes of ALP, especially in its transactional flavor.

Thus, we are also investing quite some time testing all the Cockpit functionality on ALP and
documenting which parts need tweaking... or even rethinking the Cockpit or the ALP approaches to some
topics. As with the YaST case, we are already working on some aspects and we will keep you informed
as long as we solve every existing problem.

## Moving Forward with Iguana and D-Installer {#installer}

Talking about ALP, you know we are using it as an opportunity to rethink how the (open)SUSE systems
may be installed in the future on real hardware with complex requirements in terms of storage
technologies, network setup, etc. In that regard, we keep developing D-Installer and Iguana.

In the case of the former, most recent news are about the internal architecture. You may remember
from previous reports that we are trying to make D-Installer as modular as possible with separate
processes to handle software management, creation of users, internationalization, etc. To make that
mechanism more powerful, we defined now a D-Bus API so the different processes can interact with the
user from a centralized user interface. See more details in the [corresponding pull
request](https://github.com/yast/d-installer/pull/231).

In the case of Iguana we are focusing of expanding its scope (eg. making it useful in the
context of
[Saltboot](https://www.uyuni-project.org/uyuni-docs/en/uyuni/specialized-guides/salt/salt-formula-saltboot.html))
and [documentation](https://github.com/aaannz/iguana). The Iguana Orchestrator
([iguana-workflow](https://github.com/aaannz/iguana-workflow)) now comes with some examples for
possible uses like running D-Installer as a set of two separate containers, one for the back-end and
another for the web interface. If you want to run you own experiments, installing the 
`iguana` [package from OBS](https://build.opensuse.org/package/show/home:oholecek/iguana) will
install a kernel and `iguana-initrd`, which then can be used for PXE boot or for direct kernel boot
in virtual machines.

## More to come {#closing}

As you can see, we are actively working on many areas. So we hope to have all kind of news for you
in the next report. Meanwhile, we hope you got enough to keep you interested. Keep having
a lot of fun!

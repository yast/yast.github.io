---
layout: post
date: 2022-05-03 10:11:12 +00:00
title: YaST Development Report - Chapter 3 of 2022
description: Time for another regular status update from the YaST team, with news about YaST itself
  and D-Installer
permalink: blog/2022-05-03/yast-report-2022-3
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

These last few weeks have been very intensive days in the YaST team. Significant changes are coming to the SUSE and openSUSE worlds. Have you heard about [SUSE ALP](https://lists.opensuse.org/archives/list/project@lists.opensuse.org/thread/N6TTE7ZBY7GFJ27XSDTXRF3MVLF6HW4W/) (Adaptable Linux Platform)? We are taking part of quite some discussions, research and workgroups. But, of course, we continue hardly working in YaST and in our D-Installer side project. So, let's go with a summary of the most interesting features and fixes.

## One-click migration

Since openSUSE Leap 15.3, [binary rpms are shared](https://en.opensuse.org/Portal:Leap/FAQ/ClosingTheLeapGap) between SUSE Linux Enterprise Server 15 and Leap. Closing the gap between openSUSE and SUSE makes feasible the migration from openSUSE Leap to SUSE SLE without reinstalling the system completely. [Migrating the system](https://en.opensuse.org/SDB:How_to_migrate_to_SLE) takes some steps, and sometimes manual intervention is required when the migration goes wrong. Now, YaST offers [a new client](https://github.com/yast/yast-migration-sle) that simplifies the migration process from openSUSE Leap to SUSE SLE, allowing to rollback the system if case that something fails.

## Systemd and YaST services

YaST provides three systemd services: YaST2-Firstboot.service, YaST2-Second-Stage.service and autoyast-initscripts.service. Some adjustments in the dependencies of those services was needed in order to make them to work correctly, see for example [this](https://github.com/yast/yast-installation/pull/1033) and [this](https://github.com/yast/yast-installation/pull/1036). Adapting systemd dependencies is not a trivial task. There are always edge scenarios to consider and we plan to continue working in this area.

## Download and Installation Progress

While installing packages, YaST showed a dialog with quite some information about the steps being performed. For example, the dialog provided information about the downloading progress of each package, what package is being installed, etc. But new libyzpp deployed in SUSE SLE 15 SP3 is able to perform operations in parallel such as downloading, installing or verifying packages. Keeping that rich progress dialog while performing operations in parallel was very challenging. After evaluating different options, finally it was decided to [significantly simplify the progress dialog](https://github.com/yast/yast-yast2/pull/1202), making it compatible with parallel operations. Now, the dialog only contains a progress bar with the information about the total amount of packages pending to install and the [download progress](https://github.com/yast/yast-packager/pull/609). The dialog also shows a [a secondary progress bar](https://github.com/yast/yast-yast2/pull/1250) for long tasks taking more than 4 seconds.

## Other Interesting improvements

* Making AutoYaST more robust when [setting the owner of *autoinst_files* files](https://github.com/yast/yast-installation/pull/1034).

* Improvements in the way [YaST imports users](https://github.com/yast/yast-users/pull/361) from other systems.

* Packages [yast2-nis-server](https://github.com/yast/yast-nis-server/pull/30) and [yast2-nis-clients](https://github.com/yast/yast-nis-client/pull/63) were dropped from openSUSE Tumbleweed, although they are still maintained for openSUSE Leap and SUSE SLE.

* YaST was adapted to [call external commands](https://github.com/yast/yast-iscsi-client/pull/113) in a more robust way. Research and more details can be found [here](https://github.com/yast/yast-yast2/tree/master/doc/yast-invoking-external-commands.md).

* AutoYaST [does not export the resume kernel parameter](https://github.com/yast/yast-bootloader/pull/666) anymore, and it only imports such a parameter if the indicated device exists. [AutoYaST documentation](https://github.com/SUSE/doc-sle/pull/1160) was extended to explain this new behavior.

* Fix [empty helps](https://github.com/yast/yast-storage-ng/pull/1298) in the YaST Expert Partitioner.

* Generation of [translations from XML](https://github.com/yast/yast-devtools/pull/166) files is correctly done now.

* YaST does not fail when using the installation media as part of the target system. This implies changes in different parts of YaST, like [this](https://github.com/openSUSE/linuxrc/pull/286), [this](https://github.com/yast/yast-packager/pull/606) or [this](https://github.com/yast/yast-storage-ng/pull/1290).

* The [cockpit-wicked module](https://github.com/openSUSE/cockpit-wicked/pull/133) was adapted to the latest changes in wicked for managing wireless network configurations.

## D-Installer

Little by little we are able to invest more resources in our [D-Installer](https://github.com/yast/d-installer) side project. We are closer to finish the first iteration of our [road-map](https://github.com/orgs/yast/projects/1). Here is a summary of the main features developed since [the first public release](https://yast.opensuse.org/blog/2022-03-31/d-installer-first-public-release):

* UI improvemets:
    * [Show more information](https://github.com/yast/d-installer/pull/71) about the target disk.
    * [Collapse storage actions](https://github.com/yast/d-installer/pull/72).
    * [Add reboot button](https://github.com/yast/d-installer/pull/114).
    * [Ask for confirmation before installing](https://github.com/yast/d-installer/pull/118).
* Other improvements:
    * [D-Bus API to ask questions](https://github.com/yast/d-installer/pull/135) to clients.
    * [Unmount target disk after installing](https://github.com/yast/d-installer/pull/92).
    * [Fix language selector](https://github.com/yast/d-installer/pull/130).
    * [Convert D-Installer into a real Cockpit module](https://github.com/yast/d-installer/pull/127).
    * [Add support for yaml file configuration](https://github.com/yast/d-installer/pull/132).
    * [Add support for remote installation](https://github.com/yast/d-installer/pull/145).

Our beloved [ruby-dbus](https://github.com/mvidner/ruby-dbus) gem also keeps evolving, supporting all the new features we demand for D-Installer. If you are interested in what is new in this great library, please have a look to its latest [pull requests](https://github.com/mvidner/ruby-dbus/pulls?q=is%3Apr+is%3Aclosed). And of course, we encourage you to give D-Installer a try. You can easily test it thanks to the [D-Installer live image](https://build.opensuse.org/package/show/YaST:Head:D-Installer/d-installer-live). We would like to know your opinion.

## Keep in touch

As commented, we are very busy lately. We promise we will try blogging as frequently as possible with all the news from the YaST land. Meanwhile, do not hesitate to contact us in the usual channels: *yast-devel* and *factory* [mailing lists at openSUSE](https://lists.opensuse.org/), at the *#yast* channel at *libera* IRC or directly commenting on GitHub. See you soon and have a lot of fun!

---
layout: post
date: 2022-11-16 06:00:00 +00:00
title: YaST Development Report - Chapter 11 of 2022
description: The YaST team keeps evolving D-Installer without forgetting about YaST
permalink: blog/2022-11-16/yast-report-2022-11
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

As the end of the year approaches, the YaST team is focusing more and more on evolving D-Installer
with the goal to release an incomplete but decent prototype in December. But we also find time to
improve (Auto)YaST with small corrections and not-so-small new features incorporated into openSUSE
Factory and released as updates for SUSE Linux Enterprise 15-SP4.

So let's go with a nice report including:

- A quick summary of the many recent improvements in D-Installer
- The new selection of product in the SLE images for WSL (Windows Subsystem for Linux)
- A glance at the AutoYaST support for the new security profiles feature
- Our new tool to visualize installation logs

## Tons of Improvements in D-Installer {#dinstaller}

As mentioned above, we concentrated quite some firepower on D-Installer development which resulted
in many new features that will be incorporated into the several prototypes that will be published
during this week. You can review every one of these new features by checking their corresponding
pull requests at GitHub. All of them contain nice descriptions with as many screenshots and videos
as you may need:

- Possibility of [installing ALP (Adaptable Linux Platform)
  prototypes](https://github.com/yast/d-installer/pull/265), in addition to openSUSE Tumbleweed,
  Leap and Leap Micro.
- Support for configuring networks: both [wired](https://github.com/yast/d-installer/pull/260) and
  [wireless](https://github.com/yast/d-installer/pull/292).
- New [consistency checks](https://github.com/yast/d-installer/pull/299) to prevent users from
  installing with configurations that makes little sense.
- Usage of [D-Bus activation](https://github.com/yast/d-installer/pull/295) to handle the different
  D-Installer components.
- Initial [D-Bus interface](https://github.com/yast/d-installer/pull/268) to configure the storage
  (eg. partitioning) setup. A new user interface will be built soon on top.

{% include blog_img.md alt="D-Installer"
src="d-installer-mini.png" full_img="d-installer.png" %}

We also took the opportunity to fix several minor issues reported by our early testers. So a big
thank to all of them.

## Registering SLED from a SLE Image at WSL {#wsl}

In case you don't know, Windows Subsystem for Linux is a compatibility layer that allows to run
several Linux distributions inside a Windows machine. Of course, SLES (SUSE Linux Enterprise Server)
is one of those distributions, easily accessible from MS Store as an image for WSL.

Very recently, WSL gained the [ability to execute graphical
applications](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps), which means now it
also makes sense to offer SLED (SUSE Linux Enterprise Desktop) as part of the catalog of images
available for WSL. But SUSE didn't want to bloat MS Store with too many images.

Fortunately, (open)SUSE WSL images are configured on first boot using a YaST wizard. So we added a
new step to that wizard on the SLES image allowing to continue with that product or to switch to
SLED, guiding the user through the registration process that would be needed to access the
SLED repositories.

{% include blog_img.md alt="Distribution selection on WSL Firstboot"
src="wsl-mini.png" full_img="wsl.png" %}

As usual, you can check more details and more screenshots at [the corresponding pull
request](https://github.com/yast/yast-firstboot/pull/140) at GitHub.

## AutoYaST Support for the New Security Policies {#stig}

In our [previous report]({{site.baseurl}}/blog/2022-10-20/yast-report-2022-10) we presented the new
feature to check for security profiles in all its interactive glory. But support for unattended
installation was still not finished.

Now we [added the missing AutoYaST bits](https://github.com/yast/yast-autoinstallation/pull/845).
Check how to specify a security policy in the profile (as with the interactive feature, only [DISA
STIG](http://static.open-scap.org/ssg-guides/ssg-sle15-guide-stig.html) is supported at the moment)
and how AutoYaST would report any lack of compliance.

## A New Viewer for the YaST Logs {#y2log}

But it's not all new big features in YaST. As you all know, we also invest a significant part of our
time fixing bugs, implementing small improvements and helping our users to diagnose problems. For
all that, the YaST logs are a crucial source of information... maybe too much information.  A pretty
typical installation or upgrade of an openSUSE Leap 15.4 system can result in a log file of 13MiB
(uncompressed) with more than 80.000 lines!

To improve the situation we implemented two things: some enhancements in the logging system and a
new log viewer. Now YaST adds marks to the logs that group the information into sections. And the new
log viewer understands those group marks and several other aspects of the YaST logs, making it
possible to filter and to navigate the information.

See the full announcement with examples at [this
announcement](https://lists.opensuse.org/archives/list/yast-devel@lists.opensuse.org/thread/PIUTQPQQRHVDNTTSQGKNTQAFJH6FPEMJ/).

## Stay Tuned {#conclusion}

As already mentioned, we plan to keep working on YaST and D-Installer. Regarding the latter, we hope
to have more news to share before the year ends. So keep an eye on this blog!

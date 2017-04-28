---
layout: post
date: 2017-04-26 10:37:21.000000000 +02:00
title: Highlights of YaST development sprint 33
description: It has been a long time since our last status update! The reason is the
  end of the previous sprint caught quite some of the YaST Team members on vacations
  and, when the vacation period was over, we were so anxious to jump into development
  to make YaST another little bit better that the blog [&#8230;]
category:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It has been a long time since our last status update! The reason is the
end of the previous sprint caught quite some of the YaST Team members on
vacations and, when the vacation period was over, we were so anxious to
jump into development to make YaST another little bit better that the
blog post somehow fell behind.

But it’s time to pay our (reporting) debts. So these are some of the
highlights of the 33th development sprint that finished on April 11th.

### AutoYaST and Salt integration

During this sprint, a new module has been added to the YaST tool box:
[YaST2 Configuration Management][1].

This module offers integration between AutoYaST and configuration
management systems like [Salt][2]. The idea is that AutoYaST will take
care of system installation (partitioning, network setup, etc.) and, if
desired, the system configuration can be delegated to one of those
external tools.

The YaST Configuration Management module was born during an internal
SUSE workshop during the last summer and it got more love during
HackWeek [14][3] and [15][4].

Now it is officially part of the YaST family and it will be included in
the upcoming releases.

[![The new module: YaST - Configuration
Manager](../../../../images/2017-04-26/yast-cm-300x190.jpeg)](../../../../images/2017-04-26/yast-cm.jpeg)

### Extend the YaST Installer Workflow by Add-ons

The YaST installer already allows extending the installation work flow
by add-on extensions. However, this was only supported for the SUSE tag
repositories used on the ISO installation media. That means the online
repositories, which normally use the RPM-MD data format, could not use
this feature.

This sprint we extended the support also for the other repository
formats (basically any repository format supported by libzypp). The
original limitation was caused by the fact that the other repository
types do not support other files except the RPM packages.

To overcome this limitation we now support packaging the installer
extension files into a standard RPM package which can be then provided
by any repository type.

The implementation is [documented][5] and there is the
[YaST:extension][6] OBS project with a simple example extension.

![The example extension in
action](../../../../images/2017-04-26/extended-workflow.gif)

### YaST pattern definitions

The software pattern definitions have been split and moved to the
respective OBS devel projects. See more details in [this
opensuse-factory announcement][7]. That means the YaST patterns are now
maintained in the  
 [YaST:Head][8] project.

The project sources have been imported to the [GitHub][9] repository to
track the history and use the code review workflow. Also and the usual
[Jenkins][10] and [Travis][11] automation has been set up. For
contributing your changes in the YaST patterns use the usual GitHub pull
request workflow as for the other YaST packages. Thank you in advance!
![😉](https://s.w.org/images/core/emoji/2.2.1/72x72/1f609.png){:
.wp-smiley style="height: 1em; max-height: 1em;"}

### CaaSP deserves its own YaST package!

Among other things, our team is working hard to make YaST fulfill the
requirements of the upcoming Containers as a Service Platform (CaaSP)
product. As part of this effort, we have added some new features,
discovered (and fixed) some bugs, improved documentation and so on.

We’ve also added some specific CaaSP code, so during this sprint we’ve
decided to create a new dedicated package ([yast2-caasp][12]) and move
the code there.

Currently it only contains [system role handlers][13] and some
[additional documentation][14], but most probably we will add some stuff
during the upcoming months.

### Bootloader improvement

Also the bootloader module has been improved to better handle invalid
partitioning proposal in the CaaSP product. When the partitioning
proposal did not contain a valid root directory then the bootloader
module crashed.

After the fix it now displays details about the problem so the user can
manually fix the configuration.

[![New YaST-bootloader
warning](../../../../images/2017-04-26/bootloader-300x220.png)](../../../../images/2017-04-26/bootloader.png)

### Automatic screenshots in the AutoYaST integration tests

An important part of keeping the quality in a job is investing in the
quality of the tools. So during this sprint we decided to improve the
capabilities of the [AutoYaST integration tests][15]. To help with
debugging, AYTests will now store a screenshot and, if possible, YaST2
logs from installation/upgrade under the workspace.

The screenshot will be refreshed every 30 seconds so, if a timeout
occurs, it will be now easy to find out where the process got stuck.

### Creating your own installation media

Recently, a new set of packages were introduced into Tumbleweed to help
setting up the local installation servers. They are named
`tftpboot-installation-<PRODUCT>-<ARCH>` (for example
[tftpboot-installation-openSUSE-Tumbleweed-x86\_64][16]) and are
intended to make it easy to set up the PXE boot environment for an
installation server.

These packages basically contain the installation environment as found
on the SUSE installation media.

And this enables [mksusecd][17] to create a network installation image
from it.

For example, the package above installs its files into directory
`/srv/tftpboot/openSUSE-Tumbleweed-x86_64`.

So, let’s run

    mksusecd \
      --create foo.iso \
      --net=http://download.opensuse.org/tumbleweed/repo/oss/suse \
      /srv/tftpboot/openSUSE-Tumbleweed-x86_64

and we get a network installation ISO image that will install the
Tumbleweed distribution using the official openSUSE Tumbleweed
repository.

Note that we are using the RPM-MD repository at
`/tumbleweed/repo/oss/suse` instead of `/tumbleweed/repo/oss` as one
might expect. Of course it is also OK to use the `/tumbleweed/repo/oss`
repository but we want to be cool.
![😀](https://s.w.org/images/core/emoji/2.2.1/72x72/1f600.png){:
.wp-smiley style="height: 1em; max-height: 1em;"}

You can put `foo.iso` also on a USB stick

    dd if=foo.iso of=/dev/<USB_DEVICE>

and boot from it.

To be extra-cool, try the `--fat` option

    mksusecd \
      --create foo.iso \
      --fat \
      --net=http://download.opensuse.org/tumbleweed/repo/oss/suse \
      /srv/tftpboot/openSUSE-Tumbleweed-x86_64

that will create a FAT partition for the data, which is a bit more
convenient when you plan to put the image on an USB stick (and yes, you
can still use the image to burn a DVD).

### Serial console at boot

The YaST bootloader module can be used to configure the parameters to
allow accessing the system’s boot process through a serial console. But
that’s a relatively complex topic and is easy to make mistakes when
specifying such parameters. In the past, the message displayed by YaST
in case of error was not helpful enough. To improve usability, the new
pop-up is nicer and includes a proper example, as can be seen in the
following screenshot.

[![More guided serial console setup in
YaST-Bootloader](../../../../images/2017-04-26/bootloader-srial-300x188.png)](../../../../images/2017-04-26/bootloader-srial.png)

### Storage reimplementation: new proposal guided setup

The previous sprint we brought in the ability to use encryption for both
partition-based and LVM-based proposals. This time we go a step further
and present a new guided setup that allows you to do even more. We have
worked hand in hand with our UX experts to design a new proposal wizard
composed by four steps.

In the first one, a list with the available disks is showed and you can
select which ones to use for your fresh installation.

[![Guided proposal setup - step
1](../../../../images/2017-04-26/guided1-300x225.png)](../../../../images/2017-04-26/guided1.png)

In the second screen, you can select a specific disk to be used for the
root partition, and also, you might decide what to do with the existing
Windows and Linux installed systems. Currently, this last functionality
is only illustrative, but it will become functional in the upcoming
sprints.

[![Guided proposal setup - step
2](../../../../images/2017-04-26/guided2-300x225.png)](../../../../images/2017-04-26/guided2.png)

The third step is surely more familiar for you. As in the previous
sprint, here you can select the LVM usage and encryption. And of course,
the encryption password will be checked to ensure you use it is strong
enough.

[![Guided proposal setup - step
3](../../../../images/2017-04-26/guided3-300x225.png)](../../../../images/2017-04-26/guided3.png)

Finally, in the last step the filesystem type for the root partition can
be selected. Moreover, you can decide whether to use a separate home or
not. Or you can select another filesystem type for your home.

[![](../../../../images/2017-04-26/guided4-300x225.png)](../../../../images/2017-04-26/guided4.png)

As result of the wizard, a new partition schema is automatically created
taking into account all the options you have selected. And naturally,
that is only the first version. We will let know about the news in the
guided setup in following sprints.

### Warn the user in case of inconsistencies in Online Migration

Before the live Service Pack migration the system can be manually
modified in many ways producing inconsistencies between the installed
system and the extensions/modules registered in the registration server.

In this sprint we have added some steps that will allow the user to fix
the inconsistencies. Also the displayed summary of the available
migrations has been improved showing information about products without
any migration available (e.g. third party addons).

For the online migration it is important to be able to rollback to the
original state (before the migration started) when a problem occurs or
the migration is aborted by user.

Now the user will be able to decide if the registered but not installed
products should be deactivated as part of the rollback.

[![Warning for inconsistent online
migration](../../../../images/2017-04-26/addons-warning-300x171.png)](../../../../images/2017-04-26/addons-warning.png)

### See you very soon!

As usual, this report only covers a relatively small part of all the
work done during the previous sprint and, as usual, you will have to
wait until the end of the current sprint to get more exciting news. The
bright side is that the sprint will finish in a matter of days, so you
will only need to wait one week to read our next report.

Stay tuned and have a lot of fun!



[1]: https://github.com/yast/yast-configuration-management/pull/1
[2]: https://saltstack.com/salt-open-source/
[3]: https://hackweek.suse.com/15/projects/integrate-autoyast-with-software-configuration-management-systems
[4]: https://hackweek.suse.com/15/projects/yast-module-for-suse-manager-salt-parametrizable-formulas
[5]: https://github.com/yast/yast-installation/blob/master/doc/installer_extension.md
[6]: https://build.opensuse.org/project/show/YaST:extension
[7]: https://lists.opensuse.org/opensuse-factory/2017-01/msg00041.html
[8]: https://build.opensuse.org/package/show/YaST:Head/patterns-yast
[9]: https://github.com/yast/patterns-yast
[10]: https://ci.opensuse.org/view/Yast/job/patterns-yast-master/
[11]: https://travis-ci.org/yast/patterns-yast
[12]: https://github.com/yast/yast-caasp
[13]: https://github.com/yast/yast-installation/blob/master/doc/system-role-handlers.md
[14]: https://github.com/yast/yast-caasp/blob/master/doc
[15]: https://github.com/yast/autoyast-integration-test
[16]: https://software.opensuse.org/package/tftpboot-installation-openSUSE-Tumbleweed-x86_64
[17]: https://software.opensuse.org/package/mkdud

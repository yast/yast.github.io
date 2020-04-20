---
layout: post
date: 2020-04-20 08:00:00 +00:00
title: Highlights of YaST Development Sprint 97
description: Once most of the features that were planned for SUSE 15 SP2 and openSUSE 15.2 are ready,
  wthe team is shifting its focus to SP3 and 15.3.
category: SCRUM
permalink: blog/2020-04-20/sprint-97
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

## Contents

Once most of the features that were planned for SUSE 15 SP2 and openSUSE 15.2 are ready, the team is
shifting its focus to SP3 and 15.3. Of course, we are still polishing the releases around the
corner, so in the summary of this sprint, you can find a mixture of bug fixes, small features, and
preparation for the future work. These topics are:

* [NCurses installation in old graphic chips](#ncurses-installation)
* [Booting from Remote Encrypted devices](#booting-encrypted-devices)
* [Smarter network configuration in Linuxrc with the new `try` keyword](#try-linuxrc)
* [Better support for auto-configured devices in S/390 systems](#auto-configured-devices)
* [Researching about how to improve XML YaST's parser](#xml-parser)

## Coming Back to Haunt Us: NCurses Installation and Old Graphics Chips {#ncurses-installation}

Some months ago (for Leap 15.1 / SLE-15 SP1), we started using _fbiterm_ for all NCurses
(text-based) installations. We had always used it for certain languages like Chinese, Japanese,
Korean that need special support for their fonts, but since there were font-related problems even
for other languages, we are now using it in all cases.

This fixed those font-related problems, but it turns out it brought back another issue that seemed
long forgotten: poor performance in text mode for specific graphics chips.

Remember the Matrox G200? It was a good choice for Linux systems back years ago. Back _many_ years
ago; that GPU had its 20th anniversary in 2018, so it dates back to 1998 (that was when Windows 98
was new). Its graphics performance was... let's call it _quite okay_ for a budget card even back
then.

Well, it turned out that it is still used today by some rack server manufacturers as on-board
graphics. Most on-board graphics these days uses Intel GPUs (and they work great), but not all: some
indeed use that old Matrox G200.

We had a business customer inquiring why screen redraws while installing their rack servers were so
slow with SLE-15 SP1 compared to SLE-15 GA, and that's the explanation: Those machines have that
Matrox G200 on-board graphics, and it doesn't seem to have the hardware acceleration that would be
good to have for a framebuffer console. And with _fbiterm_ you can now really see the difference.

In that setup, you can observe the NCurses library at work in slow motion: You can see how it
partially removes text from the cursor position to the end of the line (leaving part of the screen
black) and then redraws content from there. It's not wrong or buggy, it's just slow. Unbearably
slow, like back then having a very slow (4800 baud) terminal connection (remember those?).

So our recommendation for that kind of hardware is: Better not use a framebuffer console. Just leave
the machine in plain text mode with 80x25 with the _nomodeset_ boot parameter, or do an SSH
installation.

Those old ghosts keep coming back to haunt us, even from back in the very late MS-DOS days. :smile:

## Improve Booting from Remote Encrypted Devices {#booting-encrypted-devices}

But not all ghosts are that old. We also got the visit of the spirit of the past sprints. In one of
our November posts, we [explained
you](https://yast.opensuse.org/blog/2019/11/22/highlights-of-yast-development-sprints-88-and-89/#fix-boot-problems-with-remote-encrypted-devices)
how we had addressed the existing problems booting from remote encrypted devices by adding the
`_netdev` option to the `fstab` and `crypttab` files for all network-based file systems.

For some months, it looked like the definitive solution. But recently it was reported that, as much
as that option indeed pleases systemd, it confuses dracut when it is used in the root file system.
Although they say you cannot make everybody happy, we found that adding that option to all file
systems except the root one actually seems to be the right solution for both systemd and dracut. The
latter does not get confused anymore and turns out the root file system is the only one for which
omitting the option is safe for systemd.

With all that, SLE-15-SP2 (and Leap 15.2) should exhibit a pretty solid behavior for all scenarios
involving installation on top network disks, encrypted or not. For more technical details, you can
check [the corresponding pull request](https://github.com/yast/yast-storage-ng/pull/1073]).

## Let's try ifcfg in Linuxrc {#ifcfg-try-linuxrc}

Linuxrc is a piece of software responsible for booting the installation media. It offers a friendly
interface to set up some basic stuff (e.g., the language) and takes care of initializing the
hardware and preparing all the stuff that YaST needs to do its magic.

Alternatively to the good looking interface, it provides a really powerful command line too. If you
have not done it before, we recommend you to check the [Linuxrc wiki
page](https://en.opensuse.org/SDB:Linuxrc).

One of the things you can set up using the command line is [the
network](https://en.opensuse.org/SDB:Linuxrc#Using_ifcfg), which is really handy when you want to do
an installation from a network source.

```
ifcfg=eth*=192.168.0.2/24 install=http://192.168.0.1/iso
```

With these settings, Linuxrc configures the first device that matches the `eth*`. But what happens
if you have multiple network interfaces? Is the configured interface the right one to reach the
installation media?

To deal with these situations, we have added a `try` feature to the `ifcfg` option:

```
ifcfg=eth*=try,192.168.0.2/24 install=http://192.168.0.1/iso
```

In this case, Linuxrc tries to find the device which matches the pattern *and* makes the
installation source reachable.

The `try` keyword works for static configurations as well as for DHCP. When used with DHCP the
difference is that the DHCP setup is done for just one device. Without the `try` keyword, the DHCP
configuration is assigned to all devices which match the device pattern. So, if you use:

```
ifcfg=eth*=try,dhcp
```

you'll end up with one DHCP configured device (the one that has a working network connection). On
the contrary, omitting the `try` option will configure via DHCP all the devices matching the given
pattern.

You can use any of Linuxrc's network-aware options as criteria for the `try` option (`install`,
`dud`, `info`, and `autoyast`). However, you cannot explicitly determine which one will be used if
more than one is given. It merely depends on which one is used first by Linuxrc.

## Better Support for Auto-Configured Devices in S/390 Systems {#auto-configure-devices}

A few weeks ago, we [announced]({{site.baseurl}}/blog/2020-03-06/sprint-94#chzdev) that we had extended
Linuxrc and YaST to play nicely with the new I/O device auto-configuration mechanism on zSeries
systems. After gathering some feedback from our S/390 experts, we did some adjustments to the
current implementation.

On the one hand, the auto-configuration is now optional. Linuxrc offers a new `DeviceAutoConfig`
that allows the user to indicate whether to apply the configuration. The possible values are `0`
(no), `1` (yes) and `2` (ask). The last of those values is the default.

On the other hand, QA detected a problem when AutoYaST tried to configure a device that has been
already configured. Apart from solving the issue, we invested some time doing cleaning-up part of
the yast2-s390 module.

## Improving YaST's XML Parser {#xml-parser}

XML is an important language in the YaST world. The best example is the so-called _control file_,
which defines many aspects of the installation process. You can check the [control file for
openSUSE](https://github.com/yast/skelcd-control-openSUSE/blob/master/control/control.openSUSE.xml)
if you are interested.

YaST implements its own XML parser which is adapted to our needs. For instance, it is able to
understand an special `config:type` attribute which serves as a hint about to interpret the content
of the XML tag. If you have used AutoYaST, you know what we are talking about.

```xml
<initialize config:type="boolean">true</initialize>
```

However, it has its own set of problems, especially when it comes to error reporting. For that
reason, we have started a new initiative to improve our XML parser. There are some discussions which
are taking place in the yast-devel mailing list (like
[YaST XML Parser](https://lists.opensuse.org/yast-devel/2020-04/msg00002.html) and [Yast XML parser
and strictness](https://lists.opensuse.org/yast-devel/2020-04/msg00013.html)). Feel free to join and
share your point of view.

## Conclusions

To plan for the future, the team has started to do some research about the current status of YaST
modules and AutoYaST. You might already have read something about them if you are subscribed to the
[yast-devel mailing list](https://lists.opensuse.org/yast-devel/). If you want to share your point
of view, you are welcome to the discussion.

In any case, we plan to present our conclusions during the upcoming weeks. So stay safe and tunned!

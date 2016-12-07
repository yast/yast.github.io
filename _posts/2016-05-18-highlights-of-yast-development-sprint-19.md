---
layout: post
date: 2016-05-18 12:14:46.000000000 +00:00
title: Highlights of YaST development sprint 19
description: Here we are after another Scrum sprint with our usual report about the
  activity in YaST development.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

Here we are after another Scrum sprint with our usual report about the
activity in YaST development.

### Trusted boot

YaST bootloader module got a new option, Trusted Boot
([FATE#316553][1]). It installs TrustedGRUB2 instead of the regular
GRUB2. Trusted Boot means measuring the integrity of the boot process,
with the help from the hardware (a TPM, Trusted Platform Module, chip).

It enables some interesting things which we unfortunately haven’t
provided out of the box. We give you a bootloader which measures the
boot integrity and places the results in Platform Configuration
Registers (PCRs).

First you need to make sure Trusted Boot is enabled in the BIOS setup
(the setting is named Security / Security Chip on Thinkpads, for
example). Then you can enable the new YaST Bootloader option that will
install TrustedGRUB2.

[![Trusted boot in YaST
Bootloader](../../../../images/2016-05-18/42c4377c-1b88-11e6-8287-236106b6f4d9-300x234.png)](../../../../images/2016-05-18/42c4377c-1b88-11e6-8287-236106b6f4d9.png)

In the description of [this pull request][2] you can find a more
detailed explanation including some commands and hexadecimal dumps to
check the result. Geek pr0n!

### SSH keys importing… and a glance at a YaST Developer’s life

When looking at any software project, it’s common to find some feature
or piece of code that is there due to the so-called “historical
reasons”. YaST2 code-base has been around since 1999, adapting to
changes and new requirements in a (almost literally) daily basis since
then. That leads to a new level of heritage – the “prehistoric reasons”.
Working in the YaST Team implies coding, debugging, testing… and
archaeological research.

We got a [bug report][3] about the installer “stealing” some SSH host
keys (but not all of them) from previously installed systems. It was
actually the effect of a little-known YaST feature that can look
surprising (not to say weird) at first sight. Ten years ago, somebody
decided that when installing SUSE in a networked environment, where
people use SSH to log in, it was better to import SSH keys from a
previously installed Linux than to get that “ssh host key changed” for
everybody who tries to connect. The rational was that forcing everybody
to change the ~/.ssh/known\_hosts file often could become a security
breach, since people could get used to ignore the security warnings.
Welcome to the world of historical reasons. :smiley:
Moreover, it was decided that the operation should be performed without showing
any information to the users, in order to not confuse them.

More or less at the same time (we are still talking about 2006), it was
decided to introduce importing of users from an existing system, this
time with user interaction. The YaST developers decided that it would be
fine to share some mechanisms in the implementation of both features.
Another step into the historical reasons void.

Fast forward to the present. After several fate entries, bug reports and
redesigns over the years, we decided to make the importing of SSH host
keys more visible and usable, to make both functionalities (SSH import
and users import) more independent and more clean and to take the first
step to clean up the insanity introduced through the years (see
[fate#320873][4] for details).

The installer does not longer silently just import the SSH host keys
from the most recent Linux installation on the disk (remember, you might
have several distributions installed), it has now become a part of the
installation proposal dialog:

![SSH host keys
proposal](../../../../images/2016-05-18/f93f82cc-1c19-11e6-95ae-0e7e82c22eb4.png)

And from there you can change it:

![SSH host keys
selection](../../../../images/2016-05-18/08b01bfe-1c1a-11e6-84f8-ee8d5cd8c3ab.png)

Notice that one of the options is “none”, so copying of previous keys is
not longer enforced. In addition, now is also possible to import the
rest of the SSH configuration in addition to the keys.

### Disabling local repositories

When installing from a local media, like a CD/DVD or an USB stick, those
sources were still enabled after the installation. It potentially could
cause problems during software installation, upgrade, migration, etc.
because an old or obsolete installation source is still there. On the
other hand, if the source is physically removed (for instance, ejecting
the CD/DVD), zypper will complain about that source not being available.

Fortunately, this behavior will change in future SUSE/openSUSE versions.
Now, at the end of the installation, YaST will check every local source
disabling those whose products are available also through a remote
repository (so they’re not needed at all).

### Smart bonding with NPAR and SR-IOV interfaces

Support for bonding interfaces with NPar or SR-IOV capabilities has also
been improved during this sprint. Too many weird words in one sentence?
Don’t worry, we actually love to explain things.

Bonding is a way to combine multiple network connections to increase the
throughput and bandwidth and to provide redundancy. On the other hand,
NPAR and SR-IOV are technologies that provide the capability to create
multiple virtual devices from the same physical or ethernet port.

Until this sprint, YaST offered no way to know whether two interfaces
with these capabilities were sharing the same physical port. As a
result, users could bond them without realizing that they were not
getting the desired effect in terms of redundancy.

Information about the physical port ID has been added to all the
relevant dialogs for all devices supporting it, like it’s shown in the
following screenshots.

[![Physical
ports](../../../../images/2016-05-18/bonding1-1-300x232.png)](../../../../images/2016-05-18/bonding1-1.png)

[![More physical
ports](../../../../images/2016-05-18/bonding2-300x185.png)](../../../../images/2016-05-18/bonding2.png)

Additionally, the user will be alerted when trying to bond devices
sharing the same physical port.

![Bonding warning](../../../../images/2016-05-18/warning-1.png)

Last but not least, following the Boy Scout Rule (also known as
[opportunistic refactoring][5]), we took the opportunity to fix some
small quirks in YaST Network, like the counter-intuitive sorting of
devices in some lists.

### Paying our debts: much better cleanup rules in Snapper

Somebody said once “*a promise made is a debt unpaid*“. In the [previous
post][6] we promised you all an article on Snapper.io detailing the new
space-aware cleanup introduced in Snapper. [Here you are!][7]

### That’s all folks

Enough for a blog post. That’s of course not all we did during the last
sprint (to the contrary, it’s just around 20% of the finished work
according to the story points count) but, you know, we need to go back
to hacking!



[1]: https://fate.suse.com/316553
[2]: https://github.com/yast/yast-bootloader/pull/329
[3]: https://bugzilla.opensuse.org/show_bug.cgi?id=956976
[4]: https://features.opensuse.org/320873
[5]: http://martinfowler.com/bliki/OpportunisticRefactoring.html
[6]: {{ site.baseurl }}{% post_url 2016-05-02-highlights-of-yast-development-sprint-18 %}
[7]: http://snapper.io/2016/05/18/space-aware-cleanup.html

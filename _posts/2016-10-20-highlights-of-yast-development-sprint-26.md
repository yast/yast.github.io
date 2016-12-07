---
layout: post
date: 2016-10-20 12:36:54.000000000 +00:00
title: Highlights of YaST development sprint 26
description: We did our best to keep you entertained during this development sprint
  with a couple of blog posts. But now the sprint is over and it&#8217;s
  time for a new report.
category: SCRUM
tags:
- Distribution
- Factory
- Localization
- Programming
- Systems Management
- Usability
- YaST
---

We did our best to keep you entertained during this development sprint
with a couple of blog posts ([\[1\]][1] and [\[2\]][2]). But now the
sprint is over and it’s time for a new report.

### Squashing low priority bugs

One of the main reasons to adopt Scrum was to ensure we make a good use
of our development resources (i.e. developers’ time and brains) focusing
on things that bring more value to our users. In the past we had the
feeling that many important things were always postponed because the
developers were flooded by other not so important stuff. Now that
feeling is gone (to a great extent) and we have a more clear and shared
view of the direction of our development efforts.

But there is always a drawback. We have accumulated quite some unsolved
low-priority bugs. That was an expected consequence, but still it was
starting to feel wrong. On one hand, it makes us feel uncomfortable –
replying “this will have to wait” so often is not nice, even if it’s for
the shake a bigger goal. On the other hand, the amount of low-priority
stuff was affecting the signal/noise ratio on Bugzilla, making harder to
distinguish the important stuff.

So far, dealing with those low-priority bug was something that each
developer did on his own, as permitted by the time dedicated to Scrum.
In sprint 26 we decided to make that effort an explicit part of the
process and to devote a significant portion of the sprint to it. As a
result we closed or reassigned a total of 135 bugs that were just
sitting in our list.

Yes, you did read it right. One hundred and thirty five bugs.

### Storage reimplementation: our testing ISO can already destroy your data

On the previous sprint we already showed a screenshot of the installer
using the new storage stack to calculate a partitioning proposal. Now
the installer can go one step further. As you can see on this animation,
the changes are now committed to the disk, meaning the system is
actually partitioned, formatted and installed.

![Installation with the new storage
stack](../../../../images/2016-10-20/demo_commit_to_disk.gif)

The process is interrupted after installing the software, when trying to
configure and install the bootloader. That was expected because
yast2-bootloader has still not been adapted to use the new stack. First
of all, because we wanted to leave some fun for sprint 27. But also
because we used this sprint (26) to document [all the requirements of
yast2-bootloader][3] in relation to the new storage stack. Now we have
in place all the ingredients to cook an installable ISO.

### Automatic update of translation files

Recently openSUSE has adopted [Weblate][4] to perform and coordinate the
translation of the software and the project’s web pages. The [openSUSE’s
Weblate instance][5] enables everybody (from dedicated translators to
casual contributors) to take part in the process and makes possible to
coordinate the translations of openSUSE with the ones for SUSE
Enterprise Linux, boosting collaboration between the translators of both
projects.

As YaST developers, is of course our responsibility to ensure that
openSUSE’s Weblate contains always the latest English strings to be
translated. Making our developer’s life easier sometimes not only brings
advantages for us but also for our users. Until now, after each code
change we had to keep in mind to trigger the translation process for
every added or changed English text. Sometimes we were not quick enough
so that some English leftovers remained in our awesome YaST when being
used in one of the 20 languages where the translation is normally 100%
complete.

Now we finally set up a [Jenkins][6] job to automate the process of
triggering the translation update after code changes. This saves the
developers some work and makes the update of translations even faster.

Looking at [Weblate numbers][7], you can see we have 20 languages that
are about 100% translated, another 20 that are translated more than 75%
and 37 languages which are translated less than 75%. So we still need
some help to bring all languages to 100% coverage. If you are willing to
contribute, why not join our team of translators? Check out [the
localization guide][8] to get in contact with the coordinators of your
preferred language to learn about how to contribute with translations,
reviews or by any other mean.

### Ensure installation of packages needed for booting

We got some reports of systems not being able to work after the
installation in scenarios in which the user had customized the list of
packages to install. That happened because, although the bootloader
component of YaST pre-selects for installation all the needed packages,
the user can override that selection and manually disable the
installation of those packages.

To prevent this situation, or at least to increase awareness of it, the
installer now alerts in the summary screen (the last step before
proceeding to installation) if some of the required packages is missing,
as you can see in the screenshot below. We still allow the users to
shoot their own feet if they insist, but now we warn them very clearly.

[![Warning about de-selected Grub2
package](../../../../images/2016-10-20/softw-300x226.png)](../../../../images/2016-10-20/softw.png)

### Progress in the low-vision accessibility of the installer

During this sprint, we have been working to make the (open)SUSE
installer accessible to people with low-vision impairment. We already
[blogged about it][1] looking for feedback.

[![One of the new color modes available in the
installer](../../../../images/2016-10-20/highc-300x225.png)](../../../../images/2016-10-20/highc.png)

In a few days, some changes will land in Tumbleweed:

* Alternative style selection (color and font-sizes). Currently, we
  offer four options: default (no changes), high contrast
  (cyan/green/white/black), white on black and cyan on black. Those
  styles are just a proof of concept in order to test the code changes
  and, most important, to get feedback from you.
* A [long-standing issue][9], which prevented to switch to high-contrast
  mode during installation (shift+F4), has been fixed.

[![Style selection at the beginning of
installation](../../../../images/2016-10-20/linuxrc-300x225.png)](../../../../images/2016-10-20/linuxrc.png)

 Although we have made some progress, it is still an ongoing effort and
we hope to release more improvements during the upcoming weeks.

### Recover from broken bootloader configuration

There are situations in which YaST Bootloader is not able to read the
system configuration. For example, when the udev device originally used
by Grub2 is no longer available. In the past that leaded to YaST
crashes, requiring a manual fix of the bootloader configuration files.
Now YaST correctly detects the situation and offers the option to
propose a new configuration with correct devices.

[![YaST bootloader fixing a broken
configuration](../../../../images/2016-10-20/bootl-300x170.png)](../../../../images/2016-10-20/bootl.png)

### Disable autorefresh by default in local media

We have changed the default autorefresh flag for the new repositories
added by YaST. In the past the autorefresh was enabled for all
repositories except CD/DVD media and ISO files.

With the new defaults the autorefresh is enabled only for remote
repositories (like http, ftp, nfs,…). The reason is that some local
repositories might not be always available (e.g. external hard disk, USB
flash drive,…) and the automatic refresh might cause ugly errors when
starting the package manager.

Of course, you can still manually change the autorefresh flag after
adding a repository if you need a different value.

*Note: The default has been changed in Tumbleweed distribution only,
Leap 42.2 or SLE-12-SP2 keep the old defaults. The zypper behavior is
unchanged as well, it by default disables autorefresh for all
repositories. Only repositories imported from a .repo file have
autorefresh enabled. See `man zypper` for more details.*

### Tons of improvements in network bridge handling

YaST Network is Swiss Army knife for network configuration which
comprehends the management of routing, bonding, bridging and many other
things. But, to be honest, the management of bridges was not in the best
possible shape. It had quite some usability problems and it was not 100%
consistent with the way in which bridges are managed nowadays by
[Wicked][10] in (open)SUSE. Until now!

This [pull request][11] with several screenshots and animations tries to
summarize all the changes that have been done during this sprint. Like
adapting old configuration files to the new conventions or unifying the
UI to make it consistent with the one for managing bonding.

[![Revamped YaST interface for handling
bridges](../../../../images/2016-10-20/bridge-300x225.png)](../../../../images/2016-10-20/bridge.png)

This revamp includes also quite some usability improvements:

* `NONE` is shown instead of 0.0.0.0 for old bridge configuration.
* The bridge master is shown in the enslaved interface.
* The interfaces overview is updated after a bridge is modified.

### Optimizing read of hosts file

It was reported that yast2-network was slow in system with a lot of
entries in the `/etc/hosts` file. We took that as an opportunity to test
the new profiler support in YaST. The profiler revealed the problem was
in some slow calls to [SCR][12], the layer traditionally used by YaST to
interact with the underlying system… which sounded like another
opportunity. This time an opportunity to expand the use of [CFA][13]
(the component we are developing to steady replace SCR) and its
[Augeas][14] parser. Since Augeas already supports parsing of
`/etc/hosts` files, it was quite straightforward to implement that into
YaST… and the result is quite impressive.

The time needed to execute the next command in a system containing a
huge `/etc/hosts` with around 10,000 entries (quite an extreme case, we
know) was reduced from 75 seconds to just 20.

```
yast2 lan list
```

As you can see in [this pull request][15], we also improved CFA itself,
greatly reducing the time needed for reading configuration files with
Augeas.

### That’s all… until next report

Once again, we must conclude the report telling that this was just a
small summary of all the work done during the sprint and that we will be
back in three weeks with the next report. Or maybe before, now that we
are starting to get used to blog more often.

In any case, see you soon and don’t forget to have a lot of fun!



[1]: {{ site.baseurl }}{% post_url 2016-10-07-improving-low-vision-accessibility-of-the-installer %}
[2]: {{ site.baseurl }}{% post_url 2016-10-11-reducing-yast-rebuild-time-by-30\% %}
[3]: https://github.com/yast/yast-bootloader/blob/master/doc/boot_storage_needed_info.md
[4]: https://weblate.org
[5]: https://l10n.opensuse.org/
[6]: https://ci.opensuse.org/
[7]: https://l10n.opensuse.org/languages/
[8]: https://en.opensuse.org/openSUSE:Localization_guide
[9]: https://bugzilla.suse.com/show_bug.cgi?id=768112
[10]: https://en.opensuse.org/Portal:Wicked
[11]: https://github.com/yast/yast-network/pull/448
[12]: http://yastgithubio.readthedocs.io/en/latest/architecture/#system-configuration-repository-scr
[13]: https://github.com/config-files-api/config_files_api
[14]: http://augeas.net/
[15]: https://github.com/config-files-api/config_files_api/pull/10

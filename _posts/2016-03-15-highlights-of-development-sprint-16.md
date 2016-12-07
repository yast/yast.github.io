---
layout: post
date: 2016-03-15 16:28:16.000000000 +00:00
title: Highlights of development sprint 16
description: After three weeks of work, another development sprint is over. So time
  for another report for our fellow geckos. As usual, quite some time was invested
  in boring bug fixes and small non-obvious improvements, but we also have some interesting
  stuff to talk about.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

After three weeks of work, another development sprint is over. So time
for another report for our fellow geckos. As usual, quite some time was
invested in boring bug fixes and small non-obvious improvements, but we
also have some interesting stuff to talk about.

### Improved UI for the encrypted partitioning proposal

We wanted to talk about this feature not only because it has a visible
impact in the user interface, but also because it’s a great example of
collaboration among the different roles present in a Scrum Team.
Formerly our Scrum development team was only formed by the developers of
the YaST Team at SUSE. For this sprint (and future ones) the Scrum Team
has been powered up with the addition of Ken Wimer as UI/UX expert and
Jozef Pupava, one of the openQA.opensuse.org and openQA.suse.de
operators.

We got a feature request to make encryption more visible in this dialog.

[![Old partitioning proposal
dialog](../../../../images/2016-03-15/28ea0408-e22b-11e5-8290-9ad25dd65776-225x300.png)](../../../../images/2016-03-15/28ea0408-e22b-11e5-8290-9ad25dd65776.png)

Being software developers used to tools like Vim and Git, we have to
admit that the YaST team found the dialog perfectly usable and was
having hard times thinking on a better alternative. Fortunately, we now
have a UI/UX expert able to bring better alternatives like this one we
finally implemented.

[![New dialog for partitioning
proposal](../../../../images/2016-03-15/93288588-e22b-11e5-8d9e-d6190a2ad13b-219x300.png)](../../../../images/2016-03-15/93288588-e22b-11e5-8d9e-d6190a2ad13b.png)

This kind of visual changes in the installer used to cause delays in
openQA, because adapting the tests while keeping the openQA machinery
running is not always trivial. The great news is that it didn’t happen
this time because our particular openQA superhero was already watching
over our steps all along the process.

So welcome into our Scrum process, Ken and Jozef!

### System roles

A new feature was added to the installer making it possible to quickly
adjust several settings for the installation with one shot. You can see
a detailed description of the feature, including several screenshots and
configurations options [in this wiki page][1] at the Github repository
of yast2-installation. And yes, for the impatient we also have a
glorious screenshot!

[![System Role
dialog](../../../../images/2016-03-15/460729c4-ea98-11e5-95e7-1a8d90729ff1-300x231.png)](../../../../images/2016-03-15/460729c4-ea98-11e5-95e7-1a8d90729ff1.png)

### Storage reimplementation: resizing partitions

We have already explained in previous reports that we are performing an
integral rewrite of the code managing partitioning and other storage
tasks. During this sprint, the brand new library gained the ability to
resize all kind of partitions (Linux, Windows, swap, etc.). It’s nothing
that is going to hit the users in the short term but at least we have a
couple of screenshots to see the premiere working (yes, we know that
screenshots of terminals are not the most fancy stuff).

[![shrink-vfat](../../../../images/2016-03-15/shrink-vfat-300x195.png)](../../../../images/2016-03-15/shrink-vfat.png)

[![grow-ntfs](../../../../images/2016-03-15/grow-ntfs-300x195.png)](../../../../images/2016-03-15/grow-ntfs.png)

### Installer self-update

Starting on version 3.1.175, YaST is able to update itself during system
installation. This feature will help to solve problems in the installer
even after the media has been released. That’s a huge step towards
improving YaST reliability.

The workflow is pretty simple: during system analysis YaST will search
automatically for an update. If such update is found, YaST will
download, verify (using GPG) and apply it. Finally, the installation
will be resumed using the new version. Nice!

In the future, self update will be enabled by default. However, if for
some reason you don’t want such a nice feature, you’re free to disable
it. What is more: you can also craft your own update and use it instead
the official one passing a custom URL to the installer.

If you’re curious, you can check the [technical details][2].

### Storage reimplementation: the search for the perfect bootloader

One of the goals of rewriting the storage layer was to make possible to
cope with all the over-complicated requirements involved in the proposal
of a good bootloader configuration. This time we don’t want the
different scenarios to simply pop-up over time in a bug-report-oriented
basis and start aggregating more and more branches to the existing code
in order to support every one of those “new” scenarios.

Changes will come, for sure, but we need a solid ground based in experts
knowledge to start building a flexible future-proof code to handle
partitioning regarding bootloader. Thus, we started a round of contacts
with several experts in all the hardware architectures supported by YaST
in order to capture all the knowledge from their brains into a set of
Ruby classes. It’s still a work in progress since squeezing people’s
brains is not always easy, but we already have [some preliminary
document][3].

### Consolidating continuous integration tools

Continuous integration is a key aspect of software development,
specially with methodologies like Scrum. Currently we use both
[Travis][4] and [Jenkins][5] for it. Travis builds the pushed commits
and pull requests at GitHub, while Jenkins takes care of the integration
with the Open Build Service.

We are investing quite some effort trying to use Jenkins for everything.
If you want to know more about the reasons or how the progress is going,
check [the detailed documentation][6].

### And much more!

As usual, this is just a small sample of the total work delivered by the
team during the latest sprint (for Scrum and statistic’s lovers, it
represents 34 story points out of a total of 87 delivered ones).
Hopefully enough to keep you informed… and if it’s not, you know where
you can reach us for more information!



[1]: https://github.com/yast/yast-installation/wiki/System-Role
[2]: https://github.com/yast/yast-installation/blob/master/doc/SELF_UPDATE.md
[3]: https://github.com/yast/yast-storage-ng/blob/master/doc/boot-partition.md
[4]: https://travis-ci.org/
[5]: http://jenkins-ci.org/
[6]: https://github.com/yast/yast.github.io/blob/master/doc/jenkins-integration.md

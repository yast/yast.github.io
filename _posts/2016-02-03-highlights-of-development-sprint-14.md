---
layout: post
date: 2016-02-03 08:08:15.000000000 +00:00
title: Highlights of development sprint 14
description: Another three weeks period and another report from the YaST Team.
  This was actually a very productive sprint although, as usual, not all changes
  have such an obvious impact on final users...
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Another three weeks period and another report from the YaST Team (if you
don’t know what we are talking about, see [highlights of sprint 13][1]
and the [presentation post][2]). This was actually a very productive
sprint although, as usual, not all changes have such an obvious impact
on final users, at least in the short term.

### Redesign and refactoring of the user creation dialog

One of the most visible changes, at least during the installation
process, is the revamped dialog for creating local users. There is a
full screenshots-packed description of the original problems (at
usability and code levels) and the implemented solution in the
[description of this pull request][3] at Github.com.

Spoilers: the new dialog looks like the screenshot below and the
openSUSE community now needs to decide the default behavior we want for
Tumbleweed regarding password encryption methods. To take part in that
discussion, read the mentioned description and reply to [this thread][4]
in the openSUSE Factory mailing list.

[![b12a8f90-c51b-11e5-9ceb-659b6c77bac4](../../../../images/2016-02-03/b12a8f90-c51b-11e5-9ceb-659b6c77bac4-300x225.png)](../../../../images/2016-02-03/b12a8f90-c51b-11e5-9ceb-659b6c77bac4.png)

Beyond the obvious changes for the final user, the implementation of the
new dialogs resulted in a much cleaner and more tested code base,
including a new [reusable class][5] to greatly streamline the
development of new installation dialogs in the future.

### One step further in the new libstorage: installation proposal

In the highlights of the previous sprint, we already explained the YaST
team is putting a lot of effort in rewriting the layer that access to
disks, partitions, volumes and all that. One important milestone in such
rewrite is the ability to examine a hard disk with a complex
partitioning schema (including MS Windows partitions, a Linux
installation and so on) and propose the operations that need to be
performed in order to install (open)SUSE. It’s a more complex topic that
it could look at the first glance.

During this sprint we created a command line tool that can perform that
task. Is still not part of the installation process and will take quite
some time until it gets there, but it’s already a nice showcase of the
capabilities of the new library.

[![new-storage-proposal-2016-01-27-1900](../../../../images/2016-02-03/new-storage-proposal-2016-01-27-1900-1.png)](../../../../images/2016-02-03/new-storage-proposal-2016-01-27-1900-1.png)

### Fixed a crash when EULA download fails

If a download error occurred during the installation of any module or
extension requiring an EULA, YaST simply exited after displaying a
pop-up error, as you can see here.

[![0c444926-bb75-11e5-8e6e-029d018c14d3](../../../../images/2016-02-03/0c444926-bb75-11e5-8e6e-029d018c14d3.gif)](../../../../images/2016-02-03/0c444926-bb75-11e5-8e6e-029d018c14d3.gif)

Now the workflow goes back to the extension selection, to retry or to
deselect the problematic extension. Just like this.

[![46fb22a6-bb75-11e5-9830-aff1d516e77e](../../../../images/2016-02-03/46fb22a6-bb75-11e5-9830-aff1d516e77e.gif)](../../../../images/2016-02-03/46fb22a6-bb75-11e5-9830-aff1d516e77e.gif)


### Continuous integration for Snapper and (the current) libstorage

[Snapper][6] and [libstorage][7] now build the Git “master” branch
continuously on [ci.opensuse.org][8] ([S][9], [L][10]), and commit a
passing build to the OBS development project ([S][11], [L][12]), and if
the version number has changed, submit the package to Factory ([S][13],
[L][14]).

The same set-up works on [ci.suse.de][15] ([S][16], [L][17]), committing
to the SUSE’s internal OBS instance ([S][18], [L][19]) and submitting to
the future SLE12-SP2 ([S][20], [L][21]).

This brings these two packages up to the level of automation that the
YaST team uses for the yast2-\* packages, and allows releasing simple
fixes even by team members who do not work on these packages regularly.

### Disk usage stats in installation and software manager: do not list subvolumes

While installing software, YaST provides a visual overview of the free
space in the different mount points of the system. With Btrfs and its
subvolumes feature, the separation between a physical disk and its mount
point is not that clear anymore. That resulted in wrong reports in YaST,
like the one displayed in the left bottom corner of this screen.

[![broken-disk-usage](../../../../images/2016-02-03/broken-disk-usage.png)](../../../../images/2016-02-03/broken-disk-usage.png)

The actual calculation of free space is performed by libzypp (the Zypper
library), YaST only takes care of rendering the result of that
calculation in the screen. Thus, we closely collaborated with the Zypper
developer, Michael Andres, to teach libzypp how to deal with Btrfs
subvolumes. Thanks to his work, with any version of libzypp &gt;= 15.21
(already available in Tumbleweed), you can enjoy an error-free disk
usage report.

[![fixed-disk-usage](../../../../images/2016-02-03/fixed-disk-usage.png)](../../../../images/2016-02-03/fixed-disk-usage.png)

To ensure we have no regressions, the YaST team also contributed a new
test to openQA. See it [in action][22].

### Cleanup dependencies in YaST systemd services

We have received several bug reports about problems executing AutoYaST
or YasT2-Firstboot in combination with complex network settings or third
party services… and even in some simple scenarios. Many of these
problems boil down to a single culprit – the dependencies of the YaST
related systemd units.

During this sprint we have simplified the unit files for Tumbleweed and
SLE, as you can see in [this pull request][23]. It’s a small change but
with a huge impact and several implications, so a lot of time was
invested into testing during the sprint. The problems seem to be gone,
but more AutoYaST and YaST-Firstboot testing would be highly
appreciated.

### Many other things

As usual, this is only a brief collection of highlights of all the job
done during the sprint. Using Scrum terminology, this represents only 27
story points out of a total of 81 story points delivered by the team
during this sprint. Using more mundane words, this is just a third part
of what we have achieved during the last three weeks.

Hopefully, enough to keep you entertained until the next report in other
three weeks!



[1]: {{ site.baseurl }}{% post_url 2016-01-07-highlights-of-development-sprint-13 %}
[2]: {{ site.baseurl }}{% post_url 2015-12-15-let-s-blog-about-yast %}
[3]: https://github.com/yast/yast-users/pull/84
[4]: http://lists.opensuse.org/opensuse-factory/2016-01/msg00496.html
[5]: http://www.rubydoc.info/github/yast/yast-yast2/UI/InstallationDialog
[6]: https://github.com/openSUSE/snapper
[7]: https://github.com/openSUSE/libstorage/
[8]: http://ci.opensuse.org
[9]: https://ci.opensuse.org/job/snapper-master/
[10]: https://ci.opensuse.org/job/libstorage-master/
[11]: https://build.opensuse.org/package/show/YaST:Head/snapper
[12]: https://build.opensuse.org/package/show/YaST:Head/libstorage
[13]: https://build.opensuse.org/package/show/openSUSE:Factory/snapper
[14]: https://build.opensuse.org/package/show/openSUSE:Factory/libstorage
[15]: http://ci.suse.de
[16]: https://ci.suse.de/job/snapper-master/
[17]: https://ci.suse.de/job/libstorage-master/
[18]: https://build.suse.de/package/show/Devel:YaST:Head/snapper
[19]: https://build.suse.de/package/show/Devel:YaST:Head/libstorage
[20]: https://build.suse.de/package/show/SUSE:SLE-12-SP2:GA/snapper
[21]: https://build.suse.de/package/show/SUSE:SLE-12-SP2:GA/libstorage
[22]: https://openqa.opensuse.org/tests/117876/modules/yast2_i/steps/7
[23]: https://github.com/yast/yast-installation/pull/332/files

---
layout: post
date: 2018-11-07 11:37:29.000000000 +00:00
title: Highlights of YaST Development Sprint 66
description: The YaST team is working hard in order to extend the installer.
category: SCRUM
tags:
- Base System
- Distribution
- Factory
- Systems Management
- YaST
---

The YaST team is working hard in order to extend the installer, improve
the new storage layer and get rid of some bugs. So after this sprint,
there is quite some unfinished work that will be ready within two weeks.

However, we have some stuff that we would like you to check out:

* Snapper takes the free space into account when cleaning up snapshots.
* The partitioning proposal tries to use just a single disk first.
* The description of those actions that are related to BCache and
  MD-RAID devices have been greatly improved.
* YaST is now able to handle repository variables properly.
* The log viewer displays a helpful message when no logs are found.
* And last but not least, yast2-sshd got a new maintainer outside of the
  YaST team. Let’s celebrate!

### Extended Snapshots Clean-up Mechanisms in Snapper   {#snapper-deletes-snapshots}

So far *snapper* would delete snapshots if the overall spaced used for
them was above a given limit. Now, *snapper* is able to take the free
space into account too, so it will delete snapshots when the free space
of the filesystem drops below a given threshold.

Of course, the threshold can be adjusted by the user through the
*snapper* configuration files.

### Better Actions Descriptions in Storage-ng   {#better-actions-descriptions}

When describing what actions will be performed for storage actions, we
already collapsed related actions to one to make it better readable.
Instead of:

    - Create  partition /dev/sda1 (40.00 GiB)
    - Set ID of partition /dev/sda1 to "Linux" (0x83)
    - Create ext4 on /dev/sda1
    - Add mount point /home for /dev/sda1
    - Add entry for /dev/sda1 to /etc/fstab

we report:

    - Create partition /dev/sda1 (40.00 GiB) with ext4 for /home

However, actions related to BCache and MD-RAID devices were not taken
into account, which produced quite long (and confusing) descriptions.
Fortunately, these cases are now properly handled and the description is
now quite informative and concise:

    Create encrypted RAID1 /dev/md0 (511.87 GiB) for /secret with xfs
    from /dev/sda (512.00 GiB), /dev/sdb (512.00 GiB)

### Properly Handling Repository Variables   {#replacing-libzypp-variables}

libzypp supports variable substitution in the *name* and the *URLs* of
repositories and services. So a `.repo` file might contain
something like this (notice the `$releasever` variable):

    [repo-oss]
    name=openSUSE-Leap-$releasever
    baseurl=http://download.opensuse.org/distribution/leap/$releasever/repo/oss/

libzypp will take care of injecting the correct value but the user could
override those values too. So in the example above, upgrading to Leap
15.1 might be as easy as:

    zypper --releasever 15.1 dup

However, YaST2 had some problems in these situations that, hopefully,
have been fixed during this sprint. Now openSUSE release managers can
adjust the list of online repositories in order to take advantage of
such a feature. If you want to know more about variable substitution,
please check [libzypp documentation][1].

### Partitioning Proposal Uses a Single Disk   {#partitioning-proposel-uses-a-single-disk}

Until now, the partitioning proposal that is calculated during the
installation uses all available disks by default. However, according to
the feedback that we have received from our users, most people simply
expect the system to be installed in just one disk. So, from now on,
this initial proposal will consider each candidate disk in isolation
before falling back to a multi-disk approach.

A picture is worth a thousand words, so just compare the images below to
see the difference on a system which has three hard disks.

{% include blog_img.md alt="Initial Multi-Disk Partitioning Proposal"
src="initial-partitioning-multi-disk-300x215.png" full_img="initial-partitioning-multi-disk.png" %}

{% include blog_img.md alt="Initial Single Disk Partitioning Proposal"
src="initial-partitioning-single-disk-300x198.png" full_img="initial-partitioning-single-disk.png" %}

### Improve Log Viewer Usability   {#improve-log-view-usability}

YaST has featured a log viewer for a long time which allows the user to
inspect files under `/var/log` like `messages`, `boot.log` or even YaST logs
(`YaST2/y2log`). However, we are already in the *Systemd* times and most of
your system services will log relevant information to the *Systemd* journal.

For that reason, YaST2 offers a really nice log viewer for
(`yast2-journal`) which includes interesting filtering capabilities.

The problem is that, as one of our users stated in a [rather old bug
report][2], having two different tools to check logs can be confusing.
Of course, they are getting information from different places so we
decided to keep both of them. However, now the old log viewer will show
a hint when no information is found in those old-style logs.

{% include blog_img.md alt="Use yast2-journal instead"
src="use-yast2-journal-hint-300x169.png" full_img="use-yast2-journal-hint.png" %}

### yast2-sshd Has a New Maintainer   {#yast-sshd-has-a-new-maintainer}

We would like to finish this report announcing that yast2-sshd has a new
maintainer outside of the YaST team. This module was dropped back in
2013 and it was shipped in openSUSE 12.3 for the last time.

However, YaST is open source and Caleb Woodbine has built [fresh RPM
packages][3] after fixing [a problem he found][4] in the firewalld
integration. So if you are interested in such a module, check out
Caleb’s work.

Thanks a lot, Caleb!

### Conclusions   {#conclusions}

As we mentioned at the beginning of this post, there is quite some work
in progress but, sadly, you will need to wait for another two weeks to
get more details. :smiley:

Stay tunned!



[1]: https://doc.opensuse.org/projects/libzypp/HEAD/zypp-repovars.html
[2]: https://bugzilla.suse.com/show_bug.cgi?id=948729
[3]: https://build.opensuse.org/package/show/home:Boby_MC_bobs/yast2-sshd
[4]: https://bugzilla.suse.com/show_bug.cgi?id=1112491

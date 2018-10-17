---
layout: post
date: 2018-10-09 15:09:06.000000000 +00:00
title: Highlights of YaST Development Sprint 64
description: Another two weeks of development, another report from the YaST team.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- Usability
- YaST
---

During this sprint, we have been working to improve the usage and
installation experience in many areas, including but not limited to the
following:

* Improvements in several areas of the Partitioner.
* More informative Snapper.
* Better integration of the new Firewall UI with AutoYaST.
* Improvements in roles management and in the roles description.
* Better support in YaST Firstboot for devices with no hardware clock,
  like Raspberry Pi.

Let’s dive into the details.

### Changes in the Partitioner UI to Unleash the Storage-ng Power

We have explained already in several previous posts how we were
struggling to come up with a set of changes to the user interface of the
Partitioner that would allow to expose all the new functionality brought
by storage-ng, while still being familiar to our users and fitting in a
text console with 80 columns and 24 lines.

We finally implemented the interface which fits into a 80×24 text console
and allows all kind of operations. Check that document for more info about
the behavior and its rationale.

But what does “all kind of operations” mean? For example, it means it’s
possible to start with three empty disks and end up creating this
complex setup using only the Partitioner.

{% include blog_img.md alt="Complex storage setup"
src="complex-devicegraph-236x300.png" full_img="complex-devicegraph.png" %}

* In that example, `/dev/md0` is an MD RAID defined on top of two
  partitions and formatted as “/”. Nothing impressive here so far.
* `/dev/md1` is an MD RAID defined on top of a combination of full disks
  and partitions. Using disks as base for a RAID was not possible in the
  old Partitioner.
* Even more, `/dev/md1` contains partitions like `/dev/md1p1` and
  `/dev/md1p2`, another thing that the old Partitioner didn’t allow to
  configure.
* `/dev/volgroup0` is an LVM VG based on one of those MD partitions,
  allowing to combine the best of the MD and LVM technologies in a new
  way.
* Last but not least, `/dev/sdc` is a disk formatted to host a
  file-system directly, with no partitions in between (also a new
  possibility).

The general approach of the new UI is described in the linked document.
But since an image is worth a thousand words (and an animation is
probably worth two thousands), let’s see how some part of the process to
create the complex setup described about would look in a text console.

This is how you can now directly format a disk with no partitions.

{% include blog_img.md alt="Formatting a disk"
src="formatting_a_disk.gif" %}

Playing with the partitions of a disk is also a good way to get a
feeling on how the buttons are now organized and how they dynamically
change based on which row is selected in each table. Click on the
following image to animate it and see those views in action.

{% include blog_img.md alt="Playing with partitions"
src="playing_with_partitions-play.png" full_img="playing_with_partitions.gif" %}

And for a full experience of completely new stuff. Click on the image
below to see an animation showing the whole process of creating an MD
RAID on top of two full disks and then creating partitions within the
resulting RAID.

{% include blog_img.md alt="Creating a partitioned RAID"
src="creating_partitioned_array-play.png" full_img="creating_partitioned_array.gif" %}

But although the text mode is the limiting factor to design a YaST UI,
many users install their systems and use the Partitioner in graphical
mode. For those wondering how the reorganized buttons look in that case,
here are some screenshots of the installation process of the upcoming
SLE-15-SP1 (static screenshots this time, we already had enough
animations for one post).

{% include blog_img.md alt="Managing RAIDs with the new Partitioner UI"
src="raid-qt-300x215.png" full_img="raid-qt.png" %}

{% include blog_img.md alt="Managing Partitions with the new Partitioner UI"
src="partitions-qt-300x214.png" full_img="partitions-qt.png" %}

### Displaying Bcache Devices Consistently in the Device Graphs

Surely most Partitioner users have recognized the style of the visual
representation used above for the complex example setup. As you know,
the Partitioner offers similar representations in the “Device Graphs”
section, both for the original layout of the system and for the target
one.

After adding support for Bcache to the Partitioner we detected a small
but annoying problem in those graphs. The caching devices were using
their UUID as labels, which had two drawbacks.

* It was too long.
* It’s not known in advance for “planned” cache sets (i.e. sets that
  will be created after going forward in the Partitioner), which
  resulted in boxes with no labels

So know we use a fixed “bcache cache” label for all cache sets, which
looks like this.

{% include blog_img.md alt="New label for cache sets in the Device Graph"
src="cset-label-300x221.png" full_img="cset-label.png" %}

As opposed to the old way with empty boxes.

{% include blog_img.md alt="Lack of labels in the old Device Graphs"
src="cset-no-label-300x222.png" full_img="cset-no-label.png" %}

### Adding and removing Bcache devices

And since we mention the Bcache support in the Partitioner, it’s worth
noticing that the implementation continues moving forward at good pace.
During this sprint we implemented a first version of the operations to
add a new Bcache device and to delete it.

When adding a new device, the only options that can currently be defined
is which devices to use to construct it. But the next sprint has started
and you can expect more options to be supported in the near future.

{% include blog_img.md alt="Creating a new Bcache device"
src="create-bcache-300x220.png" full_img="create-bcache.png" %}

When the Bcache device is created, then it can be formatted, mounted or
partitioned with the same level of flexibility than other devices in the
system. So soon (after the usual integration and automated testing
phases) Tumbleweed users will be able to use the YaST Partitioner to
test this exciting technology.

Of course the operation to delete a Bcache device offers the usual
checks and information available in other parts of the Partitioner, like
shown in the following screenshot.

{% include blog_img.md alt="Deleting a bcache device"
src="delete-bcache-300x221.png" full_img="delete-bcache.png" %}

Both screenshots are taken with an updated version of the installer of
the upcoming SLE-15-SP1, since this functionality will be available in
such distribution and, of course, also in openSUSE Leap 15.1.

### Snapper: Show Used Space for each Snapshot

As those following our blog already know, the YaST Team is also somehow
responsible for the development and maintenance of Snapper, the ultimate
file-system snapshot tool for Linux. And Snapper has also received some
usability improvements during this sprint.

For systems with btrfs and quota enabled, the output of “snapper list”
now shows the used space for each snapshot. The used space in this case
is the exclusive space of the btrfs quota group corresponding to the
snapshot.

```
# snapper --iso list
Type   | # | Pre # | Date                | User | Used Space | Cleanup | Description      | Userdata
-------+---+-------+---------------------+------+------------+---------+------------------+--------------
single | 0 |       |                     | root |            |         | current          |
single | 1 |       | 2018-10-04 21:00:11 | root | 15.77 MiB  |         | first filesystem |
single | 2 |       | 2018-10-04 21:19:47 | root | 13.78 MiB  | number  | after install    | important=yes
```

For more details about this change, its advantages and limitations,
check the [new post at the Snapper blog][1].

### Simplified Role Selection

The role selection dialog in SLE-15 is always displayed in the
installation workflow. However, it does not make much sense to display
it if there is only one role to select. When you do not register the
system and do not use any additional installation repository then in the
default SLES-15 installation you can see only the *minimal* system role.

{% include blog_img.md alt="Selecting one out of one roles"
src="one-role-300x225.png" full_img="one-role.png" %}

In such case you cannot actually change anything as the only role is
pre-selected by default and the only thing which you can do is to press
the *Next* button.

Therefore we improved in for SLE15-SP1, if there is only one role to
select then the role is selected automatically and the dialog is
skipped.

In addition to that, many of the role descriptions have been adapted and
simplified to, hopefully, be more clear.

### YaST Firstboot in devices with no hardware clock

SLE and openSUSE can be installed on a great variety of devices,
including some system that doesn’t include a hardware Real Time Clock,
like the popular Raspberry Pi. That means the usual mechanism to
establish the current date and time (using the `hwclock` command) fails
in such devices. That general problem was detected during the usage of
YaST Firstboot to configure new devices.

So now YaST detects situations in which there is no Real Time Clock and
uses the `date` as an alternative to set the date and time. This fix,
already submitted to openSUSE Tumbleweed, will be available in all
upcoming versions of SLE (like SLE-12-SP4 and SLE-15-SP1) and openSUSE
Leap.

### Better integration of the new Firewall UI with AutoYaST

On the [previous report][2] we anticipated the new UI we are building
for configuring Firewalld from YaST. During this sprint we have been
focusing on some aspects that need to be finished before we can release
this new functionality.

Now this UI can be invoked from the AutoYaST module in YaST, meaning it
can be used to import and then fine tune the current configuration of
the system so it can be exported to an AutoYaST profile.

And since we are already in animation mood, check how the new UI can be
used to define an AutoYaST profile.

{% include blog_img.md alt="Using the Firewalld UI from the AutoYaST module"
src="firewall_ay_config.gif" %}

Very soon the whole functionality will be ready for prime time and we
will release it together with a separate blog post to explain all the
details.

### Stay tuned

We are already working on the next sprint, with special focus on
AutoYaST, on Snapper and on improving the installation experience in
several scenarios. As mentioned above, it’s likely that you will get
more news from us (about the new Firewalld support) even before that
sprint is finished.

But if you can’t wait for more news, don’t hesitate to visit us on our
Irc #yast channel on Freenode. Otherwise, see you here again soon.



[1]: http://snapper.io/2018/10/04/used-space.html
[2]: {{ site.baseurl }}{% post_url 2018-10-01-yast-squad-sprint-63 %}

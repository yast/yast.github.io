---
layout: post
date: 2019-06-19 10:42:24.000000000 +00:00
title: Getting further with Btrfs in YaST
description: Since the YaST team rewrote the software stack for managing the storage
  devices, we have been adding and presenting new capabilities in that area regularly.
  That includes, among other features, the unpaired ability to format and partition
  all kind of devices and the possibility of creating and managing Bcache devices.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

Since the YaST team rewrote the software stack for managing the storage
devices, we have been adding and presenting new capabilities in that
area regularly. That includes, among other features, the unpaired
[ability to format and partition][1] all kind of devices and the
possibility of [creating and managing Bcache devices][2]. Time has come
to present another largely awaited feature that is just landing in
openSUSE Tumbleweed: support for multi-device Btrfs file systems.

As our usual readers surely know, Btrfs is a modern file system for
Linux aimed at implementing advanced features that go beyond the scope
and capabilities of traditional file systems. Such capabilities include
subvolumes (separate internal file system roots), writable and read-only
snapshots, efficient incremental backup and our today’s special: support
for distributing a single file system over multiple block devices.

### Multi-device Btrfs at a glance

Ok, you got it. YaST now supports multi-device Btrfs file system… but,
what that exactly means? Well, as simple as it sounds, it’s possible to
create a Btrfs file system over several disks, partitions or any other
block devices. Pretty much like a software-defined RAID. In fact, you
can use it to completely replace software RAIDs.

Let’s see an example. Imagine you have two disks, `/dev/sda` and
`/dev/sdb`, and you also have some partitions on the first disk. You can
create a Btrfs file system over some devices at the same time, e.g.,
over `/dev/sda2` and `/dev/sdb`, so you will have a configuration that
looks like this.


            /dev/sda                /dev/sdb
                |                       |   
                |                       |   
         ---------------                |   
        |               |               |   
        |               |               |   
    /dev/sda1       /dev/sda2           |   
                        |               |   
                        |               |   
                         ---------------
                                |   
                              Btrfs
                                |   
                                |   
                                @ (default subvolume)
                                |   
                                |   
                     -----------------------
                    |       |       |       |   
                    |       |       |       |   
                  @/home  @/log   @/srv    ...

Once you have the file system over several devices, you can configure it
to do data striping, mirroring, striping + mirroring, etc. Basically
everything that RAID can do. In fact, you can configure how to treat the
data and the Btrfs meta-data separately. For example, you could decide
to do striping with your data (by setting the data RAID level to the
`raid0` value) and to do mirroring with the Btrfs meta-data (setting it
as `raid1` level). For both, data and meta-data, you can use the
following levels: `single`, `dup`, `raid0`, `raid1`, `raid10`, `raid5`
and `raid6`.

The combination of this feature and Btrfs subvolumes opens an almost
endless world of possibilities. It basically allows you to manage your
whole storage configuration from the file system itself. Usage of
separate tools and layers like software-defined RAID or LVM are simply
dispensable when using Btrfs in all its glory.

### Managing multi-device Btrfs with the YaST Partitioner

Interesting feature indeed, but where to start? As usual, YaST brings
you the answer! Let’s see how the YaST version that is currently being
integrated in openSUSE Tumbleweed will ease the management of this cool
Btrfs feature. SLE and Leap users will have to wait to the next release
(15.2) to enjoy all the bells and whistles.

First of all, the Btrfs section of our beloved Expert Partitioner has
been revamped as shown in the following picture.

{% include blog_img.md alt="New Btrfs section of the Partitioner"
src="btrfs_section-300x157.png" full_img="btrfs_section.png" %}

It lists all the Btrfs file systems, single- and multi-device ones. You
can distinguish them at first sight by the format of the name. The table
contains the most relevant information about the file systems, alongside
buttons to add a new file system and to delete and modify the existing
ones.

Existing Btrfs file system can be inspected and modified in several
ways. The “Overview” tab includes details like the mount point, file
system label, UUID, data and meta-data RAID levels, etc. The file system
can be edited to modify some aspects like the mount options or the
subvolumes.

{% include blog_img.md alt="Overview of a Btrfs file system"
src="show-300x157.png" full_img="show.png" %}

In addition, the tab called “Used Devices” contains a detailed list of
the block devices being used by the file system. That list can also be
modified to add or remove devices. Note such operation can only be done
when the file system does not exist on disk yet. Theoretically, Btrfs
allows to add and remove devices from an already created file system,
but a balancing operation would be needed after that. Such balancing
operation could take quite a considerable amount of time. For that
reason it has been avoided in the Expert Partitioner.

{% include blog_img.md alt="Devices of a Btrfs file system"
src="used_devices-300x158.png" full_img="used_devices.png" %}

Of course, you can still format a single device as Btrfs in the
traditional way (using the “edit” button for such device). But let’s see
how the new button for adding a Btrfs file system opens new
possibilities.

{% include blog_img.md alt="Adding a Btrfs file system"
src="add_filesystem-300x157.png" full_img="add_filesystem.png" %}

Similar to the RAID dialog, you have the available devices on the left
and you can select the devices where you want to create the file system,
and also you can indicate the data and meta-data RAID levels. Of course,
the admissible RAID levels will depend on the number of selected
devices. You will go to the second step of the Btrfs creation by
clicking the “Next” button. In this second step, you can select the
mount options and define the subvolumes, see the next image.

{% include blog_img.md alt="Options for a new Btrfs file system"
src="options-300x203.png" full_img="options.png" %}

And apart of all that, the Expert Partitioner has received several small
improvements after including multi-device Btrfs file systems. Now that
the multi-device Btrfs file systems are considered first class citizens,
they are included in the general list of devices. Note the “Type” column
has also been improved to show more useful information, not only for
Btrfs but for all kind of devices.

{% include blog_img.md alt="Revamped list of devices"
src="devices_list-300x157.png" full_img="devices_list.png" %}

### What else works?

But YaST goes far beyond the Partitioner. We have also ensured the
storage proposal (i.e. the Guided Setup) can deal with existing
multi-device Btrfs configurations when you are performing a new
installation. Moreover, the upgrade process is also ready to work with
your multi-device Btrfs file system.

Last but not least, AutoYaST can now also be used to specify that kind
of Btrfs setups. The [official AutoYaST documentation][3] will include a
specific section about advanced management of Btrfs file systems on top
of several block devices. The content is being reviewed by the SUSE
documentation team right now.

### What does not work (yet)?

There is still one scenario that is not 100% covered. As described in
[bug#1137997][4], is still not possible to use the “Import Mount Points”
button in the Partitioner to recreate a multi-device Btrfs layout. But
fear not, it’s in our list of things to fix in the short term!

### Get it while it’s hot

Free Software development is a collaborative process and now we need YOU
to do your part. Please test this new feature and report bugs if
something does not work as you expected. And please, come with your
ideas and further improvements and use cases. And, of course, don’t
forget to have a lot of fun!



[1]: {{ site.baseurl }}{% post_url 2018-10-09-highlights-of-yast-development-sprint-64 %}#changes-in-the-partitioner-ui-to-unleash-the-storage-ng-power
[2]: {{ site.baseurl }}{% post_url 2019-02-27-recapping-the-bcache-support-in-the-yast-partitioner %}
[3]: https://www.suse.com/documentation/sles-15/singlehtml/book_autoyast/book_autoyast.htmlhttps://www.suse.com/documentation/sles-15/singlehtml/book_autoyast/book_autoyast.html
[4]: https://bugzilla.suse.com/show_bug.cgi?id=1137997

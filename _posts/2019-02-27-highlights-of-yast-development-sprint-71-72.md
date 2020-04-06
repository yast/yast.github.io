---
layout: post
date: 2019-02-27 16:39:45.000000000 +00:00
title: Highlights of YaST Development Sprint 71 & 72
description: We know we owe you a report for the previous development sprint (namely
  the 71th). But we also know how to compensate that.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

We know we owe you a report for the previous development sprint (namely
the 71th). But we also know how to compensate that. This week we have
not only one, but up to three blog posts to keep you tuned to the YaST
evolution.

So let’s start with the summary of what have been implemented and fixed
lately. That includes

* Improvements in the Bcache support in the Partitioner
* Users home as Btrfs subvolumes
* Better visualization of Salt formulas in YaST Configuration Management
* Automatic selection of the needed driver packages
* Improvements in many other areas like AutoYaST, bootloader, the
  Partitioner and the storage Guided Setup

You will find links to the other more exhaustive blog posts, about the
recently added Bcache support and the revamped Configuration Management
module, in the corresponding sections of this report.

### Final Improvements in the Bcache Support

During several sprints, we have been detailing our efforts to offer a
decent support for the Bcache technology in the YaST partitioner. During
this sprint we have implemented what we consider the three final bits:

* Bache devices without caching
* Modifying Bcache devices
* Listing all caching sets

We will now detail this three improvements. But to celebrate that Bcache
support looks complete now in the Partitioner, we have published a
[separate blog post][1] explaining what Bcache is and how to take
advantage of that technology using the YaST Partitioner. Enjoy!

And back to the topic of recent improvements, we should mention that the
Bcache technology allows to create a Bcache device without an associated
caching one. This is useful if you are considering to use Bcache in the
future. In that case you can setup all your slow devices as Bcache
backing devices without a cache, leaving open the possibility of adding
caching devices later. That is now possible by selecting the new option
labeled “without caching” during creation, as shown in the following
screenshot.

{% include blog_img.md alt="No caching device in Bcache"
src="no-caching-300x168.png" full_img="no-caching.png" %}

Of course, that’s not much useful without the possibility of modifying a
Bcache device. So in the latest sprints we also added a new “Change
Caching” button.

{% include blog_img.md alt="New option to modify a bcache"
src="modify-bcache-300x223.png" full_img="modify-bcache.png" %}

This option will only work for bcaches that do not exist in your system
yet (e.g., a bcache that you are creating right now). For existing
bcache devices, this option is only available when the bcache has no
associated caching device yet. Otherwise, a detaching action would be
required, and that could take very long time in some situations.

{% include blog_img.md alt="Avoiding detach operations in bcache"
src="no-modify-bcache-300x212.png" full_img="no-modify-bcache.png" %}

And last but not least (regarding Bcache), now the Expert Partitioner
also shows the list of all caching sets in a separate tab
(unsurprisingly) titled “Caching Set Devices”. It is only an informative
tab, but thanks to it you will be able to check all devices currently
used for caching at a quick glance.

{% include blog_img.md alt="List of caching sets"
src="csets-300x223.png" full_img="csets.png" %}

### Create the User’s Home as a Btrfs Subvolume   {#create-user-home-btrfs-subvolume}

As many (open)SUSE users know, [Btrfs][2] offers several advantages over
traditional Linux file-systems. One of them is the possibility of using
subvolumes to customize the configuration and features of different
parts of the same file-system.

From now on, the YaST Users module allows to create the home path of new
users as a subvolume instead of a plain directory, as long as a Btrfs
file-system could be found in the system, of course. As simple as
checking the “Create as Btrfs Subvolume” option that you will find just
below the “Home Directory” field.

{% include blog_img.md alt="Using a Btrfs subvolume as home"
src="subvolume-home-qt-300x226.png" full_img="subvolume-home-qt.png" %}

In a multi-user system, using Btrfs subvolumes for the home paths of the
users can open a world of possibilities. The system administrator can
decide to give some users the ability to create snapshots of their
corresponding home directories, even automated on every login and/or
logout using PAM Snapper. Similar ideas can be applied to a Samba
deployment. Moreover, using subvolumes as homes can also be useful to
implement per user quotas.

Beyond multi-user systems, fine-tuning the mount options or customizing
snapshots and quotas can also be useful for some special system users
(e.g. the user associated to a database system).

And all that, as always in YaST, equally easy to configure with the
graphical interface and with the text-based one.

{% include blog_img.md alt="Moreover, using subvolumes as homes can also be
useful to implement per user quotas, ncurses version"
src="subvolume-home-ncurses-300x192.png" full_img="subvolume-home-ncurses.png" %}

### Better Visualization of SUSE Manager Salt Formulas

As we [announced on January][3], we have been working on updating the
SUSE Manager Salt Formulas support in [YaST Configuration Management][4]
to comply with the latest forms specification. As it happens with the
Bcache support, we feel we have reached a point in which the feature is
polished enough to be shipped in the next (open)SUSE stable releases and
to deserve its own separate blog post. So go and enjoy our [third blog
post of this week][5], a sneak peak into the marriage of SUSE Manager
and YaST, thanks to the magic of Salt Formulas.

In that regard, we have been recently improving how the forms look like
to make them as easy to use as possible. Bear in mind that a form can be
quite long and the support for scrolling in YaST2 is quite limited. In
order to workaround this problem, YaST2 will display a tree at the left
side outlining the structure of the form.

{% include blog_img.md alt="Tree view of long salt formulas"
src="yast-cm-300x197.png" full_img="yast-cm.png" %}

Apart from that, we have solved some known problems, like exporting
date/time and numeric values in a correct way or handling missing and
default values properly.

Sure there are some details that we like to improve but, for now, what
we need is feedback from you. So, if you are interested in such a
functionality, please check the mentioned dedicated blog post about the
topic and have a look to <tt>yast2-configuration-management 4.1.5</tt>.

### Automatically Selecting the Driver Packages in Installed System

In openSUSE Leap 15.0 and SUSE Linux Enterprise 15, the packages
containing drivers needed by the system are installed automatically if
they are available during the installation. However, if a repository
with driver packages is added later in the installed system then the
drivers are not automatically selected to install.

Fortunately, in Leap 15.1 and SLE-15-SP1 the [package solver][6]
implements a new solver mode in which it selects for installation only
the recommended driver packages, without also dragging other non-driver
recommended packages into the system.

For example, after adding the nVidia driver repository in Leap 15.1
(YaST ➝ Software Repositories ➝ Add ➝ Community Repositories, select
“nVidia Graphics Drivers”) and starting the package manager (YaST ➝
Software Management), the respective nVidia driver packages are
automatically selected to install if there is a supported nVidia
graphics card present in the system. This of course works also for the
other driver packages and hardware devices.

Just a last note about automatic selection of recommended driver
packages. When running the package manager for the first time in a
recently installed openSUSE Leap 15.1, it might automatically select
some additional packages to install coming from the Leap OSS on-line
repository (which is added automatically the end of the installation).
Do not be surprised, that’s actually desired. If you do not want to
install those packages simply deselect them, YaST will remember that and
it will not select them next time.

See more details in the corresponding [documentation][7].

### Improved Disk Selection Screen in the Storage Guided Setup

Although it may sound surprising for some users, it’s not uncommon to
install SUSE Linux Enterprise on systems with dozens or even hundreds of
disks. Of course, in those advanced scenarios the automatic partitioning
proposal is not much useful and users are expected to use the Expert
Partitioner. But, what if someone tries to use the partitioning Guided
Setup in a system with 30 disks? In SLE-15 (or Leap 15.0, in the case of
this concrete screenshot) they will see a screen as unusable as this.

{% include blog_img.md alt="Broken Guided Setup screen"
src="old-qt-30-300x176.png" full_img="old-qt-30.png" %}

Of course, it only gets worse if the number of disks increases or if the
text-mode interface is used. So we improved the disk selection screen,
taking also the opportunity to include additional information to make
easier to identify removable devices like USB and IEEE 1394 ones. In
future releases, the screen will normally look pretty much as it looks
in the previous version, just with the extra information about USB.

{% include blog_img.md alt="Normal Guided Setup screen"
src="new-qt-10-300x174.png" full_img="new-qt-10.png" %}

But if the system contains more than 10 disks to choose from, then a
different widget that makes scrolling possible will be used, ensuring
the user interface remains usable enough in both graphical and
text-based modes.

{% include blog_img.md alt="Guided Setup screen with more than 10 disks"
src="new-qt-30-300x175.png" full_img="new-qt-30.png" %}

### YaST Bootloader Becomes Less Whinny

When the installation of the system is spread over multiple physical
disks, YaST Bootloader always tries to setup the bootloader in all those
disks. This helps for example when MD RAID is used to achieve redundancy
and some disk fails. Then the system can still boot from any of the
other disks, since they also contain a proper bootloader.

But in some cases the installation can be spread over multiple disks but
with only one of them being prepared to host the bootloader (e.g.
containing the needed partitions). YaST bootloader used to complain
about it while generating its proposal, which resulted in an error shown
during installation.

In this sprint we have relaxed the YaST Bootloader expectations a bit.
It still tries to create a fail-over setup, but the proposal does not
complain if at least one disk looks bootable. Additionally if Grub2 is
properly installed to at least one device, then possible failures in
other disks will not result in an error pop-up, but just logged for
future reference.

### Device Order for MD RAIDs in AutoYaST

During the development of storage-ng, the feature to specify the device
order for MD RAIDs with AutoYaST was lost. The feature can be useful for
RAID level 10 to ensure that one full half of the RAID will only reside
on one disk subsystem and the other half on the other subsystem. Only
then a complete failure of a single subsystem keeps the RAID working.

Now the feature has been re-implemented for Leap 15.1 and SLE-15-SP1 and
the “device\_order” tag of the AutoYaST profile works as expected. For
further information about configuring RAID with AutoYaST, consult the
[AutoYaST documentation][8].

### Improvements in the Partitioner

That AutoYaST feature was not the only thing that temporarily
disappeared with the replacement of the old storage components by
storage-ng. The “Provide Crypt Passwords” button in the Partitioner was
also not there in the early versions included in openSUSE Leap 15.0. But
it was not really an omission, but a consequence on how the activation
of logical devices works now in YaST.

During installation, all pre-existing logical devices that need some
initialization are always activated to make possible to use them. That
includes LVM, Multipath devices (for which a user confirmation is
requested) and encrypted devices (for which the password is asked to the
user). But triggering such activations in an already installed and
running system cannot be done so lightly, since it affects the execution
of the whole system.

Still, there are cases in which a user executing the YaST Partitioner in
an already installed system may desire to activate currently inactive
devices. To allow that we brought back the “Provide Crypt Passwords”
button, but with two small changes compared to its historical behavior.

* It activates all kind of devices, not only the crypt ones.
* It refreshes all the Partitioner information, reading again the status
  of all the storage devices.

{% include blog_img.md alt="Provide Crypt Passwords button"
src="crypt-button-300x193.png" full_img="crypt-button.png" %}

Of course, any change in behavior is a nice opportunity to revisit and
expand the help texts.

{% include blog_img.md alt="The button explained"
src="crypt-button-help-300x202.png" full_img="crypt-button-help.png" %}

Another change that was intentionally introduced in the first versions
of the rewritten Partitioner was the fact that new file-systems always
got an empty label by default, independently of the previous content of
the partition being formatted.

But the old Partitioner used to do things differently when reformatting
a partition. In that case, it actually copied the label of the previous
file-system into the new one. Some users told us (via bug reports) they
wanted the old behavior back, so now the Partitioner preserves the old
label when a partition is reformatted.

### Wow, that was a lot!

As usual, this report only covers a small portion of what the YaST Team
has been doing. But definitely this time our readers will have enough
material to keep themselves entertained for quite some time. Specially
combining this with the two already mentioned monographic posts about
[the Bcache support][1] and about [the compatibility with SUSE Manager
Salt Formulas][5].

Have a lot of fun reading!



[1]: {{ site.baseurl }}{% post_url 2019-02-27-recapping-the-bcache-support-in-the-yast-partitioner %}
[2]: https://btrfs.wiki.kernel.org
[3]: {{ site.baseurl }}{% post_url 2019-01-31-highlights-of-yast-development-sprint-69-70 %}#revamping-suse-manager-salt-formulas-support
[4]: https://github.com/yast/yast-configuration-management/
[5]: https://lizards.opensuse.org/2019/02/27/getting-yast-cm-up-to-date/
[6]: https://github.com/opensuse/libsolv
[7]: https://github.com/yast/yast-packager/wiki/Selecting-the-Driver-Packages
[8]: https://www.suse.com/documentation/sles-15/singlehtml/book_autoyast/book_autoyast.html#ay.raid_configuration

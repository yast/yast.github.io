---
layout: post
date: 2018-09-12 14:11:31.000000000 +00:00
title: YaST Squad Sprint 62
description: 'We did quite a lot of improvements in this sprint!'
category: SCRUM
tags:
- Factory
- Systems Management
- YaST
- github
- jenkins
- storage
---

### The Sprint Summary

* Jenkins commenting in GitHub pull requests
* Intel Rapid Start Technology for better sleeping
* Consistent storage proposal in SLE-12
* Partitioner: designing the UI for its full potential
* Partitioner: entire disks as members of a software MD RAID
* Partitioner: better explanation of unusual conditions
* A sample of bug fixes

### Improved Jenkins Integration   {#improved-jenkins-integration}

It happened quite often that our [Jenkins][1] job failed for some reason
after merging a pull request at GitHub. And because the Jenkins is
supposed to submit the changes to the build service it happened that the
fixes from Git were not released in the RPM packages if nobody noticed
the failure. That was a bit confusing because we closed a bug at
Bugzilla but the fix was not available anywhere.

To avoid this we have added a wrapper script which runs the original
Jenkins command (`rake osc:sr` in this case) and writes the result as a
comment to the respective pull request at GitHub. If a submit request is
created it additionally adds a link to it.

{% include blog_img.md alt="Jenkins Integration Screenshot"
src="s62-1-jenkins-300x226.png" full_img="s62-1-jenkins.png" %}

Since now you should keep the pull request page open after merging it
and wait for the Jenkins status result. If it fails for some reason then
try fixing it or ask for help on IRC or the YaST mailing list.

Note: This automation works only for the code branches which are in
active development and for packages which have an Jenkins job assigned
(most of the YaST packages have).

### Intel Rapid Start Technology Support   {#intel-rapid-start-technology-support}

The [Intel Rapid Start Technology][2] allows to use a fast disk (SSD)
for suspend-to-RAM to save energy. The idea is that after a given time
the contents of RAM will be moved to SSD so that the system can power
itself off. When powered on, RAM will be read back. So it’s something
like a dynamic changing of suspend-to-RAM to suspend-to-fast-disk.

What does this technology need from the installer? It needs its own
dedicated partition where it can store the contents of RAM. To support
this technology we added in this sprint the ability to create and
recognize such a partition. It looks like this:  

{% include blog_img.md alt=""
src="s62-2-irst1-300x220.png" full_img="s62-2-irst1.png" %}

{% include blog_img.md alt=""
src="s62-3-irst2-300x220.png" full_img="s62-3-irst2.png" %}

### Consistent Storage Proposal (SLE-12-SP4 / yast2-storage-old)   {#consistent-storage-proposal-sle-12-sp4-yast2-storage-old}

We fixed a bug where the behavior was inconsistent if you switched the
storage proposal between partition-based and LVM-based / encrypted
LVM-based: [bsc#1085169][3].

The behavior was pretty irritating: Initially, it would propose to
create a separate “/home” partition, but when you changed the proposal
parameters and simply kept that checkbox *“\[x\] separate /home”*
checked, it would complain that with the current settings a separate
“/home” was not possible.

The two code paths did the calculations differently: One accounted for
the other partitions that were also proposed like “swap” and “boot” (or
“PrEP” or “/efi-boot”), the other did not. We unified that as much as
reasonably possible without breaking things, but since calculating when
and how to use any boot partitions is quite complex in that
<del>old</del> legacy storage stack, we did not go all the way; boot
partitions are pretty small, so their size matters only in very
pathological fringe cases. We try not to overengineer things, in
particular not with the 4th service pack for a business product.

More details in the [pull request with the fix][4].

### The Partitioner looks to the future   {#the-partitioner-looks-to-the-future}

We have blogged a lot about Storage-NG and the possibilities and
features it will bring to the users. But a significant part of its power
remain dormant under the surface because we decided to clone the user
interface and the functionality of the classical YaST Partitioner for
the deadline marked by SLE 15 (and Leap 15.0). But now we are finally
able to start exposing those long-awaited features and to bring new ones
for the current Tumbleweed and for the future SLE-15-SP1 and Leap 15.1.

The user interface of the Partitioner is already rather packed with
functionality, but we want to avoid a too disruptive redesign. So it was
time to some pen and paper sessions, trying to find and draw a good way
to add exciting new stuff to the Partitioner, including all of the
following:

* Allow entire disks (no partition table) to be added as members of a
  software MD RAID.
* Manage (create, modify and delete) partitions within a software MD
  RAID device.
* Make possible to format an entire disk (no partition table) and/or
  define a mount point for it (just as we do with partitions or LVM
  logical volumes).
* Manage [Bcache][5] so the user can set and configure which devices
  will be used to speed up others.

As usual, we consulted some UI experts in the process and the result is
this [first version of a document][6], which summarizes how to
incorporate all that to the Partitioner, including some alternatives we
are considering for the near future.

That document will become the cornerstone of future developments.
Sometimes you need to spend a sprint doing other stuff (like researching
and documenting) before you can go ahead with writing code.

### Partitioner: full disks as members of a software MD RAID   {#partitioner-full-disks-as-members-of-a-software-md-raid}

The first of the features described in the previous document is already
available for Tumbleweed users (or it will be as soon as the integration
process concludes) and, thus, ready for the upcoming releases of SLE and
Leap. Now the Partitioner offers full disks as “Available Devices” in
the RAID screen, following the criteria and considerations explained at
the document.

That brings even more ways of combining devices together (disks,
partitions, software RAIDs, you name it) to create a storage setup. As a
result, we decided it was important to explain the situation when some
combinations are not possible right away, likely because they need some
previous step. Which brings us to…

### Partitioner: more specific errors when a device is in use   {#partitioner-more-specific-errors-when-a-device-is-in-use}

In general, most of the checks already present in the Partitioner were
already able to correctly handle situations in which the disk was a
direct member of an MD RAID or an LVM volume group. But the message
about the device being in use was not informative enough.

{% include blog_img.md alt=""
src="s62-4-part-err1-300x140.png" full_img="s62-4-part-err1.png" %}

Now the message includes the name of the device that is making the
operation impossible (it’s usually one, but there are corner cases in
which it can be more than one), so the user has some clue about how to
fix it.

{% include blog_img.md alt=""
src="s62-7-part-300x170.png" full_img="s62-7-part.png" %}

### Partitioner: improved creation of partition table   {#partitioner-improved-creation-of-partition-table}

One part of the Partitioner that was specially bad at explaining the
current situation and the possible consequences was the workflow of
“Create New Partition Table”, which also used to exhibit a behavior
quite inconsistent with the rest of the Partitioner actions.

In SLE-15 and openSUSE Leap 15.0, the “Create New Partition Table”
button immediately presents a form to select the partition table type in
case the device supports more than one.

{% include blog_img.md alt=""
src="s62-6-part-300x188.png" full_img="s62-6-part.png" %}

And **after** the user selects one type it **always** shows a warning
about all kind of devices to be destroyed, no matter if some device is
really affected or not.

{% include blog_img.md alt=""
src="s62-5-part-err2.png" full_img="s62-5-part-err2.png" %}

Even better, if only one partition table type is possible, it still
shows the form but with no question. So creating a partition table in a
completely empty DASD device result in a misleading warning (nothing is
going to be destroyed) on top of an empty wizard.

{% include blog_img.md alt=""
src="s62-8-part-300x178.png" full_img="s62-8-part.png" %}

So the whole action was reimplemented to display the warning only if
some devices are indeed going to be affected (including the list of
affected devices) and to display that warning as soon as the user clicks
the button (as any other Partitioner action).

{% include blog_img.md alt=""
src="s62-9-part-good-300x206.png" full_img="s62-9-part-good.png" %}

As seen in the screenshot, the check handles correctly situations in
which the disk as a whole (no partitions) is part of an MD RAID or an
LVM setup. And, of course, there are no empty wizard steps in the case
of DASD or nothing like that. Now the workflow works in the expected way
on each situation.

In short, the Storage-NG Partitioner is moving away, step by step, from
being a 1:1 clone of the historical Partitioner to offer more
functionality and usability. And there are more improvements to come in
that area.

### Partitioner: Unmounting devices in advance   {#partitioner-unmounting-devices-in-advance}

The Partitioner allows to extensively configure your system storage
devices. You can perform a lot of different kind of actions, from
changing the label of a file system to creating a complex configuration
by using LVM or RAIDs. Each modification you perform is stored in
memory, so the real system is not altered at all until you confirm to
apply the changes as last step. But in some circumstances, the
Partitioner could not be able to perform some of the required actions,
and it would fail when trying to modify the real system. One action that
sometimes might fail is unmounting a device. This action might fail for
several reasons, but the most common is because the file system is busy.
And moreover, sometimes there are actions that require the device to be
unmounted, for example, for deleting a partition, so the Partitioner
would try to automatically unmount it.

During this sprint, the Partitioner has recovered its ability of
unmounting devices on the fly to avoid possible failures when applying
the changes. Now, if you want to delete a currently mounted device
(e.g., a LVM Logical Volume) you will be asked in advance to unmount it.
If you accept, the Partitioner will try to unmount the device on the fly
without waiting to apply all the changes. In case the unmount action
fails, you will be informed about the problem and you might try to
manually solve the problem before the Partitioner applies the changes in
your system. Of course, you can also continue without unmounting the
device and the Partitioner will try to automatically unmount it after
accepting all the changes.

{% include blog_img.md alt=""
src="s62-91-umount-300x225.png" full_img="s62-91-umount.png" %}

{% include blog_img.md alt=""
src="s62-92-umount-300x225.png" full_img="s62-92-umount.png" %}

Another task that might require unmounting the device is resizing the
filesystem. The Partitioner will ask you about unmounting the device
when the filesystem does not support resizing while being mounted. And,
even when the filesystem does support it, you still might be requested
to unmount the device. For example when you want to extend a device by
more than 50 GiB. That task might be quite slow and it is highly
recommended to unmount the device to speed up the resizing time,
otherwise it could take hours.

{% include blog_img.md alt=""
src="s62-93-grow-300x225.png" full_img="s62-93-grow.png" %}

### Bug Fixes   {#bug-fixes}

Of course, we continue fighting against bugs. Thus, from this sprint on,
alongside other minor stuff, the system

* [obeys the user and does not keep running the chrony service][7] when
  they uncheck the “Run NTP as daemon” option in the timezone dialog.
* [does not crash when the user has no access to the journal logs][8],
  displaying a human-readable message, even with a hint!
* [copies the correct metadata file][9] during the installation, and
* [limits the size of the registration code][10], to avoid showing you
  an ugly and unintelligible error in case of you write there a long
  paragraph instead ;-P



[1]: https://ci.opensuse.org/view/Yast/
[2]: https://software.intel.com/en-us/articles/what-is-intel-rapid-start-technology
[3]: https://bugzilla.suse.com/show_bug.cgi?id=1085169
[4]: https://github.com/yast/yast-storage/pull/301
[5]: https://bcache.evilpiepirate.org/
[6]: https://github.com/yast/yast-storage-ng/blob/master/doc/sle15_features_in_partitioner.md
[7]: https://github.com/yast/yast-ntp-client/pull/116
[8]: https://github.com/yast/yast-journal/pull/34
[9]: https://github.com/yast/yast-installation/pull/738
[10]: https://github.com/yast/yast-registration/pull/398

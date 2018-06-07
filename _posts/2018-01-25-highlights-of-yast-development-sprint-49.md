---
layout: post
date: 2018-01-25 11:29:42.000000000 +00:00
title: Highlights of YaST Development Sprint 49
description: Time goes by and the YaST wheel keeps rolling. So let's take a
  look to what have moved since our previous development report.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

Time goes by and the YaST wheel keeps rolling. So let’s take a look to
what have moved since our [previous development report][1].

### More flexible NET installation ISOs

Network installation media for Tumbleweed or Leap only work properly
with the exact repository they have been built for – which for
Tumbleweed may mean they could be outdated after just one day.

You would then run into this message:

{% include blog_img.md alt="Linuxrc warning"
src="linuxrc_net1-300x167.jpg" full_img="linuxrc_net1.jpg" %}

To improve the situation the installer can now offer to download
matching boot files (kernel and `initrd`, to be precise) from the
repository if it detects this situation:

{% include blog_img.md alt="Linuxrc offering a solution, as always"
src="linuxrc_net2-300x167.jpg" full_img="linuxrc_net2.jpg" %}

Of course, you can say ‘No’ here – but then you’re back to the red
dialog. :smiley:

Technically, what’s done is to download a new kernel/initrd pair from
the repository and restart the installation process with them (using
kexec). So be prepared for a slight déjà vu.

This feature is controlled by the [`kexec`][2] boot option.

### Storage-ng lands into Tumbleweed: handle with care

But that’s not the only news we have about openSUSE Tumbleweed. Our
usual readers already know about Storage-ng, our effort to rewrite the
whole YaST storage stack from scratch. And they also know it’s still a
work in progress. But since there were too many valuable changes blocked
by the adoption of Storage-ng, it was decided it was time to push the
red button. So we are glad to announce the Storage-ng era has started
with its inclusion in the first official (open)SUSE product – starting
with snapshot 20180117, `libstorage-ng` has replaced `libstorage` and,
thus, `yast2-storage-ng` has replaced `yast2-storage`.

They say forewarned is forearmed, so an article [was published in
advance][3] in news.opensuse.org to set the expectations and to provide
and overview of the current status. We would like to encourage all
openSUSE Tumbleweed users to (re)visit the article to get a better
picture of the situation.

### Alignment of partitions in the expert partitioner

An important part of that work in progress is the re-implementation of
the Expert Partitioner with Storage-ng technologies. As mentioned many
times in previous posts, this is mainly a 1:1 clone, with the same
functionality presented in exactly the same way than the classic YaST
partitioner. But some times we take the opportunity to introduce some
improvement here and there, as we did this week with a topic that can
have a very noticeable impact in the system performance: partitions
alignment.

Although many people is not aware of it, the partitions in a system must
be properly aligned to avoid the performance drop caused by excessive
read-modify-write cycles. For details please refer to the [great article
at Wikipedia explaining the topic][4], especially the sections titled “4
KB sector alignment” and “SSD page partition alignment”. Moreover,
leaving performance considerations aside, some partition tables require
alignment to simply work, like DASD partition tables which need
alignment to tracks (usually 12 sectors).

The new expert partitioner takes all that into consideration when
creating and resizing partitions, ensuring always the required alignment
(like the DASD tracks) and encouraging the optional performance-related
one, avoiding undesired gaps between partitions in the process.

{% include blog_img.md alt="Detail of the Expert Partitioner dialog to create a partition"
src="add_partition-300x193.png" full_img="add_partition.png" %}

Above you can see the dialog for choosing the size for a new partition
that, unsurprisingly, looks very much like the same dialog in the
pre-storage-ng Expert Partitioner. If a size is specified by the user in
that dialog (any of the two first options in the form), the start and
end of the partition will be aligned to ensure optimal performance and
to minimize gaps. That may result in a slightly smaller partition (with
the difference being usually less than 1MiB). If a custom region is
specified, the start and end will be honored as closely as possible,
with no performance optimizations (although mandatory alignment, like
DASD tracks, still will take place). This third option is the best to
create very small partitions.

The same considerations for optimal alignment will also be taken into
account while resizing an existing partition and calculating the minimal
and maximal sizes suggested by the partitioner during that process.

{% include blog_img.md alt="Choosing the new size of a resized partition"
src="resize_partition-300x216.png" full_img="resize_partition.png" %}

### Sanity checks for the storage setup

The possibility of bypassing the performance optimizations in the Expert
Partitioner is just one example of the (potentially unleashed) power
that tool provides. As a consequence of that flexibility, sometimes the
user can overlook some important setup configurations or even make
mistakes. To help with that, the Expert Partitioner recovered this week
its ability to check the entered storage setup.

Once the user has set partitions, LVM volumes, file systems, mount
points, etc. and decides to proceed, the Partitioner will validate that
setup to ensure it fulfills all necessary requirements for booting and
running the system. When some issue is detected, a popup message is
presented to show what the problem is, offering the option to ignore the
warning and move forward.

{% include blog_img.md alt="The resurrected partitioner sanity checks"
src="setup_checks-1-300x207.png" full_img="setup_checks-1.png" %}

Two kind of checks are carried out to ensure the partitioning setup
validity. First, the presence of needed partitions for booting is
checked. Booting requirements depends on the current architecture (x86,
PowerPC, AArch, etc.) and other technical details like the partition
table type (GPT vs MS-DOS). Then, the mandatory volumes for the current
product are checked. The mandatory volumes are defined in the revamped
`partitioning` section of the control file. Typically, only a volume for
root and another for swap used to be mandatory, but now this is totally
configurable by anyone defining the product (SLE, Leap, Tumbleweed, your
own custom openSUSE derivative…).

As a bonus, all the sanity checks are now centralized (they used to be
scattered around the YaST source code) and it’s easier to add new ones
(you will miss some old checks at this moment) and to use them from
other parts of YaST (like the bootloader module or AutoYaST).

### More improvements in the Expert Partitioner

The new warnings and the alignment improvements commented above are not
the only news on the evolution of the Expert Partitioner clone this
week. Resizing of LVM devices has also been brought back to life, both
for volume groups and logical volumes. In the case of logical volumes,
the functionality is not much different, at least in the surface, from
the partition resizing that was already present and that you can see in
the screenshot of the alignment section.

On the other hand, in the context of the Partitioner, resizing a volume
group actually means adding or removing physical volumes. Actions that
are now possible again, including the corresponding checks. For example,
a physical volume cannot be removed if it already exists on disk (that
could destroy your data) or if the resulting size of the volume group is
not enough to cover all its logical volumes.

{% include blog_img.md alt="Trying to remove the wrong PV"
src="remove_pv-300x207.png" full_img="remove_pv.png" %}

Apart from the mentioned functionality, there has also been improvements
in how the Expert Partitioner presents the information. For example, now
the “type” column shows the correct label and icon for each device
instead of that useless `TODO` label. Moreover, similar `TODO` marks
were replaced by proper data in the device overview tab.

{% include blog_img.md alt="TODO labels aregone"
src="no_more_todos-300x207.png" full_img="no_more_todos.png" %}

### Minimize changes between the SLE15 “Installer” and “Packages” DVDs

The SUSE Enterprise Server 15 (SLES15) product can be installed from a
bootable “Installer” DVD medium which contains the installer and a
subset of packages needed for a very minimal system. The other packages
are available either from a registration server (after registering the
SLES product) or via a separate “Packages” DVD medium.

Due to the structure of those DVDs (with some packages being in present
in both) the SLES installer was asking the user to change the medium
several times during the installation process. Ideally the installer
should use all packages from the “Packages” medium without changing the
media.

In addition, there is yet another requirement for preferring the
packages from the installation DVD to the packages available via a
remote repository. Downloading a package from the internet is usually
much slower than the DVD and can be problematic in network connections
with a download limit or with a price based on the bandwidth usage.

Now the installer properly adjust the priority of all the repositories
to achieve the desired behavior. To avoid possible side effects we
decided to change the repository priority only when more than one
repository is used and all repositories are local (e.g. DVD, hard disk,
USB flash disk…). That means in some less common cases (2 DVDs + a
remote repository) you will still need to change the medium but this is
a safer solution.

### Add On products in AutoYaST

For those using SLE Add On products, we have improved the error message
if an Add On Product cannot be added during an AutoYaST installation.
The user can see now which wrongly configured Add On Product has
produced the error.

{% include blog_img.md alt="AutoYaST reporting which Add On is wrong"
src="autoyast_addon-300x231.jpeg" full_img="autoyast_addon.jpeg" %}

This will be specially useful with the upcoming SLE15, in which the
concepts of Add Ons and Modules will become more relevant than ever.

### Fixed a crash when shutting down the YaST user interface

And now it’s time for the corresponding dose of technical insights for
those who enjoy that part of our reports.

When `UI::OpenDialog()` and `UI::CloseDialog()` calls didn’t match when
shutting down the UI (user interface YaST component), you’d get a
segmentation fault with a core dump. Well, you *did* want to shut down
YaST, but probably not like that. This is now fixed.

After tracking this down, it was surprisingly simple to reproduce: Just
use the YaST version of the trivial “Hello, World” program and comment
out the `UI::CloseDialog()` call.

This was a case of providing additional error reporting causing more
problems than the original error: leaving dialogs open while terminating
the program is an error, of course. But fixing this little problem by
cleaning up the remaining dialogs lead to handling widgets after some of
the underlying infrastructure (in this case the `QApplication`) was
already destroyed, so all the QWidgets were also destroyed (because the
QApplication takes care of that), but YaST’s generic UI layer was still
unaware of that fact and tried to destroy them again.

This is now fixed by properly cleaning up the widget tree in YaST’s
generic UI layer first which will also clean up the associated QWidgets
so there is nothing left to clean up for the QApplication.

This might also fix a number of similar segfaults in other situations
where the YaST Ruby engine would need to shut down because of other
problems, e.g. when there is an unhandled Ruby exception.

Surprisingly enough, this must have been a very old (10+ years?) bug,
but it never became quite obvious, or at least nobody was ever annoyed
enough to try to track it down.

If you want even more details, check [the conversation in the bug
report][5].

### More to come

The end of this sprint caught up with a lot of almost finished stuff.
But following the Scrum principle of “nothing is done until it fits the
Definition of Done”, we don’t blog about such stuff. Fortunately, that
means the next report will likely be quite juicy. So, see you again in a
couple of weeks!



[1]: https://lizards.opensuse.org/2018/01/09/highlights-of-yast-development-sprint-48/
[2]: https://en.opensuse.org/SDB:Linuxrc#p_kexec
[3]: https://news.opensuse.org/2018/01/09/future-tumbleweed-snapshot-to-bring-yast-changes/
[4]: https://en.wikipedia.org/wiki/Partition_alignment
[5]: https://bugzilla.suse.com/show_bug.cgi?id=1074596

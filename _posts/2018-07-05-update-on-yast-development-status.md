---
layout: post
date: 2018-07-05 15:53:56.000000000 +00:00
title: Update on YaST Development Status
description: Five weeks without blogging is certainly a quite an hiatus for the YaST
  Team. But fear no more, we are back!
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

This is the first time in quite a while in which our post is not titled
“Highlights of YaST Development Sprint” and there are good reasons for that.

### Adapting the YaST Team Structure the Agile Way

Now that openSUSE Leap 15.0 is out and SUSE Enterprise Linux 15 is ready
to be shipped, we felt it was time to rethink our activities. For the
duration of the storage-ng development, we had split the YaST team into
two sub-teams: Team S for **S**torage and Team R for the **R**est. But
now new challenges await us; there are some things that were pushed
aside because getting storage-ng into an acceptable state had top
priority.

We decided we’d try an approach that other development teams in SUSE
have already been using successfully: split up the YaST team into
“squads” of 3-5 people each for the duration of a couple of sprints.
Each squad is centered around a big topic that needs to be addressed.
There is no long-term fixed assignment of anyone to any squad; the idea
is to shuffle people and thus know-how around as needed, of course
taking each developer’s interests into account. So the squads and the
topics will change every few weeks.

Is this the pure spirit of Scrum and the agile bible? We don’t know. And
we don’t care. The agile spirit is to adapt your work based on what
makes sense in every moment. We work the agile way, so the way of
working also has to be agile.

The next sprint’s report will contain more information about the first
set of squads and the results they are delivering. But meanwhile we have
done much more than just reorganizing our forces. While the sprint-based
work was suspended (thus the blog title not containing the word
“sprint”), the YaST team still managed to put out of the door quite some
features, improvements and bug fixes targeting mainly Tumbleweed.

### Expert Partitioner: Moving Partitions

After quite some effort, the YaST team has completely rewritten the
Expert Partitioner from scratch using the new storage stack (a.k.a.
storage-ng). And although this new Expert Partitioner already offers
practically all the same features than the old one, some last options
are still coming. One them in the button for moving partitions, which
saves us of a lot unnecessary work in many cases. For example, imagine
you are installing openSUSE Tumbleweed and the installer automatically
proposes you to create a partition for root and, just following it, a
second partition for home. In case you don’t like the default proposed
sizes (e.g. because you want a bigger root), you have to use the Expert
Partitioner to fix the situation. You have to completely remove the home
partition, resize root for enlarging it and then create home again with
the same options than before.

Now, with the “Move” button, this kind of modifications are much easier.
For that example, you can accomplish exactly the same by simply resizing
home (without deleting it completely) and moving the resized home closer
to the end of the disk (by using Move button). After moving the home
partition, you have enough free space for enlarging the root partition.
In the following screenshot you can see this dialog for moving
partitions.

{% include blog_img.md alt="Moving partitions"
src="moving1-300x225.png" full_img="moving1.png" %}

One important thing to take into account is that the movement of
partitions is only possible for new partitions, that is, it is not
possible to move partitions that already exist on disk.

{% include blog_img.md alt="Trying to move an existing partition"
src="nomoving-300x225.png" full_img="nomoving.png" %}

### YaST Masking Systemd Mount and Swap Units

And speaking about the Partitioner and its relationship with the rest of
the system, the transition from SysVinit to Systemd changed the behavior
of (open)SUSE concerning mounting devices. Systemd generates mount units
for various file systems, e.g. those listed in `/etc/fstab`. The result
is that Systemd may automatically mount any file system, even if that
file system has been manually unmounted before. This can be problematic
when the user needs the file system to be unmounted for certain
operations, like resizing or unplugging.

Thus, now the Partitioner uses a new mechanism to prevent that to happen
during its execution. Starting with version 4.0.194, the
`yast2-storage-ng` package includes and uses the script
`/usr/lib/YaST2/bin/mask-systemd-units` to mask all mount and swap units
one by one. The script might also be useful for direct use of system
administrators. So… profit!

### Showing Logs the Systemd Way

And since we speak about how Systemd has changed the way the overall
system works, it’s also worth noticing how more and more services has
been adopting the Systemd journal for its logging purposes.

Some of the existing YaST modules to configure a given service include a
button to show the logs of such service. In the past, they used to
display the content of `/var/log/messages` with some basic filtering to
ensure only the information relative to the service (e.g. `tftp`) was
shown. But that didn’t work out of the box for services already using
the Systemd journal, and we had gotten quite some bug reports about it.

Fortunately, the solution is really at our fingertips. You surely know
by now that there is a YaST module for viewing the journal content with
powerful queries for filtering, searching and so so on. The obvious
solution is to use that YaST journal module also within other YaST
modules, in order to show domain specific logs.

So far we adapted the YaST tftp module, but it will be easy to fix also
other places that use the old approach that no longer works. And this is
how it looks when you click the “Show Logs” button in the YaST module to
configure tftp.

{% include blog_img.md alt="Journal entries for the tftp module"
src="tftp-journal-entries-300x201.png" full_img="tftp-journal-entries.png" %}

### Usability Improvement in the Repositories Manager

The YaST repositories manager displays the repositories sorted by
priority. But some people have a lot of repositories in their system and
make no use of the priorities. Since there was not a clear second
criteria, the order of the repository list looked quite arbitrary in
those cases. Now all the repositories with the same priority are sorted
by name, which makes more sense. See how it looked before the
improvement.

{% include blog_img.md alt="List of repositories sorted only by priority"
src="repos-before-300x193.png" full_img="repos-before.png" %}

And compare to how it looks now.

{% include blog_img.md alt="List of repositories sorted by priority and name"
src="repos-after-300x192.png" full_img="repos-after.png" %}

### Handling Inconsistent Boot Methods During Upgrade

We got a rather interesting amount of bug reports for openSUSE Leap 15.0
about collisions between the `grub2` and `grub2-efi` bootloaders during
the upgrade process. The root cause was that the installation medium
used a different booting mode than the installed system being upgraded.
For example, the installed system uses EFI boot but the upgrade is
executed from a DVD booted via legacy mode (i.e. disabling EFI). In that
case, the kernel running from the DVD does not expose some devices that
are needed to write to the EFI boot manager. Moreover, it causes
troubles to the updater itself, which does not expect this situation.

Looking at the majority of the bug reports, it is obvious that in most
cases it happens by accident rather than the user consciously trying to
mix both boot modes. So to improve the user experience we added a
warning that will be displayed when this situation is detected, before
starting the upgrade. That gives the user the possibility to fix the
problem or to continue if the situation is really intentional.

Below you can see how it looks, both in graphical and text mode, in a
patched openSUSE Leap 15.0 installation media, since the feature was
developed too late to be included in the official installation images.

{% include blog_img.md alt="Graphical warning about inconsistent boot mode"
src="efi-warning-qt-300x224.png" full_img="efi-warning-qt.png" %}

{% include blog_img.md alt="Text-mode warning about inconsistent boot mode"
src="efi-warning-ncurses-300x224.png" full_img="efi-warning-ncurses.png" %}

### What’s Next? Hack Week!

As commented at the beginning of the post, we have restarted the
sprint-based work, although with a little twist to try out the squads
approach. But before we come back to you to show the results of the
first squad-based sprint, we have something else to do – [Hack Week
17!][1].

Again it’s the time of the year for all SUSE Engineers (and any Open
Source enthusiast willing to join) to innovate and learn new stuff. So
please forgive us if we go too deep into playing and we are less
responsive next week. See you again soon!



[1]: https://hackweek.suse.com/

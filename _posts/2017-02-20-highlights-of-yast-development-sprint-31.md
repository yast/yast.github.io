---
layout: post
date: 2017-02-20 09:58:58.000000000 +00:00
title: Highlights of YaST development sprint 31
description: As we announced in the previous report, our 31th Scrum sprint was slightly
  shorter than the usual ones. But you would never say so looking to this blog post.
  We have a lot of things to talk you about!
category: SCRUM
tags:
- Desktop
- Distribution
- Factory
- GNOME
- Hackweek
- KDE
- Packaging
- Programming
- Software Management
- Systems Management
- XFCE
- YaST
---

### Teaching the installer self-update to be a better citizen

As you may know, YaST includes a [nice feature][2] which allows the
installer to update itself in order to solve bugs in the installation
media. This mechanism has been included in SUSE Linux Enterprise 12 SP2,
although it’s not enabled by default (you need to pass an extra option
`selfupdate=1` to make it work).

So after getting some feedback, we’re working toward fixing some
usability problems. The first of them is that, in some situations, the
self-update mechanism is too intrusive.

Consider the following scenario: you’re installing a system behind a
firewall which prevents the machine to connect to the outside network.
As the SUSE Customer Center will be unreachable, YaST complains about
not being able to get the list of repositories for the self-update. And,
after that, you get another complain because the fallback repository is
not accessible. Two error messages and 2 timeouts.

And the situation could be even worse if you don’t have access to a DNS
server (add another error message).

So after some discussion we’ve decided to show such errors only if the
user has specified SMT or a custom self-update repository (which is also
possible). In any other case, the error is logged and the self-update is
skipped completely.

You can find further information in our [Self-Update Use Cases and Error
Handling document][3].

During upcoming sprints, we’ll keep working on making the self-update
feature great!

### Configuring workers during CaaSP installation

While CaaSP release approaches, our team is still working hard to
satisfy the new requirements. Thankfully, YaST is a pretty flexible tool
and it allows us to change a lot of things.

For CaaSP installation, YaST features a one-dialog installation screen.
During this sprint, configuration of the `Worker` role has been
implemented, including validation of the entered URL and writing the
value to the installed system. You can check the animated screenshot for
details.

{% include blog_img.md alt="The CaaSP worker configuration" src="worker.gif"
attr=".thumbnail" full_img="worker.gif" %}


### New desktop selection screen in openSUSE installer

The world of Linux desktop environments change relatively quick, with
new options popping-up and some projects being abandoned. Thanks to the
openSUSE’s community of packagers we have a lot of these new desktop
environments available on the openSUSE distributions. But the status of
those packages for openSUSE is also subject to changes: some desktop
environments are poorly maintained while others have a strong and active
group of packagers and maintainer behind.

The YaST Team does not have enough overview and time to watch all these
desktop environment and evaluate which one is ready or not for being in
the installer’s desktop selection screen. So the openSUSE Release Team
decided to replace this dialog with something a bit more generic but
still useful for newcomers.

They asked the YaST Team to come up with a new dialog featuring the two
openSUSE main desktops (KDE Plasma and GNOME) and allowing the easy
selection of other environments without reworking the dialog in the
future. The goal of that new dialog was to replace the existing one you
can see in the following screenshot.

{% include blog_img.md alt="The old desktop selection screen"
src="old_desktop-300x226.png" full_img="old_desktop.png" %}

We decided the new dialog should rely on patterns for several reasons.
The main one is that the set of patterns is under the close control of
the openSUSE community, which looks more closely than us to the desktop
environments and their integration into the distribution. Moreover, each
pattern specifies its own icon and description that can be somehow
re-used by the installer.

We also took the opportunity to merge this almost empty and outdated
dialog with the new one.

{% include blog_img.md alt="The old additional repositories screen"
src="old_repos-300x226.png" full_img="old_repos.png" %}


Addons are no longer produced for openSUSE, so only the second checkbox
made any sense nowadays. Moreover, the functionality of that second
checkbox directly influence the available selection of patterns, so it
made more sense to merge everything in a single screen that keeping an
extra step in the installation just to accommodate a checkbox.

So we sent a proposal for the new dialog to the opensuse-factory mailing
list and, after implementing many of the ideas discussed there (like
better wording or using a button instead of a checkbox for the online
repositories), this is the new dialog that replaces the two ones
mentioned above.

{% include blog_img.md alt="The new desktop selection dialog"
src="new_desktop-300x225.png" full_img="new_desktop.png" %}

Selecting “custom” will take the users to the already existing patterns
selection screen. Just in case you don’t remember how that screen looks
like, you can check this image.

{% include blog_img.md alt="The patterns selection screen"
src="patterns-300x225.png" full_img="patterns.png" %}

If these screenshots are not enough to make your mind about the change,
you can check the following animation, in which KDE Plasma is initially
chosen to be changed at a later point (going back in the workflow) to
LXQt.

{% include blog_img.md alt="Desktop selection animation"
src="desktop_animation.gif" attr=".thumbnail" full_img="desktop_animation.gif" %}

It will take some time before the changes hit the Tumbleweed installer,
since they obviously have a non-trivial impact on the openQA tests, that
will need some adaptation.

We would like to thank everybody that contributed to this new feature by
providing feedback and suggestions through the mailing list. Once again,
the openSUSE community has proved to be simply awesome!

### Storage reimplementation: improved handling of logical partitions

Our reimplementation of the storage layer keeps getting improvements
here and there. With the base x86 case working, we are now implementing
the tricky parts, like the partitions renumbering that takes place when
dealing with logical partitions in a MBR style partition table.

With GPT partition tables or with primary partitions in a MBR partition
table, the partition gets a number (like sda1) when it’s created and
keeps that number for its whole lifetime. But logical partition gets
constantly renumbered when other partitions are created and destroyed.
We need to know in advance what device name every partition will get in
order to configure everything beforehand and only commit the changes to
the disk when the user clicks in the “install” (during the installation
process) or “commit” (if running the expert partitioner).

Now, libstorage-ng is able to simulate in memory the re-numbering
process, so we can calculate all the settings related to partitioning
(like the configuration of the bootloader) before really touching the
disk.

### Making kdump work in CaaSP

When you enable the Kernel Crash Dump (kdump), you probably expect that
you will get a kind of core dump, like you do for regular processes.
What you might not expect is an automatic reboot. That is a nice bonus.
If you are tired of waiting for an *actual* kernel crash, you can test
your kdump setup by triggering a crash yourself. Just run this as root:


    echo c > /proc/sysrq-trigger

The way kdump works is by allocating some extra memory at boot time and
putting a second kernel+initrd there. When the main kernel realizes it
is crashing, it transfers control (by kexec) to the other one, which has
only one purpose, to dump the memory of the crashed kernel.

In the upcoming Containers as a Service Platform, kdump was not working
because the root filesystem is read-only there and we were not able to
create the kdump initrd. We [fixed it][4] by creating it just after the
RPMs are installed, when the FS is still read-write.

### Fixes for Snapper in CaaSP

Kdump was not the only component affected by the fact of having a
read-only filesystem in CaaSP. Snapper was also running into problems
when trying to execute the `rollback` and `cleanup` operations. Now the
problems are fixed. While working on that we did enough interesting
findings to deserve a separate blog entry. So you can expect a new entry
in the [Snapper.io blog][5] soon.

### Snapshot-related improvements in the expert partitioner

While we work on the new storage system, we are still taking care and
improving the current one that will continue to be shipped with
SLE12-SP3, SUSE CaaSP and openSUSE Leap 42.3. During this sprint we
introduced a couple of usability improvements in the expert partitioner
related to Btrfs subvolumes.

First of all, we moved the “Enable Snapshots” checkbox that was pretty
much hidden in the “Subvolume Handling” dialog to the place where it
really belongs – below the selector of the file-system type.

{% include blog_img.md alt="New location for enabling snapshots"
src="snapshots-300x187.png" full_img="snapshots.png" %}

In addition, we added the warning you can see in the screenshot below
for users enabling snapshots in a potentially problematic setup.

{% include blog_img.md alt="Warning for snapshots in a small partition"
src="snapshots-size-warning-300x186.png" full_img="snapshots-size-warning.png" %}

### Bring back the beta warning on CaaSP

And talking about warnings, we improved the CaaSP installation dialog to
show the Alpha/Beta product warning at the beginning. After changing the
CaaSP installation to use the all-in-one dialog [described in our
previous post][1], this feature was lost as it is part of the initial
EULA dialog. Now it is back and the users should now properly see the
current product status.

{% include blog_img.md alt="The CaaSP alpha/beta warning pop-up"
src="caasp_warning-300x225.png" full_img="caasp_warning.png" %}

### Storage reimplementation: encrypted LVM proposal

Back to our storage layer reimplementation, the new system is now able
to propose a setup with encrypted LVM. Since some sprints ago, we were
already able to propose a partition-based and a LVM setup. That means
the new proposal is now feature-pair with the old one, with the only
exceptions of Btrfs sub-volumes (that shouldn’t be a big challenge) and
s/390 storage (that is still not properly managed by the underlying
libstorage-ng).

The bright part is that the new code is written with re-usability in
mind, which means implementing an encrypted partition-based proposal
(with no LVM) would be trivial. The new code is 100% covered by
automatic unit tests and scores to the top in all the automatic quality
checkers we have run (like Rubycritics, CodeClimate, and Rubocop).

So now we are prepared for whatever the future brings, having lost no
single feature in the way.

### Storage reimplementation: prototype if the UI for the proposal settings

The next challenge is to make the power of that new storage proposal
available to the users through the user interface. In the [previous
post][1] we presented the document describing the general ideas we
wanted to discuss with UX experts.

It’s our pleasure to announce we met the experts and we very easily
reached an agreement on how the user interaction should be. During this
sprint we already implemented a prototype of the future proposal
settings wizard that is, as usual, included in our [testing ISO][6].

Now that we have solid foundations, it’s very likely that the following
sprint will result in the fully working wizard, with almost-final
wording and design.

### Support for CaaSP added to the AutoYaST integration tests

While fixing a problem with AutoYaST and CaaSP, we decided to extend our
AutoYaST integration testing tool to support CaaSP. But, as a side
effect, we also made some additional improvements that were long overdue
(like improving the procedure to download ISOs, reducing timeouts,
etc.).

Now, our internal Jenkins instance takes care of running AutoYaST
integration tests for the development version of CaaSP (as it already
does for SLE 12 SP2).

### Services manager moved to first auto-installation stage

AutoYaST allows to [define a set of services][7] to be enabled/disabled
in the installed system, applying this configuration during the 2nd
stage (after the first reboot).

Unfortunately, this approach won’t work for CaaSP because, in that case,
the 2nd stage won’t be available. For that reason, during this sprint,
we have adapted AutoYaST to write services configuration during 1st
stage.

As usual, not only CaaSP, but other future (open)SUSE versions will
benefit of this change.

### Faster YaST installation when the release notes cannot be downloaded

Sometimes a very small simple change in a program makes a very
noticeable impact in its everyday use. That’s the case of a fix
implemented during this sprint. YaST usually re-tries to download the
distribution release notes several times if the first attempt was
unsuccessful. Although that’s correct from a general point of view,
there are cases in which retrying makes no sense and only delays the
installation. We have now added failed DNS resolution to that list of
cases, which should result in a noticeable faster installation in many
scenarios.

Moreover, in the case of AutoYaST we now skip downloading the release
notes completely. Downloading them don’t make us much sense in the kind
of unattended scenarios handled by AutoYaST and skipping this step and
all the possible associated problems result in a more robust process.

### Better continuous integration for Libyui

In the previous sprint we switched to Docker at Travis so we could build
and test our packages in the native openSUSE system instead of the
default Ubuntu. This sprint we did the same change also for the Libyui
library which implements the UI part of YaST.

Originally we could not build the Libyui packages at Travis as either
the required build dependencies were missing or were present at a very
old unusable version. With this switch we can easily use the latest
packages from openSUSE Tumbleweed and thus enable Travis builds for all
Libyui packages.

### See you after Hack Week!

As already mentioned, this week is [Hack Week 15][8]! So our Scrum
process will be on hold for some days. That doesn’t necessarily mean the
YaST development will stall. Since there are quite some YaST-related
projects in the Hack Week page, you can expect YaST to simply go in
unexpected directions. :smiley:

And remember Hack Week is not a SUSE internal initiative, we are open to
collaboration from anybody within or outside the company. So jump in and
have fun with us!



[1]: {{ site.baseurl }}{% post_url 2017-02-03-highlights-of-yast-development-sprint-30 %}
[2]: https://fate.suse.com/319716
[3]: https://gist.github.com/imobachgs/cb03b6a87dd5e31c89a9463d30db4252
[4]: https://github.com/yast/yast-kdump/pull/73
[5]: http://snapper.io/news.html
[6]: http://download.opensuse.org/repositories/YaST:/storage-ng/images/iso/
[7]: https://www.suse.com/documentation/sles-12/singlehtml/book_autoyast/book_autoyast.html#CreateProfile.Services
[8]: https://hackweek.suse.com/

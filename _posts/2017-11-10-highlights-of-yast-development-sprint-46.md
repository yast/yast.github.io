---
layout: post
date: 2017-11-10 10:10:29.000000000 +00:00
title: Highlights of YaST Development Sprint 46
description: It&#8217;s Hack Week time at SUSE! But before we dive into all kind of
  innovative experiments, let&#8217;s take a look to what we achieved during
  the latest development sprint.
category: SCRUM
tags:
- Distribution
- Factory
- Hackweek
- Programming
- Systems Management
- YaST
---

### User-friendly error messages in AutoYaST

During recent weeks, the AutoYaST version for the upcoming SLE 15 family
has received quite some love regarding the integration with the new
storage layer, from fixing bugs to adding some missing (and even some
new) features. So let’s have a look at what we have done so far.

First of all, a new error reporting mechanism will debut in the upcoming
AutoYaST version. Until now, when a problem occurred during
partitioning, you got a message like “*Error while configuring
partitions. Try again.*“. It does not help at all, right? At that point,
you were on your own to find out the problem.

Now AutoYaST is able to identify and report different problems to the
user in a convenient way. What is more, in many situations it is even
able to point to the offending section of the AutoYaST profile.

{% include blog_img.md alt="AutoYaST error reporting"
src="autoyast-errors-300x225.png" full_img="autoyast-errors.png" %}

The error reporting mechanism can distinguish between two different kind
of issues: warnings and errors. When a warning is detected, a message is
shown to the user but the installation will not be stopped (it honors
the settings in the `<reporting>` section). Errors, on the other hand,
will block the installation entirely.

Please, bear in mind that this error reporting mechanism is only
available for the `<partitioning>` section. Maybe it could be extended
in the future to cover other parts of the auto-installation process.

### Bringing back skip lists to AutoYaST partitioning

When defining a partitioning schema, you can let AutoYaST decide which
device should be used for installation. Thanks to that, you can use the
same profile to install machines with, for instance, different storage
devices kernel names (like `/dev/sda` and `/dev/vda`).

Needless to say that, in such a situation, we might want to influence
the decision process. For example, we would like to avoid considering
USB devices for installation. AutoYaST offers a feature known as *skip
lists* which allow the user to filter out devices using properties like
name, driver, size, etc.

Unfortunately, *skip lists* support in *SLE 15 Beta1* is rather limited.
But these days we have extended `yast2-storage-ng` to offer additional
hardware information and now AutoYaST is able to use it to filter
devices.

{% include blog_img.md alt=""
src="ayast-probe-300x225.png" full_img="ayast-probe.png" %}

As a side effect, the `ayast_probe` client has been fixed to show
(again) which keys you can use in your *skip lists*.

### More on AutoYaST

Apart of adding or bringing back features, we have fixed several bugs.
You can check the [recent entries][2] in the `yast2-storage-ng` changes
file if you are interested in the details.

We know that a few features are still missing and more bugs should be
addressed sooner or later, but hopefully AutoYaST must work in most use
cases.

### SLE15 media based upgrade for unregistered system

This sprint we also continued implementing the upgrade from SUSE Linux
Enterprise (SLE) 12 products to the version 15. Particularly we solved
the upgrade of unregistered systems.

In that case you need the “SLE15 Installer” medium and additionally also
the “SLE 15 Packages” medium. The installer medium contains only the
minimal packages for installing just a very minimal system. The rest is
available either via the registration server or via the extra medium.
Obviously for unregistered systems only the second option makes sense.

In this sprint we were focused on making all pieces to work together.
You can see the result in the following screencast.

{% include blog_img.md alt="Upgrading an unregistered system"
src="screencast-regist.gif" %}

### Fixed an installer crash in systems with 512MB RAM

We got a bug report that the beta version of the upcoming SUSE Linux
Enterprise Server 15 was sometimes crashing during installation on a
system with 512MB RAM. That’s bad, the 512MB is a required limit which
should be enough to install a minimal system in text mode.

At first we thought that the crash was caused by insufficient memory,
but the reported memory usage was OK, there was still enough free
memory.

It turned out that the problem was in the pkg-bindings which tried to
evaluate undefined callback function. The fix was quite simple, however,
the question was why that happened only in systems with 512MB RAM and
not when there was more memory.

Later we found out that the difference was caused by the extra inst-sys
cleanup (mentioned in [the Sprint 22 report][3]) which YaST runs when
there is low memory. In that case YaST removed the libzypp raw
repository metadata cache. The assumption was that when the data is
already parsed and cached in the binary solv cache the original files
are not needed anymore. However, libzypp still might use some raw files
later.

So we changed the inst-sys cleanup algorithm to remove only the files
which we know are not needed later and keep the rest untouched.

### Expert partitioner: <del>the</del> some boys are back in town

Several features have been brought back to the expert partitioner during
this sprint.

* Allow to create and delete logical volumes.
* Allow to delete MD RAIDs.
* Allow to work with multipath devices.

Now you can create logical volumes using the expert partitioner. When
you go to the LVM overview or visit a specific volume group, a button
for adding a logical volume is available. Clicking on it, you will be
taken through a wizard for the creation of a logical volume. Note that
although the logical volume type can be selected in the first wizard
step, only normal volumes can be created. Thin logical volumes and thin
pools will come soon. And apart of creating logical volumes, now there
is also a button for deleting them.

{% include blog_img.md alt="LVM management in the reimplemented partitioner"
src="lvm_back-300x225.png" full_img="lvm_back.png" %}

{% include blog_img.md alt="Creating an LVM LV in the reimplemented partitioner"
src="lvm_add_lv-300x225.png" full_img="lvm_add_lv.png" %}

{% include blog_img.md alt="Deleting an LVM LV in the reimplemented partitioner"
src="lvm_remove-300x225.png" full_img="lvm_remove.png" %}

Delete action has been also implemented for MD RAIDs. For that reason,
you have a delete button in the RAID overview and also when you access
to a specific MD RAID. And of course, you will be asked for confirmation
before removing the device.

{% include blog_img.md alt="Deleting an MD RAID in the reimplemented partitioner"
src="delete_raid-300x225.png" full_img="delete_raid.png" %}

Additionally, another important feature recovered during this sprint is
the possibility to work with multipath devices. Now, multipaths are
listed together with other disks in the tree view of the expert
partitioner, allowing you to manage them as regular disks. For example,
you can create or remove partitions over them. Moreover, when a
multipath device is selected, a new tab is showed to list the so-called
“wires” that belong to the multipath.

{% include blog_img.md alt="Multipath devices in the reimplemented partitioner"
src="multipath_partitioner-300x225.png" full_img="multipath_partitioner.png" %}

### Improving the product upgrade workflow

Although the possibility to offer an upgrade option from openSUSE Leap
to SLE is on both SUSE and openSUSE radars for the future, the reality
is that it has been, and still is, an unsupported scenario.

But with previous versions of SUSE Linux Enterprise, you could take a
SLES DVD, boot it in the Upgrade mode, and select to upgrade an openSUSE
partition. YaST would let you proceed several screens before telling you
that it actually will not let you upgrade from openSUSE to SLES.

Starting with recent SLE15 pre-releases, the incompatible products are
filtered out in the partition selector already (overridable with a *Show
All Partitions* checkbox), letting you know earlier whether you will be
able to upgrade your system to the new SLES.

### Fix of a registration issue during installation process

In SLE 15 Installer, there is a product selection dialog at the very
beginning of the installation. After that, you can register the selected
product but you cannot change the product later as unregistering the
product and registering another one is not supported. Our awesome QA
squad found out that when the installation was aborted and then started
again from Linuxrc without rebooting, the installer thought that the
product had been already selected and did not offer any product for
installation. A little fix made it work again – now we always execute
the following SUSEConnect command at the start of the installer.

    
    SUSEConnect --cleanup

That removes all traces of previous registration attempts from the
Installer. This also means that you might still want to unregister
directly at [SUSE Customer Center][4] if needed.

### Improving help texts in the registration process

As you have seen so far, we have been working hard to polish the
registration experience in many aspects and scenarios. That also
includes a better communication with the user. Thus, the help text in
the registration module has been improved to also include the
description of the check box states. This is especially important for
the “auto selected” state which is specific to this dialog and is not
used anywhere else.

The help texts in YaST use an HTML subset which allows also including
images. In this case we included the check box images directly from the
UI stylesheet. But in the text mode we have to use text replacement
instead of the images. That means the help text content must be created
dynamically depending on the current UI.

Here you can see examples of both interfaces.

{% include blog_img.md alt="The graphical version of the new registration message"
src="registration_message_qt-300x225.png" full_img="registration_message_qt.png" %}

{% include blog_img.md alt="Text-based version of the new registration message"
src="registration_message_ncurses-300x167.png" full_img="registration_message_ncurses.png" %}

### Twisting the storage proposal: this time for real

In [our report of sprint 42][5] (to be precise, in the section titled
“Twisting the storage proposal”) we presented our plans to make the
software proposal more customizable in a per-product basis and the
[draft document][6] of the new format for `control.xml` that would allow
release managers to define the installer behavior in that regard.

Now this goes further than a mere specification and the new format is
actually being used to define the partitioning proposal of both the
KVM/Xen role of SUSE Linux Enterprise 15 and the upcoming SLE15-based
CaaSP.

In the following screenshot you can see the corresponding step of the
guided setup for the mentioned KVM/Xen role, in which the classical
controls for the `/home` and Swap partitions have been replaced by more
goal-specific volumes defined in the section of the control file
describing the role.

{% include blog_img.md alt="Partitioning configuration for the KVM/Xen role"
src="separate-libvirt-settings2-300x177.png"
full_img="separate-libvirt-settings2.png" %}

And, as you can see below, the installer now honors those settings to
propose a reasonable partition layout.

{% include blog_img.md alt="Storage proposal for the KVM/Xen role"
src="separate-libvirt-no-snapshots2-300x116.png"
full_img="separate-libvirt-no-snapshots2.png" %}

The new format and the corresponding implementation of both the logic
and the UI are flexible enough to empower the release managers to define
all kind of products and to make possible for everybody to create a more
customized derivative of openSUSE without renouncing to the power of the
automatic proposal. See another example below (not corresponding to any
product or derivative planned in the short term) with more possibilities
and note how the wording was automatically adapted to talk about LVM
volumes instead of partitions, based on the user choice in a previous
step.

{% include blog_img.md alt="LVM-based example of the new proposal"
src="new_control_lvm-300x222.png" full_img="new_control_lvm.png" %}

### Replacing ntpd with Chrony in yast2 ntp client

Chrony will replace the classical `ntpd` as default NTP client starting
with SLE15 and openSUSE Leap 15. That will offer several advantages to
system administrators and other users, as can be seen in [this
comparison][7]. In order to make this replacement possible, we started a
research to find out what is supported in Chrony and how to allow our
users to configure it through YaST.

The research phase is now complete and we have already a plan to proceed
with the adaptation of the existing `yast2-ntp-client` module. Also a
few bits of code, which allows to set the NTP service during
installation, are now in a feature branch (so not yet in Tumbleweed).

The next step will be a huge improvement (and simplification) of the
YaST module, which will go further than adapting a list of options. In
the screenshot below you can see the not yet finished prototype in
action.

{% include blog_img.md alt="New NTP settings"
src="chrony-1-300x198.png" full_img="chrony-1.png" %}

### Configuring the keyboard in the installer via systemd

Originally the keyboard configuration was written directly by YaST in
the corresponding Systemd-related configuration files. But we got a bug
report that YaST should not touch the config directly and rather call
the `localectl` tool for changing it. (See the details in the [localectl
man page][8]).

However, this works only in the installed system, it does not work in
the system installation as it needs a running Systemd that is not
available during the installation process. Changing the setting for a
not running system must be done using the [systemd-firstboot][9]
command.

But this did not supported modifying the keyboard settings. Fortunately
one of the SUSE developer helped us and implemented this feature to
Systemd ([pull request][10]). Currently the feature is available in
(open)SUSE packages but later it will be available in the upstream
release for others.

Another related change was that YaST not only set the console keyboard
but also constructed the keyboard settings for X11 (GUI). But this is
actually a duplicated functionality, `localectl` itself includes this
feature. So we have removed it from YaST and let the `localectl` tool to
set both keyboard setting automatically.

### And now for something completely different

Hack Week 0x10 (that is, the 16th edition) is starting just right now.
Which means most developers of the YaST team will spend a week working
on topics that may or may not have a direct and visible impact in our
beloved users in the short term. But hey, maybe we will build a robot or
a space rocket!

After that week, we will restart our Scrum activity. So if nothing goes
wrong, you will have another update about the YaST development in
approximately four weeks. Meanwhile, join us at Hack Week and let’s have
a lot of fun together!



[1]: https://hackweek.suse.com/
[2]: //user-images.githubusercontent.com/15836/32597661-39f4ec0c-c52f-11e7-9dd9-207549f025d7.png)
[3]: {{ site.baseurl }}{% post_url 2016-07-27-highlights-of-yast-development-sprint-22 %}
[4]: https://scc.suse.com
[5]: {{ site.baseurl }}{% post_url 2017-09-07-highlights-of-yast-development-sprint-42 %}
[6]: https://github.com/yast/yast-storage-ng/blob/master/doc/old_and_new_proposal.md
[7]: https://chrony.tuxfamily.org/comparison.html
[8]: https://www.freedesktop.org/software/systemd/man/localectl.html
[9]: https://www.freedesktop.org/software/systemd/man/systemd-firstboot.html
[10]: https://github.com/systemd/systemd/pull/7035

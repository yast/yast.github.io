---
layout: post
date: 2018-02-22 13:55:25.000000000 +00:00
title: Highlights of YaST Development Sprint 51
description: 'Can you perform an online offline migration? Will you understand the
  license better if you display a different translation? Is your /home mounted or
  haunted? Welcome back to our linguistic blog disguised as a YaST team sprint
  report.'
category: SCRUM
tags:
- Systems Management
- Uncategorized
- YaST
---

1.  Can you perform an online offline migration?
2.  Will you understand the license better if you display a different
    translation?
3.  Is your `/home` mounted or haunted?

Welcome back to our linguistic blog disguised as a YaST team sprint
report.

* Installation and Upgrade: [an online offline
  upgrade](#offline-upgrade-using-bootable-media-via-scc); [selecting
  add-ons
  easily](#made-the-addon-linuxrc-option-work-well-with-the-packages-dvd);
  [better selection of license
  translations](#improve-licenses-translations-support).
* Replaced components: [even more traces of xinetd
  removed](#finalize-xinetd-conversion-to-systemd-sockets); [AutoYaST
  export for
  firewalld](#added-support-for-exporting-firewalld-autoyast-configuration).
* Storage and Partitioner: [format options
  dialog](#added-the-format-options-dialog-to-the-partitioner); [empty
  views removed](#removed-the-empty-views-in-the-partitioner);
  [installation summary](#installation-summary-in-the-partitioner);
  [blocker errors](#blocker-errors-in-partitioner); [autoinstall
  `by-partlabel`](#extending-the-autoyast-device-element); [more precise
  booting setup](#fine-tuning-of-the-requirements-to-boot-a-system);
  [mounted /home or haunted
  /home?](#mount-options-revisited-when-the-old-demons-come-back-to-haunt-you)

## Installation and Upgrade   {#installation-and-upgrade}

### Offline Upgrade Using Bootable Media via SCC   {#offline-upgrade-using-bootable-media-via-scc}

The last few weeks we spent quite some time implementing the offline
migration from the old SUSE Linux Enterprise products (versions 11 and
12) to the upcoming version 15.

Note: the *offline migration* term actually means that your production
system is not booted and running, it is not about the network status. At
offline migration a different system is booted (usually from a DVD). See
more details in the [official SUSE documentation][1].

We implemented and tested the upgrade from SLE 12 SP3. The offline
migration workflow is similar to the online migration as implemented in
SLE 12 release. The only difference is that you boot the SLE 15 medium,
select *Upgrade* in the boot menu and then select the disk partition to
upgrade. The rest should be the same as in the online migration.

The migration from SLE 11 is a bit more complex as it is registered
against the older *Novell* Customer Center and requires some additional
changes in the installer. This is work in progress.

And the last note: for *testing* the offline migration to SLE 15, your
system needs to be registered using the Beta registration keys. For
regular SLE 12 and 11 registrations, the migration to SLE 15 is blocked.
It will be unblocked after the SLE15 has been officially released.

### Made the `addon` Linuxrc Option Work Well with the Packages DVD   {#made-the-addon-linuxrc-option-work-well-with-the-packages-dvd}

In SLE 15 there are numerous modules and extensions, such as the Live
Patching module, or the Web Scripting module. On physical DVDs, we are
putting all of them on a single Packages DVD.

When you are installing SLES and choose to add such a module during the
installation from the DVD, you will be presented with a screen to select
from all the modules found on the DVD.

You can also automate this step by passing the `addon=dvd:///` option at
the installation boot prompt. (See [the Linuxrc reference][2]). Formerly
this worked only with single-product media. Starting [now][3], the
`addon` option will work also with multi-product media such as the
Packages DVD.

### Improve Licenses Translations Support   {#improve-licenses-translations-support}

Some months ago, YaST started to use libzypp to get product licenses,
instead of using the old SUSE Tags approach. However, until this sprint,
this feature was somehow incomplete.

On one hand, the complete list of supported languages was shown, no
matter whether a translation was available for a given language or not.
On the other hand, the \"Licenses Translation\" button was missing (it
is still used in single product media).

{% include blog_img.md alt=""
src="s51-1-300x225.png" full_img="s51-1.png" %}

Now both problems are solved and, as soon as new translations are
included in the installation media, they should be handled gracefully in
the installer.

## Replaced Components   {#replaced-components}

### Finalize Xinetd Conversion to Systemd Sockets   {#finalize-xinetd-conversion-to-systemd-sockets}

This sprint we finished our [change from xinetd to systemd sockets for
starting services on demand][4]. To finalize it there is basically two
main tasks.

The first one was dropping the YaST module for xinetd. That required a
conversion of yast2-ftp-server that used this module and also adding a
note to AutoYaST that xinetd configuration is no longer supported, so if
you have it in your AutoYaST profile, it won’t be applied. The FTP
server part was harder because, as mentioned in the last report, one of
the two backends does not support systemd sockets, but we found that
this backend is a bit ancient and support for us was quite painful. The
result is that we dropped pure-ftp and kept only vsftpd backend, which
makes the code much simplier and our life better (the final diff-stat is
+1100/-3700). And then we converted the usage to systemd sockets. Then
we could proceed to dropping yast2-inetd because there was no dependency
anymore.

The second task was xinetd usage directly, with an API for starting on
demand. It is not used too often and in the end the biggest parts were
dropping xinetd usage for VNC based installation and yast2-inst-server
which is now converted to use systemd sockets. And here we can give you
a nice trick we discovered during the implementation: If a systemd
service has a parameter (often the case with services started by a
systemd socket) you can stop all of them with a wildcard, e.g.
`systemctl stop vnc@*`.

So here is a happy end – after this sprint there is no xinetd usage and
we can support only one tool for starting on demand, allowing us to
focus on improving other parts.

### Added support for exporting firewalld AutoYaST configuration   {#added-support-for-exporting-firewalld-autoyast-configuration}

In the [previous blog entry][4] we announced AutoYaST support for
configuring firewalld but cloning the firewall configuration was not
supported yet and also the AutoYaST summary concerning the Firewall
module needed some love and that is basically what we have implemented
during this sprint.

{% include blog_img.md alt=""
src="s51-9-300x225.png" full_img="s51-9.png" %}

It should be noted that editing of the AutoYaST Firewall configuration
is not allowed since the firewall configuration is now done with the
firewalld graphical configuration tool (firewall-config)

## Storage and Partitioner   {#storage-and-partitioner}

### Added the Format Options Dialog to the Partitioner   {#added-the-format-options-dialog-to-the-partitioner}

One of the missing things in the new partitioner was the format options
dialog letting you tune the file system a bit when it is created.

The options itself are more or less the same as in the old partitioner.
This feature is intended more for the experts. As an average user you
will rarely find a need to fine-tune file system parameters. But in case
you do, the dialog is there to aid you (remember the help button).

Here is a screenshot of the ext4 options:

{% include blog_img.md alt=""
src="s51-2-265x300.jpg" full_img="s51-2.jpg" %}

### Removed the Empty Views in the Partitioner   {#removed-the-empty-views-in-the-partitioner}

In the process of rewriting the YaST storage stack, we also rewrote the
partitioner. Some views in the partitioner were taken over from the old
one, but not filled with any functionality so far – they only showed
empty pages. We now removed those empty pages:

* Crypt Files
* Device Mapper
* Unused Devices
* Mount Graph
* Settings (this one will be back soon with content)

This is what it looks like now:

{% include blog_img.md alt=""
src="s51-3-182x300.png" full_img="s51-3.png" %}

Compared to the previous version with the empty views:

{% include blog_img.md alt=""
src="s51-4-183x300.png" full_img="s51-4.png" %}

See also [Bug #1078849][5].

### Installation Summary in the Partitioner   {#installation-summary-in-the-partitioner}

One of the sections that survived the Partitioner sifting mentioned
above was the Installation Summary. During this sprint we re-implemented
this useful view that shows the changes that would be performed in the
system, including packages to install in order for the system to work
with the chosen technologies. One image is worth a thousand words.

{% include blog_img.md alt=""
src="s51-5-300x215.png" full_img="s51-5.png" %}

Of course, the information in both lists is updated with every change
done in the Partitioner and, as usual, everything works as a charm also
in text mode. Including the possibility of collapsing or extending the
(usually lengthy) list of operations on subvolumes.

{% include blog_img.md alt=""
src="s51-6-300x166.png" full_img="s51-6.png" %}

### Blocker Errors in Partitioner   {#blocker-errors-in-partitioner}

A few sprints ago we implemented warnings in the partitioner that inform
you if something looks like probably not working, but with expert
knowledge it can be made working. Now we add also blocking errors where
we are sure it won’t work. It is just a first draft so it will be
adapted as needed and as problems appear. Some checks are already moved
from the bootloader to the partitioner, so you can fix the partitioning
quickly. But enough words, check out the screenshots, where the first
one is an error which prevents continuing and the second one is just a
warning.

{% include blog_img.md alt=""
src="s51-7-300x220.png" full_img="s51-7.png" %}

{% include blog_img.md alt=""
src="s51-8-300x220.png" full_img="s51-8.png" %}

### Extending the AutoYaST &lt;device&gt; Element   {#extending-the-autoyast-device-element}

When defining a `<drive>` section in an AutoYaST profile, the `<device>`
element should determine to which disk you want to apply that
partitioning schema. Usually, it is a device kernel name, like
`/dev/sda`, or a link which resolves to a disk (for instance,
`/dev/disk/by-id/*`, `/dev/disk/by-path`, etc.).

However, AutoYaST supports specifying other names, like `by-partlabel`,
`by-label`, etc. Those links won’t resolve directly to a disk, but the
storage layer will be able to find out which disk they belong to.

Although SLE 12 supported this behaviour, it was missing from SLE 15
until this sprint.

### Fine-tuning of the Requirements to Boot a System   {#fine-tuning-of-the-requirements-to-boot-a-system}

In some situations, an extra partition or a given disk layout is needed
to boot an (open)SUSE operating system. Like the separate `/boot`
partition needed in some corner-case legacy scenarios, the ESP partition
that must be mounted at `/boot/efi` in EFI systems or the PReP partition
needed by some PowerPC systems. The partitioning proposal performed by
the installer tries to ensure those booting requirements are met (so
does AutoYaST in some cases) and our beloved Partitioner also includes
some checks to warn you user if you forget to create or mount any of
those partitions.

But in some situations, the installer was suggesting partitions with a
suboptimal size or even partitions that were not strictly needed. On the
other hand, the Partitioner was sometimes being too picky, warning about
situations that were not such a big problem. So during this sprint we
refined our list of booting requirements, updating the corresponding
documentation, relaxing the partitioner checks and fine-tuning the
proposal outcome. Specifically the PowerPC requirements were revamped
based on the input from several experts and bug reports from
manufacturers of some systems.

So no matter if you usually trust the installer proposal, if you like to
handcraft stuff with the Partitioner or if you install using AutoYaST,
the experience should be more smooth now, which fewer (if any) ugly
surprises at boot time.

### Mount Options Revisited: When the Old Demons Come back to Haunt You   {#mount-options-revisited-when-the-old-demons-come-back-to-haunt-you}

Recently, we reintroduced per-filesystem-type defaults for mount
options. We thought this would be a great chance to clean up old code
that had become messy over time; we thought we could provide a clean,
well-structured and easy-to-understand way to do this.

Then people began to test some more scenarios, and we found out the hard
way that in some situations, those mount options depend on the mount
point for various reasons: Some quirks of underlying kernel modules like
the VFAT filesystem or the way systemd handles mounting the root
filesystem during booting made this necessary.

So we had to bite the bullet and reintroduce some of that old code which
was kind of messy; for example, for ext4 or ext3 root filesystems, we no
longer specify any `data=...` mount options because this might make
remounting the root filesystem read/write at boot time fail; in another
case, a `mkdir -p /boot/efi/EFI` (when installing the boot loader) on a
VFAT partition failed despite VFAT technically being case-insensitive
(omitting `iocharset=utf8` fixed this).

Lesson learned: Some messy old code is messy for a reason. Trying to
streamline it may break some scenarios.

## Conclusion   {#conclusion}

The answers to the initial questions are

1.  Yes.
2.  说不定.
3.  Most of the time.

As the SLE release cycle is shifting from the \"all features are
mandatory\" phase to the \"all bugs are top priority\" phase, expect
less of feature news and more bugfix news in the next report, due in two
weeks.



[1]: https://www.suse.com/documentation/sles-12/singlehtml/book_sle_deployment/book_sle_deployment.html#sec.update.sle.methods
[2]: https://en.opensuse.org/SDB:Linuxrc#p_addon
[3]: https://github.com/yast/yast-add-on/pull/49
[4]: {{ site.baseurl }}{% post_url 2018-02-09-highlights-of-yast-development-sprint-50 %}
[5]: https://bugzilla.suse.com/show_bug.cgi?id=1078849

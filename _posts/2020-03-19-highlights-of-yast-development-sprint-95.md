---
layout: post
date: 2020-03-19 17:00:00
title: Highlights of YaST Development Sprint 95
description: Although SUSE has changed to remote working mode, the YaST team
  has remained focused and delivered some interesting stuff during this sprint.
category: SCRUM
permalink: blog/2020-03-19/sprint-95
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

## Contents

Due to recent events, many companies all over the world are switching to a
remote working model, and SUSE is not an exception. The YaST team is distributed
so, for many members, it is not a big deal because they are already used to work
in this way. For other folks it might be harder. Fortunately, SUSE is fully
supporting us in this endeavor, so the YaST team has been able to deliver quite
some stuff during this sprint, and we will keep doing our best in the weeks to
come.

Before jumping into what the team has recently done, we would also like to bring
your attention to the migration of our blog from the good old *openSUSE Lizards
blog platform* to the [YaST website][yast-blog]. So, please, if you use some
feeds reader, update the YaST blog URL to [the new
one](https://yast.opensuse.org/feed.xml).

Now, as promised, let's talk only about software development. These days we are
mainly focused on fixing bugs to make the upcoming (open)SUSE releases shine.
However, we still have time to introduce some important improvements. Among all
the changes, we will have a look at the following ones:

* [New possibilities for pervasive encryption.](#pervasive-encryption)
* [Improvements in the mechanism to install missing packages during storage
  system analysis.](#install-missing-packages)
* [Better handling of some conflicting attributes in
  AutoYaST.](#autoyast-conflicting-attrs)
* [Several usability improvements in the iSCSI LIO Server
  module.](#iscsi-lio-server-usability)

[yast-blog]: https://yast.opensuse.org/blog/
[yast-feed]: https://yast.opensuse.org/feed.xml


## Expanding the Possibilities of Pervasive Encryption {#pervasive-encryption}

Some months ago, in this [dedicated blog post][adv-enc-blog], we
introduced the joys and benefits of the so-called pervasive encryption available
for s390 mainframes equipped with a Crypto Express cryptographic coprocessor. As
you may remember (and you can always revisit the post if you don't), those
dedicated pieces of hardware ensure the information at-rest in any storage
device can only be read in the very same system where that information was
encrypted.

But, what is better than a cryptographic coprocessor? Several cryptographic
coprocessors! An s390 logical partition (LPAR) can have access to multiple
crypto express adapters, and several systems can share every adapter. To
configure all that, the concept of cryptographic domains is used. Each domain is
protected by a master key, thus preventing access across domains and effectively
separating the contained keys.

Now YaST detects when it's encrypting a device in a system with several
cryptographic domains. If that's the case, the dialog for pervasive encryption
allows specifying which adapters and domains must be used to generate the new
secure key.

{% include blog_img.md alt=""
src="pervasive-encryption-dialog-300x244.png" full_img="pervasive-encryption-dialog.png" %}

To succeed, all the used adapters/domains must be set with the same master key.
If that's not the case, YaST detects the circumstance and displays the
corresponding information.

{% include blog_img.md alt=""
src="secure-key-error-300x142.png" full_img="secure-key-error.png" %}

[adv-enc-blog]: {{ site.baseurl }}{% post_url 2019-10-09-advanced-encryption-options-land-in-the-yast-partitioner %}

## Install Missing Packages during Storage System Analysis {#install-missing-packages}

As our reader surely knows, YaST always ensures the presence of all the needed
utilities when performing any operation in the storage devices, like formatting
and/or encrypting them. If some necessary tool is missing in the system, YaST
has always shown the following dialog to alert the user and to allow to install
the missing packages with a single click.

{% include blog_img.md alt=""
src="check-and-install-300x184.png" full_img="check-and-install.png" %}

But the presence of those tools was only checked at the end of the process, when
YaST needed them to modify the devices. For example, in the screenshot above,
YaST asked for `btrfsprogs` & friends because it wanted to format a new
partition with that file system.

If the needed utility was already missing during the initial phase in which the
storage devices are analyzed, the user had no chance to install the
corresponding package. For example, if a USB stick formatted with Btrfs would
have been inserted, the user would get an error like this when executing the
YaST Partitioner or when opening the corresponding YaST module to configure the
bootloader.

{% include blog_img.md alt="Btrfs old error message"
src="btrfs-old-error-300x157.png" full_img="btrfs-old-error.png" %}

Now that intimidating error is replaced by this new pop-up that allows to
install the missing packages and restart the hardware probing. As usual, with
YaST, expert users can ignore the warning and continue the process if they
understand the consequences outlined in the new pop-up window.

{% include blog_img.md alt="Probe callback"
src="probe-callback-300x94.png" full_img="probe-callback.png" %}

We took the opportunity to fix other small details in the area, like better
reporting when the YaST Partitioner fails to install some package, a more
up-to-date list of possibly relevant packages per technology, and improvements
in the source code organization and the automated tests.

## Reporting Conflicting Storage Attributes in AutoYaST Profiles {#autoyast-conflicting-attrs}

If you are an AutoYaST user, you undoubtely know that it is often too quiet and
offers little information about inconsistencies or potential problems in the
profile. For simple sections, it is not a problem at all, but for complicated
stuff, like partitioning, it is far from ideal.

In (open)SUSE 15 and later versions, and given that we had to reimplement the
partitioning support using the new storage layer, we decided to add a mechanism
to report some of those issues like missing attributes or invalid values. There
is a high chance that, using an old profile in newer AutoYaST versions, you have
seen some of those warnings.

Recently, a user [reported a problem][bsc#1165907] that caused AutoYaST to
crash. While debugging the problem, we found both `raid_name` and `lvm_group`
attributes defined in one of the `partition` sections. Obviously, they are
mutually exclusive, but it is quite easy to overlook this situation. Not to
mention that AutoYaST should not crash.

From now on, if AutoYaST detects such an inconsistency, it will automatically select
one of the specified attributes, informing the user about the decision. You can
see an example in the screenshot below.

{% include blog_img.md alt="AutoYaST conflicting attributes warning"
src="autoyast-conflicting-attrs-300x225.png"
full_img="autoyast-conflicting-attrs.png" %}

For the time being, this check only applies to those attributes which determine
how a device is going to be used (`mount`, `raid_name`, `lvm_name`,
`btrfs_name`, `bcache_backing_for`, and `bcache_caching_for`), but we would like
to extend this check in the future.

[bsc#1165907]: https://bugzilla.suse.com/show_bug.cgi?id=1165907

## Usability Improvements in iSCSI-LIO-server Module {#iscsi-lio-server-usability}

Recently, one of our developers detected several usability problems in the
*iSCSI LIO Server* module, and he summarized them in [a bug
report][bsc#1127505]. Apart from minor things, like some truncated and
misaligned texts, he reported the UI to be quite confusing: it is not clear when
authentication credentials are needed, and some labels are misleading. To add
insult to injury, we found a potential crash when clicking the *Edit* button
while we were addressing those issues.

As usual, a image is worth a thousand words. Below you can see how the old
and confusing UI looked like.

{% include blog_img.md alt="Old iSCSI LIO Server Module UI"
src="iscsi-lio-server-old-ui-300x213.png" full_img="iscsi-lio-server-old-ui.png" %}

Now, let's compare it with the new one, which is better organized and more
approachable. Isn't it?

{% include blog_img.md alt="New iSCSI LIO Server Module UI"
src="iscsi-lio-server-new-ui-300x211.png" full_img="iscsi-lio-server-new-ui.png" %}

[bsc#1127505]: https://bugzilla.suse.com/show_bug.cgi?id=1127505

## Conclusion

It is possible that, during the upcoming weeks, we need to make some further
adjustments to our workflow, especially when it comes to video meetings. But, at
this point, everything is working quite well, and we are pretty sure that we
will keep delivering at a good pace.

So, take care, and stay tuned!



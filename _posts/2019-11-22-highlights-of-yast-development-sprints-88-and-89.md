---
layout: post
date: 2019-11-22 14:13:35.000000000 +00:00
title: Highlights of YaST Development Sprints 88 and 89
description: The System Role selection dialog got usability improvements and we added
  a CustomStatusItemSelector to the widget library in the process. Snapper gained
  machine-readable output.
category: SCRUM
tags:
- Systems Management
- YaST
- autoyast
- CSV
- encryption
- GUI
- JSON
- partitioner
- roles
- snapper
- storage
---

## The Contents

* The [System Role](#a-more-user-friendly-role-selector-dialog) selection dialog got usability improvements
  * and we added a [CustomStatusItemSelector](#when-one-bit-is-not-enough-the-customstatusitemselector) to the widget
    library in the process.

* Snapper gained [machine-readable output](#snapper-and-machine-readable-output)
* Storage:
  * [remote encrypted devices](#fix-boot-problems-with-remote-encrypted-devices) are activated properly at boot
    time
  * [random and pervasive encryption](#autoyast-support-for-random-and-pervasive-encryption) also supported in
    AutoYaST
  * improved support for [AutoYaST Guided Partitioning](#improve-support-for-autoyast-guided-partitioning)

### A More User Friendly Role Selector Dialog

Step by step, we continue improving the user
experience making use of the newly added widgets to libyui. This sprint
was the turn to update the role selection dialog to use the [new item
selector introduced during the sprint 87][1]. Apart from looking better
as it can be seen in the screenshots below, there are two immediate
improvements:

* the vertical scroll, when present, is respected after selecting a role
  (instead of “jumping to the beginning”), and
* the selected role (if any) will be visible when arriving at the dialog
  even when the list is quite long or the available space too short.

| Before | After |
| {% include blog_img.md alt=""
  src="s89-roles2-300x225.png" full_img="s89-roles2.png" %} |

What is more, updating the dialog was also useful for us to realize
about some needed improvements for the widget itself, mentioned in the
next section. Quite a productive [change][2] :smiley:

### When one Bit is not Enough: The CustomStatusItemSelector

A few weeks ago, we wrote about the new
*ItemSelector* widget that is finding its way into YaST user interfaces.
It turned out that just a simple on/off status is not enough in some
cases, so we had to extend that concept. For example, software modules
may have dependencies, and we want to show the difference between one
that was explicitly selected by the user and one that was auto-selected
because some other software module requires it.

{% include blog_img.md alt=""
  src="s89-selector-qt-236x300.png" full_img="s89-selector-qt.png" %}

{% include blog_img.md alt=""
  src="s89-selector-curses-300x215.png" full_img="s89-selector-curses.png" %}

This kind of shook the foundations of the underlying classes; all of a
sudden a bit is no longer just a bit, but it needs to be broken down
into even smaller pieces. Well, we cheated; we now use integer values
instead. Most of the class hierarchy still only uses 0 and 1, but the
new *YCustomStatusItemSelector* also supports using higher numbers for
application-defined purposes.

For each possible status value, the application defines the name of the
icon to be displayed (for graphical UIs like the Qt UI), the text
equivalent (for text mode / the NCurses UI), and an optional
*nextStatus* which tells the widget what status to cycle to when the
user changes the status of an item with a mouse click or with the
keyboard. A value of -1 lets the application handle this.

So this is not a one-trick-pony that is useful only for that one use
case (the software modules), but a generic tool that might find good
uses in other places all over YaST as well.

Usage examples: [C++][3], [Ruby][4].

### Snapper and Machine-readable Output

Most likely you already know [*snapper*][5], a
great tool to work with your filesystem snapshots. Some third-party
scripts and tools (e.g., YaST) use the *snapper* <abbr title="command
line interface">CLI</abbr> to get some information, but generally,
*snapper* generates an output intended to be human-readable. Sometimes
that could cause some troubles in scripts checking the *snapper* output.
Now on, *snapper* also offers CLI options to generate its output in a
machine-readable format, i.e., CSV and JSON. Please, check [this
post][6] for more information about those new options.

### Fix Boot Problems with Remote Encrypted Devices

Since we adopted systemd, the management during
system boot of encrypted devices on top of network-based devices like
[iSCSI][7] or [FCoE][8] disks has been less than optimal. But now we are
happy to announce that we have put all the pieces together to make the
experience as smooth as possible.

One of the main responsibilities of systemd is sorting the actions
performed during boot and setting the dependencies between them. For
example, if there are encrypted devices, systemd will first ask you for
the password and activate the devices to afterwards mount the file
system contained in those encrypted devices. Systemd should be able to
distinguish when an encrypted device is based on a network-based storage
device and, thus, can only be initialized after the network is up. In
some cases that detection failed (for example network block device based
mounts, such as iSCSI and FCoE disks) and systemd got stuck before
initializing the network waiting for the device to be available.

Recently, SLE and openSUSE Leap has incorporated support for specifying
the [`_netdev` option in the `/etc/crypttab` file][9]. With such option,
systemd will recognize the encrypted device as network-based and will
only try to activate it after setting up the network. That’s analogous
to the corresponding `_netdev` option in `/etc/fstab` that has been
already there for quite some time and that can be used to defer when a
device is mounted. For it to work properly, the `_netdev` option must be
present in all the relevant entries of both `crypttab` and `fstab`.

And that’s exactly what YaST will do now in openSUSE Tumbleweed and
upcoming releases of both SLE and openSUSE Leap. From now on, the
`_netdev` option will be added `fstab` for all mount points depending
(directly or indirectly) on the network. In addition, that option (and
also the `noauto` and `nofail` ones) will be propagated from `fstab` to
all the corresponding `crypttab` entries.

This should mark the end of a dark age of encrypted iSCSI and FCoE
devices timing out during boot.

### AutoYaST Support for Random and Pervasive Encryption

Back in October, we announced that [YaST got
support for new encryption methods][10] like random or pervasive
encryption. At that time, AutoYaST was out of scope because we wanted to
have a stable (and tested) API first. Fortunately, the time has come and
now AutoYaST supports these encryption mechanisms.

Starting in autoyast2 4.2.17, you can specify the encryption method
using a `crypt_method` element, as shown in the example below. Possible
values are `luks1` (regular LUKS1 encryption), `pervasive_luks2`
(pervasive volume encryption), `protected_swap` (encryption with
volatile protected key), `secure_swap` (encryption with volatile secure
key) and `random_swap` (encryption with volatile random key).

```xml
<drive>
 <type config:type="symbol">CT_DISK</type>
 <use>all</use>
 <partitions config:type="list">
  <partition>
   <size>20G</size>
   <mount>/</mount>
   <filesystem config:type="symbol">ext4</filesystem>
   <crypt_method config:type="symbol">luks1</crypt_method> <!-- default method if crypt_key is defined -->
   <crypt_key>S3CR3T</crypt_key>
  </partition>
  <partition>
   <size>1G</size>
   <mount>swap</mount>
   <crypt_method config:type="symbol">random_swap</crypt_method> <!-- set encryption method -->
  </partition>
 </partitions>
</drive>
```

As we want AutoYaST to be as user-friendly as possible, it will try to
help you if you do some mistake setting the encryption configuration as
when in the screenshot below.

{% include blog_img.md alt=""
  src="s89-ay-encryption-300x225.png" full_img="s89-ay-encryption.png" %}

Finally, the old `crypt_fs` element is deprecated, although it stills
works for backward-compatibility reasons. Basically, it is equivalent to
setting `crypt_method` to `luks1`.

### Improve Support for AutoYaST Guided Partitioning

When it comes to partitioning, we can categorize
AutoYaST use cases into three different levels:

* Automatic partitioning: the user does not care about the partitioning
  and trusts in AutoYaST to do the right thing.
* Guided partitioning: the user would like to set some basic settings
  (use LVM, set an encryption password, etc.)
* Expert partitioning: the user specifies how the layout should look,
  although a complete definition is not required.

To some extent, it is like using the regular installer where you can
skip the partitioning screen and trust in YaST, use the Guided Proposal,
or define the partitioning layout through the Expert Partitioner.

The second level (Guided partitioning) was introduced in AutoYaST with
the release of SUSE Linux Enteprise 15 (and Leap 15.0) but it was not
documented at all. Additionally, although it was working as designed at
first sight, it was far from being that useful.

This sprint with invested quite some time improving the documentation
(kudos to our awesome documentation team) and the behaviour. Now, if you
want to set up an LVM system without having the specify all the details,
you can use the following snippet in your profile:

```xml
<general>
  <storage>
    <lvm config:type="boolean">true</lvm>
  </storage>
</general>
```

If you are interested in the available options, you can check the
[documentation draft][11].



[1]: {{ site.baseurl }}{% post_url 2019-10-23-highlights-of-yast-development-sprint-87 %}
[2]: https://github.com/yast/yast-installation/pull/827
[3]: https://github.com/libyui/libyui/blob/master/examples/CustomStatusItemSelector1.cc
[4]: https://github.com/yast/yast-ycp-ui-bindings/blob/master/examples/CustomStatusItemSelector1.rb
[5]: http://snapper.io/
[6]: http://snapper.io/2019/11/06/machine-readable-output.html
[7]: https://en.wikipedia.org/wiki/ISCSI
[8]: https://en.wikipedia.org/wiki/Fibre_Channel_over_Ethernet
[9]: https://www.freedesktop.org/software/systemd/man/crypttab.html#_netdev
[10]: {{ site.baseurl }}{% post_url 2019-10-09-advanced-encryption-options-land-in-the-yast-partitioner %}
[11]: https://susedoc.github.io/doc-sle/master/SLES-autoyast/html/configuration.html#CreateProfile-Partitioning
